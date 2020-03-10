//
//  PCHistoryContentView.h
//  penco
//
//  Created by Jay on 1/8/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

@class PCTestRecordModel;
NS_ASSUME_NONNULL_BEGIN

@interface PCHistoryContentView : YHBaseViewController
@property (nonatomic, strong) NSMutableArray <PCTestRecordModel *>*models;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isNews;
@end

NS_ASSUME_NONNULL_END
