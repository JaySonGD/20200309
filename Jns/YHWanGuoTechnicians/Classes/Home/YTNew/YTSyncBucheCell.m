//
//  YTSyncBucheCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 27/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTSyncBucheCell.h"

@interface YTSyncBucheCell ()
@property (weak, nonatomic) IBOutlet UIButton *syncValue;

@end

@implementation YTSyncBucheCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)syncAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self.bucheSync setValue:@(sender.isSelected) forKey:@"sync_value"];
}

- (void)setBucheSync:(NSMutableDictionary *)bucheSync{
    _bucheSync = bucheSync;
    
    self.syncValue.userInteractionEnabled = [[bucheSync valueForKey:@"sync_status"] integerValue] != 2;
    
    self.syncValue.selected = [[bucheSync valueForKey:@"sync_value"] boolValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
