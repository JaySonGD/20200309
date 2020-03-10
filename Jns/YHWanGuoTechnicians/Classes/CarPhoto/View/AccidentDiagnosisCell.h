//
//  AccidentDiagnosisCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  YHProjectListModel;
@interface AccidentDiagnosisCell : UITableViewCell

@property (nonatomic, strong) YHProjectListModel *model;
@property (nonatomic, copy)  void(^cheackBlock)(NSInteger max ,NSInteger min , NSInteger val);

- (CGFloat)rowHeight:(YHProjectListModel *)model;
    
    @property (nonatomic, copy) void (^reloadData)(void);

@end

@interface YHPhotoAddCell : UICollectionViewCell
@property (strong, nonatomic)  UIButton *imageBtn;
@property (strong, nonatomic)  UIButton *clearnBtn;
@property (nonatomic, copy) void (^clearnAction)(void);
@end



#pragma mark - UIViewCategory
@interface UIView (fetchViewController)
- (UIViewController*)viewController;
@end

