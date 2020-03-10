//
//  YTSysCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTSysCell.h"
#import "YTWarranty.h"

@interface YTSysCell ()
@property (weak, nonatomic) IBOutlet UIView *tfBox;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *sysTitleBtn;

@end

@implementation YTSysCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)textChange:(UITextField *)sender {
    self.model.price = sender.text;
}
- (IBAction)editingEnd:(UITextField *)sender {
    !(_reloadBlock)? : _reloadBlock();

}

- (IBAction)tapClick:(UIButton *)sender {
    self.model.check = !self.model.check;
    !(_reloadBlock)? : _reloadBlock();
}

- (void)setModel:(YTWarranty *)model{
    _model = model;
    
    if (model.child_system.count) {
        self.tfBox.hidden = !model.check ;
    }else{
       self.tfBox.hidden = NO;
    }
    
    self.sysTitleBtn.selected = model.check;
    [self.sysTitleBtn setTitle:[NSString stringWithFormat:@"  %@",model.child_system?@"承保该系统":model.system_name] forState:UIControlStateNormal];
//    [self.sysTitleBtn setTitle:[NSString stringWithFormat:@"  %@",model.system_name] forState:UIControlStateSelected];
    self.priceTF.text = model.price;
    self.priceTF.userInteractionEnabled = model.check;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
