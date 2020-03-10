//
//  YTReportPromptCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTReportPromptCell.h"

@interface YTReportPromptCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation YTReportPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)closeAction:(UIButton *)sender {
    
    !(_closeBlock)? : _closeBlock();

}

- (IBAction)submitAction:(UIButton *)sender {
    !(_submitBlock)? : _submitBlock();
}


- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.desLB.text = model[@"tips"];
}

- (CGFloat)rowHeight:(NSDictionary *)model{
    self.model = model;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    return CGRectGetMaxY(self.submitBtn.frame) + 10;
}



@end
