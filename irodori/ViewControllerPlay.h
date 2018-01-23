//
//  ViewControllerPlay.h
//  irodori
//
//  Created by 前川 幸広 on 2014/08/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <GameKit/GameKit.h>
#import "NADInterstitial.h"

@interface ViewControllerPlay : UIViewController
{
    BOOL             isSmallScreen;
    NSTimer        * _timer;
    NSDate         * _stTime;
    int _ansOkCnt;
    NSMutableArray * _anserColor;
    NSMutableArray * _questionColor;
    NSMutableArray * _anserTag; // 回答済みのtag
    int _gameScore;
    
    CFURLRef _soundURL;
    SystemSoundID _soundID;
    CFURLRef _soundURL2;
    SystemSoundID _soundID2;

}
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblClear;

@end
