//
//  YHFourWheelsHeadView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHFourWheelsHeadView : UIView

@property (nonatomic, strong) NSDictionary *brakeDict;
// 工单号
@property (nonatomic, strong) NSString *billID;
- (NSString *)getDistance;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame billd:(NSString *)billd;

@end
