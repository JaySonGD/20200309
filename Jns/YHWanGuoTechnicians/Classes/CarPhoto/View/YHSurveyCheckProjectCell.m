//
//  YHSurveyCheckProjectCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSurveyCheckProjectCell.h"

#import "YHCheckProjectModel.h"

#import "YHCommon.h"

@interface YHSurveyCheckProjectCell()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

@implementation YHSurveyCheckProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YHSurveyCheckProjectModel *)model
{
    _model = model;
    
    self.nameLB.text = model.name;
    
    self.statusLB.hidden = !model.isFinish;
    self.statusBtn.selected = model.isFinish;
    if(model.isFinish){
        [self.iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-蓝",model.name]] forState:UIControlStateNormal];
        self.nameLB.textColor = YHNaviColor;

    }else{
        [self.iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-黑",model.name]] forState:UIControlStateNormal];
        self.nameLB.textColor = YHColorWithHex(0x3A3A3A);

    }
    
    if ([model.name isEqualToString:@"基本信息"]) {
        self.statusLB.text = @"已完成";
    }else{
        self.statusLB.text = @"已检测";
    }
    
}

@end
