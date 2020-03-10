//
//  YTSearchController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YTDiagnoseModel;
@interface YTSearchController : UIViewController
@property (nonatomic, weak) YTDiagnoseModel *diagnoseModel;
@property (nonatomic, copy)  dispatch_block_t searchResultBlock;
@end

NS_ASSUME_NONNULL_END
