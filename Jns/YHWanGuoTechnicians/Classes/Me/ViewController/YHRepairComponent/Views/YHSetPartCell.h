//
//  YHSetPartCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YHSetPartCellType) {
    YHSetPartCellParts, // 配件
    YHSetPartCellExpend // 耗材
};

@interface YHSetPartCell : UITableViewCell

@property (nonatomic, copy) NSMutableDictionary *infoDict;

@property (nonatomic, copy) void(^deleBtnClickBlock)(YHSetPartCell *cell, NSIndexPath *indexPath);

@property (nonatomic, copy) void(^removeBtnClickBlock)(YHSetPartCell *cell, NSIndexPath *indexPath);

@property (nonatomic, assign) YHSetPartCellType type;
/** cell相对应的indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 * 设置spaceView隐藏和显示
 */
- (void)setSpaceViewHide:(BOOL)isHide;
/**
 * 隐藏删除按钮-显示XX按钮
 */
- (void)hideRemoveBtn;
@property (nonatomic, copy) void(^selectClassClickEvent)(NSIndexPath *indexPath);

@end
