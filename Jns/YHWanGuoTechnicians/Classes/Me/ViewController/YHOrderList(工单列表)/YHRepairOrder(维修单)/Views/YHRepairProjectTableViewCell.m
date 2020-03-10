//
//  YHRepairProjectTableViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairProjectTableViewCell.h"
#import "YHIntelligentCheckModel.h"

@implementation YHRepairProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.unitPriceTft];
      [self.prsentBtn addTarget:self action:@selector(prsentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)prsentBtnClick:(UIButton *)prsentBtn{
    prsentBtn.selected = !prsentBtn.selected;
    if ([self.cellModel isKindOfClass: NSClassFromString(@"YHLaborModel")]) {
        YHLaborModel *laborM = (YHLaborModel *)self.cellModel;
        laborM.status = prsentBtn.selected ? @"2" : @"1";
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"presentStatusChange" object:nil];
}
- (void)textChangeToSource:(NSNotification *)noti{
    
    UITextField *obj = (UITextField *)noti.object;
    YTLaborModel *laborModel = (YTLaborModel *)self.cellModel;
    if(![self.billType isEqualToString:@"J006"]){
        
    NSString *resultText = [obj.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    laborModel.labor_price = resultText;
        
    }else{
        
    laborModel.labor_time = [NSString stringWithFormat:@"%.1f",obj.text.floatValue];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.indexPath forKey:@"indexPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"repairTextChange_notification" object:nil userInfo:dict];
    
}
- (void)setCellModel:(id)cellModel{
    [super setCellModel:cellModel];
    
    YTLaborModel *laborModel = (YTLaborModel *)cellModel;
    if ([self.cellModel isKindOfClass: NSClassFromString(@"YHLaborModel")]) {
        YHLaborModel *laborM = (YHLaborModel *)self.cellModel;
        self.prsentBtn.selected = [laborM.status isEqualToString:@"2"] ? YES : NO;
    }
    self.repairNameL.text = laborModel.labor_name;
     NSString *priceText = @"";
    if (!IsEmptyStr(laborModel.labor_price)) {
        priceText = [NSString stringWithFormat:@"%.2f",[laborModel.labor_price floatValue]];
    }
    NSString *moneyChar = !IsEmptyStr(laborModel.labor_price) ? @"￥" : @"";
    self.unitPriceTft.text = [self.billType isEqualToString:@"J006"] ? laborModel.labor_time : [NSString stringWithFormat:@"%@%@",moneyChar,priceText];
    
    if (self.hasPresent) {
        self.presentViewH.constant = 35;
    }else{
        self.presentViewH.constant = 0;
    }
    
    self.giveView.hidden = [self.billType isEqualToString:@"J006"]  || [self.billType isEqualToString:@"J008"]  || [self.billType isEqualToString:@"J009"] || [self.billType isEqualToString:@"Y002"] || [self.billType isEqualToString:@"A"] || [self.billType isEqualToString:@"J004"] ;
    self.leftTitle.text = [self.billType isEqualToString:@"J006"] ? @"工时" : @"单价";
//    self.botLayout.active = ![self.billType isEqualToString:@"J006"] && ![self.billType isEqualToString:@"J008"]  && ![self.billType isEqualToString:@"J009"] && ![self.billType isEqualToString:@"Y002"] && ![self.billType isEqualToString:@"A"];
    
}
- (void)setIsHiddenSeprateLine:(BOOL)isHiddenSeprateLine{
    self.seprateLineV.hidden = isHiddenSeprateLine;
}

- (void)deleteBtnClickEvent{
    
    if (self.removeCallBack){
        self.removeCallBack(self.indexPath);
    }
}
- (void)setIsNOCanEdit:(BOOL)isNOCanEdit{
    
    self.deleteBtn.hidden = isNOCanEdit;
    self.unitPriceTft.userInteractionEnabled = !isNOCanEdit;
    self.unitPriceTft.backgroundColor = isNOCanEdit ? [UIColor whiteColor] : [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.unitPriceTft.borderStyle = isNOCanEdit ? UITextBorderStyleNone: UITextBorderStyleRoundedRect;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    const NSInteger limited = [self.billType isEqualToString:@"J006"] ? 1 : 2;

    {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = limited; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
    }
    
    return YES;
    
}

@end
