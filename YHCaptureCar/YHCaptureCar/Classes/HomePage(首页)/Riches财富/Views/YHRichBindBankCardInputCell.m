//
//  YHRichBindBankCardInputCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichBindBankCardInputCell.h"

@interface YHRichBindBankCardInputCell()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UITextField *inputTft;

@property (nonatomic, weak) UIImageView *arrowImgV;

@property (nonatomic, weak) UILabel *rightTitleL;

@end

@implementation YHRichBindBankCardInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initInputCell];
    }
    return self;
}
- (void)initInputCell{
    
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:16.0];
    titleL.textColor = [UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0];
    self.titleL = titleL;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@16);
    }];
    
    UITextField *inputTft = [[UITextField alloc] init];
    inputTft.delegate = self;
    inputTft.font = [UIFont systemFontOfSize:16.0];
    inputTft.textAlignment = NSTextAlignmentRight;
    self.inputTft = inputTft;
    [self addSubview:inputTft];
    [inputTft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(inputTft.superview).offset(-16);
        make.left.equalTo(titleL.mas_right);
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    self.arrowImgV = arrowImgV;
    arrowImgV.image = [UIImage imageNamed:@"order_3"];
    [arrowImgV sizeToFit];
    [self addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-16));
        make.centerY.equalTo(arrowImgV.superview);
    }];
    
    UILabel *rightTitleL = [[UILabel alloc] init];
    rightTitleL.font = [UIFont systemFontOfSize:16.0];
    rightTitleL.textColor = [UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0];
    self.rightTitleL = rightTitleL;
    [self addSubview:rightTitleL];
    [rightTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImgV.mas_left).offset(-5);
        make.centerY.equalTo(arrowImgV);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange) name:UITextFieldTextDidChangeNotification object:inputTft];

}

- (void)textFieldContentChange{
    
    [self.info setValue:self.inputTft.text forKey:@"subtitle"];
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    
    self.titleL.text = info[@"title"];
    self.inputTft.placeholder = [NSString stringWithFormat:@"请输入%@",info[@"title"]];
    self.rightTitleL.text = info[@"subtitle"];
  
    self.inputTft.hidden = [info[@"isArrow"] isEqualToString:@"YES"] ? YES :NO;
    self.rightTitleL.hidden = !self.inputTft.hidden;
    self.arrowImgV.hidden = !self.inputTft.hidden;
    
    if ([info[@"isArrow"] isEqualToString:@"NO"] && ![info[@"subtitle"] isEqualToString:@""]) {
        self.inputTft.text = info[@"subtitle"];
    }
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}
@end
