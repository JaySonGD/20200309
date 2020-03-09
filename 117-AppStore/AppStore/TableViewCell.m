//
//  TableViewCell.m
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.iv.contentMode = UIViewContentModeScaleAspectFill;
    self.iv.layer.cornerRadius = 8;
    self.iv.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;

}

- (void)startAnimation{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);    } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
    }];
}
- (void)endAnimation{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
