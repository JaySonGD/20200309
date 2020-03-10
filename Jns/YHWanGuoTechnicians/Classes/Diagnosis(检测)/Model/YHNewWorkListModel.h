//
//  YHNewWorkListModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHNewWorkListModel : NSObject

/*    返回
 {
 "code": 20000,
 "msg":"success",
 "billStatus":{
 "billId":1,
 "nowStatusCode":"consulting",
 "nextStatusCode":"initialSurvey",
 "handleType":"handle",
 }
 }
 */

@property (nonatomic, copy)NSString *billId;              //工单ID
@property (nonatomic, copy)NSString *nowStatusCode;       //当前状态码
@property (nonatomic, copy)NSString *nextStatusCode;      //下一步状态码
@property (nonatomic, copy)NSString *handleType;          //处理类型

@end
