//
//  YHRepairPartTableViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairPartTableViewCell.h"
#import "YHIntelligentCheckModel.h"
#import "oilView.h"

@implementation YHRepairPartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.categoryL.font = [UIFont boldSystemFontOfSize:15.0];
    [self.deletePartsBtn addTarget:self action:@selector(deletePartsBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtn addTarget:self action:@selector(categoryBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.unitTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.unitPriceTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.amountTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.categaryTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileChangeToSource:) name:UITextFieldTextDidEndEditingNotification object:self.brandTF];
    
    [self.prsentBtn addTarget:self action:@selector(prsentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchaseBtn addTarget:self action:@selector(purchaseEvent:) forControlEvents:UIControlEventTouchUpInside];
//    self.isOilNumber = @"0";
}
- (void)purchaseEvent:(UIButton *)btn{
    YHLPCModel *consumableModel = self.cellModel;
    if (self.purchaseOperation) {
        self.purchaseOperation(consumableModel.suggested_info);
    }
}

- (void)prsentBtnClick:(UIButton *)prsentBtn{
    
    prsentBtn.selected = !prsentBtn.selected;
    YHLPCModel *consumableModel = self.cellModel;
    consumableModel.status = !prsentBtn.selected ? @"1" : @"2";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentStatusChange" object:nil];
}

- (void)textFileChangeToSource:(NSNotification *)noti{
    
    UITextField *obj = (UITextField *)noti.object;
    
    NSString *resultText = [obj.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    if ([self.cellModel isKindOfClass:NSClassFromString(@"YTPartModel")] || [self.cellModel isKindOfClass:NSClassFromString(@"YHPartsModel")]) {
       
        YTPartModel *partModel = (YTPartModel *)self.cellModel;
        if (obj == self.unitPriceTft) {
            partModel.part_price = resultText;
        }
        if (obj == self.unitTft) {
            partModel.part_unit = resultText;
        }
        if (obj == self.amountTft) {
            partModel.part_count = resultText;
        }
        
//        if (obj == self.categaryTft) {
////            partModel. = resultText;
//            self.brandTF.enabled = [resultText isEqualToString:@"原厂件"];
//        }
        
        if (obj == self.brandTF) {
            partModel.part_brand = resultText;
        }
    }
    
    if ([self.cellModel isKindOfClass:NSClassFromString(@"YTConsumableModel")] || [self.cellModel isKindOfClass:NSClassFromString(@"YHConsumableModel")]) {
        
        YTConsumableModel *consumableModel = (YTConsumableModel *)self.cellModel;
        if (obj == self.unitPriceTft) {
            consumableModel.consumable_price = resultText;
        }
        
        if (obj == self.unitTft) {
            consumableModel.consumable_unit = resultText;
        }
        if (obj == self.amountTft) {
            consumableModel.consumable_count = resultText;
        }
        if (obj == self.categaryTft) {
            consumableModel.consumable_standard = resultText;
            self.brandTF.enabled = [resultText isEqualToString:@"原厂件"];
        }
        
        if (obj == self.brandTF) {
            consumableModel.consumable_brand = resultText;
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.indexPath forKey:@"indexPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"repairTextChange_notification" object:nil userInfo:dict];
}

- (void)deletePartsBtnClickEvent{
    if (self.removeCallBack) {
        self.removeCallBack(self.indexPath);
    }
}

- (void)setIsHiddenSeprateLine:(BOOL)isHiddenSeprateLine{
    self.seprateLineV.hidden = isHiddenSeprateLine;
}

- (void)setCellModel:(id)cellModel{
    [super setCellModel:cellModel];
  
    self.categaryNameL.text = @"类别";
    if ([cellModel isKindOfClass:NSClassFromString(@"YTPartModel")] || [cellModel isKindOfClass:NSClassFromString(@"YHPartsModel")]) {
        YTPartModel *partModel = (YTPartModel *)cellModel;
        self.categoryL.text = partModel.part_name;
        self.categoryContentL.text = partModel.part_type_name;
        self.unitTft.text = partModel.part_unit;
        NSString *priceText = @"";
        if (!IsEmptyStr(partModel.part_price)) {
            priceText = [NSString stringWithFormat:@"%.2f",[partModel.part_price floatValue]];
        }
        NSString *moneyChar =  !IsEmptyStr(partModel.part_price) ? @"￥" : @"";
        self.unitPriceTft.text = [NSString stringWithFormat:@"%@%@",moneyChar,priceText];
        self.amountTft.text = partModel.part_count;
        self.categoryBtn.userInteractionEnabled = YES;
        
        if (self.isNOCanEdit) {
            self.arrowWidth.constant = 0;
            self.contentRightMargin.constant = 0;
        }
        self.categaryTft.hidden = YES;
        
        self.brandTF.text = partModel.part_brand;
        
        if ([self.cellModel isKindOfClass:NSClassFromString(@"YHPartsModel")]) {
            
            YHPartsModel *partModel = (YHPartsModel *)self.cellModel;
            self.prsentBtn.selected = [partModel.status isEqualToString:@"2"] ? YES : NO;
            self.brandTF.enabled = ![partModel.part_type_name isEqualToString:@"原厂件"];
        }
    }
    
    if ([cellModel isKindOfClass:NSClassFromString(@"YTConsumableModel")] || [cellModel isKindOfClass:NSClassFromString(@"YHConsumableModel")]) {
        
        self.categaryNameL.text = @"规格";
        YTConsumableModel *consumableModel = (YTConsumableModel *)cellModel;
        self.categoryL.text = consumableModel.consumable_name;
        self.categoryContentL.text = consumableModel.consumable_standard;
        self.unitTft.text = consumableModel.consumable_unit;
        NSString *priceText = @"";
        if (!IsEmptyStr(consumableModel.consumable_price)) {
            priceText = [NSString stringWithFormat:@"%.2f",[consumableModel.consumable_price floatValue]];
        }
        NSString *moneyChar = !IsEmptyStr(consumableModel.consumable_price) ? @"￥" : @"";
        self.unitPriceTft.text = [NSString stringWithFormat:@"%@%@",moneyChar,priceText];
        self.amountTft.text = consumableModel.consumable_count;
        self.categoryBtn.userInteractionEnabled = NO;
        self.arrowWidth.constant = 0;
        self.contentRightMargin.constant = 0;
        self.categaryTft.hidden = self.isNOCanEdit ? YES : NO;
        self.categaryTft.text = consumableModel.consumable_standard;
        
        self.brandTF.text = consumableModel.consumable_brand;
    
    }
    
    self.giveVIew.hidden = [self.billType isEqualToString:@"J006"] || [self.billType isEqualToString:@"J008"] || [self.billType isEqualToString:@"J009"] || [self.billType isEqualToString:@"Y002"] || [self.billType isEqualToString:@"A"] || [self.billType isEqualToString:@"J004"] ;
    
    if (self.hasPresent) {
        self.presentViewH.constant = 35;
        self.brandViewH.constant = 35;
    }else{
        self.presentViewH.constant = 0;
        self.brandViewH.constant = 0;
    }
    
    YHLPCModel *consumableModel = (YHLPCModel *)cellModel;
    self.prsentBtn.selected = [consumableModel.status isEqualToString:@"2"] ? YES : NO;
    
    NSInteger count = [consumableModel.suggested_info[@"list"] count];
    if (!count) {
        self.oilNameHeight.constant = 44;
        self.oilContainView.hidden = YES;
        return;
    }

        NSDictionary *dict = consumableModel.suggested_info;
    
        [self.oilDeployTitleL setTitle:dict[@"title"] forState:UIControlStateNormal];
    
        [self.purchaseBtn setTitle: [[NSString stringWithFormat:@"%@",dict[@"pay_status"]] isEqualToString:@"1"] ? @"查看" : @"购买" forState:UIControlStateNormal];
    
        self.purchaseBtn.hidden = [dict[@"pay_status"] boolValue] ? [[NSString stringWithFormat:@"%@",dict[@"show_type"]] isEqualToString:@"1"] : NO ;
    
        NSArray *list = dict[@"list"];
        if ([list isKindOfClass:[NSArray class]]) {
            self.oilContainView.hidden = !list.count;
            
            [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                oilView *view = [[NSBundle mainBundle] loadNibNamed:@"oilView" owner:nil options:nil].firstObject;
                view.oilStyleTitleL.text = obj[@"name"];
                [view.oilModelL setTitle: obj[@"value"] forState:UIControlStateNormal];
                [self.oilView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.oilView).offset(28*idx);
                    make.height.offset(28);
                    make.width.equalTo(self.oilContainView);
                }];
                
            }];
            
            self.oilNameHeight.constant = list.count * 28 + 88;
        }
    
}

- (void)categoryBtnClickEvent{
    
    if (self.selectClassClickEvent) {
        self.selectClassClickEvent(self.indexPath);
    }
}

- (void)setIsNOCanEdit:(BOOL)isNOCanEdit{
    [super setIsNOCanEdit:isNOCanEdit];
    
    self.amountTft.userInteractionEnabled = !isNOCanEdit;
    self.unitTft.userInteractionEnabled = !isNOCanEdit;
    self.unitPriceTft.userInteractionEnabled = !isNOCanEdit;
    self.categoryBtn.userInteractionEnabled = !isNOCanEdit;
    self.categaryTft.userInteractionEnabled = !isNOCanEdit;
    self.deletePartsBtn.hidden = isNOCanEdit;
    self.arrowImageView.hidden = isNOCanEdit;
    
    
    self.unitPriceTft.backgroundColor = isNOCanEdit ? [UIColor whiteColor] : [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.unitPriceTft.borderStyle = isNOCanEdit ? UITextBorderStyleNone: UITextBorderStyleRoundedRect;

    self.unitTft.backgroundColor = isNOCanEdit ? [UIColor whiteColor] : [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.unitTft.borderStyle = isNOCanEdit ? UITextBorderStyleNone: UITextBorderStyleRoundedRect;
    
    self.amountTft.backgroundColor = isNOCanEdit ? [UIColor whiteColor] : [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.amountTft.borderStyle = isNOCanEdit ? UITextBorderStyleNone: UITextBorderStyleRoundedRect;
    
}

@end
