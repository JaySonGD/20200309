//
//  YHBrandSeriesCell.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBrandSeriesCell.h"
@interface YHBrandSeriesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
@implementation YHBrandSeriesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info isSel:(BOOL)isSel{
    _titleL.text = info[@"lineName"];
    _imgView.hidden = !isSel;
}
@end
