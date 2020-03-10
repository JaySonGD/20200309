//
//  PCAAPopCell.m
//  penco
//
//  Created by Jay on 18/9/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCAAPopCell.h"

@implementation PCAAPopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(8, 0, self.contentView.bounds.size.width-8, self.contentView.bounds.size.height);
}

@end
