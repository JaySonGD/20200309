//
//  YHCheckListDetailCell0.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckListDetailCell0.h"

@implementation YHCheckListDetailCell0

- (void)refreshUIWithModel:(YHCheckListDetailModel0 *)model WithTag:(NSInteger)tag WithType:(NSInteger)type
{
    self.cellView.layer.cornerRadius = 10;
    self.cellView.layer.masksToBounds = YES;
    self.carBrandLogoI.image = [UIImage imageNamed:model.carBrandLogo];
    self.skilledWorkerL.text = model.skilledWorker;
    self.carModelFullNameL.text = model.carModelFullName;
    self.vinL.text = model.vin;
    
    if (tag == 1) {
        self.timeRemindL.text = @"开始时间";
        self.timeL.text = model.creationTime;
        self.goImageView.hidden = YES;
    } else {
        self.timeRemindL.text = @"结束时间";
        self.timeL.text = model.endTime;
        
//        //1-代售检测分类,2-二手车帮检分类
//        if (type == 1) {
//            self.goImageView.hidden = NO;
//        } else if (type == 2){
//            self.goImageView.hidden = YES;
//        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
