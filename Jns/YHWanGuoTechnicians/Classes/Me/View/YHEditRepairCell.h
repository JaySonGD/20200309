//
//  YHEditRepairCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/12.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHRepairEditDelegate <NSObject>
@optional
-(void)notificationRepairEdit:(id)obj;
@end
@interface YHEditRepairCell : UITableViewCell

@property (weak, nonatomic)id<YHRepairEditDelegate> delegate;

- (void)loadDataSource:(NSDictionary*)info isAdd:(BOOL)isAdd isSel:(BOOL)isSel isCloud:(BOOL)isCloud isRepairPrice:(BOOL)isRepairPrice isFirt:(BOOL)isFirt;
- (void)loadDataSource:(NSDictionary*)info isAdd:(BOOL)isAdd isSel:(BOOL)isSel;

@end
