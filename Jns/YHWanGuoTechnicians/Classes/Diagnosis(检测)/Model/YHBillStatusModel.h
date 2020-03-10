//
//  YHBillStatusModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 检测工单模型
 */
@interface YHBillStatusModel : NSObject

@property (nonatomic, copy)NSString *billId;            //工单ID
@property (nonatomic, copy)NSString *billType;         //工单类型
@property (nonatomic, copy)NSString *handleType;       //处理类型
@property (nonatomic, copy)NSString *nextStatusCode;   //下一步状态
@property (nonatomic, copy)NSString *nowStatusCode;    //当前状态

@end
