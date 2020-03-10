//
//  YHRichesHeaderView.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichesHeaderView.h"

@interface YHRichesHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *accountNumberL;

@property (weak, nonatomic) IBOutlet UIButton *applyCashBtn;

@property (weak, nonatomic) IBOutlet UILabel *richPremptL;
@property (weak, nonatomic) IBOutlet UIView *richPremptContentView;

@end

@implementation YHRichesHeaderView

- (NSString *)getAccountBalance{
    return self.accountNumberL.text;
}
- (void)setAccountBalance:(NSString *)balanceStr{
    
    _accountNumberL.text = balanceStr;
}
- (void)setGetAccountBalancePremptText:(NSString *)text{
    _richPremptL.text = text;
    [_richPremptL sizeToFit];
    
   CGFloat textWidth = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} context:nil].size.width;
    [self.richPremptContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.richPremptContentView.superview);
        make.width.equalTo(@(textWidth + 25));
        make.height.equalTo(@20);
        make.top.equalTo(self.applyCashBtn.mas_bottom).offset(15);
    }];
}

- (void)setApplyCashBtnEnable:(BOOL)isEnable{
    
    self.applyCashBtn.userInteractionEnabled = isEnable;
    self.applyCashBtn.backgroundColor = isEnable ? YHNaviColor : [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.applyCashBtn.backgroundColor = YHNaviColor;
    [self.applyCashBtn addTarget:self action:@selector(applyForCash:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)applyForCash:(UIButton *)applyBtn{
    
    if (_applyCashBtnClickEvent) {
        _applyCashBtnClickEvent();
    }
    
}
@end
