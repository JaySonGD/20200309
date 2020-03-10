//
//  YHWorkbordNoticeCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/27.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkbordNoticeCell.h"
@interface YHWorkbordNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *stateL;
@property (weak, nonatomic) IBOutlet UIButton *noticeL;

@end

@implementation YHWorkbordNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loaddataSource:(NSDictionary*)info inde:(NSInteger)index{
    _noticeL.tag = index;
    _nameL.text = info[@"title"];
    if ([info[@"agoDays"] isEqualToString:@""]) {
        [_stateL setTitle:@"过期" forState:UIControlStateNormal];
    }else{
        [_stateL setTitle:info[@"agoDays"] forState:UIControlStateNormal];
    }
}
@end
