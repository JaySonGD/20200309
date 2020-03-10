//
//  TTZFaultCodeAlertView.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZFaultCodeAlertView.h"

#import "YHCommon.h"

#import <IQKeyboardManager.h>

@interface TTZFaultCodeAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

static void (^_complete)(NSString *);

@implementation TTZFaultCodeAlertView

+ (instancetype)faultCodeAlertView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    return [[NSBundle mainBundle] loadNibNamed:@"TTZFaultCodeAlertView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    kViewRadius(self.contentView, 10);
}

+(void)showAlertViewWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholderTitle
                     codeType:(NSString *)type
                 keyBoardType:(NSString *)keyBoardType
                  didComplete:(void (^)(NSString *))complete{
    _complete = complete;
    TTZFaultCodeAlertView *view = [self faultCodeAlertView];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = [UIScreen mainScreen].bounds;
    view.alpha = 0;
    view.titleLabel.text = title;
    view.inputTF.placeholder = placeholderTitle;
    if (![type isEqualToString:@"elecCodeForm"] && ![type isEqualToString:@"gatherInputAdd"]) {
        view.inputTF.inputView = nil;
        if ([keyBoardType isEqualToString:@"number"]) {
            view.inputTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
    }

    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        view.inputTF.inputAccessoryView = nil;
        [view.inputTF becomeFirstResponder];
    }];
}

- (IBAction)addAction {
    if (IsEmptyStr(self.inputTF.text)) {
        return;
    }
    !(_complete)? : _complete(self.inputTF.text);
    [self.inputTF endEditing:YES];
    [self dimiss];
}

- (IBAction)dimiss {
    if (self.inputTF.isEditing) {
        [self.inputTF endEditing:YES];
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

@end
