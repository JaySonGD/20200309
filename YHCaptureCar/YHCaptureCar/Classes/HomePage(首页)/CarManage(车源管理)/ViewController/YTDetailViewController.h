//
//  YTDetailViewController.h
//  YHCaptureCar
//
//  Created by Jay on 25/5/2019.
//  Copyright © 2019 YH. All rights reserved.
//

#import "YHBaseViewController.h"

typedef NS_OPTIONS(NSUInteger, YTDetailBottomStyle) {
    YTDetailBottomStyleNone  = 0,
    YTDetailBottomStyleERPAuth ,
    YTDetailBottomStyleHelpSellAuth ,
};


NS_ASSUME_NONNULL_BEGIN
@class TTZCarModel;
@interface YTDetailViewController : YHBaseViewController
@property (nonatomic, strong)TTZCarModel * carModel;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) YTDetailBottomStyle bottomStyle;
@end

NS_ASSUME_NONNULL_END
