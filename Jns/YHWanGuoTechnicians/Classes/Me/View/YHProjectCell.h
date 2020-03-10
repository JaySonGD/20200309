//
//  YHProjectCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YHExtrendListController.h"
@interface YHProjectCell : UITableViewCell

@property (weak, nonatomic)NSArray *repairActionData;
- (void)loadSearchKey:(NSString *)info;

- (void)loadData:(NSDictionary *)info isRepair:(BOOL)isRepair isSel:(BOOL)isSe;
- (void)loadData:(NSDictionary *)info isRepair:(BOOL)isRepair;
- (void)loadExtrendData:(NSDictionary *)info model:(YHExtrendModel)model;
@end
