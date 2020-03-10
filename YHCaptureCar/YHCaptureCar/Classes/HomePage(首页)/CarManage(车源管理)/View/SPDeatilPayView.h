//
//  SPDeatilPayView.h
//  YHCaptureCar
//
//  Created by Jay on 10/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPDeatilPayView : UIView

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *activityPrice;

@property (nonatomic, copy) dispatch_block_t tapBlock;
@end
