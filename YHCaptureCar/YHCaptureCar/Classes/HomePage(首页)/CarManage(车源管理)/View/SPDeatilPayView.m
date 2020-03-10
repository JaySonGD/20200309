//
//  SPDeatilPayView.m
//  YHCaptureCar
//
//  Created by Jay on 10/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "SPDeatilPayView.h"

@interface SPDeatilPayView()
@property(nonatomic,getter=isHighlighted,assign) BOOL highlighted;


@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, strong) UILabel *priceTitleLB;
@property (nonatomic, strong) UIView *priceBox;

@end

@implementation SPDeatilPayView

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

- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:14.0];
        _titleLB.textColor = YHColor(85, 85, 85);
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"付费查看报告详情";
    }
    return _titleLB;
}

- (UILabel *)priceLB{
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.textAlignment = NSTextAlignmentCenter;
        _priceLB.text = @"付费查";
    }
    return _priceLB;
}

- (UILabel *)priceTitleLB{
    if (!_priceTitleLB) {
        _priceTitleLB = [[UILabel alloc] init];
        _priceTitleLB.font = [UIFont systemFontOfSize:10.0];
        _priceTitleLB.textColor = [UIColor whiteColor];
        _priceTitleLB.backgroundColor = YHColor(213, 78, 44);
        _priceTitleLB.textAlignment = NSTextAlignmentCenter;
        _priceTitleLB.text = @"\t活动价\t";
        YHViewRadius(_priceTitleLB, 5);
    }
    return _priceTitleLB;
}

- (UIView *)priceBox{
    if (!_priceBox) {
        _priceBox = [[UIView alloc] init];
        [_priceBox addSubview:self.priceTitleLB];
        [_priceBox addSubview:self.priceLB];
        

        [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(_priceBox);
        }];
        [self.priceTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_priceBox);
            make.centerY.mas_equalTo(_priceLB);
            make.right.mas_equalTo(_priceLB.mas_left).offset(-5);
            make.height.mas_equalTo(20);
        }];
    }
    return _priceBox;
}


- (void)setUI{
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.priceBox];
    [self.priceBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLB.mas_bottom);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);

    }];
}
- (void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    if (highlighted) {
        self.backgroundColor = YHNaviColor;
        self.titleLB.textColor = [UIColor whiteColor];
        
        self.priceTitleLB.textColor = YHNaviColor;
        self.priceTitleLB.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.titleLB.textColor = YHColor(85, 85, 85);
        self.priceTitleLB.textColor = [UIColor whiteColor];
        self.priceTitleLB.backgroundColor = YHColor(213, 78, 44);
    }
    
    self.price = _price;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    
    UIColor *highlightedColor = [UIColor whiteColor];
    UIColor *normalColor = YHNaviColor;

    if (!IsEmptyStr(self.activityPrice)) {
        self.priceTitleLB.text = @"\t活动价\t";
        NSString *price = [NSString stringWithFormat:@"¥%@",self.price];
        NSString *activityPrice = [NSString stringWithFormat:@"¥%@",self.activityPrice];
        NSString *priceStr = [NSString stringWithFormat:@"%@ %@",activityPrice,price];
        
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSRange priceRange = NSMakeRange(activityPrice.length+1, price.length);
        NSRange activityPriceRange = NSMakeRange(0, activityPrice.length);

        [priceAtt addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:priceRange];
        [priceAtt addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:priceRange];
        [priceAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:priceRange];
        [priceAtt addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:priceRange];
        
        [priceAtt addAttribute:NSForegroundColorAttributeName value:self.highlighted?highlightedColor:normalColor range:activityPriceRange];
        self.priceLB.attributedText = priceAtt;

    }else{
        self.priceTitleLB.text = nil;
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",self.price];
        
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSRange priceRange = [priceStr rangeOfString:priceStr];

        [priceAtt addAttribute:NSForegroundColorAttributeName value:self.highlighted?highlightedColor:normalColor range:priceRange];
        self.priceLB.attributedText = priceAtt;

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.highlighted = YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.highlighted = NO;
    !(_tapBlock)? : _tapBlock();

}

@end
