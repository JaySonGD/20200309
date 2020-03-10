//
//  PCAccountController.h
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PCAccountController : YHBaseViewController
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, weak) UIViewController *sourceVC;
@property (nonatomic, weak) UIViewController *observer;
@end

NS_ASSUME_NONNULL_END
