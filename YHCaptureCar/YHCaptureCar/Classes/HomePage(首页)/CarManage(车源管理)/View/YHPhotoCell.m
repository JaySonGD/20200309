//
//  YHPhotoCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHPhotoCell.h"
#import "YHCarPhotoModel.h"
#import <Masonry/Masonry.h>

@interface YHPhotoCell ()
@property (strong, nonatomic)  UIButton *imageBtn;
@property (strong, nonatomic)  UILabel *nameLB;
@end


@implementation YHPhotoCell


- (UIButton *)imageBtn{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"正在添加图片"] forState:UIControlStateSelected];
        _imageBtn.userInteractionEnabled = NO;
    }
    return _imageBtn;
}

- (UILabel *)nameLB{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor whiteColor];
        _nameLB.font = [UIFont systemFontOfSize:13.0];
        _nameLB.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLB;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageBtn];
        [self.contentView addSubview:self.nameLB];

        [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self.contentView);
            
        }];
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nameLB.mas_top).offset(-13);
            make.centerX.equalTo(self.contentView);
            make.size.equalTo(@(CGSizeMake(25, 25)));
        }];

    }
    return self;
}


- (void)setModel:(YHPhotoModel *)model
{
    _model = model;
    
    
    self.imageBtn.selected = model.isSelected;
  
    UIImage *image = model.image? [UIImage imageNamed:@"拍摄好图片"] : [UIImage imageNamed:@"未添加图片"];
    
    
    
    [self.imageBtn setImage:image forState:UIControlStateNormal];
    self.nameLB.text = model.name;
}

@end
