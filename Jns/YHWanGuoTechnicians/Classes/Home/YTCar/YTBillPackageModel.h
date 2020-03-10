//
//  YTBillPackageModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 9/10/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YTSystemPackageModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *level;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL is_check;
//@property (nonatomic, assign) BOOL is_accept;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSMutableArray <YTSystemPackageModel *> *child_system;
@end



@interface YTBillPackageModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
//@property (nonatomic, copy) NSString *b_title;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *warranty_desc;
//@property (nonatomic, copy) NSString *valid_time_name;
//@property (nonatomic, copy) NSString *valid_time;
//@property (nonatomic, copy) NSString *quality_km;
//@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) BOOL is_edit_price;
@property (nonatomic, assign) BOOL is_check;
//@property (nonatomic, assign) BOOL is_accept;
//@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) NSInteger status;




@property (nonatomic, copy) NSString *sales_price;
@property (nonatomic, strong) NSMutableArray <YTSystemPackageModel *> *system_list;
@property (nonatomic, assign) NSInteger limit_count;
@end

@interface YTInsuranceInfoModel : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL check;
@end



@interface YTPackageModel : NSObject
@property (nonatomic, strong) NSMutableArray <YTBillPackageModel *>*list;
@property (nonatomic, strong) YTInsuranceInfoModel *insurance_info;
@end

@interface YTTimerModel : NSObject//定时器model
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@end


NS_ASSUME_NONNULL_END
