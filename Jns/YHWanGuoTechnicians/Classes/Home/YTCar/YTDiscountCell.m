//
//  YTDiscountCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTDiscountCell.h"
#import "YTPayModeInfo.h"

#import <Masonry/Masonry.h>

@implementation YTDiscountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = YHColorWithHex(0xF3F3F3);
    }
    return self;
}

- (void)setModel:(YTPayModeInfo *)model{
    _model = model;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //if (model.discount_info.count) {
    if (!IsEmptyStr(model.product_name)) {

        UIView *box = [UIView new];
        [self.contentView addSubview:box];
        box.backgroundColor = [UIColor whiteColor];
        [box mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];

        UILabel *totalPriceNameLB = [[UILabel alloc] init];
        [box addSubview:totalPriceNameLB];
        totalPriceNameLB.font = [UIFont systemFontOfSize:16];
        totalPriceNameLB.textColor = YHColorWithHex(0x666666);
        totalPriceNameLB.text = [NSString stringWithFormat:@"%@",model.product_name];//@"产品名称原价";
        //totalPriceNameLB.backgroundColor = [UIColor redColor];
        
        [totalPriceNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(box.mas_top).offset(0);
            make.left.mas_equalTo(box.mas_left).offset(12);
            make.height.mas_equalTo(16);
        }];
        
        UILabel *totalPriceLB = [[UILabel alloc] init];
        [box addSubview:totalPriceLB];
        totalPriceLB.font = [UIFont systemFontOfSize:16];
        totalPriceLB.textColor = YHColorWithHex(0x666666);
        totalPriceLB.text = [NSString stringWithFormat:@"%@元",model.total_price];
        //totalPriceLB.backgroundColor = [UIColor redColor];
        
        [totalPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(box.mas_right).offset(-12);
            make.centerY.mas_equalTo(totalPriceNameLB.mas_centerY).offset(0);
        }];
        
        __block UIView *topView = totalPriceNameLB;
        __block CGFloat topOffset = 16;
        [model.discount_info enumerateObjectsUsingBlock:^(YTDiscount * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            UILabel *nameLB = [[UILabel alloc] init];
            [box addSubview:nameLB];
            nameLB.font = [UIFont systemFontOfSize:16];
            nameLB.textColor = YHColorWithHex(0x999999);
            nameLB.text = obj.discount_name;
            //nameLB.backgroundColor = [UIColor orangeColor];
            
            [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topView.mas_bottom).offset(topOffset);
                make.left.mas_equalTo(box.mas_left).offset(12);
                make.height.mas_equalTo(16);
            }];
            
            UILabel *discountPriceLB = [[UILabel alloc] init];
            [box addSubview:discountPriceLB];
            discountPriceLB.font = [UIFont systemFontOfSize:16];
            discountPriceLB.textColor = YHColorWithHex(0x999999);
            discountPriceLB.text = [NSString stringWithFormat:@"-%@元",obj.discount_price];
            //discountPriceLB.backgroundColor = [UIColor redColor];

            [discountPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.centerY.mas_equalTo(nameLB.mas_centerY);
            }];

            topView = nameLB;
            topOffset = 12;
        }];
        
        UIView *lineView = [UIView new];
        [box addSubview:lineView];
        lineView.backgroundColor = YHColorWithHex(0xF3F3F3);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).offset(12);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];


        UILabel *discountNameLB = [[UILabel alloc] init];
        [box addSubview:discountNameLB];
        discountNameLB.font = [UIFont systemFontOfSize:16];
        discountNameLB.textColor = YHColorWithHex(0x666666);
        discountNameLB.text = @"合计";
        //discountNameLB.backgroundColor = [UIColor redColor];

        [discountNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(16);
        }];

        UILabel *discountPriceLB = [[UILabel alloc] init];
        [box addSubview:discountPriceLB];
        discountPriceLB.font = [UIFont systemFontOfSize:16];
        discountPriceLB.textColor = YHColorWithHex(0x666666);
        discountPriceLB.text = [NSString stringWithFormat:@"%@元",model.price];
        //discountPriceLB.backgroundColor = [UIColor redColor];

        [discountPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(discountNameLB.mas_centerY);
        }];


    }
    
}

@end
