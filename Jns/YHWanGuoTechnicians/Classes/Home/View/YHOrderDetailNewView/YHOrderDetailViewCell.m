//
//  YHOrderDetailViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailViewCell.h"

@interface YHOrderDetailViewCell ()

@property (nonatomic, weak) UIImageView *iconImageV;

@property (nonatomic, weak) UIImageView *arrowImageV;

@property (nonatomic, weak) UISwitch *mySwitch;

@property (nonatomic, weak) UILabel *titleL;

@end

@implementation YHOrderDetailViewCell

+ (instancetype)createOrderDetailViewCell:(UITableView *)tableView{
    
    static NSString *cellID = @"YHOrderDetailViewCellID";
    YHOrderDetailViewCell *orderDetailCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!orderDetailCell) {
        orderDetailCell = [[YHOrderDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        orderDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return orderDetailCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
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
    
    UIImageView *arrowImageV = [[UIImageView alloc] init];
    arrowImageV.image = [UIImage imageNamed:@"home_4"];
    self.arrowImageV = arrowImageV;
    [arrowImageV sizeToFit];
    [self.contentView addSubview:arrowImageV];
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleL);
        make.right.equalTo(arrowImageV.superview).offset(-8);
    }];
    
    UILabel *checkL = [[UILabel alloc] init];
    checkL.font = [UIFont systemFontOfSize:15.0];
    checkL.textAlignment = NSTextAlignmentRight;
    checkL.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    self.checkL = checkL;
    [self.contentView addSubview:checkL];
    [checkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL);
        make.right.equalTo(arrowImageV.mas_left).offset(-10);
//        make.width.equalTo(@75);
        make.height.equalTo(titleL);
    }];
    
    UISwitch *mySwitch = [[UISwitch alloc] init];
    [mySwitch addTarget:self action:@selector(onOffEventTouch:) forControlEvents:UIControlEventValueChanged];
    mySwitch.onTintColor = YHNaviColor;
    self.mySwitch = mySwitch;
    [self.contentView addSubview:mySwitch];
    [mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkL.mas_left);
        make.centerY.equalTo(titleL.mas_centerY);
    }];
    
}

- (void)setIsEnableForSwitch:(BOOL)isEnableForSwitch{
    _isEnableForSwitch = isEnableForSwitch;
    _mySwitch.userInteractionEnabled = isEnableForSwitch;
}

- (void)setIsOnOffSwitch:(BOOL)isOnOffSwitch{
    
    _isOnOffSwitch = isOnOffSwitch;
    self.mySwitch.on = isOnOffSwitch;
    
}

- (void)onOffEventTouch:(UISwitch *)onOffSwh{
   
    if (_onOffSwitchTouchEvent) {
        _onOffSwitchTouchEvent(_cellModel.Id,onOffSwh.on);
    }
}

- (void)setType:(YHOrderDetailViewCellType)type{
    
    if (type == YHOrderDetailViewCellTypeSwitch) {
        self.mySwitch.hidden = NO;
        self.arrowImageV.hidden = YES;
        self.checkL.hidden = YES;
    }
    
    if (type == YHOrderDetailViewCellTypeArrow) {
        self.mySwitch.hidden = YES;
        self.arrowImageV.hidden = NO;
        self.checkL.hidden = YES;
    }
    
    if (type == YHOrderDetailViewCellTypeArrowAndText) {
        
        self.mySwitch.hidden = YES;
        self.arrowImageV.hidden = NO;
        self.checkL.hidden = NO;
    }
    
    if ([_cellModel.code isEqualToString:@"oil"]) {
        self.checkL.hidden = YES;
        self.arrowImageV.hidden = YES;
    }
}

- (void)setOrderIdType:(NSString *)orderIdType{
    _orderIdType = orderIdType;
    
//    if ([orderIdType isEqualToString:@"J003"]) {
//        self.checkL.hidden = YES;
//        self.arrowImageV.hidden = YES;
//        self.mySwitch.hidden = NO;
//    }else{
//
//        self.checkL.hidden = NO;
//        self.arrowImageV.hidden = NO;
//        self.mySwitch.hidden = YES;
//    }
    
}

- (void)setCellModel:(TTZSYSModel *)cellModel{
    _cellModel = cellModel;
    
//    self.iconImageV.image = [UIImage imageNamed:cellInfo[@"icon"]];
    if ([cellModel.className containsString:@"检测"]) {
        self.titleL.text = [NSString stringWithFormat:@"%@",cellModel.className];
    }else{
    self.titleL.text = [NSString stringWithFormat:@"%@检测",cellModel.className];
    }
    self.iconImageV.image = [UIImage imageNamed:cellModel.Id];
    if ([cellModel.code isEqualToString:@"oil"]) {
        self.checkL.hidden = YES;
        self.arrowImageV.hidden = YES;
    }
   
    
//    NSString *imageName = nil;
//    if ([cellModel.className isEqualToString:@"车身"]) {
//        imageName = @"carBody";
//    }
//    if ([cellModel.className isEqualToString:@"灯光"]) {
//         imageName = @"carLight";
//    }
//    if ([cellModel.className isEqualToString:@"发动机舱"]) {
//         imageName = @"carEngine";
//    }
//    if ([cellModel.className isEqualToString:@"四轮"]) {
//         imageName = @"fourWheels";
//    }
//    if ([cellModel.className isEqualToString:@"底盘"]) {
//         imageName = @"carChassis";
//    }
    
    
    TTZGroundModel *model = _cellModel.list.lastObject;
    TTZSurveyModel *mod = model.list.lastObject;
    
    if(!IsEmptyStr(mod.projectVal) && [self.orderIdType isEqualToString:@"J007"]){//不合格/合格
        
        self.checkL.text =  [mod.projectVal isEqualToString:@"0"] ? @"不合格" : [mod.projectVal isEqualToString:@"1"] ? @"合格" : mod.projectVal;
        
    }else{
        
     if (cellModel.progress > 0) {
        
        if (cellModel.progress *100 < 1) {
             self.checkL.text = [NSString stringWithFormat:@"已检测%d%@",1,@"%"];
        }else{
            
             self.checkL.text = [NSString stringWithFormat:@"已检测%d%@",(int)(cellModel.progress *100),@"%"];
        }
    }else{
        self.checkL.text = @"未检测";
    }
        
    }
    
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.x += 8;
    frame.size.width -= 16;
    [super setFrame:frame];
}

@end
