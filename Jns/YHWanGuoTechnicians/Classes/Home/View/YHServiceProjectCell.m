//
//  YHServiceProjectCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/25.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHServiceProjectCell.h"
@interface YHServiceProjectCell ()
@property (weak, nonatomic) IBOutlet UILabel *detailL;

@end
@implementation YHServiceProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataSource:(NSDictionary*)info{
    _detailL.text = info[@"name"];
}
@end
