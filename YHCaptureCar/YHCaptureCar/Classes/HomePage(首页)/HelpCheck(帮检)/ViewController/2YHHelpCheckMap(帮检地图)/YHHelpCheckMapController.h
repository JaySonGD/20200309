//
//  YHHelpCheckMapController.h
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"
@class YHReservationModel;
@interface YHHelpCheckMapController : YHBaseViewController
@property (nonatomic, copy) void (^chooseAddr)(YHReservationModel *);
@end
