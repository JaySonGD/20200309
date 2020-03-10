
#import "VerCodeView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface VerCodeView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, strong) NSMutableArray <UIView *>*viewArr;
@property (nonatomic, strong) NSMutableArray <UILabel *>*labelArr;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*pointlineArr;

@property (nonatomic, strong) NSMutableString *text;

@end

@implementation VerCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValue];
        self.text = [NSMutableString stringWithString:@""];
    }
    return self;
}

-(void)initDefaultValue{
    //初始化默认值
    self.maxLenght = 4;
    _defaultColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1];
    _borderColor = [UIColor colorWithRed:230/255.0 green:81/255.0 blue:75/255.0 alpha:1];
    _pointColor = _borderColor;
    self.backgroundColor = [UIColor clearColor];
    [self beginEdit];
}

-(void)verCodeViewWithMaxLenght{
    //创建输入验证码view
    if (_maxLenght<=0) {
        return;
    }
    if (_contairView) {
        [_contairView removeFromSuperview];
    }
    _contairView  = [UIView new];
    _contairView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_contairView addSubview:self.textView];
    //添加textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contairView);
    }];
    
    CGFloat padding = 13;
    UIView *lastView;
    for (int i=0; i<self.maxLenght; i++) {
        UIView *subView = [UIView new];
        subView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];//[UIColor whiteColor];
        subView.cornerRadius = 8;
        subView.borderWidth = (1);
        subView.userInteractionEnabled = NO;
        [_contairView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(padding);
            }else{
                make.left.equalTo(@(0));
            }
            make.centerY.equalTo(self.contairView);
            make.height.equalTo(self.contairView.mas_height);
            //make.width.equalTo(self.contairView.mas_height);
            make.width.equalTo(@(50));

        }];
        UILabel *subLabel = [UILabel new];
        subLabel.font = [UIFont systemFontOfSize:38];
        [subView addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(subView);
            make.centerY.equalTo(subView);
        }];
        lastView = subView;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetHeight(self.frame)-2)/2,10,2,(CGRectGetHeight(self.frame)-20))];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  _pointColor.CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {//初始化第一个view为选择状态
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            line.hidden = NO;
            subView.borderColor = _defaultColor;
        }else{
            line.hidden = YES;
            subView.borderColor = _defaultColor;
        }
        [self.viewArr addObject:subView];
        [self.labelArr addObject:subLabel];
        [self.pointlineArr addObject:line];
    }
    

    
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView?lastView.mas_right:@(0));
    }];
}

#pragma mark - TextView

-(void)beginEdit{
    [self.textView becomeFirstResponder];
}

-(void)endEdit{
    [self.textView resignFirstResponder];
}

//- (void)textViewDidChange:(UITextView *)textView{
- (void)textViewDidChange:(NSString *)str{

    NSString *totalStr;
    if (str.length) {
            totalStr = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
    }else{
        if (self.textView.hasText) {
            totalStr = [self.textView.text substringToIndex:self.textView.text.length - 1];
        }else{
            totalStr = self.textView.text;
        }
    }

    NSString *verStr = totalStr;
    
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    verStr = [verStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    if (verStr.length >= _maxLenght) {
        verStr = [verStr substringToIndex:_maxLenght];
        [self endEdit];
    }
    


    if (self.block) {
        //将textView的值传出去
        self.block(verStr);
    }

    for (int i= 0; i < self.viewArr.count; i++) {
        //以text为中介区分
        UILabel *label = self.labelArr[i];
        if (i<verStr.length) {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [verStr substringWithRange:NSMakeRange(i, 1)];

        }else{
            [self changeViewLayerIndex:i pointHidden:i==verStr.length?NO:YES];
            if (!verStr&&verStr.length==0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
    }
    
    NSLog(@"%s--属机构---%@", __func__,self.textView.text);
}

- (void)textViewDidChange11:(NSString *)str{
    
    [self.text appendString:str];
    
    NSString *verStr = self.text;//textView.text;
    
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    verStr = [verStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    if (verStr.length >= _maxLenght) {
        verStr = [verStr substringToIndex:_maxLenght];
        [self endEdit];
    }
    
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    verStr = [verStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    self.textView.text = verStr;
    
    if (self.block) {
        //将textView的值传出去
        self.block(verStr);
    }
    
    for (int i= 0; i < self.viewArr.count; i++) {
        //以text为中介区分
        UILabel *label = self.labelArr[i];
        if (i<verStr.length) {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [verStr substringWithRange:NSMakeRange(i, 1)];
            
        }else{
            [self changeViewLayerIndex:i pointHidden:i==verStr.length?NO:YES];
            if (!verStr&&verStr.length==0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
    }
}
- (void)changeViewLayerIndex:(NSInteger)index pointHidden:(BOOL)hidden{
    
    CAShapeLayer *line =self.pointlineArr[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    line.hidden = hidden;

}


/**
 pattern中,输入需要验证的通过的字符
 小写a-z
 大写A-Z
 汉字\u4E00-\u9FA5
 数字\u0030-\u0039
 @param str 要过滤的字符
 @return YES 只允许输入字母和汉字
 */
- (BOOL)isInputRuleAndNumber:(NSString *)str {
    NSString *pattern = @"[a-zA-Z\u4E00-\u9FA5\\u0030-\\u0039]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self isInputRuleAndNumber:string] || [string isEqualToString:@""]) {
        [self textViewDidChange:string];
        return YES;
    }
    return NO;
}



- (void)resetCode{
    
    for (UIView *view in self.viewArr) {
        view.borderColor = _borderColor;
        view.backgroundColor = [UIColor whiteColor];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in self.viewArr) {
                view.borderColor = _defaultColor;
                view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
            }
        } completion:^(BOOL finished) {
            self.textView.text = nil;
            self.text = [NSMutableString stringWithString:@""];
            for (UILabel *label in self.labelArr) {
                label.text = nil;
            }
            [self changeViewLayerIndex:0 pointHidden:NO];
            [self beginEdit];
        }];

    });
}

- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}


#pragma mark --setter&&getter

-(void)setMaxLenght:(NSInteger)maxLenght{
    _maxLenght = maxLenght;
}

-(void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    _keyBoardType = keyBoardType;
    self.textView.keyboardType = keyBoardType;
}




-(UITextField *)textView{
    if (!_textView) {
        _textView = [UITextField new];//[UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        

//        [_textView addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textView;
}

-(NSMutableArray *)pointlineArr{
    if (!_pointlineArr) {
        _pointlineArr = [NSMutableArray new];
    }
    return _pointlineArr;
}
-(NSMutableArray *)viewArr{
    if (!_viewArr) {
        _viewArr = [NSMutableArray new];
    }
    return _viewArr;
}
-(NSMutableArray *)labelArr{
    if (!_labelArr) {
        _labelArr = [NSMutableArray new];
    }
    return _labelArr;
}




@end


@implementation UITextField (code)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end

@implementation UIView (code)

- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = (cornerRadius > 0);
}


- (CGFloat)borderWidth{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = (borderWidth > 0);
}


- (UIColor *)borderColor{
    return objc_getAssociatedObject(self, @selector(borderColor));
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}



@end

