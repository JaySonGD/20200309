//
//  PCBluetoothCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/24.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCBluetoothCell.h"
@interface PCBluetoothCell ()
@property (weak, nonatomic) IBOutlet UILabel *maneL;

@end
@implementation PCBluetoothCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadName:(NSString*)name{
    self.maneL.text = name;
}

@end
