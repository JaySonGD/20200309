//
//  YHWebFuncViewController.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/7.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHWebViewController.h"
#import "YHReportListModel.h"
#import "YHReportDetailModel.h"

@interface YHWebFuncViewController : YHWebViewController
- (IBAction)showVinAction:(id)sender;

@property (nonatomic, strong)YHReportListModel *rlModel;
@property (nonatomic, strong)YHReportDetailModel *rdModel;

@property (nonatomic, assign) BOOL isPushByReportList;


@end
