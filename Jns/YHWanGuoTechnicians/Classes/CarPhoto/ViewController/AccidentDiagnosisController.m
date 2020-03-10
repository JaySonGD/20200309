//
//  AccidentDiagnosisController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "AccidentDiagnosisController.h"



#import "AccidentDiagnosisCell.h"


#import "YHCheckProjectModel.h"
#import "TTZDBModel.h"

#import "YHCarPhotoService.h"
#import "NSObject+BGModel.h"
#import "YHCommon.h"
#import <Masonry/Masonry.h>

#import "YHDiagnosisProjectVC.h"

@interface AccidentDiagnosisController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger val;

@property (nonatomic, assign)BOOL isBackBySide;

@end

@implementation AccidentDiagnosisController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initUI];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [self doClick];
}

- (void)dealloc{
    NSLog(@"");
    [self doClick];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[YHDiagnosisProjectVC class]]) {
        self.isBackBySide = YES;
        [self doClick];
    }
}

#pragma mark  -  自定义方法
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.navigationController.delegate = self;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doClick)];
}



- (void)popViewController:(id)sender{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"当前页面有数据未进行保存，是否保存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super popViewController:sender];
        });
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doClick];
    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:confirmAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark  -  -----------------------完成按钮响应事件------------------------
- (void)doClick
{
    NSInteger  max = self.max;
    NSInteger  min = self.min;
    NSInteger  value = self.val;
    
    [self.view endEditing:YES];
    
    if (min != max && (value > max || value < min)) {
//        [MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%ld~%ld内",(long)min,(long)max]];
        return;
    }
    


    
    NSMutableDictionary *val = [NSMutableDictionary dictionary];
    val[@"sysId"] = self.model.name;
    val[@"saveType"] = @"finish";
    val[@"projectVal"] = [self tempProjectVal];
    
    //!(_saveTempData)? : _saveTempData(self.model.name,val);
    !(_saveTempData)? : _saveTempData(YES,self.model.name,val);
    
    if (self.isBackBySide == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",self.model.billId]];
    
    [[YHCarPhotoService new] addEventForBillId:self.model.billId
                                        proVal:self.model.Id
                                      isFinish:YES];
    
    
    NSLog(@"%s", __func__);
}

#pragma mark  -  -----------------------完成按钮响应事件------------------------
- (void)backClick{
    
    [self.view endEditing:YES];

    
    NSMutableDictionary *val = [NSMutableDictionary dictionary];
    val[@"sysId"] = self.model.name;
    val[@"saveType"] = @"back";
    
    val[@"projectVal"] = [self tempProjectVal];
    
    //!(_saveTempData)? : _saveTempData(self.model.name,val);
    !(_saveTempData)? : _saveTempData(NO,self.model.name,val);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSMutableArray *)tempProjectVal{
    
    NSMutableArray *projectVal = [NSMutableArray array];
    
    [self.model.projectList enumerateObjectsUsingBlock:^(YHProjectListGroundModel * _Nonnull ground, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [ground.projectList enumerateObjectsUsingBlock:^(YHProjectListModel * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block NSMutableArray *lists = [NSMutableArray array];
            [cell.intervalRange.list enumerateObjectsUsingBlock:^(YHlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.isSelect){
                    [lists addObject:obj.name];
                }
            }];
            
            (!cell.projectVal.length) ? :[lists addObject:cell.projectVal];
            
            if(lists.count) [projectVal addObject:@{@"id":cell.Id,@"projectVal":[lists componentsJoinedByString:@","],@"type":cell.intervalType}];
            
        }];
        
    }];
    
    return projectVal;
}




#pragma mark  -  UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLB = [UILabel new];
    titleLB.font = [UIFont systemFontOfSize:17];
    titleLB.textColor = YHColorWithHex(0x505050);
    [sectionHeaderView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionHeaderView);
        make.left.equalTo(sectionHeaderView).offset(16);
    }];
    
    titleLB.text = self.model.projectList[section].projectName;
    
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = YHBackgroundColor;//YHColorWithHex(0xefeff4);
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.projectList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YHProjectListGroundModel *model = self.model.projectList[section];
    
    if([model.intervalType isEqualToString:@"textarea"] && model.projectList.count == 0){
        YHProjectListModel *listModel = [YHProjectListModel new];
        listModel.intervalType = @"textarea";
        listModel.Id = model.Id;
        [model.projectList addObject:listModel];
    }
    
    return  self.model.projectList[section].projectList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHProjectListModel *model = self.model.projectList[indexPath.section].projectList[indexPath.row];
    model.billId = self.model.billId;
    
    CGFloat cellHeight = model.cellHeight;
    
    if (cellHeight) {
        return cellHeight;
    }
    
    AccidentDiagnosisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentDiagnosisCell"];
    
    CGFloat height = [cell rowHeight:model];
    
    model.cellHeight = height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccidentDiagnosisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentDiagnosisCell"];
    YHProjectListModel *model = self.model.projectList[indexPath.section].projectList[indexPath.row];
    model.billId = self.model.billId;
    cell.model = model;
    
    __weak typeof(self) weakSelf = self;
    cell.reloadData = ^{
        [weakSelf.tableView reloadData];
        //[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.cheackBlock = ^(NSInteger max, NSInteger min, NSInteger val) {
        weakSelf.min = min;
        weakSelf.max = max;
        weakSelf.val = val;
    };
    return cell;
}


#pragma mark  -  get/set 方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AccidentDiagnosisCell" bundle:nil] forCellReuseIdentifier:@"AccidentDiagnosisCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AccidentDiagnosisCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0 );
        //_tableView.contentOffset = CGPointMake(0, 0);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        
        
        
        _tableView.estimatedRowHeight = 100;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
    }
    return _tableView;
}


@end
