//
//  YHDetailViewController.h
//  YHCaptureCar
//
//  Created by mwf on 2018/3/26.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"
#import "TTZCarModel.h"
#import "YHPayViewController.h"

@interface YHDetailViewController : YHPayViewController

@property (nonatomic, strong)TTZCarModel * carModel;
@property (nonatomic, copy)NSString *jumpString;
@property (nonatomic, copy)NSString *rptCode;//帮检检测报告

@end
