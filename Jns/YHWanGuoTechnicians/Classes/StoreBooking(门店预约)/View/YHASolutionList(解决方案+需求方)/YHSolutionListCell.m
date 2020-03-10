//
//  YHSolutionListCell.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSolutionListCell.h"
#import <UIImageView+WebCache.h>

@implementation YHSolutionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshUIWithModel:(YHSolutionListModel *)model Tag:(NSInteger)tag {
    NSString *url = [NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", model.carBrandLogo];
    [self.carBrandLogoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"carModelDefault"]];
    
    self.plateNumberAllLabel.text = model.plateNumberAll;
    
    if (tag == 1 || tag == 2) {
        if (tag == 1) {
            self.techNicknameLabel.text = [NSString stringWithFormat:@"接车人 %@",model.techNickname];
            self.techNicknameLabel.hidden = NO;
            self.techNicknameLabelHeight.constant = 30;
        } else {
            self.techNicknameLabel.hidden = YES;
            self.techNicknameLabelHeight.constant = 10;
        }
    } else {
        self.techNicknameLabel.hidden = NO;
        self.techNicknameLabel.text = model.shopName;
    }
    
    self.nowStatusNameLabel.text = model.nowStatusName;
    
    self.creationTimeLabel.text = model.appointmentDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
