//
//  YHCarSelCell.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/31.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHCarSelCell.h"
@interface YHCarSelCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
@implementation YHCarSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_button setUserInteractionEnabled:NO];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info isSel:(BOOL)isSel{
    _button.selected = isSel;
    [_button setTitle:info[@"carModelFullName"] forState:UIControlStateNormal];
}
@end
