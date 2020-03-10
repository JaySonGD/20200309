//
//  OilCell.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/6/25.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "OilCell.h"

#import "YHIntelligentCheckModel.h"
#import "oilView.h"

@implementation OilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setArrModel:(NSArray *)arrModel{
    
    [arrModel enumerateObjectsUsingBlock:^(TutorialListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        oilView *view = [[NSBundle mainBundle] loadNibNamed:@"oilView" owner:nil options:nil].firstObject;
        view.oilStyleTitleL.text = obj.title;
        [view.oilModelL setTitle:obj.pay_status.intValue ? @"查看" : @"购买" forState:UIControlStateNormal];
        view.oilModelL.tag = idx;
        [view.oilModelL setTitleColor:[UIColor colorWithRed:63.0/255.0 green:159.0/255.0 blue:245.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [view.oilModelL addTarget:self action:@selector(addGoto:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(28 * idx);
            make.height.offset(28);
            make.width.equalTo(self);
        }];
    }];

}

- (void)addGoto:(UIButton *)btn{
    
    self.blockPay(btn.tag);
    
}

-(void)layoutSubviews{
    
     [self setRounded:self.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
    
}

@end
