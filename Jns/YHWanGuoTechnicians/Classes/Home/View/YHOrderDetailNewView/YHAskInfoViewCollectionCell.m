//
//  YHAskInfoViewCollectionCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAskInfoViewCollectionCell.h"

@implementation YHAskInfoViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initItemView];
    }
    return self;
}
- (void)initItemView{
    
    UIImageView *itemImg = [[UIImageView alloc] init];
    self.imageV = itemImg;
    [self addSubview:itemImg];
    [itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(itemImg.superview);
        make.center.equalTo(itemImg.superview);
    }];
    
}
@end
