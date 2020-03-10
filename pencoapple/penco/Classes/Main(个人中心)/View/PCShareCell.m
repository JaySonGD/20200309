//
//  PCShareCell.m
//  penco
//
//  Created by Jay on 17/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCShareCell.h"

@implementation PCShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    
    
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 10)];
}

@end
