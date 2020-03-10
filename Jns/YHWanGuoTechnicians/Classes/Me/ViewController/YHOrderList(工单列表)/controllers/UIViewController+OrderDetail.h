//
//  UIViewController+OrderDetail.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 19/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHFunctionsEditerController.h"

@interface UIViewController (OrderDetail)
- (void)showImageByCode:(NSString*)code
             hasNeedBuy:(BOOL)needBuy  with:(BOOL)isHome;
- (void)showImageByCode:(NSString*)code;
- (void)orderDetailNavi:(NSDictionary*)orderInfo code:(YHFunctionId)functionKey;
@end
