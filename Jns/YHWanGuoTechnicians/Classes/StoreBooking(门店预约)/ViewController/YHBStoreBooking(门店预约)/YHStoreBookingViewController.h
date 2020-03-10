//
//  YHStoreBookingViewController.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSiteModel.h"
#import "YHReservationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHStoreBookingViewController : UIViewController

@property (nonatomic, strong) YHSiteModel *siteModel;
@property (nonatomic, strong) YHReservationModel *reservationModel;

@end

NS_ASSUME_NONNULL_END
