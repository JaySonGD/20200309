//
//  YHAddPictureContentView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAddPictureContentView : UIView

@property (nonatomic, copy) NSString *billID;

@property (nonatomic, copy) NSString *code;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithBilld:(NSString *)billd;

@end
