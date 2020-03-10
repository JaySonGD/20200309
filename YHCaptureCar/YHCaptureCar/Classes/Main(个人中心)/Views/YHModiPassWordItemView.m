//
//  YHModiPassWordItemView.m
//  YHCaptureCar
//
//  Created by liusong on 2018/6/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHModiPassWordItemView.h"
#import "MBProgressHUD+MJ.h"


@interface YHModiPassWordItemView () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleL;

@end

@implementation YHModiPassWordItemView

- (instancetype)init{
    if (self = [super init]) {
        [self initItemUI];
    }
    return self;
}
- (void)initItemUI{
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:17.0];
    titleL.textAlignment = NSTextAlignmentRight;
    self.titleL = titleL;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@70);
        make.height.equalTo(titleL.superview);
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    YHPassWordTextField *inputField = [[YHPassWordTextField alloc] init];
    inputField.delegate = self;
    inputField.layer.cornerRadius = 5.0;
    inputField.layer.masksToBounds = YES;
    inputField.layer.borderColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.8].CGColor;
    inputField.layer.borderWidth = 0.8;
    inputField.font = [UIFont systemFontOfSize:17.0];
    self.inputField = inputField;
    [self addSubview:inputField];
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleL);
        make.left.equalTo(titleL.mas_right).offset(8);
        make.height.equalTo(titleL);
        make.right.equalTo(inputField.superview);
    }];
}

- (void)setType:(YHModiPassWordItemViewType)type{
    _type = type;
    
    if (type == YHModiPassWordItemViewOriginPass) {
        self.inputField.placeholder = @"请输入您的原密码";
        self.titleL.text = @"原密码";
    }
    
    if (type == YHModiPassWordItemViewNewPass) {
        self.inputField.placeholder = @"请输入您的新密码";
        self.titleL.text = @"新密码";
    }
    
    if (type == YHModiPassWordItemViewSurePass) {
        self.inputField.placeholder = @"请输入您的新密码";
        self.titleL.text = @"确认密码";
    }
}

- (BOOL)is_Chinese:(NSString *)str{
    
    for(int i=0; i< [str length];i++){
        
        int comp = [str characterAtIndex:i];
        if( comp > 0x4e00 && comp < 0x9fff){ //19968,40959
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isNeedInputTypeChar:(NSString *)charStr{
    
    NSString *expressStr = @"^[0-9A-Za-z_]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expressStr];
    BOOL isNumber = [predicate evaluateWithObject:charStr];
    return isNumber;
    
};

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self is_Chinese:string] && string.length > 0) {
        [self alertPrempt:@"密码仅支持英文、数字、下划线"];
        return NO;
    }
    if (![self isNeedInputTypeChar:string] && string.length > 0) {
        [self alertPrempt:@"密码仅支持英文、数字、下划线"];
        return NO;
    }
    
    if (string.length > 0) {
        if (textField.text.length >= 16) {
            [self alertPrempt:@"密码长度最多16位"];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![self.inputField.placeholder isEqualToString: @"请输入您的原密码"]) {
        if (![self isMatchPassWord:textField.text]) {
            [MBProgressHUD showError:@"新密码要求8-16位数字和字母组成"];
        }else{
            
        }
    }
}

- (BOOL)isMatchPassWord:(NSString *)pwd{
    BOOL result = false;
    if ([pwd length] >= 8 && [pwd length] <= 16){
        // 判断长度大于8位后，再接着判断是否同时包含数字和字符
        //NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSString *regex = @"^[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pwd];
    }
    return result;
}

- (void)alertPrempt:(NSString *)str{
    [MBProgressHUD showError:str toView:self.viewController.view];
}

@end
