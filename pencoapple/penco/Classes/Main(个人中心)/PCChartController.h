//
//  PCChartController.h
//  penco
//
//  Created by Jay on 27/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PCPartCheckModelUp,//上
    PCPartCheckModelMiddle,//中
    PCPartCheckModelDown,//下
    PCPartCheckModelNormal,//默认
} PCPartCheckModel;
@class PCReportModel,YHCellItem;
@interface PCChartController : UIViewController

@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *accountId;

@property (nonatomic, strong) PCReportModel *xyPt;
@property (nonatomic, strong) YHCellItem *item;
@property (nonatomic, copy)  dispatch_block_t closeBlock;

-(void)partCheckModel:(PCPartCheckModel)model;
@end

NS_ASSUME_NONNULL_END
