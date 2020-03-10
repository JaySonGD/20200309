//
//  TTZCheckCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTZSurveyModel,TTZChildModel;
@interface TTZCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view;

@property (nonatomic, strong) TTZSurveyModel *model;
@property (nonatomic, copy) dispatch_block_t reloadBlock;
@property (nonatomic, copy) dispatch_block_t reloadAllBlock;

@property (nonatomic, copy)  void(^helpBlock)(TTZSurveyModel *model);

@property (nonatomic, copy)  void(^takePhotoBlock)(TTZSurveyModel *model);


@property (nonatomic, copy) void(^getElecCtrlProjectListBlock)(NSArray <TTZSurveyModel *>*models);
@property (nonatomic, copy) void(^removeElecCtrlProjectListBlock)(NSArray <TTZSurveyModel *>*models);

- (CGFloat)rowHeight:(TTZSurveyModel *)model;

@end


@interface TTZCheckHeaderCell : UITableViewHeaderFooterView

@property (nonatomic, weak) UILabel *titleLabel;

@end


@interface TTZFaultCodeCell : UITableViewCell
@property (nonatomic, weak) UILabel *unitLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, copy)  void(^removeBlock)(NSString *txt);

@end


@interface TTZChildCell : UITableViewCell
@property (nonatomic, strong) TTZChildModel *model;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, copy)  void(^removeBlock)(NSString *txt);
@property (nonatomic, copy)  void(^didSelectBlock)(void);

@end

