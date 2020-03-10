//
//  YHProjectCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHProjectCell.h"
#import "YHCommon.h"
@interface YHProjectCell ()
@property (weak, nonatomic) IBOutlet UILabel *decsL;
@property (weak, nonatomic) IBOutlet UIImageView *selF;
@property (weak, nonatomic) IBOutlet UILabel *valueL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *brandL;
@property (weak, nonatomic) IBOutlet UILabel *packageL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UIButton *stateB;

@end

@implementation YHProjectCell
- (void)loadSearchKey:(NSString *)info{
    _decsL.text = info;
}

- (void)loadData:(NSDictionary *)info isRepair:(BOOL)isRepair isSel:(BOOL)isSel{
    NSString *name = info[@"projectName"];
    if (!name) {
        name = info[@"partsName"];
    }
    if (!name) {
        name = info[@"repairProjectName"];
    }
    if (!name) {
        name = info[@"actionName"];
    }
    _decsL.text = name;
    if (isRepair) {
        NSNumber *sel = info[@"sel"];
        if (sel) {
            NSDictionary *item = _repairActionData[sel.integerValue];
            NSString *actionName = item[@"actionName"];
            _valueL.text = ((actionName)? (item[@"actionName"]) : (@""));
        }else{
            _valueL.text = @"";
        }
        _selF.image = [UIImage imageNamed:@"me_7"];
    }else{
        _selF.image = [UIImage imageNamed:((isSel)? (@"order_16") : (@"order_15"))];
    }
    
}

- (void)loadExtrendData:(NSDictionary *)info model:(YHExtrendModel)model {
    _nameL.text = info[@"userName"];
    _numberL.text = [NSString stringWithFormat:@"%@%@ %@", info[@"plateNumberP"],info[@"plateNumberC"],info[@"plateNumber"]];
    _phoneL.text = info[@"phone"];
    _brandL.text = [NSString stringWithFormat:@"%@ %@",info[@"carBrandName"],info[@"carLineName"]];
//    _packageL.text = EmptyStr(info[@"warrantyPackageTitle"]);
    _packageL.text = EmptyStr(info[@"sortName"]);
    _dateL.text = [NSString stringWithFormat:@"%@ %@", ((model == YHExtrendModelAudited) ? (@"生效时间") : (@"生成时间")), ((model == YHExtrendModelAudited) ? (info[@"beginEffectiveTime"]) : (info[@"addTime"]))];
    
//    绿  已生效 1
//    
//    
//    灰 已过期 4
//    
//    红 未支付 -1
//    待补充资料 0
//    待审核 3
//    审核不通过 2
    
    _stateB.hidden = NO;
    if ([info[@"status"] isEqualToString:@"1"]) {
        [_stateB setBackgroundColor:YHColor(0X25, 0XAF, 0X73)];
        _stateB.titleLabel.text = @"已生效";
        [_stateB setTitle:@"已生效" forState:UIControlStateNormal];
    }
    
    if ([info[@"status"] isEqualToString:@"4"]) {
        [_stateB setBackgroundColor:[UIColor blackColor]];
        _stateB.titleLabel.text = @"已过期";
        [_stateB setTitle:@"已过期" forState:UIControlStateNormal];
    }
    
    if ([info[@"status"] isEqualToString:@"-1"]) {
        [_stateB setBackgroundColor:[UIColor redColor]];
        _stateB.titleLabel.text = @"未支付";
        [_stateB setTitle:@"未支付" forState:UIControlStateNormal];
    }
    if ([info[@"status"] isEqualToString:@"0"]) {
        [_stateB setBackgroundColor:[UIColor redColor]];
        _stateB.titleLabel.text = @"待补充资料";
        [_stateB setTitle:@"待补充资料" forState:UIControlStateNormal];
    }
    if ([info[@"status"] isEqualToString:@"3"]) {
        [_stateB setBackgroundColor:[UIColor redColor]];
        _stateB.titleLabel.text = @"待审核";
        [_stateB setTitle:@"待审核" forState:UIControlStateNormal];
    }
    if ([info[@"status"] isEqualToString:@"2"]) {
        [_stateB setBackgroundColor:[UIColor redColor]];
        _stateB.titleLabel.text = @"审核不通过";
        [_stateB setTitle:@"审核不通过" forState:UIControlStateNormal];
    }
    
    if ([info[@"status"] isEqualToString:@"9"]) {
        _stateB.hidden = YES;
    }
}

- (void)loadData:(NSDictionary *)info isRepair:(BOOL)isRepair{
    
    NSNumber *sel = info[@"sel"];
    [self loadData:info isRepair:isRepair isSel:sel.boolValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
