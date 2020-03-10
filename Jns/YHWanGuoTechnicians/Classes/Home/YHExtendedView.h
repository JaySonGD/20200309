//
//  YHExtendedView.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/9/3.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHExtendedView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *licensed;
@property (weak, nonatomic) IBOutlet UIImageView *carIconImv;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *VINLb;
@property (weak, nonatomic) IBOutlet UILabel *kmNumber;
@property (weak, nonatomic) IBOutlet UILabel *fuelLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;

@property (nonatomic, strong) YTBaseInfo *baseInfo;

@end

NS_ASSUME_NONNULL_END
