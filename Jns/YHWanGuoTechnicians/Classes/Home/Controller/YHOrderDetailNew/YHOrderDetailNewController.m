//
//  YHOrderDetailNewController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//



#import "YHOrderDetailNewController.h"
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

@interface YHOrderDetailNewController ()<UITableViewDelegate,UITableViewDataSource>
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

@property (nonatomic, weak) UIButton *bottomBtn;
/** 查看检测报告按钮 */
@property (nonatomic, weak) UIButton *lookUpBtn;
/** 录入检测费按钮 */
@property (nonatomic, weak) UIButton *checkCostBtn;

//@property (nonatomic, copy) NSDictionary *info;
//@property (nonatomic, copy) NSMutableArray *ttzData;

@property (nonatomic, weak) YHOrderDetailTopContainView *topContainView;
/** tableView的headerView */
@property (nonatomic, weak) YHOrderDetailViewHeaderView *headerView;

@property (nonatomic, weak) UIView *contentView;
/** 基本信息的headerView */
@property (nonatomic, weak) UIView *baseInfoHeaderView;
/** 是否可上传 */
@property (nonatomic, assign) BOOL isUpLoad;
/** 是否已推送报告 */
@property (nonatomic, assign) BOOL isPushReport;

@property (nonatomic, weak) UIView *seprateview;
/** 是否是历史工单 */
@property (nonatomic, assign) BOOL isHistoryOrder;

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

@property (nonatomic, assign) BOOL isNo;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) BOOL isShow;

@property (strong, nonatomic) UITextField *price;//二手车估价输入框

@property (nonatomic, strong) NSMutableDictionary *didUsedCarStatus;
@property (nonatomic, strong) NSMutableDictionary *assess_info;
@property (nonatomic, strong) NSMutableDictionary *bucheSync;
@property (nonatomic, assign) BOOL isBack;//是否跳转到其他页面
@property (nonatomic, assign) CGFloat h;//记录刷新后cell高度
@property (nonatomic , strong)MASConstraint *height;
@end

extern NSString *const notificationOrderListChange;

static  NSInteger MaxAllowUploadCount = 10;


@implementation YHOrderDetailNewController

- (BOOL)isNo{

    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E002"] || [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"]) {
        return NO;
    }

    
    _isNo = ([self.diagnoseModel.reportStatus isEqualToString:@"0"]) && ([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"extWarrantyInitialSurvey"]);
    
    
    if (_isNo && !self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self getDataToRefreshView];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
    
    if (!_isNo && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    return _isNo;
}

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
//        [self initOrderDetailUI];
        [self getDataToRefreshView];
    }
    return self;
}
- (void)getDataToRefreshView{
    
    dispatch_group_t group = dispatch_group_create();

    if(!self.timer) [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
#pragma mark - 调试
//        NSMutableDictionary *obj =  self.orderDetailInfo.mutableCopy;
//        obj[@"billType"] = @"E003";
//        self.orderDetailInfo = obj;

        //[self getCheckCarVal:group];
        [self initData:group];
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
            self.modelDict = [NSMutableDictionary dictionary];
            NSArray *initialSurveyItem = self.info[@"data"][@"initialSurveyItem"];
    
            for (NSDictionary *elementItem in initialSurveyItem) {
                
                if ([elementItem[@"code"] isEqualToString:@"oil"]) {
                    self.oilId = elementItem[@"id"];
                }
                
                if ([elementItem[@"checkedStatus"] isEqualToString:@"1"]) {
                    [self.modelDict setValue:[NSNumber numberWithBool:YES] forKey:elementItem[@"id"]];
                }else{
                    [self.modelDict setValue:[NSNumber numberWithBool:NO] forKey:elementItem[@"id"]];
                }
            }
        }
        self.isClickedProfession = [self isExistSelectedElement];
        
        [self resfreshView:group];
    });
}

- (CGFloat)diagnoseHeight{
    
    _diagnoseHeight = 100;
    NSArray *strArr = [self.diagnoseModel.checkResultArr.makeResult componentsSeparatedByString:@"\n"];
    if (!strArr.count) {
        _diagnoseHeight = 55;
    }
   __block int sum = 0;
    [strArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       CGFloat height = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        int num = ceil(height/(screenWidth-46));
        if (num > 1) { // +行距
           _diagnoseHeight += (num - 1)*12;
        }
        sum += num;
    }];
    _diagnoseHeight += sum *18;
    return _diagnoseHeight;
}

#pragma mark - 刷新界面 ----
- (void)resfreshView:(dispatch_group_t) group{

    self.isHistoryOrder = NO;
    
    NSMutableDictionary *dataDict = self.info[@"data"];
    NSDictionary *baseInfo = dataDict[@"baseInfo"];
    self.baseInfoArr = [self getBaseInfo:baseInfo];
    self.askInfoArr = [self getAskInfoArr:self.info];
    
    if ([[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"consulting"]) {
        // 问询
        self.isCheckComplete = NO;
        self.isUpLoad = NO;
        self.isPushReport = NO;
        if([self.orderDetailInfo[@"billType"] isEqualToString:@"J007"] && [self.diagnoseModel.m_item_edit_status isEqualToString:@"0"]){
            // 已经进行过一步
            self.isCheckComplete = YES;
            self.isUpLoad = YES;
            self.isPushReport = NO;
        }
        
    }else if ([[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"newWholeCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"usedCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"extWarrantyInitialSurvey"] ){
        // 初检
        self.isCheckComplete = YES;
        self.isUpLoad = YES;
        self.isPushReport = NO;
    }else if([[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"endBill"]){
        // 历史工单
        self.isHistoryOrder = YES;
        self.isCheckComplete = YES;
        self.isUpLoad = NO;
        
    }else{
        // 已推送报告时
        self.isUpLoad = NO;
        self.isCheckComplete = YES;
        self.isPushReport = YES;
    }
    
    self.detailTableview.hidden = NO;
    self.bottomBtn.hidden = NO;
    self.bottomBtn.backgroundColor = [self isCheckedForData] ? YHNaviColor : [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
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
    
        if (self.detailTableview.frame.size.height - self.detailTableview.contentSize.height > 60) {
            
            self.detailTableview.tableFooterView = nil;
            CGFloat bottomMargin = iPhoneX ? 34 : 0;
            [self.view addSubview:self.tableFootV];
            self.tableFootV.y = screenHeight - bottomMargin - 60;
            
        }else{
            
            self.detailTableview.tableFooterView = self.tableFootV;

        }
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
        self.diagnoseModel.billId = self.orderDetailInfo[@"id"];
    }
    [self setBottomBtnStatus];
    
#pragma mark - 这里好像有问题
    [self refreshTableViewHeader];
    
    if (!self.dataArr.count && !self.detailTableview.hidden && !_isShow) {
        [MBProgressHUD showError:@"暂无初检信息" toView:self.view];
        _isShow = YES;
    }
    
    // 关闭工单
    if (self.isHistoryOrder) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
        BOOL isVerifier = NO;
        if (!isVerifier) {
            [self addCloseOrderBtn];
        }else{
            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}
- (void)refreshTableViewHeader{
    
    if([self.orderDetailInfo[@"billType"] isEqualToString:@"J007"])return;

     NSArray *imgs = self.info[@"data"][@"initialSurveyImg"];
     BOOL allowUpload = self.isCheckComplete;
    if (allowUpload) {//允许上传
        
        NSString *billId = self.orderDetailInfo[@"id"];
        TTZSurveyModel *model = [TTZSurveyModel new];
        model.code = @"car_appearance";
        model.billId = billId;
        
        //NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",model.billId,model.code]];
        NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",model.billId,model.code]];
        
        NSInteger count = imgs.count + localImages.count;
        if (count) {
            self.headerView.indicateL.text = [NSString stringWithFormat:@"%lu张",(count > MaxAllowUploadCount)? MaxAllowUploadCount : count];
        }else{
            self.headerView.indicateL.text =@"未上传";
        }
        
    }else{
        self.headerView.indicateL.text = [NSString stringWithFormat:@"%lu张",(unsigned long)imgs.count];
    }
}

#pragma mark - 检测方案tableview ------
- (UITableView *)detailTableview{
    
    if (!_detailTableview) {
        
        // tableview初始化
        UITableView *detailTableview = [self getNeedTableView];
        _detailTableview = detailTableview;
    }
    return _detailTableview;
}

- (void)setHeaderView:(YHOrderDetailViewHeaderView *)headerView{
    _headerView = headerView;
    if (headerView == nil) {
        return;
    }
    [headerView setTitleLableTextContent:self.orderDetailInfo[@"billTypeName"]];
}

//- (void)viewDidAppear:(BOOL)animated{
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [super viewDidAppear:animated];
    if(!self.topContainView){
        [self initOrderDetailUI];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
    
    
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
        [self isCheckedForData];
        return;
    }
    
    if (![self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
         [self isCheckedForData];
    }
    
    if ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"consulting"]) {//问询
        
        if([self isReturn]) return;

    }

    
    
    if (![self.info[@"data"][@"billType"] isEqualToString:@"Y002"] && self.info)  [self getDataToRefreshView];

    
}



- (BOOL)isReturn{
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"E002"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"E003"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J007"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"A"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"Y"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"Y001"]) return YES; //不缓存
    if ([self.info[@"data"][@"billType"] isEqualToString:@"Y002"]) return YES; //不缓存
    
    return NO;
    
}

- (BOOL)isCheckedForData{

    BOOL isChecked = NO;
    for (int i = 0; i<self.dataArr.count; i++) {
        TTZSYSModel *model = self.dataArr[i];
        if (model.progress > 0) {
            isChecked = YES;
        }
    }
    self.bottomBtn.backgroundColor = isChecked ? YHNaviColor :[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    self.bottomBtn.enabled = isChecked;
    return isChecked;
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
    [self.view insertSubview:tableview belowSubview:self.checkCostBtn];
    
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
    
    //这个的目的是为了使得启动app时，单元格是收缩的


    [self initOrderDetailNewControllerBase];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ReloadData" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
         if([self isReturn]) return;
         [self getDataToRefreshView];
    }];
}

- (void)getCheckCarVal:(dispatch_group_t)group{
    dispatch_group_enter(group);
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:self.orderDetailInfo[@"id"] isHistory:NO onComplete:^(NSDictionary *info) {
        
        int code = [info[@"code"] intValue];
//        NSString *msg = info[@"msg"];
        if (code == 20000) {
            
            NSDictionary *data = info[@"data"];
            NSDictionary *checkCarVal = data[@"checkCarVal"]; // 车检数据
            self.checkCarVal = checkCarVal;
            if ([info[@"data"][@"billType"] isEqualToString:@"J004"]) {
                // 汽车检测
                self.diagnoseModel = [YTDiagnoseModel mj_objectWithKeyValues:info[@"data"]];
                if (self.diagnoseModel.maintain_scheme.count) {
                    YTPlanModel *planModel =  self.diagnoseModel.maintain_scheme[0];
                    planModel.name = @"解决方案1";
                    [self.detailTableview reloadData];
                }
            }
           
        }else{
            
            //[MBProgressHUD showError:msg toView:self.view];
        }
        dispatch_group_leave(group);
    } onError:^(NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        }
        dispatch_group_leave(group);
    }];
    
}

- (void)initData:(dispatch_group_t)group{
    
    dispatch_group_enter(group);
    
    //[MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] newWorkOrderDetailForBillId:self.orderDetailInfo[@"id"]
                                                 success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {
                                                     
#pragma mark - 调试
                                                     
//                                                     NSMutableDictionary *obj = [info mutableCopy];
//                                                     NSMutableDictionary *data = [obj[@"data"] mutableCopy];
//                                                     data[@"billType"] = @"E003";
//                                                     obj[@"data"] = data;
//                                                     info = obj;
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                     self.info = info;
                                                     ///[self getCheckCarVal:group]
                                                     NSDictionary *data = info[@"data"];
                                                     NSDictionary *checkCarVal = data[@"checkCarVal"]; // 车检数据
                                                     self.checkCarVal = checkCarVal;
                                                     if ([info[@"data"][@"billType"] isEqualToString:@"J004"]) {
                                                         // 汽车检测
                                                         self.diagnoseModel = [YTDiagnoseModel mj_objectWithKeyValues:info[@"data"]];
                                                         if (self.diagnoseModel.maintain_scheme.count) {
                                                             YTPlanModel *planModel =  self.diagnoseModel.maintain_scheme[0];
                                                             planModel.name = @"解决方案1";
                                                             [self.detailTableview reloadData];
                                                         }
                                                     }
                                                    ////

                                                     if ([self.info[@"data"][@"billType"] isEqualToString:@"E003"]) {
                                                         self.didUsedCarStatus = [info[@"data"][@"didUsedCarStatus"] mutableCopy];
                                                         if (!self.assess_info.allKeys.count) {
                                                             self.assess_info = [info[@"data"][@"reportData"][@"assess_info"] mutableCopy];
                                                         }
                                                         if (!self.bucheSync.allKeys.count) {
                                                             self.bucheSync = [info[@"data"][@"reportData"][@"bucheSync"] mutableCopy];
                                                         }

                                                         
                                                         
//                                                         self.didUsedCarStatus = @{
//                                                                                   @"bill_id":@(1237),
//                                                                                   @"status":@1, //     标识：1-做过；0-未做过
//                                                                                   @"tips":@"检测到该车三个月内进行过二手车检测，是否使用该检测数据？"
//                                                                                   }.mutableCopy;
                                                     }
                                                     
                                                     if (([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"]  || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J007"])) {
                                                         self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:[info valueForKey:@"data"]];
//                                                         self.diagnoseModel.billId = self.orderDetailInfo[@"id"];
//                                                         self.diagnoseModel.isTechOrg = YES;
//                                                         self.diagnoseModel.nextStatusCode = info[@"nextStatusCode"];
//                                                         self.diagnoseModel.nowStatusCode = info[@"nowStatusCode"];
                                                         
                                                         //
                                                         //self.diagnoseModel.checkResultArr.makeResult = @"Service Worker是什么 service worker 是独立于当前页面的一段运行在浏览器后台进程里的脚本。它的特性将包括推...";
                                                         //YTPlanModel *p = [YHSchemeModel new];
                                                         //YTPlanModel *p1 = [YHSchemeModel new];
                                                         //self.diagnoseModel.maintain_scheme = @[p,p1];

                                                     }
        
        if(([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])){

            NSArray *arr = info[@"data"][@"reportData"][@"sysInfo"];
            NSArray *arr1 = info[@"data"][@"reportData"][@"subSysInfo"];
            
            self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:info[@"data"]];
            self.diagnoseModel.checkResultArr.makeResult = [self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            if(!self.diagnoseModel.maintain_scheme.count){
                YHSchemeModel *schemeModel =  [[YHSchemeModel alloc]init];
                schemeModel.name = @"方案";
                [self.diagnoseModel.maintain_scheme addObject:schemeModel];
            }
            
            if(!self.diagnoseModel.checkResultArr.makeResult.length){
                self.diagnoseModel.checkResultArr.makeResult = @"暂无诊断结果";
            }
            
            TTZSYSModel *model = self.dataArr.firstObject;
            if(self.dataArr.count && (!model.list.count || [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"]) && !self.isNo && arr.count){
                dispatch_group_leave(group);
                return;
            }else{
                self.dataArr = [NSMutableArray arrayWithCapacity:arr.count];
            }
                
            TTZSYSModel *model1 = [[TTZSYSModel alloc]init];
            for (NSDictionary *dic in arr) {
                TTZSYSModel *model = [[TTZSYSModel alloc]init];
                //['elect','cold','engine','brake','driver_dust','driver_gear'];
                //['电器17','空调12','发动机13','制动16','传动15','变速箱14'];
                if([dic[@"code"] isEqualToString:@"elect"]){
                    model.className = @"电器系统";
                    model.Id = @"17";
                    model.code = dic[@"code"];
                  
                    
                }else if([dic[@"code"] isEqualToString:@"cold"]){
                    model.className = @"空调系统";
                    model.Id = @"12";
                    model.code = dic[@"code"];
                  
                }else if ([dic[@"code"] isEqualToString:@"engine"]){
                    model.className = @"发动机系统";
                    model.Id = @"13";
                    model.code = dic[@"code"];
                     
                }else if ([dic[@"code"] isEqualToString:@"'driver_dust"]){
                    model.className = @"传动系统";
                    model.Id = @"15";
                    model.code = dic[@"code"];
                    
                }else if ([dic[@"code"] isEqualToString:@"'driver_gear"]){
                    model.className = @"变速箱系统";
                    model.Id = @"14";
                    model.code = dic[@"code"];
                   
                }else if ([dic[@"code"] isEqualToString:@"brake"]){
                    model.className = @"制动系统";
                    model.Id = @"16";
                    model.code = dic[@"code"];
                
                }else if ([dic[@"code"] isEqualToString:@"chas"]){
                    
                   model.className = @"底盘系统";
                   model.Id = @"23";
                   model.code = dic[@"code"];
                    
                }else if([dic[@"code"] isEqualToString:@"driver"]){
                    model.className = @"变速箱系统";
                    model.Id = @"14";
                    model.code = @"driver_gear";
                    
                    model1.className = @"传动系统";
                    model1.Id = @"15";
                    model1.code = @"driver_dust";
                    NSMutableArray *arrModel1 = [NSMutableArray arrayWithCapacity:20];
                    for (NSDictionary *dic in arr1) {
                        NSString *str = dic[@"result"];
                        if(![dic[@"level"] isEqualToString:@"e"] && ![dic[@"level"] isEqualToString:@"1"] && [dic[@"code"] hasPrefix:@"driver_dust"] && !IsEmptyStr(str)){
                            [arrModel1 addObject:dic];
                        }
                    }
                    
                    if(!arrModel1.count){
                       model1.status = @"e";
                       for (NSDictionary *dic in arr1) {
                           if([dic[@"code"] hasPrefix:@"driver_dust"] && [dic[@"level"] isEqualToString:@"1"]){
                                 model1.status = @"1";
                                 break;
                           }
                        }
                       }
                    
                    model1.Sublist  = [TTZSYSNewSubModel mj_objectArrayWithKeyValuesArray:arrModel1];
                    [self.dataArr addObject:model1];
                }else{
                   model.code = @"";
                }
//                NSPredicate *bPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF beginswith[c] %@",model.code]];
//                NSArray *beginWithB = [[arr1 valueForKeyPath:@"code"] filteredArrayUsingPredicate:bPredicate];
                
                NSMutableArray *arrModel = [NSMutableArray arrayWithCapacity:20];
                for (NSDictionary *dic in arr1) {
                    NSString *str = dic[@"result"];
                    if(![dic[@"level"] isEqualToString:@"e"] && ![dic[@"level"] isEqualToString:@"1"] && [dic[@"code"] hasPrefix:model.code] && !IsEmptyStr(str)){
                        [arrModel addObject:dic];
                    }
                }
                
                if(!arrModel.count){
                model.status = @"e";
                for (NSDictionary *dic in arr1) {
                    if([dic[@"code"] hasPrefix:model.code] && [dic[@"level"] isEqualToString:@"1"]){
                          model.status = @"1";
                          break;
                    }
                 }
                }
                                  
                
                model.Sublist  = [TTZSYSNewSubModel mj_objectArrayWithKeyValuesArray:arrModel];
                [self.dataArr addObject:model];
               
            }
            dispatch_group_leave(group);
            return;
        }
                     
                    if(models.count){
                        self.dataArr = models;
                    }
                 self.diagnoseModel.checkResultArr.makeResult = [self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                     dispatch_group_leave(group);
                 }
                 failure:^(NSError *error) {
                     dispatch_group_leave(group);
                     //[MBProgressHUD hideHUDForView:self.view];
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
    
    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J007"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
        NSMutableArray *newVC = [NSMutableArray array];
        NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
        
        [newVC addObject:controllers.firstObject];
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_list&bill_type=%@&status=ios&menuCode=%@&billType=%@&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.orderDetailInfo[@"id"],self.orderDetailInfo[@"billType"],self.orderDetailInfo[@"billType"],self.orderDetailInfo[@"menuCode"],self.orderDetailInfo[@"billTypeNew"]];
        controller.urlStr = urlString;
        controller.barHidden = YES;
        [newVC addObject:controller];
        [self.navigationController setViewControllers:newVC];
        return;
    }
    
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
    topContainView.titleArr = [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"] ? @[@"检测方案",@"基本信息"] : @[@"检测方案",@"基本信息",@"问询信息"];
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
        
        if ([weakSelf.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
            
            CGRect headerFrame = weakSelf.errolL.frame;
            headerFrame.size.height = (!weakSelf.detailTableview.hidden && weakSelf.isClickedProfession && !weakSelf.isCheckComplete) ? 46 : 0;
            weakSelf.errolL.frame = headerFrame;
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
    [_detailTableview registerNib:[UINib nibWithNibName:@"YHDiagnoseView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YHDiagnoseView"];
    
    [_detailTableview registerNib:[UINib nibWithNibName:@"YTPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTPlanCell"];
    
    [_detailTableview registerNib:[UINib nibWithNibName:@"YTReportPromptCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTReportPromptCell"];

    [_detailTableview registerNib:[UINib nibWithNibName:@"HTPlayCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HTPlayCardCell"];
    
    [_detailTableview registerNib:[UINib nibWithNibName:@"YTEstimateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTEstimateCell"];

    [_detailTableview registerNib:[UINib nibWithNibName:@"YTSyncBucheCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTSyncBucheCell"];

    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    self.tableFootV = footView;
    // 底部按钮
    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.bottomBtn = bottomBtn;
    self.bottomBtn.hidden = YES;
    [footView addSubview:bottomBtn];
    bottomBtn.enabled = NO;
    bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    bottomBtn.layer.cornerRadius = 5.0;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomClickEvent) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(bottomBtn.superview).offset(-10);
        make.bottom.equalTo(bottomBtn.superview).offset(-10);
        make.height.equalTo(@40);
    }];
    // 查看检测报告
    UIButton *lookUpBtn = [[UIButton alloc] init];
    [lookUpBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
    lookUpBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.lookUpBtn = lookUpBtn;
    self.lookUpBtn.hidden = YES;
    [footView addSubview:lookUpBtn];
    lookUpBtn.backgroundColor = YHNaviColor;
    [lookUpBtn addTarget:self action:@selector(newWholeCarReport) forControlEvents:UIControlEventTouchUpInside];
    [lookUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(lookUpBtn.superview).offset(-10);
        make.height.equalTo(@40);
        make.width.equalTo(bottomBtn.mas_width).multipliedBy(0.5);
    }];
    
    UIView *seprateview = [[UIView alloc] init];
    self.seprateview = seprateview;
    seprateview.hidden = YES;
    seprateview.backgroundColor = [UIColor whiteColor];
    [footView addSubview:seprateview];
    [seprateview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(lookUpBtn.mas_top);
        make.bottom.equalTo(lookUpBtn.mas_bottom);
        make.left.equalTo(lookUpBtn.mas_right).offset(1);
    }];
    
    // 录入检测费
    UIButton *checkCostBtn = [[UIButton alloc] init];
    [checkCostBtn setTitle:@"录入检测费" forState:UIControlStateNormal];
    checkCostBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.checkCostBtn = checkCostBtn;
    self.checkCostBtn.hidden = YES;
    [footView addSubview:checkCostBtn];
    checkCostBtn.backgroundColor = YHNaviColor;
    [checkCostBtn addTarget:self action:@selector(jumpToInputCheckCostView) forControlEvents:UIControlEventTouchUpInside];
    [checkCostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seprateview.mas_right);
        make.width.equalTo(lookUpBtn);
        make.bottom.equalTo(lookUpBtn);
        make.height.equalTo(lookUpBtn);
    }];
    
        [self setBottomBtnStatus];
}

#pragma mark - 检测方案展示 ---
- (void)showCheckCaseView{
    
    self.detailTableview.hidden = NO;
    self.baseInfoTableview.hidden = YES;
    self.askAboutTableview.hidden = YES;
    
    [self setBottomBtnStatus];
    
    if (!self.dataArr.count && !self.detailTableview.hidden && !_isShow) {
        [MBProgressHUD showError:@"暂无初检信息" toView:self.view];
    }
}
#pragma mark - 基本信息展示 ---
- (void)showbaseInfoView{
    
    self.detailTableview.hidden = YES;
    self.baseInfoTableview.hidden = NO;
    self.askAboutTableview.hidden = YES;
    self.bottomBtn.hidden = YES;
    self.lookUpBtn.hidden = YES;
    self.checkCostBtn.hidden = YES;
    self.seprateview.hidden = YES;
    
    [self.baseInfoTableview reloadData];
}
#pragma mark - 问询view展示 ---
- (void)showAskAboutView{
    
    self.detailTableview.hidden = YES;
    self.baseInfoTableview.hidden = YES;
    self.askAboutTableview.hidden = NO;
    self.bottomBtn.hidden = YES;
    self.lookUpBtn.hidden = YES;
    self.checkCostBtn.hidden = YES;
    self.seprateview.hidden = YES;
    
    if (!self.askInfoArr.count) {
        [MBProgressHUD showError:@"暂无问询信息" toView:self.view];
    }else{
        [self.askAboutTableview reloadData];
    }
}

//FIXME:  -  封面上传
- (void)jumpToCarPicture{
    
    __weak typeof(self) weakSelf = self;
    YHCheckCarAllPictureViewController *pictureVc = [[YHCheckCarAllPictureViewController alloc] init];
    NSString *billId = self.orderDetailInfo[@"id"];
    NSArray *imgs =  self.info[@"data"][@"initialSurveyImg"];;//self.ttzData;
    BOOL allowUpload = self.isUpLoad;
    
    TTZSurveyModel *model = [TTZSurveyModel new];
    model.code = @"car_appearance";
    model.billId = billId;
    
    if(allowUpload){//允许上传
        
        if (imgs.count) {//已经成功上传了一些图片
            
            model.dbImages = [NSMutableArray array];
            if (imgs.count<MaxAllowUploadCount) {//少于五张
                
                // 现添加远程资源
                for (NSInteger i = 0; i < imgs.count; i ++) {
                    TTZDBModel *db = [TTZDBModel new];
                    db.fileId = imgs[i];
                    [model.dbImages addObject:db];
                }
                // 添加本地的资源
                //NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",model.billId,model.code]];
                NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",model.billId,model.code]];
                
                NSInteger count = imgs.count + localImages.count;
                count = (count > MaxAllowUploadCount)? MaxAllowUploadCount : count; //最多5个
                
                for (NSInteger i = imgs.count; i < count; i ++) {
                    TTZDBModel *db = localImages[i - imgs.count];
                    [model.dbImages addObject:db];
                }
                
                // 加上本地缓存还小于5张图片
                if (count<MaxAllowUploadCount) {
                    TTZDBModel *defaultDB = [TTZDBModel new];
                    defaultDB.image = [UIImage imageNamed:@"otherAdd"];
                    [model.dbImages addObject:defaultDB];
                }
                
            }else{//五张全部上传成功
                for (NSInteger i = 0; i < MaxAllowUploadCount; i ++) {
                    TTZDBModel *db = [TTZDBModel new];
                    db.fileId = imgs[i];
                    [model.dbImages addObject:db];
                }
            }
        }
        
    }else{//一进到了预览大图状态
        
        // 防止出现bug
        model.dbImages = [NSMutableArray array];
        // 有网络图片
        for (NSInteger i = 0; i < imgs.count; i ++) {
            TTZDBModel *db = [TTZDBModel new];
            db.fileId = imgs[i];
            [model.dbImages addObject:db];
        }
    }
    
    pictureVc.model = model;
    pictureVc.isAllowUpLoad =  allowUpload;
    pictureVc.callBackBlock = ^{
        [weakSelf getDataToRefreshView];
    };
    [self.navigationController pushViewController:pictureVc animated:YES];
    
}

#pragma mark --isCheckComplete --------
- (void)setIsCheckComplete:(BOOL)isCheckComplete{
    _isCheckComplete = isCheckComplete;
    
    [self setBottomBtnStatus];
}
#pragma mark - 设置底部按钮的状态 ----
- (void)setBottomBtnStatus{
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
        
        if (![self isRequireShowRepairCase]) { // 问询
            
            [self.bottomBtn setTitle:@"提交检测数据" forState:UIControlStateNormal];
           
            if ([self isCheckedForData]) {
                self.bottomBtn.enabled = YES;
                self.bottomBtn.backgroundColor = YHNaviColor;
            }else{
                self.bottomBtn.enabled = NO;
                self.bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
            }
            
        }else{
            [self.bottomBtn setTitle: (self.isPushReport||self.isHistoryOrder)? @"查看检测报告":@"预览报告" forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = YHNaviColor;
        }
        //self.bottomBtn.hidden = NO;
        self.bottomBtn.hidden = self.isNo;
        return;
    }
    
    // 历史工单
    if (self.isHistoryOrder) {
        
        NSDictionary *data = self.info[@"data"];
        NSDictionary *reportData = data[@"reportData"];
        self.bottomBtn.hidden = (reportData.count == 0 || !reportData) ? YES : NO;
        self.lookUpBtn.hidden = YES;
        self.checkCostBtn.hidden = YES;
        self.seprateview.hidden = YES;
        [self.bottomBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
        self.bottomBtn.backgroundColor = YHNaviColor;
        self.bottomBtn.enabled = YES;
        
        return;
    }
    
    if (self.isPushReport) {
        
        NSDictionary *data = self.info[@"data"];
        NSString *handleType = data[@"handleType"];
        
        // 已推送报告 ->有权限
        if ([handleType isEqualToString:@"handle"]) {
            
            self.lookUpBtn.hidden = NO;
            self.checkCostBtn.hidden = NO;
            self.bottomBtn.hidden = YES;
            self.seprateview.hidden = NO;
        }
        
        // 无权限
        if ([handleType isEqualToString:@"detail"]) {
            
            self.lookUpBtn.hidden = YES;
            self.checkCostBtn.hidden = YES;
            self.bottomBtn.hidden = NO;
            self.seprateview.hidden = YES;
        }
        
        [self.bottomBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
        
    }else{
        
        self.bottomBtn.hidden = NO;
        self.lookUpBtn.hidden = YES;
        self.checkCostBtn.hidden = YES;
        self.seprateview.hidden = YES;
        
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
            
            CGRect headerFrame = self.errolL.frame;
            headerFrame.size.height = (!self.detailTableview.hidden && !self.isCheckComplete && self.isClickedProfession) ? 46 : 0;
            self.errolL.frame = headerFrame;
           
            if (self.isCheckComplete) {
                [self.bottomBtn setTitle:@"完善报告" forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = YHNaviColor;
                self.bottomBtn.enabled = YES;
                
            }else{
            
            if([self.info[@"data"][@"detectionStatus"] isEqualToString:@"0"]){
                
                [self.bottomBtn setTitle:@"开始检测" forState:UIControlStateNormal];
                if ([self isExistSelectedElement]) {
                    self.bottomBtn.backgroundColor = YHNaviColor;
                    self.bottomBtn.enabled = YES;
                }else{
                    
                    self.bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
                    self.bottomBtn.enabled = NO;
                }
                
            }else{
                
                [self.bottomBtn setTitle:@"继续检测" forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = YHNaviColor;
                self.bottomBtn.enabled = YES;
            }
        }
            
        }else{
            
            // 问询和初检
            if (self.isCheckComplete) {
                
                self.bottomBtn.backgroundColor = YHNaviColor;
                self.bottomBtn.enabled = YES;
                [self.bottomBtn setTitle: ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"])?@"预览报告":@"完善报告" forState:UIControlStateNormal];
                if([self.info[@"data"][@"billType"] isEqualToString:@"A"] ){
                    [self.bottomBtn setTitle:[self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] ? @"下一步" : @"查看报告" forState:UIControlStateNormal];
                }
                
                self.bottomBtn.hidden = self.isNo;
                
                if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E002"]
                    || [self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
                    //[self.bottomBtn setTitle: @"推送" forState:UIControlStateNormal];
                    [self.bottomBtn setTitle: @"生成报告" forState:UIControlStateNormal];
                    self.bottomBtn.hidden = NO;
                }
                
                if([self.orderDetailInfo[@"billType"] isEqualToString:@"J007"]){
                    
                    [self.bottomBtn setTitle:@"继续AI尾气诊断" forState:UIControlStateNormal];
                }
                
                
            }else{
                
                NSString *str = @"提交检测数据";
                
                if([self.info[@"data"][@"billType"] isEqualToString:@"J007"]){
                    
                    str = @"开始AI尾气诊断";
                    
                };
                
                [self.bottomBtn setTitle:str forState:UIControlStateNormal];
                
                self.bottomBtn.backgroundColor = [self isCheckedForData] ? YHNaviColor :[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
                self.bottomBtn.enabled = [self isCheckedForData];
            }
        }
    }
}

#pragma mark - 底部按钮点击 -------
- (void)bottomClickEvent{
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
        
        if (![self isRequireShowRepairCase]) {
            // 提交检测数据
            [self submitData];
        }else{
            
            [self jumpToCarCheckReport];
        }
        return;
    }
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
        
        if (self.isCheckComplete) {
            
            [self jumpReportForJ003_order];
            
        }else{
            [self professionalExamine];
        }
        
    }else{
        
        if (self.isCheckComplete && ![self.info[@"data"][@"billType"] isEqualToString:@"J007"]) {
            
            if (  ( [self.orderDetailInfo[@"billType"] isEqualToString:@"E002"]
                   || [self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]
                   )
                && !(self.isHistoryOrder || self.isPushReport)) {//推送->支付
                
                if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
                    [self saveE003Quote];
                    return;
                }
                
                //支付页面
                YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                vc.billId = self.orderDetailInfo[@"id"];
                vc.billType =self.orderDetailInfo[@"billType"];
                [self.navigationController pushViewController:vc animated:YES];

                return;
            }
            
            
                
            if ([self.info[@"data"][@"billType"] isEqualToString:@"A"] && !(self.isHistoryOrder || self.isPushReport)) {

                UIViewController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBillPackageController"];
                  [vc setValue:self.orderDetailInfo[@"id"] forKey:@"billId"];
                  [self.navigationController pushViewController:vc animated:YES];
                  self.isBack = YES;
                  return;
               
            }
//
                // 查看检测报告
                [self newWholeCarReport];
//            }
            
        }else{
            
            if([self.info[@"data"][@"billType"] isEqualToString:@"J007"] && [self.diagnoseModel.m_item_edit_status isEqualToString:@"0"]){
                [self getItemList];
                return;
            }
            
            // 提交检测数据
            [self submitData];

        }
    }
}
- (void)saveE003Quote{
    
    if (IsEmptyStr(self.assess_info[@"car_license_time"])) {
        [MBProgressHUD showError:@"请填写上牌时间"];
        return;
    }
    
    NSString *str = self.price.text;
    if (IsEmptyStr(str) || !str.doubleValue) {
        [MBProgressHUD showError:@"请填写正确的第三方评估价"];
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] saveE003QuoteTime:self.assess_info[@"car_license_time"]
                                         price:self.price.text
                              sync_buche_value:[self.bucheSync[@"sync_value"] integerValue]
                                        billId:self.orderDetailInfo[@"id"]
                                       success:^{
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           //支付页面
                                           YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                                           vc.billId = self.orderDetailInfo[@"id"];
                                           vc.billType =self.orderDetailInfo[@"billType"];
                                           [self.navigationController pushViewController:vc animated:YES];

                                       } failure:^(NSError *error) {
                                           [MBProgressHUD hideHUDForView:self.view];
                                           NSString *msg = [error.userInfo valueForKey:@"message"];
                                           [MBProgressHUD showError:msg];

                                       }];
}

- (void)jumpToCarCheckReport{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios#/bill/carDetectionReport?billId=%@",SERVER_PHP_URL_Statements_H5_Vue, [YHTools getAccessToken], self.orderDetailInfo[@"id"]];
    controller.urlStr = urlStr;
    controller.title = @"工单";
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)closeBtnClickedEvent{
    [self.deleAlertView hideDeleteView];
}
#pragma mark - 确定按钮 ---
- (void)sureBtnClickedEvent{
    
    [self saveOrderDeductNumberDetail];
}
#pragma mark - 获取扣除余额 ---
- (void)getOrderDeductNumberDetail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getOrderDeductNumber:[YHTools getAccessToken] billId:[self.orderDetailInfo[@"id"] intValue] onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            NSDictionary *data = info[@"data"];
            if ([data[@"is_expend"] isEqualToString:@"0"]) { // 未扣
                
                [self alertMessageView:[NSString stringWithFormat:@"完善工单检测报告将会扣除余额数%@点,目前剩余余额数%@点",data[@"points_expend"],data[@"points"]]];
            }else{
                // 查看检测报告
                [self newWholeCarReport];
            }

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

- (void)alertMessageView:(NSString *)describeText{
    
    YHDeleteRepairCaseView *deleAlertView = [YHDeleteRepairCaseView alertToView:self.view];
    self.deleAlertView = deleAlertView;
    [deleAlertView.cancelBtn setTitle:@"暂不处理" forState:UIControlStateNormal];
    deleAlertView.describeL.text = describeText;
    [deleAlertView.closeBtn addTarget:self action:@selector(closeBtnClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [deleAlertView.cancelBtn addTarget:self action:@selector(closeBtnClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [deleAlertView.sureBtn addTarget:self action:@selector(sureBtnClickedEvent) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 保存扣除余额 ---
- (void)saveOrderDeductNumberDetail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveOrderDeductNumber:[YHTools getAccessToken] billId:[self.orderDetailInfo[@"id"] intValue] onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        [self.deleAlertView hideDeleteView];
        
        if ([code isEqualToString:@"20000"]) {
             [MBProgressHUD showError:@"扣点成功"];
        }else{
             [MBProgressHUD showError:@"余额数不足"];
        }
        
    } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark - 专业检测 ----
- (void)professionalExamine{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] professionalExamine:[YHTools getAccessToken] billId:[self.orderDetailInfo[@"id"] intValue] sysIds:self.sysIds onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            self.isClickedProfession = YES;
            self.isCheckComplete = YES;
            NSDictionary *data = info[@"data"];
            NSArray *initialSurveyItem = data[@"initialSurveyItem"];
            // 下一状态: 1-初检 2-编辑报告
//            if ([data[@"nexStatus"] isEqualToString:@"1"]) {
        
            if ([self.sysIds isEqualToString:self.oilId]) {
                [self getDataToRefreshView];
                return ;
            }
            
            NSMutableArray *newInitialSurveyItem = [NSMutableArray array];
            for (int i = 0; i<initialSurveyItem.count; i++) {
                NSDictionary *elementItem = initialSurveyItem[i];
                NSArray *list = elementItem[@"list"];
                if ([elementItem[@"checkedStatus"] isEqualToString:@"1"] && list.count > 0) {
                    [newInitialSurveyItem addObject:elementItem];
                }
            }
                [self.bottomBtn setTitle:@"继续监测" forState:UIControlStateNormal];
            
                TTZSYSModel *model = [TTZSYSModel new];
//                model.Id = @"";
                model.className = @"专项";
//                model.saveType = @"";
                model.list = [TTZGroundModel mj_objectArrayWithKeyValuesArray:newInitialSurveyItem];
                self.professionDataArr = [NSMutableArray arrayWithObject:model];
                // 没有检测完成
                __weak typeof(self) weakSelf = self;
                TTZCheckViewController *vc = [TTZCheckViewController new];
                vc.detailNewController = self;
                vc.billType = [self.orderDetailInfo valueForKey:@"billType"];
                vc.sysModels = self.professionDataArr;
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
            
                vc.backBlock = ^{
                    [weakSelf submitData];
                };
                vc.currentIndex = 0;
                vc.isNoEdit = [self.info[@"data"][@"detectionStatus"] isEqualToString:@"1"] ? YES : NO;
                [self.navigationController pushViewController:vc animated:YES];
//            }
            
            // 下一状态: 1-初检 2-编辑报告
//            if ([data[@"nexStatus"] isEqualToString:@"2"]) {
//
//                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//                YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//                 controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_H5@SERVER_PHP_H5_Trunk"dedicated_report.html?token=%@&billId=%@&status=ios", [YHTools getAccessToken], self.orderDetailInfo[@"id"]];
//                controller.title = @"工单";
//                controller.barHidden = YES;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
        }else{
            
            [MBProgressHUD showError:info[@"msg"]];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark - J003工单报告跳转 ----
- (void)jumpReportForJ003_order{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
     controller.urlStr = [NSString stringWithFormat:@"%@%@/dedicated_report.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], self.orderDetailInfo[@"id"]];
    controller.title = @"工单";
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _askAboutTableview) {
        return self.askInfoArr.count;
    }else if(tableView == _detailTableview){
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) { //
            
//            return self.isNo ? 2 : (([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"] || [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]))&&(self.diagnoseModel.maintain_scheme.count || self.diagnoseModel.checkResultArr.makeResult.length)? 3 : 1);
            return self.isNo ? 2 : (([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"] || [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]))&&(self.diagnoseModel.checkResultArr.makeResult)? 3 : 1);

            
            
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) { // 汽车检测
            
            if (!self.dataArr.count) {
                self.headerView.hidden = YES;
                self.footChildView.hidden = YES;
                
                if ([self isRequireShowRepairCase]) {
//                    return 2;
                    return self.isNo? 1 : 2;

                }else{
                    return 0;
                }
                
            }else{
                if ([self isRequireShowRepairCase]) {
//                    return 3;
                    return self.isNo? 2 : 3;

                }else{
                    return 1;
                }
            }
            
        }else{
            
            if (!self.dataArr.count) {
                self.headerView.hidden = YES;
                self.footChildView.hidden = YES;
                return 0;
            }else{
                self.headerView.hidden = NO;
                self.footChildView.hidden = NO;
                
                
                if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
                    
                    if ((self.isPushReport || self.isHistoryOrder)) {
                        return 2;
                    }
                    return 5;
                }
                
                return 1;
            }
        }
        
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
            if (section == 0) {
                return 1;
            }else if (section == 1) {
                return self.dataArr.count;
            }else{
                return 1;
            }
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] ||
            [self.info[@"data"][@"billType"] isEqualToString:@"A"]) {
            
            if (section == 0) {
                 if([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])){
                  return 1;
                 }
                return self.dataArr.count;
            }else if (section == 1) {
                return 1;
            }else{
                return self.diagnoseModel.maintain_scheme.count;
            }

        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
            if (section == 0) {
                // 检测方案
                return self.dataArr.count;
            }else{
                return 1;
            }
            
        }else{
            
            // 检测方案
            return self.dataArr.count;
        }
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
        
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {

            if (indexPath.section == 0) {
                YTReportPromptCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTReportPromptCell"];
                plancell.model = self.didUsedCarStatus;
                plancell.closeBlock = ^{
                    self.didUsedCarStatus[@"status"] = @(0);
                    [self.detailTableview reloadData];
                };
                
                plancell.submitBlock = ^{
                    [self submitNewData];
                };
                return plancell;
            }
            
            if (indexPath.section == 1) {
                YHOrderDetailViewCell *orderDetailCell = [self getOrderDetailViewCell:indexPath tableView:tableView];
                return orderDetailCell;
            }

            
            if (indexPath.section == 2) {
                HTPlayCardCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"HTPlayCardCell"];
                plancell.getValueBlock = ^(NSString * _Nonnull time) {
                    [self getValue:time];
                };
                plancell.userInteractionEnabled = !(self.isPushReport || self.isHistoryOrder);
                if (!self.assess_info) {
                    self.assess_info = @{}.mutableCopy;
                }
                plancell.assess_info = self.assess_info;
                plancell.getValueBlock = ^(NSString * _Nonnull time) {
                    [self getValue:time];
                };
                return plancell;
            }

            if (indexPath.section == 3) {
                YTEstimateCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTEstimateCell"];
                plancell.userInteractionEnabled = !(self.isPushReport || self.isHistoryOrder);
                if (!self.assess_info) {
                    self.assess_info = @{}.mutableCopy;
                }
                plancell.assess_info = self.assess_info;
                self.price = plancell.price;
                return plancell;

            }
            
            if (indexPath.section == 4) {
                YTSyncBucheCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTSyncBucheCell"];
                if (!self.bucheSync) {
                    self.bucheSync = @{}.mutableCopy;
                }
                plancell.bucheSync = self.bucheSync;
                return plancell;
                
            }


        }

        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) {
            
            if (indexPath.section == 0) {
//                && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]
                if([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])){
                 
                    YHOrderDetailViewNewCell *cell = [[YHOrderDetailViewNewCell alloc]init];
                    cell.dataArr = self.dataArr;
                    cell.frame = CGRectMake(8, 0, screenWidth - 16,self.h ?: 44 * self.dataArr.count);
                    cell.click = ^(CGFloat h) {
                        self.h = h;
                        //刷新列表
                        NSIndexSet * index = [NSIndexSet indexSetWithIndex:0];
                        [UIView performWithoutAnimation:^{
                            [tableView reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
                        }];
                    };
                        
                     return cell;
                }
                
                YHOrderDetailViewCell *orderDetailCell = [self getOrderDetailViewCell:indexPath tableView:tableView];
                return orderDetailCell;

            }
            if (indexPath.section == 1) {
                
                if (self.isNo) {
                    YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                    diagnoseCell.backgroundColor = [UIColor clearColor];
                    diagnoseCell.orderType = @"J004";///test
                    diagnoseCell.diagnoseTitieL.textColor = [UIColor blackColor];
                    diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                    diagnoseCell.diagnoseTitieL.text = @"温馨提示";
                    diagnoseCell.diagnoseTextView.textColor = [UIColor blackColor];
                    diagnoseCell.diagnoseTextView.text = @"报告生成中，请稍后查询。";
                    diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;

                    return diagnoseCell;
                }
                YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                diagnoseCell.backgroundColor = [UIColor clearColor];
                diagnoseCell.orderType = @"J004";///test
                diagnoseCell.diagnoseTitieL.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
                diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                diagnoseCell.diagnoseTitieL.text = @"诊断结果";

                //diagnoseCell.diagnoseTextView.backgroundColor = [UIColor redColor];
                NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                    //调整行间距
                paragraphStyle.lineSpacing = 5;
                NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(0.5),
                    NSFontAttributeName:[UIFont systemFontOfSize:14]};
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:IsEmptyStr(self.diagnoseModel.checkResultArr.makeResult)? @"暂无诊断结果" : self.diagnoseModel.checkResultArr.makeResult attributes:attriDict];
                diagnoseCell.diagnoseTextView.attributedText = attributedString;
                diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return diagnoseCell;
            }

            YTPlanCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
            plancell.leftMargin.constant = 8.0;
            plancell.rightMargin.constant = 8.0;
            plancell.orderType = self.info[@"data"][@"billType"];
            plancell.selectionStyle = UITableViewCellSelectionStyleNone;
            plancell.line.hidden = (indexPath.row == self.diagnoseModel.maintain_scheme.count-1);
            YTPlanModel *obj = self.diagnoseModel.maintain_scheme[indexPath.row];
            obj.isOnlyOne = (self.diagnoseModel.maintain_scheme.count == 1);
            
            plancell.model = obj;
//            if (self.diagnoseModel.maintain_scheme.count) {
//                plancell.caseName = @"方案1";
//                plancell.model = self.diagnoseModel.maintain_scheme[0];
//                plancell.model.name = @"维修方案";
//
//            }else{
//                YTPlanModel *model = [YTPlanModel new];
//                model.name = @"维修方案";
//                plancell.caseName = @"维修方案";
//                plancell.model = model;
//            }
            
            return plancell;

        }
        
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
            if (indexPath.section == 0) {
                
                if (!self.dataArr.count) {
                    
                    if (self.isNo) {
                        YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                        diagnoseCell.backgroundColor = [UIColor clearColor];
                        diagnoseCell.orderType = @"J004";///test
                        diagnoseCell.diagnoseTitieL.textColor = [UIColor blackColor];
                        diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                        diagnoseCell.diagnoseTitieL.text = @"温馨提示";
                        diagnoseCell.diagnoseTextView.textColor = [UIColor blackColor];
                        diagnoseCell.diagnoseTextView.text = @"报告生成中，请稍后查询。";
                        diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return diagnoseCell;
                    }

                    YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                    diagnoseCell.backgroundColor = [UIColor clearColor];
                    diagnoseCell.orderType = @"J004";
                    diagnoseCell.diagnoseTitieL.text = @"诊断结果";
                    diagnoseCell.diagnoseTitieL.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
                    diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                    diagnoseCell.diagnoseTextView.backgroundColor = [UIColor redColor];
                   NSString *result = [self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                    diagnoseCell.diagnoseTextView.text = result;
                    diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return diagnoseCell;
                }
                
                YHOrderDetailViewCell *orderDetailCell = [self getOrderDetailViewCell:indexPath tableView:tableView];
                    return orderDetailCell;

            }
            
            if (indexPath.section == 1) {
                
                if (!self.dataArr.count) {
                    YTPlanCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
                    plancell.leftMargin.constant = 8.0;
                    plancell.rightMargin.constant = 8.0;
                    plancell.orderType = @"J004";
                    plancell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (self.diagnoseModel.maintain_scheme.count) {
                        plancell.caseName = @"方案1";
                        plancell.model = self.diagnoseModel.maintain_scheme[0];
                        plancell.model.name = @"维修方案";
                       
                    }else{
                        YTPlanModel *model = [YTPlanModel new];
                        model.name = @"维修方案";
                        plancell.caseName = @"维修方案";
                        plancell.model = model;
                    }
                    
                    return plancell;
                }
                if (self.isNo) {
                    YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                    diagnoseCell.backgroundColor = [UIColor clearColor];
                    diagnoseCell.orderType = @"J004";///test
                    diagnoseCell.diagnoseTitieL.textColor = [UIColor blackColor];
                    diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                    diagnoseCell.diagnoseTitieL.text = @"温馨提示";
                    diagnoseCell.diagnoseTextView.textColor = [UIColor blackColor];
                    diagnoseCell.diagnoseTextView.text = @"报告生成中，请稍后查询。";
                    diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return diagnoseCell;
                }

                
                YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
                diagnoseCell.backgroundColor = [UIColor clearColor];
                diagnoseCell.orderType = @"J004";
                diagnoseCell.diagnoseTitieL.text = @"诊断结果";
                diagnoseCell.diagnoseTitieL.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
                diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
                 NSString *result = [self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                diagnoseCell.diagnoseTextView.text = result;
                diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return diagnoseCell;
            }else{
                
                YTPlanCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
                plancell.leftMargin.constant = 8.0;
                plancell.rightMargin.constant = 8.0;
                plancell.orderType = @"J004";
                plancell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.diagnoseModel.maintain_scheme.count) {
                    plancell.caseName = @"方案1";
                    plancell.model = self.diagnoseModel.maintain_scheme[0];
                    plancell.model.name = @"维修方案";
                    
                }else{
                    YTPlanModel *model = [YTPlanModel new];
                    model.name = @"维修方案";
                    plancell.caseName = @"维修方案";
                    plancell.model = model;
                }
               
                return plancell;
            }
            
        }else{
            
           YHOrderDetailViewCell *orderDetailCell = [self getOrderDetailViewCell:indexPath tableView:tableView];
            return orderDetailCell;
        }
        
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

- (YHOrderDetailViewCell *)getOrderDetailViewCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    YHOrderDetailViewCell *orderDetailCell = [YHOrderDetailViewCell createOrderDetailViewCell:tableView];
    orderDetailCell.cellModel = self.dataArr[indexPath.row];
    orderDetailCell.orderIdType = self.info[@"data"][@"billType"];
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
        
        orderDetailCell.isEnableForSwitch = [self.info[@"data"][@"detectionStatus"] isEqualToString:@"0"] ? YES : NO;
        NSDictionary *elementItem = self.info[@"data"][@"initialSurveyItem"][indexPath.row];
        orderDetailCell.isOnOffSwitch = [[NSString stringWithFormat:@"%@", elementItem[@"checkedStatus"]] isEqualToString:@"0"] ? NO : YES;
        if (self.isCheckComplete) {
            orderDetailCell.type = YHOrderDetailViewCellTypeArrow;
        }else{
            orderDetailCell.type = YHOrderDetailViewCellTypeSwitch;
        }
        orderDetailCell.onOffSwitchTouchEvent = ^(NSString *Id, BOOL isOn) {
            [self.modelDict setValue:[NSNumber numberWithBool:isOn] forKey:Id];
            
            BOOL isSelect = [self isExistSelectedElement];
            if (isSelect) {
                self.bottomBtn.enabled = YES;
                self.bottomBtn.backgroundColor = YHNaviColor;
            }else{
                self.bottomBtn.enabled = NO;
                self.bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
            }
        };
    }else{
        
        orderDetailCell.type = YHOrderDetailViewCellTypeArrowAndText;
    }
    
    return orderDetailCell;
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
        
        
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
            
            if (indexPath.section == 0)
            {
                
                if (([self.didUsedCarStatus[@"status"] integerValue] == 1) && ([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"consulting"])) {
                    
                    
                    YTReportPromptCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTReportPromptCell"];
                    return  [plancell rowHeight:self.didUsedCarStatus];
                    
                }
                return 0.0;
            }
            

            
            if (indexPath.section == 1) return 40.0;

            if (([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"consulting"] )) {
                return 0.0;
            }
            
            return (indexPath.section == 4)? ([self.bucheSync[@"sync_status"] integerValue]? 44 : 0) : 72.0;

        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) {
            
            if(indexPath.section == 0 && (([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]))){
                return self.h ?: 44 * self.dataArr.count;
            }

            if (indexPath.section == 0) return 40.0;
            

            if (indexPath.section == 1){
                if (self.isNo) {
                    return 84;
                }
                return self.diagnoseHeight;
            }

            return UITableViewAutomaticDimension;
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
            if (indexPath.section == 0) {
                if (!self.dataArr.count) {
                    if (self.diagnoseModel.checkResultArr.makeResult.length == 0) {
                        return 0;
                    }
                    return self.diagnoseHeight;
                }else{
                return 40.0;
                }
            }
            if (indexPath.section == 1) {
                if (!self.dataArr.count) {
                    NSDictionary *dataDict = self.info[@"data"];
                    return [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"endBill"] ? 0 : 100;
                }else{
                    
                if (self.isNo) {
                    return 84;
                }
                    
                if (self.diagnoseModel.checkResultArr.makeResult.length == 0) {
                    return 0;
                }
                    return self.diagnoseHeight;
                }
            }else{
                
                NSDictionary *dataDict = self.info[@"data"];
                return [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"endBill"] ? 0: 100;
            }
        }else{ // 非J004
          return 40.0;
        }
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
    
    if (tableView == _detailTableview) {
        
        
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
            
            
            if (indexPath.section == 1) {
                [self clickOrderDetailCell:tableView indexPath:indexPath];
                return;
            }
            
            return;
            
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || ([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])) {
            if (indexPath.section == 0) {
                [self clickOrderDetailCell:tableView indexPath:indexPath];
                return;
            }
            if (indexPath.section == 2) {
                
                if([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]){//已完成的捕车首保点击维修方案
                    YHOrderDetailDepthViewController *VC = [[YHOrderDetailDepthViewController alloc]init];
                    VC.diagnoseModel =  self.diagnoseModel.maintain_scheme.firstObject;
                    VC.title = @"工单详情";
                    [self.navigationController pushViewController:VC animated:YES];
                    return;
                }
                
                if ([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"] || [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]){
                    
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
                return;
               }

            return;
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J004"]) { // 汽车检测
            if (indexPath.section == 0) {
                [self clickOrderDetailCell:tableView indexPath:indexPath];
                return;
            }
            
            if (!self.dataArr.count && indexPath.section == 1) {
                if ([self.diagnoseModel.nowStatusCode isEqualToString:@"endBill"]) {
                    return;
                }
//                YHRepairCaseDetailController *vc =[YHRepairCaseDetailController new];
//                vc.billType = self.info[@"data"][@"billType"];
//                vc.index = 0;
//                vc.model = self.diagnoseModel;
//                __weak typeof(self)weakSelf = self;
//                vc.refreshOrderStatusBlock = ^{
//                    [weakSelf getDataToRefreshView];
//                };
                
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
            
            if (indexPath.section == 2) {
            
                if ([self.diagnoseModel.nowStatusCode isEqualToString:@"endBill"]) {
                    return;
                }
                
//                YHRepairCaseDetailController *vc =[YHRepairCaseDetailController new];
//                vc.billType = self.info[@"data"][@"billType"];
//                vc.index = 0;
//                vc.model = self.diagnoseModel;
//                __weak typeof(self)weakSelf = self;
//                vc.refreshOrderStatusBlock = ^{
//                    [weakSelf getDataToRefreshView];
//                };
        
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
            }
            
        }else{
            
            [self clickOrderDetailCell:tableView indexPath:indexPath];
        }
    }
}

- (void)clickOrderDetailCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"] && !self.isCheckComplete) {
        return;
    }
    
    TTZSYSModel *model = self.dataArr[indexPath.row];
    if ([model.code isEqualToString:@"oil"]) {
        return;
    }
    
    if (!self.isCheckComplete) {
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
        
        if ((section == 0 && ![self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) || ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"] && section == 1)) {
            // tableview头部View
            YHOrderDetailViewHeaderView *headerView = [[YHOrderDetailViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            if(([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])){
                headerView.isCar = YES;
            }
            self.headerView = headerView;
            __weak typeof(self) weakSelf = self;
            headerView.indicateBtnClickBlock = ^{
                [weakSelf jumpToCarPicture];
            };
            if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"] || [self.info[@"data"][@"billType"] isEqualToString:@"J004"] || [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"]) {
                
                [headerView hideBottomContentView:YES];
                [headerView modifyContentViewHeight:44];
            }else{
                
                CGFloat height = self.isCheckComplete ? (([self.info[@"data"][@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"]) && [self.info[@"data"][@"billType"] isEqualToString:@"A"]) ? 72 : 44 : 0;
                [headerView modifyContentViewHeight:height];
            }
            [self refreshTableViewHeader];
            return headerView;
            
        }else{
            
            if (([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) && section == 2) {
                
                UIView *bgView = [[UIView alloc] init];
                bgView.backgroundColor = tableView.backgroundColor;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 40)];
                view.clipsToBounds = YES;
                UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 40)];
                [view addSubview:boxV];
                [boxV setRounded:boxV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
                boxV.backgroundColor = [UIColor whiteColor];
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
//                if (!section) {
//                    titleLB.text = @"诊断结果";
//                }else{
                //titleLB.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
                    titleLB.text = @"维修方案";
//                    if(self.diagnoseModel.isTechOrg && [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"])
                    if(self.diagnoseModel.maintain_scheme.count < 2 && ([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"] || [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"] || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"])))

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
            
           return  [[UIView alloc] init];
        }
       
    }else{
        return  [[UIView alloc] init];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        if ((section == 0 && ![self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) || (section == 1 && [self.orderDetailInfo[@"billType"] isEqualToString:@"E003"])) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        
        UIView *footChildView = [[UIView alloc] init];
        footChildView.backgroundColor = [UIColor whiteColor];
        self.footChildView = footView;
        [footView addSubview:footChildView];
        [footChildView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@8);
            make.right.equalTo(footChildView.superview).offset(-8);
            make.height.equalTo(footChildView.superview);
            make.top.equalTo(@0);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [footChildView setRounded:footChildView.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
        });
            
        return footView;
        }else{
            
            if (section == 2 && ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) ) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
                UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 10)];
                boxV.backgroundColor = [UIColor whiteColor];
                [view addSubview:boxV];
                [boxV setRounded:boxV.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
                return view;
            }
            
           return [[UIView alloc] init];
        }
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
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
            if (section == 1) {
                
                if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"] || [self.info[@"data"][@"billType"] isEqualToString:@"J004"]) {
                    return 44.0;
                }else{
                    
                    CGFloat height = self.isCheckComplete ? 44 : 0;
                    return 44.0 + height;
                }
            }
            

            if (section && !([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"consulting"])) {
                return 10.0;
            }
            
            return 0;
        }
        
        if (section == 0) {
            
                if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"] || [self.info[@"data"][@"billType"] isEqualToString:@"J004"]  || [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"]) {
                    return 44.0;
                }else{
            
                    CGFloat height = self.isCheckComplete ? 44 : 0;
                    height = ([self.orderDetailInfo[@"billType"] isEqualToString:@"A"] && [self.info[@"data"][@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) || ([self.info[@"data"][@"nowStatusCode"] isEqualToString:@"endBill"] && [self.info[@"data"][@"billType"] isEqualToString:@"A"]) ? 72 : height;
                    return 44.0 + height;
                }
        }
        if (section == 1) {
            
            if([self.info[@"data"][@"billType"] isEqualToString:@"J004"]){
                
                if (self.isNo) {
                    return 10;
                }
        
                if(self.diagnoseModel.checkResultArr.makeResult.length == 0){
                   return 0;
                }
                
                return 10;
            }
            
            if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"]) {
                return 10;
            }
            if (!self.dataArr.count) {
                return 10;
            }
            
            if (self.diagnoseModel.checkResultArr.makeResult.length == 0) {
                return 0;
            }
            return 10;
        }
        
        if ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) {
            return 50;
        }
        
        return 10;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _askAboutTableview) {
        if (!self.askInfoArr.count) {
            return 0.0;
        }
        return 10.0;
    }
    if (tableView == _detailTableview) {
        
        if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
            if (section == 1) {
                return 20;
            }
            if (([self.didUsedCarStatus[@"status"] integerValue] == 1) && section == 0 && ([[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", self.info[@"data"][@"nowStatusCode"]] isEqualToString:@"consulting"])) {
                return 10;
            }

            return 0.0;
        }
        if (section == 0) {
            return 20;
        }
        if (([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"A"]) && section == 2) {
            return 20;
        }

        return 0.0;
    }else{
        return 0.0;
    }
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
    
    [self.lookUpBtn setRounded:self.lookUpBtn.bounds corners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:8.0];
    [self.checkCostBtn setRounded:self.lookUpBtn.bounds corners:UIRectCornerTopRight | UIRectCornerBottomRight radius:8.0];
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@?token=%@&billId=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, ([self.info[@"data"][@"billType"] isEqualToString:@"J002"] ? @"car_check_report.html" : @"car_report.html"), [YHTools getAccessToken], self.orderDetailInfo[@"id"], ((_functionKey == YHFunctionIdHistoryWorkOrder)? (@"&history=1") : (@""))];
    
    if ([self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
        || [self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
        urlStr = [NSString stringWithFormat:@"%@&order_state=%@", urlStr, self.orderDetailInfo[@"nextStatusCode"]];
    }
    
    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"E002"]
        ||[self.orderDetailInfo[@"billType"] isEqualToString:@"E003"]) {
        urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_report&status=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.orderDetailInfo[@"id"],self.orderDetailInfo[@"billType"]];

    }
    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J006"]) {
        urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=J006_report&status=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.orderDetailInfo[@"id"]];
        
    }
    
    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J008"]) {
        urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=J008_report&jnsAppStatus=ios#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.orderDetailInfo[@"id"]];
        
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

#pragma mark - 录入检测费 ----
- (void)jumpToInputCheckCostView{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHSettlementController *controller = [board instantiateViewControllerWithIdentifier:@"YHSettlementController"];
    controller.orderInfo = self.orderDetailInfo;
    NSDictionary *data = self.info[@"data"];
    controller.isChild = !data[@"childInfo"];
    controller.price = data[@"totalQuote"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)submitNewData{
    NSString *billId = self.orderDetailInfo[@"id"];
    NSString *bill_Type = [self.orderDetailInfo valueForKey:@"billType"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] copyUsedCarInitialSurvey:self.didUsedCarStatus[@"bill_id"] bill_id: self.orderDetailInfo[@"id"] success:^(NSDictionary *obj) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        ///
        [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",billId]];
        [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:billId didHandle:nil];
        self.isCheckComplete = YES;
        self.isUpLoad = YES;
        
        if ([bill_Type isEqualToString:@"A"] || [bill_Type isEqualToString:@"Y"] || [bill_Type isEqualToString:@"Y001"] || [bill_Type isEqualToString:@"Y002"]) {
            NSMutableDictionary *billStatus =  [self.orderDetailInfo mutableCopy];
            [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];
        }
        
        if ([bill_Type isEqualToString:@"J004"] || [self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [bill_Type isEqualToString:@"J001"] || [bill_Type isEqualToString:@"E002"] || [bill_Type isEqualToString:@"E003"]) {
            [self getDataToRefreshView];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSString *msg = [error.userInfo valueForKey:@"message"];
        [MBProgressHUD showError:msg];
    }];
}

//MARK 根据上牌时间获取评估价格
- (void)getValue:(NSString *)time{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    dic[@"token"] = [YHTools getAccessToken];
    dic[@"bill_id"] = @([self.orderDetailInfo[@"id"] intValue]);
    
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date= [formatter dateFromString:time];
    dic[@"car_license_time"] = time;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getPriceByCarLicenseTime:dic onComplete:^(NSDictionary *info) {
        
        if([info[@"code"]intValue] == 20000){
            
        self.price.enabled = [info[@"data"][@"edit_status"] boolValue];
        self.price.text = info[@"data"][@"car_inspection_evaluation_price"];
            
        }else{
            
         [MBProgressHUD showError:info[@"msg"]];
            
        }
        
    } onError:^(NSError *error) {
        
        NSString *msg = [error.userInfo valueForKey:@"message"];
        [MBProgressHUD showError:msg];
    }];
}

//FIXME:  -  提交数据
- (void)submitData{
    
    NSString *billId = self.orderDetailInfo[@"id"];
    NSString *bill_Type = [self.orderDetailInfo valueForKey:@"billType"];
    NSDictionary *info = self.info[@"data"][@"baseInfo"];
    NSMutableArray *resultArr = self.dataArr;
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
        resultArr = self.professionDataArr;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strType = [bill_Type isEqualToString:@"J007"] ? [bill_Type stringByAppendingString:@"J"] : bill_Type;

    [ZZSubmitDataService saveInitialSurveyForBillId:billId
                                           billType:strType
                                         submitData:resultArr
                                           baseInfo:info
                                            success:^{
                                                [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                [MBProgressHUD showError:@"提交成功"];
                                                
                                                ///
                                                [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",billId]];
                                                [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:billId didHandle:nil];
                                                self.isCheckComplete = YES;
                                                self.isUpLoad = YES;
                                    
//                                                if([bill_Type isEqualToString:@"Y002"]){
//                                                    self.isCheckComplete = NO;
//                                                    self.isUpLoad = NO;
//                                                    [[YHCarPhotoService new] newWorkOrderDetailForBillId:self.orderDetailInfo[@"id"]
//                                                                                                 success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {
//                                                                                                     
//                                            
//                                                                                                     YTDepthController *vc =[YTDepthController new];
//                                                                                                     vc.orderType = @"Y002";
//                                                                                                     vc.order_id = self.orderDetailInfo[@"id"];
//                                                                                                     vc.reportModel = [YHReportModel mj_objectWithKeyValues:[info valueForKey:@"data"]];
//                                                                                                     [self.navigationController pushViewController:vc animated:YES];
//                                                                                                     
//                                                                                                 }
//                                                                                                 failure:^(NSError *error) {
//                                                                                                     
//                                                                                                     [MBProgressHUD hideHUDForView:self.view];
//                                                                                                 }];
//                                                    
//                                                    return;
//                                                    
//                                                }
                                                
                                                if ([bill_Type isEqualToString:@"Y"] || [bill_Type isEqualToString:@"Y001"] || [bill_Type isEqualToString:@"Y002"]) {
                                                    NSMutableDictionary *billStatus =  [self.orderDetailInfo mutableCopy];
                                                    [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];
                                                }
                                                
                                                
                                                if([self.info[@"data"][@"billType"] isEqualToString:@"J007"]){
                                                    [self getItemList];
                                                     self.diagnoseModel.m_item_edit_status = @"0";
                                                }
                                                
                                                if ([bill_Type isEqualToString:@"J004"] || [self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J008"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"] || [bill_Type isEqualToString:@"J001"] || [bill_Type isEqualToString:@"E002"] || [bill_Type isEqualToString:@"E003"] || [bill_Type isEqualToString:@"J007"] || [bill_Type isEqualToString:@"A"]) {
                                                    [self getDataToRefreshView];
                                                    
                                                }
                                                
                                                
                                            }
                                            failure:^(NSError * _Nonnull error) {
                                                
                                                [MBProgressHUD hideHUDForView:self.view];
                                                NSString *msg = [error.userInfo valueForKey:@"message"];
                                                [MBProgressHUD showError:msg];

                                            }];
    
    return;
    //判断是否是有代录权限
    BOOL saveReplaceDetectiveInitialSurvey = YES;//代录
    NSString *billType = [self.orderDetailInfo valueForKey:@"billType"];

    if(saveReplaceDetectiveInitialSurvey){
        
        [[YHCarPhotoService new] saveReplaceDetectiveInitialSurvey:self.orderDetailInfo[@"id"]
                                                             value:[self submitProjectVal]
                                                              info:self.info[@"data"][@"baseInfo"]
                                                           success:^{
                                                               [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                               [MBProgressHUD showError:@"提交成功"];
                                                               
                                                               [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",self.orderDetailInfo[@"id"]]];
                                                               //[[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:nil];
                                                               [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:self.orderDetailInfo[@"id"] didHandle:nil];
                                                               self.isCheckComplete = YES;
                                                               self.isUpLoad = YES;
                                                               
                                                               if ([billType isEqualToString:@"J003"]) {
                                                                   [self getDataToRefreshView];
                                                               }
                                                               
                                                              if ([billType isEqualToString:@"A"] || [billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"]) {
                                                                  NSMutableDictionary *billStatus =  [self.orderDetailInfo mutableCopy];
                                                                   [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];
                                                               }
                                                               
                                                           }
                                                           failure:^(NSError *error) {
                                                               [MBProgressHUD hideHUDForView:self.view];
                                                               NSString *msg = [error.userInfo valueForKey:@"message"];
                                                               [MBProgressHUD showError:msg];
                                                           }];
        return;
    }
    
    if ([billType isEqualToString:@"A"] || [billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"]) {
        [[YHCarPhotoService new] saveYAY001InitialSurveyForBillId:self.orderDetailInfo[@"id"]
                                                            value:[self submitProjectVal]
                                                             info:self.info[@"data"][@"baseInfo"]
                                                          success:^{
                                                              [MBProgressHUD hideHUDForView:self.view];
                                                              [MBProgressHUD showError:@"提交成功"];
                                                              self.isCheckComplete = YES;
                                                              NSMutableDictionary *billStatus =  [self.orderDetailInfo mutableCopy];
                                                              [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];

                                                          }
                                                          failure:^(NSError *error) {
                                                              [MBProgressHUD hideHUDForView:self.view];
                                                              [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                          }];
        return;
    }
    
    [[YHCarPhotoService new] saveInitialSurveyForBillId:self.orderDetailInfo[@"id"]
                                                  value:[self submitProjectVal]
                                                   info:self.info[@"data"][@"baseInfo"]
                                                 isJ002:([self.info[@"data"][@"billType"] isEqualToString:@"J002"] || [self.info[@"data"][@"billType"] isEqualToString:@"J006"])
                                                success:^{
                                                    [MBProgressHUD hideHUDForView:self.view];
                                                    [MBProgressHUD showError:@"提交成功"];
                                                    
                                                    if ([billType isEqualToString:@"J003"]) {
                                                        [self getDataToRefreshView];
                                                    }
                                                    [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",self.orderDetailInfo[@"id"]]];
                                                    //[[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:nil];
                                                    [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:self.orderDetailInfo[@"id"] didHandle:nil];
                                                    
                                                    self.isCheckComplete = YES;
                                                }
                                                failure:^(NSError *error) {
                                                    [MBProgressHUD hideHUDForView:self.view];
                                                    [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                }];
}



- (void)getItemList{//获取诊断列表
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        
        [[YHCarPhotoService new] getJ005ItemBillId:self.orderDetailInfo[@"id"] success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *baseInfo) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            TTZCheckViewController *vc = [TTZCheckViewController new];
            models.firstObject.className = @"AI尾气诊断";
            models.firstObject.list.firstObject.projectName = @"AI尾气诊断";
            vc.sysModels = models;
            vc.billId = self.orderDetailInfo[@"id"];
            vc.billType = @"J007";
            vc.title = @"AI尾气诊断";
            vc.isFromAI = YES;
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
            
        }];
}


- (NSMutableArray *)submitProjectVal{
    NSMutableArray *projectVal = [NSMutableArray array];
    
    NSMutableArray *resultArr = self.dataArr;
    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
        resultArr = self.professionDataArr;
    }
    
    [resultArr enumerateObjectsUsingBlock:^(TTZSYSModel *  sysModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel *  gObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel *  cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //单选 多选
                if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                    
                    NSArray <TTZValueModel *>*selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    NSString *projectValString = [[selects valueForKeyPath:@"value"] componentsJoinedByString:@","];
                    
                    NSArray <TTZChildModel *>*childList = selects.firstObject.childList;
                    if (childList) {
                        NSArray <TTZChildModel *>*selectChild = [childList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                        projectValString = [[selectChild valueForKeyPath:@"value"] componentsJoinedByString:@","];
                        NSLog(@"%s", __func__);
                    }
                    
                    if(selects.count){
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":[[selects valueForKeyPath:@"name"] componentsJoinedByString:@","],@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                //输入文本类型
                }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                    //if(!IsEmptyStr(cellObj.intervalRange.interval)) {
                    if(!IsEmptyStr(cellObj.projectVal) || !IsEmptyStr(cellObj.intervalRange.interval)) {
                        
                        NSString *projectValString = IsEmptyStr(cellObj.projectVal)? cellObj.intervalRange.interval : cellObj.projectVal;
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                 //故障码类型
                }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
                    //if(cellObj.codes.count) {
                    if(!IsEmptyStr(cellObj.projectVal)) {
                        
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":cellObj.projectVal}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                 // elecCodeForm 联动故障码
                }else if ([cellObj.intervalType isEqualToString:@"elecCodeForm"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                //  表单
                }else if ([cellObj.intervalType isEqualToString:@"form"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                //  气缸
                }else if ([cellObj.intervalType isEqualToString:@"sameIncrease"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                }
            }];
        }];
    }];
    return projectVal;
}


@end
