//
//  ZZAlertViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 30/10/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "ZZAlertViewController.h"

#import "UIView+Layout.h"

@interface ZZAlertViewController ()

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, strong) NSMutableArray <UIButton *>*actions;
@property (nonatomic, strong) NSMutableArray <UITextField *>*tfs;
@property (nonatomic, strong) NSMutableArray <ZZTextView *>*tvs;
@property (nonatomic, strong) NSMutableDictionary *handlers;

@property (nonatomic, weak) UIView *buttonContentView;

@end


@implementation ZZAlertViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setupUI{
    
     __weak typeof(self) weakSelf = self;
//    [self.view addSubview:({
//        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [coverBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
//        coverBtn.frame = [UIScreen mainScreen].bounds;
//        coverBtn;
//    })];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView.layer setCornerRadius:8];
    [contentView.layer setMasksToBounds:YES];
    [self.view addSubview:contentView];
    
    UIToolbar *bgBar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView addSubview:bgBar];

    
    [contentView setLyCenterX:nil];
    [contentView setLyCenterY:nil];
    [contentView setLyWidth:^(LayoutModel * _Nonnull layout) {
        layout.constant = 330;
    }];
    
    
    UIImageView *iconView = nil;
    if (self.icon) {
        iconView = [[UIImageView alloc] init];
        iconView.image = self.icon;
        [contentView addSubview:iconView];
        
        [iconView setLyWidth:^(LayoutModel * _Nonnull layout) {
            layout.constant = 80;
        }];
        [iconView setLyHeight:^(LayoutModel * _Nonnull layout) {
            layout.constant =  80;
        }];
        [iconView setLyCenterX:nil];
        [iconView setLyTop:^(LayoutModel * _Nonnull layout) {
            layout.constant = 25;
        }];
    }
    
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.font = [UIFont systemFontOfSize:17.0];
    titleLB.text = self.alertTitle;
    titleLB.numberOfLines = 0;
    [contentView addSubview:titleLB];
    
    [titleLB setLyTop:^(LayoutModel * _Nonnull layout) {
        
        if (iconView) {
            layout.relativeToView = iconView;
            layout.layoutAtt = NSLayoutAttributeBottom;
        }
        if(weakSelf.alertTitle.length) layout.constant = 25;
    }];
    [titleLB setLyleft:^(LayoutModel * _Nonnull layout) {
        layout.constant = 25;
    }];
    [titleLB setLyRight:^(LayoutModel * _Nonnull layout) {
        layout.constant = -25;
    }];
    
    if(!weakSelf.alertTitle.length)  {
        [titleLB setLyHeight:^(LayoutModel * _Nonnull layout) {
            layout.constant = 0;
        }];
    }
    
    
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.textAlignment = NSTextAlignmentCenter;
    messageLB.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
    messageLB.numberOfLines = 0;
    messageLB.font = [UIFont systemFontOfSize:13.0];
    messageLB.text = self.message;
    [contentView addSubview:messageLB];
    
    [messageLB setLyTop:^(LayoutModel * _Nonnull layout) {
        layout.relativeToView = titleLB;
        layout.layoutAtt = NSLayoutAttributeBottom;
        if(weakSelf.message.length) layout.constant = 15;
    }];
    [messageLB setLyleft:^(LayoutModel * _Nonnull layout) {
        layout.constant = 25;
    }];
    [messageLB setLyRight:^(LayoutModel * _Nonnull layout) {
        layout.constant = -25;
    }];
    if(!weakSelf.message.length)  {
        [messageLB setLyHeight:^(LayoutModel * _Nonnull layout) {
            layout.constant = 0;
        }];
    }
    
    
    UIView *buttonContentView = [[UIView alloc] init];
    [contentView addSubview:buttonContentView];
    _buttonContentView = buttonContentView;
    
    [buttonContentView setLyTop:^(LayoutModel * _Nonnull layout) {
        layout.relativeToView = messageLB;
        layout.layoutAtt = NSLayoutAttributeBottom;
        layout.constant = 0;
    }];
    [buttonContentView setLyleft:^(LayoutModel * _Nonnull layout) {
        layout.constant = 25;
    }];
    [buttonContentView setLyRight:^(LayoutModel * _Nonnull layout) {
        layout.constant = -25;
    }];
    [buttonContentView setLyHeight:^(LayoutModel * _Nonnull layout) {
        layout.constant = 0;
    }];
    [buttonContentView setLyButtom:^(LayoutModel * _Nonnull layout) {
        layout.constant = -20;
    }];
    
}



+ (instancetype)alertControllerWithTitle:(NSString *)title
                                    icon:(UIImage *)icon
                                 message:(NSString *)message{
    ZZAlertViewController *alertVC = [[self alloc] init];
    alertVC.alertTitle = title;
    alertVC.icon = icon;
    alertVC.message = message;
    alertVC.actions = @[].mutableCopy;
    alertVC.handlers = @{}.mutableCopy;
    alertVC.tfs = @[].mutableCopy;
    alertVC.tvs = @[].mutableCopy;
    [alertVC setupUI];
    return alertVC;
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

- (void)addActionWithTitle:(NSString *)title style:(ZZAlertActionStyle)style handler:(void (^)(UIButton * _Nonnull))handler configurationHandler:(void (^)(UIButton * _Nonnull))configurationHandler{
    UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAction setTitle:title forState:UIControlStateNormal];
    
    NSArray *bgColors = @[[UIColor colorWithRed:69/255.0 green:175/255.0 blue:247/255.0 alpha:1.0],[UIColor whiteColor],[UIColor whiteColor]];
    NSArray *fontColors = @[[UIColor whiteColor],[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0],[UIColor redColor]];
    
    //[UIColor redColor]//209
    [btnAction.layer setBorderWidth:0.5];
    [btnAction.layer setBorderColor:[[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor]];
    [btnAction.layer setCornerRadius:8];
    [btnAction.layer setMasksToBounds:YES];
    [btnAction setTitleColor:fontColors[style] forState:UIControlStateNormal];
    //[btnAction setBackgroundColor:bgColors[style]];
    [btnAction setBackgroundImage:[self createImageWithColor:bgColors[style]] forState:UIControlStateNormal];
    
    [btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [btnAction setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]] forState:UIControlStateDisabled];
    
    
    btnAction.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btnAction addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actions addObject:btnAction];
    if (handler) {
        [self.handlers setValue:handler forKey:title];
    }
    
    UIView *lastView = self.buttonContentView.subviews.lastObject;
    
    [self.buttonContentView addSubview:btnAction];
    
    [btnAction setLyleft:nil];
    [btnAction setLyRight:nil];
    [btnAction setLyTop:^(LayoutModel * _Nonnull layout) {
        if (lastView){
            layout.relativeToView = lastView;
            layout.layoutAtt = NSLayoutAttributeBottom;
        }
        layout.constant = 15;
    }];
    [btnAction setLyHeight:^(LayoutModel * _Nonnull layout) {
        layout.constant = 45;
    }];
    
    self.buttonContentView.lyHeight.constant += 60;
    
    !(configurationHandler)? : configurationHandler(btnAction);

}


- (void)addActionWithTitle:(NSString *)title
                     style:(ZZAlertActionStyle)style
                   handler:(void (^)(UIButton *))handler{
    [self addActionWithTitle:title style:style handler:handler configurationHandler:nil];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler didChangeCharacters:(void (^ _Nullable)(UITextField * _Nonnull))didChangeHandler{
    
    UITextField *tf = [[UITextField alloc] init];
    [tf addTarget:self action:@selector(didChange:) forControlEvents:UIControlEventEditingChanged];
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tf.layer setBorderWidth:0.5];
    [tf.layer setBorderColor:[[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor]];
    [tf.layer setCornerRadius:8];
    [tf.layer setMasksToBounds:YES];
    
    UIView *lastView = self.buttonContentView.subviews.lastObject;
    
    [self.buttonContentView addSubview:tf];
    
    [tf setLyleft:nil];
    [tf setLyRight:nil];
    [tf setLyTop:^(LayoutModel * _Nonnull layout) {
        if (lastView){
            layout.relativeToView = lastView;
            layout.layoutAtt = NSLayoutAttributeBottom;
        }
        layout.constant = 15;
    }];
    [tf setLyHeight:^(LayoutModel * _Nonnull layout) {
        layout.constant = 45;
    }];
    
    self.buttonContentView.lyHeight.constant += 60;
    [self.tfs addObject:tf];
    configurationHandler(tf);
    
    if (didChangeHandler) {
        NSString *objKey = [NSString stringWithFormat:@"%ld",(long)tf.tag];
        [self.handlers setValue:didChangeHandler forKey:objKey];
    }

}

- (void)addTextViewWithConfigurationHandler:(void (^)(ZZTextView * _Nonnull))configurationHandler didChangeCharacters:(void (^)(UITextView * _Nonnull))didChangeHandler{
    
    ZZTextView *tf = [[ZZTextView alloc] init];

    [tf.layer setBorderWidth:0.5];
    [tf.layer setBorderColor:[[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor]];
    [tf.layer setCornerRadius:8];
    [tf.layer setMasksToBounds:YES];
    
    UIView *lastView = self.buttonContentView.subviews.lastObject;
    
    [self.buttonContentView addSubview:tf];
    
    [tf setLyleft:nil];
    [tf setLyRight:nil];
    [tf setLyTop:^(LayoutModel * _Nonnull layout) {
        if (lastView){
            layout.relativeToView = lastView;
            layout.layoutAtt = NSLayoutAttributeBottom;
        }
        layout.constant = 15;
    }];
    [tf setLyHeight:^(LayoutModel * _Nonnull layout) {
        layout.constant = 145;
    }];
    
    self.buttonContentView.lyHeight.constant += 160;
    [self.tvs addObject:tf];
    configurationHandler(tf);
    
    if (didChangeHandler) {
        tf.didChangeCharactersBlock = ^(UITextView * _Nonnull textField) {
            didChangeHandler(textField);
        };
    }
}

- (void)didChange:(UITextField *)textField{
    void (^handler)(UITextField *)  = self.handlers[[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    if (handler) {
        handler(textField);
    }
}
- (void)tapAction:(UIButton *)sender{
    
    void (^handler)(UIButton *)  = self.handlers[sender.currentTitle];
    !(handler)? : handler(sender);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (NSArray<UITextField *> *)textFields{
    return _tfs;
}

- (NSArray<UIButton *> *)buttons{
    return _actions;
}

- (NSArray<ZZTextView *> *)textViews{
    return _tvs;
}
@end



@interface ZZTextView ()<UITextViewDelegate>

@end

@implementation ZZTextView{
    UILabel *_placeholderLabel;
    UITextView *_textField;
    UILabel *_maxLengthLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maxLength = 80;
        
        UITextView *textField = [[UITextView alloc] init];
        [self addSubview:textField];
        textField.font = [UIFont systemFontOfSize:14.0];
        textField.delegate = self;
        _textField = textField;
        
        [textField setLyButtom:^(LayoutModel * _Nonnull layout) {
            layout.constant = -6;
        }];
        [textField setLyTop:^(LayoutModel * _Nonnull layout) {
            layout.constant = 6;
        }];
        [textField setLyleft:^(LayoutModel * _Nonnull layout) {
            layout.constant = 8;
        }];
        [textField setLyRight:^(LayoutModel * _Nonnull layout) {
            layout.constant = -8;
        }];
        
        UILabel *placeholderLB = [[UILabel alloc] init];
        [self addSubview:placeholderLB];
        _placeholderLabel = placeholderLB;
        placeholderLB.numberOfLines = 0;
        placeholderLB.font = [UIFont systemFontOfSize:14.0];
        placeholderLB.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];

        [placeholderLB setLyleft:^(LayoutModel * _Nonnull layout) {
            layout.constant = 12;
        }];
        [placeholderLB setLyTop:^(LayoutModel * _Nonnull layout) {
            layout.constant = 14;
        }];
        [placeholderLB setLyRight:^(LayoutModel * _Nonnull layout) {
            layout.constant = -12;
        }];
        
        UILabel *maxLengthLabel = [[UILabel alloc] init];
        [self addSubview:maxLengthLabel];
        _maxLengthLabel = maxLengthLabel;
        maxLengthLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        maxLengthLabel.text = [NSString stringWithFormat:@"%ld",(long)_maxLength];
        maxLengthLabel.font = [UIFont systemFontOfSize:12.0];
        maxLengthLabel.textAlignment = NSTextAlignmentRight;
        
        [maxLengthLabel setLyButtom:^(LayoutModel * _Nonnull layout) {
            layout.constant = -14;
        }];
        [maxLengthLabel setLyRight:^(LayoutModel * _Nonnull layout) {
            layout.constant = -12;
        }];
        
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (void)textViewDidChange:(UITextView *)textView{
    _placeholderLabel.hidden = textView.hasText;
    _maxLengthLabel.text = [NSString stringWithFormat:@"%lu",_maxLength - textView.text.length];
    !(_didChangeCharactersBlock)? : _didChangeCharactersBlock(textView);

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location>=_maxLength){
        return NO;
    }
    return YES;
}

- (BOOL)becomeFirstResponder{
    return [_textField becomeFirstResponder];
}


- (NSString *)text{
    return _textField.text;
}
@end
