//
//  YHAddPartInfoView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAddPartInfoView.h"
#import <Masonry.h>

@interface YHAddPartInfoView () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleL;

@end

@implementation YHAddPartInfoView

- (instancetype)init{
    if (self = [super init]) {
        [self initAddPartInfoView];
    }
    return self;
}
- (void)initAddPartInfoView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleL = [[UILabel alloc] init];
    self.titleL = titleL;
    [self addSubview:titleL];
  
    UITextField *inputTft = [[UITextField alloc] init];
    inputTft.delegate = self;
    self.inputTft = inputTft;
    [self addSubview:inputTft];
    
}
- (void)setTitleLableText:(NSString *)text{
    
    self.titleL.text = text;
    [self.titleL sizeToFit];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@20);
        make.bottom.equalTo(@0);
    }];
    
}
- (void)setTextFieldPlacehold:(NSString *)placeholdText{
    
    self.inputTft.placeholder = placeholdText;
    CGFloat width = [placeholdText boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.inputTft.font} context:nil].size.width;
    [self.inputTft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputTft.superview).offset(-20);
        make.top.equalTo(@0);
        make.width.equalTo(@(width));
        make.height.equalTo(self.inputTft.superview);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
   
    if ([self.delegate respondsToSelector:@selector(YHAddPartInfoView:changedText:)]) {
        [self.delegate YHAddPartInfoView:self changedText:textField.text];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(YHAddPartInfoView:changedText:)]) {
        [self.delegate YHAddPartInfoView:self changedText:textField.text];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *resultText = [NSMutableString stringWithString:textField.text];
    if (string.length > 0) { // 输入中
        [resultText appendString:string];
    }else{ // 删除中
        
        if (range.length > 0) {
          NSString *str = [resultText substringToIndex:range.location];
          resultText = [NSMutableString stringWithString:str];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(YHAddPartInfoView:changedText:)]) {
        [self.delegate YHAddPartInfoView:self changedText:resultText];
    }
    return YES;
}
@end
