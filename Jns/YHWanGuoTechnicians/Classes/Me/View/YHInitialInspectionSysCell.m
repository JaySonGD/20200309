//
//  YHInitialInspectionSysCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHInitialInspectionSysCell.h"
#import "YHTools.h"
#import "YHCommon.h"
@interface YHInitialInspectionSysCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *ttileL;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIG;

@end

@implementation YHInitialInspectionSysCell

- (void)loadDatasoure:(NSDictionary*)info isDataFilled:(BOOL)isDataFiled{
    NSArray *sysInfoDesc = [YHTools sysProjectByKey:info[@"sysClassId"]];
    [_imageV setImage:[UIImage imageNamed:((isDataFiled) ? (sysInfoDesc[2]) : (sysInfoDesc[1]))]];
    [_arrowIG setImage:[UIImage imageNamed:((isDataFiled) ? (@"me_59") : (@"home_4"))]];
    [_ttileL setText:sysInfoDesc[0]];
    _ttileL.textColor =  ((isDataFiled) ? (YHNaviColor) : (YHCellColor));

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
