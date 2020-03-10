//
//  YHOfferCell.m
//  YHCaptureCar
//
//  Created by Jay on 14/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHOfferCell.h"
#import "TTZCarModel.h"

#import "SPAlertController.h"

@interface YHOfferCell()
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UIButton *userPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *commissionLB;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLB;

@end

@implementation YHOfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UITextField *tf;
//    tf.inputView
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)callAction:(UIButton *)sender {

    
    SPAlertController *presentVC = [SPAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否拨打号码：%@",self.model.userPhone]];
    [presentVC addActionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:nil];
    [presentVC addActionWithTitle:@"确定" style:SPAlertActionStyleDefault handler:^(SPAlertController *action) {
        NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.model.userPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    presentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:presentVC animated:NO completion:nil];
    
}

- (void)setModel:(offerModel *)model{
    _model = model;
    self.userNameLB.text = model.userName;
    self.timeLB.text = model.time;
    self.commissionLB.text = IsEmptyStr(model.commission)? @"":[NSString stringWithFormat:@"￥%@",model.commission];
    self.offerPriceLB.text = IsEmptyStr(model.offerPrice)? @"":[NSString stringWithFormat:@"%@万",model.offerPrice];

}

@end
