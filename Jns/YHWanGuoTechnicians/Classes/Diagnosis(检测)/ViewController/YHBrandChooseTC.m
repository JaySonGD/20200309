//
//  YHBrandChooseTC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  品牌选择控制器

#import "YHBrandChooseTC.h"
#import "YHBrandChooseCell.h"
#import "YHNetworkPHPManager.h"
//#import "MBProgressHUD+MJ.h"
#import "YHBrandModel.h"
#import <MJExtension.h>
#import "YHCarSeriesTC.h"

static NSString *cellID = @"brand";

/**
 品牌选择控制器
 */
@interface YHBrandChooseTC ()

@property(nonatomic,strong)NSMutableArray *searchBtnArr;

@property(nonatomic,strong)NSMutableArray *brandArr;//品牌数组

@property(nonatomic,strong)NSMutableArray <NSMutableArray <YHBrandModel*>*> * brandSortArr;//品牌排序数组

@end

@implementation YHBrandChooseTC

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求网络数据
    [self loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
//    //创建右侧列表数据
//    self.searchBtnArr = [NSMutableArray array];
//    for (char i = 'A'; i<= 'Z'; i++) {
//        [self.searchBtnArr addObject:[NSString stringWithFormat:@"%c",i]];
//    }
//    [self.searchBtnArr addObject:[NSString stringWithFormat:@"#"]];
    
    self.searchBtnArr = [NSMutableArray array];
    for (YHBrandModel *model in self.brandArr) {
        [self.searchBtnArr addObject:[NSString stringWithFormat:@"%@",model.initial]];
    }
    self.title = @"车系选择";
    
    //设置tableView右侧
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor grayColor]];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[YHBrandChooseCell class] forCellReuseIdentifier:cellID];

}


/**
 请求网络数据
 */
-(void)loadData{
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]queryCarBrandListonComplete:^(NSDictionary *info) {
        if ([info[@"code"] longLongValue] == 20000) {  //请求成功
            //进行字典转模型
            for (NSDictionary *dict in info[@"data"]) {
                YHBrandModel *model = [YHBrandModel mj_objectWithKeyValues:dict];
                [self.brandArr addObject:model];
            }

            //整理数据结构
            NSMutableDictionary *dict =[NSMutableDictionary dictionary];
            [self.brandArr enumerateObjectsUsingBlock:^(YHBrandModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!dict[obj.initial]) {
                    dict[obj.initial] = [NSMutableArray array];
                }
                [dict[obj.initial] addObject:obj];
            }];
         //排序
            self.brandSortArr = (NSMutableArray *)[dict.allValues sortedArrayUsingComparator:^NSComparisonResult(NSArray<YHBrandModel *>* _Nonnull obj1, NSArray<YHBrandModel *>* _Nonnull obj2) {
                return [obj1.firstObject.initial compare: obj2.firstObject.initial];
            }];
            
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{//请求错误弹出提示信息
            [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } onError:^(NSError *error) {
        
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.brandSortArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.brandSortArr[section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHBrandChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    YHBrandModel *brandModel = self.brandSortArr[indexPath.section][indexPath.row];
    cell.brandModel = brandModel;
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

/**
 右侧索引数据
 */
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titles = [NSMutableArray array];
    [self.brandSortArr enumerateObjectsUsingBlock:^(NSMutableArray<YHBrandModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.firstObject.initial];
    }];
    return titles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    NSInteger count = 0;
//    for (NSString *header in self.searchBtnArr) {
//        if ([header isEqualToString:title]) {
//            return count;
//        }
//        count++;
//    }
//    return 0;
    
    NSMutableArray *titles = [NSMutableArray array];
    [self.brandSortArr enumerateObjectsUsingBlock:^(NSMutableArray<YHBrandModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.firstObject.initial];
    }];
    return [titles indexOfObject:title];
}

/**
头部标题
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

     NSMutableArray *titles = [NSMutableArray array];
    [self.brandSortArr enumerateObjectsUsingBlock:^(NSMutableArray<YHBrandModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.firstObject.initial];
    }];
    
    return titles[section];
}

/**
选择那一条数据
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YHCarSeriesTC *carTC = [[YHCarSeriesTC alloc]init];
    YHBrandModel *brandModel = self.brandSortArr[indexPath.section][indexPath.row];
    carTC.brandId = brandModel.brandId;
    carTC.brandName = brandModel.brandName;
    [self.navigationController pushViewController:carTC animated:YES];
}

#pragma mark - 懒加载
/**
品牌数组
 */
-(NSMutableArray *)brandArr{
    if (_brandArr == nil) {
        _brandArr = [NSMutableArray array];
    }
    return _brandArr;
}

/**
 品牌排序之后的数组
 */
-(NSMutableArray *)brandSortArr{
    if (_brandSortArr == nil) {
        _brandSortArr = [NSMutableArray array];
    }
    return _brandSortArr;
}

@end
