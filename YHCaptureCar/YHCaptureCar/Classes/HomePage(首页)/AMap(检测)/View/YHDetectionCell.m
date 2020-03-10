//
//  YHDetectionCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHDetectionCell.h"

@interface YHDetectionCell()

/**
 预约检测点
 */
@property (weak, nonatomic) IBOutlet UILabel *detectionAddrL;

/**
 检测数量
 */
@property (weak, nonatomic) IBOutlet UILabel *amountL;

/**
 预约时间
 */
@property (weak, nonatomic) IBOutlet UILabel *detectionTimeL;

@end


@implementation YHDetectionCell

-(void)setModel:(YHToBeDetectionModel *)model{
    _model = model;
    self.detectionAddrL.text = model.name;
    self.amountL.text = [NSString stringWithFormat:@"%d",model.amount];
    self.detectionTimeL.text = //model.bookDate;// [model.bookDate substringToIndex:10];
    [NSString stringWithFormat:@"%@-%@",[model.bookDate substringToIndex:16],[model.arrivalEndTime substringWithRange:NSMakeRange(11, 5)]];

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
