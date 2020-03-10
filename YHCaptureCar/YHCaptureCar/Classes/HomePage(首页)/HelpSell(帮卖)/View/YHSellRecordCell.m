//
//  YHSellRecordCell.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHSellRecordCell.h"
#import <UIImageView+WebCache.h>

#import "TTZCarModel.h"

#import "YHCommon.h"


@interface YHSellRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagIV;
@property (weak, nonatomic) IBOutlet UIImageView *carPictureIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLB;
@property (weak, nonatomic) IBOutlet UILabel *useTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *mileageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusIV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carPictureLeft;


@end

@implementation YHSellRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TTZCarModel *)model
{
    _model = model;
    //self.carPictureLeft.constant = model.flag ? 21 : 16;
    
    self.flagIV.hidden = !model.flag;
    
//    NSString *carPictureURL = model.flag? [NSString stringWithFormat:@"%@%@",SERVER_JAVA_IMAGE_URL,model.carPicture] :[NSString stringWithFormat:@"%@%@",SERVER_JAVA_NonAuthentication_IMAGE_URL,model.carPicture];
    
    [self.carPictureIV sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];
    
    self.carNameLB.text = model.carName;
    
    self.priceLB.text = model.price;//model.price.length ? [NSString stringWithFormat:@"%@万",[self formatFloat:[model.price floatValue]]] : @"面议";
    
    self.mileageBtn.text = [NSString stringWithFormat:@"%@万 km",[self formatFloat:[model.mileage floatValue]/10000]];
    
    if (model.useTime.length) {
        self.useTimeBtn.text = [NSString stringWithFormat:@"%@",model.useTime];
    }else{
        self.useTimeBtn.text = @"年限未设置";
    }
    
    //状态 1、拍卖成功  2、销售成功
    NSString *imageName = (model.carStatus == 1)? @"拍卖成功" : @"销售成功";
    self.statusIV.image = [UIImage imageNamed:imageName];

    self.priceLB.textColor = (model.carStatus == 1)? YHColor0X(0xD4502C, 1.0) : YHNaviColor;
    
}

- (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}



@end
