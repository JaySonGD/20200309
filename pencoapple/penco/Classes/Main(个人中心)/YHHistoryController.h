//
//  YHHistoryController.h
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"
#import "PCPersonModel.h"
NS_ASSUME_NONNULL_BEGIN
@class PCMessageModel;
@interface YHHistoryController : YHBaseViewController

@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, assign) BOOL isNews;

//@property (nonatomic, weak) NSMutableArray<PCPersonModel *> *models;

@property (nonatomic, strong) PCMessageModel *messageModel;
@property (nonatomic, assign) NSInteger scrollIndex;

@end

NS_ASSUME_NONNULL_END
