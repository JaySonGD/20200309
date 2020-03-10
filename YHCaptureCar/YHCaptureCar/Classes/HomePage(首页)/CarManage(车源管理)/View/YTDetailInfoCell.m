//
//  YTDetailInfoCell.m
//  YHCaptureCar
//
//  Created by Jay on 25/5/2019.
//  Copyright © 2019 YH. All rights reserved.
//

#import "YTDetailInfoCell.h"

@implementation YTDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)action:(id)sender {
    !(_block)? : _block();

}


@end
