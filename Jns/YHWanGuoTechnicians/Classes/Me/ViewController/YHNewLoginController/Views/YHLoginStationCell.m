//
//  YHLoginStationCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHLoginStationCell.h"

@interface YHLoginStationCell ()

@property (nonatomic, weak) UILabel *stationNameL;

@property (nonatomic, weak) UILabel *stationAddressL;

@property (nonatomic, weak) UILabel *orderCountL;

@property (nonatomic, weak) UIView *motherView;

@end

@implementation YHLoginStationCell

+ (instancetype)createLoginStationCelltableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    
    YHLoginStationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[YHLoginStationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCellUI];
    }
    return self;
}
- (void)initCellUI{
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *motherView = [[UIView alloc] init];
    motherView.backgroundColor = [UIColor redColor];
    self.motherView = motherView;
    motherView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [self.contentView addSubview:motherView];
    [motherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@0);
        make.width.equalTo(motherView.superview).offset(-40);
        make.height.equalTo(motherView.superview).offset(-10);
    }];
    
    //站点名称
    UILabel *stationNameL = [[UILabel alloc] init];
    //stationNameL.backgroundColor = [UIColor orangeColor];
    stationNameL.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
    stationNameL.textAlignment = NSTextAlignmentLeft;
    stationNameL.font = [UIFont systemFontOfSize:17.0];
    self.stationNameL = stationNameL;
    [motherView addSubview:stationNameL];
    
    //站点地址
    UILabel *stationAddressL = [[UILabel alloc] init];
    //stationAddressL.backgroundColor = [UIColor redColor];
    stationAddressL.font = [UIFont systemFontOfSize:17.0];
    stationAddressL.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
    stationAddressL.textAlignment = NSTextAlignmentCenter;
    self.stationAddressL = stationAddressL;
    [motherView addSubview:stationAddressL];
    
    //预约订单数量
    UILabel *orderCountL = [[UILabel alloc] init];
    //orderCountL.backgroundColor = [UIColor yellowColor];
    orderCountL.font = [UIFont systemFontOfSize:17.0];
    orderCountL.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
    orderCountL.textAlignment = NSTextAlignmentRight;
    self.orderCountL = orderCountL;
    [motherView addSubview:orderCountL];
}

- (void)setInfo:(NSDictionary *)info{
    
    NSLog(@"===========---%@---===========",info);
    
    _info = info;
    self.stationNameL.text = info[@"shop_name"];
    self.stationAddressL.text = info[@"url_code"];
    
    
    if (!IsEmptyStr([info[@"xhjc_booking_num"] stringValue]) && ![[info[@"xhjc_booking_num"] stringValue] isEqualToString:@"0"]) {
        self.orderCountL.text = [NSString stringWithFormat:@"%@预约",[info[@"xhjc_booking_num"] stringValue]];
    } else {
        self.orderCountL.text = @"";
    }

    
    //预约订单数量
    [self.orderCountL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.motherView).offset(0);
        make.right.equalTo(self.motherView).offset(-10);
        make.bottom.equalTo(self.motherView).offset(0);
        make.width.equalTo(@70);
    }];
    
    //站点地址
    //[self.stationAddressL sizeToFit];
    [self.stationAddressL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderCountL.mas_left).offset(0);
        make.top.equalTo(self.motherView).offset(0);
        make.width.equalTo(@60);
        make.bottom.equalTo(self.motherView).offset(0);
    }];
    
    //站点名称
    [self.stationNameL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.motherView).offset(10);
        make.right.equalTo(self.stationAddressL.mas_left).offset(0);
        make.top.equalTo(self.motherView).offset(0);
        make.bottom.equalTo(self.motherView).offset(0);
    }];
    
    if (![[info[@"xhjc_booking_num"]stringValue] isEqualToString:@"0"]) {
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.motherView setRounded:self.motherView.bounds corners:UIRectCornerAllCorners radius:10.0];
    });
}
@end
