//
//  YHIntelligentDiagnoseController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.test
//

#import "YTDepthController.h"
#import "YHDiagnoseView.h"
#import "YHPushPhoneView.h"
#import "YHPushPhoneView.h"
#import "YHBaseRepairTableViewCell.h"
#import "YHRepairPartTableViewCell.h"
#import "YHRepairAddController.h"
#import "ZZAlertViewController.h"
#import <MJExtension.h>
#import "YHWebFuncViewController.h"
#import "YHNoPayStatusView.h"
#import "YHCarPhotoService.h"
#import "WXPay.h"
#import "YTCounterController.h"
#import "YHExtendedView.h"
#import "YHCarPhotoService.h"
#import "YHInputQualityCell.h"
#import "YHQualityTableViewCell.h"
#import "YHOrderListController.h"
#import "OilCell.h"
#import "YHHUPhotoBrowser.h"
#import "TTZHeaderTagCell.h"
#import "TTZSurveyModel.h"
#import "YTSysController.h"
#import "ResultCell.h"

@interface YTDepthController () <UICollectionViewDataSource,UITableViewDataSource,
UICollectionViewDelegate,UITableViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UITableView *repairTableview;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, strong) NSMutableArray *repairTitleArr;
@property (nonatomic, assign) BOOL isNOEdit;
@property (nonatomic,copy) NSDictionary *repairCellInfo;
@property (nonatomic, strong) NSMutableArray *intelligentInfo;
@property (nonatomic, strong) NSMutableArray *repairProjectArr;
@property (nonatomic, strong) NSMutableDictionary *qualityItemDict;
@property (nonatomic, strong) NSMutableArray *parttypeList;
@property (nonatomic, strong) NSMutableArray *partTypeNameList;
@property (nonatomic, strong) YHSchemeModel *schemeModel;
@property (nonatomic, strong) NSString *pushPhone;
@property (nonatomic, weak) YHNoPayStatusView *noPayView;
@property (nonatomic, strong) YHDiagnoseView *diagNoseView;
@property (nonatomic, assign) NSInteger tutorial;//0.无 1.有视频教程信息
@property (nonatomic, strong) UICollectionView *headerView;
/** 当前索引*/
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong)  NSMutableArray <TTZGroundModel *>*gModels;

@end

@implementation YTDepthController

- (YHNoPayStatusView *)noPayView{
    if (!_noPayView) {
        
        CGFloat bottonMargin = iPhoneX ? 34 : 0;
        CGFloat topMargin = IphoneX ? 88 : 64;
        
        YHNoPayStatusView *noPayView = [[NSBundle mainBundle] loadNibNamed:@"YHNoPayStatusView" owner:nil options:nil].firstObject;
        [self.view addSubview:noPayView];
        [self.view bringSubviewToFront:noPayView];
        [noPayView.immediatelyPayBtn addTarget:self action:@selector(immediatelyPayBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [noPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@(topMargin));
            make.bottom.equalTo(@(bottonMargin));
        }];
        _noPayView = noPayView;
    }
    return _noPayView;
}
#pragma mark --- 立即购买 ---
- (void)immediatelyPayBtnClickEvent{
    
    [self popViewController:nil];
    return;
    __block YHWebFuncViewController *vc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            vc = obj;
            *stop = YES;
        }
    }];
    if (!vc) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBase];
    [self setUI];
    [self getIntelligentReport];
    [self getPartTypeList];
    if(![self.orderType isEqualToString:@"A"]){
    self.tutorial = self.reportModel.tutorial_list.count ? 1 : 0;
    }
    [self setData];
    
    if (self.reportModel.maintain_scheme.count > 1 && ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"] )) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除方案" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    
    if (self.reportModel.maintain_scheme.count > 1 && ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"])) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除方案" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    if (self.reportModel.maintain_scheme.count > 1 && ([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"])) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除方案" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.repairTableview reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)rightBarButtonItemClick{
    
    if (!self.schemeModel.repairCaseId) {
        
        if (self.reportModel.maintain_scheme && self.reportModel.maintain_scheme.count >= self.index) {
            [self.reportModel.maintain_scheme removeObjectAtIndex:self.index];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.orderType isEqualToString:@"AirConditioner"]) {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] delReportMaintainBillId:self.order_id caseId:self.schemeModel.repairCaseId onComplete:^(NSDictionary *info) {
            if ([[NSString stringWithFormat:@"%@",info[@"code"]] isEqualToString:@"20000"]) {
                [MBProgressHUD showError:@"删除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.removeRepairCaseSuccessOperation) {
                        self.removeRepairCaseSuccessOperation();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [MBProgressHUD showError:@"删除失败"];
            }
        } onError:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        return;
    }
    
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] removeRepairCaseBillId:self.order_id caseId:self.schemeModel.repairCaseId onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[NSString stringWithFormat:@"%@",info[@"code"]] isEqualToString:@"20000"]) {
            [MBProgressHUD showError:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.removeRepairCaseSuccessOperation) {
                    self.removeRepairCaseSuccessOperation();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showError:@"删除失败"];
        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (void)getPartTypeList{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getPartTypeList:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            NSDictionary *dataDict = info[@"data"];
            NSArray *partTypeList = dataDict[@"list"];
            
            NSMutableArray *partTypeNameList = [NSMutableArray array];
            for (NSDictionary *element in partTypeList) {
                NSString *value = element[@"value"];
                [partTypeNameList addObject:value];
            }
            self.partTypeNameList = partTypeNameList;
            self.parttypeList = [NSMutableArray arrayWithArray:partTypeList] ;
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)getIntelligentReport{
    
    YHSchemeModel *schemeModel = self.schemeModel;
    self.schemeModel = schemeModel;
    
    if (!self.reportModel) { // 未支付
        self.noPayView.diagnoseContentL.text = @"诊断结果及维修方式数据整理中，请稍等片刻或者选择返回列表";
        self.noPayView.diagnoseTilLeL.text = @"注意";
        [self.noPayView.immediatelyPayBtn setTitle:[NSString stringWithFormat:@"返回列表"] forState:UIControlStateNormal];
    }else{
        [self.noPayView removeFromSuperview];
        self.noPayView = nil;
        self.repairTableview.hidden = NO;
    }
    
    if (self.schemeModel.quality_km.floatValue == 0) {
        self.schemeModel.quality_km = @"";
    }
    
    if (self.schemeModel.quality_time.floatValue == 0) {
        self.schemeModel.quality_time = @"";
    }
    
    [schemeModel.parts enumerateObjectsUsingBlock:^(YHPartsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.part_price.floatValue == 0) {
            obj.part_price = @"";
        }
        if (obj.part_count.intValue == 0) {
            obj.part_count = @"";
        }
    }];
    [schemeModel.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.consumable_price.floatValue == 0) {
            obj.consumable_price = @"";
        }
        if (obj.consumable_count.intValue == 0) {
            obj.consumable_count = @"";
        }
    }];
    [schemeModel.labor enumerateObjectsUsingBlock:^(YHLaborModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.labor_price.floatValue == 0) {
            obj.labor_price = @"";
        }
    }];
    [self.repairTableview reloadData];
    
}

- (YHSchemeModel *)schemeModel{
    if (!_schemeModel) {
        if ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"]  || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"J004"]) {
            YHSchemeModel *schemeModel = self.reportModel.maintain_scheme.count ? self.reportModel.maintain_scheme[self.index] : nil;
            _schemeModel = schemeModel?:[YHSchemeModel new];
        }else if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
            YHSchemeModel *schemeModel = self.reportModel.maintain_scheme.count ? self.reportModel.maintain_scheme[self.index] : nil;
            _schemeModel = schemeModel?:[YHSchemeModel new];
        }else if ([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]) {
            YHSchemeModel *schemeModel = self.reportModel.maintain_scheme.count ? self.reportModel.maintain_scheme[self.index] : nil;
            _schemeModel = schemeModel?:[YHSchemeModel new];
        }else{
            YHSchemeModel *schemeModel = self.reportModel.maintain_scheme.count ? self.reportModel.maintain_scheme.firstObject : nil;
            _schemeModel = schemeModel?:[YHSchemeModel new];
        }
        
    }
    return _schemeModel;
}

- (void)setData{
    
    self.repairTitleArr = [NSMutableArray array];

    if([self.orderType isEqualToString:@"Y002"]){
    [self.repairTitleArr addObject:@"基础信息"];
    }
    
    [self.repairTitleArr addObject:@"诊断结果"];
    
    
    if(self.tutorial == 1 && ![self.orderType isEqualToString:@"Y002"]){
        [self.repairTitleArr addObject:@"配置建议"];
    }else if([self.orderType isEqualToString:@"Y002"]){
        self.tutorial += 1;
    }
    
    [self.repairTitleArr addObject:@"设置配件"];
    [self.repairTitleArr addObject:@"设置耗材"];
    [self.repairTitleArr addObject:@"维修项目"];
    [self.repairTitleArr addObject:@"维修总计"];
    [self.repairTitleArr addObject:@"质保内容"];
    [self.repairTitleArr addObject:@"4S店维修参考价"];
    
    if([self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"]){
        
        [self.repairTitleArr removeObject:@"质保内容"];
        [self.repairTitleArr removeObject:@"4S店维修参考价"];
        if([self.orderType isEqualToString:@"J006"]){
        [self.repairTitleArr replaceObjectAtIndex:4 + self.tutorial withObject:@"小计"];
        }
        
    }
    
    if([self.orderType isEqualToString:@"J009"]){
        [self.repairTitleArr removeObject:@"4S店维修参考价"];
    }
    
    self.gModels = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < self.repairTitleArr.count; i++) {
        
        if(i || !([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J007"] || [self.orderType isEqualToString:@"J009"] || [self.orderType isEqualToString:@"J004"])  || [self.orderType isEqualToString:@"Y002"] ){
            
            NSString *str = self.repairTitleArr[i];
            
            if([str hasSuffix:@"计"] && ![self.orderType isEqualToString:@"A"])break;
            
            TTZGroundModel *model = [TTZGroundModel new];
            model.projectName = self.repairTitleArr[i];
            [self.gModels addObject:model];
            
        }
    }
    
    TTZGroundModel *model = self.gModels.firstObject;
    model.isSelected = YES;//默认选中第一个
    
    
    //    [self.repairTitleArr addObject:@"推送手机号"];
    
    [self repairCellInfo];
    
}

- (void)setBase{
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.title = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] ) ? @"方案详情": [self.orderType isEqualToString:@"Y002"] ? @"延长保修" :@"深度诊断";
    
    if ([self.orderType isEqualToString:@"J005"]) {
        self.title = @"深度诊断";
    }
    
    if ([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]) {
        self.title = @"AI智能检测";
    }
    
    if([self.orderType isEqualToString:@"J007"]){
        self.title = @"AI尾气诊断";
    }
    
    if([self.orderType isEqualToString:@"J004"]){
        self.title = @"汽车检测";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextContentChange:) name:@"textChangeWriteData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repairTextChangeNoti:) name:@"repairTextChange_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalPriceWithPresentBtnClick) name:@"presentStatusChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editQualityDescText:) name:@"quality_descTextEnd" object:nil];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新诊断" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClickEvent)];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}
- (void)editQualityDescText:(NSNotification *)noti{
    self.schemeModel.quality_desc = noti.userInfo[@"quality_desc"];
}
- (void)refreshTotalPriceWithPresentBtnClick{
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}

- (void)textFieldTextContentChange:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    NSString *text = userInfo[@"textContent"];
    
    if (indexPath.section == 5 + self.tutorial) {
        if (indexPath.row == 0) {
            self.schemeModel.quality_time = text;
        }
        
        if (indexPath.row == 1) {
            self.schemeModel.quality_km = text;
        }
    }else if(indexPath.section == 6 + self.tutorial){
        self.schemeModel.price_ssss = text;
    }
    
    [self.repairTableview reloadData];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)repairTextChangeNoti:(NSNotification *)noti{
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}

- (void)popViewController:(id)sender{
    
    if ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]   || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"J004"]) {
        [super popViewController:sender];
        return;
    }
    
    if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
        [super popViewController:sender];
        return;
    }
    
    if ([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]) {
        [super popViewController:sender];
        return;
    }
    
    
    //    if ([self.orderType isEqualToString:@"J005"]) {
    
    NSMutableArray *newVC = [NSMutableArray array];
    NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
    //        [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if (![obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
    //                [newVC addObject:obj];
    //            }
    //            [newVC addObject:obj];
    //            *stop = YES;
    //        }];
    [newVC addObject:controllers.firstObject];
    
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_list&bill_type=%@&status=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.order_id,self.orderType,self.orderType];
    
    if([self.orderType isEqualToString:@"Y002"]){
        if([controllers[controllers.count - 2] isKindOfClass:NSClassFromString(@"YHOrderDetailController")] || [controllers[controllers.count - 3] isKindOfClass:NSClassFromString(@"YHOrderDetailController")]){
            NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
            [arr removeLastObject];
            if([controllers[controllers.count - 3] isKindOfClass:NSClassFromString(@"YHOrderDetailController")]){
            [arr removeLastObject];
            }
            self.navigationController.viewControllers = arr;
            [super popViewController:sender];
            return;
        }
    }
    controller.urlStr = urlString;
    controller.barHidden = YES;
    [newVC addObject:controller];
    [self.navigationController setViewControllers:newVC];
    
    return;
    //    }
    //    __block YHWebFuncViewController *vc = nil;
    //    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSLog(@"%@",obj);
    //        if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
    //            [self.navigationController popToViewController:obj animated:YES];
    //            vc = obj;
    //            *stop = YES;
    //        }
    //    }];
    //
    //    NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"airCondition",@"token":[YHTools getAccessToken]} mj_JSONString];
    //    [vc appToH5:json];
}

- (void)rightBtnClickEvent{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI{
    
    CGFloat bottonMargin = iPhoneX ? 34 : 0;
    //    CGFloat topMargin = IphoneX ? 88 : 64;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.repairTableview];
    
    if (@available(iOS 11.0, *)) {
        self.headerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.repairTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.repairTableview = tableview;
    tableview.hidden = YES;
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
//    tableview.estimatedSectionFooterHeight = 0;
    
     if([self.orderType isEqualToString:@"Y002"]){
         
         YHExtendedView *v = [[NSBundle mainBundle] loadNibNamed:@"YHExtendedView" owner:nil options:nil].firstObject;
         v.baseInfo = self.reportModel.baseInfo;
         tableview.tableHeaderView = v;
         
     }else{
         
         tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
         
     }
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(tableview.superview).offset(-bottonMargin);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 73)];
    UIButton *bottomBtn = [UIButton new];
    self.bottomBtn = bottomBtn;
    //NSString *title = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]) ? @"保存方案":@"推送车主";
    NSString *title = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"] ) ? @"保存方案":@"生成报告";

    if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
        title = @"保存方案";
    }
    
    if ([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]) {
        title = @"保存方案";
    }
    
    if ([self.orderType isEqualToString:@"Y002"]) {
        title = @"下一步";
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(bottomBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag = 1;
        [rightBtn setTitle:@"保存" forState: UIControlStateNormal];
        [rightBtn setTitleColor:YHNagavitionBarTextColor forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn] ;
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 8.0;
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.backgroundColor = YHNaviColor;
    [footView addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-20));
    }];
    tableview.tableFooterView = footView;
    
    if (@available(iOS 11.0, *)) {
        self.repairTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.repairTableview.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
}

- (NSDictionary *)repairCellInfo{
    if (!_repairCellInfo) {
        NSString *repairInfoPath  = [[NSBundle mainBundle] pathForResource:@"YTDepthCellList.plist" ofType:nil];
        NSDictionary *repairCellInfo = [NSDictionary dictionaryWithContentsOfFile:repairInfoPath];
        _repairCellInfo = repairCellInfo;
    }
    return _repairCellInfo;
}

- (NSMutableDictionary *)titleInfo{
    
    YHSchemeModel *schemeModel = self.schemeModel;
    
    NSMutableDictionary *titleInfo = [NSMutableDictionary dictionary];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:@"0"];
    
    if(self.tutorial){
        [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:[NSString stringWithFormat:@"%ld",(long)self.tutorial]];
    }
    
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 6]];
    //    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:@"7"];
    
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.repairProjectArr.count] forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 4]];
    [titleInfo setValue:self.isNOEdit ? @1 : @2 forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 5]];
    if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
        [titleInfo setValue:@(1) forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 5]];
    }
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.labor.count] forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 3]];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.consumable.count] forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 2]];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.parts.count] forKey:[NSString stringWithFormat:@"%ld",self.tutorial + 1]];
    
    return titleInfo;
}
#pragma 底部按钮点击事件 ----
- (void)bottomBtnClickEvent:(UIButton *)bottomBtn{
    
    NSDictionary *paramDict = nil;
    if ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"]) {
        paramDict = [self structureSubmitDataJ002];
    }else if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"] || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"A"]){
        paramDict = [self structureSubmitDataJ002];
    }else if([self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]){
        paramDict = [self structureSubmitDataJ002];
    }else{
        paramDict = [self structureSubmitData];
    }
    
    if (!paramDict) {
        return;
    }
    
    
     if ([self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"A"]) {
         
         [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveStoreExtWarrantyReportQuote:paramDict onComplete:^(NSDictionary *info) {
             
             NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
             if ([code isEqualToString:@"20000"]) {
                 
                 if([self.orderType isEqualToString:@"A"]){
                 if (_removeRepairCaseSuccessOperation) {
                     _removeRepairCaseSuccessOperation();
                 }
                 [self.navigationController popViewControllerAnimated:YES];
                 return ;
                 }
                 
                 if(!bottomBtn.tag){
                     YTSysController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTSysController"];
                      vc.billId = self.order_id;
                     [self.navigationController pushViewController:vc animated:YES];
                    
                 }else{
                     [MBProgressHUD showSuccess:@"保存成功"];
                 }
                 
             }
             
             if([code isEqualToString:@"40000"]){
                 
                 [MBProgressHUD showError:info[@"msg"]];
             }
             
         } onError:^(NSError *error) {
             
             if (error) {
                 NSLog(@"%@",error);
             }
         }];
         return;
     }
    
    [bottomBtn YH_showStartLoadStatus];
    //bottomBtn.YH_loadStatusTitle = @"推送中...";
    bottomBtn.YH_loadStatusTitle = @"生成中...";

    if ([self.orderType isEqualToString:@"AirConditioner"]) {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitAirConditionerReport:paramDict onComplete:^(NSDictionary *info) {
            [bottomBtn YH_showEndLoadStatus];
            if ([self.orderType isEqualToString:@"AirConditioner"]){
                bottomBtn.YH_normalTitle = @"保存方案";
            }
            
            NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
            if ([code isEqualToString:@"20000"]) {
                
                
                if ([self.orderType isEqualToString:@"AirConditioner"]){
                    if (_removeRepairCaseSuccessOperation) {
                        _removeRepairCaseSuccessOperation();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
            }
            
            if([code isEqualToString:@"40000"]){
                
                [MBProgressHUD showError:info[@"msg"]];
            }
            
        } onError:^(NSError *error) {
            [bottomBtn YH_showEndLoadStatus];
            if ([self.orderType isEqualToString:@"AirConditioner"]){
                bottomBtn.YH_normalTitle = @"保存方案";
            }
            //bottomBtn.YH_normalTitle = [self.orderType isEqualToString:@"J002"] ? @"保存方案": @"推送车主";
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        return;
    }
    
   if([self.orderType isEqualToString:@"J009"]) {
       // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
       BOOL isVerifier = NO;
       if(isVerifier){
           
           
           return;
       }
       
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitJ009Report:paramDict onComplete:^(NSDictionary *info) {
            [bottomBtn YH_showEndLoadStatus];
           
                bottomBtn.YH_normalTitle = @"保存方案";
          
            
            NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
            if ([code isEqualToString:@"20000"]) {
                
                    if (_removeRepairCaseSuccessOperation) {
                        _removeRepairCaseSuccessOperation();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                
            }
            
            if([code isEqualToString:@"40000"]){
                
                [MBProgressHUD showError:info[@"msg"]];
            }
            
        } onError:^(NSError *error) {
            [bottomBtn YH_showEndLoadStatus];
            if ([self.orderType isEqualToString:@"J009"]){
                bottomBtn.YH_normalTitle = @"保存方案";
            }
            //bottomBtn.YH_normalTitle = [self.orderType isEqualToString:@"J002"] ? @"保存方案": @"推送车主";
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        return;
    }
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitDepthDiagnoseReport:paramDict onComplete:^(NSDictionary *info) {
        [bottomBtn YH_showEndLoadStatus];
        //bottomBtn.YH_normalTitle = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]) ? @"保存方案": @"推送车主";
        bottomBtn.YH_normalTitle = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"]) ? @"保存方案": @"生成报告";

        if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
            bottomBtn.YH_normalTitle = @"保存方案";
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            if ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"] ) {
                if (_removeRepairCaseSuccessOperation) {
                    _removeRepairCaseSuccessOperation();
                }
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
                if (_removeRepairCaseSuccessOperation) {
                    _removeRepairCaseSuccessOperation();
                }
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            
            
            
            
            //支付页面
            YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
            vc.billId = self.order_id;
            vc.billType = self.orderType;
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
    } onError:^(NSError *error) {
        [bottomBtn YH_showEndLoadStatus];
        //bottomBtn.YH_normalTitle = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]) ? @"保存方案": @"推送车主";
        bottomBtn.YH_normalTitle = ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"] || [self.orderType isEqualToString:@"J004"] ) ? @"保存方案": @"生成报告";

        
        if ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) {
            bottomBtn.YH_normalTitle = @"保存方案";
        }
        
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

//配置建议跳转
- (void)ConfigurationInfo:(TutorialListModel *)model{
    
    if(!model.pay_status.intValue){
        //支付页面
        YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
        vc.billId = self.order_id;
        vc.parts_suggestion_id = model.parts_suggestion_id;
        vc.billType = self.orderType;
        vc.block = ^{
            
            model.pay_status = @"1";
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [self.repairTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        if([model.code isEqualToString:@"circuit"]){//电路图
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
            NSMutableDictionary *info = self.orderInfo? self.orderInfo.mutableCopy : [NSMutableDictionary dictionary];
            info[@"id"] = self.order_id;
            controller.orderInfo = info;
            controller.functionKey = YHFunctionIdCircuitDiagram;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        if([model.code isEqualToString:@"reset_tutorial"]){//复位教程
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"token"] = [YHTools getAccessToken];
            dic[@"car_brand"] = self.reportModel.baseInfo.carBrandName;
            dic[@"car_line"] = self.reportModel.baseInfo.carLineName;
            dic[@"car_produceYear"] = self.reportModel.baseInfo.carYear;
            [[YHNetworkPHPManager sharedYHNetworkPHPManager] getOilReset:dic onComplete:^(NSDictionary *info) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                if([info[@"code"] intValue] == 20000){
                    
                    NSArray *arr = info[@"data"][@"list"];
                    if(arr.count){
                        [YHHUPhotoBrowser showFromImageView:nil withURLStrings:arr placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
                    }
                }
                
            } onError:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
            }];
        }
        
        if([model.code isEqualToString:@"oil"]){//机油
            
        }
        
        if([model.code isEqualToString:@"gearbox_oil"]){//波箱油
            
        }
        
        if([model.code isEqualToString:@"cell"]){//电池
            
        }
        
        if([model.code isEqualToString:@"antifreeze"]){//防冻液
            
        }
    }
}


- (NSDictionary *)structureSubmitDataJ002{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:[YHTools getAccessToken] forKey:@"token"];
    if ([self.orderType isEqualToString:@"AirConditioner"]) {
        [paramDict setValue:self.order_id forKey:@"order_id"];
    }else [paramDict setValue:self.order_id forKey:@"billId"];
    
    NSMutableDictionary *maintain_scheme = [NSMutableDictionary dictionary];
    [maintain_scheme setValue:self.schemeModel.repairCaseId forKey:@"id"];
    [maintain_scheme setValue:self.schemeModel.name forKey:@"name"];
    
    BOOL isLeastExistOne = NO;
    // 配件
    if (self.schemeModel.parts.count > 0) {
        NSMutableArray *partArr = [NSMutableArray array];
        for (YHPartsModel *partModel in self.schemeModel.parts) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            if (!partModel.part_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件名称不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_name forKey:@"part_name"];
            [mutableDict setValue:partModel.part_type forKey:@"part_type"];
            
            [mutableDict setValue:partModel.part_brand forKey:@"part_brand"];
            [mutableDict setValue:partModel.part_type_name forKey:@"part_type_name"];
            
            
            //            if (!partModel.part_unit.length) {
            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件单位不能为空",partModel.part_name]];
            //                return nil;
            //            }
            [mutableDict setValue:partModel.part_unit forKey:@"part_unit"];
            
            if (IsEmptyStr(partModel.part_count)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件数量不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_count forKey:@"part_count"];
            
            if (IsEmptyStr(partModel.part_price)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件价格不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_price forKey:@"part_price"];
            [mutableDict setValue:partModel.status ? : @"2" forKey:@"status"];
            [partArr addObject:mutableDict];
        }
        
        [maintain_scheme setValue:partArr forKey:@"parts"];
        if (partArr.count) {
            isLeastExistOne = YES;
        }
    }
    
    // 耗材
    if (self.schemeModel.consumable.count > 0) {
        
        NSMutableArray *consumableArr = [NSMutableArray array];
        for (YHConsumableModel *consumableModel in self.schemeModel.consumable) {
            NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
            if (!consumableModel.consumable_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材名称不能为空",consumableModel.consumable_name]];
                return nil;
            }
            [consumableDict setValue:consumableModel.consumable_name forKey:@"consumable_name"];
            [consumableDict setValue:consumableModel.consumable_standard forKey:@"consumable_standard"];
            
            
            [consumableDict setValue:consumableModel.consumable_brand forKey:@"consumable_brand"];
            
            //            if (!consumableModel.consumable_unit.length) {
            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材单位不能为空",consumableModel.consumable_name]];
            //                return nil;
            //            }
            [consumableDict setValue:consumableModel.consumable_unit forKey:@"consumable_unit"];
            
            if (IsEmptyStr(consumableModel.consumable_count)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材数量不能为空",consumableModel.consumable_name]];
                return nil;
            }
            [consumableDict setValue:consumableModel.consumable_count forKey:@"consumable_count"];
            
            if (IsEmptyStr(consumableModel.consumable_price)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材价格不能为空",consumableModel.consumable_name]];
                return nil;
            }
            
            [consumableDict setValue:consumableModel.consumable_price forKey:@"consumable_price"];
            [consumableDict setValue:consumableModel.status forKey:@"status"];
            [consumableDict setValue:consumableModel.suggested_status forKey:@"suggested_status"];
            [consumableArr addObject:consumableDict];
        }
        
        [maintain_scheme setValue:consumableArr forKey:@"consumable"];
        if (consumableArr.count) {
            isLeastExistOne = YES;
        }
    }
    // 维修项目
    if (self.schemeModel.labor.count > 0) {
        
        NSMutableArray *laborArr = [NSMutableArray array];
        for (YHLaborModel *laborModel in self.schemeModel.labor) {
            NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
            if (!laborModel.labor_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目名称不能为空",laborModel.labor_name]];
                return nil;
            }
            [laborDict setValue:laborModel.labor_name forKey:@"labor_name"];
            
            if([self.orderType isEqualToString:@"J006"]){
                if(IsEmptyStr(laborModel.labor_time)){
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目工时不能为空",laborModel.labor_name]];
                    return nil;
                }
            }else{
                if (IsEmptyStr(laborModel.labor_price)) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目价格不能为空",laborModel.labor_name]];
                    return nil;
                }
            }
            
            if([self.orderType isEqualToString:@"J006"]){
                [laborDict setValue: laborModel.labor_time  forKey:@"labor_time"];
                [laborDict setValue: @"0.00"  forKey:@"labor_price"];
            }else{
                [laborDict setValue: laborModel.labor_price  forKey:@"labor_price"];
            };
            [laborDict setValue:laborModel.status forKey:@"status"];
            [laborArr addObject:laborDict];
        }
        [maintain_scheme setValue:laborArr forKey:@"labor"];
        if (laborArr.count) {
            isLeastExistOne = YES;
        }
    }
    
    if(![self.orderType isEqualToString:@"A"]){
    if (!self.schemeModel.quality_km) {
        [MBProgressHUD showError:@"质保公里不能为空！"];
        return nil;
    }
    [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
    if (!self.schemeModel.quality_time) {
        [MBProgressHUD showError:@"质保时长不能为空！"];
        return nil;
    }
    [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
    
    if (self.schemeModel.price_ssss.floatValue > 0) {
        [maintain_scheme setValue:self.schemeModel.price_ssss forKey:@"price_ssss"];
    }
    
    if([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]){
        [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
        NSString *qualityString = [self.schemeModel.quality_desc stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        [maintain_scheme setValue:[NSString stringWithFormat:@"%@",qualityString] forKey:@"quality_desc"];
    }
    }
    
    if (!isLeastExistOne) {
        [MBProgressHUD showError:@"配件、耗材、维修项目至少要存在一个才能提交"];
        return nil;
    }
    [paramDict setValue:maintain_scheme forKey:@"maintain_info"];
    return paramDict;
}

//- (NSDictionary *)structureSubmitDataY002{
//
//    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//    [paramDict setValue:[YHTools getAccessToken] forKey:@"token"];
//    [paramDict setValue:self.order_id forKey:@"billId"];
//
//    NSMutableDictionary *maintain_scheme = [NSMutableDictionary dictionary];
////    [maintain_scheme setValue:self.schemeModel.repairCaseId forKey:@"id"];
////    [maintain_scheme setValue:self.schemeModel.name forKey:@"name"];
//    [paramDict setValue:maintain_scheme forKey:@"maintenance"];
//
//    BOOL isLeastExistOne = NO;
//    NSMutableArray *partArr = [NSMutableArray array];
//    // 配件
//    if (self.schemeModel.parts.count > 0) {
//
//        for (YHPartsModel *partModel in self.schemeModel.parts) {
//            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//            if (!partModel.part_name.length) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件名称不能为空",partModel.part_name]];
//                return nil;
//            }
//            [mutableDict setValue:partModel.part_name forKey:@"partName"];
//            [mutableDict setValue:@(1) forKey:@"partType"];
//            [mutableDict setValue:partModel.part_type_name forKey:@"kind"];//配件类别 2:原厂件，1：品牌（OEM），3：副厂件，4：二手件，0：-
//            [mutableDict setValue:partModel.part_brand forKey:@"brand"];
//
//            //            if (!partModel.part_unit.length) {
//            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件单位不能为空",partModel.part_name]];
//            //                return nil;
//            //            }
//            [mutableDict setValue:partModel.part_unit forKey:@"partUnit"];
//
//            if (IsEmptyStr(partModel.part_count)) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件数量不能为空",partModel.part_name]];
//                return nil;
//            }
//            [mutableDict setValue:partModel.part_count forKey:@"scalar"];
//
//            if (IsEmptyStr(partModel.part_price)) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件价格不能为空",partModel.part_name]];
//                return nil;
//            }
//            [mutableDict setValue:partModel.part_price forKey:@"price"];
////            [mutableDict setValue:partModel.status ? : @"2" forKey:@"status"];
//            [partArr addObject:mutableDict];
//        }
//
////        [maintain_scheme setValue:partArr forKey:@"parts"];
//        if (partArr.count) {
//            isLeastExistOne = YES;
//        }
//    }
//
//    // 耗材
//    if (self.schemeModel.consumable.count > 0) {
//
//        NSMutableArray *consumableArr = [NSMutableArray array];
//        for (YHConsumableModel *consumableModel in self.schemeModel.consumable) {
//            NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
//            if (!consumableModel.consumable_name.length) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材名称不能为空",consumableModel.consumable_name]];
//                return nil;
//            }
//            [consumableDict setValue:consumableModel.consumable_name forKey:@"partName"];
//            [consumableDict setValue:@(2) forKey:@"partType"];
//            [consumableDict setValue:consumableModel.consumable_standard forKey:@"specification"];//耗材规格
//            [consumableDict setValue:consumableModel.consumable_standard forKey:@"modelNumber"];//耗材型号
//            [consumableDict setValue:consumableModel.consumable_standard forKey:@"kind"];//配件类别 2:原厂件，1：品牌（OEM），3：副厂件，4：二手件，0：-
//            [consumableDict setValue:consumableModel.consumable_brand forKey:@"brand"];//品牌
//
//            //            if (!consumableModel.consumable_unit.length) {
//            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材单位不能为空",consumableModel.consumable_name]];
//            //                return nil;
//            //            }
//            [consumableDict setValue:consumableModel.consumable_unit forKey:@"partUnit"];//
//
//            if (IsEmptyStr(consumableModel.consumable_count)) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材数量不能为空",consumableModel.consumable_name]];
//                return nil;
//            }
//            [consumableDict setValue:consumableModel.consumable_count forKey:@"scalar"];//耗材数量
//
//            if (IsEmptyStr(consumableModel.consumable_price)) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材价格不能为空",consumableModel.consumable_name]];
//                return nil;
//            }
//
//            [consumableDict setValue:consumableModel.consumable_price forKey:@"price"];//价格
////            [consumableDict setValue:consumableModel.status forKey:@"status"];
////            [consumableDict setValue:consumableModel.suggested_status forKey:@"suggested_status"];
//            [consumableArr addObject:consumableDict];
//        }
//        [partArr addObjectsFromArray:consumableArr];
//        [maintain_scheme setValue:partArr forKey:@"parts"];
//        if (consumableArr.count) {
//            isLeastExistOne = YES;
//        }
//    }
//    // 维修项目
//    if (self.schemeModel.labor.count > 0) {
//
//        NSMutableArray *laborArr = [NSMutableArray array];
//        for (YHLaborModel *laborModel in self.schemeModel.labor) {
//            NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
//            if (!laborModel.labor_name.length) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目名称不能为空",laborModel.labor_name]];
//                return nil;
//            }
//            [laborDict setValue:laborModel.labor_name forKey:@"maintenanceName"];
//
//                if (IsEmptyStr(laborModel.labor_price)) {
//                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目价格不能为空",laborModel.labor_name]];
//                    return nil;
//                }
//                [laborDict setValue: laborModel.labor_price  forKey:@"maintenancePrice"];
////            [laborDict setValue:laborModel.status forKey:@"status"];
//            [laborArr addObject:laborDict];
//        }
//        [maintain_scheme setValue:laborArr forKey:@"maintenanceMode"];
//        if (laborArr.count) {
//            isLeastExistOne = YES;
//        }
//    }
//
//    if (!self.schemeModel.quality_km) {
//        [MBProgressHUD showError:@"质保公里不能为空！"];
//        return nil;
//    }
//    [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
//    if (!self.schemeModel.quality_time) {
//        [MBProgressHUD showError:@"质保时长不能为空！"];
//        return nil;
//    }
//    [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
//
//    if (self.schemeModel.price_ssss.floatValue > 0) {
//        [maintain_scheme setValue:self.schemeModel.price_ssss forKey:@"price_ssss"];
//    }
//
//    if([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]){
//        [maintain_scheme setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
//        NSString *qualityString = [self.schemeModel.quality_desc stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
//        [maintain_scheme setValue:[NSString stringWithFormat:@"%@",qualityString] forKey:@"quality_desc"];
//    }
//
//    if (!isLeastExistOne) {
//        [MBProgressHUD showError:@"配件、耗材、维修项目至少要存在一个才能提交"];
//        return nil;
//    }
//    [paramDict setValue:maintain_scheme forKey:@"maintain_info"];
//    return paramDict;
//}

- (NSDictionary *)structureSubmitData{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:[YHTools getAccessToken] forKey:@"token"];
    [paramDict setValue:self.order_id forKey:@"billId"];
    
    NSMutableArray *maintain_scheme = [NSMutableArray array];
    [paramDict setValue:maintain_scheme forKey:@"maintain_scheme"];
    
    BOOL isLeastExistOne = NO;
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setValue:self.schemeModel.name forKey:@"name"];
    // 配件
    if (self.schemeModel.parts.count > 0) {
        NSMutableArray *partArr = [NSMutableArray array];
        for (YHPartsModel *partModel in self.schemeModel.parts) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            if (!partModel.part_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件名称不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_name forKey:@"part_name"];
            [mutableDict setValue:partModel.part_type forKey:@"part_type"];
            
            [mutableDict setValue:partModel.part_brand forKey:@"part_brand"];
            [mutableDict setValue:partModel.part_type_name forKey:@"part_type_name"];
            
            
            //            if (!partModel.part_unit.length) {
            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件单位不能为空",partModel.part_name]];
            //                return nil;
            //            }
            [mutableDict setValue:partModel.part_unit forKey:@"part_unit"];
            
            if (IsEmptyStr(partModel.part_count)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件数量不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_count forKey:@"part_count"];
            
            if (IsEmptyStr(partModel.part_price)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件价格不能为空",partModel.part_name]];
                return nil;
            }
            [mutableDict setValue:partModel.part_price forKey:@"part_price"];
            [mutableDict setValue:partModel.status forKey:@"status"];
            [partArr addObject:mutableDict];
        }
        
        [resultDict setValue:partArr forKey:@"parts"];
        if (partArr.count) {
            isLeastExistOne = YES;
        }
    }
    
    // 耗材
    if (self.schemeModel.consumable.count > 0) {
        
        NSMutableArray *consumableArr = [NSMutableArray array];
        for (YHConsumableModel *consumableModel in self.schemeModel.consumable) {
            NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
            if (!consumableModel.consumable_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材名称不能为空",consumableModel.consumable_name]];
                return nil;
            }
            [consumableDict setValue:consumableModel.consumable_name forKey:@"consumable_name"];
            [consumableDict setValue:consumableModel.consumable_standard forKey:@"consumable_standard"];
            
            [consumableDict setValue:consumableModel.consumable_brand forKey:@"consumable_brand"];
            
            //            if (!consumableModel.consumable_unit.length) {
            //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材单位不能为空",consumableModel.consumable_name]];
            //                return nil;
            //            }
            [consumableDict setValue:consumableModel.consumable_unit forKey:@"consumable_unit"];
            
            if (IsEmptyStr(consumableModel.consumable_count)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材数量不能为空",consumableModel.consumable_name]];
                return nil;
            }
            [consumableDict setValue:consumableModel.consumable_count forKey:@"consumable_count"];
            
            if (IsEmptyStr(consumableModel.consumable_price)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材价格不能为空",consumableModel.consumable_name]];
                return nil;
            }
            
            [consumableDict setValue:consumableModel.consumable_price forKey:@"consumable_price"];
            [consumableDict setValue:consumableModel.status forKey:@"status"];
            [consumableArr addObject:consumableDict];
        }
        
        [resultDict setValue:consumableArr forKey:@"consumable"];
        if (consumableArr.count) {
            isLeastExistOne = YES;
        }
    }
    // 维修项目
    if (self.schemeModel.labor.count > 0) {
        
        NSMutableArray *laborArr = [NSMutableArray array];
        for (YHLaborModel *laborModel in self.schemeModel.labor) {
            NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
            if (!laborModel.labor_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目名称不能为空",laborModel.labor_name]];
                return nil;
            }
            [laborDict setValue:laborModel.labor_name forKey:@"labor_name"];
            
            if (IsEmptyStr(laborModel.labor_price)) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目价格不能为空",laborModel.labor_name]];
                return nil;
            }
            [laborDict setValue:laborModel.labor_price forKey:@"labor_price"];
            [laborDict setValue:laborModel.status forKey:@"status"];
            [laborArr addObject:laborDict];
        }
        [resultDict setValue:laborArr forKey:@"labor"];
        if (laborArr.count) {
            isLeastExistOne = YES;
        }
    }
    
    [resultDict setValue:self.schemeModel.name forKey:@"name"];
    
    if (!self.schemeModel.quality_km) {
        [MBProgressHUD showError:@"质保公里不能为空！"];
        return nil;
    }
    
    [resultDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
    if (!self.schemeModel.quality_time) {
        [MBProgressHUD showError:@"质保时长不能为空！"];
        return nil;
    }
    [resultDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
    NSString *qualityString = [self.schemeModel.quality_desc stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [resultDict setValue:[NSString stringWithFormat:@"%@",qualityString] forKey:@"quality_desc"];
    if (self.schemeModel.price_ssss.floatValue > 0) {
        [resultDict setValue:self.schemeModel.price_ssss forKey:@"price_ssss"];
    }
    [maintain_scheme addObject:resultDict];
    
    if (!isLeastExistOne) {
        [MBProgressHUD showError:@"配件、耗材、维修项目至少要存在一个才能提交"];
        return nil;
    }
    return paramDict;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.repairTitleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *sec = [NSString stringWithFormat:@"%ld",section];
    return [self.titleInfo[sec] integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除
    __weak typeof(self)weakSelf = self;
    NSInteger index = indexPath.section ? indexPath.section - self.tutorial : indexPath.section;
    if(self.tutorial && indexPath.section == 1){//新增的资料教程cell
        
        if([self.orderType isEqualToString:@"Y002"]){
            
            ResultCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ResultCell" owner:nil options:nil].firstObject;
            NSString *result = [self.reportModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            cell.resultStr = IsEmptyStr(result)? @"暂无诊断结果" : result;
            
            return cell;
        }
        
        NSArray *modelArr = self.reportModel.tutorial_list;
        OilCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OilCell"];
        if(!cell){
            cell = [[OilCell alloc]init];
        }
        cell.arrModel = modelArr;
        cell.blockPay = ^(NSInteger idx) {//支付跳转或许查看
            TutorialListModel *model = self.reportModel.tutorial_list[idx];
            [self ConfigurationInfo:model];
        };
        
        return cell;
    }
    
    NSDictionary *cellInfo = self.repairCellInfo[[NSString stringWithFormat:@"%ld",index]];
    NSString *cellNameString = cellInfo[@"cellClass"];
    NSString *cellID =  [NSString stringWithFormat:@"%@_%ld",cellNameString,index];
    YHBaseRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellNameString owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 替换原来的质保cell
    if ([cell isKindOfClass:[YHQualityTableViewCell class]] && ([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) && index == 5) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YHInputQualityCell" owner:nil options:nil].firstObject;
        cell.cellModel = self.schemeModel;
    }
    
    cell.indexPath = indexPath;
    cell.billType = self.orderType;
    
    if ([cell isKindOfClass:[YHDiagnoseView class]]) {
        
    }
    if ([self.orderType isEqualToString:@"J002"] || [self.orderType isEqualToString:@"J006"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"]  || [self.orderType isEqualToString:@"J009"] || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"J004"]) {
        // 购买
        cell.purchaseOperation = ^(NSMutableDictionary *parts_suggestion){
            
            if([parts_suggestion[@"pay_status"] boolValue]){//查看电池跳h5
                
                YTBaseInfo  * baseModel =   self.reportModel.baseInfo;
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[NSString stringWithFormat:@"/technicalAssistant/index.html?token=%@&carBrandName=%@&status=ios&carLineName=%@&produceYear=%@&carCc=%@&sourceName=appTo_znby_dc&helperTitle=电池型号#/batteryMessage",[YHTools getAccessToken],baseModel.carBrandName,baseModel.carLineName,baseModel.carYear,baseModel.carCc],(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));//带中文的url转换
                YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                controller.urlStr = [NSString stringWithFormat:@"%@%@%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,encodedString];
                controller.title = @"电池型号";
                controller.barHidden = YES;
                controller.isFeedBackPush = YES;
                [self.navigationController pushViewController:controller animated:YES];
                
            }else{
                
                YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                vc.billId = self.order_id;
                vc.billType = self.orderType;
                vc.paySuccessBlock = ^(NSString * _Nonnull susId) {
                    
                    [weakSelf getpurchaseInfo:susId];
                    
                };
                vc.parts_suggestion_id = parts_suggestion[@"parts_suggestion_id"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        };
    }
    
    cell.hasPresent =  YES;
    
    cell.removeCallBack = ^(NSIndexPath *indexPath) {
        [weakSelf removeItemForCell:indexPath];
    };
    // 点击分类
    cell.selectClassClickEvent = ^(NSIndexPath *indexPath) {
        [weakSelf alertListForSelect:indexPath];
    };
    
    void (^operation)(void) = [self getCellDataWithKey:indexPath cell:cell];
    if (operation) {
        operation();
    }
    
    NSString *sec = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSInteger rows = [self.titleInfo[sec] integerValue];
    if (indexPath.row == (rows - 1) && (rows >= 1)) {
        cell.isNeedRaidus = YES;
        cell.isHiddenSeprateLine = YES;
    }
    
    return cell;
}

- (void)getpurchaseInfo:(NSString *)susId{
    
    [[YHCarPhotoService new] newWorkOrderDetailForBillId:self.order_id
                                                 success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {
                                                     NSArray *arr = info[@"data"][@"maintain_scheme"];
                                                     __block NSDictionary *resultDict = nil;
                                                     [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         NSArray *consumableArr = obj[@"consumable"];
                                                         if(!consumableArr.count){
                                                             consumableArr = obj[@"parts"];
                                                         }
                                                         [consumableArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             NSDictionary *suggested_info = obj[@"suggested_info"];
                                                             if ([[NSString stringWithFormat:@"%@",suggested_info[@"parts_suggestion_id"]] isEqualToString:susId]) {
                                                                 resultDict = suggested_info;
                                                                 *stop = YES;
                                                             }
                                                         }];
                                                     }];
                                                     
                                                     [self.reportModel.maintain_scheme enumerateObjectsUsingBlock:^(YHSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         
                                                         [obj.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             if ([[NSString stringWithFormat:@"%@",obj.suggested_info[@"parts_suggestion_id"]] isEqualToString:susId]) {
                                                                 obj.suggested_info = resultDict.mutableCopy;
                                                                 //                                                             *stop = YES;
                                                             }
                                                         }];
                                                         
                                                         [obj.parts enumerateObjectsUsingBlock:^(YHPartsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             if ([[NSString stringWithFormat:@"%@",obj.suggested_info[@"parts_suggestion_id"]] isEqualToString:susId]) {
                                                                 obj.suggested_info = resultDict.mutableCopy;
                                                                 //                                                             *stop = YES;
                                                             }
                                                         }];
                                                         
                                                     }];
                                                     //                                                     [self.schemeModel.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                     //                                                         if ([[NSString stringWithFormat:@"%@",obj.suggested_info[@"parts_suggestion_id"]] isEqualToString:susId]) {
                                                     //                                                             obj.suggested_info = resultDict;
                                                     ////                                                             *stop = YES;
                                                     //                                                         }
                                                     //                                                     }];
                                                     [self.repairTableview reloadData];
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
    
}
- (void)alertListForSelect:(NSIndexPath *)indexPath{
    
    if (!(self.parttypeList.count > 1)) {
        return;
    }
    
    YHRepairPartTableViewCell *cell = [self.repairTableview cellForRowAtIndexPath:indexPath];
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.partTypeNameList popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
        popover.sourceView =  cell.categoryBtn;
        popover.sourceRect =  cell.categoryBtn.bounds;
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex < 2) {
            return ;
        }
        YHPartsModel *partModel = self.schemeModel.parts[indexPath.row];
        NSDictionary *element = self.parttypeList[buttonIndex - 2];
        partModel.part_type = [NSString stringWithFormat:@"%@",element[@"id"]];
        partModel.part_type_name = [NSString stringWithFormat:@"%@",element[@"value"]];
        
        if (!indexPath) {
            return;
        }
        if ([partModel.part_type_name isEqualToString:@"原厂件"]) {
            partModel.part_brand = @"原厂";
        }
        [self.repairTableview reloadData];
//        [self.repairTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark - 删除cell ---
- (void)removeItemForCell:(NSIndexPath *)indexPath{
    
    if(self.schemeModel.labor.count + self.schemeModel.consumable.count + self.schemeModel.parts.count <= 1){
        [MBProgressHUD showError:@"最后一项不能删除!"];
        return;
    }
    
    if (indexPath.section == 1 + self.tutorial) {
        
        //"pay_status": "0", //购买状态：1-已购买，0-未购买
        
        BOOL pay_status = [self.schemeModel.parts[indexPath.row].suggested_info[@"pay_status"] boolValue];
        if (pay_status) {
            
            ZZAlertViewController *vc = [ZZAlertViewController alertControllerWithTitle:@"注意" icon:nil message:@"删除该项配件之后，该项的配置建议将会消失"];
            [vc addActionWithTitle:@"确认删除" style:ZZAlertActionStyleDestructive handler:^(UIButton * _Nonnull action) {
                [self.schemeModel.parts removeObjectAtIndex:indexPath.row];
                [self reCountTotalPrice];
                [self.repairTableview reloadData];
                
            }];
            [vc addActionWithTitle:@"暂不处理" style:ZZAlertActionStyleCancel handler:nil];
            
            [self presentViewController:vc animated:NO completion:nil];
            
            return;
        }
        
        [self.schemeModel.parts removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 2 + self.tutorial) {
        
        //"pay_status": "0", //购买状态：1-已购买，0-未购买
        
        BOOL pay_status = [self.schemeModel.consumable[indexPath.row].suggested_info[@"pay_status"] boolValue];
        if (pay_status) {
            
            ZZAlertViewController *vc = [ZZAlertViewController alertControllerWithTitle:@"注意" icon:nil message:@"删除该项耗材之后，该项的配置建议将会消失"];
            [vc addActionWithTitle:@"确认删除" style:ZZAlertActionStyleDestructive handler:^(UIButton * _Nonnull action) {
                [self.schemeModel.consumable removeObjectAtIndex:indexPath.row];
                [self reCountTotalPrice];
                [self.repairTableview reloadData];
                
            }];
            [vc addActionWithTitle:@"暂不处理" style:ZZAlertActionStyleCancel handler:nil];
            
            [self presentViewController:vc animated:NO completion:nil];
            
            return;
        }
        
        
        [self.schemeModel.consumable removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 3 + self.tutorial) {
        [self.schemeModel.labor removeObjectAtIndex:indexPath.row];
    }
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}

- (void)reCountTotalPrice{
    // 维修项目
    __block CGFloat repairProjectTotalPrice = 0;
    // 配件耗材
    __block CGFloat partTotalPrice = 0;
    __block CGFloat consumableTotalPrice = 0;
    [self.schemeModel.parts enumerateObjectsUsingBlock:^(YHPartsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.status isEqualToString:@"1"]) {
            partTotalPrice += [obj.part_price floatValue] *[obj.part_count floatValue];
        }
    }];
    
    [self.schemeModel.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.status isEqualToString:@"1"]) {
            consumableTotalPrice += [obj.consumable_price floatValue] * [obj.consumable_count floatValue];
        }
        
    }];
    
    [self.schemeModel.labor enumerateObjectsUsingBlock:^(YHLaborModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.status isEqualToString:@"1"]) {
            
            repairProjectTotalPrice += ([self.orderType isEqualToString:@"J006"])  ? [obj.labor_time floatValue] : [obj.labor_price floatValue];
        }
    }];
    self.schemeModel.labor_time_total = [NSString stringWithFormat:@"%.1f",repairProjectTotalPrice];
    self.schemeModel.labor_total = [NSString stringWithFormat:@"%.2f",repairProjectTotalPrice];
    self.schemeModel.total_price = [NSString stringWithFormat:@"%.2f",partTotalPrice + repairProjectTotalPrice + consumableTotalPrice];
    self.schemeModel.parts_total = [NSString stringWithFormat:@"%f",partTotalPrice];
    self.schemeModel.consumable_total = [NSString stringWithFormat:@"%f",consumableTotalPrice];
}

- (NSMutableArray *)repairProjectArr{
    
    YHSchemeModel *schemeModel = self.schemeModel;
    
    _repairProjectArr = [NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue: ([self.orderType isEqualToString:@"J006"]) ? schemeModel.labor_time_total : schemeModel.labor_total forKey:@"price"];
    [dict1 setValue:([self.orderType isEqualToString:@"J006"]) ? @"项目工时" : @"维修项目" forKey:@"name"];
    [_repairProjectArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:[NSString stringWithFormat:@"%.2f",schemeModel.consumable_total.floatValue + schemeModel.parts_total.floatValue] forKey:@"price"];
    [dict2 setValue:@"配件耗材" forKey:@"name"];
    [_repairProjectArr addObject:dict2];
    
    if(![self.orderType isEqualToString:@"J006"]){
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        [dict3 setValue:[NSString stringWithFormat:@"%.2f",(schemeModel.consumable_total.floatValue + schemeModel.parts_total.floatValue + [schemeModel.labor_total floatValue])] forKey:@"price"];
        [dict3 setValue:@"合计" forKey:@"name"];
        [_repairProjectArr addObject:dict3];
    }
    
    return _repairProjectArr;
}

- (NSMutableDictionary *)qualityItemDict{
    
    _qualityItemDict = [NSMutableDictionary dictionary];
    if (self.isNOEdit) {
        
        NSMutableString *textString1 = [NSMutableString string];
        if (self.schemeModel.quality_time > 0){
            
            if (self.schemeModel.quality_time.integerValue >= 12) {
                NSInteger year = self.schemeModel.quality_time.integerValue / 12;
                NSInteger value = self.schemeModel.quality_time.integerValue % 12;
                if (year > 0) {
                    [textString1 appendString:[NSString stringWithFormat:@"%ld年",year]];
                    if (value > 0) {
                        [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                    }
                }else{
                    [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                }
            }else{
                [textString1 appendString:[NSString stringWithFormat:@"%ld个月",self.schemeModel.quality_time.integerValue]];
            }
        }
        NSMutableString *textString2 = [NSMutableString string];
        if (self.schemeModel.quality_km.integerValue > 0) {
            
            NSInteger num1 = self.schemeModel.quality_km.integerValue/10000; // 万
            NSInteger num2 = self.schemeModel.quality_km.integerValue % 10000;
            NSInteger num3 = num2 / 1000;  // 千
            NSInteger num4 = num2 % 1000;
            NSInteger num5 = num4 / 100; // 百
            if (num1 > 0) {
                if (num3 > 0 || num5 > 0) {
                    [textString2 appendString:[NSString stringWithFormat:@"%ld.%ld%ld万公里",num1,num3,num5]];
                }else{
                    [textString2 appendString:[NSString stringWithFormat:@"%ld万公里",num1]];
                }
            }else{
                [textString2 appendString:[NSString stringWithFormat:@"%ld公里",num2]];
            }
        }
        NSMutableString *resultString = [NSMutableString string];
        if (textString1.length > 0) {
            [resultString appendString:textString1];
            if (textString2.length > 0) {
                [resultString appendString:@"或"];
                [resultString appendString:textString2];
            }
        }else{
            if (textString2.length > 0) {
                [resultString appendString:textString2];
            }else{
                [resultString appendString:@"无质保"];
            }
        }
        [_qualityItemDict setValue:resultString forKey:@"text"];
    }else{
        
        [_qualityItemDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
        [_qualityItemDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
    }
    
    return _qualityItemDict;
}

- (void (^)(void))getCellDataWithKey:(NSIndexPath *)indexPath cell:(YHBaseRepairTableViewCell *)cell{
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    //    NSIndexPath *index = [NSIndexPath indexPathWithIndex:(indexPath.section + self.tutorial)];
    NSMutableDictionary *dictOperation = [NSMutableDictionary dictionary];
    
    void(^operation)(void) = ^(void) {
        YHCheckResultArrModel *checkResultArrModel = self.reportModel.checkResultArr;
        cell.cellModel = checkResultArrModel.makeResult;
    };
    
    void(^operation1)(void) = ^(void) {
        cell.cellModel = self.schemeModel.parts[indexPath.row];
    };
    void (^operation2)(void) = ^(void) {
        cell.cellModel = self.schemeModel.consumable[indexPath.row];
    };
    void (^operation3)(void) = ^(void) {
        cell.cellModel = self.schemeModel.labor[indexPath.row];
    };
    void (^operation4)(void) = ^(void) {
        cell.cellModel = self.repairProjectArr[indexPath.row];
    };
    __weak typeof(self)weakSelf = self;
    void (^operation5)(void) = ^(void) {
        if (![weakSelf.orderType isEqualToString:@"J005"] && ![weakSelf.orderType isEqualToString:@"J007"]) {
            cell.cellModel = weakSelf.qualityItemDict;
        }
    };
    
    void (^operation6)(void) = ^(void) {
        cell.is4s = YES;
        cell.cellModel = @{@"quality_time":self.schemeModel.price_ssss ? :@"0"};//self.qualityItemDict;
    };
    //    // 推送手机号
    //    void(^operation7)(void) = ^(void) {
    //
    //        YHPushPhoneView *pushPhoneCell = (YHPushPhoneView *)cell;
    //        pushPhoneCell.phoneTft.text = self.pushPhone ? self.pushPhone : @"";
    //        __weak typeof(self)weakSelf = self;
    //        pushPhoneCell.textEditEndCallBack = ^(NSString * _Nonnull text) {
    //            weakSelf.pushPhone = text;
    //        };
    //    };
    
    //    [dictOperation setValue:operation01 forKey:@(self.tutorial).stringValue];
    [dictOperation setValue:operation forKey:@"0"];
    [dictOperation setValue:operation1 forKey:@(1 + self.tutorial).stringValue];
    [dictOperation setValue:operation2 forKey:@(2 + self.tutorial).stringValue];
    [dictOperation setValue:operation3 forKey:@(3 + self.tutorial).stringValue];
    [dictOperation setValue:operation4 forKey:@(4 + self.tutorial).stringValue];
    [dictOperation setValue:operation5 forKey:@(5 + self.tutorial).stringValue];
    [dictOperation setValue:operation6 forKey:@(6 + self.tutorial).stringValue];
    //    [dictOperation setValue:operation7 forKey:@"7"];
    
    return dictOperation[key];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *sectionL = [UILabel new];
    sectionL.font = [UIFont boldSystemFontOfSize:18.0];
    [sectionView addSubview:sectionL];
    [sectionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.bottom.equalTo(@(-10));
    }];
    sectionL.text = self.repairTitleArr[section];
    
    UIButton *addBTn = [UIButton new];
    
    if (section == (0 + self.tutorial) || section > (3 + self.tutorial)) {
        addBTn.hidden = YES;
    }else{
        addBTn.hidden = NO;
    }
    
    addBTn.tag = section + 999;
    [addBTn setTitle:@"增加" forState:UIControlStateNormal];
    [addBTn setTitleColor:[UIColor colorWithRed:63.0/255.0 green:159.0/255.0 blue:245.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    addBTn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    addBTn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    [sectionView addSubview:addBTn];
    [addBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionL);
        make.right.equalTo(@(-15));
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    [addBTn addTarget:self action:@selector(addItme:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sectionView setRounded:sectionView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
    });
    return sectionView;
}
#pragma mark - 增加 ---
- (void)addItme:(UIButton *)addBTn{
    
    YHRepairAddController *repairAddVc = [YHRepairAddController new];
    repairAddVc.baseInfo = self.reportModel.baseInfo;
    repairAddVc.base_info = self.reportModel.base_info;
    repairAddVc.repairType = (addBTn.tag - 1) - 999 - self.tutorial;
    
    switch (repairAddVc.repairType) {
        case 0:{
            repairAddVc.models = [[self.schemeModel.parts valueForKeyPath:@"part_name"] mutableCopy];
            repairAddVc.TitleText = @"已设置配件";
            repairAddVc.title = @"配件搜索";
            repairAddVc.isNotZero = (self.schemeModel.consumable.count + self.schemeModel.labor.count);
        }
            break;
        case 1:
             repairAddVc.models = [[self.schemeModel.consumable  valueForKeyPath:@"consumable_name"] mutableCopy];
             repairAddVc.TitleText = @"已设置耗材";
             repairAddVc.title = @"耗材搜索";
             repairAddVc.isNotZero = (self.schemeModel.parts.count + self.schemeModel.labor.count);
            break;
        case 2:
             repairAddVc.models = [[self.schemeModel.labor  valueForKeyPath:@"labor_name"] mutableCopy];
             repairAddVc.TitleText = @"已设置维修项目";
             repairAddVc.title = @"维修项目搜索";
             repairAddVc.isNotZero = (self.schemeModel.consumable.count + self.schemeModel.parts.count);
            break;
            
        default:
            break;
    }
    
    __weak typeof(self)weakSelf = self;
    repairAddVc.removeCallBack = ^(NSInteger index) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:addBTn.tag - 999];
        [weakSelf removeItemForCell:path];
    };
    
    repairAddVc.addDataBlock = ^(NSArray *finalArr, NSInteger section) {
        section += 1;
        for (NSDictionary *element in finalArr) {
            
            if (section == 1) {
                YHPartsModel *partModel = [YHPartsModel mj_objectWithKeyValues:element];
                if (IsEmptyStr(partModel.status)) {
                    partModel.status = @"1";
                }
                
                [weakSelf.schemeModel.parts addObject:partModel];
            }
            if (section == 2) {
                YHConsumableModel *consumableModel = [YHConsumableModel mj_objectWithKeyValues:element];
                if (IsEmptyStr(consumableModel.status)) {
                    consumableModel.status = @"1";
                }
                
                [weakSelf.schemeModel.consumable addObject:consumableModel];
            }
            if (section == 3) {
                YHLaborModel *laborModel = [YHLaborModel mj_objectWithKeyValues:element];
                if (IsEmptyStr(laborModel.status)) {
                    laborModel.status = @"1";
                }
                
                [weakSelf.schemeModel.labor addObject:laborModel];
            }
        }
        [weakSelf reCountTotalPrice];
        [weakSelf.repairTableview reloadData];
    };
    [self.navigationController pushViewController:repairAddVc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return ([self.orderType isEqualToString:@"J002"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"]  || [self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"] || [self.orderType isEqualToString:@"J004"]) || [self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J007"] || [self.orderType isEqualToString:@"Y002"]  ? 0 : [self diagnoseHeight];
    }else{
        NSDictionary *cellInfo = self.repairCellInfo[[NSString stringWithFormat:@"%ld",indexPath.section ? indexPath.section - self.tutorial : indexPath.section]];
        NSString *cellName = cellInfo[@"cellClass"];
        
        if(self.tutorial && indexPath.section == 1 && ![self.orderType isEqualToString:@"Y002"]){
            return 12 + self.reportModel.tutorial_list.count * 28;
        }
        
        if([self.orderType isEqualToString:@"Y002"] && indexPath.section == 1){
            return [self diagnoseHeight1];
        }
        
        {//配件/耗材有建议内容时高度
            
            YHLPCModel *consumableModel = nil;
            
            if (indexPath.section == 1 + self.tutorial) {
                consumableModel = self.schemeModel.parts[indexPath.row];
            }
            
            if (indexPath.section == 2 + self.tutorial) {
                consumableModel = self.schemeModel.consumable[indexPath.row];
            }
            
            NSArray *list = consumableModel.suggested_info[@"list"];
            if(list.count){
                return 310 + list.count * 28 ;
            }
        }
        
        NSInteger h = [cellInfo[@"cellHeight"] integerValue] + (([cellName isEqualToString:@"YHRepairPartTableViewCell"] || [cellName isEqualToString:@"YHRepairProjectTableViewCell"])? 35 :0) + ([cellName isEqualToString:@"YHRepairPartTableViewCell"]? 35:0);
        
        if([self.orderType isEqualToString:@"J009"] && indexPath.section == (5 + self.tutorial)) return h;
        
        h =  ([self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"A"]  || [self.orderType isEqualToString:@"J009"] || [self.orderType isEqualToString:@"Y002"] || [self.orderType isEqualToString:@"J004"]) && indexPath.section != (4 + self.tutorial) ? indexPath.section == (3 + self.tutorial) ? h - 20 - 25 : h - 20 : h;
        
        if(([self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"J007"]) && indexPath.section == 5 + self.tutorial){
            YHInputQualityCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YHInputQualityCell" owner:nil options:nil].firstObject;
            cell.cellModel = self.schemeModel;
            return cell.oldTextViewBounds.size.height + 60;
        }
        
        return   h;
        
    }
}

- (CGFloat)diagnoseHeight1{
    __block CGFloat diagnoseHeight = 36;
    NSArray *strArr = [self.reportModel.checkResultArr.makeResult componentsSeparatedByString:@"\n"];
    if (!strArr.count) {
        diagnoseHeight = 36;
    }
    __block int sum = 0;
    [strArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        int num = ceil(height/(screenWidth-46));
        if (num > 1) { // +行距
            diagnoseHeight += (num - 1)*20;
        }
        sum += num;
    }];
    
    
    diagnoseHeight += sum  *16;
    return diagnoseHeight;
}

- (CGFloat)diagnoseHeight{
    __block CGFloat diagnoseHeight = 100;
    NSArray *strArr = [self.reportModel.checkResultArr.makeResult componentsSeparatedByString:@"\n"];
    if (!strArr.count) {
        diagnoseHeight = 55;
    }
    __block int sum = 0;
    [strArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        int num = ceil(height/(screenWidth-46));
        if (num > 1) { // +行距
            diagnoseHeight += (num - 1)*12;
        }
        sum += num;
    }];
    diagnoseHeight += sum *15;
    return diagnoseHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return ([self.orderType isEqualToString:@"J002"]  || [self.orderType isEqualToString:@"J008"] || [self.orderType isEqualToString:@"J004"] || [self.orderType isEqualToString:@"A"]  || [self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J009"]) || [self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J007"] || [self.orderType isEqualToString:@"Y002"]  ? 0 : [self diagnoseHeight] ? 0 : UITableViewAutomaticDimension;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor clearColor];
    
    return sectionView;
}


//FIXME:  -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.gModels.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTZHeaderTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.tagModel = self.gModels[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentIndex == indexPath.item)return;
    
    TTZGroundModel *gModel = self.gModels[indexPath.item];

    self.currentIndex = indexPath.item;
    gModel.isSelected = YES;
    
    [collectionView reloadData];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return CGSizeMake(self.sysModels[self.currentIndex].list[indexPath.item].itemWidth + 64, 34);
    TTZGroundModel *gModel = self.gModels[indexPath.item];
    CGFloat f = [gModel.projectName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width;

    return CGSizeMake(f + 36, 34);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == self.headerView) return;
    
    NSArray <NSIndexPath *>*indexs = [self.repairTableview indexPathsForVisibleRows];
    NSArray *sections = [indexs valueForKeyPath:@"section"];
    
    NSInteger  scrollSection = [sections.firstObject integerValue];
    if(![self.orderType isEqualToString:@"Y002"]){
        scrollSection = [sections.firstObject integerValue] - (![[self.gModels.firstObject valueForKeyPath:@"projectName"] isEqualToString:@"诊断结果"] ? 1 : 0);
        scrollSection = scrollSection < 0 ? 0 :scrollSection;
        scrollSection = scrollSection > self.repairProjectArr.count - 1 ?  self.repairProjectArr.count - 1 : scrollSection;
    }
    

    [_gModels enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    _gModels[scrollSection].isSelected = YES;
    
    [self.headerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollSection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.headerView reloadData];
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex{

    _currentIndex = currentIndex;
    NSInteger tagCount = self.gModels.count;
    
    for (TTZGroundModel *model in self.gModels) {
        
        if(![model isEqual:self.gModels[currentIndex]]){
           model.isSelected = NO;
        }
    }

    CGFloat itemWidth = screenWidth / tagCount;
    if (itemWidth < 90) {
        itemWidth = 90;
    }
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.headerView.collectionViewLayout;
    layout.itemSize = CGSizeMake(itemWidth, 34);
    
    NSInteger i = currentIndex + (![[self.gModels.firstObject valueForKeyPath:@"projectName"] isEqualToString:@"诊断结果"] ? 1 : 0);
    if([self.orderType isEqualToString:@"Y002"]){
        i = currentIndex;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.repairTableview reloadData];
        
        if([self.orderType isEqualToString:@"Y002"] && !currentIndex){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.repairTableview setContentOffset:CGPointZero animated:YES];
                
            });
            
            return ;
           
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.repairTableview setContentOffset:[self.repairTableview rectForHeaderInSection:i].origin animated:YES];
        });
        
        
//        if(self.repairTableview.numberOfSections && [self.repairTableview numberOfRowsInSection:i]){[self.repairTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
    });
}


- (UICollectionView *)headerView{
    if (!_headerView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight,screenWidth , 34) collectionViewLayout:layout];
        _headerView.showsHorizontalScrollIndicator = NO;
        _headerView.showsVerticalScrollIndicator = NO;
        _headerView.dataSource = self;
        _headerView.delegate = self;
        _headerView.bounces = NO;
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView registerClass:[TTZHeaderTagCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _headerView;
}
@end

