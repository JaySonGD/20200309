//
//  YHCaptureCarAlertView.h
//  YHCaptureCar
//
//  Created by Jay on 15/5/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHCaptureCarAlertView : YHBaseViewController
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *commission;

/** 是否是帮买 */
@property (nonatomic, assign) BOOL isHelpBuy;
/** 建议价格 例 12-18 */
@property (nonatomic, copy) NSString *suggestPrice;
/** 是否已询价 0 未询价 1 已询价  */
@property (nonatomic, assign) BOOL isEnquiry;

@property (nonatomic, copy) void (^submitBlock)(NSString *price,NSString * commission);
@property (nonatomic, copy) dispatch_block_t enquirieBlock;

/** 出价*/
@property (nonatomic, assign) BOOL isOffer;


@end
