//
//  YHOrderDetailTopContainView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailTopContainView.h"

@interface YHOrderDetailTopContainView ()

@property (nonatomic, weak) UIButton *currentSelectBtn;

@property (nonatomic, weak) UIView *bottomLine;

@property (nonatomic, assign) BOOL isFirstEnter;

@property (nonatomic, weak) UIButton *upBtn;

@end


@implementation YHOrderDetailTopContainView

- (UIView *)bottomLine{
    if (!_bottomLine) {
        
        UIView *bottomLine = [[UIView alloc] init];
        _bottomLine = bottomLine;
        bottomLine.backgroundColor = YHNaviColor;
        [self addSubview: bottomLine];
    }
    return _bottomLine;
}

- (void)setTitleArr:(NSArray <NSString *>*)titleArr{
    
    self.isFirstEnter = NO;
    
    _titleArr = titleArr;
    
    for (int i = 0; i<titleArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.selected = NO;
        btn.tag = 999+i;
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(btn.superview).dividedBy(titleArr.count);
            make.height.equalTo(btn.superview);
            if (self.upBtn) {
                make.left.equalTo(self.upBtn.mas_right);
            }else{
                make.left.equalTo(@0);
            }
            make.top.equalTo(@0);
        }];
        self.upBtn = btn;
        [btn addTarget:self action:@selector(btnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.isFirstEnter = YES;
            [self btnTouchUpInsideEvent:btn];
        }
        
        if ( i == titleArr.count - 1) {
            return;
        }
        
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [self addSubview:verticalLine];
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(btn.mas_right).offset(-1);
            make.width.equalTo(@0.5);
            make.top.equalTo(@5);
            make.bottom.equalTo(verticalLine.superview).offset(-5);
        }];
        
    }
    
}
- (void)btnTouchUpInsideEvent:(UIButton *)btn{
    
    [btn setTitleColor:YHNaviColor forState:UIControlStateNormal];
    btn.selected = YES;
    self.currentSelectBtn.selected = NO;
    [self.currentSelectBtn setTitleColor:[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.currentSelectBtn = btn;
    
    CGFloat width = [btn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.width;
    
    [self bringSubviewToFront:self.bottomLine];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.bottom.equalTo(self.bottomLine.superview);
        make.width.equalTo(@(width));
        make.centerX.equalTo(btn);
    }];
   
    if (!self.isFirstEnter) {
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
        }];
    }
  
    self.isFirstEnter = NO;
    if (_topButtonClickedBlock) {
        _topButtonClickedBlock(btn);
    }
    
}

@end
