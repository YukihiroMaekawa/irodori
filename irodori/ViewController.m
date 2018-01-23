//
//  ViewController.m
//  irodori
//
//  Created by 前川 幸広 on 2014/08/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewController.h"
#import "Utility.h"
#import <GameKit/GameKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sns
    _sns = [[Sns alloc ] init];
    
    //広告設定
    [self nendAdIcon];

	// Do any additional setup after loading the view, typically from a nib.
    
    // (2) NADView の作成
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 520, 320, 50)];
    // (3) ログ出力の指定 [self.nadView setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadView setNendID:@"f27d72e8fca3d43303c315ef53149a706300135b" spotID:@"149562"];
    [self.nadView setDelegate:self]; //(5) [self.nadView load]; //(6)
    [self.view addSubview:self.nadView]; // 最初から表示する場合
    [self.nadView setDelegate:self];
    
    //広告表示
    [self.nadView load];
    
    //ボタンの枠
    UIColor *color = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];

    [[self.btnStart layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnStart layer] setBorderWidth:1.0];
    [[self.btnStart layer] setCornerRadius:15.0];
    [self.btnStart setClipsToBounds:YES];
    [self.btnStart setBackgroundColor:color];

    [[self.lblBtnStart layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.lblBtnStart layer] setBorderWidth:1.0];
    [[self.lblBtnStart layer] setCornerRadius:15.0];
    [self.lblBtnStart setClipsToBounds:YES];
    [self.lblBtnStart setBackgroundColor:color];

    [[self.lblBtnSns layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.lblBtnSns layer] setBorderWidth:1.0];
    [[self.lblBtnSns layer] setCornerRadius:15.0];
    [self.lblBtnSns setClipsToBounds:YES];
    [self.lblBtnSns setBackgroundColor:[UIColor orangeColor]];

    
    //スコアラベル
    [[self.lblScore1 layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.lblScore1 layer] setBorderWidth:1.0];
    [[self.lblScore1 layer] setBorderWidth:1.0];
    [[self.lblScore1 layer] setCornerRadius:15.0];
    
    // ゲームセンターログイン
    [self authenticateLocalPlayer];
}

- (void) nendAdIcon{
    // NADIconView クラスの生成
    _iconView = [[NADIconView alloc] initWithFrame:CGRectMake(0, 25, 75, 75)]; // NADIconView の配置
    [self.view addSubview:_iconView];
    
    _iconView2 = [[NADIconView alloc] initWithFrame:CGRectMake(80, 25, 75, 75)]; // NADIconView の配置
    [self.view addSubview:_iconView2];
    
    _iconView3 = [[NADIconView alloc] initWithFrame:CGRectMake(160, 25, 75, 75)]; // NADIconView の配置
    [self.view addSubview:_iconView3];
    
    _iconView4 = [[NADIconView alloc] initWithFrame:CGRectMake(240, 25, 75, 75)]; // NADIconView の配置
    [self.view addSubview:_iconView4];

    // NADIconLoader クラスの生成
    _iconLoader = [[NADIconLoader alloc] init];
    // ログ出力の指定
    [_iconLoader setIsOutputLog:YES];
    // NADIconLoader へ NADIconView を追加
    [_iconLoader addIconView:_iconView];
    [_iconLoader addIconView:_iconView2];
    [_iconLoader addIconView:_iconView3];
    [_iconLoader addIconView:_iconView4];
    
    // API キーと SPOTID を設定
    [_iconLoader setNendID:@"905b677c78d634eb2841da927c3dded43b564706"
                   spotID:@"226947"]; // デリゲートオブジェクトの設定
    [_iconLoader setDelegate:self];
    
    // 広告のロード
    [_iconLoader load];
}

-(void)nadIconLoaderDidFinishLoad:(NADIconLoader *)iconLoader{
    NSLog(@"delegate nadIconLoaderDidFinishLoad:");
}

- (void)viewWillDisappear:(BOOL)animated {
    [_iconLoader pause];
    [self.nadView pause];
}

- (void)viewWillAppear:(BOOL)animated {
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    
    //スコア読み込み
    Utility *utility = [[Utility alloc] init];
    [utility loadData];
    
    NSString *score = @"";
    NSString *scoreBest = @"";

    int idx = 0;
    for(NSString *data in utility.arrScore){
        idx++;
        if(idx ==1){
            scoreBest = data;
        }

        score = [NSString stringWithFormat:@"%@\n%d  %@" ,score, idx,data];
    }

    self.lblScore1.numberOfLines = 0;
    self.lblScore1.text = score;
    [self.lblScore1 sizeToFit];
    
    //広告表示
//    [[NADInterstitial sharedInstance] showAd];
    
    [_iconLoader resume];
    [self.nadView resume];

    _urlString  = @"https://itunes.apple.com/jp/app/irodori-pazuru-jian-weietara/id914345348?mt=8";
    _textString = [NSString stringWithFormat:@"Best Score %@",scoreBest];

    if([utility isLocaleJapanese]){
        //日本語
        _textString = [NSString stringWithFormat:@"%@　イロドリ 無料のパズルゲームでスコアを競いましょう。" ,_textString];
    }else{
        //日本語以外
        _textString = [NSString stringWithFormat:@"%@ Irodori Let's compete the score with a free puzzle game." ,_textString];
    }
}

/**
 * GameCenterにログインしているか確認処理
 * ログインしていなければログイン画面を表示
 */
- (void)authenticateLocalPlayer
{
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* ui, NSError* error )
    {
        if( nil != ui )
        {
            [self presentViewController:ui animated:YES completion:nil];
        }
        
    };
}

/**
 * ランキングボタンタップ時の処理
 * リーダーボードを表示
 */
/*
 */

/**
 * リーダーボードで完了タップ時の処理
 * 前の画面に戻る
 */
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRanking:(id)sender {
    GKGameCenterViewController *gcView = [GKGameCenterViewController new];
    if (gcView != nil)
    {
        gcView.gameCenterDelegate = self;
        gcView.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gcView animated:YES completion:nil];
    }
}

- (IBAction)btnSns:(id)sender {
    // アクションシート例文
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"SNS";
    [as addButtonWithTitle:@"Facebook"];
    [as addButtonWithTitle:@"Twitter"];
    [as addButtonWithTitle:@"Cancel"];
    as.cancelButtonIndex = 2;
//    as.destructiveButtonIndex = 0;
    [as showInView:self.view];  // ※下記参照
}

-(void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            // Facebook ボタンが押された場合
            [self presentViewController:[_sns doPostFacebook:_urlString :_textString] animated:YES completion:nil];
            break;
        case 1:
            // Twitter ボタンが押された場合
            [self presentViewController:[_sns doPostTwitter:_urlString :_textString] animated:YES completion:nil];
            break;
        case 2:
            // ３番目のボタンが押されたときの処理を記述する
            break;
    }
    
}
@end
