//
//  YHCarDetailCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/9/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarDetailCell.h"
#import "YHCustomLeftAndRightButton.h"
//#import "MBProgressHUD+MJ.h"

@interface YHCarDetailCell ()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UILabel *upSubTitleL;

@end

@implementation YHCarDetailCell

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    self.upSubTitleL = nil;
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UILabel *titleL = [[UILabel alloc] init];
    UIColor *mainTextColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0];
    titleL.textColor = mainTextColor;
    titleL.font = [UIFont systemFontOfSize:14.0];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@8);
//        make.right.equalTo(@-8);
        make.height.equalTo(@18);
    }];
    self.titleL.text = info[@"title"];
    
    NSArray *subArr = info[@"subArr"];
    for (int i = 0; i<subArr.count; i++) {
         NSDictionary *item = subArr[i];
        
        UIView *temp = nil;
        BOOL isMainColor = [item[@"textColor"] isEqualToString:@"mainColor"] ? YES : NO;
        // 不可编辑类型
        if ([item[@"type"] isEqualToString:@"label"]) {
            UILabel *subTitleL = [[UILabel alloc] init];
            subTitleL.text = item[@"subTitle"];
            subTitleL.numberOfLines = 0;
            subTitleL.tag = 1;
            subTitleL.textColor = isMainColor ? mainTextColor : [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
            subTitleL.font = [UIFont systemFontOfSize:14.0];
            temp = subTitleL;
        }
        // 输入类型
        if ([item[@"type"] isEqualToString:@"textfield"]) {
            UITextField *subTft = [[UITextField alloc] init];
            subTft.delegate = self;
            subTft.text = item[@"subTitle"];
            subTft.placeholder = item[@"prempt"];
            subTft.textColor = isMainColor ? mainTextColor : [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
            subTft.font = [UIFont systemFontOfSize:14.0];
            temp = subTft;
        }
        // 选择类型
        if ([item[@"type"] isEqualToString:@"select"]) {
            
            YHCustomLeftAndRightButton *selectBtn = [[YHCustomLeftAndRightButton alloc] init];
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [selectBtn setTitleColor:isMainColor ? mainTextColor : [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectBtn setImage:[UIImage imageNamed:@"me_7"] forState:UIControlStateNormal];
            NSString *text = [item[@"subTitle"] isEqualToString:@""] ? item[@"prempt"] : item[@"subTitle"];
            [selectBtn setTitle:text forState:UIControlStateNormal];
            temp = selectBtn;
        }
        
        if (!temp) {
            return;
        }
        
        [self.contentView addSubview:temp];
        [temp mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.upSubTitleL) {
                make.top.equalTo(self.upSubTitleL.mas_bottom).offset(8);
            }else{
                make.top.equalTo(self.titleL.mas_bottom).offset(10);
            }
            make.left.equalTo(self.titleL);
            if(temp.tag == 1){
            make.right.equalTo(@-8);
            make.height.greaterThanOrEqualTo(@28);
            }else{
            make.height.equalTo(self.titleL);
            }
        }];
        temp.tag = i+888;
        self.upSubTitleL = temp;
       
    }
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:233/255.0 green:232/255.0 blue:245/255.0 alpha:1];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upSubTitleL.mas_bottom).offset(4);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(@12);
        make.bottom.equalTo(@0);
    }];
    
    UIView *v = [[UIView alloc]init];
   v.backgroundColor = [UIColor whiteColor];
   v.layer.cornerRadius = 4.0;
   v.layer.masksToBounds = YES;
   [view addSubview:v];
   [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-4);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(@8);
   }] ;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.titleL.text isEqualToString:@"证件号码"]) {
        if (textField.text.length < 8) {
            [MBProgressHUD showError:@"请输入至少8位以上的证件号码"];
            return;
        }
        
        if (textField.text.length > 18) {
            [MBProgressHUD showError:@"证件号码位数不能大于18位！"];
            return;
        }
        
    }
    
    if (_textfieldInputEvent) {
        _textfieldInputEvent(textField.text,_indexPath,(textField.tag - 888));
    }
}
#pragma mark - 选择类型点击事件 ----
- (void)selectBtnClick:(UIButton *)btn{
    
    if(_indexPath.row == 5)return;
    
    if (_selectEvent) {
        _selectEvent(_indexPath,(btn.tag - 888),btn);
    }
}
//- (void)setFrame:(CGRect)frame{
//    frame.size.height -= 8;
//    [super setFrame:frame];
//}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
//    [self.contentView setRounded:self.contentView.frame corners:UIRectCornerAllCorners radius:2.0];
}
@end
