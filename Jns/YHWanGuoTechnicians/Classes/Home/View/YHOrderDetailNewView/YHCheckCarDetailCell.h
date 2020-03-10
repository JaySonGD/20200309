//
//  YHCheckCarDetailCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCheckCarDetailCell : UITableViewCell

+ (instancetype)createCheckCarDetailCell:(UITableView *)tableView;

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger maxRows;
/** 问询信息 */
@property (nonatomic, copy) NSDictionary *askInfo;
/** 基本信息 */
@property (nonatomic, copy) NSDictionary *baseInfo;

@end
