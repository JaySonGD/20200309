//
//  YHHomeModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/6/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YHHomeModel : NSObject

/**
 *标识
 */
@property (nonatomic, copy)NSString *code;

/**
 *是否有查看权限
 */
@property (nonatomic, copy)NSString *status;


/**
 *是否已购买
 */
@property (nonatomic, assign) BOOL buyStatus;

/**
 *标题
 */
@property (nonatomic, copy)NSString *title;

/**
 *无权限提示语
 */
@property (nonatomic, copy)NSString *msg;
/**
 * 图片名称
 */
@property (nonatomic, copy) NSString *iconName;

/**
 * 新的h5跳转地址
 */
@property (nonatomic, copy) NSString *route_h5;


/**
 * 图片名称
 */
@property (nonatomic, copy) NSString *icon;


/**
 * 展示名称
 */
@property (nonatomic, copy) NSString *name;


@end
