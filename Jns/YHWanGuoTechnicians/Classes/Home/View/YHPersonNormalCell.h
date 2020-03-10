//
//  YHPersonNormalCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPersonNormalCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *megain;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *topicL;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;

@property (nonatomic, assign) BOOL isRequireCorner;

@end

NS_ASSUME_NONNULL_END
