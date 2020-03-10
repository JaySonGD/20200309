//
//  YTPriceCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTPriceCell.h"

@implementation YTPriceCell


- (void)setModel:(YTPriceModel *)model{
    _model = model;
    
    
    NSString *title = IsEmptyStr(model.name)? model.price : model.name;
    
    [self.priceBtn setTitle:title forState:UIControlStateNormal];
    self.priceBtn.selected = model.isSelect;
    
    if (model.isSelect) {
        self.priceBtn.backgroundColor = YHNaviColor;
    }else{
        self.priceBtn.backgroundColor = [UIColor whiteColor];
    }
}
@end
