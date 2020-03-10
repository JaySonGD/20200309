//
//  YHSysSelController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSysSelController.h"
#import "YHSysSelCell.h"
#import "YHInitialInspectionController.h"
@interface YHSysSelController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YHSysSelController
@dynamic orderInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if ([self.orderInfo[@"billType"] isEqualToString:@"P"]) {
//        
//        self.sysinfos = [@[
//                           [@{@"title" : @"机油匹配(烧机油)",
//                              @"sysClassId" : @"10000",
//                              @"sel" : @0}mutableCopy],
//                           [@{@"title" : @"冷媒冷冻油",
//                              @"sysClassId" : @"10001",
//                              @"sel" : @0}mutableCopy],
//                           ]mutableCopy];
//    }else{
//        self.sysinfos = [@[
//                           [@{@"title" : @"传动系统",
//                              @"sysClassId" : @"1",
//                              @"sel" : @0}mutableCopy],
//                           [@{@"title" : @"电控系统",
//                              @"sysClassId" : @"2",
//                              @"sel" : @0}mutableCopy],
//                           [@{@"title" : @"发动机系统",
//                              @"sysClassId" : @"3",
//                              @"sel" : @0}mutableCopy],
//                           [@{@"title" : @"制动系统",
//                              @"sysClassId" : @"4",
//                              @"sel" : @0}mutableCopy],
//                           [@{@"title" : @"制冷系统",
//                              @"sysClassId" : @"5",
//                              @"sel" : @0}mutableCopy],
//                           ]mutableCopy];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    NSMutableArray *items = [@[]mutableCopy];
    for (NSDictionary *item in _sysinfos) {
        NSNumber *sel = item[@"sel"];
        if (sel.boolValue) {
            [items addObject:item];
        }
    }
    if (items.count == 0) {
        [MBProgressHUD showError:@"请选择系统"];
        return NO;
    }
    return YES;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    YHInitialInspectionController *controller = segue.destinationViewController;
    NSMutableArray *items = [@[]mutableCopy];
    for (NSMutableDictionary *item in _sysinfos) {
        NSNumber *sel = item[@"sel"];
        [item removeObjectForKey:@"subSys"];
        if (sel.boolValue) {
            [items addObject:item];
        }
    }
    
    controller.sysAr = items;
    controller.sysData = _sysData;
    
    controller.orderInfo = self.orderInfo;
    controller.is_circuitry = _is_circuitry;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sysinfos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHSysSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_sysinfos[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *info =  _sysinfos[indexPath.row];
    NSNumber *sel = info[@"sel"];
    [info setObject:[NSNumber numberWithBool:!sel.boolValue] forKey:@"sel"];
    [tableView reloadData];
}

@end
