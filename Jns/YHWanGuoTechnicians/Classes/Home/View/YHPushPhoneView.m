//
//  YHPushPhoneView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPushPhoneView.h"

@implementation YHPushPhoneView

- (void)awakeFromNib{
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEiditEnd:) name:UITextFieldTextDidEndEditingNotification object:self.phoneTft];
}
- (void)textFieldEiditEnd:(NSNotification *)noti{
    
    UITextField *obj = noti.object;
    
    if (obj.text.length > 11) {
        [MBProgressHUD showError:@"手机号码位数不能大于11位"];
        obj.text = [obj.text substringToIndex:11];
    }
    
    if (_textEditEndCallBack) {
        _textEditEndCallBack(obj.text);
    }
    
}

@end
