//
//  YHSolutionListCell.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSolutionListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHSolutionListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *plateNumberAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *techNicknameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *techNicknameLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *nowStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationTimeLabel;

- (void)refreshUIWithModel:(YHSolutionListModel *)model Tag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
