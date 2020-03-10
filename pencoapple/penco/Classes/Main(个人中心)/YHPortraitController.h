//
//  YHPortraitController.h
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHPortraitController : YHBaseViewController
/** <##> */
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) void (^complete)(NSString *baseImag);
@end

NS_ASSUME_NONNULL_END
