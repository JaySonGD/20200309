//
//  YTRepairViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTRepairViewController.h"

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

#import "YTPlanCell.h"
#import "YTDiagnoseCell.h"
#import "UIView+add.h"
#import "YTSearchController.h"
#import "YTPayViewController.h"
#import "YTPlanModel.h"

#import "WXPay.h"

#import "YHRepairCaseDetailController.h"

#import "ZZAlertViewController.h"


extern NSString *const notificationOrderListChange;


@interface YTRepairViewController ()
<UITableViewDelegate,UITableViewDataSource>
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

@property (nonatomic, strong) YTDiagnoseModel *diagnoseModel;

@end

@implementation YTRepairViewController

//- (instancetype)init{
//
//    if (self = [super init]) {
//        [self initOrderDetailUI];
//        //[self getDataToRefreshView];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
//    [self initOrderDetailUI];
//    [self loadDate];
}

//- (void)setOrderDetailInfo:(NSDictionary *)orderDetailInfo{
//    _orderDetailInfo = orderDetailInfo;
////    [self loadDate];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self loadData];

    if(_detailTableview) [_detailTableview reloadData];
    
//    if (![self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//        [self isCheckedForData];
//    }
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
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.hidden = YES;
    
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


#pragma mark - 检测方案tableview ------
- (UITableView *)detailTableview{
    
    if (!_detailTableview) {
        
        // tableview初始化
        UITableView *detailTableview = [self getNeedTableView];
        _detailTableview = detailTableview;
        
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTDiagnoseCell" bundle:nil] forCellReuseIdentifier:@"YTDiagnoseCell"];
        [_detailTableview registerNib:[UINib nibWithNibName:@"YTPlanCell" bundle:nil] forCellReuseIdentifier:@"YTPlanCell"];

        // tableView底部控件
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
//        UIView *footChildView = [[UIView alloc] init];
//        footChildView.backgroundColor = [UIColor whiteColor];
//        [footView addSubview:footChildView];
//        self.footChildView = footChildView;
//        detailTableview.tableFooterView = footView;
//        [footChildView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@8);
//            make.right.equalTo(footChildView.superview).offset(-8);
//            make.height.equalTo(footChildView.superview);
//            make.top.equalTo(@0);
//        }];
//
        // tableview头部View
//        YHOrderDetailViewHeaderView *headerView = [[YHOrderDetailViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 88)];
//        self.headerView = headerView;
//        __weak typeof(self) weakSelf = self;
//        headerView.indicateBtnClickBlock = ^{
//            [weakSelf jumpToCarPicture];
//        };
//        detailTableview.tableHeaderView = headerView;
        
    }
    return _detailTableview;
}

//- (void)setHeaderView:(YHOrderDetailViewHeaderView *)headerView{
//    _headerView = headerView;
//    if (headerView == nil) {
//        return;
//    }
//    //    if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J002"]) {
//    //        [headerView setTitleLableTextContent:@"小虎安检"];
//    //    }else if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J001"]) {
//    //        [headerView setTitleLableTextContent:@"全车检测"];
//    //    }
//
//    [headerView setTitleLableTextContent:self.orderDetailInfo[@"billTypeName"]];
//
//}


//- (BOOL)isCheckedForData{
//
//    BOOL isChecked = NO;
//    for (int i = 0; i<self.dataArr.count; i++) {
//        TTZSYSModel *model = self.dataArr[i];
//        if (model.progress > 0) {
//            isChecked = YES;
//        }
//    }
//    self.bottomBtn.backgroundColor = isChecked ? YHNaviColor :[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
//    self.bottomBtn.enabled = isChecked;
//    return isChecked;
//}

//- (void)getCheckCarVal:(dispatch_group_t)group{
//    dispatch_group_enter(group);
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:self.orderDetailInfo[@"id"] isHistory:NO onComplete:^(NSDictionary *info) {
//
//        int code = [info[@"code"] intValue];
//        //        NSString *msg = info[@"msg"];
//        if (code == 20000) {
//
//            NSDictionary *data = info[@"data"];
//            NSDictionary *checkCarVal = data[@"checkCarVal"]; // 车检数据
//            self.checkCarVal = checkCarVal;
//
//        }else{
//
//            //[MBProgressHUD showError:msg toView:self.view];
//        }
//        dispatch_group_leave(group);
//    } onError:^(NSError *error) {
//
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        dispatch_group_leave(group);
//    }];
//
//}

//- (void)initData:(dispatch_group_t)group{
- (void)loadData{
    
    NSString *billId = self.orderDetailInfo[@"id"];
    if(!self.diagnoseModel) [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] newW001WorkOrderDetailForBillId:billId success:^(YTDiagnoseModel *model, NSDictionary *obj) {
        
        /**close:关闭;进行中:underway;complete:工单完成  已支付(工单已完成)页面：billStatus 等于 complete*/
        //@property (nonatomic, copy) NSString *billStatus;
        
        /**
         编辑方案和派工页面：nextStatusCode 等于 initialSurveyCompletion
         方案选择页面：nextStatusCode 等于 affirmMode
         方案待支付页面：nextStatusCode 等于 storeBuyMaintainScheme
         点击已完工页面：nextStatusCode 等于 affirmComplete
         */
        //@property (nonatomic, copy) NSString *nextStatusCode;

//        model.isTechOrg = NO;
//        model.nextStatusCode = @"storeBuyMaintainScheme";
#pragma mark - 调试数据
        if (model.isTechOrg && [model.nextStatusCode isEqualToString:@"initialSurveyCompletion"]) {
             YTDiagnoseModel *cacheModel = [YTDiagnoseModel findWhere:[NSString stringWithFormat:@"where billId ='%@' AND  nextStatusCode ='%@' AND isTechOrg = 1",model.billId,model.nextStatusCode]].firstObject;
            if (cacheModel) {
                model.maintain_scheme = cacheModel.maintain_scheme;
                model.checkResultArr = cacheModel.checkResultArr;
            }
        }
        ////
        [MBProgressHUD hideHUDForView:self.view];

        BOOL isFirst = (self.diagnoseModel)? NO : YES;
        
        self.baseInfoArr = [self getBaseInfo:obj[@"data"][@"baseInfo"]];
        self.askInfoArr = [self getAskInfoArr:obj];
        self.diagnoseModel = model;
        self.info  = obj;
        
        if (isFirst) {
            [self initOrderDetailUI];
        }

        [self refreshView];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
    
    return;
//    dispatch_group_enter(group);

    //[MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] newWorkOrderDetailForBillId:self.orderDetailInfo[@"id"]
                                                 success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {

                                                     //[MBProgressHUD hideHUDForView:self.view];
                                                     self.info = info;
                                                     if(models.count){
                                                         self.dataArr = models;
                                                     }
                                                     //dispatch_group_leave(group);
                                                 }
                                                 failure:^(NSError *error) {
//                                                     dispatch_group_leave(group);
                                                     //[MBProgressHUD hideHUDForView:self.view];
                                                 }];


}

- (void)initUI{
    
    self.title = @"工单详情";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addNavigationBarBtn];
}

- (void)addCloseOrderBtn{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"关闭工单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:YHNagavitionBarTextColor forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 20, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(closeToOrder) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    
//    self.diagnoseModel.isTechOrg = NO;
//    self.diagnoseModel.nextStatusCode  = @"initialSurveyCompletion" ;//isEqualToString:@"initialSurveyCompletion"]
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    // 顶部菜单栏
    YHOrderDetailTopContainView *topContainView = [[YHOrderDetailTopContainView alloc] initWithFrame:CGRectMake(0, topMargin, self.view.frame.size.width, 44)];
    self.topContainView = topContainView;
    self.topContainView.hidden = NO;
    topContainView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    topContainView.topButtonClickedBlock = ^(UIButton *btn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([btn.currentTitle isEqualToString:@"检测方案"]) {
                [weakSelf showCheckCaseView];
            }
            
            if ([btn.currentTitle isEqualToString:@"基本信息"]) {
                [weakSelf showbaseInfoView];
            }
            
            if ([btn.currentTitle isEqualToString:@"问询信息"]) {
                [weakSelf showAskAboutView];
            }
        });
    };

//    topContainView.titleArr = (!self.diagnoseModel.isTechOrg && (
//                                                                 [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"] || [self.diagnoseModel.billStatus isEqualToString:@"close"] || [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurvey"]))? @[@"基本信息",@"问询信息"]:@[@"检测方案",@"基本信息",@"问询信息"];
    
//    topContainView.titleArr = (!self.diagnoseModel.isTechOrg && (
//                                                                 [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"] || [self.diagnoseModel.billStatus isEqualToString:@"close"] || [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurvey"]))? @[@"基本信息",@"问询信息"]:@[@"检测方案",@"基本信息",@"问询信息"];
    
    topContainView.titleArr = ((!self.diagnoseModel.isTechOrg || [self.diagnoseModel.billStatus isEqualToString:@"close"])  && (self.diagnoseModel.maintain_scheme.count == 0) && IsEmptyStr(self.diagnoseModel.checkResultArr.makeResult))? @[@"基本信息",@"问询信息"]:@[@"检测方案",@"基本信息",@"问询信息"];
    
    [self.view addSubview:topContainView];
    

    UILabel *errolL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topContainView.frame) + 5, self.view.frame.size.width, 0)];
    //errolL.text = @"开始检测后不能修改项目";
    errolL.font = [UIFont systemFontOfSize:16];
    errolL.textColor = [UIColor whiteColor];
    errolL.textAlignment = NSTextAlignmentCenter;
    errolL.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.errolL = errolL;
    [self.view addSubview:errolL];

    // 底部按钮
    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.bottomBtn = bottomBtn;
    self.bottomBtn.hidden = YES;
    [self.view addSubview:bottomBtn];
    bottomBtn.backgroundColor = YHNaviColor;//[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    //[bottomBtn setTitle:@"推送方案" forState:UIControlStateNormal];
    [bottomBtn setTitle:@"生成报告" forState:UIControlStateNormal];

    bottomBtn.layer.cornerRadius = 5.0;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomClickEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(bottomBtn.superview).offset(-10);
        make.bottom.equalTo(bottomBtn.superview).offset(bottomMargin);
        make.height.equalTo(@44);
    }];
//    // 查看检测报告
//    UIButton *lookUpBtn = [[UIButton alloc] init];
//    [lookUpBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
//    lookUpBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    self.lookUpBtn = lookUpBtn;
//    self.lookUpBtn.hidden = NO;
//    [self.view addSubview:lookUpBtn];
//    lookUpBtn.backgroundColor = YHNaviColor;
//    [lookUpBtn addTarget:self action:@selector(newWholeCarReport) forControlEvents:UIControlEventTouchUpInside];
//    [lookUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@10);
//        make.bottom.equalTo(lookUpBtn.superview).offset(bottomMargin);
//        make.height.equalTo(@40);
//        make.width.equalTo(bottomBtn.mas_width).multipliedBy(0.5);
//    }];
//
//    UIView *seprateview = [[UIView alloc] init];
//    self.seprateview = seprateview;
//    seprateview.hidden = NO;
//    seprateview.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:seprateview];
//    [seprateview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@1);
//        make.top.equalTo(lookUpBtn.mas_top);
//        make.bottom.equalTo(lookUpBtn.mas_bottom);
//        make.left.equalTo(lookUpBtn.mas_right).offset(1);
//    }];
//
//    // 录入检测费
//    UIButton *checkCostBtn = [[UIButton alloc] init];
//    [checkCostBtn setTitle:@"录入检测费" forState:UIControlStateNormal];
//    checkCostBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    self.checkCostBtn = checkCostBtn;
//    self.checkCostBtn.hidden = NO;
//    [self.view addSubview:checkCostBtn];
//    checkCostBtn.backgroundColor = YHNaviColor;
//    [checkCostBtn addTarget:self action:@selector(jumpToInputCheckCostView) forControlEvents:UIControlEventTouchUpInside];
//    [checkCostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(seprateview.mas_right);
//        make.width.equalTo(lookUpBtn);
//        make.bottom.equalTo(lookUpBtn);
//        make.height.equalTo(lookUpBtn);
//    }];
//
//    [self setBottomBtnStatus];
    
}

- (void)refreshView{
    [self.detailTableview reloadData];
    
    self.errolL.text = self.diagnoseModel.billStatusMsg;
    self.errolL.height = IsEmptyStr(self.diagnoseModel.billStatusMsg)? 0 : 46;
    
    [self setBottomBtnStatus];
    [self setCloseBtnStatus];
    
    _detailTableview.contentInset = UIEdgeInsetsMake(0, 0, (self.bottomBtn.isHidden)?0 : 44, 0);
    
}


#pragma mark - 检测方案展示 ---
- (void)showCheckCaseView{

    self.detailTableview.hidden = NO;
    self.baseInfoTableview.hidden = YES;
    self.askAboutTableview.hidden = YES;
    //self.bottomBtn.hidden = NO;
    [self setBottomBtnStatus];

//    if (!self.dataArr.count && !self.detailTableview.hidden) {
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
//- (void)jumpToCarPicture{
//    __weak typeof(self) weakSelf = self;
//    YHCheckCarAllPictureViewController *pictureVc = [[YHCheckCarAllPictureViewController alloc] init];
//    NSString *billId = self.orderDetailInfo[@"id"];
//    NSArray *imgs =  self.info[@"data"][@"initialSurveyImg"];;//self.ttzData;
//    BOOL allowUpload = self.isUpLoad;
//
//    TTZSurveyModel *model = [TTZSurveyModel new];
//    model.code = @"car_appearance";
//    model.billId = billId;
//
//    if(allowUpload){//允许上传
//
//        if (imgs.count) {//已经成功上传了一些图片
//
//            model.dbImages = [NSMutableArray array];
//            if (imgs.count<5) {//少于五张
//
//                // 现添加远程资源
//                for (NSInteger i = 0; i < imgs.count; i ++) {
//                    TTZDBModel *db = [TTZDBModel new];
//                    db.fileId = imgs[i];
//                    [model.dbImages addObject:db];
//                }
//                // 添加本地的资源
//                //NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",model.billId,model.code]];
//                NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",model.billId,model.code]];
//
//                NSInteger count = imgs.count + localImages.count;
//                count = (count > 5)? 5 : count; //最多5个
//
//                for (NSInteger i = imgs.count; i < count; i ++) {
//                    TTZDBModel *db = localImages[i - imgs.count];
//                    [model.dbImages addObject:db];
//                }
//
//                // 加上本地缓存还小于5张图片
//                if (count<5) {
//                    TTZDBModel *defaultDB = [TTZDBModel new];
//                    defaultDB.image = [UIImage imageNamed:@"otherAdd"];
//                    [model.dbImages addObject:defaultDB];
//                }
//
//            }else{//五张全部上传成功
//                for (NSInteger i = 0; i < 5; i ++) {
//                    TTZDBModel *db = [TTZDBModel new];
//                    db.fileId = imgs[i];
//                    [model.dbImages addObject:db];
//                }
//            }
//        }
//
//    }else{//一进到了预览大图状态
//
//        // 防止出现bug
//        model.dbImages = [NSMutableArray array];
//        // 有网络图片
//        for (NSInteger i = 0; i < imgs.count; i ++) {
//            TTZDBModel *db = [TTZDBModel new];
//            db.fileId = imgs[i];
//            [model.dbImages addObject:db];
//        }
//    }
//
//    pictureVc.model = model;
//    pictureVc.isAllowUpLoad =  allowUpload;
//    pictureVc.callBackBlock = ^{
//        [weakSelf getDataToRefreshView];
//    };
//    [self.navigationController pushViewController:pictureVc animated:YES];
//}

#pragma mark --isCheckComplete --------
//- (void)setIsCheckComplete:(BOOL)isCheckComplete{
//    _isCheckComplete = isCheckComplete;
//
//    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//
//        YHOrderDetailViewHeaderView *headerView = [[YHOrderDetailViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
//        [headerView hideBottomContentView:YES];
//        __weak typeof(self)weakSelf = self;
//        headerView.indicateBtnClickBlock = ^{
//
//            [weakSelf jumpToCarPicture];
//        };
//        self.headerView = headerView;
//        [headerView modifyContentViewHeight:44];
//        self.detailTableview.tableHeaderView = headerView;
//    }else{
//
//        CGFloat height = isCheckComplete ? 44 : 0;
//        YHOrderDetailViewHeaderView *headerView = [[YHOrderDetailViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 44 + height)];
//
//        __weak typeof(self)weakSelf = self;
//        headerView.indicateBtnClickBlock = ^{
//
//            [weakSelf jumpToCarPicture];
//        };
//        self.headerView = headerView;
//        [headerView modifyContentViewHeight:height];
//        self.detailTableview.tableHeaderView = headerView;
//    }
//
//    [self setBottomBtnStatus];
//}

- (void)setCloseBtnStatus{
    // 关闭工单
    if (self.diagnoseModel.isHistoryOrder || !self.diagnoseModel.isTechOrg) {
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

#pragma mark - 设置底部按钮的状态 ----
- (void)setBottomBtnStatus{
    if (self.diagnoseModel.isTechOrg) {
        
        if ([self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"]) {
            //[self.bottomBtn setTitle:@"推送方案" forState:UIControlStateNormal];
            [self.bottomBtn setTitle:@"生成报告" forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
        }else if ([self.diagnoseModel.nextStatusCode isEqualToString:@"affirmComplete"]){
            [self.bottomBtn setTitle:@"已完工" forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
            
        }else{
            [self.bottomBtn setTitle:@"" forState:UIControlStateNormal];
            self.bottomBtn.hidden = YES;
        }
        
    }else{
        //方案待支付页面：nowStatusCode 等于 affirmMode && nextStatusCode 等于 空字符串
        if ([self.diagnoseModel.nowStatusCode isEqualToString:@"affirmMode"] && IsEmptyStr(self.diagnoseModel.nextStatusCode)) {
        //if ([self.diagnoseModel.nextStatusCode isEqualToString:@"storeBuyMaintainScheme"]) {
            [self.bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
        }else{
            [self.bottomBtn setTitle:@"" forState:UIControlStateNormal];
            self.bottomBtn.hidden = YES;
        }
    }

    return;
//    // 历史工单
//    if (self.isHistoryOrder) {
//
//        NSDictionary *data = self.info[@"data"];
//        NSDictionary *reportData = data[@"reportData"];
//        self.bottomBtn.hidden = (reportData.count == 0 || !reportData) ? YES : NO;
//        self.lookUpBtn.hidden = YES;
//        self.checkCostBtn.hidden = YES;
//        self.seprateview.hidden = YES;
//        [self.bottomBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
//        self.bottomBtn.backgroundColor = YHNaviColor;
//        self.bottomBtn.enabled = YES;
//
//        return;
//    }
//
//    if (self.isPushReport) {
//
//        NSDictionary *data = self.info[@"data"];
//        NSString *handleType = data[@"handleType"];
//
//        // 已推送报告 ->有权限
//        if ([handleType isEqualToString:@"handle"]) {
//
//            self.lookUpBtn.hidden = NO;
//            self.checkCostBtn.hidden = NO;
//            self.bottomBtn.hidden = YES;
//            self.seprateview.hidden = NO;
//        }
//
//        // 无权限
//        if ([handleType isEqualToString:@"detail"]) {
//
//            self.lookUpBtn.hidden = YES;
//            self.checkCostBtn.hidden = YES;
//            self.bottomBtn.hidden = NO;
//            self.seprateview.hidden = YES;
//        }
//
//        [self.bottomBtn setTitle:@"查看检测报告" forState:UIControlStateNormal];
//
//    }else{
//
//        self.bottomBtn.hidden = NO;
//        self.lookUpBtn.hidden = YES;
//        self.checkCostBtn.hidden = YES;
//        self.seprateview.hidden = YES;
//
//        if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//
//            CGRect headerFrame = self.errolL.frame;
//            headerFrame.size.height = (!self.detailTableview.hidden && !self.isCheckComplete && self.isClickedProfession) ? 46 : 0;
//            self.errolL.frame = headerFrame;
//
//            if (self.isCheckComplete) {
//                [self.bottomBtn setTitle:@"完善报告" forState:UIControlStateNormal];
//                self.bottomBtn.backgroundColor = YHNaviColor;
//                self.bottomBtn.enabled = YES;
//
//            }else{
//
//                if([self.info[@"data"][@"detectionStatus"] isEqualToString:@"0"]){
//
//                    [self.bottomBtn setTitle:@"开始检测" forState:UIControlStateNormal];
//                    if ([self isExistSelectedElement]) {
//                        self.bottomBtn.backgroundColor = YHNaviColor;
//                        self.bottomBtn.enabled = YES;
//                    }else{
//                        self.bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
//                        self.bottomBtn.enabled = NO;
//                    }
//
//                }else{
//
//                    [self.bottomBtn setTitle:@"继续检测" forState:UIControlStateNormal];
//                    self.bottomBtn.backgroundColor = YHNaviColor;
//                    self.bottomBtn.enabled = YES;
//                }
//            }
//
//        }else{
//
//            // 问询和初检
//            if (self.isCheckComplete) {
//
//                self.bottomBtn.backgroundColor = YHNaviColor;
//                self.bottomBtn.enabled = YES;
//                [self.bottomBtn setTitle:@"完善报告" forState:UIControlStateNormal];
//
//            }else{
//                [self.bottomBtn setTitle:@"提交检测数据" forState:UIControlStateNormal];
//
//                self.bottomBtn.backgroundColor = [self isCheckedForData] ? YHNaviColor :[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
//                self.bottomBtn.enabled = [self isCheckedForData];
//            }
//        }
//    }
}


- (void)WXPay{
    WeakSelf
    
    NSString *billId = self.diagnoseModel.billId;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] solutionPay:billId price:nil success:^(NSDictionary *info) {
        if (!info) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"不需要购买！"];
            return ;
        }
        
        [[WXPay sharedWXPay] payByParameter:info success:^{
            
            [[YHCarPhotoService new] solutionPay:billId price:nil success:^(NSDictionary *info) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"支付成功！"];
#pragma mark - 支付成功，跳转列表
                [self loadData];

            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"支付失败！"];
            }];
            
        } failure:^{
#pragma mark - 微信App支付失败，跳转拆分支付
            YTPayViewController *vc = [YTPayViewController new];
            vc.diagnoseModel = weakSelf.diagnoseModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}
#pragma mark - 完工
- (void)saveAffirm{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] saveAffirmComplete:self.diagnoseModel.billId success:^(NSDictionary *obj) {
        
        [MBProgressHUD hideHUDForView:self.view];

        self.diagnoseModel.nowStatusCode = [obj valueForKey:@"nowStatusCode"];
        self.diagnoseModel.nextStatusCode = [obj valueForKey:@"nextStatusCode"];
        self.diagnoseModel.handleType = [obj valueForKey:@"handleType"];

        [self refreshView];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
    
}

- (void)addPlan{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *localPlans = [self.diagnoseModel.maintain_scheme filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_sys < 1"]];
        NSArray *localNames = [localPlans valueForKey:@"name"];
        
        NSInteger sysC = self.diagnoseModel.maintain_scheme.count - localPlans.count;
        NSInteger i = sysC + 1;
        while ([localNames containsObject:[NSString stringWithFormat:@"解决方案%ld",i]]) {
            i++;
        }
        YTPlanModel *localPlan = [YTPlanModel new];
        localPlan.name = [NSString stringWithFormat:@"解决方案%ld",i];
        localPlan.total_price = @"0.00";
        [self.diagnoseModel.maintain_scheme addObject:localPlan];
        [self.diagnoseModel saveDiagnose];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            YHRepairCaseDetailController *vc =[YHRepairCaseDetailController new];
            vc.index = [self.diagnoseModel.maintain_scheme indexOfObject:localPlan];
            vc.model = self.diagnoseModel;
            [self.navigationController pushViewController:vc animated:YES];
            [self refreshView];
        });
    });
}

- (void)pushPlan{
//    self.bottomBtn.YH_normalTitle = @"推送方案";
//    self.bottomBtn.YH_loadStatusTitle = @"方案推送中...";
    self.bottomBtn.YH_normalTitle = @"生成报告";
    self.bottomBtn.YH_loadStatusTitle = @"报告生成中...";

    
    
    [self.bottomBtn YH_showStartLoadStatus];
    [YHRepairCaseDetailController submitRepairCaseModel:self.diagnoseModel completeBlock:^(BOOL isSuccess, NSString *message) {
        [self.bottomBtn YH_showEndLoadStatus];
        if(!isSuccess){
            [MBProgressHUD showError:message];
            return ;
        }
        
#pragma mark - 推送成功回到列表
        [self loadData];
        
        [YTDiagnoseModel deleteWhere:[NSString stringWithFormat:@"where billId ='%@'",self.diagnoseModel.billId]];

//        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if([obj isKindOfClass:NSClassFromString(@"YHOrderListController")]) [self.navigationController popToViewController:obj animated:YES];
//        }];
        
    }];

}

#pragma mark - 底部按钮点击 -------
- (void)bottomClickEvent{
    
    if (self.diagnoseModel.isTechOrg) {
        
        if ([self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"]) {
#pragma mark - 推送方案
            [self pushPlan];
        }else if ([self.diagnoseModel.nextStatusCode isEqualToString:@"affirmComplete"]){
#pragma mark - 已完工
            [self saveAffirm];
            
        }else{}
        
        
    }else{
        //方案待支付页面：nowStatusCode 等于 affirmMode && nextStatusCode 等于 空字符串

//        if ([self.diagnoseModel.nextStatusCode isEqualToString:@"storeBuyMaintainScheme"]) {
        if ([self.diagnoseModel.nowStatusCode isEqualToString:@"affirmMode"] && IsEmptyStr(self.diagnoseModel.nextStatusCode)) {

#pragma mark - 去支付
            [self WXPay];

        }else{}
    }

    return;
    [YTDiagnoseModel setDebug:YES];
    NSArray *list = [YTDiagnoseModel findAll];
    [self.navigationController pushViewController:[YTPayViewController new] animated:YES];
    
    YTDiagnoseModel *model = [YTDiagnoseModel new];
    model.billId = [NSString stringWithFormat:@"%d",rand()];
    model.isTechOrg = YES;
    //model.state = 2;
    
    
    YTPlanModel *p = [YTPlanModel new];
    p.Id = @"333";
    
    YTPartModel *m = [YTPartModel new];
    m.part_name = @"";
    p.parts = [NSMutableArray arrayWithObject:m];
    
    model.maintain_scheme = [NSMutableArray arrayWithObject:p];
    
    [model save];
    
    NSLog(@"%s", __func__);
    return;
//    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//
//        if (self.isCheckComplete) {
//            [self jumpReportForJ003_order];
//        }else{
//            [self professionalExamine];
//        }
//    }else{
//
//        if (self.isCheckComplete) {
//            // 查看检测报告
//            [self newWholeCarReport];
//        }else{
//            // 提交检测数据
//            [self submitData];
//        }
//    }
}
#pragma mark - 专业检测 ----
//- (void)professionalExamine{
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager] professionalExamine:[YHTools getAccessToken] billId:[self.orderDetailInfo[@"id"] intValue] sysIds:self.sysIds onComplete:^(NSDictionary *info) {
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
//        if ([code isEqualToString:@"20000"]) {
//
//            self.isClickedProfession = YES;
//
//            NSDictionary *data = info[@"data"];
//            NSArray *initialSurveyItem = data[@"initialSurveyItem"];
//            // 下一状态: 1-初检 2-编辑报告
//            //            if ([data[@"nexStatus"] isEqualToString:@"1"]) {
//
//
//            if ([self.sysIds isEqualToString:self.oilId]) {
//                [self getDataToRefreshView];
//                return ;
//            }
//
//            NSMutableArray *newInitialSurveyItem = [NSMutableArray array];
//            for (int i = 0; i<initialSurveyItem.count; i++) {
//                NSDictionary *elementItem = initialSurveyItem[i];
//                NSArray *list = elementItem[@"list"];
//                if ([elementItem[@"checkedStatus"] isEqualToString:@"1"] && list.count > 0) {
//                    [newInitialSurveyItem addObject:elementItem];
//                }
//            }
//
//            [self.bottomBtn setTitle:@"继续监测" forState:UIControlStateNormal];
//
//            TTZSYSModel *model = [TTZSYSModel new];
//            //                model.Id = @"";
//            model.className = @"专项";
//            //                model.saveType = @"";
//            model.list = [TTZGroundModel mj_objectArrayWithKeyValuesArray:newInitialSurveyItem];
//            self.professionDataArr = [NSMutableArray arrayWithObject:model];
//            // 没有检测完成
//            __weak typeof(self) weakSelf = self;
//            TTZCheckViewController *vc = [TTZCheckViewController new];
//            vc.detailNewController = self;
//            vc.billType = [self.orderDetailInfo valueForKey:@"billType"];
//            vc.sysModels = self.professionDataArr;
//            vc.orderInfo = self.info[@"data"];
//            vc.baseInfo = self.info[@"data"][@"baseInfo"];
//            vc.billId = self.orderDetailInfo[@"id"];
//            vc.is_circuitry = [self.info[@"data"][@"is_circuitry"] boolValue];
//            vc.callBackBlock = ^{
//                [weakSelf getDataToRefreshView];
//            };
//
//            vc.backBlock = ^{
//                [weakSelf submitData];
//            };
//            vc.currentIndex = 0;
//            vc.isNoEdit = [self.info[@"data"][@"detectionStatus"] isEqualToString:@"1"] ? YES : NO;
//            [self.navigationController pushViewController:vc animated:YES];
//
//            //            }
//
//            // 下一状态: 1-初检 2-编辑报告
//            //            if ([data[@"nexStatus"] isEqualToString:@"2"]) {
//            //
//            //                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//            //                YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//            //                 controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_H5@SERVER_PHP_H5_Trunk"dedicated_report.html?token=%@&billId=%@&status=ios", [YHTools getAccessToken], self.orderDetailInfo[@"id"]];
//            //                controller.title = @"工单";
//            //                controller.barHidden = YES;
//            //                [self.navigationController pushViewController:controller animated:YES];
//            //            }
//        }else{
//
//            [MBProgressHUD showError:info[@"msg"]];
//        }
//    } onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
//}
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
        
        return 2;
//        if (!self.dataArr.count) {
//            self.headerView.hidden = YES;
//            self.footChildView.hidden = YES;
//            return 0;
//        }else{
//            self.headerView.hidden = NO;
//            self.footChildView.hidden = NO;
//            return 1;
//        }
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        // 检测方案
        return section? self.diagnoseModel.maintain_scheme.count : 1;
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
    WeakSelf;

    if (tableView == _detailTableview) {
        
//        YHOrderDetailViewCell *orderDetailCell = [YHOrderDetailViewCell createOrderDetailViewCell:tableView];
//        orderDetailCell.cellModel = self.dataArr[indexPath.row];
//        orderDetailCell.orderIdType = self.info[@"data"][@"billType"];
//
//        if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//
//            orderDetailCell.isEnableForSwitch = [self.info[@"data"][@"detectionStatus"] isEqualToString:@"0"] ? YES : NO;
//            NSDictionary *elementItem = self.info[@"data"][@"initialSurveyItem"][indexPath.row];
//            orderDetailCell.isOnOffSwitch = [[NSString stringWithFormat:@"%@", elementItem[@"checkedStatus"]] isEqualToString:@"0"] ? NO : YES;
//            if (self.isCheckComplete) {
//                orderDetailCell.type = YHOrderDetailViewCellTypeArrow;
//            }else{
//                orderDetailCell.type = YHOrderDetailViewCellTypeSwitch;
//            }
//
//            orderDetailCell.onOffSwitchTouchEvent = ^(NSString *Id, BOOL isOn) {
//                [self.modelDict setValue:[NSNumber numberWithBool:isOn] forKey:Id];
//
//                BOOL isSelect = [self isExistSelectedElement];
//                if (isSelect) {
//                    self.bottomBtn.enabled = YES;
//                    self.bottomBtn.backgroundColor = YHNaviColor;
//                }else{
//                    self.bottomBtn.enabled = NO;
//                    self.bottomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
//                }
//            };
//        }else{
//
//            orderDetailCell.type = YHOrderDetailViewCellTypeArrowAndText;
//        }
        if (indexPath.section == 0) {
            
           YTDiagnoseCell * orderDetailCell =  [tableView dequeueReusableCellWithIdentifier:@"YTDiagnoseCell"];
            self.diagnoseModel.checkResultArr.isTechOrg = self.diagnoseModel.isTechOrg;
            self.diagnoseModel.checkResultArr.nextStatusCode = self.diagnoseModel.nextStatusCode;

            orderDetailCell.model = self.diagnoseModel.checkResultArr;
            orderDetailCell.clearResultBlock = ^{
                
                NSLog(@"%s---%@", __func__,self.diagnoseModel.maintain_scheme);
                ZZAlertViewController *vc = [ZZAlertViewController alertControllerWithTitle:@"是否要清空诊断结果" icon:nil message:@"清空诊断结果会把所有的智能维修方案清空！"];
                [vc addActionWithTitle:@"清空" style:ZZAlertActionStyleDestructive handler:^(UIButton * _Nonnull action) {
                    
                    NSEnumerator *enumerator = [weakSelf.diagnoseModel.maintain_scheme reverseObjectEnumerator];
                    weakSelf.diagnoseModel.checkResultArr.makeResult = @"";
                    for (YTPlanModel *obj in enumerator) {
                        if (obj.is_sys) {
                            [weakSelf.diagnoseModel.maintain_scheme removeObject:obj];
                        }
                        
                        NSLog(@"%s---------%@--%ld", __func__,obj.name,obj.is_sys);
                    }
//                    [weakSelf.diagnoseModel.maintain_scheme enumerateObjectsUsingBlock:^(YTPlanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if (obj.is_sys) {
//                            [weakSelf.diagnoseModel.maintain_scheme removeObject:obj];
//                        }
//                        NSLog(@"%s---------%@--%ld", __func__,obj.name,obj.is_sys);
//                    }];
                    //[weakSelf.diagnoseModel.maintain_scheme removeAllObjects];
                    [weakSelf.diagnoseModel saveDiagnose];

                    [weakSelf refreshView];
                }];
                [vc addActionWithTitle:@"取消" style:ZZAlertActionStyleCancel handler:nil];

                [weakSelf presentViewController:vc animated:NO completion:nil];
            };
            orderDetailCell.searchBlock = ^{
                YTSearchController *vc = [YTSearchController new];
                vc.searchResultBlock = ^{
                    [weakSelf.diagnoseModel saveDiagnose];
                    [weakSelf refreshView];
                };
                vc.diagnoseModel = weakSelf.diagnoseModel;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBar.tintColor = [UIColor blackColor];
                [weakSelf presentViewController:nav animated:NO completion:nil];
            };
            
            
            return orderDetailCell;
        }else{
            
           YTPlanCell* orderDetailCell =  [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
            orderDetailCell.model = self.diagnoseModel.maintain_scheme[indexPath.row];
            orderDetailCell.line.hidden = (indexPath.row == self.diagnoseModel.maintain_scheme.count - 1);
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
        if (indexPath.section == 0) {
            YTDiagnoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTDiagnoseCell"];
            CGFloat height = [cell rowHeight:self.diagnoseModel.checkResultArr];
            return height;
        }
        return 95;
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
        
        if (indexPath.section == 1) {
            YHRepairCaseDetailController *vc =[YHRepairCaseDetailController new];
            vc.index = indexPath.row;
            vc.model = self.diagnoseModel;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
//        if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"] && !self.isCheckComplete) {
//            return;
//        }
//
//        TTZSYSModel *model = self.dataArr[indexPath.row];
//        if ([model.code isEqualToString:@"oil"]) {
//            return;
//        }
//
//        if (!self.isCheckComplete) {
//            // 没有检测完成
//            __weak typeof(self) weakSelf = self;
//            TTZCheckViewController *vc = [TTZCheckViewController new];
//            vc.detailNewController = self;
//            vc.billType = [self.orderDetailInfo valueForKey:@"billType"];
//            vc.sysModels = self.dataArr;
//            vc.orderInfo = self.info[@"data"];
//            vc.baseInfo = self.info[@"data"][@"baseInfo"];
//            vc.billId = self.orderDetailInfo[@"id"];
//            vc.is_circuitry = [self.info[@"data"][@"is_circuitry"] boolValue];
//            vc.callBackBlock = ^{
//                [weakSelf getDataToRefreshView];
//            };
//            vc.currentIndex = indexPath.row;
//            [self.navigationController pushViewController:vc animated:YES];
//
//            return;
//        }
//        // 检测完毕的情况
//        YHCheckDetailViewController *checkDetailVc = [[YHCheckDetailViewController alloc] init];
//        checkDetailVc.orderDetailInfo = self.orderDetailInfo;
//        [self.navigationController pushViewController:checkDetailVc animated: YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
        view.clipsToBounds = YES;
        UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenWidth - 20, 40)];
        [view addSubview:boxV];
        [boxV setRounded:boxV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
        boxV.backgroundColor = [UIColor whiteColor];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        if (!section) {
            titleLB.text = @"诊断结果";
        }else{
            
            titleLB.text = @"维修方案";
            if(self.diagnoseModel.isTechOrg && [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"]){// && !IsEmptyStr(self.diagnoseModel.checkResultArr.makeResult)
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(boxV.width - 54, 10, 44, 30);
                [addBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [addBtn setTitle:@"添加" forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addPlan) forControlEvents:UIControlEventTouchUpInside];
                [boxV addSubview:addBtn];
            }
        }
        [boxV addSubview:titleLB];
        
        return view;
    }
    
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
    }else{
        return  [[UIView alloc] init];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _detailTableview) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenWidth - 20, 10)];
        boxV.backgroundColor = [UIColor whiteColor];
        [view addSubview:boxV];
        [boxV setRounded:boxV.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
        return view;
    }
    
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _detailTableview) {
        
        return 40;
    }
    
    if (tableView == _askAboutTableview) {
        if (!self.askInfoArr.count) {
            return 0;
        }
        return 45.0;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _detailTableview) {
        return 20;
    }

    if (tableView == _askAboutTableview) {
        if (!self.askInfoArr.count) {
            return 0.0;
        }
        return 10.0;
    }else{
        
        return 0.0;
    }
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
//FIXME:  -  问询信息
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


#pragma mark - 获取基本信息数据源数据 ---
- (NSMutableArray *)getBaseInfo:(NSDictionary *)info{
    
    NSMutableArray *baseInfoArr = [NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"客户名称" forKey:@"name"];
    [dict1 setValue:info[@"userName"] forKey:@"value"];
    [baseInfoArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"客户电话" forKey:@"name"];
    [dict2 setValue:info[@"phone"] forKey:@"value"];
    [baseInfoArr addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"车牌号码" forKey:@"name"];
    [dict3 setValue:[NSString stringWithFormat:@"%@%@%@",info[@"plateNumberP"],info[@"plateNumberC"],info[@"plateNumber"]] forKey:@"value"];
    [baseInfoArr addObject:dict3];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setValue:@"车架号" forKey:@"name"];
    [dict4 setValue:info[@"vin"] forKey:@"value"];
    [baseInfoArr addObject:dict4];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setValue:@"车型" forKey:@"name"];
    [dict5 setValue:[NSString stringWithFormat:@"%@%@",info[@"carBrandName"],info[@"carLineName"]] forKey:@"value"];
    [baseInfoArr addObject:dict5];
    
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setValue:@"排量" forKey:@"name"];
    [dict6 setValue:info[@"carCc"] forKey:@"value"];
    [baseInfoArr addObject:dict6];
    
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionary];
    [dict7 setValue:@"变速箱" forKey:@"name"];
    [dict7 setValue:info[@"gearboxType"] forKey:@"value"];
    [baseInfoArr addObject:dict7];
    
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionary];
    [dict8 setValue:@"公里数" forKey:@"name"];
    NSString *tripDistance = [NSString stringWithFormat:@"%@",info[@"tripDistance"]];
    [dict8 setValue:tripDistance forKey:@"value"];
    
    if (tripDistance.length) {
        [baseInfoArr addObject:dict8];
    }
    
    NSMutableDictionary *dict9 = [NSMutableDictionary dictionary];
    [dict9 setValue:@"燃油表" forKey:@"name"];
    NSString *fuelMeter = [NSString stringWithFormat:@"%@",info[@"fuelMeter"]];
    [dict9 setValue:fuelMeter forKey:@"value"];
    if (fuelMeter.length) {
        [baseInfoArr addObject:dict9];
    }
    
    NSMutableDictionary *dict10 = [NSMutableDictionary dictionary];
    [dict10 setValue:@"预约时间" forKey:@"name"];
    [dict10 setValue:info[@"startTime"] forKey:@"value"];
    [baseInfoArr addObject:dict10];
    
    return baseInfoArr;
}
#pragma mark - 查看检测报告 ----
- (void)newWholeCarReport{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@?token=%@&billId=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, (([self.orderDetailInfo[@"billType"] isEqualToString:@"J002"])? @"car_check_report.html" : @"car_report.html"), [YHTools getAccessToken], self.orderDetailInfo[@"id"], ((_functionKey == YHFunctionIdHistoryWorkOrder)? (@"&history=1") : (@""))];
    
    if ([self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
        || [self.orderDetailInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
        urlStr = [NSString stringWithFormat:@"%@&order_state=%@", urlStr, self.orderDetailInfo[@"nextStatusCode"]];
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
@end
