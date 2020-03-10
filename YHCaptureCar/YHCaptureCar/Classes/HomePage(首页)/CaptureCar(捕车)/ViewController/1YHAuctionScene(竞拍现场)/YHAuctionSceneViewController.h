//
//  YHAuctionSceneViewController.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/6.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "YHBaseViewController.h"


@interface YHAuctionSceneViewController : YHBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@end
