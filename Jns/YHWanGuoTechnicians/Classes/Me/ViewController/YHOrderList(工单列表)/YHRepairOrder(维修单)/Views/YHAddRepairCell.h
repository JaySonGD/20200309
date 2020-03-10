//
//  YHAddRepairCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/29.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAddRepairCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void(^closeCellCallBbackBlock)(NSIndexPath *indexPath);

@end
