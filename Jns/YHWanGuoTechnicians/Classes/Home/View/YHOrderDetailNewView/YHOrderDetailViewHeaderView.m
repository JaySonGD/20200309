//
//  YHOrderDetailViewHeaderView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailViewHeaderView.h"
#import "UIView+add.h"


@interface YHOrderDetailViewHeaderView ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, weak) UIImageView *arrowImageV;

@end

@implementation YHOrderDetailViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initHeaderViewUI];
    }
    return self;
}
- (void)initHeaderViewUI{
    
    
    UIView *view = [[UIView alloc] init];
    self.view = view;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.top.equalTo(@0);
        make.left.equalTo(@8);
        make.right.equalTo(view.superview).offset(-8);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    self.titleL = titleL;
    titleL.font = [UIFont systemFontOfSize:15.5];
    titleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@18);
        make.centerY.equalTo(titleL.superview);
    }];
    
    UIView *seprateLineOne = [[UIView alloc] init];
    seprateLineOne.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [view addSubview:seprateLineOne];
    [seprateLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(seprateLineOne.superview);
        make.height.equalTo(@1);
        make.bottom.equalTo(seprateLineOne.superview).offset(-1);
        make.left.equalTo(@0);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.top.equalTo(view.mas_bottom);
        make.right.equalTo(contentView.superview).offset(-8);
        make.left.equalTo(@8);
    }];
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = [UIImage imageNamed:@"carAll"];
    [contentView addSubview:iconImageV];
    [iconImageV sizeToFit];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(iconImageV.superview);
    }];
    
    UILabel *contenttitleL = [[UILabel alloc] init];
    contenttitleL.text = @"车辆外观图片";
    contenttitleL.font = [UIFont systemFontOfSize:15.5];
    contenttitleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    [contentView addSubview:contenttitleL];
    [contenttitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contenttitleL.superview);
        make.width.equalTo(@150);
        make.left.equalTo(iconImageV.mas_right).offset(10);
        make.centerY.equalTo(contenttitleL.superview);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCarPictureViewController)];
    UIImageView *arrowImageV = [[UIImageView alloc] init];
    self.arrowImageV = arrowImageV;
    arrowImageV.userInteractionEnabled = YES;
    arrowImageV.image = [UIImage imageNamed:@"home_4"];
    [contentView addSubview:arrowImageV];
    [arrowImageV sizeToFit];
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageV.superview).offset(-8);
        make.centerY.equalTo(arrowImageV.superview);
    }];
    [arrowImageV addGestureRecognizer:tapGes];
    
    UILabel *indicateL = [[UILabel alloc] init];
    self.indicateL = indicateL;
    indicateL.font = [UIFont systemFontOfSize:15.0];
    indicateL.userInteractionEnabled = YES;
    indicateL.textAlignment = NSTextAlignmentRight;
    indicateL.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    indicateL.text = @"未上传";
    [contentView addSubview:indicateL];
    [indicateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageV.mas_left).offset(-10);
        make.height.equalTo(indicateL.superview);
        make.width.equalTo(@64);
        make.top.equalTo(@0);
    }];
    [indicateL addGestureRecognizer:tapGes];
    
    UIView *seprateLineTwo = [[UIView alloc] init];
    seprateLineTwo.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [contentView addSubview:seprateLineTwo];
    [seprateLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(seprateLineTwo.superview);
        make.height.equalTo(@1);
        make.bottom.equalTo(seprateLineTwo.superview).offset(-1);
        make.left.equalTo(@0);
    }];
    
}

-(void)setIsCar:(BOOL)isCar{
    
       UIView *view = [[UIView alloc] init];
       view.backgroundColor = [UIColor whiteColor];
       [self addSubview:view];
       [view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(@8);
           make.right.equalTo(view.superview).offset(-8);
           make.height.equalTo(@72);
           make.top.equalTo(self.view.mas_bottom);
       }];
    
      UILabel *indicateL = [[UILabel alloc] init];
       indicateL.font = [UIFont systemFontOfSize:14.5];
       indicateL.textColor = [UIColor colorWithHexString:@"0x666666"];
       indicateL.text = @"承保部件";
       [view addSubview:indicateL];
       [indicateL mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(@18);
           make.top.equalTo(@12);
       }];
    
    UIImageView *v1 = [[UIImageView alloc]initWithImage:[YHOrderDetailViewHeaderView imageWithColor:[UIColor colorWithHexString:@"#F9BC2D"]]];
    [view addSubview:v1];
    v1.layer.masksToBounds = YES;
    v1.layer.cornerRadius = 10;
    
    UIImageView *v2 = [[UIImageView alloc]initWithImage:[YHOrderDetailViewHeaderView imageWithColor:[UIColor colorWithHexString:@"#FF8B3E"]]];
       [view addSubview:v2];
    
    UIImageView *v3 = [[UIImageView alloc]initWithImage:[YHOrderDetailViewHeaderView imageWithColor:[UIColor colorWithHexString:@"#FB3537"]]];
    [view insertSubview:v3 atIndex:0];
    v3.layer.masksToBounds = YES;
    v3.layer.cornerRadius = 10;

   UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"轻微",@"中度",@"重度"]];
   UIFont *font = [UIFont systemFontOfSize:12];
   segment.tintColor = [UIColor clearColor];
   NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
   segment.userInteractionEnabled = NO;
   [view addSubview:segment];
   [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicateL.mas_bottom).offset(8);
        make.width.equalTo(@(3*101));
        make.height.equalTo(@(20));
        make.centerX.offset(0);
    }];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(segment.mas_left);
        make.top.equalTo(indicateL.mas_bottom).offset(8);
        make.width.equalTo(@(111));
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_right).offset(-10);
        make.top.equalTo(indicateL.mas_bottom).offset(8);
        make.width.equalTo(@(101));
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v2.mas_right).offset(-10);
        make.top.equalTo(indicateL.mas_bottom).offset(8);
        make.width.equalTo(@(111));
    }];
        
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 101.0f, 20.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)hideBottomContentView:(BOOL)hide{
    
//    self.contentView.hidden = hide;
//    for (UIView *subView in self.contentView.subviews) {
//        subView.hidden = hide;
//    }
    
    [self.contentView removeFromSuperview];
    
}
- (void)modifyContentViewHeight:(CGFloat)height{
    
    if (height == 0) {
        self.contentView.hidden = YES;
    }else{
        self.contentView.hidden = NO;
        self.indicateL.userInteractionEnabled = YES;
        self.arrowImageV.userInteractionEnabled = YES;
    }
    
//    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.height.equalTo(@(height));
//        make.top.equalTo(self.view.mas_bottom);
//        make.right.equalTo(self.contentView.superview).offset(-8);
//        make.left.equalTo(@8);
//        
//    }];
}

- (void)setTitleLableTextContent:(NSString *)text{
    
    self.titleL.text = text;
    [self.titleL sizeToFit];
    
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@18);
        make.centerY.equalTo(self.titleL.superview);
    }];
}

- (void)enterCarPictureViewController{
    
    if (_indicateBtnClickBlock) {
        _indicateBtnClickBlock();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.view setRounded:self.view.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
    
}

@end
