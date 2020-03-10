//
//  YTPlanCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTPlanModel;
@interface YTPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, strong) YTPlanModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@property (nonatomic, copy) NSString *caseName;

@property (nonatomic, copy) NSString *orderType;

@end

NS_ASSUME_NONNULL_END
