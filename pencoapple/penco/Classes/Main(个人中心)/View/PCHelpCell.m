//
//  PCHelpCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/10/21.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCHelpCell.h"
@interface PCHelpCell ()
@property (weak, nonatomic) IBOutlet UILabel *tilteL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;

@end
@implementation PCHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTitle:(NSString*)title detail:(NSString*)detail{
    self.tilteL.text = title;
    self.detailL.text = detail;
}

@end
