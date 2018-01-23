//
//  Utility.m
//  irodori
//
//  Created by 前川 幸広 on 2014/08/31.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Utility.h"

@implementation Utility

- (void) saveData :(NSString*) newScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 読み込み
    NSDictionary *dictLoad = [defaults objectForKey:@"scoreData"];
    NSMutableDictionary *dictLoadData = [dictLoad mutableCopy];

    // 新レコード
    // ディクショナリに要素を追加する
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:newScore];
    for (NSString *key in [dictLoadData allKeys]) {
        NSLog(@"%@",[dictLoadData objectForKey:key]);
        [array addObject:[dictLoadData objectForKey:key]];
    }
    
    // 配列をソート
    NSArray *sortArr = [array sortedArrayUsingSelector:@selector(compare:)];
    
    // 保存用 (上位ランキング5つのみ保存)
    NSMutableDictionary *dictSave = [NSMutableDictionary dictionary];
    int idx = 0;
    self.scoreLv = 0;
    for(NSString *data in sortArr){
        idx++;
        [dictSave setObject:data forKey:[NSString stringWithFormat:@"%03d",idx]];
        
        if([newScore isEqual:data]){
            self.scoreLv = idx;
        }
        if (idx == 5){break;}
    }
    
    // 保存
    [defaults setObject:dictSave forKey:@"scoreData"];
}

- (void) loadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 読み込み
    NSDictionary *dictLoad = [defaults objectForKey:@"scoreData"];
    NSMutableDictionary *dictLoadData = [dictLoad mutableCopy];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.arrScore = [[NSMutableArray alloc]init];
    for(NSString *key in [dictLoadData allKeys]){
        [array addObject:[dictLoadData objectForKey:key]];
    }
    // 配列をソート
    NSArray *sortArr = [array sortedArrayUsingSelector:@selector(compare:)];

    self.arrScore = [NSMutableArray arrayWithArray:sortArr];
}

// 日本語かどうか判定
-(BOOL)isLocaleJapanese{
    //まず言語のリストを取得します。
    NSArray *languages = [NSLocale preferredLanguages];
    // 取得したリストの0番目に、現在選択されている言語の言語コード(日本語なら”ja”)が格納されるので、NSStringに格納します。
    NSString *languageID = [languages objectAtIndex:0];
    
    // 日本語の場合はYESを返す
    if ([languageID isEqualToString:@"ja"]) {
        return YES;
    }
    
    // 日本語の以外はNO
    return NO;
}
@end
