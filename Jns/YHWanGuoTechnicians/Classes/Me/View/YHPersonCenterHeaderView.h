//
//  YHPersonCenterHeaderView.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/4/26.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPersonCenterHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLab;
@property (weak, nonatomic) IBOutlet UILabel *availableCashbackLab;
@property (weak, nonatomic) IBOutlet UILabel *alreadyWithdrawLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;


@end

NS_ASSUME_NONNULL_END
