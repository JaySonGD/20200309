//
//  YHInPutCell.m
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHInPutCell.h"
#import "TTZDateTextField.h"

#include "YHHelpCkeckInputController.h"

@interface YHInPutCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet TTZDateTextField *dateTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *rightView;

@end

@implementation YHInPutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     __weak typeof(self) weakSelf = self;
    self.dateTF.valueChange = ^(NSString *text) {
        weakSelf.model.text = text;
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TTZInPutModel *)model{
    _model = model;
    self.nameLB.text = model.name;
    self.rightViewWidth.constant = model.image.length? 35 : 10;
    self.dateTF.hidden = !model.isCusKeyboard;
    self.textTF.hidden = !self.dateTF.isHidden;
    self.dateTF.placeholder = model.placeholder;
    self.textTF.placeholder = model.placeholder;

    self.textTF.userInteractionEnabled = !model.image.length;
    self.dateTF.userInteractionEnabled = !model.image.length;
    self.textTF.text = model.text;
    self.dateTF.text = model.text;

    self.textTF.keyboardType = [model.name isEqualToString:@"联系人电话"]? UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    
    //if([model.name isEqualToString:@"检测费"]) {self.textTF.userInteractionEnabled = NO;}else{}
    self.textTF.userInteractionEnabled = ![model.name isEqualToString:@"检测费"];
    [self.rightView setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
}

//FIXME:  -  <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.model.text = textField.text;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string length]==0) {
        return YES;
    }

    
    if ([self.model.name isEqualToString:@"联系人电话"]) {
        if ([textField.text length] >= 11) return NO;
    }
    
    if ([self.model.name isEqualToString:@"车架号"]) {
        if ([textField.text length] >= 17) return NO;
    }


    return YES;
}

- (IBAction)jump2MapAction {
    if([self.model.image isEqualToString:@"定位"])
    {
        !(_jump2Map)? : _jump2Map();

    }
}


@end
