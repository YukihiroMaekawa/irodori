//
//  Sns.h
//  irodori
//
//  Created by 前川 幸広 on 2014/10/25.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>

@interface Sns : NSObject
//メソッド定義
- (UIViewController *) doPostFacebook :(NSString*) UrlString :(NSString*) TextString ;
- (UIViewController *) doPostTwitter :(NSString*) UrlString :(NSString*) TextString ;

@end
