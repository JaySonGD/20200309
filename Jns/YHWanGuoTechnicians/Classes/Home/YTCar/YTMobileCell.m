//
//  YTMobileCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTMobileCell.h"

@implementation YTMobileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //137 2537 5617
    if (textField.text.length >=11 && !IsEmptyStr(string)) {
        return NO;
    }
    //    self.inputStr = string;
    //    self.previousTextFieldContent = textField.text;
    //    self.previousSelection = textField.selectedTextRange;
    NSString *str = nil;
                     
    if(string.length){
        
    str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
    }else{
    
    str = [textField.text substringToIndex:range.location];//截取子字符串方式
        
    }
    self.mobileTfBlock(str);
    return YES;
}


@end
