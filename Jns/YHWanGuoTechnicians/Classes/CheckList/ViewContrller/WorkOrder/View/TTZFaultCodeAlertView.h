//
//  TTZFaultCodeAlertView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZFaultCodeAlertView : UIView
+(void)showAlertViewWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholderTitle
                     codeType:(NSString *)type
                 keyBoardType:(NSString *)keyBoardType
                  didComplete:(void (^)(NSString *))complete;
@end
