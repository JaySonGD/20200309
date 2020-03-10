//
//  YHBindBankCordView.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBindBankCordView.h"
#import <UIImageView+WebCache.h>

@interface YHBindBankCordView ()

/** 银行logo */
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgV;
/** 增加银行卡按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *bankCardAddBtn;
/** 增加银行卡提示文字 */
@property (weak, nonatomic) IBOutlet UILabel *bankCardBindPremptL;
/** 银行卡号 */
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumberL;

@end

@implementation YHBindBankCordView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.bankCardAddBtn.hidden = YES;
    self.bankCardBindPremptL.hidden = YES;
    self.bankLogoImgV.contentMode = UIViewContentModeScaleToFill;
}

- (void)setBankLogoImageViewUrlString:(NSString *)urlString{
    [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
}
- (void)setBankCardNumber:(NSString *)cardNumberString{
    _bankCardNumberL.text = cardNumberString;
}

@end
