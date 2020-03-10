//
//  YHRepairCollectionViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRepairCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *title;

- (void)setSelectTitle:(BOOL)isSelect;

@property (nonatomic, assign) BOOL isNoCanEdit;

@end
