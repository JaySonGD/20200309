//
//  AAPlayer.h
//  player
//
//  Created by xin on 2019/6/23.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AAPlayer : UIView
+ (instancetype)player;
- (void)playWithURL:(NSString *)url
          backTitle:(NSString *)title;
@end


@interface UIView (Player)

- (UIViewController *)viewController;
- (UIViewController *)topViewController;

@end


@interface UIViewController (Player)
@property (nonatomic, assign) UIStatusBarStyle ddStatusBarStyle;
@property (nonatomic, assign) BOOL ddStatusBarHidden;
@property (nonatomic, assign) BOOL ddHomeIndicatorAutoHidden;
@end


