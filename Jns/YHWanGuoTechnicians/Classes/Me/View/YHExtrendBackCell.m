//
//  YHExtrendBackCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendBackCell.h"
#import "YHCommon.h"
@interface YHExtrendBackCell ()
@property (weak, nonatomic) IBOutlet UILabel *backL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *carNumberL;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberL;
@property (weak, nonatomic) IBOutlet UILabel *carTypeL;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (weak, nonatomic) IBOutlet UIButton *packageL;

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@end
@implementation YHExtrendBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info model:(YHExtrendBackModel)model{
    if (model == YHExtrendBackModelUn || model == YHExtrendBackModelPart) {
        [_backL setTextColor:YHNaviColor];
        [_priceL setTextColor:YHNaviColor];
    }else{
        [_backL setTextColor:YHCellColor];
        [_priceL setTextColor:YHCellColor];
    }
    
    if (model == YHExtrendBackModelUn) {
        _priceL.text = info[@"tradingTime"];
        _dateL.text = @"交易时间";
    }else{
        _dateL.text = @"返现时间";
        _priceL.text = info[@"wmPredictTime"];
    }
    
    _priceL.hidden = (model == YHExtrendBackModelAll);
    _dateL.hidden = (model == YHExtrendBackModelAll);
    
    _backL.text = [NSString stringWithFormat:@"¥%@", info[@"seviceCharge"]];
    _carNumberL.text = info[@"plateNumber"];
    _phoneNumberL.text = info[@"customerPhone"];
    _carTypeL.text = info[@"carModelFullName"];
    _vinL.text = info[@"vin"];
    
    _packageL.layer.borderWidth  = 1;
    _packageL.layer.borderColor  = YHLineColor.CGColor;
    _packageL.titleLabel.text = info[@"warrantyName"];
    [_packageL setTitle:info[@"warrantyName"] forState:UIControlStateNormal];
    
}
@end
