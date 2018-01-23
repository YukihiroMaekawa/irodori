//
//  Sns.m
//  irodori
//
//  Created by 前川 幸広 on 2014/10/25.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Sns.h"

@implementation Sns

// Facebookに投稿
- (UIViewController *) doPostFacebook :(NSString*) UrlString :(NSString*) TextString{
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString* postContent = [NSString stringWithFormat:@"%@",TextString];
    [facebookPostVC setInitialText:postContent];
    // URL文字列
    [facebookPostVC addURL:[NSURL URLWithString:UrlString]];
    // Image
    //[facebookPostVC addImage:[UIImage imageNamed:@"image_name_string"]]; // 画像名（文字列）
    return facebookPostVC;
}

// Twitterに投稿
- (UIViewController *) doPostTwitter :(NSString*) UrlString :(NSString*) TextString{
    NSString* postContent = [NSString stringWithFormat:@"%@",TextString];
    NSURL* appURL = [NSURL URLWithString:UrlString];
    
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [twitterPostVC setInitialText:postContent];
    [twitterPostVC addURL:appURL]; // アプリURL

    return twitterPostVC;
    
    //[self presentViewController:twitterPostVC animated:YES completion:nil];
}

@end
