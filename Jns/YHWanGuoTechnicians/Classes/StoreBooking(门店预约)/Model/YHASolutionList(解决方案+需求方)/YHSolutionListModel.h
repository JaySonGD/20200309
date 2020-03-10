//
//  YHSolutionListModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "billTypeDataModel.h"
#import "YHBillTypeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHSolutionListModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *billStatus;
@property (nonatomic, copy)NSString *billType;
@property (nonatomic, copy)NSString *creationTime;
@property (nonatomic, copy)NSString *appointmentDate;
@property (nonatomic, copy)NSString *plateNumberAll;
@property (nonatomic, copy)NSString *handleType;
@property (nonatomic, copy)NSString *nowStatusCode;
@property (nonatomic, copy)NSString *nextStatusCode;
@property (nonatomic, copy)NSString *nowStatusName;
@property (nonatomic, copy)NSString *carBrandLogo;
@property (nonatomic, copy)NSString *techNickname;
//@property (nonatomic, strong)NSMutableArray <billTypeDataModel *>*billTypeData;
@property (nonatomic, strong)NSMutableArray <YHBillTypeDataModel *>*billTypeData;

//需求方未完成、已完成独有
@property (nonatomic, copy)NSString *shopName;
@property (nonatomic, copy)NSString *vin;

@end

NS_ASSUME_NONNULL_END
