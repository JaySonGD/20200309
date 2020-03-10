//
//  YHOrderDetailController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailController.h"
#import "YHCommon.h"
#import "YHOrderDetailCell.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHOrderListController.h"
#import "YHInitialInspectionController.h"
#import "YHSysSelController.h"
#import "AppDelegate.h"
#import "YHDepthController.h"
#import "YHPhotoManger.h"
#import "Masonry.h"
#import "YHSuccessController.h"
#import "YHImageCollectionCell.h"
#import "YHSellCell.h"
#import "UIButton+WebCache.h"
#import "UIAlertView+Block.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHRepairCell.h"
#import "YHRemarksCell.h"
#import "YHSettlementController.h"
#import "YHVehicleController.h"
#import "YHWebFuncViewController.h"
#import "YHHUPhotoBrowser.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "YHAssignTechnicianController.h"
#import "IQTextView.h"
#import "PayViewController.h"
#import "YHInitialInspectionSysController.h"
#import "UIAlertController+Blocks.h"
#import "YHDiagnosisProjectVC.h"
#import <MJExtension.h>
#import "YHCheckCarModel0.h"
#import "YHCheckCarModelA.h"
#import "YHCheckCarModelB.h"

#import "YHCheckCarCellA.h"
#import "YHStoreTool.h"

#import "UIViewController+OrderDetail.h"

#import "UIViewController+sucessJump.h"

#import "YHCloseWorkListView.h"

#import "YTRepairViewController.h"
#import "YTCounterController.h"

extern NSString *const notificationOrderListChange;
extern NSString *const notificationPriceChange;
extern NSString *const notificationChildByTag;
//#import "UITableView+FDTemplateLayoutCell.h"

@interface YHOrderDetailController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *bottomBoxV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLC;

//导航栏右按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIView *timeOutResultBox;
@property (weak, nonatomic) IBOutlet IQTextView *timeOutResultTV;
@property (weak, nonatomic) IBOutlet UILabel *resultFL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLC;
@property (weak, nonatomic) IBOutlet UIButton *bottomB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomSubBoxV;
@property (strong, nonatomic) NSMutableArray* carPictureArray;

- (IBAction)bottomBAction:(id)sender;

@property (strong, nonatomic)NSMutableArray *initialSurveyProjectVal;
@property (strong, nonatomic)NSMutableArray *consulting;
@property (strong, nonatomic)NSMutableArray *modeInfos;
@property (strong, nonatomic)NSMutableArray *sysInfos;

//顶部视图
@property (weak, nonatomic) IBOutlet UIView *topBoxV;

//请求协助
@property (weak, nonatomic) IBOutlet UIButton *assistB;

//请求协助点击事件
- (IBAction)orderEditAction:(id)sender;

//转派工单
@property (weak, nonatomic) IBOutlet UIButton *redeployB;

//转派工单点击事件
- (IBAction)turnToAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *repairB2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *assistWLC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repairEditLC;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic)UIActionSheet *sheet;
@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (strong, nonatomic)NSString *phoneNum;
@property (weak, nonatomic)UITextField *phoneFT;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *repairBox;
@property (nonatomic)NSUInteger repairSelIndex;
@property (strong, nonatomic)NSString *remarks;
@property (weak, nonatomic)NSArray *childOrderInfos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBWLC;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftB;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightB;
@property (weak, nonatomic) IBOutlet UILabel *planTimeL;
@property (weak, nonatomic) IBOutlet UILabel *timeoutL;
@property (nonatomic)BOOL isNoPass;

//验证图片(MWF)
@property (nonatomic,copy)NSString *version;
@property (nonatomic,strong)NSMutableArray *checkCarValArray;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *nameArray;
@property (nonatomic,strong)NSMutableArray *kejianshangArray;
@property (nonatomic,strong)NSMutableArray *penqiArray;
@property (nonatomic,strong)NSMutableArray *sechaArray;
@property (nonatomic,strong)NSMutableArray *banjinArray;
@property (nonatomic,strong)NSMutableArray *huahengArray;
@property (nonatomic,strong)NSMutableArray *fugaijianArray;


@property (nonatomic, assign) BOOL isShow;

//工单状态提醒视图
@property (nonatomic, strong) UIView *remindView;

//转派/关闭工单视图
@property (nonatomic, strong) UIView *closeView;

//是否显示“转派工单”按钮
@property (nonatomic, assign) BOOL isDisplayTransferBtn;

//是否显示“关闭工单”按钮
@property (nonatomic, assign) BOOL isDisPlayCloseBtn;

//权限数组
@property (nonatomic, strong) NSMutableArray *authorityArray;

@end

@implementation YHOrderDetailController

@dynamic orderInfo;
    
- (void)viewDidLoad
{
    [super viewDidLoad];

    // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
    BOOL isVerifier = NO;
    
    if(![self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"] && !isVerifier){
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭工单" style:UIBarButtonItemStylePlain target:self action:@selector(closeToOrder)];

    }
    
    self.authorityArray = [[NSMutableArray alloc] init];
    
    _bottomLC.constant = 53 + kTabbarSafeBottomMargin;
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCheckCarCellA" bundle:nil] forCellReuseIdentifier:@"YHCheckCarCellA"];
    
    _bottomSubBoxV.layer.borderWidth = 1;
    _bottomSubBoxV.layer.borderColor = YHLineColor.CGColor;
    _rightButton.hidden = YES;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 25);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    _timeOutResultTV.placeholder = @"请输入逾期原因";
    _collectionView.collectionViewLayout = layout;
    _timeOutResultTV.layer.borderWidth = 1;
    _timeOutResultTV.layer.borderColor = YHLineColor.CGColor;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationPriceChange:) name:notificationPriceChange object:nil];
    [center addObserver:self selector:@selector(notificationChildByTag:) name:notificationChildByTag object:nil];
    [center addObserver:self selector:@selector(notificationRefreshOrderStatus) name:@"backForRefreshOrderStatus" object:nil];
    [YHNotificationCenter addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    self.sysInfos = [@[] mutableCopy];
    _repairSelIndex = 0;
    [self.repairBox removeFromSuperview];
    
    if (_isDepth) {
        [_bottomB setTitle:@"提交报价单" forState:UIControlStateNormal];
        if(NO){
            
            _bottomLC.constant = kTabbarSafeBottomMargin;
        }
    }else{
        
        [_bottomB setTitle:(([self.orderInfo[@"billType"] isEqualToString:@"J"]
                             || [self.orderInfo[@"billType"] isEqualToString:@"E"]
                             || [self.orderInfo[@"billType"] isEqualToString:@"V"]
                             || ([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]
                                 || [self.orderInfo[@"billType"] isEqualToString:@"E001"])
                             )? (@"录入初检数据") : (@"选择初检系统")) forState:UIControlStateNormal];
        
    }
    
    _topLC.constant = 0;

    _leftBWLC.constant = screenWidth / 2;//底部按钮宽度初始化
    
    if ([self.orderInfo[@"billType"] isEqualToString:@"W001"] &&
        [self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]
        ) {
        _leftBWLC.constant = screenWidth * 0;//底部按钮宽度初始化
    }
    
    if (_dethPay) {
        _topLC.constant = 0;
        _bottomLC.constant = ((_functionKey == YHFunctionIdHistoryOrder)? (kTabbarSafeBottomMargin) : (53 + kTabbarSafeBottomMargin));
        [_bottomB setBackgroundColor:YHNaviColor];
        [_bottomB setEnabled:YES];
        //        _bottomB.hidden = ;
        [self reupdataDatasource];
        self.title = @"订单详情";
        _rightButton.hidden = YES;
    }else if([self.orderInfo[@"nowStatusCode"] isEqualToString:@"storePushDepth"]
              && ![self.orderInfo[@"nextStatusCode"] isEqualToString:@"carAffirmDepth"]) {
        _topLC.constant = 0;
        _repairB2.hidden = NO;
        _bottomSubBoxV.hidden = NO;
        [self reupdataDatasource];
    }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]) {
        _bottomSubBoxV.hidden = NO;
        _topLC.constant = 0;
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]
              ) {
        _bottomSubBoxV.hidden = NO;
        if ([self.orderInfo[@"billType"] isEqualToString:@"B"]) {
            _topLC.constant = 0;
        }else{
            _topLC.constant = 50;
        }
        [self reupdataDatasource];
        
    }else if(([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudDepthQuote"] && _isDepth)
              || ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"] && _isDepth)){//data 为空是云技师细检报价
        _topLC.constant = 0;
        [_redeployB setTitle:@"细检报价" forState:UIControlStateNormal];
        [self depthDataInit];
        [_tableView reloadData];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurvey"]
             ){
        _topLC.constant = 0;
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"checkReportUploadPicture"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarCheckUploadPicture"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"assessCarUploadPicture"]
             ){
        _topLC.constant = 0;
        [_bottomB setTitle:@"提交" forState:UIControlStateNormal];
        [self reupdataDatasource];
        
    }else if( ([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]
                                 || [self.orderInfo[@"billType"] isEqualToString:@"E001"]) || [self.orderInfo[@"billType"] isEqualToString:@"A"] || [self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"E001"]){
        _topLC.constant = 0;
        _bottomSubBoxV.hidden = NO;
        NSString *billStatus = self.orderInfo[@"billStatus"];
        _bottomLC.constant = (([billStatus isEqualToString:@"close"]/*作废工单没有功能*/)? (0) : (53)) + kTabbarSafeBottomMargin;
        if( [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]){
         
            BOOL saveNewWholeCarUploadPicture = YES;//新全车图片上传
            BOOL saveReplaceDetectiveInitialSurvey = YES;//代录
            if ((saveNewWholeCarUploadPicture || saveReplaceDetectiveInitialSurvey)) {
                [_bottomLeftB setTitle:@"查看报告" forState:UIControlStateNormal];
                [_bottomRightB setTitle:@"提交" forState:UIControlStateNormal];
            }else  if ((!saveNewWholeCarUploadPicture && !saveReplaceDetectiveInitialSurvey) ) {
                [_bottomLeftB setTitle:@"查看报告" forState:UIControlStateNormal];
                _leftBWLC.constant = screenWidth;
            }else{
                _leftBWLC.constant = 0;
                [_bottomRightB setTitle:@"提交" forState:UIControlStateNormal];
            }
        }else  if( [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]){
            
            BOOL Bill_Undisposed_saveEndBill = YES;//结算工单
            if (Bill_Undisposed_saveEndBill) {
                [_bottomLeftB setTitle:@"查看报告" forState:UIControlStateNormal];
                [_bottomRightB setTitle:(([self.orderInfo[@"billType"] isEqualToString:@"G"])? (@"结算工单") : (@"录入检测费")) forState:UIControlStateNormal];
            }else{
                [_bottomLeftB setTitle:@"查看报告" forState:UIControlStateNormal];
                _leftBWLC.constant = screenWidth;
            }
        }else if(([self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"] || ([self.orderInfo[@"nowStatusCode"] isEqualToString:@"storePushNewWholeCarReport"] && [self.orderInfo[@"nextStatusCode"] isEqualToString:@""]))){
            [_bottomLeftB setTitle:@"查看报告" forState:UIControlStateNormal];
            _leftBWLC.constant = screenWidth;
//            _bottomSubBoxV.hidden = NO;
        }else{
            _bottomSubBoxV.hidden = YES;
        }
        
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmMode"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"partsApply"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmComplete"]
             || ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"qualityInspection"])
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]){
        _topLC.constant = 0;
        
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
            
            BOOL Bill_Undisposed_saveEndBill = YES;//结算工单
            if (!Bill_Undisposed_saveEndBill) {
                _bottomLC.constant = kTabbarSafeBottomMargin;
            }
            [_bottomB setTitle:(([self.orderInfo[@"billType"] isEqualToString:@"G"])? (@"结算工单") : (@"录入检测费")) forState:UIControlStateNormal];
        }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmComplete"]) {
            [_bottomB setTitle:@"确认完工" forState:UIControlStateNormal];
        }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"partsApply"]) {
            [_bottomB setTitle:@"申请领料" forState:UIControlStateNormal];
        }else{
            _bottomSubBoxV.hidden = NO;
            if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"qualityInspection"]) {
                _bottomLC.constant = 53 + kTabbarSafeBottomMargin;
                [_bottomLeftB setTitle:@"质检通过" forState:UIControlStateNormal];
                [_bottomRightB setTitle:@"返回重修" forState:UIControlStateNormal];
            }else{
                _repairEditLC.constant = -39;
                [_bottomLeftB setTitle:@"确认维修方式" forState:UIControlStateNormal];
                [_bottomRightB setTitle:@"推送给车主" forState:UIControlStateNormal];
            }
        }
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nowStatusCode"] isEqualToString:@"carAffirmDepth"]//车主确认细检
             ||[self.orderInfo[@"nextStatusCode"] isEqualToString:@"makeModeScheme"]//云技师出维修方式
             ){
        _topLC.constant = 0;
        _repairB2.hidden = NO;
        _bottomSubBoxV.hidden = NO;
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nowStatusCode"] isEqualToString:@"checkCar"]//验车 全车检测
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"checkReportInitialSurvey"]//问询
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"]//新全车问询
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarInitialSurvey"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"assessCarInitialSurvey"]
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"matchInitialSurvey"]
             ){
        _topLC.constant = 0;
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushDepth"]//中心站推送细检方案给维修厂
             
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushModeScheme"]//中心站推送维修方式
             ){
        _topLC.constant = 0;
        [_bottomB setTitle:@"推送给维修厂" forState:UIControlStateNormal];
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nowStatusCode"] isEqualToString:@"storePushDepth"]
             &&[self.orderInfo[@"nextStatusCode"] isEqualToString:@"carAffirmDepth"]//修理厂确认细检
             ){
        _topLC.constant = 0;
        [_bottomB setTitle:@"确认细检" forState:UIControlStateNormal];
        [self reupdataDatasource];
    }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushDepth"]//细检推送车主
             || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"modeQuote"]//维修方式推送车主
             || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"channelSubmitMode"]//保存提交渠道维修方案
             || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]//全车检测报告推送车主
             || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeBuyAssessCarReport"]//估车报告推送车主
             || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告推送车主
             ){
        _topLC.constant = 0;
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"channelSubmitMode"]) {
            _repairEditLC.constant = -39;
            [_bottomB setTitle:@"提交方案" forState:UIControlStateNormal];
        }else{
            [_bottomB setTitle:@"推送给车主" forState:UIControlStateNormal];
        }
        [self reupdataDatasource];
    }else{
        _topLC.constant = 0;
        _bottomLC.constant = kTabbarSafeBottomMargin;
        [self reupdataDatasource];
    }
    
    if ([self.orderInfo[@"handleType"] isEqualToString:@"detail"] && ![self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"] && ![self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
        && ![self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
        _bottomLC.constant = kTabbarSafeBottomMargin;
    }
    
//    if(self.isFatherWorkList){
//        [_sysInfos insertObject:@{@"title": @"车况报告"} atIndex:0];
//    }
}

#pragma mark - 关闭工单 ----
- (void)closeToOrder{
    
    [self endBill:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 点击cell跳转
- (void)notificationChildByTag:(NSNotification*)notic{
    
    NSInteger i = [notic.userInfo[@"tag"] integerValue];
    
    if (self.showCarReport && (i >= 1000) && [_sysInfos[i-1000][@"title"] isEqualToString:@"车况报告"] ) {
        NSDictionary *value = _sysInfos[0][@"value"][i-1000];
        //"pay_status":1 // 支付状态：0-未支付，1-已支付
        
        BOOL pay_status = [value[@"pay_status"] boolValue];
        NSString *bill_id = value[@"bill_id"];
        NSString *bill_type = value[@"bill_type"];
        if (pay_status) {
#pragma mark - 😄 to h5
            [self newWholeCarReport:value];
            return;
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.urlStr = @"http://www.baidu.com";
            controller.title = @"车况报告";
            controller.barHidden = YES;
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
        vc.billId = bill_id;
        vc.billType = bill_type;
        
        [self.navigationController pushViewController:vc animated:YES];
        

        return;
    }
    
    
//    NSLog(@"---------%@%@%@--------",notic.name,notic.userInfo,notic.object);
    
    NSNumber *tag = notic.userInfo[@"tag"];
    NSDictionary *orderInfo = _childOrderInfos[tag.intValue];
    
    if((
        [orderInfo[@"billType"] isEqualToString:@"E002"]
        || [orderInfo[@"billType"] isEqualToString:@"E003"]
        || [orderInfo[@"billType"] isEqualToString:@"J004"]
        || [orderInfo[@"billType"] isEqualToString:@"J006"]
        || [orderInfo[@"billType"] isEqualToString:@"J003"]
        || [orderInfo[@"billType"] isEqualToString:@"J002"]
        || [orderInfo[@"billType"] isEqualToString:@"J008"]
        || [orderInfo[@"billType"] isEqualToString:@"J009"]
        || [orderInfo[@"billType"] isEqualToString:@"Y002"]

        
        )
       && [orderInfo[@"nowStatusCode"] isEqualToString:@"consulting"]){//
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                                billId:orderInfo[@"id"]
                                                             isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
                                                            onComplete:^(NSDictionary *info) {
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                                if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                                                                    BOOL detectionPay = [info[@"data"][@"detectionPay"] boolValue];
                                                                    //"detectionPay": "0", // 检测服务费支付装：0-未付款 1-已付款
                                                                    if (!detectionPay) { // 去支付
                                                                        
                                                                        YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                                                                        vc.billId = orderInfo[@"id"];
                                                                        vc.billType = orderInfo[@"billType"];
                                                                        vc.buy_type = 3;
                                                                        
                                                                        [self.navigationController pushViewController:vc animated:YES];

                                                                        return;
                                                                    }
                                                                    [self orderDetailNavi:orderInfo code:self.functionKey];
                                                                    return;
                                                                }
                                                            } onError:^(NSError *error) {
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                            }];
        return;
    }
//    [self orderDetailNavi:orderInfo];
#warning [self orderDetailNavi:orderInfo]
    [self orderDetailNavi:orderInfo code:self.functionKey];
}

#pragma mark - 查看检测报告 ----
- (void)newWholeCarReport:(NSDictionary *)orderDetailInfo{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    //http://dev.demo.com/owner/carReport.html?token=xxx&billId=xxx&status=ios
    NSString *urlStr = [NSString stringWithFormat:@"%@/owner/carReport.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,[YHTools getAccessToken],orderDetailInfo[@"bill_id"]];
//    NSString *urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_H5@SERVER_PHP_H5_Trunk"/%@?token=%@&billId=%@&status=ios%@", (([orderDetailInfo[@"bill_type"] isEqualToString:@"J002"])? @"car_check_report.html" : @"car_report.html"), [YHTools getAccessToken], orderDetailInfo[@"bill_id"], ((_functionKey == YHFunctionIdHistoryWorkOrder)? (@"&history=1") : (@""))];
//
//    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
//        || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
//        urlStr = [NSString stringWithFormat:@"%@&order_state=%@", urlStr, self.orderInfo[@"nextStatusCode"]];
//    }
    controller.urlStr = urlStr;
    controller.title = @"工单";
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)notificationPriceChange:(NSNotification*)notic
{
    [_tableView reloadData];
}

- (IBAction)popViewController:(id)sender
{
    if (!_timeOutResultBox.isHidden) {
        _timeOutResultBox.hidden = YES;
        return;
    }
    if (_isDepth || !_isPop2Root) {
        [super popViewController:sender];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHOrderListController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            isBack = YES;
        }
    }];
    if (!isBack) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - orderDetail Navi
- (void)orderDetailNavi:(NSDictionary*)orderInfo{
    
    NSString *billType = orderInfo[@"billType"];
    if ([orderInfo[@"nextStatusCode"] isEqualToString:@"checkCar"] ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHVehicleController *controller = [board instantiateViewControllerWithIdentifier:@"YHVehicleController"];
        controller.orderInfo= orderInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ((self.functionKey == YHFunctionIdHistoryWorkOrder && ( [billType isEqualToString:@"V"] || [billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]))//三大报告
              || (([billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]) &&([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]))
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushAssessCarReport"]//估车车报告
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushCheckReport"]//检测报告 特殊流程(全部正常，无维修方式)
              //              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]//全车检测
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"]//二手车报告
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"]//二手车报告 推送报告 特殊流程(全部正常，无维修方式)
              
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeCheckReportQuote"]//检测报告 修改报价
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告 修改报价
              || [orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]) {//检测报告
        [self historyNavi:orderInfo];
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"cloudMakeDepth"]
              ||([orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"])
              //              ||[orderInfo[@"nextStatusCode"] isEqualToString:@"modeQuote"]//人工费
              ||[orderInfo[@"nowStatusCode"] isEqualToString:@"cloudMakeDepth"]
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"checkCar"] && [billType isEqualToString:@"B"])){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHDepthController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthController"];
        controller.orderInfo = orderInfo;
        controller.isRepair = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([orderInfo[@"nowStatusCode"] isEqualToString:@"carAppointment"]
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"consulting"] && [orderInfo[@"nowStatusCode"] isEqualToString:@"receivedBill"])){// 预约
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"]];
        controller.title = @"工单";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (([orderInfo[@"nextStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) && ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getBillDetail:[YHTools getAccessToken]
         billId:orderInfo[@"id"]
         isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSDictionary *data = info[@"data"];
                 NSString *handleType = data[@"handleType"];
                 if (![handleType isEqualToString:@"detail"] && handleType) {
                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                     YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
                     controller.sysData = data;
                     controller.orderInfo = orderInfo;
                     [weakSelf.navigationController pushViewController:controller animated:YES];
                 }else{
                     [weakSelf interView:orderInfo isDetail:YES];
                 }
             }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                 [weakSelf interView:orderInfo isDetail:NO];
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }else  if ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushExtWarrantyReport"] && ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@/insurance.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5 ,SERVER_PHP_H5_Trunk,[YHTools getAccessToken], orderInfo[@"id"]];
        controller.title = @"工单";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarInitialSurvey"] && [billType isEqualToString:@"E001"]){
        YHDiagnosisProjectVC *VC = [[YHDiagnosisProjectVC alloc]init];
        YHBillStatusModel *billModel = [[YHBillStatusModel alloc]init];
        billModel.billId = orderInfo[@"id"];
        VC.billModel = billModel;
        VC.isHelp = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self interView:orderInfo isDetail:YES];
    }
}

- (void)historyNavi:(NSDictionary*)orderInfo{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getBillDetail:[YHTools getAccessToken]
     billId:orderInfo[@"id"]
     isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             NSDictionary *reportData = data[@"reportData"];
             [weakSelf interView:orderInfo isDetail:((reportData == nil) || !(reportData.count > 0)/*报告已出和已购买 */ || (([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]) /* 等待生产报告和等待购买报告情况*/))];
         }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
             [weakSelf interView:orderInfo isDetail:NO];
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - -----------------------------现有工单流程提醒------------------------------
- (void)initRemindingView
{
    self.remindView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, screenWidth, 50)];
    self.remindView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:221/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:self.remindView];
    
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    remindLabel.text = @"请使用PC端进行详细操作";
    remindLabel.textColor = YHNaviColor;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.font = [UIFont systemFontOfSize:15];
    [self.remindView addSubview:remindLabel];
}

#pragma mark - ------------------------------导航栏更多按钮-------------------------------
- (void)clickMoreBtn
{
//    if (self.redeployB.isSelected == YES) {
//        [self.redeployB setSelected:NO];
//        [self.closeView removeFromSuperview];
//    } else {
//        [self.redeployB setSelected:YES];
//        [self initTransferAndCloseView];
//        [self.closeWorkListView removeFromSuperview];
//    }
    
    if (self.isShow == YES) {
        [self.redeployB setSelected:NO];
        [self.closeView removeFromSuperview];
    } else {
        [self.redeployB setSelected:YES];
        [self initTransferAndCloseView];
    }
    [self.closeWorkListView removeFromSuperview];
    self.isShow = !self.isShow;
}

#pragma mark - 转派/关闭工单
- (void)initTransferAndCloseView
{
    self.closeView = [[UIView alloc] init];
    self.closeView.frame = CGRectMake(screenWidth-115, kStatusBarAndNavigationBarHeight, 100, self.authorityArray.count*50+1);
    self.closeView.backgroundColor = YHBackgroundColor;
    self.closeView.layer.borderWidth = 1;
    self.closeView.layer.borderColor = [YHBackgroundColor CGColor];
    [self.view addSubview:self.closeView];
    
    for (int i = 0; i < self.authorityArray.count; i++) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            closeBtn.frame = CGRectMake(0, 0, 100, 50);
        } else {
            closeBtn.frame = CGRectMake(0, 51, 100, 50);
        }
        closeBtn.tag = i+1;
        closeBtn.backgroundColor = YHWhiteColor;
        [closeBtn setTitle:self.authorityArray[i] forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(transferAndCloseList:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeView addSubview:closeBtn];
    }
}

- (void)transferAndCloseList:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"转派工单"]) {
        [self transferWorkList];
    } else if ([button.titleLabel.text isEqualToString:@"关闭工单"]) {
//        [self closeWorkList];
        [self endBill:nil];
    }
    [self.redeployB setSelected:NO];
    [self.closeView removeFromSuperview];
    self.isShow = NO;
}

#pragma mark - 转派工单操作步骤
- (void)transferWorkList{
    YHAssignTechnicianController * VC = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAssignTechnicianController"];
    VC.data = self.data;
    VC.orderInfo = self.orderInfo;
    VC.isMark = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 关闭工单操作步骤
- (void)closeWorkList{
    if (!self.closeWorkListView) {
        self.closeWorkListView = [[NSBundle mainBundle]loadNibNamed:@"YHCloseWorkListView" owner:self options:nil][0];
        self.closeWorkListView.backgroundColor = YHColorA(127, 127, 127, 0.5);
        self.closeWorkListView.reasonTF.delegate = self;
        [self.view addSubview:self.closeWorkListView];
    }
    
    WeakSelf;
    self.closeWorkListView.btnClickBlock = ^(UIButton *button) {
        if (IsEmptyStr(weakSelf.closeWorkListView.reasonTF.text)) {
            [MBProgressHUD showError:@"请输入关闭原因"];
            return;
        }
        
        [MBProgressHUD showMessage:@"关闭中..." toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]endBill:[YHTools getAccessToken]
                                                         billId:weakSelf.orderInfo[@"id"]
                                                 closeTheReason:weakSelf.closeWorkListView.reasonTF.text
                                                     onComplete:^(NSDictionary *info)
         {
             [MBProgressHUD hideHUDForView:self.view];
             [weakSelf.closeWorkListView removeFromSuperview];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:notificationOrderListChange object:Nil userInfo:nil];
                 
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
    };
}

- (void)interView:(NSDictionary*)orderInfo isDetail:(BOOL)isDetail{
    
    if (isDetail) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
        controller.functionKey = _functionKey;
        NSString *billStatus = orderInfo[@"billStatus"];
        if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
            controller.functionKey = YHFunctionIdHistoryWorkOrder;
        }
        controller.orderInfo = orderInfo;
        controller.isPop2Root = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.barHidden = YES;
        if ([orderInfo[@"billType"] isEqualToString:@"V"]) {
            controller.urlStr = [NSString stringWithFormat:@"%@%@/look_assess.html?token=%@&order_id=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],  ((self.functionKey == YHFunctionIdHistoryWorkOrder)? (@"") : (@"&push=1"))];
        }else{
            controller.urlStr = [NSString stringWithFormat:@"%@%@/look_report.html?token=%@&billId=%@&status=ios&order_status=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],(((self.functionKey == YHFunctionIdHistoryWorkOrder)/* 历史工单传 billType*/ )? (orderInfo[@"billType"]) : (orderInfo[@"nextStatusCode"]))];
        }
        controller.title = @"工单";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"programme"]) {
        YHDepthController *controller = segue.destinationViewController;
        controller.isRepair = ![segue.identifier isEqualToString:@"programme"];
        controller.orderInfo = self.orderInfo;
    }else if([segue.identifier isEqualToString:@"repair"]){
        
        YHDepthController *controller = segue.destinationViewController;
        controller.isRepair = ![segue.identifier isEqualToString:@"programme"];
        controller.orderInfo = self.orderInfo;
        [[YHStoreTool ShareStoreTool] setTemporaryData:self.data];
        
    }else if([segue.identifier isEqualToString:@"turn"]){
        YHAssignTechnicianController *controller = segue.destinationViewController;
        controller.data = self.data;
        controller.orderInfo = self.orderInfo;
        controller.isMark = YES;
    }else{
        YHDepthController *controller = segue.destinationViewController;
        controller.isRepair = ![segue.identifier isEqualToString:@"programme"];
        controller.orderInfo = self.orderInfo;
        controller.isRepairPrice = YES;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
{
    if ([identifier isEqualToString:@"programme"]) {
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
            controller.sysData = self.data;
            controller.orderInfo = self.orderInfo;
            controller.is_circuitry = _data[@"is_circuitry"];
            [self.navigationController pushViewController:controller animated:YES];
            return NO;
        }else if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmMode"])
                  || ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"qualityInspection"])){
            [self bottomBAction:nil];
            return NO;
        }else if((([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"]/*新安检单*/ || [self.orderInfo[@"billType"] isEqualToString:@"J001"]))
               && ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
                   || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]
                   || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"]
                   || ([self.orderInfo[@"nowStatusCode"] isEqualToString:@"storePushNewWholeCarReport"] && [self.orderInfo[@"nextStatusCode"] isEqualToString:@""]))){//新全车查看报告
                   [self newWholeCarReport];
                   return NO;
               }else if(([self.orderInfo[@"billType"] isEqualToString:@"A"] ||
                       [self.orderInfo[@"billType"] isEqualToString:@"E001"] ||
                       [self.orderInfo[@"billType"] isEqualToString:@"Y"] ||
                       [self.orderInfo[@"billType"] isEqualToString:@"Y001"] ||
                         [self.orderInfo[@"billType"] isEqualToString:@"Y002"])
                      && ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
                          || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]
                          || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"])){//二延查看报告
                          UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
                          
                          /*
                           @摸金校尉 质保合并的那个  工单类型是 Y002，报告跳转页地址   'newExtendedWarranty.html?token='+token+"&status="+status+"&billId="+billId;
                           */
                          
                          YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                          if ([self.orderInfo[@"billType"] isEqualToString:@"E001"]) {//二手车报告
//                              NSDictionary *reportData = self.data[@"reportData"];
//                              controller.urlStr = [NSString stringWithFormat:@"%@&isInfoEnter=0&status=ios",  reportData[@"reportUrl"]];
                            controller.urlStr = [NSString stringWithFormat:@"%@%@/maintenance_report.html?token=%@&&status=ios&billId=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken],self.orderInfo[@"id"]];
                              

                          }else if ([self.orderInfo[@"billType"] isEqualToString:@"Y002"]){
                              
                               controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_report&jnsAppStatus=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.orderInfo[@"id"]];
                               //controller.urlStr = [NSString stringWithFormat:@"%@%@/newExtendedWarranty.html?token=%@&&status=ios&billId=%@", SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],self.orderInfo[@"id"]];

                          }else{
                              
                              controller.urlStr = [NSString stringWithFormat:@"%@%@/insurance.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], self.orderInfo[@"id"]];
                              
                          }
                          controller.title = @"工单";
                          controller.barHidden = YES;
                          [self.navigationController pushViewController:controller animated:YES];
                          return NO;
                      }
        
    }else if([identifier isEqualToString:@"repair"]){
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"qualityInspection"]) {
            if (_timeOutResultBox.isHidden && !(self.isNoPass)) {
                self.timeOutResultBox.hidden = NO;
                self.isNoPass = YES;
                _resultFL.text = @"请输入问题描述";
                _planTimeL.hidden = YES;
                _timeoutL.hidden = YES;
                _timeOutResultTV.placeholder = @"请输入问题描述";
                [_bottomLeftB setTitle:@"确定打回" forState:UIControlStateNormal];
                [_bottomRightB setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                self.timeOutResultBox.hidden = YES;
                self.isNoPass = NO;
                _timeOutResultTV.text = @"";
                [_bottomLeftB setTitle:@"质检通过" forState:UIControlStateNormal];
                [_bottomRightB setTitle:@"返回重修" forState:UIControlStateNormal];
            }
            return NO;
        }
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmMode"]) {
            
            __weak __typeof__(self) weakSelf = self;
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveStorePushDepth:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             phoneNumber:_phoneNum
             orderModel:YHOrderStorePushMode
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     [MBProgressHUD showSuccess:@"推送成功！"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLogERROR(@"");
                         [weakSelf showErrorInfo:info];
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];;
             }];
            return NO;
        }
        if(( ([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"]) || [self.orderInfo[@"billType"] isEqualToString:@"A"]) && ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"] || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"])
           ){ //新全车查看报告，提交图片和新全车结算
            [self bottomBAction:nil];
            return NO;
        }
        
        //        if(([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])
        //           && [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]){//新全车结算
        //            [self bottomBAction:nil];
        //            return NO;
        //        }
                if([self.orderInfo[@"billType"] isEqualToString:@"W001"]
                   && [self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]){//

                    YTRepairViewController *vc = [YTRepairViewController new];
                    vc.orderDetailInfo = self.orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    return NO;
                }
    }
    return YES;
}

//http://dev.demo.com/app/car_report.html?token=b4c4ca9296bab1a9a106a48a8ae2623f&billId=8910&status=ios&history=1&order_state=storePushNewWholeCarReport
//http://dev.demo.com/app/car_report.html?token=b4c4ca9296bab1a9a106a48a8ae2623f&billId=8892&status=ios&order_state=storePushNewWholeCarReport
- (void)newWholeCarReport
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@?token=%@&billId=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, (([self.orderInfo[@"billType"] isEqualToString:@"J002"])? @"car_check_report.html" : @"car_report.html"), [YHTools getAccessToken], self.orderInfo[@"id"], ((_functionKey == YHFunctionIdHistoryWorkOrder)? (@"&history=1") : (@""))];
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
        || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
        urlStr = [NSString stringWithFormat:@"%@&order_state=%@", urlStr, self.orderInfo[@"nextStatusCode"]];
    }
    controller.urlStr = urlStr;
    controller.title = @"工单";
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//报告费用
- (void)reportBillDataInit
{
    NSDictionary *reportBillData = _data[@"reportBillData"];
    NSArray *reportBills = reportBillData[@"reportBills"];
    if (reportBillData && reportBills) {
        [_sysInfos addObject:@{@"title" : @"报告费用",
                               @"value" : reportBillData}];
    }
}

//收款
- (void)totalQuoteDataInit
{
    NSMutableArray *infos = [@[]mutableCopy];
    NSString *realQuote = _data[@"realQuote"];
    NSString *totalQuote = _data[@"totalQuote"];
    if (!totalQuote) {
        return;
    }
    if (totalQuote) {
        [infos addObject:@{@"projectName" : @"应收", @"projectVal" : [NSString stringWithFormat:@"¥%@", totalQuote]}];
    }else{
        return;
    }
    if ((totalQuote.floatValue > realQuote.floatValue) && totalQuote && realQuote) {
        [infos addObject:@{@"projectName" : @"优惠", @"projectVal" : [NSString stringWithFormat:@"¥%.2f", realQuote.floatValue - totalQuote.floatValue]}];
    }
    
    if (realQuote) {
        [infos addObject:@{@"projectName" : @"实收", @"projectVal" : [NSString stringWithFormat:@"¥%@", realQuote]}];
    }
    if (infos.count) {
        [_sysInfos addObject:@{@"title" : @"总费用",
                               @"value" : infos}];
    }
}

- (void)cloudDepthDataInit
{
    NSArray *cloudDepthSysClass = _data[@"cloudDepthSysClass"];//cloudDepthSysClass
    
    if (cloudDepthSysClass) {
        self.cloudDepthProjectVal = [@[]mutableCopy];
        if ([cloudDepthSysClass isKindOfClass:[NSDictionary class]]) {
            cloudDepthSysClass = ((NSDictionary*)cloudDepthSysClass).allValues;
        }
        for (NSDictionary *item in cloudDepthSysClass) {
            BOOL isExit = NO;
            NSString *sysClassId = item[@"sysClassId"];
            if (!sysClassId) {
                sysClassId = item[@"id"];
            }
            for (NSMutableDictionary *initialSurvey in _cloudDepthProjectVal) {
                
                if ([sysClassId isEqualToString:initialSurvey[@"sysClassId"]]) {
                    
                    NSMutableArray *subSys = initialSurvey[@"subSys"];
                    if (subSys == nil) {
                        subSys = [@[]mutableCopy];
                        [initialSurvey setObject:subSys forKey:@"subSys"];
                    }
                    
                    NSMutableDictionary *project = [item mutableCopy];
                    [project setValue:item[@"id"] forKey:@"sysClassId"];
                    [subSys addObject:project];
                    isExit = YES;
                }
            }
            
            if (!isExit) {
                NSString *sysClassId = item[@"sysClassId"];
                if (!sysClassId) {
                    sysClassId = item[@"id"];
                }
                NSMutableDictionary *temp = [item mutableCopy];
                [temp setObject:sysClassId forKey:@"sysClassId"];
                [_cloudDepthProjectVal addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                                    @"subSys" : [@[temp]mutableCopy]}mutableCopy]];
            }
        }
        
        if (_cloudDepthProjectVal.count) {
            [_sysInfos addObject:@{@"title" : @"云细检",
                                   @"value" : _cloudDepthProjectVal}];
        }
    }
    //本地
    NSArray *storeDepth = _data[@"storeDepth"];
    if ([storeDepth isKindOfClass:[NSDictionary class]]) {
        storeDepth = [(NSDictionary*)storeDepth allValues];
    }
    if (storeDepth) {
        self.storeDepthProjectVal = [@[]mutableCopy];
        
        for (NSDictionary *item in storeDepth) {
            BOOL isExit = NO;
            NSString *sysClassId = item[@"sysClassId"];
            if (!sysClassId) {
                sysClassId = item[@"id"];
            }
            for (NSMutableDictionary *initialSurvey in _storeDepthProjectVal) {
                
                if ([sysClassId isEqualToString:initialSurvey[@"sysClassId"]]) {
                    
                    NSMutableArray *subSys = initialSurvey[@"subSys"];
                    if (subSys == nil) {
                        subSys = [@[]mutableCopy];
                        [initialSurvey setObject:subSys forKey:@"subSys"];
                    }
                    
                    NSMutableDictionary *project = [item mutableCopy];
                    [project setValue:sysClassId forKey:@"sysClassId"];
                    
                    [subSys addObject:project];
                    isExit = YES;
                }
            }
            
            if (!isExit) {
                NSString *sysClassId = item[@"sysClassId"];
                if (!sysClassId) {
                    sysClassId = item[@"id"];
                }
                NSMutableDictionary *temp = [item mutableCopy];
                [temp setObject:sysClassId forKey:@"sysClassId"];
                [_storeDepthProjectVal addObject:[@{@"sysClassId" : sysClassId,
                                                    @"subSys" : [@[temp]mutableCopy]}mutableCopy]];
            }
        }
        
        if (_storeDepthProjectVal.count) {
            [_sysInfos addObject:@{@"title" : @"细检 ",
                                   @"value" : _storeDepthProjectVal}];
        }
        
        
    }
}
- (void)notificationRefreshOrderStatus{
    
    self.sysInfos = [@[] mutableCopy];
    [self reupdataDatasource];
}

//云维修方式
- (void)cloudRepairModesInit
{
    NSArray *modes;
    id cloudRepairModeData = _data[@"cloudRepairModeData"];
    if ([cloudRepairModeData isKindOfClass:[NSDictionary class]]) {
        modes = ((NSDictionary*)cloudRepairModeData).allValues;//cloudDepthSysClass
    }
    
    if ([cloudRepairModeData isKindOfClass:[NSArray class]]) {
        modes = (NSArray*)cloudRepairModeData;//cloudDepthSysClass
    }
    if (!modes) {
        return;
    }
    self.cloudRepairs = [@[]mutableCopy];
    self.cloudCheckResult = _data[@"cloudCheckResultArr"];
    for (NSUInteger i = 0; i < modes.count; i++) {
        NSDictionary *mode = modes[i];
        NSMutableArray *parts = [@[]mutableCopy];
        
        for (NSDictionary *item in mode[@"parts"]){
            [parts addObject:[item mutableCopy]];
        }
        
        NSMutableArray *repairItem = [@[]mutableCopy];
        for (NSDictionary *item in mode[@"repairItem"]){
            [repairItem addObject:[item mutableCopy]];
        }
        [_cloudRepairs addObject:
         [@{@"dataSourceSupplies" : parts,
            @"dataSourceModel" : repairItem,
            //            @"scheme" : mode[@"scheme"],
            @"repairData": mode,
            @"repairStr": [NSString stringWithFormat:@"维修方式 %lu", (unsigned long)i + 1]
            } mutableCopy]];
        
    }
}

//诊断结果
- (void)repairResult
{
    NSDictionary *checkResult = _data[@"checkResultArr"];//
    if (!checkResult || (id)checkResult == [NSNull null] || ![checkResult isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ( !checkResult[@"makeResult"] || [checkResult[@"makeResult"] isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"诊断结果",  @"value" : checkResult[@"makeResult"]}];
}

//诊断思路
- (void)repairIdea
{
    NSDictionary *checkResult = _data[@"checkResultArr"];//
    if (!checkResult || (id)checkResult == [NSNull null] || ![checkResult isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ( !checkResult[@"makeIdea"] || [checkResult[@"makeIdea"] isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"诊断思路", @"value" : checkResult[@"makeIdea"]}];
}

//结算
- (void)settlementDataInit
{
    NSDictionary *endBillResult = _data[@"endBillResult"];
    if (!endBillResult) {
        return;
    }
    NSMutableArray *infos = [@[]mutableCopy];
    NSString *payMode = endBillResult[@"payMode"];
    if (payMode) {
        [infos addObject:@{@"projectName" : @"支付方式", @"projectVal" : payMode}];
    }
    
    NSString *receiveAmount = endBillResult[@"receiveAmount"];
    if (receiveAmount) {
        [infos addObject:@{@"projectName" : @"实付金额", @"projectVal" : [NSString stringWithFormat:@"¥%@", receiveAmount]}];
    }
    
    NSString *remark = endBillResult[@"remark"];
    if (remark) {
        [infos addObject:@{@"projectName" : @"备注", @"projectVal" : remark}];
    }
    if (infos.count) {
        [_sysInfos addObject:@{@"title" : @"结算信息",
                               @"value" : infos}];
    }
}

//关闭原因
- (void)closeTheReason
{
    
    NSDictionary *closeTheReason = _data[@"closeTheReason"];//
    if (!closeTheReason || (id)closeTheReason == [NSNull null]|| ![closeTheReason isKindOfClass:[NSDictionary class]] ) {
        return;
    }
    
    NSString *reason = closeTheReason[@"reason"];
    if (!reason || (id)reason == [NSNull null]|| [reason isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"关闭原因", @"value" : closeTheReason[@"reason"]}];
}

//质检不通过原因
- (void)qualityInspectionRemarks
{
    NSArray *qualityInspectionRemarks = _data[@"qualityInspectionRemarks"];//
    if (!qualityInspectionRemarks || qualityInspectionRemarks.count == 0) {
        return;
    }
    NSMutableArray *qualityInspectionRemarksStrs = [@[]mutableCopy];
    for (NSDictionary *item in qualityInspectionRemarks) {
        [qualityInspectionRemarksStrs addObject:[NSString stringWithFormat:@"%@ %@", item[@"time"], item[@"remarks"]]];
    }
    [_sysInfos addObject:@{@"title" : @"质检不通过原因", @"value" : [qualityInspectionRemarksStrs componentsJoinedByString:@"\n"]}];
}

//质检通过时间
- (void)qualityInspectionPassTime
{
    
    NSString *qualityInspectionPassTime = _data[@"qualityInspectionPassTime"];//
    if (!qualityInspectionPassTime || (id)qualityInspectionPassTime == [NSNull null]|| [qualityInspectionPassTime isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"质检通过时间", @"value" : qualityInspectionPassTime}];
}

//备注
- (void)repairModeText
{
    NSString *repairModeText = _data[@"repairModeText"];//
    if (!repairModeText || (id)repairModeText == [NSNull null]|| ![repairModeText isKindOfClass:[NSString class]] || [repairModeText isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"备注", @"value" : repairModeText}];
}

#pragma mark ---- 维修方式 ----
- (void)repairModesInit{
    
    if ([[self.orderInfo valueForKeyPath:@"billType"] isEqualToString:@"W"]
        && [[self.orderInfo valueForKeyPath:@"handleType"] isEqualToString:@"handle"]
        && [[self.orderInfo valueForKeyPath:@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]) {//帮检单转维修单，维修方式暂存
        return;
    }
    NSArray *modes = _data[@"repairModeData"];
    //    if (!modes) {
    //        modes = _data[@"modeScheme"];
    //    }
    //    if (!modes) {
    //        modes = _data[@"repairMode"];
    //    }
    if (!modes) {
        return;
    }
    //    NSArray *modesKeys = modes.allKeys;//cloudDepthSysClass
    if (!_modeInfos) {
        self.modeInfos = [@[]mutableCopy];
    }
    
    NSString *selectiveRepairModeId = _data[@"selectiveRepairModeId"];
    //    if (selectiveRepairModeId) {//已经选择维修方式
    //        modesKeys = @[selectiveRepairModeId];
    //    }
    for (NSDictionary *mode in modes) {
        NSMutableArray *modeInfo = [@[]mutableCopy];
        if ([mode isKindOfClass:[NSDictionary class]]) {
            NSArray *parts = mode[@"parts"];
            NSArray *repairItem = mode[@"repairItem"];
            if ((id)repairItem != [NSNull null]) {
                if (repairItem && repairItem.count != 0) {
                    [modeInfo addObject:@{@"title" : @"维修项目",
                                          @"value" : repairItem}];
                }
            }
            if ((id)parts != [NSNull null]) {
                if (parts && parts.count != 0) {
                    [modeInfo addObject:@{@"title" : @"配件耗材",
                                          @"value" : parts}];
                }
            }
            NSDictionary *repairModeQuality = mode[@"repairModeQuality"];
            if (repairModeQuality) {
                NSString *warrantyDay = repairModeQuality[@"warrantyDay"];
                if (warrantyDay && ![warrantyDay isEqualToString:@""]) {
                    [modeInfo addObject:@{@"title" : @"质保",                                          @"value" : @[@{@"partsName" : warrantyDay}]}];
                }
            }
            
            NSDictionary *giveBack = mode[@"giveBack"];
            
            if (giveBack) {
                [modeInfo addObject:@{@"title" : @"交车时间",
                                      @"giveBack" : giveBack}];
            }
            
            NSDictionary *scheme = mode[@"scheme"];
            if (scheme) {
                NSString *schemeContent = scheme[@"schemeContent"];
                if (![schemeContent isEqualToString:@""] && schemeContent) {
                    [modeInfo addObject:@{@"title" : @"解决方案",
                                          @"schemeContent" : schemeContent}];
                }
            }
        }else{
            NSDictionary *content0 = ((NSArray*)mode)[0];
            NSString *repairItemStr = content0[@"content"];
            if (((NSArray*)mode).count == 2) {
                NSDictionary *content1 = ((NSArray*)mode)[1];
                NSString *partsStr = content1[@"content"];
                NSArray *parts = (NSArray *)[YHTools dictionaryWithJsonString:partsStr];
                
                NSArray *repairItem = (NSArray *)[YHTools dictionaryWithJsonString:repairItemStr];
                if ((id)repairItem != [NSNull null]) {
                    if (repairItem && repairItem.count != 0) {
                        [modeInfo addObject:@{@"title" : @"维修项目",
                                              @"value" : repairItem}];
                    }
                }
                if ((id)parts != [NSNull null]) {
                    if (parts && parts.count != 0) {
                        [modeInfo addObject:@{@"title" : @"配件耗材",
                                              @"value" : parts}];
                    }
                }
            }else{
                NSArray *repairItem = (NSArray *)[YHTools dictionaryWithJsonString:repairItemStr];
                if ((id)repairItem != [NSNull null]) {
                    if (repairItem && repairItem.count != 0) {
                        [modeInfo addObject:@{@"title" : @"维修项目",
                                              @"value" : repairItem}];
                    }
                }
            }
        }
        
        NSString *preId = mode[@"preId"];
        if (!preId) {
            preId = @"";
        }
        if (selectiveRepairModeId) {
            if ([selectiveRepairModeId isEqualToString:mode[@"preId"]]) {
                [_modeInfos addObject:@{@"model" : modeInfo,
                                        @"id" : preId}];
                break;
            }
        }else{
            [_modeInfos addObject:@{@"model" : modeInfo,
                                    @"id" : preId}];
        }
    }
    
    if (_modeInfos.count != 0) {
        [_sysInfos addObject:@{@"title" : @"维修方式",
                               @"value" : _modeInfos}];
    }
    
    //    [repairs addObject:_modeInfos];
    //}
    //
    //[_sysInfos addObject:@{@"title" : @"维修方式",
    //                       @"value" : repairs}];
}

- (BOOL)isPayDepth
{   //判断是否需要显示购买细检方案按钮
    NSString *cloudDepthOrderId = _data[@"cloudDepthOrderId"];
    return ( cloudDepthOrderId
            );
}

- (void)depthPayDataInit
{
    [_bottomB setTitle:[NSString stringWithFormat:@"购买%@¥%@元", _data[@"productName"], _data[@"payAmount"]] forState:UIControlStateNormal];
    NSArray *payDepthData = _data[@"payDepthData"];
    if (!payDepthData || payDepthData.count == 0) {
        return;
    }
    NSDictionary *dethPayInfo = @{@"title" : @"细检系统",
                                  @"value" : payDepthData};
    if (dethPayInfo) {
        [_sysInfos addObject:@{@"title" : @"细检方案",
                               @"value" : dethPayInfo}];
    }
}

- (void)depthDataInit
{
    /**
     技师
     cloudDepthSysClass 云
     storeDepth 本地
     
     云技师
     depth
     cloudDepth
     **/
    
    NSArray *depthProjectS = _data[@"depth"];
    if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"] && _isDepth)
        ) {
        depthProjectS = _data[@"storeDepth"];
    }else{
        if (!depthProjectS) {
            depthProjectS = _data[@"cloudDepth"];
            if (!depthProjectS) {
                return;
            }
        }
    }
    
    if ([depthProjectS isKindOfClass:[NSDictionary class]]) {
        depthProjectS = [(NSDictionary*)depthProjectS allValues];
    }
    self.depthProjectVal = [@[]mutableCopy];
    for (NSDictionary *item in depthProjectS) {
        BOOL isExit = NO;
        NSString *sysClassId = item[@"sysClassId"];
        if (!sysClassId) {
            sysClassId = item[@"id"];
        }
        /*
         {
         className = "\U5236\U52a8\U7cfb\U7edf";
         dataType = string;
         descs = "<null>";
         intervalRange = "<null>";
         intervalType = text;
         projectId = 108;
         projectName = test2;
         sysClassId = 4;
         type = system;
         unit = e21e2;
         }
         */
        for (NSMutableDictionary *initialSurvey in _depthProjectVal) {
            
            if ([sysClassId isEqualToString:initialSurvey[@"sysClassId"]]) {
                
                NSMutableArray *subSys = initialSurvey[@"subSys"];
                if (subSys == nil) {
                    subSys = [@[]mutableCopy];
                    [initialSurvey setObject:subSys forKey:@"subSys"];
                }
                NSMutableDictionary *project = [item mutableCopy];
                //                [project setValue:item[@"id"] forKey:@"sysClassId"];
                [subSys addObject:project];
                isExit = YES;
            }
        }
        
        if (!isExit) {
            NSString *sysClassId = item[@"sysClassId"];
            if (!sysClassId) {
                sysClassId = item[@"id"];
            }
            NSMutableDictionary *temp = [item mutableCopy];
            //            [temp setObject:sysClassId forKey:@"sysClassId"];
            [_depthProjectVal addObject:[@{@"sysClassId" : sysClassId,
                                           @"subSys" : [@[temp]mutableCopy]}mutableCopy]];
        }
    }
    
    if (_depthProjectVal.count) {
        [_sysInfos addObject:@{@"title" : @"细检",
                               @"value" : _depthProjectVal}];
    }
}

//客户备注
- (void)customerRemark
{
    NSString *ownerRemark = _data[@"ownerRemark"];//
    if (!ownerRemark || (id)ownerRemark == [NSNull null]|| ![ownerRemark isKindOfClass:[NSString class]] || [ownerRemark isEqualToString:@""]) {
        return;
    }
    [_sysInfos addObject:@{@"title" : @"客户备注", @"value" : ownerRemark}];
}

/**
 故障信息
 **/
- (void)faultInit
{
    NSDictionary *faultPhenomenonCustom = _data[@"faultPhenomenonCustom"];
    NSArray *faultPhenomenon = faultPhenomenonCustom[@"faultPhenomenon"];
    
    if (faultPhenomenon && faultPhenomenon.count > 0) {
        [_sysInfos addObject:@{@"title" : @"故障信息",
                               @"value" : @{@"title" : @"故障信息",
                                            @"value" : faultPhenomenon}}];
    }
}

/**
 订单详情
 **/
- (void)orderDetailInit
{
    NSMutableArray *payInfos = [@[@{@"key" : @"订单单号",
                                    @"value" : _data[@"orderOpenId"]},
                                  @{@"key" : @"创建时间",
                                    @"value" : _data[@"creationTime"]},
                                  @{@"key" : @"支付金额",
                                    @"value" : _data[@"payAmount"]},
                                  @{@"key" : @"支付状态",
                                    @"value" : (@{@"notPay" : @"待支付", @"succeedPay" : @"支付成功", @"payIng" : @"支付中", @"closePay" : @"取消支付"}[_data[@"isPay"]])},
                                  ]mutableCopy];
    
    
    if (_data[@"payForm"] && ![_data[@"payForm"] isEqualToString:@""]) {
        [payInfos addObject: @{@"key" : @"支付方式",
                               @"value" : @{@"WXPAY" : @"微信支付", @"EXPPAY" : @"体验金支付", @"VIP" : @"会员优惠"}[_data[@"payForm"]]}];
    }
    
    if (payInfos && payInfos.count > 0) {
        [_sysInfos addObject:@{@"title" : @"订单详情",
                               @"value" : @{@"title" : _data[@"productName"],
                                            @"value" : payInfos}}];
    }
}

//子工单
- (void)childInfoInit
{
    NSArray *childInfo = _data[@"childInfo"];
    
    if (!childInfo) {
        return;
    }
    self.childOrderInfos = childInfo;
    [_sysInfos addObject:@{@"title" : @"工单服务进度",
                           @"value" : childInfo}];
    
}

- (NSMutableArray*)projects
{
    __block NSMutableArray *projects = [@[]mutableCopy];
    
    NSArray *initialSurveyCheckProject = _data[@"initialSurveyCheckProject"];
    if (!initialSurveyCheckProject) {
        return nil;
    }
    
    for (NSDictionary *projectItem in initialSurveyCheckProject) {
        bool isExit = NO;
        for (NSDictionary *project in projects) {
            if ([projectItem[@"sysClassId"] isEqualToString:project[@"sysClassId"]]) {
                isExit = YES;
                break;
            }
        }
        if (!isExit) {
            [projects addObject:[@{@"title" : projectItem[@"className"],
                                   @"sysClassId" : projectItem[@"sysClassId"],
                                   @"projectCheckType" : projectItem[@"projectCheckType"],
                                   @"sel" : @0}mutableCopy]];
        }
    }
    return projects;
}

- (void)newWholeInit
{
    //已上传图片保存
    NSArray *initialSurveyImg = _data[@"initialSurveyImg"];
    if((YES)
       //       && [self.orderInfo[@"billStatus"] isEqualToString:@"underway"]
       &&((([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"] || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"]) && initialSurveyImg && initialSurveyImg.count > 0)|| [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"])
       ){
        [_sysInfos addObject:@{@"title" : @"上传图片",
                               @"value" : @[]}];
    }
    //质检通过时间
    [self qualityInspectionPassTime];
    
    //质检不通过原因
    [self qualityInspectionRemarks];
    
    //关闭原因
    [self closeTheReason];
    
    //结算
    [self settlementDataInit];
    
    //收款
    [self totalQuoteDataInit];
    
    //报告费用
    [self reportBillDataInit];
    
    //云维修方式
    [self cloudRepairModesInit];
    
    //备注
    [self repairModeText];
    
    //诊断结果
    [self repairResult];
    
    //    //诊断思路
    //    [self repairIdea];
    
    //维修方式
    [self repairModesInit];
    
    //云细检
    [self cloudDepthDataInit];
    
    //细检
    [self depthDataInit];
    
    //新全车初检
    [self initialSurveyProjectValNewWholeInit];
    
    //新全车初检数据重新排列， 按照左前、右前等等
    [self newWholeSubItemDone];
    
    if (initialSurveyImg && initialSurveyImg.count > 0) {
        if (!_carPictureArray) {
            self.carPictureArray = [@[]mutableCopy];
        }
        for (NSInteger i = 0; i < initialSurveyImg.count; i++) {
            [_carPictureArray addObject:[@{@"url" : initialSurveyImg[i]}mutableCopy]];
        }
    }
    
    //客户备注
    [self customerRemark];
    
    //故障
    [self faultInit];
    
    [self baseInfo];
}

//新全车初检
- (void)initialSurveyProjectValNewWholeInit
{
    //初检
    self.initialSurveyProjectVal = [@[]mutableCopy];
    
    NSArray *initialSurveyCheckProject = _data[@"initialSurveyProjectVal"];
    if ([initialSurveyCheckProject isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in initialSurveyCheckProject) {
            BOOL isExit = NO;
            for (NSMutableDictionary *initialSurvey in _initialSurveyProjectVal) {
                if ([ item[@"sysClassId"] isEqualToString:initialSurvey[@"sysClassId"]]) {
                    
                    NSMutableArray *subSys = initialSurvey[@"subSys"];
                    if (subSys == nil) {
                        subSys = [@[]mutableCopy];
                        [initialSurvey setObject:subSys forKey:@"subSys"];
                    }
                    [subSys addObject:[item mutableCopy]];
                    isExit = YES;
                }
            }
            
            if (!isExit) {
                [_initialSurveyProjectVal addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                                       @"subSys" : [@[[item mutableCopy]]mutableCopy]}mutableCopy]];
            }
        }
        
        if (_initialSurveyProjectVal.count) {
            [_sysInfos addObject:@{@"title" : @"初检",
                                   @"value" : _initialSurveyProjectVal}];
        }
    }
}

- (void)newWholeSubItemDone
{
    //    _initialSurveyProjectVal
    for (NSMutableDictionary *item in _initialSurveyProjectVal) {
        if ([item[@"sysClassId"] isEqualToString:@"19"]
            || [item[@"sysClassId"] isEqualToString:@"21"]) {
            NSMutableArray *subSys = [self newWholeCarSubinfo:item[@"subSys"]];
            
            NSMutableArray *subItem = [@[]mutableCopy];
            
            for (NSInteger i = 0; subSys.count > i; i++) {
                NSDictionary *subSysItem = subSys[i];
                NSArray *sysSub = subSysItem[@"subSys"];
                if (sysSub.count > 0 || sysSub) {
                    [subItem addObject:subSysItem[@"data"]];
                    [subItem addObjectsFromArray:subSysItem[@"subSys"]];
                }
            }
            [item setObject:subItem forKey:@"subSys"];
        }
    }
}

- (NSMutableArray*)newWholeCarSubinfo:(NSArray*)infos
{
    NSMutableArray *temp = [@[]mutableCopy];
    
    for (int i = 0; i < infos.count; i++) {
        NSMutableDictionary *item = infos[i];
        if ([item[@"pid"] isEqualToString:@"0"]) {
            [item setObject:@1 forKey:@"isLow2"];
            BOOL isExistence = NO;
            for (NSMutableDictionary *sysLow2 in temp) {
                if ([item[@"id"] isEqualToString:sysLow2[@"id"]]) {
                    [sysLow2 setObject:item[@"projectName"] forKey:@"title"];
                    [sysLow2 setObject:item forKey:@"data"];
                    isExistence = YES;
                    break;
                }
            }
            if (!isExistence) {
                [temp addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                   @"sel" : @1,
                                   @"id" : item[@"id"],
                                   @"data" : item,
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
//初检
- (void)initialSurveyProjectValInit
{
    //初检
    self.initialSurveyProjectVal = [@[]mutableCopy];
    
    NSArray *initialSurveyCheckProject = _data[@"initialSurveyProjectVal"];
    if ([initialSurveyCheckProject isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in initialSurveyCheckProject) {
            BOOL isExit = NO;
            for (NSMutableDictionary *initialSurvey in _initialSurveyProjectVal) {
                if ([ item[@"sysClassId"] isEqualToString:initialSurvey[@"sysClassId"]]) {
                    
                    NSMutableArray *subSys = initialSurvey[@"subSys"];
                    if (subSys == nil) {
                        subSys = [@[]mutableCopy];
                        [initialSurvey setObject:subSys forKey:@"subSys"];
                    }
                    [subSys addObject:[item mutableCopy]];
                    isExit = YES;
                }
            }
            
            if (!isExit) {
                [_initialSurveyProjectVal addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                                       @"subSys" : [@[[item mutableCopy]] mutableCopy]} mutableCopy]];
            }
        }
        
        if (_initialSurveyProjectVal.count) {
            [_sysInfos addObject:@{@"title" : @"初检",
                                   @"value" : _initialSurveyProjectVal}];
        }
    }
}

- (void)dataInit
{
    
    if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"checkReportUploadPicture"]
       || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarCheckUploadPicture"]
       || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"assessCarUploadPicture"]
       ){
        
        [_sysInfos addObject:@{@"title" : @"上传图片",
                               @"value" : @[]}];
    }
    if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmMode"]
       || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"channelSubmitMode"]){
        [_sysInfos addObject:@{@"title" : @" 维修方式备注",
                               @"value" : @[]}];
    }
    
    //质检通过时间
    [self qualityInspectionPassTime];
    
    //质检不通过原因
    [self qualityInspectionRemarks];
    
    //关闭原因
    [self closeTheReason];
    
    //结算
    [self settlementDataInit];
    
    //收款
    [self totalQuoteDataInit];
    
    //报告费用
    [self reportBillDataInit];
    
    //云维修方式
    [self cloudRepairModesInit];
    
    //备注
    [self repairModeText];
    
    //诊断结果
    [self repairResult];
    
    //    //诊断思路
    //    [self repairIdea];
    
    //维修方式
    [self repairModesInit];
    
    //云细检
    [self cloudDepthDataInit];
    
    //细检
    [self depthDataInit];
    
    //初检
    [self initialSurveyProjectValInit];
    
    //客户备注
    [self customerRemark];
    
    //故障
    [self faultInit];
    //问询
    self.consulting = [@[] mutableCopy];
    NSArray *consultingProjectVal = _data[@"consultingProjectVal"];
    if ([consultingProjectVal isKindOfClass:[NSArray class]]) {
        NSArray *allKeys = @[@{@"title" : @"故障灯选择（多选）",
                               @"value" : @[@"55"]},
                             @{@"title" : @"燃油故障",
                               @"value" : @[@"57",@"67",@"442",@"443",@"444"]},
                             @{@"title" : @"动力故障",
                               @"value" : @[@"69",@"70",@"71",@"72",@"73"]}];
        for (int i = 0; i < allKeys.count; i++ ) {
            NSDictionary *keys = allKeys[i];
            NSArray *value = keys[@"value"];
            NSMutableDictionary *itemInfo = [@{@"title" : keys[@"title"],
                                               @"value" : [@[] mutableCopy]} mutableCopy];
            for (NSString *key in value) {
                
                for (NSDictionary *itemValue in consultingProjectVal) {
                    if ([itemValue[@"id"] isEqualToString:key]) {
                        NSMutableArray *value = itemInfo[@"value"];
                        if (value.count == 0) {
                            [value addObject:itemValue];
                            [_consulting addObject:itemInfo];
                        }else{
                            [value addObject:itemValue];
                        }
                        break;
                    }
                }
                
                //                if (consultingProjectVal[key]) {
                //                    if (_consulting.count <= i) {
                //                        [_consulting addObject:@{@"title" : keys[@"title"],
                //                                                 @"value" : [@[consultingProjectVal[key]]mutableCopy]}];
                //                    }else{
                //                        NSDictionary *item = _consulting[i];
                //                        NSMutableArray *value = item[@"value"];
                //                        [value addObject:consultingProjectVal[key]];
                //                    }
                //                }
            }
        }
        
        NSDictionary *fault_data = _data[@"fault_data"];
        if (![fault_data isKindOfClass:[NSDictionary class]]) {
            fault_data = nil;
        }
        if (fault_data != nil) {
            NSArray *faultPhenomenon = fault_data[@"faultPhenomenon"];
            if (faultPhenomenon.count != 0) {
                [_consulting addObject:@{@"title" : @"故障现象",
                                         @"value" : fault_data[@"faultPhenomenon"]}];
            }
            
            NSString *faultPhenomenonDescs = fault_data[@"faultPhenomenonDescs"];
            if (![faultPhenomenonDescs isEqualToString:@""]) {
                [_consulting addObject:@{@"title" : @"故障现象补充",
                                         @"value" : @[faultPhenomenonDescs]}];
            }
        }
        
        if (_consulting.count) {
            [_sysInfos addObject:@{@"title" : @"问询",
                                   @"value" : _consulting}];
        }
    }
    
    [self childInfoInit];
    [self baseInfo];
    
    //判断有无图片(MWF)
    [self judgePicture];
}

#pragma mark - 判断有无图片(MWF)
- (void)judgePicture
{
    NSDictionary *checkCarValDict = _data[@"checkCarVal"];
    
    self.version = [checkCarValDict[@"version"]stringValue];
    
    NSArray *tempArray;
    if ([self.version isEqualToString:@"1"]) {
        tempArray = checkCarValDict[@"img"];
    } else if ([self.version isEqualToString:@"2"]) {
        tempArray = checkCarValDict[@"checkProject"];
    }
    
    for (NSDictionary *dict in tempArray) {
        YHCheckCarModelA *model = [YHCheckCarModelA mj_objectWithKeyValues:dict];
        [self.checkCarValArray addObject:model];
        
        if ([self.version isEqualToString:@"1"]) {
            //可见伤
            if ([model.type isEqualToString:@"kejianshang"]) {
                [self.kejianshangArray addObject:model];
            //有喷漆
            } else if ([model.type isEqualToString:@"penqi"]) {
                [self.penqiArray addObject:model];
            //有色差
            } else if ([model.type isEqualToString:@"secha"]) {
                [self.sechaArray addObject:model];
            //钣金
            } else if ([model.type isEqualToString:@"banjin"]) {
                [self.banjinArray addObject:model];
            //划痕
            } else if ([model.type isEqualToString:@"huaheng"]) {
                [self.huahengArray addObject:model];
            //覆盖件
            } else if ([model.type isEqualToString:@"fugaijian"]) {
                [self.fugaijianArray addObject:model];
            }
        } else {
            
        }
    }
    
    if (self.checkCarValArray.count != 0) {
        [_sysInfos addObject:@{@"title" : @"验车"}];
    }
}

- (void)baseInfo
{
    //基本信息
    NSDictionary *baseInfo = _data[@"baseInfo"];
    if (baseInfo) {
        [_sysInfos addObject:@{@"title" : @"基本信息",
                               @"value" :
                                   baseInfo}];
    }
}


- (void)bottomBtUpdata//获取详情后刷新按钮
{
    if (_bottomLC.constant  == kTabbarSafeBottomMargin) {//填写初检 有查看报告
        NSDictionary *reportData = _data[@"reportData"];
        _bottomLC.constant = ((reportData.count == 0 || !reportData)? (0) : (53)) + kTabbarSafeBottomMargin;
    }
}

#pragma mark - --------------------------------权限判断---------------------------------
- (void)orderDetail
{
    NSArray *flow = _data[@"flow"];
    if (flow.count != 0) {
        NSDictionary *info = flow[0];
        NSString *statusCode = info[@"statusCode"];
        if ([statusCode isEqualToString:@"storePushDepth"]) {
            _topLC.constant = 0;
            //            _bottomLC.constant = 0;
        }
    }
    
    NSArray *depthProjectS = _data[@"cloudDepthDetail"];//云细检项目数值填写
    if ((depthProjectS.count == 0 && !depthProjectS ) && [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]) {
        _repairB2.hidden = NO;
    }
    
    _repairSelIndex = 0;
    [self.repairBox removeFromSuperview];
    
    //是否显示“转派工单”按钮
    self.isDisplayTransferBtn = NO;

    NSArray *oil_reset_data = _data[@"oil_reset_data"];
    NSArray *redeploy_tech_list = _data[@"redeploy_tech_list"];
    NSArray *cloudRepairModeData = _data[@"cloudRepairModeData"];
    
    
    //保养手工复位教、转派工单(MWF)
    if (oil_reset_data && (oil_reset_data.count > 0) && (redeploy_tech_list && redeploy_tech_list.count > 0)) {
        
        //_assistWLC.constant = screenWidth / 2;
        _assistWLC.constant = screenWidth;
        _topLC.constant = 50;
        [_assistB setTitle:@"保养手工复位教程" forState:UIControlStateNormal];
        self.isDisplayTransferBtn = YES;

    //保养手工复位教
    }else if (oil_reset_data && (oil_reset_data.count > 0)) {
        
        _assistWLC.constant = screenWidth;
        _topLC.constant = 50;
        [_assistB setTitle:@"保养手工复位教程" forState:UIControlStateNormal];
        self.isDisplayTransferBtn = NO;

    //请求协助、转派工单(MWF)
    }else if (redeploy_tech_list && redeploy_tech_list.count > 0
              && [self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]
              && ![self.orderInfo[@"billType"] isEqualToString:@"B"]
              && (cloudRepairModeData.count == 0 || !cloudRepairModeData)) {
        
        //_assistWLC.constant = screenWidth / 2;
        _assistWLC.constant = screenWidth;
        _topLC.constant = 0;//请求协助屏蔽
        self.isDisplayTransferBtn = YES;

    //请求协助、转派工单、是否需要显示购买细检方案按钮(MWF)
    }else if (redeploy_tech_list && redeploy_tech_list.count > 0 && [self isPayDepth]){
        
        //_assistWLC.constant = screenWidth / 2;
        _assistWLC.constant = screenWidth;
        _topLC.constant = 50;
        self.isDisplayTransferBtn = YES;

    //只有转派工单(MWF)
    }else if(redeploy_tech_list && redeploy_tech_list.count > 0){
        
        _assistWLC.constant = 0;
        //_topLC.constant = 50;
        _topLC.constant = 0;
        self.isDisplayTransferBtn = YES;

    //是否需要显示购买细检方案按钮
    }else if([self isPayDepth]){
        _assistWLC.constant = screenWidth;
        _topLC.constant = 50;
        self.isDisplayTransferBtn = NO;
    }else{
        _assistWLC.constant = screenWidth;
        
        //MWF
        self.isDisplayTransferBtn = NO;
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"partsQuote"]) {
            self.topLC.constant = 50;
            [self initRemindingView];
        }
    }
    
    
    //是否显示“关闭工单”按钮(MWF)
    NSString *billStatus = _data[@"billStatus"];
    self.isDisPlayCloseBtn = (!([billStatus isEqualToString:@"underway"])) || (_functionKey == YHFunctionIdHistoryWorkOrder) || _dethPay || [self.orderInfo[@"billType"] isEqualToString:@"G"] || ([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"]) || (([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"]) && [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"]);
    
    //只有initialSurveyCompletion时，才有“更多”按钮(MWF)
    [self.authorityArray removeAllObjects];
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]) {
        if ((self.isDisplayTransferBtn == NO) && (self.isDisPlayCloseBtn == YES)) {
            self.rightButton.hidden = YES;
        } else {
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:@"更多" forState:UIControlStateNormal];
            [self.rightButton addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];

            if (self.isDisplayTransferBtn == YES) {
                [self.authorityArray addObject:@"转派工单"];
            }
            
            if (self.isDisPlayCloseBtn == NO) {
                [self.authorityArray addObject:@"关闭工单"];
            }
        }
    } else {
        if (self.isDisPlayCloseBtn == NO) {
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:@"关闭工单" forState:UIControlStateNormal];
            [self.rightButton addTarget:self action:@selector(closeWorkList) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]
         || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"]
         || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyAssessCarReport"])){
        NSDictionary *orderInfo = _data[@"orderInfo"];
        _bottomLC.constant = 53 + kTabbarSafeBottomMargin;
        if ([orderInfo isKindOfClass:[NSDictionary class]]) {
            NSString *reportPrice = orderInfo[@"reportPrice"];
            [_bottomB setTitle:[NSString stringWithFormat:@"购买报告¥%@", reportPrice] forState:UIControlStateNormal];
            [_bottomB setBackgroundColor:YHNaviColor];
            [_bottomB setEnabled:YES];
        }else{
            [_bottomB setTitle:@"请稍等，报告将在5分钟左右生成" forState:UIControlStateNormal];
            [_bottomB setBackgroundColor:YHCellColor];
            [_bottomB setEnabled:NO];
        }
    }
}

#pragma mark - ===================================网络请求======================================
- (void)reupdataDatasource{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    if (_dethPay) {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getOrderDetail:[YHTools getAccessToken]
                                                               orderId:self.orderId
                                                             isHistory:(_functionKey == YHFunctionIdHistoryOrder)
                                                            onComplete:^(NSDictionary *info)
        {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 weakSelf.data = info[@"data"];
                 [self orderDetailInit];
                 [self baseInfo];
                 [self depthPayDataInit];
                 [weakSelf.tableView reloadData];
             }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                 [MBProgressHUD showError:@"你还没有工单！"];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     [weakSelf showErrorInfo:info];
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }else{
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                               billId:self.orderInfo[@"id"]
                                                            isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
                                                           onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 weakSelf.data = info[@"data"];
                 
//                 "bill_id" = 13860;
//                 "bill_type" = J002;
//                 "create_time" = "2018-08-08 17:39:34";
//                 "org_name" = "\U7f24\U7eb7\U7ef4\U4fee\U7ad9888_003";
//                 "pay_status" = 1;
//                 technician = "\U8ba4\U8bc14";
//                 title = "JNS\U5b89\U68c0\U62a5\U544a";
                 NSArray *car_report_list = [weakSelf.data valueForKey:@"car_report_list"];
//                 car_report_list = @[
//                                     @{
//                                         @"bill_id":@"13860",
//                                         @"bill_type":@"J002",
//                                         @"create_time":@"2018-08-08 17:39:34",
//                                         @"org_name":@"org_name",
//                                         @"pay_status":@"1",
//                                         @"technician":@"technician",
//                                         @"title":@"title",
//
//                                         },
//                                     @{
//                                         @"bill_id":@"13860",
//                                         @"bill_type":@"J002",
//                                         @"create_time":@"2018-08-08 17:39:34",
//                                         @"org_name":@"org_name",
//                                         @"pay_status":@"1",
//                                         @"technician":@"technician",
//                                         @"title":@"title",
//                                         
//                                         },
//
//                                     ];
                 if (self.showCarReport && car_report_list.count && self.isFatherWorkList) {
                     
                     NSMutableArray *values = [NSMutableArray array];
                     [car_report_list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         
                         NSMutableDictionary *value = obj.mutableCopy;
                         value[@"billTypeName"] = value[@"title"];
                         //value[@"assignTech"] = [NSString stringWithFormat:@"%@-%@",value[@"org_name"],value[@"technician"]];
                         value[@"assignTech"] = [NSString stringWithFormat:@"%@",value[@"org_name"]];

                         [values addObject:value];
                         //[_sysInfos insertObject:@{@"title": @"车况报告",@"value":@[value]} atIndex:0];
                     }];
                     
                     [_sysInfos insertObject:@{@"title": @"车况报告",@"value":values} atIndex:0];

                 }
                 
                 
                 
                 if ((([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J008"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])
                     && ( ![self.orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"] &&  ![self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurvey"]))) {
                     [weakSelf newWholeInit];
                     [weakSelf orderDetail];
                 }else{
                     [weakSelf dataInit];
                     [weakSelf assistReload];
                     [weakSelf orderDetail];
                 }
                 [weakSelf bottomBtUpdata];
                 [weakSelf.tableView reloadData];
             }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                 [MBProgressHUD showError:@"你还没有工单！"];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     [weakSelf showErrorInfo:info];
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

- (void)assistReload
{
    NSDictionary *menu_type = _data[@"menu_type"];
    NSString *click = menu_type[@"Bill_Undisposed_saveAssist"];
    
    NSArray *cloudDepthSysClass = _data[@"cloudDepthSysClass"];
    if (cloudDepthSysClass && cloudDepthSysClass.count > 0) {
        if ([self isPayDepth]) {
            [_assistB setTitle:@"购买细检方案" forState:UIControlStateNormal];
        }else{
            [_assistB setTitle:@"已请求协助" forState:UIControlStateNormal];
        }
    }else{
        if ([click isEqualToString:@"click"]) {
            [_assistB setTitle:@"待生成细检方案" forState:UIControlStateNormal];
        }
    }
    if ([click isEqualToString:@"hidden"]) {
        _topLC.constant = 0;
    }
}

- (IBAction)getImageAction:(UIView *)sender
{
//    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                             delegate:self
//                                    cancelButtonTitle:@"取消"
//                               destructiveButtonTitle:nil
//                                    otherButtonTitles:@"从手机相册选择", @"拍照", nil];
//    // Show the sheet
//    [self.sheet showInView:self.view];
//    return;
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        [self takePhotoBy:buttonIndex];

    }];
}

#pragma mark - =============================actionSheet代理方法=================================
#pragma mark - 上传图片
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    [self takePhotoBy:buttonIndex];
}

//获取相片
-(void)takePhotoBy:(UIImagePickerControllerSourceType)type
{
    //有相机
    if ([UIImagePickerController isSourceTypeAvailable: type]){
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.delegate = self;
        }else{
            //设置拍照后的图片可被编辑
            self.imagePicker.allowsEditing = YES;
            //资源类型为照相机
            self.imagePicker.sourceType = type;
            self.imagePicker.delegate = self;
        }
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"无该设备"];
        NSLog(@"无该设备");
    }
}

#pragma mark - =================================picker代理方法===================================
//3.x  用户选中图片后的回调
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    image = [YHPhotoManger fixOrientation:image];
//    image = [self OriginImage:image scaleToSize:CGSizeMake(120, 120)];
    NSData *imageData = UIImageJPEGRepresentation(image, .4);
    
    __weak __typeof__(self) weakSelf = self;
    YHOrderModel model = YHOrderModelW;
    
    if ([self.orderInfo[@"billType"] isEqualToString:@"P"]) {
        model = YHOrderModelP;
    }else if ([self.orderInfo[@"billType"] isEqualToString:@"J"]) {
        model = YHOrderModelJ;
    }else if ([self.orderInfo[@"billType"] isEqualToString:@"E"]) {
        model = YHOrderModelE;
    }else if ([self.orderInfo[@"billType"] isEqualToString:@"V"]) {
        model = YHOrderModelV;
    }else if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]
                                 || [self.orderInfo[@"billType"] isEqualToString:@"E001"])) {
        model = YHOrderModelK;
    }
    
    if (!_carPictureArray) {
        self.carPictureArray = [@[]mutableCopy];
    }
    
    [self.carPictureArray addObject:[@{@"img" : image}mutableCopy]];
    NSInteger index = self.carPictureArray.count - 1;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     updatePictureImageDate:@[imageData]
     token:[YHTools getAccessToken]
     billId:self.orderInfo[@"id"]
     orderModel:model
     isReplace:YES
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             if (info[@"imgUrl"]) {
                 NSMutableDictionary *item = weakSelf.carPictureArray[index];
                 [item setObject:info[@"imgUrl"] forKey:@"url"];
             }else{
                 NSDictionary *data = info[@"data"];
                 NSMutableDictionary *item = weakSelf.carPictureArray[index];
                 [item setObject:data[@"imgUrl"] forKey:@"url"];
             }
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
    
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
}

//2.x  用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setObject:image forKey:@"UIImagePickerControllerOriginalImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

//用户选择取消
- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
    self.imagePicker = nil;
}

-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - =================================tableView代理方法===================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_data) {
        return 0;
    }
    
    if (_isDepth){
        return 1;
    }else{
        return _sysInfos.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isDepth){
        return _depthProjectVal.count + 1;
    }else{
        NSDictionary *sysInfo = _sysInfos[section];
        if ([sysInfo[@"title"] isEqualToString:@"上传图片"] || [sysInfo[@"title"] isEqualToString:@" 维修方式备注"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"云细检"]) {
            return _cloudDepthProjectVal.count;
        }else  if ([sysInfo[@"title"] isEqualToString:@"细检 "]) {
            return _storeDepthProjectVal.count;
        }else if ([sysInfo[@"title"] isEqualToString:@"细检"]) {
            return _depthProjectVal.count;
        }else if ([sysInfo[@"title"] isEqualToString:@"工单服务进度"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"初检"]) {
            return _initialSurveyProjectVal.count;
        }else if ([sysInfo[@"title"] isEqualToString:@"问询"]) {
            return _consulting.count;
        }else if ([sysInfo[@"title"] isEqualToString:@"基本信息"]) {
            return 1;
        //验车(MWF)
        }else if ([sysInfo[@"title"] isEqualToString:@"车况报告"]) {
            return 1;
            //验车(MWF)
        }else if ([sysInfo[@"title"] isEqualToString:@"验车"]) {
            if ([self.version isEqualToString:@"1"]) {
                return self.nameArray.count;
            } else if ([self.version isEqualToString:@"2"]) {
                return self.checkCarValArray.count;
            }
        }else if ([sysInfo[@"title"] isEqualToString:@"诊断结果"]
                  || [sysInfo[@"title"] isEqualToString:@"诊断思路"]
                  || [sysInfo[@"title"] isEqualToString:@"备注"]
                  || [sysInfo[@"title"] isEqualToString:@"客户备注"]
                  || [sysInfo[@"title"] isEqualToString:@"质检不通过原因"]
                  || [sysInfo[@"title"] isEqualToString:@"质检通过时间"]
                  || [sysInfo[@"title"] isEqualToString:@"关闭原因"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"结算信息"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"报告费用"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"总费用"]) {
            return 1;
        }else if ([sysInfo[@"title"] isEqualToString:@"细检方案"]
                  || [sysInfo[@"title"] isEqualToString:@"故障信息"]
                  || [sysInfo[@"title"] isEqualToString:@"订单详情"]) {
        }else{
            //维修方式
            NSArray *repairs = sysInfo[@"value"];
            NSDictionary *modelInfo = repairs[_repairSelIndex];
            NSArray *values = modelInfo[@"model"];
            return values.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sysInfo = _sysInfos[indexPath.section];
    
    if ([sysInfo[@"title"] isEqualToString:@"上传图片"]) {
        YHSellCell *cellU = [tableView dequeueReusableCellWithIdentifier:@"cellU" forIndexPath:indexPath];
        [cellU loadInfo:nil];
        return cellU;
    }else if ([sysInfo[@"title"] isEqualToString:@"车况报告"]) {//test
        YHOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSArray *value = sysInfo[@"value"];
        [cell loadDatasource:value title:sysInfo[@"title"]];
        return cell;
    }else if ([sysInfo[@"title"] isEqualToString:@" 维修方式备注"]) {
        YHRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remarks" forIndexPath:indexPath];
        [cell loadData:_remarks];
        return cell;
    }else if ([sysInfo[@"title"] isEqualToString:@"诊断结果"]
              || [sysInfo[@"title"] isEqualToString:@"诊断思路"]
              || [sysInfo[@"title"] isEqualToString:@"备注"]
              || [sysInfo[@"title"] isEqualToString:@"客户备注"]
              || [sysInfo[@"title"] isEqualToString:@"质检不通过原因"]
              || [sysInfo[@"title"] isEqualToString:@"质检通过时间"]
              || [sysInfo[@"title"] isEqualToString:@"关闭原因"]) {
        YHOrderDetailCell *cellU = [tableView dequeueReusableCellWithIdentifier:@"cellResult" forIndexPath:indexPath];
        [cellU loadDatasourceResult:[YHTools yhStringByReplacing:sysInfo[@"value"]] title:sysInfo[@"title"]];
        return cellU;
    }else if ((_depthProjectVal.count == indexPath.row) && _isDepth) {
        YHOrderDetailCell *cellU = [tableView dequeueReusableCellWithIdentifier:@"cellAll" forIndexPath:indexPath];
        __block float priceValue = 0.0;
        for (NSDictionary *item in _depthProjectVal) {
            for (NSDictionary *subItem in (NSArray*)item[@"subSys"]) {
                NSString *price = subItem[@"price"];
                if (![price isEqualToString:@""] && price) {
                    priceValue += price.floatValue;
                }
            }
        }
        [cellU loadDatasourceResult:[NSString stringWithFormat:@"%.2f元", priceValue]];
        return cellU;
    }else{
        YHOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

        if (_isDepth){
            NSDictionary *sysItem = _depthProjectVal[indexPath.row];
            [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"] isPrice:YES isEditPrice:YES];
            return cell;
        }else{
            if ([sysInfo[@"title"] isEqualToString:@"云细检"]) {
                NSDictionary *sysItem = _cloudDepthProjectVal[indexPath.row];
                [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"] isPrice:YES isEditPrice:NO];
                return cell;
            }else  if ([sysInfo[@"title"] isEqualToString:@"细检 "]) {
                NSDictionary *sysItem = _storeDepthProjectVal[indexPath.row];
                [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"] isPrice:YES isEditPrice:NO];
                return cell;
            }else if ([sysInfo[@"title"] isEqualToString:@"细检"]) {
                NSDictionary *sysItem = _depthProjectVal[indexPath.row];
                [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"] isPrice:YES isEditPrice:NO];
                return cell;
            }else if ([sysInfo[@"title"] isEqualToString:@"工单服务进度"]) {
                NSArray *value = sysInfo[@"value"];
                [cell loadDatasource:value title:sysInfo[@"title"]];
                return cell;
            }else if ([sysInfo[@"title"] isEqualToString:@"初检"]) {
                NSDictionary *sysItem = _initialSurveyProjectVal[indexPath.row];
                [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"]];
                return cell;
            }else if ([sysInfo[@"title"] isEqualToString:@"问询"]) {
                [cell loadDatasourceConsulting:_consulting[indexPath.row]];
                return cell;
            }else if ([sysInfo[@"title"] isEqualToString:@"基本信息"]) {
                [cell loadDatasourceBaseInfo:_data[@"baseInfo"] isBlockPolicy:_data[@"isBlockPolicy"] billType:self.orderInfo[@"billType"]];
                return cell;
            //验车(MWF)
            }else if ([sysInfo[@"title"] isEqualToString:@"验车"]) {
                YHCheckCarCellA *checkCell = [tableView dequeueReusableCellWithIdentifier:@"YHCheckCarCellA"];
                if ([self.version isEqualToString:@"1"]) {
                    [checkCell refreshUIWithVersion:self.version WithImageStr:self.imageArray[indexPath.row] WithNameStr:self.nameArray[indexPath.row] WithRow:indexPath.row WithArray1:self.kejianshangArray WithArray2:self.penqiArray WithArray3:self.sechaArray WithArray4:self.banjinArray WithArray5:self.huahengArray WithArray6:self.fugaijianArray];
                } else if ([self.version isEqualToString:@"2"]) {
                    [checkCell refreshUIWithVersion:self.version WithModel:self.checkCarValArray[indexPath.row]];
                }
                return checkCell;
            }else  if ([sysInfo[@"title"] isEqualToString:@"结算信息"] || [sysInfo[@"title"] isEqualToString:@"总费用"]) {
                NSArray *value = sysInfo[@"value"];
                [cell loadDatasourceConsulting:value title:sysInfo[@"title"]];
                return cell;
            }else  if ([sysInfo[@"title"] isEqualToString:@"报告费用"]) {
                NSDictionary *value = sysInfo[@"value"];
                [cell loadreportBillData:value title:sysInfo[@"title"]];
                return cell;
            }else  if ([sysInfo[@"title"] isEqualToString:@"细检方案"]
                       || [sysInfo[@"title"] isEqualToString:@"故障信息"]
                       || [sysInfo[@"title"] isEqualToString:@"订单详情"]) {
                NSDictionary *modelInfo = sysInfo[@"value"];
                [cell loadDatasourceMode:modelInfo isShowAllPrice:![sysInfo[@"title"] isEqualToString:@"订单详情"]];
                return cell;
            }else if ([sysInfo[@"title"] hasPrefix:@"维修方式"]) {//维修方式
                NSArray *repairs = sysInfo[@"value"];
                NSDictionary *modelInfo = repairs[_repairSelIndex];
                NSArray *values = modelInfo[@"model"];
                NSDictionary *repairitem = values[indexPath.row];
                if ([repairitem[@"title"] isEqualToString:@"交车时间"]) {
                    [cell loadDatasourceTime:repairitem];
                }else if ([repairitem[@"title"] isEqualToString:@"解决方案"]) {
                    [cell loadDatasourceProgramme:repairitem];
                }else{
                    [cell loadDatasourceMode:repairitem isShowAllPrice:YES];
                }
                return cell;
            } else {
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_data) {
        return 0.;
    }
    
    if (_isDepth){
        if (_depthProjectVal.count == indexPath.row) {
            return 65;
        }else{
            
            NSDictionary *sysItem = _depthProjectVal[indexPath.row];
            NSArray *subSys = sysItem[@"subSys"];
            return 65 + subSys.count * 55;
        }
    }else{
        NSDictionary *sysInfo = _sysInfos[indexPath.section];
        if ([sysInfo[@"title"] isEqualToString:@"上传图片"]) {
            return ((80 + 20) * (1 + (((_carPictureArray.count) >= ((inch5_5)? (4) : (3)) ) ? (1) : (0) ) )) + 50;
        }else if ([sysInfo[@"title"] isEqualToString:@" 维修方式备注"]) {
            float h =[tableView fd_heightForCellWithIdentifier:@"remarks" configuration:^(YHRemarksCell* cell) {
                [cell loadData:_remarks];
            }];
            return h;
        }else if ([sysInfo[@"title"] isEqualToString:@"车况报告"]) {
            
            return 118 * [self.sysInfos.firstObject[@"value"] count];
        }else if ([sysInfo[@"title"] isEqualToString:@"诊断结果"]
                  || [sysInfo[@"title"] isEqualToString:@"诊断思路"]
                  || [sysInfo[@"title"] isEqualToString:@"备注"]
                  || [sysInfo[@"title"] isEqualToString:@"客户备注"]
                  || [sysInfo[@"title"] isEqualToString:@"质检不通过原因"]
                  || [sysInfo[@"title"] isEqualToString:@"质检通过时间"]
                  || [sysInfo[@"title"] isEqualToString:@"关闭原因"]) {
            float h =[tableView fd_heightForCellWithIdentifier:@"cellResult" configuration:^(YHOrderDetailCell* cell) {
                [cell loadDatasourceResult:[YHTools yhStringByReplacing:sysInfo[@"value"]] title:sysInfo[@"title"]];
            }];
            return h;
        }else{
            if ([sysInfo[@"title"] isEqualToString:@"云细检"]) {
                NSDictionary *sysItem = _cloudDepthProjectVal[indexPath.row];
                NSArray *subSys = sysItem[@"subSys"];
                return 65 + subSys.count * 55;
            }else  if ([sysInfo[@"title"] isEqualToString:@"细检 "]) {
                NSDictionary *sysItem = _storeDepthProjectVal[indexPath.row];
                NSArray *subSys = sysItem[@"subSys"];
                return 65 + subSys.count * 55;
            }else if ([sysInfo[@"title"] isEqualToString:@"细检"]) {
                NSDictionary *sysItem = _depthProjectVal[indexPath.row];
                NSArray *subSys = sysItem[@"subSys"];
                return 65 + subSys.count * 55;
            }else if ([sysInfo[@"title"] isEqualToString:@"工单服务进度"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSArray *value = sysInfo[@"value"];
                    [cell loadDatasource:value title:sysInfo[@"title"]];
                }];
                return h;
            }else if ([sysInfo[@"title"] isEqualToString:@"初检"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSDictionary *sysItem = _initialSurveyProjectVal[indexPath.row];
                    [cell loadDatasourceInitialSurveyProject:sysItem[@"subSys"] sysClassId:sysItem[@"sysClassId"]];
                }];
                return h;
            //问询
            }else if ([sysInfo[@"title"] isEqualToString:@"问询"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    [cell loadDatasourceConsulting:_consulting[indexPath.row]];
                }];
                return h;
            //基本信息
            }else if ([sysInfo[@"title"] isEqualToString:@"基本信息"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    [cell loadDatasourceBaseInfo:_data[@"baseInfo"] isBlockPolicy:_data[@"isBlockPolicy"] billType:self.orderInfo[@"billType"]];
                }];
                return h;
            //验车(MWF)
            }else if ([sysInfo[@"title"] isEqualToString:@"验车"]) {
                if ([self.version isEqualToString:@"1"]) {
                    return 160;
                } else if ([self.version isEqualToString:@"2"]) {
                    YHCheckCarModelA *model = self.checkCarValArray[indexPath.row];
                    if (model.projectRelativeImgList.count != 0) {
                        return 160;
                    } else {
                        return 50;
                    }
                }
            //结算信息
            }else if ([sysInfo[@"title"] isEqualToString:@"总费用"] || [sysInfo[@"title"] isEqualToString:@"结算信息"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSArray *value = sysInfo[@"value"];
                    [cell loadDatasourceConsulting:value title:sysInfo[@"title"]];
                }];
                return h;
            //报告费用
            }else if ([sysInfo[@"title"] isEqualToString:@"报告费用"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSDictionary *value = sysInfo[@"value"];
                    [cell loadreportBillData:value title:sysInfo[@"title"]];
                }];
                return h;
            }else if ([sysInfo[@"title"] isEqualToString:@"细检方案"]
                      || [sysInfo[@"title"] isEqualToString:@"故障信息"]
                      || [sysInfo[@"title"] isEqualToString:@"订单详情"]) {
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSDictionary *modelInfo = sysInfo[@"value"];
                    [cell loadDatasourceMode:modelInfo isShowAllPrice:![sysInfo[@"title"] isEqualToString:@"订单详情"]];
                }];
                return h;
            }else{
                //维修方式
                float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderDetailCell* cell) {
                    NSArray *repairs = sysInfo[@"value"];
                    NSDictionary *modelInfo = repairs[_repairSelIndex];
                    NSArray *values = modelInfo[@"model"];
                    NSDictionary *repairitem = values[indexPath.row];
                    if ([repairitem[@"title"] isEqualToString:@"交车时间"]) {
                        [cell loadDatasourceTime:repairitem];
                    }else if ([repairitem[@"title"] isEqualToString:@"解决方案"]) {
                        [cell loadDatasourceProgramme:repairitem];
                    }else{
                        [cell loadDatasourceMode:repairitem isShowAllPrice:YES];
                    }
                }];
                return h;
            }
        }
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_sysInfos.count <= section) {
        return nil;
    }
    
    NSDictionary *sysInfo = _sysInfos[section];
    if ([sysInfo[@"title"] isEqualToString:@"上传图片"]) {
        return nil;
    }else{
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        
        UIImageView *imaggeView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 22, 22)];
        [imaggeView setImage:[UIImage imageNamed:@"order_13"]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 18, 4, 12)];
        [lineView setBackgroundColor:YHNaviColor];
        
        [contentView addSubview:imaggeView];
        [contentView addSubview:lineView];
        
        if ([sysInfo[@"title"] hasPrefix:@"维修方式"]) {//维修方式
            [contentView addSubview:self.repairBox];
            [_repairBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView.mas_left).with.offset(35);
                make.top.equalTo(contentView.mas_top).with.offset(0);
                make.right.equalTo(contentView.mas_right).with.offset(0);
                make.height.equalTo(@30);
            }];
        } else if ([sysInfo[@"title"] hasPrefix:@"验车"]) {//MWF
            //左边
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, screenWidth, 22)];
            [titleL setText:sysInfo[@"title"]];
            [titleL setTextColor:YHNaviColor];
            [contentView addSubview:titleL];
            
            //右边
            if ([self.version isEqualToString:@"2"]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(screenWidth - 190, 0, 170, 20);
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitle:@"查看车辆外观标记图" forState:UIControlStateNormal];
                [button setTitleColor:YHNaviColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
                [contentView addSubview:button];
            }
        } else{
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, screenWidth, 22)];
            [titleL setText:sysInfo[@"title"]];
            [titleL setTextColor:YHNaviColor];
            [contentView addSubview:titleL];
        }
        
        if (_dethPay && _functionKey == YHFunctionIdUnprocessedOrder && section == 0) {
            UIButton *lose = [[UIButton alloc] initWithFrame:CGRectZero];
            [lose setTitle:@"忽略" forState:UIControlStateNormal];
            [lose setImage:[UIImage imageNamed:@"lose"] forState:UIControlStateNormal];
            [lose addTarget:self action:@selector(loseAction:) forControlEvents:UIControlEventTouchUpInside];
            [lose setTitleColor:YHCellColor forState:UIControlStateNormal];
            lose.titleLabel.font = [UIFont systemFontOfSize:15];
            [contentView addSubview:lose];
            
            [lose mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contentView.mas_top).with.offset(0);
                make.right.equalTo(contentView.mas_right).with.offset(-10);
                make.height.equalTo(@30);
                make.width.equalTo(@60);
            }];
        }
        return contentView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_sysInfos.count <= section) {
        return 0;
    }
    
    NSDictionary *sysInfo = _sysInfos[section];
    if ([sysInfo[@"title"] isEqualToString:@"上传图片"]) {
        return 0;
    }else {
        return 30;
    }
}

#pragma mark - 验车图片跳转(MWF)
- (void)push
{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@"%@%@/CheckCar.html?token=%@&&status=ios&billId=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk ,[YHTools getAccessToken],self.orderInfo[@"id"]];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ==========================collectionView代理方法=============================
#define ImageMaxCount 12
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return _modeInfos.count;
    }
    
    if ((_carPictureArray.count) == ImageMaxCount) {
        return ImageMaxCount;
    }
    
    return (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"] || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"]) ? (_carPictureArray.count) : (_carPictureArray.count ) + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        YHRepairCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (_modeInfos.count == 1) {
            [cell loadData:@"维修方式" isSel:(_repairSelIndex == indexPath.row)];
        }else{
            [cell loadData:[NSString stringWithFormat:@"维修方式%ld", indexPath.row + 1] isSel:(_repairSelIndex == indexPath.row)];
        }
        return cell;
    }else{
        
        YHImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellImage" forIndexPath:indexPath];
        if ((_carPictureArray.count != ImageMaxCount) && (indexPath.row == _carPictureArray.count) &&!([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"] || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"])) {
            //        [cell.imageView setImage:[UIImage imageNamed:@"addUpdata"]];
            [cell.buttonImage setImage:[UIImage imageNamed:@"addUpdata"] forState:UIControlStateNormal];
        }else{
            NSDictionary *item = _carPictureArray[indexPath.row];
            if (item[@"img"]) {
                [cell.buttonImage setImage:item[@"img"] forState:UIControlStateNormal];
            }else{
                [cell.buttonImage sd_setImageWithURL:[NSURL URLWithString:item[@"url"]]  forState:UIControlStateNormal ];
            }
            
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        _repairSelIndex = indexPath.row;
        [collectionView reloadData];
        [self.tableView reloadData];
    }else{
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"] || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"]) {
            return;
        }
        if ((_carPictureArray.count != ImageMaxCount) && (indexPath.row == _carPictureArray.count)) {
            //[self getImageAction:nil];
            [self getImageAction:[collectionView cellForItemAtIndexPath:indexPath]];
        }else{
            __weak __typeof__(self) weakSelf = self;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除图片？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                if(buttonIndex == 1){
                    [_carPictureArray removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}

#pragma mark - =================================textField代理方法===================================
//textField文本发生改变时会一直调用(MWF)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    
    if (_phoneFT == textField) {
        if ([textField.text length]>=11)
            return NO;
    }
    
    //关闭工单视图(MWF)
    if (textField == self.closeWorkListView.reasonTF) {
        self.closeWorkListView.closeButton.backgroundColor = YHNaviColor;
        return YES;
    }
    
    return YES;
}

//编辑完成时调用(MWF)
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.closeWorkListView.reasonTF) {
        if (textField.text.length == 0 ) {
            self.closeWorkListView.closeButton.backgroundColor = YHBackgroundColor;
        }
    }
}

#pragma mark - =================================textView代理方法===================================
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _timeOutResultTV) {
        ;
    }else{
        self.remarks = textView.text;
    }
}

#pragma mark - ===================================功能模块代码======================================
- (void)loseAction:(id) button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定忽略该订单吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            __weak __typeof__(self) weakSelf = self;
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             loseOrder:[YHTools getAccessToken]
             orderId:self.orderId
             onComplete:^(NSDictionary *info) {
                 
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     [[NSNotificationCenter
                       defaultCenter]postNotificationName:notificationOrderListChange
                      object:Nil
                      userInfo:nil];
                     [MBProgressHUD showSuccess:@"已忽略该订单" toView:weakSelf.navigationController.view];
                     
                     [_bottomB setBackgroundColor:YHLineColor];
                     [_bottomB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_bottomB setEnabled:YES];
                     //                     [weakSelf popViewController:nil];
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

-(void)getPhoneNumber
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送车主" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入手机号";
    txtName.delegate = self;
    
    
    NSDictionary *baseInfo = _data[@"baseInfo"];
    txtName.text = baseInfo[@"phone"];
    self.phoneFT = txtName;
    [alert show];
}

#pragma mark - Pay
- (void)payByPrepayId:(NSString*)prepayId
{
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = kMchId;
    request.prepayId= prepayId;
    request.package = @"Sign=WXPay";
    request.nonceStr= [self generateTradeNO];
    //将当前事件转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= timeStamp;
    DataMD5 *md5 = [[DataMD5 alloc] init];
    request.sign=[md5 createMD5SingForPay:kAppID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
    //            调用微信
    [WXApi sendReq:request];
}


- (void)tongzhi:(NSNotification *)text
{
    NSString * success = text.userInfo[@"Success"];
    if ([success isEqualToString:@"YES"]) {
        [self paySuccess];
    }else{
        [MBProgressHUD showError:@"支付失败！"];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [self.navigationController popViewControllerAnimated:YES];
        //        });
    }
}


#pragma mark 微信支付
///产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//将订单号使用md5加密
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//产生随机数
- (NSString *)getOrderNumber
{
    int random = arc4random()%10000;
    return [self md5:[NSString stringWithFormat:@"%d",random]];
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        //        获取txt内容即可
        if (txt.text.length == 11) {
            self.phoneNum = txt.text;
            [self bottomBAction:nil];
        }else{
            [MBProgressHUD showError:@"请输入正确手机号！" toView:self.view];
        }
    }
}

-(BOOL)priceFillAll
{
    for (NSDictionary *sysInfo in _depthProjectVal) {
        NSArray *subSys = sysInfo[@"subSys"];
        for (NSDictionary *item in subSys) {
            NSString *price = item[@"price"];
            if (!price || [price isEqualToString:@""]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)paySuccess
{
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getOrderDetail:[YHTools getAccessToken]
     orderId:self.orderId
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             //             [[NSNotificationCenter
             //               defaultCenter]postNotificationName:notificationOrderListChange
             //              object:Nil
             //              userInfo:nil];
             //             [MBProgressHUD showSuccess:@"购买成功！" toView:self.navigationController.view];
             //             _isPop2Root = YES;
             //             [weakSelf popViewController:nil];
             
//             UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//             YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
             NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
             [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//             controller.orderInfo = billStatus;
//             controller.titleStr = @"支付成功";
//             controller.pay = YES;
//             [weakSelf.navigationController pushViewController:controller animated:YES];
             
             [self submitDataSuccessToJump:billStatus pay:YES message:info[@"msg"]];
             
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 [weakSelf showErrorInfo:info];
                 YHLogERROR(@"");
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}
#pragma mark - 底部按钮Event -------
- (IBAction)bottomBAction:(id)sender
{
    __weak __typeof__(self) weakSelf = self;
    if (_isDepth) {
        if (![self priceFillAll]) {
            [MBProgressHUD showError:@"请填写报价"];
            return;
        }
        
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"]
            ) {
            
            NSMutableArray *requestData = [@[]mutableCopy];
            for (NSDictionary *sysInfo in _depthProjectVal) {
                for (NSDictionary *item in sysInfo[@"subSys"]) {
                    NSString *type = item[@"type"];
                    NSMutableDictionary *temp = [@{@"id" : item[@"id"],
                                                   @"storeQuote" : item[@"price"]}mutableCopy];
                    if (type) {
                        [temp setObject:type forKey:@"type"];
                    }
                    [requestData addObject:temp];
                }
            }
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveStoreDepthQuote:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             depthQuote:requestData
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLogERROR(@"");
                         [weakSelf showErrorInfo:info];
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];;
             }];
        }else{
            
            NSMutableArray *requestData = [@[]mutableCopy];
            for (NSDictionary *sysInfo in _depthProjectVal) {
                [requestData addObjectsFromArray:sysInfo[@"subSys"]];
            }
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveWriteDepthToCloud:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             requestData:requestData
             isPrice:YES
             onComplete:^(NSDictionary *info) {
                 
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
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
        
    }else{
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"channelSubmitMode"]) {
            __weak __typeof__(self) weakSelf = self;
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveChannelSubmitMode:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             repairModeText:_remarks
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"qualityInspection"]) {
            __weak __typeof__(self) weakSelf = self;
            
            if ([_timeOutResultTV.text isEqualToString:@""] && !_timeOutResultBox.isHidden && !(self.isNoPass)) {
                [MBProgressHUD showError:@"请输入逾期原因"];
                return;
            }
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveQualityInspection:[YHTools getAccessToken]
             orderId:self.orderInfo[@"id"]
             reqAct:((self.isNoPass)? (@"noPass") : (@"pass"))
             overdueReason:((self.isNoPass)? (@"") : (_timeOutResultTV.text))
             remarks:((self.isNoPass)? (_timeOutResultTV.text) : (@""))
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else if (((NSNumber*)info[@"code"]).integerValue == 40016) {
                     NSDictionary *data = info[@"data"];
                     [_bottomRightB setTitle:@"取消" forState:UIControlStateNormal];
                     weakSelf.timeoutL.text = [NSString stringWithFormat:@"逾期%@", data[@"overTimeText"]];
                     weakSelf.planTimeL.text = [NSString stringWithFormat:@"计划完成时间%@", data[@"giveBackTime"]];
                     weakSelf.timeOutResultBox.hidden = NO;
                     weakSelf.isNoPass = NO;
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else if ([self isPayDepth] || _dethPay) {
            if (!self.orderId) {
                self.orderId = _data[@"cloudDepthOrderId"];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认付款吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
                    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
                     orderPay:[YHTools getAccessToken]
                     orderId:weakSelf.orderId
                     onComplete:^(NSDictionary *info) {
                         if (((NSNumber*)info[@"code"]).integerValue == 20000 || ((NSNumber*)info[@"code"]).integerValue == 40017) {
                             [weakSelf paySuccess];
                         }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                             NSDictionary *data = info[@"data"];
                             NSString *wxPrepayId = data[@"wxPrepayId"];
                             [weakSelf payByPrepayId:wxPrepayId];
                         }else{
                             [MBProgressHUD hideHUDForView:self.view];
                             if(![weakSelf networkServiceCenter:info[@"code"]]){
                                 [weakSelf showErrorInfo:info];
                                 YHLogERROR(@"");
                             }
                         }
                         
                     } onError:^(NSError *error) {
                         [MBProgressHUD hideHUDForView:self.view];
                     }];
                    
                }
            }];
        }else if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]
                   || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"]
                   || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyAssessCarReport"])){
            
            
            __weak __typeof__(self) weakSelf = self;
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             addCheckReportOrder:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             onComplete:^(NSDictionary *info) {
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     NSDictionary *data = info[@"data"];
                     weakSelf.orderId = data[@"orderId"];
                     [[YHNetworkPHPManager sharedYHNetworkPHPManager]
                      orderPay:[YHTools getAccessToken]
                      orderId:weakSelf.orderId
                      onComplete:^(NSDictionary *info) {
                          [MBProgressHUD hideHUDForView:self.view];
                          if (((NSNumber*)info[@"code"]).integerValue == 20000 || ((NSNumber*)info[@"code"]).integerValue == 40017) {
                              [weakSelf paySuccess];
                          }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                              NSDictionary *data = info[@"data"];
                              NSString *wxPrepayId = data[@"wxPrepayId"];
                              [weakSelf payByPrepayId:wxPrepayId];
                          }else{
                              if(![weakSelf networkServiceCenter:info[@"code"]]){
                                  [weakSelf showErrorInfo:info];
                                  YHLogERROR(@"");
                              }
                          }
                          
                      } onError:^(NSError *error) {
                          [MBProgressHUD hideHUDForView:self.view];
                      }];
                     
                 }else if (((NSNumber*)info[@"code"]).integerValue == 40017) {
                     NSDictionary *data = info[@"data"];
                     weakSelf.orderId = data[@"orderId"];
                     [weakSelf paySuccess];
                 }else{
                     [MBProgressHUD hideHUDForView:self.view];
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmMode"]
                 ){
            __weak __typeof__(self) weakSelf = self;
            NSDictionary *modelInfo = _modeInfos[_repairSelIndex];
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveAffirmModel:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             repairModelId:modelInfo[@"id"]
             repairModeText:_remarks
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"partsApply"]
                 ){
            __weak __typeof__(self) weakSelf = self;
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             savePartsApply:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else  if([self.orderInfo[@"nextStatusCode"] isEqualToString:@"affirmComplete"]){
            
            if ([_timeOutResultTV.text isEqualToString:@""] && !_timeOutResultBox.isHidden) {
                [MBProgressHUD showError:@"请输入逾期原因"];
                return;
            }
            __weak __typeof__(self) weakSelf = self;
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveAffirmComplete:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             overdueReason:_timeOutResultTV.text
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
                     weakSelf.timeOutResultBox.hidden = YES;
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else if (((NSNumber*)info[@"code"]).integerValue == 40016) {
                     NSDictionary *data = info[@"data"];
                     weakSelf.timeoutL.text = [NSString stringWithFormat:@"逾期%@", data[@"overTimeText"]];
                     weakSelf.planTimeL.text = [NSString stringWithFormat:@"计划完成时间%@", data[@"giveBackTime"]];
                     weakSelf.timeOutResultBox.hidden = NO;
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHSettlementController *controller = [board instantiateViewControllerWithIdentifier:@"YHSettlementController"];
            controller.orderInfo = self.orderInfo;
            controller.isChild = !_childOrderInfos;
            controller.price = _data[@"totalQuote"];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushDepth"]//细检推送车主
                  || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"modeQuote"] //维修方式推送车主
                  || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]//全车检测报告推送车主
                  || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeBuyAssessCarReport"]//估车报告推送车主
                  || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告推送车主
                  || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushDepth"]//中心站推送细检方案给维修厂车主
                  
                  || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushModeScheme"]//中心站推送维修方式
                  ) {
            YHOrderPush mode = YHOrderStorePushDepth;
            if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushDepth"]//细检推送车主
                ) {
                mode = YHOrderStorePushDepth;
            }
            //            if ( [self.orderInfo[@"nowStatusCode"] isEqualToString:@"modeQuote"] //维修方式推送车主
            //                ) {
            //                mode = YHOrderStorePushMode;
            //            }
            if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushModeScheme"]//中心站推送维修方式
                ) {
                mode = YHOrderCloudPushModeScheme;
            }
            if ( [self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudPushDepth"] //中心站推送细检方案给维修厂
                ) {
                mode = YHOrderCloudPushDepth;
            }
            if ( [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]//全车检测报告推送车主
                ) {
                mode = YHOrderPushCheckReport;
            }
            if ( [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeBuyAssessCarReport"]//估车报告推送车主
                ) {
                if (!_phoneNum || [_phoneNum isEqualToString:@""]) {
                    [self getPhoneNumber];
                    return;
                }
                mode = YHOrderStorePushAssessCarReport;
            }
            if ( [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告推送车主
                ) {
                mode = YHOrderStorePushUsedCarCheckReport;
            }
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveStorePushDepth:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             phoneNumber:_phoneNum
             orderModel:mode
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     
                     if ( [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]//全车检测报告推送车主
                         || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeBuyAssessCarReport"]//估车报告推送车主
                         || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告推送车主
                         ) {
                         [[NSNotificationCenter
                           defaultCenter]postNotificationName:notificationOrderListChange
                          object:Nil
                          userInfo:nil];
                         [MBProgressHUD showError:@"推送成功！" toView:self.navigationController.view];
                         [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             if ([obj isKindOfClass:[YHOrderListController class]]) {
                                 [weakSelf.navigationController popToViewController:obj animated:YES];
                             }
                         }];
                     }else{
                         
//                         UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                         YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                         NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                         [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                         controller.orderInfo = billStatus;
//                         controller.titleStr = @"提交成功";
//                         [self.navigationController pushViewController:controller animated:YES];
                         [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
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
        }else if([self.orderInfo[@"nowStatusCode"] isEqualToString:@"storePushDepth"]
                 &&[self.orderInfo[@"nextStatusCode"] isEqualToString:@"carAffirmDepth"]//修理厂确认细检
                 ){
            
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveCarAffirmDepth:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                     
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLogERROR(@"");
                         [weakSelf showErrorInfo:info];
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];;
             }];
        }else if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"checkReportUploadPicture"]
                   || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarCheckUploadPicture"]
                   || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"assessCarUploadPicture"]
                   || ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"])
                   )){
            //            if (_arrayUrl.count == 0) {
            //                [MBProgressHUD showError:@"请选择上传图片"];
            //                return;
            //            }
            YHOrderModel model = YHOrderModelW;
            if ([self.orderInfo[@"billType"] isEqualToString:@"P"]) {
                model = YHOrderModelP;
            }else if ([self.orderInfo[@"billType"] isEqualToString:@"J"]) {
                model = YHOrderModelJ;
            }else if ([self.orderInfo[@"billType"] isEqualToString:@"E"]) {
                model = YHOrderModelE;
            }else if ([self.orderInfo[@"billType"] isEqualToString:@"V"]) {
                model = YHOrderModelV;
            }else if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]
                                 || [self.orderInfo[@"billType"] isEqualToString:@"E001"])) {
                model = YHOrderModelK;
            }
            __weak __typeof__(self) weakSelf = self;
            NSMutableArray *urls = [@[]mutableCopy];
            
            for (NSInteger i = 0; i < _carPictureArray.count; i++) {
                NSDictionary *item = _carPictureArray[i];
                if (item[@"url"] != nil) {
                    [urls addObject:item[@"url"]];
                }
            }
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             uploadWholeCarDetectivePicture:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             picPathData:urls
             orderModel:model
             isReplace:YES
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     [[NSNotificationCenter
                       defaultCenter]postNotificationName:notificationOrderListChange
                      object:Nil
                      userInfo:nil];
                     [MBProgressHUD showError:@"提交成功！" toView:self.navigationController.view];
                     __weak __typeof__(self) weakSelf = self;
                     __block BOOL isBack = NO;
                     [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         if ([obj isKindOfClass:[YHOrderListController class]]) {
                             [weakSelf.navigationController popToViewController:obj animated:YES];
                             *stop = YES;
                             isBack = YES;
                         }
                     }];
                     if (!isBack) {
                         [self popViewController:nil];
                     }
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         [weakSelf showErrorInfo:info];
                         YHLogERROR(@"");
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
                 YHLogERROR(@"");
             }];
            
        }else
            if (([self.orderInfo[@"billType"] isEqualToString:@"J"]
                 || [self.orderInfo[@"billType"] isEqualToString:@"E"]
                 || [self.orderInfo[@"billType"] isEqualToString:@"V"])
                && ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"checkReportInitialSurvey"]
                    || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarInitialSurvey"]
                    || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"assessCarInitialSurvey"]
                    || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"matchInitialSurvey"])) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
                    controller.sysData = _data;
                    controller.orderInfo = self.orderInfo;
                    controller.is_circuitry = _data[@"is_circuitry"];
                    //            controller.sysinfos = [self projects];
                    [self.navigationController pushViewController:controller animated:YES];
                } else if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]
                                 || [self.orderInfo[@"billType"] isEqualToString:@"E001"])
                           && ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"] || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurvey"] || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarInitialSurvey"])) {
                    

                    if ([self.orderInfo[@"billType"] isEqualToString:@"J002"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]) {
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:self.orderInfo[@"id"] isHistory:NO onComplete:^(NSDictionary *info) {
                            [MBProgressHUD hideHUDForView:self.view];

                            dispatch_async(dispatch_get_main_queue(), ^{

                                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                                YHInitialInspectionSysController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionSysController"];
                                _data = info[@"data"];
                                controller.sysData = _data;
                                controller.orderInfo = self.orderInfo;
                                controller.isHasPhoto = [self.orderInfo[@"billType"] isEqualToString:@"J002"];
                                [self.navigationController pushViewController:controller animated:YES];

                            });

                        } onError:^(NSError *error) {
                            [MBProgressHUD hideHUDForView:self.view];
                            if (error) {
                                NSLog(@"%@",error);
                            }
                        }];
                    }else{
                    
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                        YHInitialInspectionSysController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionSysController"];
                        controller.sysData = _data;
                        controller.orderInfo = self.orderInfo;
                        controller.isHasPhoto = [self.orderInfo[@"billType"] isEqualToString:@"J002"];
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                    
                    }
                    
                  
                } else  {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    YHSysSelController *controller = [board instantiateViewControllerWithIdentifier:@"YHSysSelController"];
                    controller.sysData = _data;
                    controller.orderInfo = self.orderInfo;
                    controller.sysinfos = [self projects];
                    controller.is_circuitry = _data[@"is_circuitry"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
        
    }
}

- (IBAction)orderEditAction:(UIButton*)sender
{
    NSArray *oil_reset_data = _data[@"oil_reset_data"];
    if (oil_reset_data) {
        [YHHUPhotoBrowser showFromImageView:nil withURLStrings:oil_reset_data placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
    }else{
        NSDictionary *menu_type = _data[@"menu_type"];
        NSString *click = menu_type[@"Bill_Undisposed_saveAssist"];
        
        NSArray *cloudDepthSysClass = _data[@"cloudDepthSysClass"];
        if (cloudDepthSysClass && cloudDepthSysClass.count > 0) {
            if ([self isPayDepth]) {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
                controller.data = self.data;
                //                controller.orderInfo= self.orderInfo;
                controller.orderId = self.data[@"cloudDepthOrderId"];
                controller.functionKey = YHFunctionIdUnprocessedOrder;
                controller.dethPay = YES;
                [self.navigationController pushViewController:controller animated:YES];
                return;
            }else{
                return;
            }
        }else{
            if ([click isEqualToString:@"click"]) {
                return;
            }
        }
        
        __weak __typeof__(self) weakSelf = self;
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         orderEdit:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         isAssist:(sender.tag == 0)
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showError:@"发起成功"];
                 [weakSelf reupdataDatasource];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

- (IBAction)turnToAction:(id)sender
{

}

#pragma mark - ===================================懒加载(MWF)======================================
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
        
        if (_kejianshangArray.count != 0) {
            [_imageArray addObject:@"icon_kejianshang"];
        }
        
        if (_penqiArray.count != 0) {
            [_imageArray addObject:@"icon_penqi"];
        }
        
        if (_sechaArray.count != 0) {
            [_imageArray addObject:@"icon_secha"];
        }
        
        if (_banjinArray.count != 0) {
            [_imageArray addObject:@"icon_banjin"];
        }
        
        if (_huahengArray.count != 0) {
            [_imageArray addObject:@"icon_huaheng"];
        }
        
        if (_fugaijianArray.count != 0) {
            [_imageArray addObject:@"icon_fugaijian"];
        }
    }
    return _imageArray;
}

- (NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [[NSMutableArray alloc]init];
        if (_kejianshangArray.count != 0) {
            [_nameArray addObject:@"可见伤"];
        }
        if (_penqiArray.count != 0) {
            [_nameArray addObject:@"有喷漆"];
        }
        if (_sechaArray.count != 0) {
            [_nameArray addObject:@"有色差"];
        }
        if (_banjinArray.count != 0) {
            [_nameArray addObject:@"钣金修复"];
        }
        if (_huahengArray.count != 0) {
            [_imageArray addObject:@"划痕"];
        }
        if (_fugaijianArray.count != 0) {
            [_nameArray addObject:@"覆盖件更换"];
        }
    }
    return _nameArray;
}

- (NSMutableArray *)checkCarValArray
{
    if (!_checkCarValArray) {
        _checkCarValArray = [[NSMutableArray alloc]init];
    }
    return _checkCarValArray;
}

- (NSMutableArray *)kejianshangArray
{
    if (!_kejianshangArray) {
        _kejianshangArray = [[NSMutableArray alloc]init];
    }
    return _kejianshangArray;
}

- (NSMutableArray *)penqiArray
{
    if (!_penqiArray) {
        _penqiArray = [[NSMutableArray alloc]init];
    }
    return _penqiArray;
}

- (NSMutableArray *)sechaArray
{
    if (!_sechaArray) {
        _sechaArray = [[NSMutableArray alloc]init];
    }
    return _sechaArray;
}

@end
