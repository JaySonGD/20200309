//
//  YHWorkbordRecordCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/27.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkbordRecordCell.h"
#import "YHCommon.h"
@interface YHWorkbordRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *delB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailWidthLC;
@end
@implementation YHWorkbordRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _detailWidthLC.constant = screenWidth - 75;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loaddataSource:(NSDictionary*)info index:(NSInteger)index{
    _nameL.text = info[@"realname"];
    _dateL.text = info[@"addTime"];
    _detailL.text = info[@"result"];
    NSNumber *authDel = info[@"authDel"];
    _delB.hidden = !(authDel.boolValue);
    _delB.tag = index;
}
@end
