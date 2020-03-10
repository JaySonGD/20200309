//
//  YTPhoneCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 5/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTPhoneCell.h"

#import "YTWarranty.h"

@interface YTPhoneCell ()
@property (weak, nonatomic) IBOutlet UITextField *phpneTF;
@property (weak, nonatomic) IBOutlet UIButton *syncBtn;

@end


@implementation YTPhoneCell
- (IBAction)editingChanged:(UITextField *)sender {
    _model.phone = sender.text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)syncClick:(UIButton *)sender {
    self.model.check = !self.model.check;
    sender.selected = self.model.check;
}

- (void)setModel:(YTExtended *)model{
    _model = model;
    self.phpneTF.text = model.phone;
    self.syncBtn.selected = model.check;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
