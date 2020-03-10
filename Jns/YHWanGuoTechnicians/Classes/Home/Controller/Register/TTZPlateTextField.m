//
//  TTZPlateTextField.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZPlateTextField.h"
#import "TTZPlateKeyBoardView.h"

@interface TTZPlateTextField ()<TTZPlateKeyBoardViewDelegate>
@end
@implementation TTZPlateTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
- (void)clickWithString:(NSString *)string{
    NSString *code = string;
    NSRange select = [self selectedRange];
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.text];
    
    if(self.isCarNo){
        if (text.length>8) {
            return;
        }

    }else{
        if (text.length>16) {
            return;
        }
    }
    
    [text replaceCharactersInRange:select withString:code];
    self.text = text;
    [self setSelectedRange:NSMakeRange(select.location+code.length, 0)];
//    !(_textChange)? : _textChange();

}

- (void)setPunctuation:(BOOL)punctuation{
    _punctuation = punctuation;
    if (punctuation) {
        TTZPlateKeyBoardView *keyBoardView = (TTZPlateKeyBoardView *)self.inputView;
        keyBoardView.punctuation = YES;
    }
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    !(_textChange)? : _textChange();
}

- (void)deleteBtnClick{
    NSRange select = [self selectedRange];
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.text];
    if(self.hasText) {
        
        if (select.length) {
            [text replaceCharactersInRange:select withString:@""];
            self.text = text;
            [self setSelectedRange:NSMakeRange(select.location, 0)];
        }else{
            if(select.location){
                [text replaceCharactersInRange:                    NSMakeRange(select.location - 1, 1) withString:@""];
                self.text = text;
                [self setSelectedRange:NSMakeRange(select.location-1, 0)];
                
            }
            
        }
        
    }
//    !(_textChange)? : _textChange();
    return;
}
- (void)setUI{
    
    
    
    TTZPlateKeyBoardView *keyBoardView  = [[TTZPlateKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.33)];
    self.inputView = keyBoardView;
    keyBoardView.delegate = self;
//    __weak typeof(self) weakSelf = self;
//    keyBoardView.clickBlock = ^(NSDictionary *codeObj) {
//        NSString *code = codeObj[@"code"];
//        NSRange select = [self selectedRange];
//        NSMutableString *text = [[NSMutableString alloc] initWithString:weakSelf.text];
//        
//        if ([code isEqualToString:@"收起"] || [code isEqualToString:@"确定"]) {
//            [weakSelf endEditing:YES];
//            return ;
//        }else if ([code isEqualToString:@"推格"]){
//            
//            if(weakSelf.hasText) {
//                
//                if (select.length) {
//                    [text replaceCharactersInRange:select withString:@""];
//                    weakSelf.text = text;
//                    [weakSelf setSelectedRange:NSMakeRange(select.location, 0)];
//                }else{
//                    if(select.location){
//                        [text replaceCharactersInRange:                    NSMakeRange(select.location - 1, 1) withString:@""];
//                        weakSelf.text = text;
//                        [weakSelf setSelectedRange:NSMakeRange(select.location-1, 0)];
//                        
//                    }
//                    
//                }
//                
//            }
//            return;
//        }
//        [text replaceCharactersInRange:select withString:code];
//        weakSelf.text = text;
//        [weakSelf setSelectedRange:NSMakeRange(select.location+code.length, 0)];
//    };
}

- (NSRange)selectedRange{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange) range {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}



@end
