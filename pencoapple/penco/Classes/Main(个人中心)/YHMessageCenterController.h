//
//  YHMessageCenterController.h
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DataTypeHistory = 0,
    DataTypeMessage,
} DataType;


@interface YHMessageCenterController : YHBaseViewController
@property (nonatomic, assign) DataType  type;
@property (nonatomic, copy) NSString *personId;
@end

NS_ASSUME_NONNULL_END
