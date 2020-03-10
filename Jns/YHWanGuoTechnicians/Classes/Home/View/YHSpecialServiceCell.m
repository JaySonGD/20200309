//
//  YHSpecialServiceCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/25.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSpecialServiceCell.h"
@interface YHSpecialServiceCell()
@property (weak, nonatomic) IBOutlet UIButton *row1;
@property (weak, nonatomic) IBOutlet UIButton *row2;
@property (weak, nonatomic) IBOutlet UIButton *row3;

@end
@implementation YHSpecialServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataSource:(NSArray*)info{
   [ @[_row1, _row2, _row3] enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
       if (info.count > idx) {
           NSDictionary *item = info[idx];
           button.hidden = NO;
           [button setTitle:item[@"name"] forState:UIControlStateNormal];
           [button setImage:[UIImage imageNamed:item[@"icon"]] forState:UIControlStateNormal];
       }else{
           button.hidden = YES;
       }
   }];
    
}
@end
