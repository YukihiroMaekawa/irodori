//
//  ViewController.h
//  irodori
//
//  Created by 前川 幸広 on 2014/08/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"
#import "NADIconLoader.h"
#import "NADInterstitial.h"
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import "Sns.h"

@interface ViewController : UIViewController <NADViewDelegate ,NADIconLoaderDelegate ,UIActionSheetDelegate,GKGameCenterControllerDelegate>
{
    NADIconLoader* _iconLoader;
    NADIconView* _iconView;
    NADIconView* _iconView2;
    NADIconView* _iconView3;
    NADIconView* _iconView4;
    Sns *_sns;
    
    NSString *_urlString;
    NSString *_textString;
}

@property (nonatomic, retain) NADView * nadView;
@property (weak, nonatomic) IBOutlet UILabel *lblScore1;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
- (IBAction)btnRanking:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lblBtnStart;
- (IBAction)btnSns:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lblBtnSns;

@end
