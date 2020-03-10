//
//  YHCarValuationViewController.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHCarValuationModel.h"

@interface YHCarValuationViewController : YHBaseViewController

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, strong) YHCarValuationModel *model;

@end
