//
//  YHCarDetailCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/9/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCarDetailCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *info;
/** 选择事件处理block */
@property (nonatomic, copy) void(^selectEvent)(NSIndexPath *cellIndexPath,NSInteger viewIndex,UIButton *selectBtn);
/** textField输入事件处理block */
@property (nonatomic, copy) void(^textfieldInputEvent)(NSString *text,NSIndexPath *cellIndexPath,NSInteger viewIndex);

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
