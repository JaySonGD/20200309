//
//  YHOrderDetailNewOneController.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/22.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailNewOneController.h"
#import "TTZCheckViewController.h"
#import "UIViewController+sucessJump.h"

#import "YHOrderDetailTopContainView.h"
#import "YHOrderDetailViewCell.h"
#import "YHOrderDetailViewHeaderView.h"

#import "YHCheckDetailViewController.h"
#import "YHCheckCarAllPictureViewController.h"

#import "YHCarPhotoService.h"
#import "TTZSurveyModel.h"
#import "TTZUpLoadService.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"

#import "YHCheckCarDetailCell.h"

#import "YHAskAboutInfoHeaderView.h"
#import "YHWebFuncViewController.h"
#import "YHStoreTool.h"

#import "YHSettlementController.h"
#import "UIAlertView+Block.h"
#import "YHOrderListController.h"
#import "ZZSubmitDataService.h"

#import <MJExtension.h>

#import "YHDeleteRepairCaseView.h"

#import "YHRepairCaseDetailController.h"
#import "YTRepairViewController.h"
#import "YTPlanCell.h"

#import "YHDiagnoseView.h"
#import "YTDepthController.h"

#import "YTCounterController.h"

#import "YTReportPromptCell.h"
#import "HTPlayCardCell.h"
#import "YTEstimateCell.h"
#import "YTSyncBucheCell.h"

#import "YHOrderDetailViewNewCell.h"

#import "YHOrderDetailDepthViewController.h"

#import "YTBillPackageModel.h"
#import "YTBillPackageCellOne.h"
#import "YHDiagnoseNewView.h"
#import "YTBillPackageModel.h"

@interface YHOrderDetailNewOneController ()<UITableViewDelegate,UITableViewDataSource>
/** 检测方案tableView */
@property (nonatomic, weak) UITableView *detailTableview;
/** 基本信息tableView */
@property (nonatomic, weak) UITableView *baseInfoTableview;
/** 问询信息tableView */
@property (nonatomic, weak) UITableView *askAboutTableview;

/** 基本信息数据源 */
@property (nonatomic, strong) NSMutableArray *baseInfoArr;
/** 问询信息数据源 */
@property (nonatomic, strong) NSMutableArray *askInfoArr;

@property (nonatomic, weak) UIView *footChildView;
/** 复检按钮 */
@property (nonatomic, weak) UIButton *bottomBtn;
/** 查看检测报告按钮 */
@property (nonatomic, weak) UIButton *lookUpBtn;

@property (nonatomic, weak) YHOrderDetailTopContainView *topContainView;
/** tableView的headerView */

@property (nonatomic, weak) UIView *contentView;
/** 基本信息的headerView */
@property (nonatomic, weak) UIView *baseInfoHeaderView;
/** 是否可上传 */
@property (nonatomic, assign) BOOL isUpLoad;
/** 是否已推送报告 */
@property (nonatomic, assign) BOOL isPushReport;
/** 是否是历史工单 */
//@property (nonatomic, assign) BOOL isHistoryOrder;

@property (nonatomic, strong) NSMutableDictionary *modelDict;

@property (nonatomic, strong) NSMutableString *sysIds;

@property (nonatomic, strong) NSMutableArray *professionDataArr;
/** 机油的id */
@property (nonatomic, copy) NSString *oilId;

@property (nonatomic, weak) UILabel *errolL;

@property (nonatomic, assign) BOOL isClickedProfession;

@property (nonatomic, weak) YHDeleteRepairCaseView *deleAlertView;

@property (nonatomic, strong) UIView *tableFootV;

@property (nonatomic,strong) YTDiagnoseModel *diagnoseModel;

@property (nonatomic,strong) YHReportModel *diagnoseModel1;

@property (nonatomic, assign) CGFloat diagnoseHeight;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) BOOL isShow;

@property (strong, nonatomic) UITextField *price;//二手车估价输入框

@property (nonatomic, strong) NSMutableDictionary *didUsedCarStatus;
@property (nonatomic, strong) NSMutableDictionary *assess_info;
@property (nonatomic, strong) NSMutableDictionary *bucheSync;
@property (nonatomic, assign) BOOL isBack;//是否跳转到其他页面
@property (nonatomic, assign) CGFloat h;//记录刷新后cell高度
@property (nonatomic , strong) MASConstraint *with;
@property (nonatomic, strong) NSMutableArray *arrData;//数据源模型
@property (nonatomic, copy) NSString *bottomBtnTitle;//复检按钮文字
@property (nonatomic, assign) BOOL isSubmiting;//第一次提交复检数据页面,防止返回刷新数据问题
@end

extern NSString *const notificationOrderListChange;

//static  NSInteger MaxAllowUploadCount = 10;
//

@implementation YHOrderDetailNewOneController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)dealloc{
    NSLog(@"dealloc");
}

- (instancetype)init{
    
    if (self = [super init]) {
        [self getDataToRefreshView];
    }
    return self;
}

- (void)getDataToRefreshView{
    
    dispatch_group_t group = dispatch_group_create();

    if(!self.timer) [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
#pragma mark - 调试
        [self initData:group];
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        self.isClickedProfession = [self isExistSelectedElement];
        [self resfreshView:group];
    });
}

#pragma mark - 刷新界面 ----
- (void)resfreshView:(dispatch_group_t) group{

    NSMutableDictionary *dataDict = self.info[@"data"];
    NSDictionary *baseInfo = dataDict[@"baseInfo"];
    self.baseInfoArr = [self getBaseInfo:baseInfo];
    self.askInfoArr = [self getAskInfoArr:self.info];
    
    switch (self.functionCode) {
        case YHFunctionIdConsulting:
        {   // 问询
            self.isCheckComplete = NO;
            self.isUpLoad = NO;
            self.isPushReport = NO;
        }
            break;
        case YHFunctionIdInitialSurvey:
        {   // 初检
        self.isCheckComplete = NO;
        self.isUpLoad = YES;
        self.isPushReport = NO;
        }
            break;
        case YHFunctionIdReCheck:
        {   //复检
        self.isCheckComplete = NO;
        self.isUpLoad = NO;
        }
        case YHFunctionIdEndBill:
        {   // 历史工单
        self.isCheckComplete = YES;
        self.isUpLoad = NO;
        }
            break;
        default:{
            // 已推送报告时
        self.isUpLoad = NO;
        self.isCheckComplete = YES;
        self.isPushReport = YES;
        }
            break;
    }
    
    self.detailTableview.hidden = NO;
    self.topContainView.hidden = NO;
    
    [self setBottomBtnStatus];
   
     //刷新列表
       TTZSYSModel *model = self.dataArr.firstObject;
       if(self.dataArr.count && !model.list.count && [self.info[@"data"][@"billType"] isEqualToString:@"A"] && self.isBack){
           NSIndexSet * index = [NSIndexSet indexSetWithIndex:2];
           [UIView performWithoutAnimation:^{
           [self.detailTableview reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
           }];
       }else{
           [self.detailTableview reloadData];
       }
    
    // 获取准确的contentSize前调用
    [self.detailTableview layoutIfNeeded];
    
//    if (self.detailTableview.contentSize.height > self.detailTableview.frame.size.height) {
//        self.detailTableview.tableFooterView = self.tableFootV;
////        [self.tableFootV addSubview:self.bottomBtn];
////        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.equalTo(@10);
////            make.right.offset(-10);
////            make.bottom.offset(-10);
////            make.height.equalTo(@40);
////        }];
//    }else{
//
//        if (self.detailTableview.frame.size.height - self.detailTableview.contentSize.height > 60) {
//
//            self.detailTableview.tableFooterView = nil;
//            CGFloat bottomMargin = iPhoneX ? 34 : 0;
//            [self.view addSubview:self.tableFootV];
//            [self.tableFootV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(@0);
//                make.right.equalTo(@0);
//                make.bottom.equalTo(self.tableFootV.superview).offset(-bottomMargin);
//                make.height.equalTo(@60);
//            }];
////            [self.view insertSubview:self.detailTableview belowSubview:self.bottomBtn];
//
//        }else{
//
//            self.detailTableview.tableFooterView = self.tableFootV;
////            [self.tableFootV addSubview:self.bottomBtn];
////            [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.left.equalTo(@10);
////                make.right.offset(-10);
////                make.bottom.offset(-10);
////                make.height.equalTo(@40);
////            }];
//        }
//    }
    
//    [self setBottomBtnStatus];
    
//    if (!self.dataArr.count && !self.detailTableview.hidden && !_isShow) {
//        [MBProgressHUD showError:@"暂无初检信息" toView:self.view];
//        _isShow = YES;
//    }
    
    // 关闭工单
    if (self.functionCode == YHFunctionIdEndBill || [self.diagnoseModel.package_check isEqualToString:@"1"] || self.functionCode == YHFunctionIdClose) {//复检车主已购买也不能关闭
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
        BOOL isVerifier =NO;
        if (!isVerifier) {
            [self addCloseOrderBtn];
        }else{
            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}


#pragma mark - 检测方案tableview ------
- (UITableView *)detailTableview{
    
    if (!_detailTableview) {
        
        // tableview初始化
        UITableView *detailTableview = [self getNeedTableView];
        detailTableview.estimatedRowHeight = 100;
        _detailTableview = detailTableview;
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTBillPackageCellOne" bundle:nil] forCellReuseIdentifier:@"YTBillPackageCellOne"];
        
        [_detailTableview registerNib:[UINib nibWithNibName:@"YHDiagnoseNewView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YHDiagnoseNewView"];
        
         [_detailTableview registerNib:[UINib nibWithNibName:@"YHDiagnoseView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YHDiagnoseView"];
        
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTPlanCell"];
        
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTReportPromptCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTReportPromptCell"];

        [_detailTableview registerNib:[UINib nibWithNibName:@"HTPlayCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HTPlayCardCell"];
        
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTEstimateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTEstimateCell"];

        [_detailTableview registerNib:[UINib nibWithNibName:@"YTSyncBucheCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTSyncBucheCell"];
        _detailTableview.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    }
    return _detailTableview;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.topContainView){
        [self initOrderDetailUI];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.detailTableview reloadData];
    
    if ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"consulting"] || [self.diagnoseModel.recheck_status isEqualToString:@"0"]) {//问询或者复检中
        self.bottomBtn.enabled = [self isCheckedForData];
        if([self isReturn]) return;

    }
    
   [self getDataToRefreshView];

}



- (BOOL)isReturn{

    if ([self.info[@"data"][@"billType"] isEqualToString:@"A"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"Y002"]) return YES; //不缓存
    
    return NO;
    
}

- (BOOL)isCheckedForData{//是否有提交数据
    
    if([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"consulting"]){//问询状态
        BOOL isChecked = NO;
        for (int i = 0; i<self.dataArr.count; i++) {
            TTZSYSModel *model = self.dataArr[i];
            if (model.progress > 0) {
                isChecked = YES;
            }
        }
        return isChecked;
    }
    
    if(self.diagnoseModel.recheck_status && (self.diagnoseModel.recheck_num.intValue > 1 || self.isSubmiting) ){//复检状态
    BOOL isChecked = YES;
    for (int i = 0; i<self.dataArr.count; i++) {
        TTZSYSModel *model = self.dataArr[i];
        if (model.progress < 1) {
            isChecked = NO;
        }
    }
        
         return isChecked;
    }
   
    return YES;
}

#pragma mark - 基本信息tableview ------
- (UITableView *)baseInfoTableview{
    if (!_baseInfoTableview) {
        
        UITableView *baseInfoTableview = [self getNeedTableView];
        _baseInfoTableview = baseInfoTableview;
        
        UIView *baseInfoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 45.0)];
        self.baseInfoHeaderView = baseInfoHeaderView;
        UIView *contentView = [[UIView alloc] init];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [baseInfoHeaderView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@8);
            make.right.equalTo(contentView.superview).offset(-8);
            make.height.equalTo(contentView.superview).offset(-1);
            make.top.equalTo(@0);
        }];
        
        UILabel *baseInfoL = [[UILabel alloc] init];
        baseInfoL.text = @"基本信息";
        [baseInfoL sizeToFit];
        [contentView addSubview:baseInfoL];
        [baseInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(baseInfoL.superview);
        }];
        
        baseInfoTableview.tableHeaderView = baseInfoHeaderView;
    }
    
    return _baseInfoTableview;
}
#pragma mark - 问询信息tableview ------
- (UITableView *)askAboutTableview{
    if (!_askAboutTableview) {
        
        UITableView *askAboutTableview = [self getNeedTableView];
        _askAboutTableview = askAboutTableview;
    }
    return _askAboutTableview;
}
#pragma mark - 创建tableview ---
- (UITableView *)getNeedTableView{
    
    CGFloat bottonMargin = iPhoneX ? 34 : 0;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    [self.view insertSubview:tableview belowSubview:self.bottomBtn];
    [self.view insertSubview:tableview belowSubview:self.lookUpBtn];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.errolL.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.width.equalTo(tableview.superview);
        make.bottom.equalTo(tableview.superview).offset(-bottonMargin);
    }];
    
    return tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initOrderDetailNewControllerBase];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ReloadData" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
         if([self isReturn]) return;
         [self getDataToRefreshView];
    }];
}


- (void)initData:(dispatch_group_t)group{
    
//    if(self.functionCode == YHFunctionIdEndBill | self.functionCode == YHFunctionIdClose){
//        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:self.orderDetailInfo[@"id"] isHistory:YES onComplete:^(NSDictionary *info) {
//
//
//        }onError:^(NSError *error) {
//
//            if (error) {
//                NSLog(@"%@",error);
//            }
//            dispatch_group_leave(group);
//        }];
//        return;
//    }
    
    dispatch_group_enter(group);
    
    //[MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] newWorkOrderDetailForBillId:self.orderDetailInfo[@"id"]
                                                 success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {
        
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                     self.info = info;
                                                     self.diagnoseModel = [YTDiagnoseModel mj_objectWithKeyValues:info[@"data"]];
                   BOOL isInitialSurvey = [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"newWholeCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"usedCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"extWarrantyInitialSurvey"];//是否初检
        
                    if( isInitialSurvey){
                        self.functionCode = YHFunctionIdInitialSurvey;
                    }
                  
                    if([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"endBill"]){
                         self.functionCode = YHFunctionIdEndBill;
                    }
        

                    if([[NSString stringWithFormat:@"%@", self.info[@"data"][@"billStatus"]] isEqualToString:@"close"]){
                         self.functionCode = YHFunctionIdClose;
                    }
                                                    
                    self.arrData = [NSMutableArray arrayWithCapacity:10];
                    if(self.diagnoseModel.package_owner.count && self.diagnoseModel.recheck_num.intValue < 2){//套餐选择
                        [self.arrData addObjectsFromArray:@[self.diagnoseModel.package_owner]];
                    }
        
                    if(self.diagnoseModel.policy_system_names.count && self.diagnoseModel.recheck_num.intValue < 2){//套餐选择
                        [self.arrData addObjectsFromArray:@[self.diagnoseModel.policy_system_names]];
                    }
        
                    if(models.count && (self.diagnoseModel.recheck_num.intValue > 1 || self.functionCode != YHFunctionIdReCheck) && self.functionCode != YHFunctionIdEndBill){//复检第二次才显示
                       [self.arrData addObject:models];
                    }
                   
                    self.dataArr = models;
                    
        
                 if(![self.info[@"data"][@"nowStatusCode"] isEqualToString:@"consulting"]){
                   self.diagnoseModel.checkResultArr.makeResult = [self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                     self.diagnoseModel.checkResultArr.makeResult = self.diagnoseModel.checkResultArr.makeResult.length ? self.diagnoseModel.checkResultArr.makeResult : self.functionCode == YHFunctionIdEndBill && ([self.info[@"data"][@"billType"] isEqualToString:@"A"] || [self.info[@"data"][@"billType"] isEqualToString:@"Y002"]) ? @"全部系统复检通过" : @"暂无诊断结果";
                   [self.arrData addObject:@[self.diagnoseModel.checkResultArr]];
                  }

                    if(self.diagnoseModel.maintain_scheme.count){
                        [self.arrData addObject:self.diagnoseModel.maintain_scheme];
                    }else if(isInitialSurvey){
                        YTPlanModel *model = [YTPlanModel new];
                        model.name = @"方案";
                        [self.arrData addObject:@[model]];
                    }
                   //报告生成状态 0：未生成，1：已生成
                    if((([self.diagnoseModel.reportStatus isEqualToString:@"1"] && self.functionCode != YHFunctionIdReCheck) ||([self.diagnoseModel.r_report_status isEqualToString:@"1"] && self.functionCode == YHFunctionIdReCheck)) && self.timer) {
                            [self.timer invalidate];
                            self.timer = nil;
                        if(![self.diagnoseModel.billStatus isEqualToString:@"complete"] && self.functionCode == YHFunctionIdReCheck){
//                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [MBProgressHUD showError:@"部分系统未达要去\n请维修后再次复检" toView:nil timeOut:1];
                        }
                      }
        
                    if(self.isSubmiting){//提交数据返回刷新问题
                        self.arrData = @[self.dataArr].mutableCopy;
                    }
        
                if(!self.timer){
                    if([self.diagnoseModel.reportStatus isEqualToString:@"0"] && isInitialSurvey){
                         //self.arrData = [NSMutableArray arrayWithCapacity:10];
                         [self creatTimer];
                    }
                  //提前修改状态
                  [self setBottomBtnStatus];
                   dispatch_group_leave(group);
                  }
        
                 }
                 failure:^(NSError *error) {
                     dispatch_group_leave(group);
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                 }];
    
}

- (NSMutableArray *)getAskInfoArr:(NSDictionary *)info{
    
    NSMutableArray *askInfoArr = [NSMutableArray array];
    
    NSDictionary *data = info[@"data"];
    NSArray *consultingProjectValArr = data[@"consultingProjectVal"];
    
    NSMutableDictionary *faultLight = [NSMutableDictionary dictionary];
    [faultLight setValue:@"故障灯选择（多选）" forKey:@"sectionTitle"];
    NSMutableArray *faultLightArr = [NSMutableArray array];
    
    
    NSMutableDictionary *faultOil = [NSMutableDictionary dictionary];
    [faultOil setValue:@"燃油故障" forKey:@"sectionTitle"];
    NSMutableArray *faultOilArr = [NSMutableArray array];
    
    
    NSMutableDictionary *faultPower = [NSMutableDictionary dictionary];
    [faultPower setValue:@"动力故障" forKey:@"sectionTitle"];
    NSMutableArray *faultPowerArr = [NSMutableArray array];
    
    if (consultingProjectValArr && [consultingProjectValArr isKindOfClass:[NSArray class]]) {
        
        for (int i = 0; i<consultingProjectValArr.count; i++) {
            NSDictionary *dict = consultingProjectValArr[i];
            int askId = [dict[@"id"] intValue];
            if (askId == 55) {
                
                NSDictionary *defaultDict = dict[@"projectVal"];
                NSArray *defaultArr = defaultDict[@"default"];
                for (int j = 0; j< defaultArr.count; j++) {
                    
                    NSString *defStr = defaultArr[j];
                    NSMutableDictionary *defDict = [NSMutableDictionary dictionary];
                    [defDict setValue:defStr forKey:@"rowTitle"];
                    [defDict setValue:@"" forKey:@"rowSubTitle"];
                    [faultLightArr addObject:defDict];
                }
            }
            
            if (askId == 57 || askId == 67 || askId == 442 ||askId == 443 || askId == 444) {
                
                NSMutableDictionary *oilDict = [NSMutableDictionary dictionary];
                [oilDict setValue:dict[@"projectName"] forKey:@"rowTitle"];
                [oilDict setValue:dict[@"projectVal"] forKey:@"rowSubTitle"];
                [faultOilArr addObject:oilDict];
            }
            
            if (askId == 69 || askId == 70 || askId == 71 ||askId == 72 || askId == 73) {
                
                NSMutableDictionary *powerDict = [NSMutableDictionary dictionary];
                [powerDict setValue:dict[@"projectName"] forKey:@"rowTitle"];
                [powerDict setValue:dict[@"projectVal"] forKey:@"rowSubTitle"];
                [faultPowerArr addObject:powerDict];
            }
        }
        
    }
    [faultLight setValue:faultLightArr forKey:@"rowData"];
    if (faultLightArr.count) {
        [askInfoArr addObject:faultLight];
    }
    
    [faultOil setValue:faultOilArr forKey:@"rowData"];
    if (faultOilArr.count) {
        [askInfoArr addObject:faultOil];
    }
    
    [faultPower setValue:faultPowerArr forKey:@"rowData"];
    if (faultPowerArr.count) {
        [askInfoArr addObject:faultPower];
    }
    
    NSMutableDictionary *faultPhenomenon = [NSMutableDictionary dictionary];
    [faultPhenomenon setValue:@"故障现象" forKey:@"sectionTitle"];
    NSDictionary *fault_data = data[@"fault_data"];
    NSArray *phenomenonArr = fault_data[@"faultPhenomenon"];
    NSMutableArray *newPhenomenonArr = [NSMutableArray array];
    for (int i = 0; i<phenomenonArr.count; i++) {
        
        NSDictionary *phenomenonDict = phenomenonArr[i];
        NSMutableDictionary *newPhenomenonDict = [NSMutableDictionary dictionary];
        [newPhenomenonDict setValue:phenomenonDict[@"faultPhenomenonName"] forKey:@"rowTitle"];
        [newPhenomenonDict setValue:@"" forKey:@"rowSubTitle"];
        [newPhenomenonArr addObject:newPhenomenonDict];
    }
    [faultPhenomenon setValue:newPhenomenonArr forKey:@"rowData"];
    if (newPhenomenonArr.count) {
        [askInfoArr addObject:faultPhenomenon];
    }
    
    NSMutableDictionary *faultPhenomenonAdd = [NSMutableDictionary dictionary];
    [faultPhenomenonAdd setValue:@"故障现象补充" forKey:@"sectionTitle"];
    NSString *phenomenonStr = fault_data[@"faultPhenomenonDescs"];
    NSMutableArray *phenomenonAddArr = [NSMutableArray array];
    NSMutableDictionary *phenomenonAddDict = [NSMutableDictionary dictionary];
    [phenomenonAddDict setValue:phenomenonStr forKey:@"rowTitle"];
    [phenomenonAddDict setValue:@"" forKey:@"rowSubTitle"];
    
    [phenomenonAddArr addObject:phenomenonAddDict];
    [faultPhenomenonAdd setValue:phenomenonAddArr forKey:@"rowData"];
    if (phenomenonStr.length > 0) {
        [askInfoArr addObject:faultPhenomenonAdd];
    }
    // 验车
    NSMutableDictionary *checkDict = [NSMutableDictionary dictionary];
    [checkDict setValue:@"验车" forKey:@"sectionTitle"];
    [checkDict setValue:self.checkCarVal[@"version"] forKey:@"version"];
    NSMutableArray *checkArr = [NSMutableArray array];
    NSArray *checkProjectArr = self.checkCarVal[@"checkProject"];
    for (int i = 0; i<checkProjectArr.count; i++) {
        NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
        NSDictionary *item = checkProjectArr[i];
        [newItem setValue:item[@"projectName"] forKey:@"rowTitle"];
        [newItem setValue:item[@"projectOptionName"] forKey:@"rowSubTitle"];
        [newItem setValue:item[@"projectRelativeImgList"] forKey:@"imgList"];
        [checkArr addObject:newItem];
    }
    [checkDict setValue:checkArr forKey:@"rowData"];
    
    if (checkArr.count) {
        [askInfoArr addObject:checkDict];
    }
    
    return askInfoArr;
}

- (void)initOrderDetailNewControllerBase{
    
    self.title = @"工单详情";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNavigationBarBtn];
}
#pragma mark - 导航栏返回按钮 ----
- (void)addNavigationBarBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
}

- (void)popViewController:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backForRefreshOrderStatus" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCloseOrderBtn{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"关闭工单" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 20, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:YHNagavitionBarTextColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(closeToOrder) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
#pragma mark - 关闭工单 ----
- (void)closeToOrder{
    
    self.orderInfo = self.orderDetailInfo;
    [self endBill:nil];
    
    return;
    __weak __typeof__(self) weakSelf = self;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"关闭工单" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alertView textFieldAtIndex:0];
    txtName.placeholder = @"请输入关闭原因";
    
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            UITextField *txt = [alertView textFieldAtIndex:0];
            if ([txt.text isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入关闭原因！" toView:weakSelf.navigationController.view];
                return ;
            }

            [MBProgressHUD showMessage:@"关闭中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             endBill:[YHTools getAccessToken]
             billId:weakSelf.orderDetailInfo[@"id"]
             closeTheReason:txt.text
             onComplete:^(NSDictionary *info) {
                 
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     
                     [[NSNotificationCenter
                       defaultCenter] postNotificationName:notificationOrderListChange object:Nil userInfo:nil];
                     __strong __typeof__(self) strongSelf = weakSelf;
                     __block BOOL isBack = NO;
                     [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         if ([obj isKindOfClass:[YHOrderListController class]]) {
                             [strongSelf.navigationController popToViewController:obj animated:YES];
                             *stop = YES;
                             isBack = YES;
                         }
                     }];
                     
                     if (!isBack) {
                         [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
                                 UIWebView *webView = [obj valueForKey:@"webView"];
                                 [webView reload];
                                 
                                 [strongSelf.navigationController popToViewController:obj animated:YES];
                                 *stop = YES;
                                 isBack = YES;
                             }
                         }];
                     }
                     
                     if (!isBack) {
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     }
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLogERROR(@"");
                         [weakSelf showErrorInfo:info];
                     }
                 }
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];;
             }];
        }
    }];
    
}

- (void)initOrderDetailUI{
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    // 顶部菜单栏
    YHOrderDetailTopContainView *topContainView = [[YHOrderDetailTopContainView alloc] initWithFrame:CGRectMake(0, topMargin, self.view.frame.size.width, 44)];
    self.topContainView = topContainView;
    self.topContainView.hidden = YES;
    topContainView.backgroundColor = [UIColor whiteColor];
    topContainView.titleArr = @[@"检测方案",@"基本信息",@"问询信息"];
    [self.view addSubview:topContainView];
    __weak typeof(self)weakSelf = self;
    topContainView.topButtonClickedBlock = ^(UIButton *btn) {
        
        if ([btn.currentTitle isEqualToString:@"检测方案"]) {
            [weakSelf showCheckCaseView];
        }
        
        if ([btn.currentTitle isEqualToString:@"基本信息"]) {
            [weakSelf showbaseInfoView];
        }
        
        if ([btn.currentTitle isEqualToString:@"问询信息"]) {
            [weakSelf showAskAboutView];
        }
    };
    
    UILabel *errolL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topContainView.frame) + 5, self.view.frame.size.width, 0)];
    errolL.text = @"开始检测后不能修改项目";
    errolL.font = [UIFont systemFontOfSize:16];
    errolL.textColor = [UIColor whiteColor];
    errolL.textAlignment = NSTextAlignmentCenter;
    errolL.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.errolL = errolL;
    [self.view addSubview:errolL];
    
    self.detailTableview.hidden = YES;
    
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
//    self.tableFootV = footView;
    
    // 查看检测报告
    UIButton *lookUpBtn = [[UIButton alloc] init];
    [lookUpBtn setTitle:@"查看报告" forState:UIControlStateNormal];
    lookUpBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.lookUpBtn = lookUpBtn;
    [self.view addSubview:lookUpBtn];
    [lookUpBtn setTitleColor:[UIColor colorWithHexString:@"0x181818"] forState:UIControlStateSelected];
    [lookUpBtn setBackgroundImage:[self imageWithColor:YHNaviColor] forState:UIControlStateNormal];
    [lookUpBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [lookUpBtn addTarget:self action:@selector(newWholeCarReport) forControlEvents:UIControlEventTouchUpInside];
    [lookUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.offset(0);
        make.height.equalTo(@(40 + SafeAreaBottomHeight));
    }];
    
   //提交数据按钮
    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.bottomBtn = bottomBtn;
    [self.view addSubview:bottomBtn];
    [bottomBtn setTitle:@"提交检测数据" forState:UIControlStateDisabled];
    [bottomBtn setTitle:@"提交检测数据" forState:UIControlStateNormal];
    [bottomBtn setBackgroundImage:[self imageWithColor:YHNaviColor] forState:UIControlStateNormal];
    [bottomBtn setBackgroundImage:[self imageWithColor:YHBlackOneColor] forState:UIControlStateDisabled];
    [bottomBtn addTarget:self action:@selector(bottomClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookUpBtn.mas_right);
        make.right.offset(0);
        make.bottom.offset(0);
        self.with = make.width.offset(screenWidth/3.0);
        make.height.equalTo(@(40 + SafeAreaBottomHeight));
    }];
    
    if(IphoneX){
        lookUpBtn.titleEdgeInsets = UIEdgeInsetsMake(18, 0, 32, 0);
        bottomBtn.titleEdgeInsets = UIEdgeInsetsMake(18, 0, 32, 0);
    }
    [self setBottomBtnStatus];
}

#pragma mark - 检测方案展示 ---
- (void)showCheckCaseView{
    
    self.detailTableview.hidden = NO;
    self.baseInfoTableview.hidden = YES;
    self.askAboutTableview.hidden = YES;
    self.bottomBtn.hidden = NO;
    self.lookUpBtn.hidden = NO;
//    if (!self.dataArr.count && !self.detailTableview.hidden && !_isShow) {
//        [MBProgressHUD showError:@"暂无初检信息" toView:self.view];
//    }
}
#pragma mark - 基本信息展示 ---
- (void)showbaseInfoView{
    
    self.detailTableview.hidden = YES;
    self.baseInfoTableview.hidden = NO;
    self.askAboutTableview.hidden = YES;
    self.bottomBtn.hidden = YES;
    self.lookUpBtn.hidden = YES;
    [self.baseInfoTableview reloadData];
}
#pragma mark - 问询view展示 ---
- (void)showAskAboutView{
    
    self.detailTableview.hidden = YES;
    self.baseInfoTableview.hidden = YES;
    self.askAboutTableview.hidden = NO;
    self.bottomBtn.hidden = YES;
    self.lookUpBtn.hidden = YES;
    if (!self.askInfoArr.count) {
        [MBProgressHUD showError:@"暂无问询信息" toView:self.view];
    }else{
        [self.askAboutTableview reloadData];
    }
}



#pragma mark --isCheckComplete --------
- (void)setIsCheckComplete:(BOOL)isCheckComplete{
    _isCheckComplete = isCheckComplete;

}
#pragma mark - 设置底部按钮的状态 ----
- (void)setBottomBtnStatus{
    
    self.lookUpBtn.hidden = NO;//报告生成完需要显示
    self.bottomBtn.hidden = NO;//报告生成完需要显示
    
    //首保已经购买套餐才显示复检按钮,不然就显示查看报告,延保直接根据复检状态显示
    if(self.functionCode == YHFunctionIdEndBill || self.functionCode == YHFunctionIdClose || [self.diagnoseModel.package_check isEqualToString:@"0"] || [self.diagnoseModel.nextStatusCode isEqualToString:@"pendingPackage"] || [self.diagnoseModel.billStatus isEqualToString:@"complete"]){
     
           self.with.offset(screenWidth);
           self.bottomBtn.enabled = YES;
           self.bottomBtnTitle = @"查看报告";
           return;
    }

    if(self.functionCode == YHFunctionIdConsulting){
               self.with.offset(screenWidth);
               self.bottomBtn.enabled = NO;
    }
    
    // && [self.diagnoseModel.reportStatus isEqualToString:@"1"]
    if(self.functionCode == YHFunctionIdInitialSurvey ){//初检且报告未生成
               self.with.offset(screenWidth);
               self.bottomBtn.enabled = YES;
               self.bottomBtnTitle = @"下一步";
        
    }
    
    if(self.functionCode == YHFunctionIdReCheck){
        
              self.with.offset(screenWidth * 2/3.0);
              self.lookUpBtn.selected = YES;
              self.bottomBtn.enabled = [self isCheckedForData];
              self.bottomBtnTitle = self.diagnoseModel.recheck_num.intValue < 2 && !self.isSubmiting ? @"复检" :  [NSString stringWithFormat:@"提交第%d次复检数据",self.diagnoseModel.recheck_num.intValue];
           
       }
    
}

#pragma mark - 底部按钮点击 -------
- (void)bottomClickEvent{
    {
            if([self.bottomBtn.currentTitle isEqualToString:@"复检"] && !self.isSubmiting){//第一次复检切换页面
                self.arrData = @[self.dataArr].mutableCopy;
                self.isSubmiting = YES;
                [self setBottomBtnStatus];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_detailTableview setContentOffset:CGPointMake(0, 0) animated:NO];
                     [_detailTableview reloadData];
                    });

                return;
            }
      
            
            if ([self.bottomBtn.currentTitle isEqualToString:@"下一步"]) {//下一步

                UIViewController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBillPackageController"];
                  [vc setValue:self.orderDetailInfo[@"id"] forKey:@"billId"];
                  [self.navigationController pushViewController:vc animated:YES];
                  self.isBack = YES;
                  return;
               
            }
        
            if([self.bottomBtn.currentTitle isEqualToString:@"查看报告"]){
                [self newWholeCarReport];//h5
                return;
            }
            
            // 提交检测数据
            [self submitData];

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _askAboutTableview) {
        return self.askInfoArr.count;
    }
    
     if (tableView == _detailTableview) {
        return self.arrData.count;
     }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        NSLog(@"11111111---%lu-----%lu",(unsigned long)[self.arrData[section] count],section);
        return [self.arrData[section] count];
        
    }else if(tableView == _baseInfoTableview){
        // 基本信息
        return self.baseInfoArr.count;
    }else{
        if (!self.askInfoArr.count) {
            return 0.0;
        }
        // 问询信息
        NSDictionary *sectionDict = self.askInfoArr[section];
        NSArray *rowArr = sectionDict[@"rowData"];
        return rowArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _detailTableview) {
        
        id model = self.arrData[indexPath.section][indexPath.row];
        
        if ([model isKindOfClass:[YTTimerModel class]]) {
            YTTimerModel *Mod = model;
            YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
            diagnoseCell.backgroundColor = [UIColor clearColor];
            diagnoseCell.diagnoseTitieL.textColor = [UIColor blackColor];
            diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
            diagnoseCell.diagnoseTitieL.text = Mod.name;
            diagnoseCell.diagnoseTextView.textColor = [UIColor blackColor];
            diagnoseCell.diagnoseTextView.text = Mod.content;
            diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return diagnoseCell;
        }
        
            if ([model isKindOfClass:[packageOwnerModel class]]) {
                    YTBillPackageCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"YTBillPackageCellOne"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = model;
                    cell.h.constant = cell.model.system_names.count * 30;
                     return cell;
            }
        
            if([model isKindOfClass:[NSString class]]){//延保车主选择系统
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.textLabel.text = [NSString stringWithFormat:@" %@",model];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [UIColor colorWithHexString:@"0x2a2a2a"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8,cell.height)];
                view.backgroundColor = tableView.backgroundColor;
                [cell.contentView addSubview:view];
                
                UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(screenWidth - 8, 0, 8,cell.height)];
                view1.backgroundColor = tableView.backgroundColor;
                [cell.contentView addSubview:view1];
                
                return cell;
                
            }
            
            if([model isKindOfClass:[TTZSYSModel class]]){
                
               YHOrderDetailViewCell *orderDetailCell = [YHOrderDetailViewCell createOrderDetailViewCell:tableView];
                orderDetailCell.cellModel = self.dataArr[indexPath.row];
                orderDetailCell.type = YHOrderDetailViewCellTypeArrowAndText;
                orderDetailCell.checkL.text = self.diagnoseModel.recheck_num.intValue > 1 ? @"未检测" : orderDetailCell.checkL.text;//复检过且没有完成的单显示
                return orderDetailCell;
            }
            
            if ([model isKindOfClass:[YTCResultModel class]]) {
                
                YHDiagnoseNewView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseNewView"];
                diagnoseCell.backgroundColor = [UIColor clearColor];
                NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                    //调整行间距
                paragraphStyle.lineSpacing = 5;
                NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(0.5),
                    NSFontAttributeName:[UIFont systemFontOfSize:14]};
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString: self.diagnoseModel.checkResultArr.makeResult attributes:attriDict];
                diagnoseCell.diagnoseTextView.attributedText = attributedString;
                diagnoseCell.diagnoseTextView.editable = NO;
                diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return diagnoseCell;
            }
        
          if ([model isKindOfClass:[YTPlanModel class]]) {

            YTPlanCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
            plancell.leftMargin.constant = 8.0;
            plancell.rightMargin.constant = 8.0;
            plancell.orderType = self.info[@"data"][@"billType"];
            plancell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *arr = self.arrData[indexPath.section];
            plancell.line.hidden = (indexPath.row == arr.count-1);
            YTPlanModel *obj = self.arrData[indexPath.section][indexPath.row];
            obj.isOnlyOne = (arr.count == 1);
            plancell.model = obj;
            return plancell;

        }
        
        return nil;
        
    }else if(tableView == _baseInfoTableview){
        // 基本信息
        YHCheckCarDetailCell * baseInfoCell = [YHCheckCarDetailCell createCheckCarDetailCell:tableView];
        baseInfoCell.baseInfo = self.baseInfoArr[indexPath.row];
        baseInfoCell.maxRows = self.baseInfoArr.count;
        baseInfoCell.indexPath = indexPath;
        return baseInfoCell;
        
    }else{
        // 问询信息
        YHCheckCarDetailCell * checkCarcell = [YHCheckCarDetailCell createCheckCarDetailCell:tableView];
        
        NSDictionary *sectionDict = self.askInfoArr[indexPath.section];
        NSArray *rowArr = sectionDict[@"rowData"];
        
        checkCarcell.askInfo = rowArr[indexPath.row];
        checkCarcell.maxRows = rowArr.count;
        checkCarcell.indexPath = indexPath;
        return checkCarcell;
    }
    
}


- (void)addPlan{
    
    
    if([self.orderDetailInfo[@"billType"] isEqualToString:@"A"]){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/repair_price.html?token=%@&status=ios&billId=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], self.orderDetailInfo[@"id"]];
        self.isBack = YES;
        controller.urlStr = urlStr;
        controller.title = @"专修询价";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *localPlans = [self.diagnoseModel.maintain_scheme filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_sys < 1"]];
        NSArray *localNames = [localPlans valueForKey:@"name"];
        
        NSInteger sysC = self.diagnoseModel.maintain_scheme.count - localPlans.count;
        NSInteger i = sysC + 1;
        while ([localNames containsObject:[NSString stringWithFormat:@"方案%ld",i]]) {
            i++;
        }
        YHSchemeModel *localPlan = [YHSchemeModel new];
        localPlan.name = [NSString stringWithFormat:@"方案%ld",i];
        localPlan.total_price = @"0.00";
        [self.diagnoseModel.maintain_scheme addObject:localPlan];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            YTDepthController *vc =[YTDepthController new];
            vc.orderType = self.info[@"data"][@"billType"];
            vc.order_id = self.orderDetailInfo[@"id"];
            vc.index = [self.diagnoseModel.maintain_scheme indexOfObject:localPlan];
            vc.reportModel = self.diagnoseModel;
            __weak typeof(self)weakSelf = self;
            vc.removeRepairCaseSuccessOperation = ^{
                [weakSelf getDataToRefreshView];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [self.detailTableview reloadData];
            return;

        });
    });
}

- (BOOL)isExistSelectedElement{
    
    self.sysIds = [NSMutableString string];
    for (int i = 0; i<self.modelDict.allKeys.count; i++) {
        NSString *key = self.modelDict.allKeys[i];
        BOOL isOn = [self.modelDict[key] boolValue];
        if (isOn) {
            [self.sysIds appendFormat:@"%@,",key];
        }
    }
    if (self.sysIds.length > 0) {
        self.sysIds = [self.sysIds substringToIndex:self.sysIds.length - 1].mutableCopy;
    }
    
    return self.sysIds.length > 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _detailTableview) {
    
       return UITableViewAutomaticDimension;
        
    }else if(tableView == _baseInfoTableview){
        
        return 45.0;
    }else{
        
        NSDictionary *sectionDict = self.askInfoArr[indexPath.section];
        NSArray *rowArr = sectionDict[@"rowData"];
        NSDictionary *item = rowArr[indexPath.row];
        NSArray *imgList = item[@"imgList"];
        return imgList.count > 0 ? 45.0 + 94.0 : 45.0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
            id model = self.arrData[indexPath.section][indexPath.row];
            
                if ([model isKindOfClass:[packageOwnerModel class]]) {
                      return;
                    }
                
                if([model isKindOfClass:[TTZSYSModel class]]){//选择数据
                    
                    [self clickOrderDetailCell:tableView indexPath:indexPath];
                }
                
                if ([model isKindOfClass:[YTCResultModel class]]) {
                
                    return ;
                }
            
              if ([model isKindOfClass:[YTPlanModel class]]) {

               if(([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"newWholeCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"usedCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"extWarrantyInitialSurvey"])){//初检可以去编辑
                    //维修方式页面
                    YTDepthController *vc =[YTDepthController new];
                    vc.orderType = self.info[@"data"][@"billType"];
                    vc.index = indexPath.row;
                    self.isBack = YES;
                    vc.reportModel = self.diagnoseModel;
                    vc.order_id = self.orderDetailInfo[@"id"];
                    __weak typeof(self)weakSelf = self;
                    vc.removeRepairCaseSuccessOperation = ^{
                        [weakSelf getDataToRefreshView];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                  
                  YHOrderDetailDepthViewController *VC = [[YHOrderDetailDepthViewController alloc]init];
                  VC.diagnoseModel =  self.diagnoseModel.maintain_scheme.firstObject;
                  VC.title = @"工单详情";
                  [self.navigationController pushViewController:VC animated:YES];
                  return;

            }
}

- (void)clickOrderDetailCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    TTZSYSModel *model = self.dataArr[indexPath.row];
    if ([model.code isEqualToString:@"oil"]) {
        return;
    }
    
    if ((self.functionCode == YHFunctionIdConsulting || self.functionCode == YHFunctionIdReCheck) && ![self.diagnoseModel.nextStatusCode isEqualToString:@"pendingPackage"]) {
        // 没有检测完成
        __weak typeof(self) weakSelf = self;
        TTZCheckViewController *vc = [TTZCheckViewController new];
        vc.detailNewController = self;
        vc.billType = [self.orderDetailInfo valueForKey:@"billType"];
        vc.sysModels = self.dataArr;
        vc.orderInfo = self.info[@"data"];
        vc.baseInfo = self.info[@"data"][@"baseInfo"];
        vc.billId = self.orderDetailInfo[@"id"];
        vc.is_circuitry = [self.info[@"data"][@"is_circuitry"] boolValue];
        ///
        NSArray *initialSurveyItemVals = [[self.info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItemVal"];
        NSArray *initialSurveyItems = [[self.info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItem"];
        NSArray *m_item_vals = [[self.info valueForKeyPath:@"data"] valueForKeyPath:@"m_item_val"];
        NSArray *arr = [self.info[@"data"][@"billType"] isEqualToString:@"J007"] ? m_item_vals : initialSurveyItems?initialSurveyItems:initialSurveyItemVals;
        vc.sysArray = arr.mutableCopy;
        ///
        vc.callBackBlock = ^{
            [weakSelf getDataToRefreshView];
        };
        vc.currentIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    // 检测完毕的情况
    YHCheckDetailViewController *checkDetailVc = [[YHCheckDetailViewController alloc] init];
    checkDetailVc.orderDetailInfo = self.orderDetailInfo;
    [self.navigationController pushViewController:checkDetailVc animated: YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _askAboutTableview) {
        
        YHAskAboutInfoHeaderView *askAboutHeaderView = [[YHAskAboutInfoHeaderView alloc] init];
        if (self.askInfoArr.count) {
            NSDictionary *sectionDict = self.askInfoArr[section];
            [askAboutHeaderView setTitle:sectionDict[@"sectionTitle"]];
            BOOL isEqual = [sectionDict[@"sectionTitle"] isEqualToString:@"验车"];
            askAboutHeaderView.jumpCheckCarPicBtn.hidden = !isEqual;
            __weak typeof(self)weakSelf = self;
            if (isEqual) {
                askAboutHeaderView.jumpToCarPicBlock = ^{
                    [weakSelf pushCarJump];
                };
            }
        }
        
        return askAboutHeaderView;
    }
    if (tableView == _detailTableview) {
        {
            
               id model = self.arrData[section][0];
            
                UIView *bgView = [[UIView alloc] init];
                bgView.backgroundColor = tableView.backgroundColor;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
                view.clipsToBounds = YES;
                UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 40)];
                [view addSubview:boxV];
                [boxV setRounded:boxV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
                boxV.backgroundColor = [UIColor whiteColor];
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 30)];
                titleLB.font = [UIFont systemFontOfSize:18];
            
                NSString *title = nil;
                if ([model isKindOfClass:[packageOwnerModel class]]){
                    title = [self.diagnoseModel.nextStatusCode isEqualToString:@"pendingPackage"] || [self.diagnoseModel.package_check isEqualToString:@"0"] ? @"待车主选择套餐" : @"车主选择套餐";
                }
            
                if([model isKindOfClass:[NSString class]]){//延保车主选择系统
                    title = [self.diagnoseModel.nextStatusCode isEqualToString:@"pendingPackage"] || [self.diagnoseModel.package_check isEqualToString:@"0"] ? @"待车主选择系统" : @"车主选择系统";
                }
                        
                if([model isKindOfClass:[TTZSYSModel class]]){
                    NSString *str = nil;
                    if([self.info[@"data"][@"billType"] isEqualToString:@"A"]){
                        str = @"捕车首保";
                    }
                    if([self.info[@"data"][@"billType"] isEqualToString:@"Y002"]){
                        str = @"延长保修";
                    }
                    title = [NSString stringWithFormat:@"%@复检",str];
                }
                        
                if ([model isKindOfClass:[YTCResultModel class]]){
                    title = @"诊断结果";
                }

                if ([model isKindOfClass:[YTPlanModel class]]){
                    title = @"维修方案";
                }
                    titleLB.text = title;

                    if([model isKindOfClass:[YTPlanModel class]] && ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]))

                    {// && !IsEmptyStr(self.diagnoseModel.checkResultArr.makeResult)
                        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addBtn.frame = CGRectMake(boxV.width -  54 - ([self.info[@"data"][@"billType"] isEqualToString:@"A"] ? 20 : 0) , 10,[self.info[@"data"][@"billType"] isEqualToString:@"A"] ? 64 : 44, 30);
                        [addBtn setTitleColor:[self.info[@"data"][@"billType"] isEqualToString:@"A"] ? [UIColor colorWithHexString:@"0x46AEF7"] :YHNaviColor forState:UIControlStateNormal];
                        addBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                        [addBtn setTitle:[self.info[@"data"][@"billType"] isEqualToString:@"A"] ? @"专修询价" :@"新增" forState:UIControlStateNormal];
                        [addBtn addTarget:self action:@selector(addPlan) forControlEvents:UIControlEventTouchUpInside];
                        [boxV addSubview:addBtn];
                    }
//                }
                [boxV addSubview:titleLB];
                [bgView addSubview:view];
                return bgView;
        }
       
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 10)];
        boxV.backgroundColor = [UIColor whiteColor];
        [view addSubview:boxV];
        [boxV setRounded:boxV.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
        return view;
    }else{
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _askAboutTableview) {
        if (!self.askInfoArr.count) {
            return 0;
        }
        return 45.0;
    }
    if (tableView == _detailTableview) {
        NSArray *arr = self.arrData[section];
        if([arr.firstObject isKindOfClass:[YTTimerModel class]])
        {
            return 0.0;
        }
        return 40;
    }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == _askAboutTableview) {
        if (!self.askInfoArr.count) {
            return 0.0;
        }
    }
    
//    NSArray *arr = self.arrData[section];
//    if([arr.firstObject isKindOfClass:[YTTimerModel class]])
//    {
//        return 0.0;
//    }
    
    return 20;
}

- (BOOL)isRequireShowRepairCase{
    
    if ([self.diagnoseModel.nowStatusCode isEqualToString:@"consulting"]) {
        return NO;
    }
    return YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.footChildView setRounded:self.footChildView.bounds corners:UIRectCornerBottomRight | UIRectCornerBottomLeft radius:8.0];
    if (!_baseInfoTableview.hidden) {
        [_baseInfoHeaderView layoutIfNeeded];
        [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
    }
}
#pragma mark - 验车图片跳转(MWF)
- (void)pushCarJump
{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@"%@%@/CheckCar.html?token=%@&&status=ios&billId=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken],self.orderDetailInfo[@"id"]];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - 获取基本信息数据源数据 ---
- (NSMutableArray *)getBaseInfo:(NSDictionary *)info{
    
    NSMutableArray *baseInfoArr = [NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    if(!IsEmptyStr(info[@"userName"])){
    [dict1 setValue:@"客户名称" forKey:@"name"];
    [dict1 setValue:info[@"userName"] forKey:@"value"];
    [baseInfoArr addObject:dict1];
    }
    
     if(!IsEmptyStr(info[@"phone"])){
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"客户电话" forKey:@"name"];
    [dict2 setValue:info[@"phone"] forKey:@"value"];
    [baseInfoArr addObject:dict2];
     }
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",info[@"plateNumberP"],info[@"plateNumberC"],info[@"plateNumber"]];
     if(!IsEmptyStr(info[@"plateNumberP"]) && !IsEmptyStr(info[@"plateNumberC"]) && !IsEmptyStr(info[@"plateNumber"])){
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"车牌号码" forKey:@"name"];
    [dict3 setValue:str forKey:@"value"];
    [baseInfoArr addObject:dict3];
     }
    
     if(!IsEmptyStr(info[@"vin"])){
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setValue:@"车架号" forKey:@"name"];
    [dict4 setValue:info[@"vin"] forKey:@"value"];
    [baseInfoArr addObject:dict4];
     }
    
    str = [NSString stringWithFormat:@"%@%@",info[@"carBrandName"],info[@"carLineName"]];
    if(!IsEmptyStr(info[@"carBrandName"]) && !IsEmptyStr(info[@"carLineName"])){
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setValue:@"车型" forKey:@"name"];
    [dict5 setValue:str forKey:@"value"];
    [baseInfoArr addObject:dict5];
    }
    
    if(!IsEmptyStr(info[@"carCc"])){
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setValue:@"排量" forKey:@"name"];
    [dict6 setValue:info[@"carCc"] forKey:@"value"];
    [baseInfoArr addObject:dict6];
    }
    
     if(!IsEmptyStr(info[@"gearboxType"])){
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionary];
    [dict7 setValue:@"变速箱" forKey:@"name"];
    [dict7 setValue:info[@"gearboxType"] forKey:@"value"];
    [baseInfoArr addObject:dict7];
     }
    
    if(!IsEmptyStr(info[@"tripDistance"])){
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionary];
    [dict8 setValue:@"公里数" forKey:@"name"];
    [dict8 setValue:info[@"tripDistance"] forKey:@"value"];
        if ([info[@"tripDistance"] length]) {
            [baseInfoArr addObject:dict8];
        }
    }
    
     if(!IsEmptyStr(info[@"fuelMeter"])){
    NSMutableDictionary *dict9 = [NSMutableDictionary dictionary];
    [dict9 setValue:@"燃油表" forKey:@"name"];
    [dict9 setValue:info[@"fuelMeter"] forKey:@"value"];
    if ([info[@"fuelMeter"] length]) {
        [baseInfoArr addObject:dict9];
    }
     }
    
     if(!IsEmptyStr(info[@"startTime"])){
    NSMutableDictionary *dict10 = [NSMutableDictionary dictionary];
    [dict10 setValue:@"预约时间" forKey:@"name"];
    [dict10 setValue:info[@"startTime"] forKey:@"value"];
    [baseInfoArr addObject:dict10];
     }
    
    return baseInfoArr;
}
#pragma mark - 查看检测报告 ----
- (void)newWholeCarReport{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    //http://www.mhace.cn/jnsDev/index.html?token=e2ad4932aea3b55ee9d2756e4f6cd04c&bill_id=24246&jnsAppStep=Y002_report&bill_type=Y002&status=ios&#/appToH5
    NSString *urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_report&bill_type=Y002&status=ios%@",SERVER_PHP_URL_Statements_H5_Vue, [YHTools getAccessToken], self.orderDetailInfo[@"id"], @"&#/appToH5"];
    
    if ([self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
        || [self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
        urlStr = [NSString stringWithFormat:@"%@&order_state=%@", urlStr, self.orderDetailInfo[@"nextStatusCode"]];
    }
    
    if([self.orderDetailInfo[@"billType"] isEqualToString:@"A"]){
                urlStr = [NSString stringWithFormat:@"%@/%@/maintenance_plan.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],self.orderDetailInfo[@"id"]];
        self.isBack = YES;
    }

    
    controller.urlStr = urlStr;
    controller.title = @"工单";
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//FIXME:  -  提交数据
- (void)submitData{
    
    self.bottomBtn.userInteractionEnabled = NO;
    NSString *billId = self.orderDetailInfo[@"id"];
    NSString *bill_Type = [self.orderDetailInfo valueForKey:@"billType"];
    NSDictionary *info = [self.diagnoseModel.recheck_status isEqualToString:@"0"] ? nil : self.info[@"data"][@"baseInfo"];
    NSMutableArray *resultArr = self.dataArr;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [ZZSubmitDataService saveInitialSurveyForBillId:billId
                                           billType:bill_Type
                                         submitData:resultArr
                                           baseInfo:info
                                            success:^{
                                                [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                [MBProgressHUD showError:@"提交成功"];
                                                 self.bottomBtn.userInteractionEnabled = YES;
                                                 self.isSubmiting = NO;
                                                  if([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"consulting"]){//开启生成报告定时器 //问询状态
                                                      
                                                      if ([bill_Type isEqualToString:@"Y002"]) {
                                                          NSMutableDictionary *billStatus =  [self.orderDetailInfo mutableCopy];
                                                          [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];
                                                          return;
                                                      }
                                                }
                                                   [self creatTimer];
                                                
                                            }
                                            failure:^(NSError * _Nonnull error) {
                                                
                                                [MBProgressHUD hideHUDForView:self.view];
                                                NSString *msg = [error.userInfo valueForKey:@"message"];
                                                self.bottomBtn.userInteractionEnabled = YES;
                                                [MBProgressHUD showError:msg];

                                            }];
    
}

-(void)creatTimer{//开启生成报告定时器刷新
    YTTimerModel *model = [YTTimerModel new];
    model.name = @"温馨提示";
    model.content = @"报告生成中，请稍后查询。";
    self.arrData = @[@[model]].mutableCopy;
    self.lookUpBtn.hidden = YES;//报告生成中需要隐藏
    self.bottomBtn.hidden = YES;//报告生成中需要隐藏
    [_detailTableview reloadData];
     NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
         [self getDataToRefreshView];
     }];
     [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
     self.timer = timer;
}

//根据颜色生成图片(底部按钮使用)
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setBottomBtnTitle:(NSString *)bottomBtnTitle{//更新复检按钮文字
    
    [self.bottomBtn setTitle:bottomBtnTitle forState:UIControlStateNormal];
    if([bottomBtnTitle containsString:@"复检"]){
    [self.bottomBtn setTitle:bottomBtnTitle forState:UIControlStateDisabled];
    }
}


@end

