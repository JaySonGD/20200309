//
//  YHSetPartNameView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartNameView.h"
#import <Masonry.h>


@interface YHSetPartNameView ()

@end

@implementation YHSetPartNameView

- (instancetype)init{
    if (self = [super init]) {
        [self initSetPartNameView];
    }
    return self;
}
- (void)initSetPartNameView{
    
    // title_Label
    UILabel *textL = [[UILabel alloc] init];
    textL.font = [UIFont systemFontOfSize:17.0];
    textL.numberOfLines = 2;
    self.textL = textL;
    [self addSubview:textL];
    [textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@0);
        make.height.equalTo(@62);
        make.right.equalTo(textL.superview).offset(-85);
    }];
    // 删除按钮
    UIButton *removeBtn = [[UIButton alloc] init];
    [removeBtn setTitle:@"删除" forState:UIControlStateNormal];
    removeBtn.backgroundColor = [UIColor redColor];
    self.removeBtn = removeBtn;
    self.removeBtn.hidden = YES;
    [removeBtn addTarget:self action:@selector(removeMethodPartName) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeBtn];
    [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(textL.mas_right);
        make.right.equalTo(@0);
        make.height.equalTo(textL);
    }];
    
    // 叉叉按钮
    UIButton *deleBtn = [[UIButton alloc] init];
    [deleBtn setImage:[UIImage imageNamed:@"setPartRemove"] forState:UIControlStateNormal];
    self.deleBtn = deleBtn;
    [self addSubview:deleBtn];
    [deleBtn addTarget:self action:@selector(deleMethodPartName) forControlEvents:UIControlEventTouchUpInside];
    [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@46);
        make.height.equalTo(textL);
        make.right.equalTo(@0);
    }];
}
- (void)removeMethodPartName{
    if (_removeBtnPartNameClickBlock) {
        _removeBtnPartNameClickBlock();
    }
}
- (void)deleMethodPartName{
    
    self.deleBtn.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        self.removeBtn.hidden = NO;
    }];
    
    if (_deleBtnPartNameClickBlock) {
        _deleBtnPartNameClickBlock();
    }
}
@end
