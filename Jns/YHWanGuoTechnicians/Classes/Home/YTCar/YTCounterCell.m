//
//  YTCounterCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTCounterCell.h"
#import "YTPayModeInfo.h"

@interface YTCounterCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topupViewH;
@property (weak, nonatomic) IBOutlet UIView *lastView;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *orgPointLB;
@property (weak, nonatomic) IBOutlet UILabel *needPayNameLB;


@end

@implementation YTCounterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)topupAction:(UIButton *)sender {
    !(_topupBlock)? : _topupBlock();

}

- (IBAction)selectAction:(UIButton *)sender {
    self.model.isSelect = !self.model.isSelect;
    !(_selectBlock)? : _selectBlock(self.model);
}



- (void)setModel:(YTPayMode *)model{
    _model = model;
    self.topupViewH.constant = 0;
    self.pointViewH.constant = 0;
    
    self.nameLB.text = model.name;
    self.needPayNameLB.text = nil;//model.need_pay_name;
    self.priceLB.text = nil;//model.price;
    self.orgPointLB.text = model.org_point;
    
    self.selectBtn.selected = model.isSelect;

    if ([model.type isEqualToString:@"ORG_POINTS"]||[model.type isEqualToString:@"OTHER_ORG_POINTS"]) {
        self.pointViewH.constant = 22;
        if (model.org_point.doubleValue < fabs(model.price.doubleValue)){
            self.topupViewH.constant = 30;
        }
    }else if ([model.type isEqualToString:@"ORG_WX"]){
        //self.priceLB.text = [NSString stringWithFormat:@"¥%@",model.price];

    }else if ([model.type isEqualToString:@"OWNER"]){
        self.needPayNameLB.text = [NSString stringWithFormat:@"由车主承担支付费用¥%@,付费完后车主可直接查看检测报告                        ",model.price];//
        self.priceLB.text = nil;


    }else{
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)rowHeight:(YTPayMode *)model{
    self.model = model;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    return CGRectGetMaxY(self.lastView.frame)+5;
}


@end
