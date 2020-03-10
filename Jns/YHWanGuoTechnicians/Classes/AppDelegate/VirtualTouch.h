//
//  VirtualButton.m
//  DemoSuspendBtn
//
//  Created by zhang on 2017/5/19.
//  Copyright © 2017年 爱贝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualTouch : UIView

@property (nonatomic, copy) void(^tapBlock)(VirtualTouch *button);

- (id)initInKeyWindowWithFrame:(CGRect)frame;

+ (void)removeAllFromKeyWindow;

@end
