//
//  TTZTextView.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZTextView.h"

@interface TTZTextView()
    @property (weak, nonatomic) IBOutlet UITextView *textView;

    @property (nonatomic, strong) UILabel *placeHolderLB;
@end

@implementation TTZTextView

- (void)awakeFromNib
    {
        [super awakeFromNib];
        self.placeHolderLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        self.placeHolderLB.text = @"请输入车辆描述";
        self.placeHolderLB.font = [UIFont systemFontOfSize:14];
        self.placeHolderLB.enabled = NO;
        [self addSubview:self.placeHolderLB];
    }

- (void)setText:(NSString *)text
{
    _text = text;
    self.textView.text = text;
    self.placeHolderLB.hidden = text.length;
}

#pragma mark - TextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];//按回车取消第一相应者
//    }
    return YES;
//    NSString *rangeText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSInteger res = 50 - [rangeText length];
//    if(res >= 0){
//        return YES;
//    }
//    else{
//        NSRange rg = {0,[text length]+res};
//        if (rg.length>0) {
//            NSString *s = [text substringWithRange:rg];
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
//        return NO;
//    }

}
    
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
    {
        self.placeHolderLB.alpha = 0;//开始编辑时
        return YES;
    }
    
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
    {//将要停止编辑(不是第一响应者时)
        if (textView.text.length == 0) {
            self.placeHolderLB.alpha = 1;
        }
        !(_textChange)? : _textChange(textView.text);

        return YES;
    }
@end
