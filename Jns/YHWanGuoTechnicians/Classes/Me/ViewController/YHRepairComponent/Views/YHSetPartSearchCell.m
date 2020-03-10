//
//  YHSetPartSearchCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartSearchCell.h"
#import <Masonry.h>


@implementation YHSetPartSearchCell

- (void)setFrame:(CGRect)frame{
    
    frame.size.height = frame.size.height- 1;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSelectBtn];
    }
    return self;
}
- (void)addSelectBtn{
    
//    UIButton *statusBtn = [[UIButton alloc] init];
//    statusBtn.hidden = YES;
//    statusBtn.userInteractionEnabled = NO;
//    [statusBtn setImage:[UIImage imageNamed:@"order_15"] forState:UIControlStateNormal];
//    [statusBtn setImage:[UIImage imageNamed:@"order_16"] forState:UIControlStateSelected];
//    self.statusBtn = statusBtn;
//    [self.contentView addSubview:statusBtn];
//    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(statusBtn.superview);
//        make.top.equalTo(statusBtn.superview);
//        make.bottom.equalTo(statusBtn.superview);
//        make.width.equalTo(@60);
//    }];
}
@end
