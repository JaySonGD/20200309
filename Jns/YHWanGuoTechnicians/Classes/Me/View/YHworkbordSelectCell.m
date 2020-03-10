//
//  YHworkbordSelectCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/27.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHworkbordSelectCell.h"
@interface YHworkbordSelectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selIG;
@property (weak, nonatomic) IBOutlet UIButton *stateL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end
@implementation YHworkbordSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataSource:(NSDictionary*)info{
    [_selIG setImage:[UIImage imageNamed:((info[@"sel"])? (@"SubtractionP") : (@"SubtractionN"))]];
    _nameL.text = info[@"title"];
    if ([info[@"agoDays"] isEqualToString:@""]) {
        [_stateL setTitle:@"过期" forState:UIControlStateNormal];
    }else{
        [_stateL setTitle:info[@"agoDays"] forState:UIControlStateNormal];
    }
    
}

@end
