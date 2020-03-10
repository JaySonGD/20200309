//
//  UIViewController+sucessJump.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (sucessJump)

@property (nonatomic, strong) NSTimer *successTimer;

@property (nonatomic, assign) NSInteger totalTimes;

- (void)submitDataSuccessToJump:(NSDictionary *)orderInfo pay:(BOOL)isPay message:(NSString *)message;

@end
