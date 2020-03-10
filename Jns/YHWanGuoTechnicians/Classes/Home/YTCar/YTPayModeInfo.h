//
//  YTPayModeInfo.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 21/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTDiscount : NSObject
@property (nonatomic, copy) NSString *discount_name;
@property (nonatomic, copy) NSString *discount_price;
@end

@interface YTPayMode : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *need_pay_name;
@property (nonatomic, copy) NSString *org_point;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) CGFloat totalHeight;

@property (nonatomic, assign) CGFloat height;

@end


@interface YTPayModeInfo : NSObject

@property (nonatomic, copy) NSString *org_name;
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *org_point;

@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pushSmsStatusMsg;

@property (nonatomic, strong) NSArray <YTPayMode *>*pay_mode;
@property (nonatomic, strong) NSArray <YTDiscount *>*discount_info;

@property (nonatomic, copy) NSString *product_name;

@property (nonatomic, assign) NSUInteger pay_status;

@end

NS_ASSUME_NONNULL_END
