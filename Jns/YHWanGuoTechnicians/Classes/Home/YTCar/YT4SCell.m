//
//  YT4SCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YT4SCell.h"
#import "YTWarranty.h"

@interface YT4SCell ()
@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@end

@implementation YT4SCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)textChange:(UITextField *)sender {
    self.model.ssss_price = sender.text;
}
- (IBAction)editingEnd:(UITextField *)sender {
    !(_reloadBlock)? : _reloadBlock();
    
}

- (void)setModel:(YTExtended *)model{
    _model = model;
    self.priceTF.text = model.ssss_price;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
