//
//  YHDepthEditCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/3.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHDepthEditCell : UITableViewCell

@property (weak, nonatomic)NSArray *repairActionData;
- (void)loadDatasource:(NSMutableDictionary*)info index:(NSInteger)index isRepair:(BOOL)isRepair isRepairModel:(BOOL)isRepairModel isCloud:(BOOL)isCloud isRepairPrice:(BOOL)isRepairPrice;
- (void)loadDatasource:(NSString*)title desc:(NSString*)desc index:(NSInteger)index;
@end
