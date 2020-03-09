//
//  UIView+Loading.h
//  HKV
//
//  Created by Jay on 25/11/2019.
//  Copyright © 2019 Jayson. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Loading)
- (void)showLoading:(NSString *)message;

- (void)hideLoading:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
