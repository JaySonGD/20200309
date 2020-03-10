//
//  YHPushPhoneView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHPushPhoneView : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *pushPhoneNumberL;
@property (weak, nonatomic) IBOutlet UITextField *phoneTft;

@property (nonatomic, copy) void(^textEditEndCallBack)(NSString *text);

@end

NS_ASSUME_NONNULL_END
