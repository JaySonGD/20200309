//
//  YHAppointmentArriveTimeView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/10/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAppointmentArriveTimeView.h"



@implementation YHAppointmentArriveTimeView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)selectArriveShopTime:(UIButton *)sender {

    if (_selectArriveTime) {
        _selectArriveTime();
    }
}

@end
