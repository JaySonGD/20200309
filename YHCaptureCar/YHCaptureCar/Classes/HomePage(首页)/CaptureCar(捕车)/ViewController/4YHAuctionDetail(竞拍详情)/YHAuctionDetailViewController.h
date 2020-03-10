//
//  YHAuctionDetailViewController.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPayViewController.h"

@interface YHAuctionDetailViewController : YHPayViewController

@property (nonatomic, strong)NSString *auctionId;

@property (nonatomic)BOOL isAppointment;

@property (nonatomic, strong)NSString *jumpString;

@property (nonatomic, strong)NSString *status;

@property (nonatomic, strong)NSString *topPrice;

@end
