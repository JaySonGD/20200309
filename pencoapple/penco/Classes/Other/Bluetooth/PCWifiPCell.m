//
//  PCWifiPCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/25.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCWifiPCell.h"
@interface PCWifiPCell ()
@property (weak, nonatomic) IBOutlet UIButton *showB;

- (IBAction)showPAction:(id)sender;

@end
@implementation PCWifiPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pFT.secureTextEntry = YES;
    self.pFT.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)loadData:(NSString*)info{
    self.pFT.text =  info;
}


- (IBAction)showPAction:(id)sender {
    self.showB.selected = !self.showB.selected;
    self.pFT.secureTextEntry = !self.showB.selected;
}
@end
