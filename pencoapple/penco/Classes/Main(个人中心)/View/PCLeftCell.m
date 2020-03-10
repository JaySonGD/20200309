//
//  PCLeftCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/11/4.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCLeftCell.h"
@interface PCLeftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *right;

@end
@implementation PCLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)rightAnimated{
    self.right.alpha = 0.0;
    [UIView animateWithDuration:1.  animations:^{
           self.right.alpha = 1.0;
       } completion:^(BOOL finisahed){
           
       }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
