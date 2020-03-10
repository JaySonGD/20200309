//
//  TTZTagRightView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHlistModel;

@interface TTZTagRightView : UIView

@property (nonatomic,assign) BOOL isMultipleChoice;

@property (nonatomic, strong) NSArray<YHlistModel*> *models;

@property (nonatomic, copy) void(^clickAction)(NSArray<YHlistModel*> *);

@end
