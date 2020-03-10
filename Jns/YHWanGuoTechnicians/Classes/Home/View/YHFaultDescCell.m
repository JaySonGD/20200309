//
//  YHFaultDescCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/21.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHFaultDescCell.h"
@interface YHFaultDescCell  ()
@property (weak, nonatomic) IBOutlet UILabel *descL;

@end
@implementation YHFaultDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSString*)info{
    _descL.text = info;
}
@end
