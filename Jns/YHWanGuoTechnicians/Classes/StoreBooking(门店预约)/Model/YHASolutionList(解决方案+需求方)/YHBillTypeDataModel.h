//
//  YHBillTypeDataModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/27.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHBillTypeDataModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *billType;
@property (nonatomic, copy)NSString *billTypeName;
@property (nonatomic, copy)NSString *nowStatusCode;
@property (nonatomic, copy)NSString *nextStatusCode;
@property (nonatomic, copy)NSString *handleType;

@end

NS_ASSUME_NONNULL_END
