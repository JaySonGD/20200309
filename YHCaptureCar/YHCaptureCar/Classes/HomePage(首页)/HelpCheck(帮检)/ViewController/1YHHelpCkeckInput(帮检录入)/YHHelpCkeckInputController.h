//
//  YHHelpCkeckInputController.h
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPayViewController.h"


@class YHCarVersionModel;
@interface TTZInPutModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isCusKeyboard;
/** 辅助属性 */
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *org_Name;

@property (nonatomic, copy) NSString *carBrandId;
@property (nonatomic, copy) NSString *carLineId;
@property (nonatomic, copy) NSString *smsNotifyPhone;

@end

@interface YHHelpCkeckInputController : YHPayViewController

//车型车系
@property (nonatomic, copy) NSString *carType;

@property (nonatomic, strong) YHCarVersionModel *model;

@property (nonatomic, copy) NSString *vinStr;

@end
