//
//  YHCarBrandNameController.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHCarBrandNameController.h"
#import "YHNetworkPHPManager.h"
#import "NSString+PinYin.h"

#import "YHBrandNameCell.h"
#import "YHBrandSeriesController.h"
@interface YHCarBrandNameController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)  NSMutableArray  *dataArray;
@property (nonatomic, strong) NSArray *hotBrandNames;

@end

@implementation YHCarBrandNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getCarBrandListOnComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        if (((NSNumber*)info[@"code"]).integerValue == 20000) {
            
            [weakSelf dataSourceChange:info[@"data"]];
        }else{
            if(![self networkServiceCenter:info[@"code"]]){
                YHLog(@"getCarBrandList Error");
            }
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)dataSourceChange:(NSArray*)brandNames{
    NSArray  *indexArray= [brandNames arrayWithPinYinFirstLetterFormat:^NSString *(NSDictionary *info) {
        return info[@"brandName"];
    }];
    
    self.dataArray =[NSMutableArray arrayWithArray:indexArray];
    [_dataArray insertObject:@{
                               @"content" : @[
                                       @{
                                           @"brandName" : @"不限品牌",
                                           }
                                       ],
                               @"firstLetter" : @""
                               } atIndex:0];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.dataArray[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHBrandNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = _dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    [cell loadDatasource:array[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHBrandSeriesController *controller = [board instantiateViewControllerWithIdentifier:@"YHBrandSeriesController"];
    
    NSDictionary *dict = _dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    controller.brandInfo =  array[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark---tableView索引相关设置----
//添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSDictionary *dict = self.dataArray[section];
        NSString *title = dict[@"firstLetter"];
        return title;
    }
    return nil;
}


//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *resultArray =[NSMutableArray arrayWithObjects:@"筛", @"选", nil];
        //        NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
        for (NSDictionary *dict in self.dataArray) {
            NSString *title = dict[@"firstLetter"];
            [resultArray addObject:title];
        }
        return resultArray;
    }
    return nil;
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if (index <= 2)
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:0];//不限品牌

    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 2; // -2 定位按钮
    }
}

@end
