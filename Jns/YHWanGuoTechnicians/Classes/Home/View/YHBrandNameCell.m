//
//  YHBrandNameCell.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBrandNameCell.h"
@interface YHBrandNameCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@end
@implementation YHBrandNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info{
    _titleL.text = info[@"brandName"];
    UIImage *image = [UIImage imageNamed:info[@"icoName"]];
    if (!image) {
        image = [UIImage imageNamed:@"carDefault"];
    }
    [_imgView setImage:image];
}
@end
