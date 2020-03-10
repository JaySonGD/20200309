//
//  YHCarVersionVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  车辆版本控制器

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
@interface YHCarVersionVC : YHBaseViewController

/**
 VIN码
 */
@property(nonatomic,copy)NSString *vinStr;

@property(nonatomic,assign)int bucheBookingId; //捕车ID

@end


/*
     return [self.carVersionArray count]?1:0;
 解决Cell数据与视图无法进行分离拿不到数据的问题;

 */
