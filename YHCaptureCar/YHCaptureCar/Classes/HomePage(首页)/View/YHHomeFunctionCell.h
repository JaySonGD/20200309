//
//  YHHomeFunctionCell.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YHFunctionId) {
    YHFunctionIdCheck ,//检测
    YHFunctionIdCaptureCar ,//捕车
    YHFunctionIdSell ,//帮卖
    YHFunctionIdFinance ,//金融
    YHFunctionIdCustomerService ,//售后
    YHFunctionIdWealth ,//财富
    YHFunctionIdERP ,//erp 变成 车源管理
    YHFunctionIdTrain ,//培训
    YHFunctionIdHelper ,//帮手
    YHFunctionIdHelpCheck ,//帮检
    YHFunctionIdNone ,//Node
};

@interface YHHomeFunctionCell : UITableViewCell

- (void)loadDatasource:(NSArray*)source;
@end
