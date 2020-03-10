//
//  YHMeMenuCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHMeMenuCell.h"
@interface YHMeMenuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *menuLog;
@property (weak, nonatomic) IBOutlet UILabel *menuStr;

@end
@implementation YHMeMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info{
    [_menuLog setImage:[UIImage imageNamed:info[@"img"]]];
    [_menuStr setText:info[@"str"]];
}



@end
