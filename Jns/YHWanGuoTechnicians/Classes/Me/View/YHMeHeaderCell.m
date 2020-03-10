//
//  YHMeHeaderCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import "YHMeHeaderCell.h"
NSString *const notificationLogin = @"YHNotificationLogin";
@interface YHMeHeaderCell ()
- (IBAction)meLoginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *meLoginB;
@property (weak, nonatomic) IBOutlet UILabel *loginL;

@end

@implementation YHMeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)meLoginAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil userInfo:nil];
}

- (void)loadDatasource:(NSDictionary*)info{
    NSDictionary *data = info[@"data"];
    
    NSString *urlStr = data[@"headUrl"];
    if ((id)urlStr != [NSNull null]) {
        [_meLoginB sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"me_14"]];
    }
    _loginL.text = data[@"nickname"];
}
@end
