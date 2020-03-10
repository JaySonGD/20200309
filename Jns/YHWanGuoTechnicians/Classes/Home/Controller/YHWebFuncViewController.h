//
//  YHWebFuncViewController.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/7.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHWebViewController.h"

@interface YHWebFuncViewController : YHWebViewController

@property (nonatomic, assign)BOOL isFeedBackPush;

- (IBAction)showVinAction:(id)sender;

@property (nonatomic, assign) NSInteger functionK;

- (void)depthDiagnose:(NSString *)bill_id

             billType:(NSString *)billType

             menuCode:(NSString *)menuCode

          billTypeNew:(NSString *)billTypeNew
                 with:(BOOL)isAI;

- (void)getIntelligentReport:(NSString *)order_id;
- (void)getReportByBillIdV2:(NSString *)billId;
@end
