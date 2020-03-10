//
//  YHDateTimeCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/8/25.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHDateTimeCell.h"

NSString *const notificationDateTimeSel = @"YHNotificationDateTimeSel";
@interface YHDateTimeCell ()

@property (weak, nonatomic) IBOutlet UIButton *timeB;

@end

@implementation YHDateTimeCell

- (void)loadDateStr:(NSString*)str{
    if (str && ![str isEqualToString:@""]) {
        [_timeB setTitle:str forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)timeAction:(id)sender {
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationDateTimeSel
         object:Nil
         userInfo:nil];
}


@end
