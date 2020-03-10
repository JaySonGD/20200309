//
//  YHReservationVC.h
//  YHCaptureCar
//
//  Created by liusong on 2018/1/18.
//  Copyright © 2018年 YH. All rights reserved.
// 预约弹框控制器

#import <UIKit/UIKit.h>
#import "MYPresentedController.h"
#import "YHReservationModel.h"

@class YHReservationVC;

@protocol YHReservationVCDelegate<NSObject>
    
/**
 进行新增预约控制器
 */
-(void)pushToNewReservationVCWithReserM:(YHReservationModel*)reservationM;

@end

/**
 预约控制器
 */
@interface YHReservationVC : MYPresentedController

@property (weak, nonatomic) id <YHReservationVCDelegate>delegate;

@property(nonatomic,strong)YHReservationModel *reservationM;

@end
