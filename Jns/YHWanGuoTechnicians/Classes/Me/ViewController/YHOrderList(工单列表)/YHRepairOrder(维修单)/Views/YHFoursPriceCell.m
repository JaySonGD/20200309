//
//  YHFoursPriceCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/1.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHFoursPriceCell.h"

@implementation YHFoursPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.itemNameL.font = [UIFont boldSystemFontOfSize:18.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditEnd:) name:UITextFieldTextDidEndEditingNotification object:self.priceTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.priceTft];
}

- (void)textEditEnd:(NSNotification *)noti{
    
    UITextField *obj = (UITextField *)noti.object;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *result = [obj.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    [dict setValue:[result stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"textContent"];
    [dict setValue:self.indexPath forKey:@"indexPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textChangeWriteDataForJ004" object:nil userInfo:dict];
}

- (void)textChange:(NSNotification *)noti{
    UITextField *obj = (UITextField *)noti.object;
    
    CGFloat amountW = [obj.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    if (amountW >= 150) {
        amountW = 150;
    }
    if (amountW > 40) {
        self.priceConstraint.constant = amountW + 20;
    }
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    [super setIndexPath:indexPath];
    
}
- (void)setCellModel:(NSString *)cellModel{
    
    if (cellModel.floatValue == 0) {
        return;
    }
    
    self.priceTft.text = [NSString stringWithFormat:@"%.2f",[cellModel floatValue]];
    CGFloat amountW = [self.priceTft.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    
    if (amountW >= 150) {
        amountW = 150;
    }
    
    if (amountW > 40) {
        self.priceConstraint.constant = amountW + 20;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setRounded:self.bounds corners:UIRectCornerAllCorners radius:8.0];
}

@end
