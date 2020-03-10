//
//  YHOrderDetailViewSupCell.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/10.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailViewSupCell.h"

@interface YHOrderDetailViewSupCell ()

@property (nonatomic, weak) UIImageView *iconImageV;

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UILabel *checkL;

@property (nonatomic, weak) UIButton *arrowBtn;

@end

@implementation YHOrderDetailViewSupCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.frame = frame;
        [self initOrderDetailViewCellUI];
    }
    
    return self;
}

- (void)initOrderDetailViewCellUI{
    
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    self.iconImageV = iconImageV;
    [self.contentView addSubview:iconImageV];
   
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(iconImageV.superview);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:15.0];
    titleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@250);
        make.left.equalTo(@(33 + 20));
//        make.top.equalTo(@20);
        make.centerY.equalTo(iconImageV);
    }];
    
    
    UIImage *backImage = [UIImage imageNamed:@"home_4"];
    //改变该图片的方向
    backImage = [UIImage imageWithCGImage:backImage.CGImage
                                    scale:backImage.scale
                              orientation:UIImageOrientationRight];
    UIImage  *backImage1 = [UIImage imageWithCGImage:backImage.CGImage
          scale:backImage.scale
    orientation:UIImageOrientationLeft];
    
    UIButton *arrowBtn = [[UIButton alloc] init];
    [arrowBtn setImage:backImage forState:UIControlStateNormal];
    [arrowBtn setImage:backImage1 forState:UIControlStateSelected];
    self.arrowBtn = arrowBtn;
    [self.contentView addSubview:arrowBtn];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleL);
        make.right.offset(-8);
    }];
    
    UILabel *checkL = [[UILabel alloc] init];
    checkL.font = [UIFont systemFontOfSize:15.0];
    checkL.textAlignment = NSTextAlignmentRight;
    self.checkL = checkL;
    [self.contentView addSubview:checkL];
    [checkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL);
        make.right.equalTo(arrowBtn.mas_left).offset(-10);
//        make.width.equalTo(@75);
        make.height.equalTo(titleL);
    }];
    
}


- (void)setCellModel:(TTZSYSModel *)cellModel{
    _cellModel = cellModel;
    self.arrowBtn.selected = cellModel.close.intValue == 1;
    if ([cellModel.className containsString:@"检测"]) {
        self.titleL.text = [NSString stringWithFormat:@"%@",cellModel.className];
    }else{
        self.titleL.text = [NSString stringWithFormat:@"%@检测",cellModel.className];
    }
    self.iconImageV.image = [UIImage imageNamed:cellModel.Id];
        
    //问题严重程度：e-未检测 1-正常 0-轻微 2-中等  3-严重",//当为1时 ，显示 检测结果+换行+工程师评估+空格+用车建议;当不为1时，显示detectionResult
    if(([cellModel.status isEqualToString:@"1"] || [cellModel.status isEqualToString:@"e"]) && !cellModel.Sublist.count){
        self.checkL.text = [cellModel.status isEqualToString:@"1"] ? @"正常" : @"未检";
        self.checkL.textColor = [cellModel.status isEqualToString:@"1"] ? [UIColor colorWithHexString:@"0x666666"] : [UIColor colorWithHexString:@"0x999999"];;
        self.arrowBtn.hidden = YES;
        self.userInteractionEnabled = NO;
        [self.checkL mas_updateConstraints:^(MASConstraintMaker *make) {
//                 make.centerY.equalTo(titleL);
                 make.right.offset(-8);
            }];
    }else{
         self.checkL.text = @"异常";
         self.checkL.textColor = [UIColor colorWithRed:246/255.0 green:27/255.0 blue:43/255.0 alpha:1.0];
         
    }
        
}

//- (void)setFrame:(CGRect)frame{
//
//    frame.size.width -= 16;
//    [super setFrame:frame];
//}

@end
