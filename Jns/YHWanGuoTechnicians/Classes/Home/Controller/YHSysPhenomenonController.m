//
//  YHSysPhenomenonController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/20.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSysPhenomenonController.h"

#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHWenXunCell.h"

NSString *const notificationSysPhenomenon = @"YHNotificationSysPhenomenon";

extern NSString *const notificationSysPhenomenonChange;
@interface YHSysPhenomenonController ()
@property (strong, nonatomic)NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableDictionary *sysClassSel;
- (IBAction)comfirmAction:(id)sender;
@end

@implementation YHSysPhenomenonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationSysPhenomenonChange:) name:notificationSysPhenomenonChange object:nil];
    
    [self reupdataDatasource];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notificationSysPhenomenonChange:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    NSNumber *index = userInfo[@"index"];
    NSNumber *sel = userInfo[@"sel"];
    NSDictionary *sysPhenomenon = _data[index.integerValue];
    NSString *sysPhenomenonId = sysPhenomenon[@"id"];
    if (sel.boolValue) {
        if (!_sysPhenomenonSel) {
            _sysPhenomenonSel = [@{sysPhenomenonId : sysPhenomenon[@"faultPhenomenonName"]}mutableCopy];
        }else{
            [_sysPhenomenonSel setValue:sysPhenomenon[@"faultPhenomenonName"] forKey:sysPhenomenonId];
        }
    }else{
        [_sysPhenomenonSel removeObjectForKey:sysPhenomenonId];
    }
    
}

- (void)reupdataDatasource{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getFaultPhenomenon:[YHTools getAccessToken]
     sysClassId:_sysId
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             weakSelf.data = info[@"data"];
             
             [weakSelf.tableview reloadData];
         }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
             [MBProgressHUD showError:@"你还没有工单！"];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *sysItem = _data[indexPath.row];

    NSString *sysPhenomenonId = sysItem[@"id"];
    
    [cell loadDatasource:sysItem[@"faultPhenomenonName"] unit:@"" isOnly:NO index:indexPath.row isOn:_sysPhenomenonSel[sysPhenomenonId]];
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)comfirmAction:(id)sender {
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationSysPhenomenon
     object:Nil
     userInfo:@{_sysId :_sysPhenomenonSel}];
    [self popViewController:nil];
}
@end
