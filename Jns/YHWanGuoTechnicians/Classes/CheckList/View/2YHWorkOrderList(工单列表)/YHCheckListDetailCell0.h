//
//  YHCheckListDetailCell0.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCheckListDetailModel0.h"

@interface YHCheckListDetailCell0 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogoI;
@property (weak, nonatomic) IBOutlet UILabel *skilledWorkerL;
@property (weak, nonatomic) IBOutlet UILabel *carModelFullNameL;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (weak, nonatomic) IBOutlet UILabel *timeRemindL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *goImageView;


- (void)refreshUIWithModel:(YHCheckListDetailModel0 *)model WithTag:(NSInteger)tag WithType:(NSInteger)type;

@end
