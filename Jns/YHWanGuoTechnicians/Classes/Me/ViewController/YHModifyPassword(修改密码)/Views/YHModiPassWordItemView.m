//
//  YHModiPassWordItemView.m
//  YHCaptureCar
//
//  Created by liusong on 2018/6/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHModiPassWordItemView.h"
//#import "MBProgressHUD+MJ.h"

@interface YHModiPassWordItemView () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, copy) NSString *upInputString;

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

- (BOOL)is_Chinese:(NSString *)str{
    
    for(int i=0; i< [str length];i++){
        
        int comp = [str characterAtIndex:i];
        if( comp > 0x4e00 && comp < 0x9fff){ //19968,40959
            return YES;
        }
    }
    
    return NO;
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

- (void)alertPrempt:(NSString *)str{
    [MBProgressHUD showError:str toView:self.viewController.view];
}

@end
