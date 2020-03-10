//
//  YHSuccessController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/18.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSuccessController.h"
#import "YHOrderDetailController.h"
#import "YHOrderListController.h"
#import "YHDepthController.h"
#import "YHTools.h"
#import "YHExtrendListController.h"
#import "YHWebFuncViewController.h"
extern NSString *const notificationOrderListChange;
@interface YHSuccessController ()

@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *timeoutL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic, weak)NSTimer *timer;
@property (nonatomic)NSInteger times;
@end

@implementation YHSuccessController
@dynamic orderInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _successView.hidden = NO;
    self.title = _titleStr;
    self.titleL.text = _titleStr;
    self.timer=  [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(timeout:) userInfo:nil repeats:YES];
    self.times = 3;
    [self.timer fire];
    
}

- (IBAction)popViewController:(id)sender {
    [self.timer  invalidate];
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationOrderListChange
     object:Nil
     userInfo:nil];
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHOrderListController class]] || [obj isKindOfClass:[YHExtrendListController class]] ) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            isBack = YES;
        }
    }];
    
    if(!isBack){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                *stop = YES;
                isBack = YES;
            }
        }];

    }
    
    if (!isBack) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)timeout:(id)obj{
    NSInteger count = self.times - 1;
    if (count > 0) {
        self.times -= 1;
        if (_pay) {
            self.timeoutL.text = [NSString stringWithFormat:@"%ld秒后回到列表\n或点击下方按钮回到列表", (long)count];
        }else{
            self.timeoutL.text = [NSString stringWithFormat:@"%ld秒后回到工单详情\n或点击下方按钮回到列表", (long)count];
        }
    }else{
        
        [self.timer  invalidate];
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationOrderListChange
         object:Nil
         userInfo:nil];
        if (_pay) {
            [self popViewController:nil];
            return;
        }
        
        if ( ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"])
            || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudDepthQuote"]) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHDepthController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthController"];
            controller.functionKey = YHFunctionIdNewWorkOrder;
            controller.orderInfo = self.orderInfo;
            
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
            if ([self.orderInfo[@"nowStatusCode"] isEqualToString:@"qualityInspectionPass"]) {
                controller.functionKey = YHFunctionIdHistoryWorkOrder;
            }else if ([self.orderInfo[@"nowStatusCode"] isEqualToString:@"channelSubmitMode"]) {
                controller.functionKey = YHFunctionIdUnfinishedWorkOrder;
            }else{
                controller.functionKey = YHFunctionIdNewWorkOrder;
            }
            controller.orderInfo = self.orderInfo;
            controller.isPop2Root = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
