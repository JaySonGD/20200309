//
//  YHProjectAddCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHProjectAddCell.h"

@interface YHProjectAddCell ()
@property (weak, nonatomic) IBOutlet UILabel *addL;

@end
@implementation YHProjectAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadDataSource:(NSString*)info{
    _addL.text = info;
}

@end
