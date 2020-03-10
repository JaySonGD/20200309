//
//  YTWarranty.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 4/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTWarranty : NSObject

@property (nonatomic, copy) NSString *system_id;
@property (nonatomic, assign) BOOL check;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *guide_price;
@property (nonatomic, copy) NSString *system_name;
@property (nonatomic, strong) NSArray <YTWarranty *>*child_system;

@end


@interface YTExtended : NSObject

@property (nonatomic, copy) NSString *ssss_price;

@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *system_total_price;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *detection_price;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL check;

@property (nonatomic, strong) NSArray <YTWarranty *>*extended_warranty;

@end



NS_ASSUME_NONNULL_END
