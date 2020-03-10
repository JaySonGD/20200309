//
//  YHInventoryListCell.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHInventoryListCell.h"

#import <UIImageView+WebCache.h>

#import "TTZCarModel.h"

//#import "YHNetworkManager.h"
#import "YHCommon.h"

@interface YHInventoryListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagIV;
@property (weak, nonatomic) IBOutlet UIImageView *carPictureIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLB;
@property (weak, nonatomic) IBOutlet UILabel *useTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *mileageBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carPictureLeft;


@property (weak, nonatomic) IBOutlet UIButton *reasonB;

@property (weak, nonatomic) IBOutlet UILabel *browseNumLB;
@property (weak, nonatomic) IBOutlet UILabel *browseName;

@end

@implementation YHInventoryListCell

- (IBAction)clickReasonB:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
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
    
    //0 库存 1 拍卖 2 帮卖 5 帮买
    
    self.statusLB.text = (model.carStatus>2)? @"帮买": ( (model.carStatus>1)? @"帮卖" : (model.carStatus? @"拍卖" : @"库存") );//model.status? ((model.status>1)? @"帮卖" :@"竞价" ) : @"库存";
    self.statusLB.textColor = (model.carStatus == 1)? YHColor0X(0xD4502C, 1.0) : YHNaviColor;
    self.priceLB.textColor = (model.carStatus == 1)? YHColor0X(0xD4502C, 1.0) : YHNaviColor;
    
    if (!IsEmptyStr(model.remark)) {
        self.reasonB.hidden = NO;
    } else {
        self.reasonB.hidden = YES;
    }
    
    self.browseName.hidden = IsEmptyStr(model.browseNum);
    self.browseNumLB.hidden = self.browseName.hidden;
    
    if (!IsEmptyStr(model.browseNum)) {
        self.browseNumLB.text = model.browseNum;
    }
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
