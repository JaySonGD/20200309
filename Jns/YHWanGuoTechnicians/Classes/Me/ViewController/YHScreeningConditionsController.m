//
//  YHScreeningConditionsController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHScreeningConditionsController.h"
#import "YHExtrendBackListController.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkPHPManager.h"
extern NSString *const notificationConditionDate;
@interface YHScreeningConditionsController ()
@property (weak, nonatomic) IBOutlet UILabel *conditionDateL;
@property (weak, nonatomic) IBOutlet UILabel *siteStrL;

@end

@implementation YHScreeningConditionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationConditionDate:) name:notificationConditionDate object:nil];
    if (_fromDate && _toDate) {
        NSString *start = [_fromDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *end = [_toDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _conditionDateL.text = [NSString stringWithFormat:@"%@-%@", start, end];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)comfireAction:(id)sender {
    if (!_fromDate || !_toDate) {
        [MBProgressHUD showError:@"请选择起始结束时间！"];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/statisticsChart.html?token=%@&status=ios&startDate=%@&endDate=%@", SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken], _fromDate, _toDate];
    [_webController loadWebPageWithString:urlStr];
    [self popViewController:nil];
}

- (void)notificationConditionDate:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    self.fromDate = userInfo[@"fromDate"];
    self.toDate = userInfo[@"toDate"];
    
    NSString *start = [_fromDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *end = [_toDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _conditionDateL.text = [NSString stringWithFormat:@"%@-%@", start, end];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"list"]) {
        YHExtrendBackListController *controller = segue.destinationViewController;
        controller.fromDate =_fromDate;
        controller.toDate =_toDate;
    }
}


@end
