//
//  YHBankLogoCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBankLogoCell.h"

@implementation YHBankLogoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBankLogoCell];
    }
    return self;
}
- (void)initBankLogoCell{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *logoImgV = [[UIImageView alloc] init];
    logoImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImgV = logoImgV;
    [self addSubview:logoImgV];
    [logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.width.equalTo(@160);
        make.height.equalTo(@30);
        make.centerY.equalTo(logoImgV.superview);
    }];
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}
@end
