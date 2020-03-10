//
//  YHMapSheetView.h
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHReservationModel;
@interface YHMapSheetView : UIView
+ (instancetype)showAnnotation:(YHReservationModel *)model;
@property (nonatomic, copy) void (^didSelectBlock)(YHReservationModel *);//(NSString *addr,NSString *org_id);
@end
