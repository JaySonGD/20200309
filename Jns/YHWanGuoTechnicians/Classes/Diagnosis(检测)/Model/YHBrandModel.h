//
//  YHBrandModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
品牌列表
 */
@interface YHBrandModel : NSObject

@property (nonatomic,copy)NSString *brandId;            //品牌ID
@property (nonatomic, copy)NSString *brandName;         //品牌名称
@property (nonatomic, copy)NSString *icoName;           //图片名称
@property (nonatomic, copy)NSString *initial;           //索引字段

@end
