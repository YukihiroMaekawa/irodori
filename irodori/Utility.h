//
//  Utility.h
//  irodori
//
//  Created by 前川 幸広 on 2014/08/31.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

//メソッド定義
- (void) saveData :(NSString*) newScore;
- (void) loadData;
-(BOOL)isLocaleJapanese;

//スコア1から5
@property(nonatomic) NSMutableArray *arrScore;

@property(nonatomic) int scoreLv;
@end
