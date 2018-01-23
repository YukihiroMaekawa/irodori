//
//  ViewControllerPlay.m
//  irodori
//
//  Created by 前川 幸広 on 2014/08/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerPlay.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"

#define ARC4RANDOM_MAX      0x100000000

@interface ViewControllerPlay ()

@end

@implementation ViewControllerPlay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    NSLog(@"%.1f, %.1f", rect.size.width, rect.size.height);
    
    isSmallScreen = NO;
    if(rect.size.height == 480){
        isSmallScreen = YES;
    }
    
    _anserColor    = [[NSMutableArray alloc] init];
    _questionColor = [[NSMutableArray alloc] init];
    _anserTag      = [[NSMutableArray alloc] init];
    
    // 線を引く
    // 線幅
    CGFloat wide = 1.0f / [UIScreen mainScreen].scale;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, wide)];
    [self.view addSubview:view];
    
    //サウンド設定
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    _soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("ok"),CFSTR ("mp3"),NULL);
    AudioServicesCreateSystemSoundID (_soundURL, & _soundID);
    CFRelease (_soundURL);

    CFBundleRef mainBundle2;
    mainBundle2 = CFBundleGetMainBundle ();
    _soundURL2  = CFBundleCopyResourceURL (mainBundle2,CFSTR ("ng"),CFSTR ("mp3"),NULL);
    AudioServicesCreateSystemSoundID (_soundURL2, & _soundID2);
    CFRelease (_soundURL2);

    [self startGame];
}

- (void)startGame{

    // ラベルを生成する
    [self createLabel];
    
    //
    _ansOkCnt         = 0;
    self.lblTime.text = @"00:00.000";
    _stTime = [NSDate date];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(0.001)
                                              target:self selector:@selector(onTimer:)
                                            userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)onTimer:(NSTimer*)timer {
    NSTimeInterval dateDiff = [[NSDate date] timeIntervalSinceDate:_stTime];
    _gameScore = dateDiff;
    int hour   = dateDiff / (60 * 60);
    int minute = fmod((dateDiff / 60) ,60);
    int second = fmod(dateDiff ,60);
    //int miliSec = (dateDiff - floor(dateDiff)) * 1000;
    int miliSec = (dateDiff - floor(dateDiff)) * 100;
    self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d",hour,minute,second,miliSec];
    
    
    _gameScore = [NSString stringWithFormat:@"%d.%d" ,((hour * 3600) + (minute * 60) + second) ,miliSec].doubleValue * 100;
}

- (void)createLabel{
    UILabel* label;
    int width = 50 ,height = 50;
    double margin  = 7.5f;
    double marginY = 7.5f;
    int xSt = 19 ,ySt = 120;

    // 3.5Inch用
    if(isSmallScreen){
        ySt     = 113;
        marginY = 2.25f;
    }
    
    // 色問題(5つ)
    for (int x=0; x<=4; x++){
        label= [[UILabel alloc] init];
        label.userInteractionEnabled = false;
        label.frame = CGRectMake(xSt + ((width + margin) * x) ,47 ,width, height);
        label.tag = 101 + x;
        label.textAlignment = NSTextAlignmentCenter;

        // 色をランダムで生成
        NSString *red   = [self getColor];
        NSString *green = [self getColor];
        NSString *blue  = [self getColor];
        
        // 問題の色を格納しておく
        [_questionColor addObject:[NSString stringWithFormat:@"%@,%@,%@",red,green,blue]];
        label.backgroundColor = [UIColor colorWithRed:red.doubleValue
                                                green:green.doubleValue
                                                 blue:blue.doubleValue
                                                alpha:1.000];
        [[label layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[label layer] setBorderWidth:1.0];
        [self.view addSubview:label];
    }

    // 選択ラベル
    int anserIdx = 0;
    NSMutableArray *anserIdxArr = [[NSMutableArray alloc] init];
    for (int y=0; y<=6; y++){
        for (int x=0; x<=4; x++){
            label = [[UILabel alloc] init];
            label.userInteractionEnabled = true;
            label.frame = CGRectMake(xSt + ((width + margin) * x) ,ySt + ((height + marginY) * y), width, height);
            label.tag = y * 5 + x + 1;
            
            // 色を生成
            NSString *red   = @"0.0";
            NSString *green = @"0.0";
            NSString *blue  = @"0.0";
            
            // 7の倍数時は回答の色を設定する
            if(anserIdx < 5
               &&
                (
                  (35 - anserIdx <= label.tag)
               || (arc4random() % 100 + 1) % 7 == 0
               )
            ){
                // 5種類の回答をランダムでピックアップ (0から4)
                int selectedIdx = 0;
                BOOL isBreak;
                while (YES){
                    isBreak = YES;
                    selectedIdx = (arc4random() % 5);
                    
                    for (NSString *data in anserIdxArr){
                        if(data.intValue == selectedIdx){
                            // すでに登録した回答の場合はもう一度やりなおし
                            isBreak = NO;
                            break;
                        }
                    }
                    if(isBreak){break;}
                }
                //
                NSString *color = [_questionColor objectAtIndex:selectedIdx];
                NSArray *colorArr = [color componentsSeparatedByString:@","];
                red   = [NSString stringWithFormat:@"%@" ,colorArr[0]];
                green = [NSString stringWithFormat:@"%@" ,colorArr[1]];
                blue  = [NSString stringWithFormat:@"%@" ,colorArr[2]];
                [anserIdxArr addObject:[NSString stringWithFormat:@"%d",selectedIdx]];
                anserIdx++;
            }else{
                // １色だけ変えて、回答と同じ色を作成しないようにする
                while(YES){
                    BOOL isBreak = YES;
                    // 新しい色を生成する(回答と同じ色は使わない)
                    red   = [self getColor];
                    green = [self getColor];
                    blue  = [self getColor];
                    NSString *colorAnser = [NSString stringWithFormat:@"%@,%@,%@",red,green,blue];

                    // 回答のカラーと同一の場合は色を変える(ランダム関数で出現したidxの色を変える)
                    int idx = (arc4random() % 3 + 1) % 3; // 1から3の数値を3で割ったあまり
                    for (NSString *colorQuestion in _questionColor) {
                        // 配列から問題を取得(red ,green ,blueをカンマで格納してある)
                        NSArray *colorArr    = [colorQuestion componentsSeparatedByString:@","];
                        NSArray *colorNewArr = [colorAnser    componentsSeparatedByString:@","];
                        
                        if([NSString stringWithFormat:@"%@" ,colorArr[idx]].doubleValue ==
                           [NSString stringWithFormat:@"%@" ,colorNewArr[idx]].doubleValue)
                        {
                            isBreak = NO;
                            break;
                        }
                    }
                    if(isBreak == YES){break;}
                }
            }
            [_anserColor addObject:[NSString stringWithFormat:@"%@,%@,%@",red,green,blue]];
            label.backgroundColor = [UIColor colorWithRed:red.doubleValue
                                                    green:green.doubleValue
                                                     blue:blue.doubleValue
                                                    alpha:1.000];
            [[label layer] setBorderColor:[[UIColor whiteColor] CGColor]];
            [[label layer] setBorderWidth:1.0];
            [self.view addSubview:label];
        }
    }
}

- (NSString *) getColor{
    double a = 0.0f;
    double b = 1.0f;
    return [NSString stringWithFormat:@"%.2f" ,((b-a)*((double)arc4random()/ARC4RANDOM_MAX))+a];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // 回答をチェック
    [self checkAnser:touch.view.tag];
}

-(void)checkAnser:(long)tag{
    if(tag == 0){
        return;
    }
    
    // 回答済タグは処理しない
    for(NSString *data in _anserTag){
        if (data.longLongValue == tag){
            return;
        }
    }
    
    NSInteger idx = tag - 1;
    NSString *anser = [_anserColor objectAtIndex:idx];
    bool isAnserOK = NO;
    long questionTag = 101;
    for (NSString *colorQuestion in _questionColor) {
        if([anser isEqual:colorQuestion]){
            UILabel* label = (UILabel*) [self.view viewWithTag:questionTag];
            label.text = @"Clear";
            isAnserOK = YES;
            _ansOkCnt ++;
            [_anserTag addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
            self.lblClear.text = [NSString stringWithFormat:@"%d / 5" ,_ansOkCnt];

            
            break;
        }
        questionTag++;
    }
    
    if (isAnserOK){
        AudioServicesPlaySystemSound (_soundID);
    }
    else{
        AudioServicesPlaySystemSound (_soundID2);
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Game Over"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil
                              ];
        alert.delegate = self;
        [alert show];
    }
    
    if(_ansOkCnt == 5){
        // タイマー停止
        [_timer invalidate];
        
        // スコアを保存する
        Utility *utility = [[Utility alloc] init];
        NSLog(@"%@",self.lblTime.text);
        
        [utility saveData:self.lblTime.text];
        
        // 生成と同時に各種設定も完了させる例
        //ランクインしたかどうか
        if ((arc4random() % 5 + 1) % 5 == 0) {
            //広告表示
            [[NADInterstitial sharedInstance] showAd];
        }
        
        // GameCenter スコア送信
        if ([GKLocalPlayer localPlayer].isAuthenticated) {
            GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Stage1"];
            score.value = _gameScore;
            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                if (error) {
                    // エラーの場合
                }
            }];
        }
        
        NSString *scoreStr;
        if(utility.scoreLv > 0){
            scoreStr = [NSString stringWithFormat:@"BEST %d\n%@" ,utility.scoreLv,self.lblTime.text];
        }else{
            scoreStr = [NSString stringWithFormat:@"%@" ,self.lblTime.text];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Stage Clear"
                              message:scoreStr
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil
                              ];
        alert.delegate = self;
        [alert show];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonInde{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
