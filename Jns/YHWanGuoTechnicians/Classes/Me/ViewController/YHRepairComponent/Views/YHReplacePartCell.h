//
//  YHReplacePartCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHReplacePartCell : UITableViewCell

@property (nonatomic, copy) void(^replacePartDeleBtnClickBlock)(YHReplacePartCell *cell, NSIndexPath *indexPath);

@property (nonatomic, copy) void(^replacePartRemoveBtnClickBlock)(YHReplacePartCell *cell, NSIndexPath *indexPath);

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSDictionary *infoDict;

- (void)hideRemoveBtn;

@end
