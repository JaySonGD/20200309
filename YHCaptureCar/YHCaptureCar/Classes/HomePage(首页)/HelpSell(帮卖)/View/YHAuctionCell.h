//
//  YHAuctionCell.h
//  YHCaptureCar
//
//  Created by Jay on 2018/3/31.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTZCarModel;
@interface YHAuctionCell : UITableViewCell

/** 是否正在拍卖中 */
@property (nonatomic, assign) BOOL isInAuction;
@property (nonatomic, strong) TTZCarModel *model;
/** 时间差<##> */
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) dispatch_block_t getNewData;


@end
