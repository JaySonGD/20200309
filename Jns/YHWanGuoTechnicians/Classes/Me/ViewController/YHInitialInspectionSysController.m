//
//  YHInitialInspectionSysController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHInitialInspectionSysController.h"
#import "YHInitialInspectionSysCell.h"
#import "YHInitialInspectionController.h"
@interface YHInitialInspectionSysController ()

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@end

@implementation YHInitialInspectionSysController

- (void)viewDidLoad {
    self.isInitialInspectionSys = YES;
    [super viewDidLoad];
    
    NSLog(@"------------===哈哈：%@===------------",self.sysAr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableVIew reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sysAr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHInitialInspectionSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasoure:self.sysAr[indexPath.row] isDataFilled:[self checkDataFilled:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
    NSDictionary *sysInfo = self.sysAr[indexPath.row];
    
    controller.is_circuitry = self.sysData[@"is_circuitry"];
    NSMutableArray *data = [@[sysInfo]mutableCopy];
    if ([sysInfo[@"title"] isEqualToString:@"灯光"]
        || [sysInfo[@"title"] isEqualToString:@"四轮"]) {
        data = [self newWholeCarSubinfo:sysInfo[@"subSys"]];
    }
    controller.sysAr = data;
    controller.sysData = self.sysData;
    controller.orderInfo = self.orderInfo;
    controller.titleStr = sysInfo[@"title"];
    controller.isHasPhoto = self.isHasPhoto;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)checkDataFilled:(NSUInteger)index{
    NSDictionary *info = self.sysAr[index];
    for (NSDictionary *item in info[@"subSys"]) {
        if (item[@"sel"] || item[@"value"]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray*)newWholeCarSubinfo:(NSArray*)infos{
    NSMutableArray *temp = [@[]mutableCopy];
    
    for (int i = 0; i < infos.count; i++) {
        NSMutableDictionary *item = infos[i];
        if ([item[@"pid"] isEqualToString:@"0"]) {
            [item setObject:@1 forKey:@"isLow2"];//新全车的二级栏目，入 左前，右前
            BOOL isExistence = NO;
            for (NSMutableDictionary *sysLow2 in temp) {
                if ([item[@"id"] isEqualToString:sysLow2[@"id"]]) {
                    [sysLow2 setObject:item[@"projectName"] forKey:@"title"];
                    isExistence = YES;
                    break;
                }
            }
            if (!isExistence) {
                [temp addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                   @"sel" : @1,
                                   @"id" : item[@"id"],
                                   @"title" : item[@"projectName"],
                                   @"subSys" : [@[]mutableCopy]}mutableCopy]];
            }
            
        }else{
            BOOL isExistence = NO;
            for (NSMutableDictionary *sysLow2 in temp) {
                if ([item[@"pid"] isEqualToString:sysLow2[@"id"]]) {
                    NSMutableArray *subSys = sysLow2[@"subSys"];
                    [subSys addObject:item];
                    isExistence = YES;
                    continue;
                }
            }
            if(!isExistence){
                [temp addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                   @"sel" : @1,
                                   @"id" : item[@"pid"],
//                                   @"title" : item[@"projectName"],
                                   @"subSys" : [@[item] mutableCopy]}mutableCopy]];
            }
        }
    }
    return temp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.;
}

@end
