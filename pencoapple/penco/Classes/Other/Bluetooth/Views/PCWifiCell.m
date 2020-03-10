//
//  PCWifiCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/8/12.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCWifiCell.h"
@interface PCWifiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ssidImg;

@end
@implementation PCWifiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)ssid:(NSNumber*)ssid{
    if (ssid == nil) {
        return;
    }
    NSString *icon = @"分组_copy";
    if (ssid.integerValue > -55) {
        icon = @"分组_copy";
    }
    if (ssid.integerValue > -65 && ssid.integerValue <= -55) {
        icon = @"分组_copy2";
    }
    if (ssid.integerValue > -75 && ssid.integerValue <= -65) {
        icon = @"分组_copy3";
    }
    if (ssid.integerValue > -85 && ssid.integerValue <= -75) {
        icon = @"分组_copy4";
    }
    if (ssid.integerValue <= -85) {
        icon = @"分组_copy5";
    }
    
    [self.ssidImg setImage:[UIImage imageNamed:icon]];
    
}
@end
