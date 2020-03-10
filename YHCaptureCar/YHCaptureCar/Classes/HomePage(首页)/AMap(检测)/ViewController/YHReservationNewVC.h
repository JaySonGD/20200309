//
//  YHReservationNewVC.h
//  YHCaptureCar
//
//  Created by Liangtao Yu on 2019/5/25.
//  Copyright © 2019 YH. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHReservationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHReservationNewVC : YHBaseViewController

@property(nonatomic,strong)YHReservationModel *reservationM;

@property(nonatomic,assign) BOOL isFirst;//是否直接进来

@end

NS_ASSUME_NONNULL_END
