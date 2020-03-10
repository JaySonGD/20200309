//
//  YHDiagnosisOrderModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHDiagnosisOrderModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;
/** 是否显示SegamentContrroll控件 */
@property (nonatomic, assign) BOOL isShowSegamentContrroll;

@end
