//
//  YHDiagnosisProjectVC.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnosisProjectVC.h"
#import "AccidentDiagnosisController.h"
#import "YHCarCheckAlertView.h"
//#import "YHDiagnosisBaseTC.h"
#import "YHDiagnosisBaseVC.h"
#import "YHCheckListDetailViewController.h"
#import "YHOrderDetailController.h"
#import "UIViewController+YH.h"
#import "YHSurveyCheckProjectCell.h"

#import "YHCheckProjectModel.h"
#import "YHCarBaseModel.h"
#import "YHTemporarySaveModel.h"
#import "YHOrderListController.h"
#import "YHWebFuncViewController.h"

#import "TTZUpLoadService.h"
#import "YHCarPhotoService.h"
#import "YHCommon.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "YHTools.h"

#import "YHCompetingOrderVC.h"

extern NSString *const notificationOrderListChange;
@interface YHDiagnosisProjectVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <YHSurveyCheckProjectModel*>*models;

@property (nonatomic, strong) NSMutableDictionary  *val;
@property (nonatomic, strong) NSMutableDictionary  *tempInitialSurveyProjectVal;
@property (nonatomic, strong) YHCarBaseModel  *baseInfo;

/** 已点击完成检车的项目*/
@property (nonatomic, strong) NSMutableDictionary *finishCheckVal;


@end

@implementation YHDiagnosisProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark  -  自定义方法
- (void)setUI{
    self.navigationItem.title = @"检测项目";
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 74)];
    footerView.backgroundColor = YHBackgroundColor;
    
    //    [footerView addSubview:self.submitBtn];
    //    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.top.equalTo(@(10));
    //        make.top.equalTo(@(0));
    //        make.bottom.equalTo(@(-10));
    //        make.right.equalTo(@(-10));
    //    }];
    self.tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.height.mas_equalTo(54);
        make.bottom.equalTo(@(-10-kTabbarSafeBottomMargin));
        make.right.equalTo(@(-10));
    }];
    
}

#pragma mark 处理网络数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] detailForBillId:self.billModel.billId
                                     isHelp:_isHelp
                                     success:^(NSMutableArray<YHSurveyCheckProjectModel *> *models, YHCarBaseModel *baseInfo,YHTemporarySaveModel *temp) {
                                         weakSelf.baseInfo = baseInfo;
                                         weakSelf.models = models;
                                         _val = [temp mj_keyValues];
                                         NSArray *vals = [_val valueForKey:@"initialSurveyProjectVal"];
                                         [vals enumerateObjectsUsingBlock:^(NSDictionary *  val, NSUInteger idx, BOOL * _Nonnull stop) {
                                             NSString *key = [val valueForKey:@"sysId"];
                                             weakSelf.tempInitialSurveyProjectVal[key] = val;
                                         }];
                                         
                                         [MBProgressHUD hideHUDForView:self.view];
                                     } failure:^(NSError *error) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         NSString *msg = [error.userInfo valueForKey:@"message"];
                                         [MBProgressHUD showError:msg];
                                         
                                     }];
}

- (void)temporarySave{
    
    
    self.val[@"initialSurveyProjectVal"] = self.tempInitialSurveyProjectVal.allValues;
    
    NSLog(@"%s", __func__);
    [[YHCarPhotoService new] temporarySaveForBillId:self.billModel.billId
                                              value:self.val
                                             isHelp:_isHelp
                                            success:^{
                                                
                                            }
                                            failure:^(NSError *error) {
                                                
                                            }];
}


- (void)submitData{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    //判断是否是有代录权限
    BOOL saveReplaceDetectiveInitialSurvey = YES;//代录
    if (saveReplaceDetectiveInitialSurvey && _isHelp) {
        [[YHCarPhotoService new] saveReplaceDetectiveInitialSurvey:self.billModel.billId
                                                      value:[self submitProjectVal]
                                                       info:[self.baseInfo mj_keyValues]
                                                    success:^{
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        [[NSNotificationCenter
                                                          defaultCenter]postNotificationName:notificationOrderListChange
                                                         object:Nil
                                                         userInfo:nil];
                                                        [MBProgressHUD showSuccess:@"提交成功" toView:self.navigationController.view];
                                                        [weakSelf.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                            if ([obj isKindOfClass:[YHCheckListDetailViewController class]]) {
                                                                YHCheckListDetailViewController * vc = (YHCheckListDetailViewController *)obj;
                                                                
                                                                vc.code = 1;
                                                                
                                                                if (vc.isSearch == YES) {
                                                                    //1.设置为未搜索状态
                                                                    vc.isSearch = NO;
                                                                    
                                                                    //2.清空输入框内容
                                                                    vc.searchTF.text = @"";
                                                                    
                                                                    //3.“取消按钮”隐藏
                                                                    vc.cancelWidth.constant = 0;
                                                                }
                                                                [vc loadNewData1];//哈哈
                                                                *stop = YES;
                                                            }
                                                        }];
//                                                        [[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:^{
//                                                            [weakSelf popToViewcontrollers:@[[YHCheckListDetailViewController class],
//                                                                                         [YHOrderListController class],
//                                                                                         [YHWebFuncViewController class]]];
//
//                                                        }];
                                                        [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:weakSelf.billModel.billId didHandle:^{
                                                            [weakSelf popToViewcontrollers:@[[YHCheckListDetailViewController class],
                                                                                             [YHOrderListController class],
                                                                                             [YHWebFuncViewController class]]];
                                                        }];


                                                        //[[TTZUpLoadService sharedTTZUpLoadService] uploadWithAlert];
                                                        
                                                    }
                                                    failure:^(NSError *error) {
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        NSString *msg = [error.userInfo valueForKey:@"message"];
                                                        [MBProgressHUD showError:msg];
                                                    }];
    }else{
       
        [[YHCarPhotoService new] saveInitialSurveyForBillId:self.billModel.billId
                                                      value:[self submitProjectVal]
                                                       info:[self.baseInfo mj_keyValues]
                                                     isHelp:_isHelp
                                                    success:^{
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        [[NSNotificationCenter
                                                          defaultCenter]postNotificationName:notificationOrderListChange
                                                         object:Nil
                                                         userInfo:nil];
                                                        [MBProgressHUD showSuccess:@"提交成功" toView:self.navigationController.view];
                                                        [weakSelf.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                            if ([obj isKindOfClass:[YHCheckListDetailViewController class]]) {
                                                                YHCheckListDetailViewController * vc = (YHCheckListDetailViewController *)obj;
                                                                
                                                                vc.code = 1;
                                                                
                                                                if (vc.isSearch == YES) {
                                                                    //1.设置为未搜索状态
                                                                    vc.isSearch = NO;
                                                                    
                                                                    //2.清空输入框内容
                                                                    vc.searchTF.text = @"";
                                                                    
                                                                    //3.“取消按钮”隐藏
                                                                    vc.cancelWidth.constant = 0;
                                                                }
                                                                [vc loadNewData1];//哈哈
                                                                *stop = YES;
                                                            }
                                                           
                                                        }];
                                                        
//                                                        [[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:^{
//                                                            [weakSelf popToViewcontrollers:@[[YHCheckListDetailViewController class],
//                                                                                         [YHOrderListController class],
//                                                                                         [YHWebFuncViewController class]]];
//                                                        }];
                                                        
                                                        [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:weakSelf.billModel.billId didHandle:^{
                                                            [weakSelf popToViewcontrollers:@[[YHCheckListDetailViewController class],
                                                                                             [YHOrderListController class],
                                                                                             [YHWebFuncViewController class]]];
                                                        }];
                                                        
                                                        //[[TTZUpLoadService sharedTTZUpLoadService] uploadWithAlert];
                                                    }
                                                    failure:^(NSError *error) {
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        NSString *msg = [error.userInfo valueForKey:@"message"];
                                                        [MBProgressHUD showError:msg];
                                                    }];
    }
    
}


- (NSMutableArray *)submitProjectVal{
    NSMutableArray *projectVal = [NSMutableArray array];
    
    
    [self.models enumerateObjectsUsingBlock:^(YHSurveyCheckProjectModel * _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
        if(page.isFinish){
            [page.projectList enumerateObjectsUsingBlock:^(YHProjectListGroundModel * _Nonnull ground, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [ground.projectList enumerateObjectsUsingBlock:^(YHProjectListModel * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    __block NSMutableArray *lists = [NSMutableArray array];
                    [cell.intervalRange.list enumerateObjectsUsingBlock:^(YHlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(obj.isSelect){
                            [lists addObject:obj.name];
                        }
                    }];
                    
                    (!cell.projectVal.length) ? :[lists addObject:cell.projectVal];
                    
                    if(lists.count) [projectVal addObject:@{@"projectId":cell.Id,@"projectVal":[lists componentsJoinedByString:@","]}];
                    else [projectVal addObject:@{@"projectId":cell.Id,@"projectVal":@""}];
                }];
                
            }];
        }
    }];
    
    
    
    return projectVal;
}


#pragma mark  -  提交按钮 ---
- (void)submitClick:(UIButton *)sender{
    
    //    //
    //    [[TTZUpLoadService sharedTTZUpLoadService] upLoad];
    //
    //    return;
    
    //[self submitProjectVal];
    
    NSMutableArray *alertLists = [NSMutableArray array];
    __block NSInteger count = 0;//所有检测项目数量
    [self.models enumerateObjectsUsingBlock:^(YHSurveyCheckProjectModel * _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
        if(page.isFinish) [page.projectList enumerateObjectsUsingBlock:^(YHProjectListGroundModel * _Nonnull ground, NSUInteger idx, BOOL * _Nonnull stop) {
            count+= ground.projectList.count;
        }];
    }];
    
    NSArray *vals = self.finishCheckVal.allValues;
    //NSArray *vals = self.tempInitialSurveyProjectVal.allValues;
    
    NSMutableArray *initialSurveyVal = [NSMutableArray array];
    [vals enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull gval, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *projectValDict = gval[@"projectVal"];
        [projectValDict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *projectId = obj[@"id"];
            NSString *projectVal = obj[@"projectVal"];
            [initialSurveyVal addObject:@{@"projectId":projectId,@"projectVal":projectVal}];
        }];
    }];
    
    YHSurveyCheckProjectModel *normal = [YHSurveyCheckProjectModel new];
    normal.val = @"项正常";
    normal.name = [NSString stringWithFormat:@"%lu",count - (unsigned long)initialSurveyVal.count];
    normal.nameColor = YHColorWithHex(0x46AEF7);
    [alertLists addObject:normal];
    
    
    YHSurveyCheckProjectModel *abnormal = [YHSurveyCheckProjectModel new];
    abnormal.val = @"项异常";
    abnormal.name = [NSString stringWithFormat:@"%lu",(unsigned long)initialSurveyVal.count];
    abnormal.nameColor = YHColorWithHex(0x696969);
    
    [alertLists addObject:abnormal];
    //2）.模糊查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFinish < 1"];
    NSArray *filtereds = [self.models filteredArrayUsingPredicate:predicate];
    [filtereds makeObjectsPerformSelector:@selector(setNameColor:) withObject:YHColorWithHex(0xF24E4E)];
    [filtereds makeObjectsPerformSelector:@selector(setVal:) withObject:@"未检测"];
    [alertLists addObjectsFromArray:filtereds];
    
    YHCarCheckAlertView *presentVC = [[UIStoryboard storyboardWithName:@"CarPhoto" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCarCheckAlertView"];
    presentVC.models = alertLists;
    // 核心代码
    presentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    //self.definesPresentationContext = YES;
    // 可以使用的Style
    // UIModalPresentationOverCurrentContext
    // UIModalPresentationOverFullScreen
    // UIModalPresentationCustom
    // 使用其他Style会黑屏
    presentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:presentVC animated:NO completion:nil];
    
    __weak typeof(self) weakSelf = self;
    presentVC.submitBlock = ^{
        [weakSelf submitData];
    };
    
}

- (void)showAbnormal:(YHSurveyCheckProjectModel *)pageModel abnormalVal:(NSDictionary *)val{
    NSLog(@"%s", __func__);
    __block NSInteger count = 0;//所有项目数
    __block NSInteger totalInputCount = 0; //所有输入项目数

    [pageModel.projectList enumerateObjectsUsingBlock:^(YHProjectListGroundModel * _Nonnull ground, NSUInteger idx, BOOL * _Nonnull stop) {
        count+= ground.projectList.count;
        
        [ground.projectList enumerateObjectsUsingBlock:^(YHProjectListModel * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if([cell.intervalType isEqualToString:@"form"] || [cell.intervalType isEqualToString:@"text"] || [cell.intervalType isEqualToString:@"textarea"]) totalInputCount += 1;
        }];
    }];
    
    NSInteger totalAbnormalCount = [[val valueForKey:@"projectVal"] count];//所有提交项目数
    __block NSInteger inputCount = 0; //录入项目数 必须要有内容
    __block NSInteger inputSubmitCount = 0; //录入项目数

    [[val valueForKey:@"projectVal"] enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = [obj valueForKey:@"type"];
        NSString *projectVal = [obj valueForKey:@"projectVal"];
        
        if(([type isEqualToString:@"form"] || [type isEqualToString:@"text"] || [type isEqualToString:@"textarea"]) && !IsEmptyStr(projectVal)) inputCount += 1;
        
        if([type isEqualToString:@"form"] || [type isEqualToString:@"text"] || [type isEqualToString:@"textarea"]) inputSubmitCount += 1;
    }];
    
    NSInteger unInputCount = totalInputCount - inputCount;//未录入项目数
    NSInteger abnormalCount = totalAbnormalCount - inputSubmitCount;//异常项目数
    NSInteger normalCount = count - totalInputCount-abnormalCount;//count - totalInputCount-abnormalCount;//正常项目数

    NSMutableArray *msgs = [NSMutableArray array];
    
    (!normalCount)? : [msgs addObject:[NSString stringWithFormat:@"%ld  项正常",normalCount]];
    (!abnormalCount)? : [msgs addObject:[NSString stringWithFormat:@"%ld  项异常",abnormalCount]];
    (!unInputCount)? : [msgs addObject:[NSString stringWithFormat:@"%ld  项未录入",unInputCount]];


    (!msgs.count)? : [MBProgressHUD showSuccess:[msgs componentsJoinedByString:@"\r\n\r\n"]];
    
    //    NSString *msg = [NSString stringWithFormat:@"%ld  项正常\r\n\r\n%ld  项异常",count - abnormalCount - inputCount , (long)abnormalCount];
    //    [MBProgressHUD showSuccess:msg];
    
}

#pragma mark  - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHSurveyCheckProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHSurveyCheckProjectCell"];
    cell.model = self.models[indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHSurveyCheckProjectModel *model = self.models[indexPath.row];
    
    
    model.billId = self.billModel.billId;
    __weak typeof(self) weakSelf = self;
    
    if (!indexPath.row) { // indexpath.row == 0
        if (_isHelp) {
            YHCompetingOrderVC *orderBaseInfoVC = [[YHCompetingOrderVC alloc] init];
            orderBaseInfoVC.baseInfoM = self.baseInfo;
            [self.navigationController pushViewController:orderBaseInfoVC animated:YES];
            return;
        }else{
//            UIStoryboard *board = [UIStoryboard storyboardWithName:@"diagnosis" bundle:nil];
            YHDiagnosisBaseVC *diagnosisBaseVC = [[YHDiagnosisBaseVC alloc] init];//[board instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseVC"];
            //self.baseInfo.carPhotos.car_surface_front = @"http://cdn.cocimg.com/bbs/attachment/upload/56/3656.jpg";
            //self.baseInfo.carPhotos.car_interior_2 = @"http://cdn.cocimg.com/bbs/attachment/upload/56/3656.jpg";
            //self.baseInfo.carPhotos.car_other = @[@"http://cdn.cocimg.com/bbs/attachment/upload/56/3656.jpg",@"http://cdn.cocimg.com/bbs/attachment/upload/56/3656.jpg"];
            diagnosisBaseVC.isHelp = _isHelp;
            diagnosisBaseVC.vinController = self;
            diagnosisBaseVC.baseInfoM = self.baseInfo;
            diagnosisBaseVC.billId = self.billModel.billId;
            diagnosisBaseVC.doAciton = ^(YHCarBaseModel *baseInfo) {
                model.isFinish = YES;
                weakSelf.baseInfo = baseInfo;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:diagnosisBaseVC animated:YES];
            return;
        }
    }
    
    [[YHCarPhotoService new] addEventForBillId:self.billModel.billId
                                        proVal:model.Id
                                      isFinish:NO];
    
    AccidentDiagnosisController *vc = [AccidentDiagnosisController new];
    vc.saveTempData = ^(BOOL isFinish, NSString *key, NSDictionary *val) {
        NSLog(@"%s", __func__);
        if(!model.isFinish) {
            model.isFinish = isFinish;
        }
        weakSelf.tempInitialSurveyProjectVal[key] = val;
        [weakSelf temporarySave];
        [weakSelf.tableView reloadData];
        if(isFinish) {
            weakSelf.finishCheckVal[key] = val;
            [weakSelf showAbnormal:model abnormalVal:val];
        } else {
            [weakSelf.finishCheckVal removeObjectForKey:key];
        }
    };
    vc.title = model.name;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
}

#pragma mark  -  get/set 方法

- (NSMutableDictionary *)val{
    if(!_val){
        _val = [NSMutableDictionary dictionary];
        _val[@"baseInfo"] = [NSMutableDictionary dictionary];
        _val[@"initialSurveyProjectVal"] = [NSMutableArray array];
    }
    return _val;
}

- (NSMutableDictionary *)tempInitialSurveyProjectVal
{
    if(!_tempInitialSurveyProjectVal){
        _tempInitialSurveyProjectVal = [NSMutableDictionary dictionary];
    }
    return _tempInitialSurveyProjectVal;
}

- (NSDictionary *)finishCheckVal
{
    if (!_finishCheckVal) {
        _finishCheckVal = [NSMutableDictionary dictionary];
    }
    return _finishCheckVal;
}

- (void)setModels:(NSMutableArray *)models
{
    YHSurveyCheckProjectModel *baseModel = [[YHSurveyCheckProjectModel alloc] init];
    baseModel.name = @"基本信息";
    [models insertObject:baseModel atIndex:0];
    _models = models;
    baseModel.isFinish = (BOOL)self.baseInfo;
    self.submitBtn.hidden = NO;
    [self.tableView reloadData];
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitBtn.backgroundColor = YHNaviColor;
        [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        kViewRadius(_submitBtn, 10);
        _submitBtn.hidden = YES;
    }
    
    return _submitBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHSurveyCheckProjectCell" bundle:nil] forCellReuseIdentifier:@"YHSurveyCheckProjectCell"];
        _tableView.rowHeight = 72;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //[_tableView registerNib:[UINib nibWithNibName:@"AccidentDiagnosisCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //_tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
        //_tableView.contentOffset = CGPointMake(0, 0);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        //_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.backgroundColor = YHBackgroundColor;
    }
    return _tableView;
}


- (IBAction)popViewController:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHCheckListDetailViewController class]]) {
            [obj loadNewData1];//哈哈
            *stop = YES;
        }
    }];
    [self popToViewcontrollers:@[[YHOrderDetailController class],
                                 [YHCheckListDetailViewController class],
                                 [YHOrderListController class],
                                 [YHWebFuncViewController class]]];
}
@end
