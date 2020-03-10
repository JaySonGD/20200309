//
//  YHImageItemView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHImageItemView.h"
#import "YHCommon.h"
#import <Masonry.h>

@interface YHImageItemView ()

@property (nonatomic, copy) void (^clearnBlock)();

@property (nonatomic, copy) void (^tapImageViewBlock)();

@end

@implementation YHImageItemView

- (instancetype)initWithImageItemViewClearnBlock:(void (^)(YHImageItemView *))clearnBlock tapImageViewBlock:(void (^)(YHImageItemView *))tapImageViewBlock{

    if (self = [super init]) {
        self.clearnBlock = clearnBlock;
        self.tapImageViewBlock = tapImageViewBlock;
        [self initImageItemView];
    }
    return self;
}


- (void)initImageItemView{
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    [imageV addGestureRecognizer:tapGes];
    self.imageV = imageV;
    imageV.layer.borderColor = YHLineColor.CGColor;
    imageV.layer.borderWidth = 1;
    imageV.layer.cornerRadius = 5;
    imageV.layer.masksToBounds = YES;
    [self addSubview:imageV];
    
    UIButton *cleanBtn = [[UIButton alloc] init];
    [cleanBtn addTarget:self action:@selector(cleanBtnTouchUpInsideEvent) forControlEvents:UIControlEventTouchUpInside];
    self.cleanBtn = cleanBtn;
    [cleanBtn setImage:[UIImage imageNamed:@"clearn"] forState:UIControlStateNormal];
    [self addSubview:cleanBtn];
    
    [self layoutView];
}
- (void)tapImageView{
    
    if (_tapImageViewBlock) {
        _tapImageViewBlock(self);
    }
}
- (void)layoutView{
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.imageV.superview).and.offset(-7);
        make.height.equalTo(self.imageV.superview).and.offset(-7);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        
    }];
    
}
- (void)cleanBtnTouchUpInsideEvent{
    NSLog(@"点击了清除按钮");
    if (_clearnBlock) {
        _clearnBlock(self);
    }
}

@end
