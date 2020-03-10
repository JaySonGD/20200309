//
//  YHAppointmentArriveTimeView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/10/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAppointmentArriveTimeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *arriveShopTimeL;

@property (nonatomic, copy) void(^selectArriveTime)(void);


@end
