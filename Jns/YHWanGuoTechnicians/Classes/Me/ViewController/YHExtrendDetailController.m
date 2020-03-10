//
//  YHExtrendDetailController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendDetailController.h"
#import "YHExtrenImgCell.h"
#import "YHCommon.h"
#import "YHTools.h"

#import "YHNetworkPHPManager.h"
#import "UIButton+WebCache.h"
#import "YHSuccessController.h"
#import "YHHUPhotoBrowser.h"
#import "YHAgreementCell.h"
#import "YHPhotoManger.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIAlertController+Blocks.h"

#import "UIViewController+sucessJump.h"

#import "YHOrderDetailTopContainView.h"
#import "YHCarDetailCell.h"
#import "YHCarDetailHeaderView.h"


#import "YHMaintainContentView.h"


#import "YHMaintenanceContentCell.h"


typedef enum : NSUInteger {
    
    YHExtrendDetailTableViewTypeCarInfo, // 车辆信息
    YHExtrendDetailTableViewTypeCarOwnerInfo, // 车主信息
    YHExtrendDetailTableViewTypeCarProtocolInfo, // 协议信息
    YHExtrendDetailTableViewTypeCarInvoiceInfo, // 发票信息
    YHExtrendDetailTableViewTypeCarNone
    
} YHExtrendDetailTableViewType;

extern NSString *const notificationOrderListChange;
@interface YHExtrendDetailController () <UIImagePickerControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

- (IBAction)serviceTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *agreementIdF;
@property (weak, nonatomic) IBOutlet UITextField *mileageF;
@property (weak, nonatomic) IBOutlet UIView *checkKmView;
@property (weak, nonatomic) IBOutlet UILabel *currentKmL;
@property (weak, nonatomic) IBOutlet UIButton *serviceTimeB;
@property (weak, nonatomic) IBOutlet UITextField *personIdF;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (strong, nonatomic) IBOutlet UIView *invoiceV;
@property (weak, nonatomic) IBOutlet UITextField *invoiceTitleL;
@property (weak, nonatomic) IBOutlet UITextField *invoiceIdL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseInfoLC;
@property (strong, nonatomic) IBOutlet UIView *extrendAgreementV;
@property (weak, nonatomic) IBOutlet UITableView *extrendAgreementTabl;
@property (weak, nonatomic) IBOutlet UILabel *examineCaseL;
@property (strong, nonatomic)UIActionSheet *sheet;
@property (weak, nonatomic) IBOutlet UILabel *examineStatusL;
@property (weak, nonatomic) IBOutlet UIButton *salespersonB;
- (IBAction)salespersonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBLC;
@property (weak, nonatomic) IBOutlet UIButton *technicianB;
- (IBAction)technicianAction:(id)sender;
@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIImagePickerController *picker;
@property (nonatomic)YHExtendImg extendImg;
@property (strong, nonatomic)UIImage *drivingLicenseImg;@property (strong, nonatomic)UIImage *drivingLicenseBackImg;
@property (strong, nonatomic)UIImage *idFrontImg;
@property (strong, nonatomic)UIImage *idBackImg;
@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenseAdd;
@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseAddStr;
@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenseBackAdd;
@property (weak, nonatomic) IBOutlet UILabel *idAddBackStr;
@property (weak, nonatomic) IBOutlet UIImageView *idAddBack;
@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseBackAddStr;
@property (weak, nonatomic) IBOutlet UIImageView *idAdd;
@property (weak, nonatomic) IBOutlet UILabel *idAddStr;
- (IBAction)rightAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic)NSString *drivingLicenseImgStr;
@property (strong, nonatomic)NSString *drivingLicenseBackImgStr;
@property (strong, nonatomic)NSString *idFrontImgStr;
@property (strong, nonatomic)NSString *idBackImgStr;

@property (strong, nonatomic)NSString *originaldrivingLicenseImgStr;
@property (strong, nonatomic)NSString *originaldrivingLicenseBackImgStr;
@property (strong, nonatomic)NSString *originalidFrontImgStr;
@property (strong, nonatomic)NSString *originalidBackImgStr;
@property (weak, nonatomic) IBOutlet UIImageView *qaArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sellerArrow;

//@property (strong, nonatomic)NSMutableArray *agreementImgs;
//@property (strong, nonatomic)NSMutableArray *carImgs;
//@property (strong, nonatomic)NSMutableArray *agreementImgsStr;
//@property (strong, nonatomic)NSMutableArray *carImgsStr;
//@property (strong, nonatomic)NSMutableArray *originalAgreementImgsStr;
//@property (strong, nonatomic)NSMutableArray *originalCarImgsStr;
@property (strong, nonatomic)NSMutableArray *agreementPicInfo;
@property (strong, nonatomic)NSMutableArray *carPicInfo;

@property (weak, nonatomic) IBOutlet UIButton *drivingLicenseB;
@property (weak, nonatomic) IBOutlet UIButton *drivingLicenseBackB;
@property (weak, nonatomic) IBOutlet UIButton *idFrontB;
@property (weak, nonatomic) IBOutlet UIButton *idBackB;
@property (weak, nonatomic) IBOutlet UICollectionView *agreementCV;
@property (weak, nonatomic) IBOutlet UICollectionView *carImageCV;
@property (weak, nonatomic)UIView *backView;
- (IBAction)drivingLicenseAction:(id)sender;
- (IBAction)drivingLicenseBackAction:(id)sender;
- (IBAction)idFrontAction:(id)sender;
- (IBAction)idBackAction:(id)sender;
- (IBAction)drivingEXAction:(id)sender;

- (IBAction)idEXAction:(id)sender;
- (IBAction)agreementEXAction:(id)sender;
- (IBAction)carImgAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *carDetailV;
@property (strong, nonatomic) IBOutlet UIView *personInfoV;
@property (strong, nonatomic) IBOutlet UIView *agreementInfoV;

@property (strong, nonatomic) IBOutlet UIView *examineInfoV;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBox;
@property (weak, nonatomic) IBOutlet UIImageView *timeArrow;
@property (strong, nonatomic)NSDictionary *dataSource;
- (IBAction)menuActions:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuB1;
@property (weak, nonatomic) IBOutlet UIButton *menuB2;
@property (weak, nonatomic) IBOutlet UIButton *menuB3;
@property (weak, nonatomic) IBOutlet UIButton *menuB4;
@property (weak, nonatomic) IBOutlet UIButton *menuB5;
@property (weak, nonatomic) IBOutlet UILabel *menuLine1;
@property (weak, nonatomic) IBOutlet UILabel *menuLine2;
@property (weak, nonatomic) IBOutlet UILabel *menuLine3;
@property (weak, nonatomic) IBOutlet UILabel *menuLine4;
@property (weak, nonatomic) IBOutlet UILabel *menuLine5;
@property (weak, nonatomic) IBOutlet UILabel *carNumberL;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (weak, nonatomic) IBOutlet UILabel *brandL;
@property (weak, nonatomic) IBOutlet UILabel *transmissionL;//变速箱
@property (weak, nonatomic) IBOutlet UILabel *createDateL;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UILabel *checkIdL;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberL;
@property (weak, nonatomic) IBOutlet UILabel *userPersonIdL;
@property (weak, nonatomic) IBOutlet UILabel *extrendOrderL;
@property (weak, nonatomic) IBOutlet UILabel *extrendOrderPriceL;
@property (weak, nonatomic) IBOutlet UILabel *extrendTimeL;
@property (weak, nonatomic) IBOutlet UILabel *agreementIdL;

@property (nonatomic)BOOL isEditer;

@property (nonatomic)NSString *validityStr;
@property (nonatomic)NSDictionary *technicianInfo;
@property (nonatomic)NSDictionary *salespersonInfo;
@property (nonatomic)YHExtrendAgreementChoice choice;

/**************************************** VAN_MR *************************************************/

@property (nonatomic, weak) YHOrderDetailTopContainView *titleBarView;

@property (nonatomic, weak) UITableView *detailTableView;
/** 面向tableView展示的信息 */
@property (nonatomic, strong) NSMutableArray *tableViewDataArr;
/**车辆信息*/
@property (nonatomic, strong) NSMutableArray *carInfoArr;
/**车主信息*/
@property (nonatomic, strong) NSMutableArray *carOwnerArr;
/**协议信息*/
@property (nonatomic, strong) NSMutableArray *carProtocolArr;
/**发票信息*/
@property (nonatomic, strong) NSMutableArray *carInvoiceArr;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) YHCarDetailHeaderView *headView;

@property (nonatomic, weak) NSIndexPath *selectEventIndexPath;

@property (nonatomic, assign) NSInteger viewIndex;

@property (nonatomic, assign) YHExtrendDetailTableViewType type;
/** 保单号 */
@property (nonatomic, copy) NSString *protocolSerialNumber;
/** 质保公里数 */
@property (nonatomic, copy) NSString *km_number;
/** 证件号码 */
@property (nonatomic, copy) NSString *carOwner;
/** 电子邮箱 */
@property (nonatomic, copy) NSString *etc_email;
/** 选择日期 */
@property (nonatomic, copy) NSString *choiceDate;
/** 选择检测师 */
@property (nonatomic, copy) NSString *choiceCheckTeacher;
/** 选择销售员 */
@property (nonatomic, copy) NSString *choicSalePerson;
/** 保单类型 */
@property (nonatomic, copy)  NSString *sort;
/** 首保单时的公里数 */
@property (nonatomic, assign) int qualityKm;
/** 是否存在保养内容 */
@property (nonatomic, assign) BOOL isExistMaintenance;
/** 当前是否选择协议 */
@property (nonatomic, assign) BOOL isSelectProtocol;

@property (nonatomic, strong) NSMutableDictionary *maintenanceItem;

@property (nonatomic)YHExtrendModel extrendModel;

@end

@implementation YHExtrendDetailController

- (void)loadView{

    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setStatus:(NSString *)status{
    _status = status;
    NSDictionary *extrendDict = @{@"-1":@(0),@"0":@(1),@"2":@(2),@"1":@(3),@"9":@(4),@"4":@(4),@"3":@(5)};
    self.extrendModel = (YHExtrendModel)[extrendDict[status] intValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isExistMaintenance = NO;
    self.isSelectProtocol = NO;
    
    [self initExtrendDetailControllerUI];
    [self reupdataDatasource];
    return;
    
//    _isEditer = YES;
//    _drivingLicenseB.layer.borderColor  = YHNaviColor.CGColor;
//    _drivingLicenseB.layer.borderWidth  = 2;
//    _drivingLicenseBackB.layer.borderColor  = YHNaviColor.CGColor;
//    _drivingLicenseBackB.layer.borderWidth  = 2;
//
//    _idFrontB.layer.borderColor  = YHNaviColor.CGColor;
//    _idFrontB.layer.borderWidth  = 2;
//    _idBackB.layer.borderColor  = YHNaviColor.CGColor;
//    _idBackB.layer.borderWidth  = 2;
//
//    _agreementPicInfo = [@[]mutableCopy];
//    _carPicInfo = [@[]mutableCopy];
//    NSString *rightButtonStr = @"提交";
//    if (_extrendModel == YHExtrendModelUnpay) {
//        rightButtonStr = @"关闭";
//    }else if(_extrendModel == YHExtrendModelCanceled){
//        rightButtonStr = @"恢复";
//    }
//    [_rightButton setTitle:rightButtonStr forState:UIControlStateNormal];
//    [self menuState:0];
//    if (_extrendModel == YHExtrendModelUnpay || _extrendModel == YHExtrendModelCanceled) {
//        _menuBLC.constant = screenWidth / 2;
//    }else{
//        _menuBLC.constant = screenWidth / 4;
//    }
//    if (_extrendModel == YHExtrendModelAudited) {
//        [_scrollBox removeFromSuperview];
//        self.title = @"质量延长保障服务协议";
//    }else{
//        [_extrendAgreementTabl removeFromSuperview];
//    }
//
//    if (_extrendModel == YHExtrendModelAuditAotThrough) {
//        _baseInfoLC.constant = 100;
//        [self getBlockPolicyNoPasslog];
//    }else {
//        _baseInfoLC.constant = 0;
//    }
//    _extrendAgreementTabl.hidden = _extrendModel != YHExtrendModelAudited;
//    _scrollBox.hidden = _extrendModel == YHExtrendModelAudited;
//    [self reupdataDatasource];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
#pragma mark -  搜索延长保修套餐数据 ---
- (void)getBlockPolicyNoPasslog{

    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getBlockPolicyNoPasslog:[YHTools getAccessToken]
     blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
     onComplete:^(NSDictionary *info) {
        
           NSLog(@"--222--%@----%@",self.view,[NSThread currentThread]);
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [weakSelf updataInfoPolicyNoPasslog:info[@"data"]];
             [weakSelf updataInfo];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                 }
             }
         }
         [weakSelf.extrendAgreementTabl reloadData];
     } onError:^(NSError *error) {
         
     }];
}
#pragma mark - 初始化UI ---
- (void)initExtrendDetailControllerUI{
    
    YHOrderDetailTopContainView *titleBarView = [[YHOrderDetailTopContainView alloc] init];
    self.titleBarView = titleBarView;
    CGFloat topMargin = iPhoneX ? 88.0 : 64.0;
    [self.view addSubview:titleBarView];
    
    titleBarView.titleArr = @[
                              @"车辆",
                              @"车主",
                              @"协议",
                              @"发票",
                              @"证件"
                              ];
    
    [titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@(topMargin));
        make.height.equalTo(@50);
    }];
    __weak typeof(self)weakSelf = self;
    titleBarView.topButtonClickedBlock = ^(UIButton *btn) {
        
        NSInteger index = btn.tag - 999;
       
        weakSelf.detailTableView.hidden = index == 4;
        weakSelf.scrollView.hidden = !weakSelf.detailTableView.hidden;
        
        [weakSelf.view.window endEditing:YES];
        
        if (_extrendModel == YHExtrendModelAuditAotThrough) {
            
            CGFloat headerHeight = index == 0 ? 92 : 0;
            weakSelf.headView.frame = CGRectMake(0, 0, 0, headerHeight);
            weakSelf.detailTableView.tableHeaderView = weakSelf.headView;
        }
       
        weakSelf.isSelectProtocol = index == 2 ? YES : NO;
        if (index == 0) {
            weakSelf.tableViewDataArr = weakSelf.carInfoArr;
            weakSelf.type = YHExtrendDetailTableViewTypeCarInfo;
        }
        if (index == 1) {
            weakSelf.tableViewDataArr = weakSelf.carOwnerArr;
            weakSelf.type = YHExtrendDetailTableViewTypeCarOwnerInfo;
        }
        
        if (index == 2) {
            
            weakSelf.tableViewDataArr = weakSelf.carProtocolArr;
            weakSelf.type = YHExtrendDetailTableViewTypeCarProtocolInfo;
        }
        
        if (index == 3) {
            weakSelf.tableViewDataArr = weakSelf.carInvoiceArr;
            weakSelf.type = YHExtrendDetailTableViewTypeCarInvoiceInfo;
        }
        
        if (index == 4) {
             weakSelf.tableViewDataArr = [NSMutableArray array];
            [weakSelf showCertificateView];
            weakSelf.type = YHExtrendDetailTableViewTypeCarNone;
        }
        
        [weakSelf.detailTableView reloadData];
    };
    
    CGFloat bottomMargin = iPhoneX ? 34.0 : 0;
    UITableView *detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.detailTableView = detailTableView;
    [self.view addSubview:detailTableView];
    [detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.top.equalTo(titleBarView.mas_bottom).offset(10);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
    detailTableView.tableFooterView = [[UIView alloc] init];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 审核不通过
    if (_extrendModel == YHExtrendModelAuditAotThrough) {
        
        YHCarDetailHeaderView *headView = [[NSBundle mainBundle] loadNibNamed:@"YHCarDetailHeaderView" owner:nil options:nil].firstObject;
        self.headView = headView;
        headView.frame = CGRectMake(0, 0, 0, 92);
        detailTableView.tableHeaderView = headView;
        
        [self getBlockPolicyNoPasslog];
    }

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    scrollView.hidden = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(detailTableView);
        make.center.equalTo(detailTableView);
    }];
    
//    if (_extrendModel == YHExtrendModelPendingAudit) {
//        _isEditer = NO;
//    }else{
//        _isEditer = YES;
//    }
    
    _isEditer = YES;
    
    _drivingLicenseB.layer.borderColor  = YHNaviColor.CGColor;
    _drivingLicenseB.layer.borderWidth  = 2;
    _drivingLicenseBackB.layer.borderColor  = YHNaviColor.CGColor;
    _drivingLicenseBackB.layer.borderWidth  = 2;
    
    _idFrontB.layer.borderColor  = YHNaviColor.CGColor;
    _idFrontB.layer.borderWidth  = 2;
    _idBackB.layer.borderColor  = YHNaviColor.CGColor;
    _idBackB.layer.borderWidth  = 2;
    
    
    NSString *rightButtonStr = @"提交";
    if (_extrendModel == YHExtrendModelUnpay) {
        rightButtonStr = @"关闭";
    }else if(_extrendModel == YHExtrendModelCanceled){
        rightButtonStr = @"恢复";
    }
    
    [_rightButton setTitle:rightButtonStr forState:UIControlStateNormal];
    
    // 已审核协议
    [self.view addSubview:_extrendAgreementTabl];
    _extrendAgreementTabl.estimatedRowHeight = 28;
    [_extrendAgreementTabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@(bottomMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    if (_extrendModel == YHExtrendModelAudited) {
        _extrendAgreementTabl.hidden = NO;
        self.detailTableView.hidden = YES;
        self.title = @"汽车质量延长保修服务协议";
        
    }else{
        self.detailTableView.hidden = NO;
        _extrendAgreementTabl.hidden = YES;
    }
}

- (void)reupdataDatasource{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getBlockPolicyDetail:[YHTools getAccessToken]
         blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
         onComplete:^(NSDictionary *info) {
             NSLog(@"--333--%@----%@",self.view,[NSThread currentThread]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 
                 weakSelf.dataSource = info[@"data"];
                
                 [self setUpAllCarRelateInfo:info];
                 // 默认显示车辆信息
                 self.tableViewDataArr = self.carInfoArr;
                 self.type = YHExtrendDetailTableViewTypeCarInfo;
                 
                  [weakSelf updataInfo];
                 
                 [self.detailTableView reloadData];
                 
             }else {
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                         [weakSelf showErrorInfo:info];
                     }
                 }
             }
             [weakSelf.extrendAgreementTabl reloadData];
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    
//    });
   
}
#pragma mark ---初始化所有数据 ---
- (void)setUpAllCarRelateInfo:(NSDictionary *)info{
    
    self.carInfoArr = [self setUpDataSource:info];
    self.carOwnerArr = [self setUpCarOwnerInfo:info];
    self.carProtocolArr = [self setUpProtocolInfo:info];
    self.carInvoiceArr = [self setUpInvoiceInfo:info];
}
#pragma mark - 生成车辆数据源 ----
- (NSMutableArray *)setUpDataSource:(NSDictionary *)info{
    
    if (!info) {
        return nil;
    }
    
    NSDictionary *data = info[@"data"];
    // 车辆
    NSMutableArray *carDetailInfoArr = [NSMutableArray array];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableDictionary *item1 = [NSMutableDictionary dictionary];
    [item1 setValue:[NSString stringWithFormat:@"%@%@ %@",data[@"plateNumberP"],data[@"plateNumberC"],data[@"plateNumber"]] forKey:@"subTitle"];
    [item1 setValue:@"label" forKey:@"type"];
    [arr1 addObject:item1];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"车牌号码" subArr:arr1]];
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableDictionary *item2 = [NSMutableDictionary dictionary];
    [item2 setValue:data[@"vin"] forKey:@"subTitle"];
    [item2 setValue:@"label" forKey:@"type"];
    [arr2 addObject:item2];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"车架号" subArr:arr2]];
    
    NSMutableArray *arr3 = [NSMutableArray array];
    NSMutableDictionary *item3 = [NSMutableDictionary dictionary];
    [item3 setValue:[NSString stringWithFormat:@"%@ %@",data[@"carBrandName"],data[@"carLineName"]] forKey:@"subTitle"];
    [item3 setValue:@"label" forKey:@"type"];
    [arr3 addObject:item3];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"车系车型" subArr:arr3]];
    
    NSMutableArray *arr4 = [NSMutableArray array];
    NSMutableDictionary *item4 = [NSMutableDictionary dictionary];
    [item4 setValue:data[@"gearboxType"] forKey:@"subTitle"];
    [item4 setValue:@"label" forKey:@"type"];
    [arr4 addObject:item4];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"变速箱" subArr:arr4]];
    
    NSMutableArray *arr5 = [NSMutableArray array];
    NSMutableDictionary *item5 = [NSMutableDictionary dictionary];
    [item5 setValue:[NSString stringWithFormat:@"%@ 年",data[@"carYear"]] forKey:@"subTitle"];
    [item5 setValue:@"label" forKey:@"type"];
    [arr5 addObject:item5];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"生产年份" subArr:arr5]];
    
    NSMutableArray *arr6 = [NSMutableArray array];
    NSMutableDictionary *item6 = [NSMutableDictionary dictionary];
    [item6 setValue:data[@"carCc"] forKey:@"subTitle"];
    [item6 setValue:@"label" forKey:@"type"];
    [arr6 addObject:item6];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"排量" subArr:arr6]];
    
    NSMutableArray *arr7 = [NSMutableArray array];
    NSMutableDictionary *item7 = [NSMutableDictionary dictionary];
    [item7 setValue:data[@"policyNumber"] forKey:@"subTitle"];
    [item7 setValue:@"label" forKey:@"type"];
    [arr7 addObject:item7];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"电子单号" subArr:arr7]];
    
    NSMutableArray *arr8 = [NSMutableArray array];
    NSMutableDictionary *item8 = [NSMutableDictionary dictionary];
    [item8 setValue:data[@"tripDistance"] forKey:@"subTitle"];
    [item8 setValue:@"label" forKey:@"type"];
    [arr8 addObject:item8];
    [carDetailInfoArr addObject:[self infoDictWithTitle:@"当前公里数" subArr:arr8]];
    
    return carDetailInfoArr;
}
#pragma mark - 车主信息 --
- (NSMutableArray *)setUpCarOwnerInfo:(NSDictionary *)info{
    
    if (!info) {
        return nil;
    }
    NSDictionary *data = info[@"data"];
    // "sort":1 ,// 1 延保, 2 质保,3 首保
    NSString *sort = [NSString stringWithFormat:@"%@",data[@"sort"]];
    self.sort = sort;
    NSMutableArray *carOwnerArr = [NSMutableArray array];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableDictionary *item1 = [NSMutableDictionary dictionary];
    [item1 setValue:data[@"userName"] forKey:@"subTitle"];
    [item1 setValue:@"label" forKey:@"type"];
    [arr1 addObject:item1];
    [carOwnerArr addObject:[self infoDictWithTitle:@"车主" subArr:arr1]];
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableDictionary *item2 = [NSMutableDictionary dictionary];
    [item2 setValue:data[@"customerPhone"] forKey:@"subTitle"];
    [item2 setValue:@"label" forKey:@"type"];
    [arr2 addObject:item2];
    [carOwnerArr addObject:[self infoDictWithTitle:@"联系方式" subArr:arr2]];
    
    NSMutableArray *arr3 = [NSMutableArray array];
    NSMutableDictionary *item3 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item3 setValue:[NSString stringWithFormat:@"%@", data[@"cardNumber"]] forKey:@"subTitle"];
        [item3 setValue:@"label" forKey:@"type"];
         self.carOwner = [NSString stringWithFormat:@"%@", data[@"cardNumber"]];
    }else{
        
//        if ([sort isEqualToString:@"3"] && data[@"cardNumber"] && ![data[@"cardNumber"] isEqualToString:@""]) {
//
//            [item3 setValue:[NSString stringWithFormat:@"%@", data[@"cardNumber"]] forKey:@"subTitle"];
//            [item3 setValue:@"label" forKey:@"type"];
//            self.carOwner = [NSString stringWithFormat:@"%@", data[@"cardNumber"]];
//
//        }else{
        
            [item3 setValue:[NSString stringWithFormat:@"%@", data[@"cardNumber"]] forKey:@"subTitle"];
            [item3 setValue:@"请输入证件号码" forKey:@"prempt"];
            [item3 setValue:@"textfield" forKey:@"type"];
             self.carOwner = [NSString stringWithFormat:@"%@", data[@"cardNumber"]];
//        }

    }
    [arr3 addObject:item3];
    [carOwnerArr addObject:[self infoDictWithTitle:@"证件号码" subArr:arr3]];
    
    return carOwnerArr;
    
}
#pragma mark - 协议信息 --
- (NSMutableArray *)setUpProtocolInfo:(NSDictionary *)info{
    
    if (!info) {
        return nil;
    }
    
    NSDictionary *data = info[@"data"];
    NSMutableArray *protocolArr = [NSMutableArray array];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    // "sort":1 ,// 1 延保, 2 质保,3 首保 4新延长保修
    NSString *sort = [NSString stringWithFormat:@"%@",data[@"sort"]];
    if ([sort isEqualToString:@"2"] || [sort isEqualToString:@"4"]) {
        
        NSArray *maintenanceSystemList = data[@"maintenanceSystemList"];
        NSDictionary *maintenanceSystem = maintenanceSystemList.firstObject;
        NSString *systemName = maintenanceSystem[@"pid_system_name"];
        NSArray *systemNameArr = maintenanceSystem[@"maintenance_system_name"];
        for (int i = 0; i<systemNameArr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:systemNameArr[i] forKey:@"subTitle"];
            [dict setValue:@"label" forKey:@"type"];
            [arr1 addObject:dict];
        }
       
        for (int i = 0; i<maintenanceSystemList.count; i++) {
            
            if (i == 0) {
                continue;
            }
            
            NSDictionary *maintenanceSys = maintenanceSystemList[i];
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            NSString *sysName = maintenanceSys[@"pid_system_name"];
            [dict1 setValue:sysName forKey:@"subTitle"];
            [dict1 setValue:@"label" forKey:@"type"];
            [dict1 setValue:@"mainColor" forKey:@"textColor"];
            [arr1 addObject:dict1];
          
            NSArray *sysNameArr = maintenanceSys[@"maintenance_system_name"];
            for (int j = 0; j<sysNameArr.count; j++) {
                
                NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                [dict2 setValue:EmptyStr(sysNameArr[j]) forKey:@"subTitle"];
                [dict2 setValue:@"label" forKey:@"type"];
                [arr1 addObject:dict2];
            }
        }
    
       [protocolArr addObject:[self infoDictWithTitle:systemName subArr:arr1]];
        
    }else{
        NSMutableDictionary *item1 = [NSMutableDictionary dictionary];
        [item1 setValue:data[@"warrantyPackageTitle"] forKey:@"subTitle"];
        [item1 setValue:@"label" forKey:@"type"];
        [arr1 addObject:item1];
        [protocolArr addObject:[self infoDictWithTitle:@"服务套餐" subArr:arr1]];
    }
   
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableDictionary *item2 = [NSMutableDictionary dictionary];
    [item2 setValue:data[@"warrantyPackagePrice"] forKey:@"subTitle"];
    [item2 setValue:@"label" forKey:@"type"];
    [arr2 addObject:item2];
    [protocolArr addObject:[self infoDictWithTitle:@"套餐价格" subArr:arr2]];
    
    NSMutableArray *arr3 = [NSMutableArray array];
    NSMutableDictionary *item3 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item3 setValue:[NSString stringWithFormat:@"%@", data[@"validTimeName"]] forKey:@"subTitle"];
        [item3 setValue:@"label" forKey:@"type"];
    }else{
        
        if (([sort isEqualToString:@"2"] || [sort isEqualToString:@"4"]) && (data[@"validTimeName"])  && ![[NSString stringWithFormat:@"%@", data[@"validTimeName"]] isEqualToString:@""]) {
            
            [item3 setValue:[NSString stringWithFormat:@"%@", data[@"validTimeName"]] forKey:@"subTitle"];
            if ([sort isEqualToString:@"4"]) {

                  [item3 setValue:@"select" forKey:@"type"];
            }else{
                  [item3 setValue:@"label" forKey:@"type"];
            }
           
        }else if ([sort isEqualToString:@"3"]){
        
            [item3 setValue:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", data[@"validTimeName"]]] forKey:@"subTitle"];
            [item3 setValue:@"label" forKey:@"type"];
        
        }else {
           
            [item3 setValue:[NSString stringWithFormat:@"%@", data[@"validTimeName"]] forKey:@"subTitle"];
            [item3 setValue:@"请选择服务期限" forKey:@"prempt"];
            [item3 setValue:@"select" forKey:@"type"];
        }
    }
    self.choiceDate = [NSString stringWithFormat:@"%@", data[@"validTimeName"]];
    [arr3 addObject:item3];
    [protocolArr addObject:[self infoDictWithTitle:@"服务期限" subArr:arr3]];
    
    NSMutableArray *arr4 = [NSMutableArray array];
    NSMutableDictionary *item4 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item4 setValue:[NSString stringWithFormat:@"%@", data[@"agreementNumer"]] forKey:@"subTitle"];
        [item4 setValue:@"label" forKey:@"type"];
    }else{

//        if ([sort isEqualToString:@"3"] && data[@"agreementNumer"] && ![[NSString stringWithFormat:@"%@", data[@"agreementNumer"]] isEqualToString:@""]) {
//
//            [item4 setValue:[NSString stringWithFormat:@"%@", data[@"agreementNumer"]] forKey:@"subTitle"];
//            [item4 setValue:@"label" forKey:@"type"];
//
//        }else{
        
            [item4 setValue:data[@"agreementNumer"] forKey:@"subTitle"];
            [item4 setValue:@"请输入保单号" forKey:@"prempt"];
            [item4 setValue:@"textfield" forKey:@"type"];
//        }
    }
    self.protocolSerialNumber = [NSString stringWithFormat:@"%@", data[@"agreementNumer"]];
    [arr4 addObject:item4];
    [protocolArr addObject:[self infoDictWithTitle:@"保单号" subArr:arr4]];
    
    NSMutableArray *arr5 = [NSMutableArray array];
    NSMutableDictionary *item5 = [NSMutableDictionary dictionary];
   
    if (!_isEditer) {
        [item5 setValue:[NSString stringWithFormat:@"%@",data[@"carKm"]] forKey:@"subTitle"];
        [item5 setValue:@"label" forKey:@"type"];
    }else{
        
//        if ([sort isEqualToString:@"3"] && data[@"carKm"] && ![[NSString stringWithFormat:@"%@",data[@"carKm"]] isEqualToString:@""]) {
//
//            [item5 setValue:[NSString stringWithFormat:@"%@",data[@"carKm"]] forKey:@"subTitle"];
//            [item5 setValue:@"label" forKey:@"type"];
//
//        }else{
        
        if ([sort isEqualToString:@"3"]) {
            
            int qualityKm = [[NSString stringWithFormat:@"%@",data[@"qualityKm"]] intValue];
            self.qualityKm = qualityKm;
            [item5 setValue:[NSString stringWithFormat:@"%d",qualityKm] forKey:@"subTitle"];
            self.km_number = [NSString stringWithFormat:@"%d",qualityKm];
            
        }else{
             int KMNumber = [[NSString stringWithFormat:@"%@",data[@"carKm"]] intValue];
            [item5 setValue:[NSString stringWithFormat:@"%d",KMNumber] forKey:@"subTitle"];
            self.km_number = [NSString stringWithFormat:@"%@",data[@"carKm"]];
        }
        [item5 setValue:[NSString stringWithFormat:@"请输入公里数"] forKey:@"prempt"];
        [item5 setValue:@"textfield" forKey:@"type"];
        
//        }
    }
    
    [arr5 addObject:item5];
    [protocolArr addObject:[self infoDictWithTitle:@"质保公里数" subArr:arr5]];
    
    NSMutableArray *arr6 = [NSMutableArray array];
    NSMutableDictionary *item6 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item6 setValue:[NSString stringWithFormat:@"%@",data[@"qa"]] forKey:@"subTitle"];
        [item6 setValue:@"label" forKey:@"type"];
    }else{
        
//        if ([sort isEqualToString:@"3"] && data[@"qa"] && ![[NSString stringWithFormat:@"%@",data[@"qa"]] isEqualToString:@""]) {
//
//            [item6 setValue:[NSString stringWithFormat:@"%@",data[@"qa"]] forKey:@"subTitle"];
//            [item6 setValue:@"label" forKey:@"type"];
//
//        }else{
        
            [item6 setValue:[NSString stringWithFormat:@"%@",data[@"qa"]] forKey:@"subTitle"];
            [item6 setValue:@"认证技师测试" forKey:@"prempt"];
            [item6 setValue:@"select" forKey:@"type"];
//    }
}
    self.choiceCheckTeacher = [NSString stringWithFormat:@"%@",data[@"qaId"]];
    [arr6 addObject:item6];
    [protocolArr addObject:[self infoDictWithTitle:@"服务单检测师" subArr:arr6]];
    
    NSMutableArray *arr7 = [NSMutableArray array];
    NSMutableDictionary *item7 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item7 setValue:[NSString stringWithFormat:@"%@",data[@"seller"]] forKey:@"subTitle"];
        [item7 setValue:@"label" forKey:@"type"];
    }else{
        
//        if ([sort isEqualToString:@"3"] && data[@"seller"] && ![[NSString stringWithFormat:@"%@",data[@"seller"]] isEqualToString:@""]) {
//
//            [item7 setValue:[NSString stringWithFormat:@"%@",data[@"seller"]] forKey:@"subTitle"];
//            [item7 setValue:@"label" forKey:@"type"];
//
//        }else{
        
            [item7 setValue:[NSString stringWithFormat:@"%@",data[@"seller"]] forKey:@"subTitle"];
            [item7 setValue:@"认证技师测试" forKey:@"prempt"];
            [item7 setValue:@"select" forKey:@"type"];
//        }
    }
    self.choicSalePerson = [NSString stringWithFormat:@"%@",data[@"sellerId"]];
    [arr7 addObject:item7];
    [protocolArr addObject:[self infoDictWithTitle:@"服务单销售员" subArr:arr7]];
    
    // 保养内容
    if ([sort isEqualToString:@"3"]) {
        
        NSArray *careList = data[@"careList"];
        if (careList.count > 0) {
            
            self.isExistMaintenance = YES;
            
            NSMutableArray *resultArr = [NSMutableArray array];
            [resultArr addObject:protocolArr];
            [resultArr addObject:careList];
            
            NSMutableDictionary *maintenanceItem = [NSMutableDictionary dictionary];
            
            for (int i = 0; i<careList.count; i++) {
                NSDictionary *element = careList[i];
                NSArray *itemList = element[@"itemList"];
                for (int j = 0; j<itemList.count; j++) {
                    NSDictionary *item = itemList[j];
                    [maintenanceItem setValue:[NSString stringWithFormat:@"%@",item[@"checkedStatus"]]forKey:[NSString stringWithFormat:@"%@",item[@"itemId"]]];
                }
                
            }
            self.maintenanceItem = maintenanceItem;
            return resultArr;
        }
    }
    
    return protocolArr;
}
#pragma mark - 发票信息 --
- (NSMutableArray *)setUpInvoiceInfo:(NSDictionary *)info{
   
    if (!info) {
        return nil;
    }
   
    NSMutableArray *invoiceArr = [NSMutableArray array];
    NSDictionary *data = info[@"data"];
    // "sort":1 ,// 1 延保, 2 质保,3 首保
//    NSString *sort = [NSString stringWithFormat:@"%@",data[@"sort"]];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableDictionary *item1 = [NSMutableDictionary dictionary];
    [item1 setValue:data[@"userName"] forKey:@"subTitle"];
    [item1 setValue:@"label" forKey:@"type"];
    [arr1 addObject:item1];
    [invoiceArr addObject:[self infoDictWithTitle:@"发票抬头" subArr:arr1]];
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableDictionary *item2 = [NSMutableDictionary dictionary];
    if (!_isEditer) {
        [item2 setValue:[NSString stringWithFormat:@"%@", data[@"emailAddress"]] forKey:@"subTitle"];
        [item2 setValue:@"label" forKey:@"type"];
    }else{
        
//        if ([sort isEqualToString:@"3"] && data[@"emailAddress"] && [[NSString stringWithFormat:@"%@", data[@"emailAddress"]] isEqualToString:@""]) {
//
//            [item2 setValue:[NSString stringWithFormat:@"%@", data[@"emailAddress"]] forKey:@"subTitle"];
//            [item2 setValue:@"label" forKey:@"type"];
//
//        } else {
            [item2 setValue:[NSString stringWithFormat:@"%@", data[@"emailAddress"]] forKey:@"subTitle"];
            [item2 setValue:@"textfield" forKey:@"type"];
            [item2 setValue:@"请输入邮箱" forKey:@"prempt"];
//        }
    }
    [arr2 addObject:item2];
    [invoiceArr addObject:[self infoDictWithTitle:@"电子邮箱" subArr:arr2]];
    
    return invoiceArr;
}

- (NSMutableDictionary *)infoDictWithTitle:(NSString *)title subArr:(NSMutableArray<NSMutableDictionary *> *)subArr{
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setValue:title forKey:@"title"];
    [resultDict setValue:subArr forKey:@"subArr"];
    
    return resultDict;
}
#pragma mark 展示证件信息 -----
- (void)showCertificateView{
    
    self.scrollView.hidden = NO;
    self.detailTableView.hidden = YES;
   
    self.scrollView.backgroundColor = [UIColor clearColor];
    CGRect frame = _examineInfoV.frame;
    _examineInfoV.layer.cornerRadius = 4.0;
    _examineInfoV.layer.masksToBounds = YES;
    frame.size.width = self.scrollView.frame.size.width;
    
    if ([UIScreen mainScreen].bounds.size.height > 800) {
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
    }
    _examineInfoV.frame = frame;
    [self.scrollView addSubview:_examineInfoV];
    [self.scrollView setContentSize:CGSizeMake(self.detailTableView.frame.size.width, _examineInfoV.frame.size.height)];
}
#pragma mark - 展示不通过状态 -----
- (void)updataInfoPolicyNoPasslog:(NSArray*)data{
    if (data.count == 0 || !data) {
        return;
    }
    NSDictionary *fisrt = data[0];
    
    [self.headView setExamineStatusText:EmptyStr(fisrt[@"handleActs"])];
//    _examineStatusL.text = EmptyStr(fisrt[@"handleActs"]);
    [self.headView setExamineReasonText:[NSString stringWithFormat:@"原因:%@", EmptyStr(fisrt[@"handleMsg"])]];
//    _examineCaseL.text = [NSString stringWithFormat:@"原因:%@", EmptyStr(fisrt[@"handleMsg"])];
}

- (void)updataInfo{
    
//    _carNumberL.text = [NSString stringWithFormat:@"%@%@ %@", _dataSource[@"plateNumberP"],_dataSource[@"plateNumberC"],_dataSource[@"plateNumber"]];
//    _vinL.text = _dataSource[@"vin"];
//    _brandL.text = _dataSource[@"carLineName"];
//    _transmissionL.text = _dataSource[@"gearboxType"];
//    _createDateL.text =[NSString stringWithFormat:@"%@ 年", _dataSource[@"carYear"]];
//    _unitL.text = _dataSource[@"carCc"];
//    _checkIdL.text = _dataSource[@"policyNumber"];
    
    
//    _currentKmL.text = _dataSource[@"tripDistance"];
//    _userNameL.text = _dataSource[@"userName"];
//    _phoneNumberL.text = _dataSource[@"phone"];
    
//    _extrendOrderL.text = EmptyStr(_dataSource[@"warrantyPackageTitle"]);
//    _extrendOrderPriceL.text = EmptyStr(_dataSource[@"warrantyPackagePrice"]);
//    //    _extrendTimeL.text = EmptyStr(_dataSource[@"validTimeName"]);
//    _extrendTimeL.hidden = YES;
    
    NSArray *drivingImg = _dataSource[@"drivingImg"];
    NSArray *originaldrivingImg = _dataSource[@"originaldrivingImg"];
    if (drivingImg && drivingImg.count == 2) {
        
        [_drivingLicenseB sd_setBackgroundImageWithURL:[NSURL URLWithString:drivingImg[0]]  forState:UIControlStateNormal ];
        [_drivingLicenseBackB sd_setBackgroundImageWithURL:[NSURL URLWithString:drivingImg[1]]  forState:UIControlStateNormal ];
        _drivingLicenseImgStr = drivingImg[0];
        _drivingLicenseBackImgStr = drivingImg[1];
        _originaldrivingLicenseImgStr = originaldrivingImg[0];
        _originaldrivingLicenseBackImgStr = originaldrivingImg[1];
        _isEditer = NO;
    }
    
    if ([self.sort isEqualToString:@"3"] && _extrendModel == YHExtrendModelAuditAotThrough) {
        _isEditer = YES;
    }
    
    if (_extrendModel == YHExtrendModelPendingAudit) {
         _isEditer = YES;
    }
    
    _drivingLicenseAdd.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _drivingLicenseAddStr.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _drivingLicenseBackAdd.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _drivingLicenseBackAddStr.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    
    NSArray *idImg = _dataSource[@"idImg"];
    NSArray *originalidImg = _dataSource[@"originalidImg"];
    if (idImg && idImg.count == 2) {
        [_idFrontB sd_setBackgroundImageWithURL:[NSURL URLWithString:idImg[0]]  forState:UIControlStateNormal ];
        [_idBackB sd_setBackgroundImageWithURL:[NSURL URLWithString:idImg[1]]  forState:UIControlStateNormal ];
        _idFrontImgStr = idImg[0];
        _idBackImgStr = idImg[1];
        _originalidFrontImgStr = originalidImg[0];
        _originalidBackImgStr = originalidImg[1];
    }
    _idAdd.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _idAddStr.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _idAddBack.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    _idAddBackStr.hidden = !_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough);
    
    if (!_isEditer  && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
        _rightButton.hidden = YES;
    }
    
    _agreementPicInfo = [@[] mutableCopy];
    NSArray *warrantyPactImg = _dataSource[@"warrantyPactImg"];
    NSArray *originalwarrantyPactImg  = [_dataSource[@"originalwarrantyPactImg"] mutableCopy];
    for (NSUInteger i = 0; warrantyPactImg.count > i; i++) {
        [_agreementPicInfo addObject:[@{@"loc" : originalwarrantyPactImg[i],
                                        @"ser" : warrantyPactImg[i]}mutableCopy]];
    }
    
    _carPicInfo = [@[] mutableCopy];
    NSArray *carImg  = [_dataSource[@"carImg"] mutableCopy];
    NSArray *originalcarImg  = [_dataSource[@"originalcarImg"] mutableCopy];
    for (NSUInteger i = 0; carImg.count > i; i++) {
        [_carPicInfo addObject:[@{@"loc" : originalcarImg[i],
                                  @"ser" : carImg[i]}mutableCopy]];
    }
    
    
//    [@[ _personIdF,_agreementIdF,_invoiceTitleL,_invoiceIdL,_emailF,_mileageF]enumerateObjectsUsingBlock:^(UITextField *item, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        item.enabled = _isEditer || (_extrendModel == YHExtrendModelAuditAotThrough);
//        if (!_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
//            item.placeholder = @"";
//        }
//    }];
    
//    _serviceTimeB.enabled = _isEditer || (_extrendModel == YHExtrendModelAuditAotThrough);
//    if (!_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
//        _timeArrow.hidden = YES;
//        _qaArrow.hidden = YES;
//        _sellerArrow.hidden = YES;
//        NSString *carKm = _dataSource[@"carKm"];
//        if (carKm && ![carKm isEqualToString:@"0"]) {
//            [_serviceTimeB setTitle:[NSString stringWithFormat:@"%@或%@公里", EmptyStr(_dataSource[@"validTimeName"]), carKm] forState:UIControlStateNormal];
//        }else{
//            _checkKmView.hidden = YES;
//            [_serviceTimeB setTitle:EmptyStr(_dataSource[@"validTimeName"]) forState:UIControlStateNormal];
//        }
//    }else if(_extrendModel == YHExtrendModelAuditAotThrough){
//        [_serviceTimeB setTitle:EmptyStr(_dataSource[@"validTimeName"]) forState:UIControlStateNormal];
//        _validityStr = EmptyStr(_dataSource[@"validTime"]);
//    }
    
//    NSString *qaId = _dataSource[@"qaId"];
//    NSString *qa = _dataSource[@"qa"];
//    self.technicianInfo = [self getStaffById:qaId];
//    if (qa) {
//        [_technicianB setTitle:EmptyStr(qa) forState:UIControlStateNormal];
//    }
//    _technicianB.enabled = _isEditer || (_extrendModel == YHExtrendModelAuditAotThrough);
    
//    NSString *sellerId = _dataSource[@"sellerId"];
//    NSString *seller = _dataSource[@"seller"];
//    self.salespersonInfo = [self getStaffById:sellerId];
//    if (seller) {
//        [_salespersonB setTitle:EmptyStr(seller) forState:UIControlStateNormal];
//    }
//    _salespersonB.enabled = _isEditer || (_extrendModel == YHExtrendModelAuditAotThrough);
    
//    _personIdF.text = _dataSource[@"cardNumber"];
//    _agreementIdF.text= _dataSource[@"agreementNumer"];
//    _invoiceTitleL.text = _dataSource[@"invoiceTitle"];
//    _invoiceIdL.text = _dataSource[@"taxCode"];
//    _emailF.text = _dataSource[@"emailAddress"];
//    _mileageF.text =  _dataSource[@"carKm"];
    
    [_carImageCV reloadData];
    [_agreementCV reloadData];
    [self.detailTableView reloadData];
}

- (NSDictionary*)getStaffById:(NSString*)staffId{
    NSArray *staffList = _dataSource[@"staffList"];
    for (NSUInteger i = 0; staffList.count > i; i++) {
        NSDictionary *item = staffList[i];
        if ([item[@"userId"] isEqualToString:staffId]) {
            return item;
        }
    }
    return nil;
}

- (IBAction)drivingLicenseAction:(id)sender {
    _extendImg = YHExtendImgDrving;
    [self getIamge:_drivingLicenseImgStr];
    [self choosePicturn:sender];
}

- (IBAction)drivingLicenseBackAction:(id)sender{
    _extendImg = YHExtendImgDrvingBack;
    [self getIamge:_drivingLicenseBackImgStr];
    [self choosePicturn:sender];

}

- (IBAction)idFrontAction:(id)sender {
    _extendImg = YHExtendImgIdFront;
    [self getIamge:_idFrontImgStr];
    [self choosePicturn:sender];

}

- (IBAction)idBackAction:(id)sender {
    _extendImg = YHExtendImgIdBack;
    [self getIamge:_idBackImgStr];
    [self choosePicturn:sender];

}

- (IBAction)drivingEXAction:(id)sender {//示例
    [YHHUPhotoBrowser showFromImageView:nil withImages:@[[UIImage imageNamed:@"drivingEg"]] atIndex:0];
}

- (IBAction)idEXAction:(id)sender {//示例
    [YHHUPhotoBrowser showFromImageView:nil withImages:@[[UIImage imageNamed:@"idEg"]] atIndex:0];
}

- (IBAction)agreementEXAction:(id)sender {//示例
    [YHHUPhotoBrowser showFromImageView:nil withImages:@[[UIImage imageNamed:@"agreementEg"]] atIndex:0];
}

- (IBAction)carImgAction:(id)sender {//示例
    [YHHUPhotoBrowser showFromImageView:nil withImages:@[[UIImage imageNamed:@"carEg"]] atIndex:0];
}


- (void)getIamge:(NSString*)imgUrl{
    if (!_isEditer  && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
        [YHHUPhotoBrowser showFromImageView:nil withURLStrings:@[imgUrl] placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
        return;
    }
//    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                             delegate:self
//                                    cancelButtonTitle:@"取消"
//                               destructiveButtonTitle:nil
//                                    otherButtonTitles:@"从手机相册选择", @"拍照", nil];
    
    // Show the sheet
    //[self.sheet showInView:self.view];
    
}

- (void)choosePicturn:(UIView*)orgin{
    if (!_isEditer  && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
        return;
    }
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = orgin;
        popover.sourceRect = orgin.bounds;//CGRectMake(screenWidth * 0.5-50 , screenHeight * 0.5-50, 100, 100);
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        
        buttonIndex -= 2;
        
        [self takePhotoBy:buttonIndex];

    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.detailTableView && self.isExistMaintenance && self.isSelectProtocol) {
        return self.tableViewDataArr.count;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.detailTableView) {
        
        if (self.isExistMaintenance && self.isSelectProtocol) {
            NSArray *sectionArr = self.tableViewDataArr[section];
            return sectionArr.count;
        }
        return self.tableViewDataArr.count;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.detailTableView) {
        
        if (indexPath.section == 0) {
            
            static NSString *carDetailCellID = @"YHCarDetailCell_ID";
            YHCarDetailCell *carDetailCell = [tableView dequeueReusableCellWithIdentifier:carDetailCellID];
            if (carDetailCell == nil) {
                carDetailCell = [[YHCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carDetailCellID];
                carDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                __weak typeof(self)weakSelf = self;
                // 选择事件
                carDetailCell.selectEvent = ^(NSIndexPath *cellIndexPath, NSInteger viewIndex, UIButton *selectBtn) {
                    [weakSelf selectCellAlertViewHandleTableView:tableView indexPath:cellIndexPath viewIndex:viewIndex selectBtn:selectBtn];
                };
                // 输入事件
                carDetailCell.textfieldInputEvent = ^(NSString *text, NSIndexPath *cellIndexPath, NSInteger viewIndex) {
                    [weakSelf textFieldInputEventHandleTableView:tableView indexPath:cellIndexPath ViewIndex:viewIndex completeText:text];
                };
            }
            carDetailCell.indexPath = indexPath;
            
            if (self.isExistMaintenance && self.isSelectProtocol) {
                NSArray *secondArr =  self.tableViewDataArr[indexPath.section];
                carDetailCell.info = secondArr[indexPath.row];
            }else{
                
                carDetailCell.info = self.tableViewDataArr[indexPath.row];
            }
            carDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return carDetailCell;
            
        }
        // 保养内容
        static NSString *maintenanceCellId = @"maintenanceCellId";
        YHMaintenanceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:maintenanceCellId];
        if (!cell) {
            cell = [[YHMaintenanceContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:maintenanceCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        __weak typeof(self)weakSelf = self;
        cell.clickSelectMaintenanceEvent = ^(NSDictionary *itemDict) {
            for (NSString *key in itemDict.allKeys) {
                [weakSelf.maintenanceItem setValue:itemDict[key] forKey:key];
            }
        };
        cell.isCanEdit = _isEditer;
        NSArray *secondArr =  self.tableViewDataArr[indexPath.section];
        cell.info = secondArr[indexPath.row];
        cell.isLast = (indexPath.row == secondArr.count - 1);
        return cell;
    }
    
    YHAgreementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataSource[@"sort"] isEqualToString:@"3"]) {
         [cell hideInSuranceCompany:NO];
    }else{
         [cell hideInSuranceCompany:YES];
    }
   
    [cell loadData:_dataSource];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.detailTableView) {
        
        if (indexPath.section == 0) {
            CGFloat margin = 10;
            
            if (self.isSelectProtocol && self.isExistMaintenance) {
//                NSArray *secondArr = self.tableViewDataArr[indexPath.section];
//                NSDictionary *info = secondArr[indexPath.row];
//                NSArray *subArr = info[@"subArr"];
//                return 38.0 + subArr.count * 28.0 + margin;
                return UITableViewAutomaticDimension;
            }
            
            NSDictionary *cellInfo = self.tableViewDataArr[indexPath.row];
            NSArray *subArr = cellInfo[@"subArr"];
            NSLog(@"%@",cellInfo);
            return 38.0 + subArr.count * 28.0 + margin;
        }
        
        NSArray *twoSecondArr = self.tableViewDataArr[indexPath.section];
        NSDictionary *info = twoSecondArr[indexPath.row];
        NSArray *itemList = info[@"itemList"];
        return 40 + itemList.count * 30 + 10;
    }
    
    float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHAgreementCell* cell) {
        [cell loadData:_dataSource];
    }];
    return h;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [[UIView alloc] init];
    }
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]init];
         view.backgroundColor = [UIColor colorWithRed:233/255.0 green:232/255.0 blue:245/255.0 alpha:1];
         [sectionView addSubview:view];
         [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(0);
             make.left.equalTo(0);
             make.right.equalTo(0);
             make.height.equalTo(@4);
         }];
         
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.cornerRadius = 4.0;
        v.layer.masksToBounds = YES;
        [view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(@0);
             make.left.equalTo(0);
             make.right.equalTo(0);
             make.height.equalTo(@8);
        }] ;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0];
    label.text = @"保养内容";
    
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@0);
        make.centerY.equalTo(label.superview);
        make.height.equalTo(@20);
    }];
    
    UIView *sepreateL = [[UIView alloc] init];
    sepreateL.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    [sectionView addSubview:sepreateL];
    [sepreateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0.8);
        make.bottom.equalTo(sepreateL.superview);
        
    }];
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if ([self.sort isEqualToString:@"3"]) {
          return 38;
    }else{
        return 0;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 8;
//}

#pragma mark - cell输入事件处理 ---
- (void)textFieldInputEventHandleTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath ViewIndex:(NSInteger)viewIndex completeText:(NSString *)text{
    
    NSDictionary *item = nil;
    if (self.isSelectProtocol && self.isExistMaintenance) {
        NSArray *sectionArr = self.tableViewDataArr[indexPath.section];
        item = sectionArr[indexPath.row];
    }else{
        item = self.tableViewDataArr[indexPath.row];
    }
    
    if ([item[@"title"] isEqualToString:@"保单号"]) {
        self.protocolSerialNumber = text;
    }
    if ([item[@"title"] isEqualToString:@"电子邮箱"]) {
        self.etc_email = text;
    }
    if ([item[@"title"] isEqualToString:@"证件号码"]) {
        self.carOwner = text;
    }
    if ([item[@"title"] isEqualToString:@"质保公里数"]) {
        // 首保单
        if ([self.sort isEqualToString:@"3"]) {
            
            if ([text floatValue] < self.qualityKm) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"输入公里数不能小于%d公里！",self.qualityKm]];
            }
        }
 
        self.km_number = text;
    }
    NSMutableDictionary *technician = item.mutableCopy;
    NSArray *subArr = technician[@"subArr"];
    NSDictionary *viewItem = subArr[viewIndex];
    NSMutableDictionary *viewDict = viewItem.mutableCopy;
    [viewDict setValue:text forKey:@"subTitle"];
    NSMutableArray *newSubArr = subArr.mutableCopy;
    [newSubArr replaceObjectAtIndex:viewIndex withObject:viewDict];
    [technician setValue:newSubArr forKey:@"subArr"];
    
    if (self.isExistMaintenance && self.isSelectProtocol) {
        
        NSMutableArray *firstSectionArr = [self.tableViewDataArr[indexPath.section] mutableCopy];
        [firstSectionArr replaceObjectAtIndex:indexPath.row withObject:technician];
        [self.tableViewDataArr replaceObjectAtIndex:indexPath.section withObject:firstSectionArr];
        
    }else{
        [self.tableViewDataArr replaceObjectAtIndex:indexPath.row withObject:technician];
    }
    
    [self refreshRelateData];
    
    [UIView performWithoutAnimation:^{
        [self.detailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark - tableView数据变化时同步更新相关数据 ---
- (void)refreshRelateData{
    
    switch (self.type) {
        case YHExtrendDetailTableViewTypeCarInfo:
        {
            self.carInfoArr = self.tableViewDataArr.mutableCopy;
        }
            break;
        case YHExtrendDetailTableViewTypeCarOwnerInfo:
        {
            self.carOwnerArr = self.tableViewDataArr.mutableCopy;
        }
            break;
        case YHExtrendDetailTableViewTypeCarProtocolInfo:
        {
            self.carProtocolArr = self.tableViewDataArr.mutableCopy;
        }
            break;
        case YHExtrendDetailTableViewTypeCarInvoiceInfo:
        {
            self.carInvoiceArr = self.tableViewDataArr.mutableCopy;
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - cell点击选择事件处理 ---
- (void)selectCellAlertViewHandleTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath viewIndex:(NSInteger)viewIndex selectBtn:(UIButton *)selectBtn{
    
    self.selectEventIndexPath = indexPath;
    self.viewIndex = viewIndex;
    NSDictionary *item = nil;
    if (self.isSelectProtocol && self.isExistMaintenance) {
        NSArray *sectionArr = self.tableViewDataArr[indexPath.section];
        item = sectionArr[indexPath.row];
    }else{
        item = self.tableViewDataArr[indexPath.row];
    }

    if ([item[@"title"] isEqualToString:@"服务期限"]) {
        [self serviceTimeAction:selectBtn];
    }
    
    if ([item[@"title"] isEqualToString:@"服务单检测师"]) {
        [self technicianAction:selectBtn];
    }
    
    if ([item[@"title"] isEqualToString:@"服务单销售员"]) {
        [self salespersonAction:selectBtn];
    }
    
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _agreementCV) {
        if (_isEditer || (_extrendModel == YHExtrendModelAuditAotThrough)) {
            if (_agreementPicInfo.count == 4) {
                return 4;
            }
            return _agreementPicInfo.count + 1;
        }else{
            return _agreementPicInfo.count;
        }
    }else{
        if (_isEditer || (_extrendModel == YHExtrendModelAuditAotThrough)) {
            if (_carPicInfo.count == 20) {
                return 20;
            }
            return _carPicInfo.count + 1;
        }else{
            return _carPicInfo.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHExtrenImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView == _agreementCV) {
        if (_isEditer || (_extrendModel == YHExtrendModelAuditAotThrough)) {
            if (_agreementPicInfo.count == 4) {
                
                NSDictionary *item = _agreementPicInfo[indexPath.row];
                UIImage *locImage = item[@"locImg"];
                if (locImage) {/*0X20000 协议图片 */
                    [cell loadData:nil image:locImage isAdd:NO index:(0X10000 + indexPath.row)];
                }else{
                    [cell loadData:item[@"ser"] image:nil isAdd:NO index:(0X10000 + indexPath.row)];
                }
            }else{
                NSDictionary *item = ((indexPath.row == 0)? (nil) : _agreementPicInfo[indexPath.row - 1]);
                UIImage *locImage = item[@"locImg"];
                if (locImage) {
                    [cell loadData:nil image:locImage isAdd:(indexPath.row == 0) index:(0X10000 + indexPath.row)];
                }else{
                    [cell loadData:item[@"ser"] image:nil isAdd:(indexPath.row == 0) index:(0X10000 + indexPath.row)];
                }
            }
        }else{
            NSDictionary *item = _agreementPicInfo[indexPath.row];
            [cell loadData:item[@"ser"] image:nil isAdd:YES index:(0X10000 + indexPath.row)];
        }
    }else{
        if (_isEditer || (_extrendModel == YHExtrendModelAuditAotThrough)) {
            if (_carPicInfo.count == 20) {
                
                NSDictionary *item = _carPicInfo[indexPath.row];
                UIImage *locImage = item[@"locImg"];
                if (locImage) {/*0X20000 汽车图片 */
                    [cell loadData:nil image:locImage isAdd:NO index:(0X20000 + indexPath.row)];
                }else{
                    [cell loadData:item[@"ser"] image:nil isAdd:NO index:(0X20000 + indexPath.row)];
                }
            }else{
                NSDictionary *item = ((indexPath.row == 0)? (nil) : _carPicInfo[indexPath.row - 1]);
                UIImage *locImage = item[@"locImg"];
                if (locImage) {
                    [cell loadData:nil image:locImage isAdd:(indexPath.row == 0) index:(0X20000 + indexPath.row)];
                }else{
                    [cell loadData:item[@"ser"] image:nil isAdd:(indexPath.row == 0) index:(0X20000 + indexPath.row)];
                }
            }
        }else{
            NSDictionary *item = _carPicInfo[indexPath.row];
            [cell loadData:item[@"ser"] image:nil isAdd:YES index:(0X20000 + indexPath.row)];
        }
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
        
        if (collectionView == _agreementCV) {
            
            NSMutableArray *agreementPic = [@[]mutableCopy];
            for (NSDictionary *item in _agreementPicInfo) {
                [agreementPic addObject:item[@"ser"]];
            }
            [YHHUPhotoBrowser showFromImageView:nil withURLStrings:agreementPic placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
        }else{
            NSMutableArray *carPic = [@[]mutableCopy];
            
            for (NSDictionary *item in _carPicInfo) {
                [carPic addObject:item[@"ser"]];
            }
            [YHHUPhotoBrowser showFromImageView:nil withURLStrings:carPic placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
        }
        return;
    }else{
        if (collectionView == _agreementCV) {
            
            if (_agreementPicInfo.count == 4 || (_agreementPicInfo.count != 4 && indexPath.row != 0)) {
                return;
            }
            _extendImg = YHExtendImgWarrantyPact;
            [self getIamge:nil];
            
            [self choosePicturn:[collectionView cellForItemAtIndexPath:indexPath]];
        }else{
            if (_agreementPicInfo.count == 20 || (_agreementPicInfo.count != 20 && indexPath.row != 0)) {
                return;
            }
            _extendImg = YHExtendImgCar;
            [self getIamge:nil];
            [self choosePicturn:[collectionView cellForItemAtIndexPath:indexPath]];

        }
    }
}

- (IBAction)delImgAction:(UIButton*)sender {
    NSUInteger index = sender.tag;
    NSUInteger section = index >> 16;
    NSUInteger row = index & 0XFFFF;
    if (section == 1) {//协议
        
        if (_agreementPicInfo.count == 4) {
            [_agreementPicInfo removeObjectAtIndex:row];
        }else{
            [_agreementPicInfo removeObjectAtIndex:row - 1];
        }
        [_agreementCV reloadData];
    }else if (section == 2) {//车辆照片
        
        if (_carPicInfo.count == 20) {
            [_carPicInfo removeObjectAtIndex:row];
        }else{
            [_carPicInfo removeObjectAtIndex:row - 1];
        }
        [_carImageCV reloadData];
    }
}

- (IBAction)menuActions:(UIButton*)sender{
    [self menuState:sender.tag];
}

- (void)menuState:(NSUInteger)index{

    [@[_menuB1, _menuB2, _menuB3, _menuB4, _menuB5] enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [button setTitleColor:YHNaviColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
    [@[_menuLine1, _menuLine2, _menuLine3, _menuLine4, _menuLine5] enumerateObjectsUsingBlock:^(UILabel *lable, NSUInteger idx, BOOL * _Nonnull stop) {
        lable.hidden = (idx != index);
        
    }];
    
    UIView *contentView = @[_carDetailV, _personInfoV, _agreementInfoV, _invoiceV, _examineInfoV][index];
    contentView.layer.cornerRadius = 4.0;
    contentView.layer.masksToBounds = YES;
    [self.backView removeFromSuperview];
    self.backView = contentView;
    
    CGRect frame =  contentView.frame;
    frame.size.width = screenWidth;
    contentView.frame = frame;
    _scrollBox.backgroundColor = [UIColor clearColor];
    [_scrollBox addSubview:contentView];
    [_scrollBox setContentSize:CGSizeMake(screenWidth, contentView.frame.size.height)];
}

#pragma mark - 上传图片
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_sheet == actionSheet) {
        if (buttonIndex == 2) {
            return;
        }
        [self takePhotoBy:buttonIndex];
    }else{
        switch (_choice) {
            case YHExtrendAgreementChoiceDate:
            {
                NSArray *info = @[@"3", @"6", @"12"];
                NSArray *infoStr = @[@"3个月", @"6个月", @"12个月"];
                if (info.count > buttonIndex) {
                    _validityStr = info[buttonIndex];
                    _serviceTimeB.titleLabel.text = infoStr[buttonIndex];
                    [_serviceTimeB setTitle:infoStr[buttonIndex] forState:UIControlStateNormal];
                }
            }
                break;
                
            case YHExtrendAgreementChoiceTechnician:
            case YHExtrendAgreementChoiceSalesperson:
            {
                NSArray *staffList = _dataSource[@"staffList"];
                if (buttonIndex != 0) {
                    if (_choice == YHExtrendAgreementChoiceTechnician) {
                        self.technicianInfo = staffList[buttonIndex - 1];
                        if (_technicianInfo) {
                            _technicianB.titleLabel.text = EmptyStr(_technicianInfo[@"realName"]);
                            [_technicianB setTitle:EmptyStr(_technicianInfo[@"realName"]) forState:UIControlStateNormal];
                        }
                    }else{
                        self.salespersonInfo = staffList[buttonIndex - 1];
                        if (_salespersonInfo) {
                            _salespersonB.titleLabel.text = EmptyStr(_salespersonInfo[@"realName"]);
                            [_salespersonB setTitle:EmptyStr(_salespersonInfo[@"realName"]) forState:UIControlStateNormal];
                        }
                    }
                }
                
            }
                break;
        }
    }
}

//获取相片
-(void)takePhotoBy:(UIImagePickerControllerSourceType)type{
    //有相机
    if ([UIImagePickerController isSourceTypeAvailable: type]){
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.delegate = self;
        }else{
            //设置拍照后的图片可被编辑
            self.imagePicker.allowsEditing = YES;
            //        资源类型为照相机
            self.imagePicker.sourceType = type;
            self.imagePicker.delegate = self;
        }
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"无该设备"];
        NSLog(@"无该设备");
    }
}

//3.x  用户选中图片后的回调
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    
    NSLog(@"----------%@",[NSThread currentThread]);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    image = [YHPhotoManger fixOrientation:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    float imageSize = imageData.length / 1000. / 1000.;
    if (imageSize > 2.) {//上传小于2M的图
        imageData = UIImageJPEGRepresentation(image, 2.0 / imageSize);
    }
    __block  NSInteger index = -1;
    switch (_extendImg) {
        case YHExtendImgIdFront:
        {
            self.idFrontImg = image;
            [_idFrontB setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
            
        case YHExtendImgIdBack:
        {
            self.idBackImg = image;
            [_idBackB setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
            
        case YHExtendImgDrving:
        {
            self.drivingLicenseImg = image;
            [_drivingLicenseB setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        case YHExtendImgDrvingBack:
        {
            self.drivingLicenseBackImg = image;
            [_drivingLicenseBackB setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
            
        case YHExtendImgWarrantyPact:
        {
            if (!_agreementPicInfo) {
                self.agreementPicInfo = [@[]mutableCopy];
            }
            [_agreementPicInfo addObject:[@{@"locImg" : image}mutableCopy]];
            index = _agreementPicInfo.count;
            [_agreementCV reloadData];
        }
            break;
            
        case YHExtendImgCar:
        {
            if (!_carPicInfo) {
                self.carPicInfo = [@[]mutableCopy];
            }
            [_carPicInfo addObject:[@{@"locImg" : image} mutableCopy]];
            index = _carPicInfo.count;
            [_carImageCV reloadData];
        }
            break;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     uploadBlockPolicyFile:@[imageData]
     token:[YHTools getAccessToken]
     blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
     orderModel:_extendImg
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             NSDictionary *blockPolicy = data[@"blockPolicy"];
             
             switch (_extendImg) {
                 case YHExtendImgIdFront:
                 {
                     weakSelf.originalidFrontImgStr = blockPolicy[@"url"];
                 }
                     break;
                     
                 case YHExtendImgIdBack:
                 {
                     weakSelf.originalidBackImgStr = blockPolicy[@"url"];
                 }
                     break;
                     
                 case YHExtendImgDrving:
                 {
                     weakSelf.originaldrivingLicenseImgStr = blockPolicy[@"url"];
                 }
                     break;
                 case YHExtendImgDrvingBack:
                 {
                     weakSelf.originaldrivingLicenseBackImgStr = blockPolicy[@"url"];
                 }
                     break;
                     
                 case YHExtendImgWarrantyPact:
                 {
                     if (!_agreementPicInfo) {
                         weakSelf.agreementPicInfo = [@[] mutableCopy];
                     }
                     
                     if (index - 1 < weakSelf.agreementPicInfo.count) {
                          NSMutableDictionary *item = weakSelf.agreementPicInfo[index - 1];
                          [item setValue:blockPolicy[@"url"] forKey:@"loc"];
                     }
                    
                 }
                     break;
                     
                 case YHExtendImgCar:
                 {
                     
                     if (!_carPicInfo) {
                         weakSelf.carPicInfo = [@[]mutableCopy];
                     }
                     if (index - 1 < weakSelf.carPicInfo.count) {
                         NSMutableDictionary *item = weakSelf.carPicInfo[index - 1];
                         [item setValue:blockPolicy[@"url"] forKey:@"loc"];
                     }
                 }
                     break;
             }
             
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
}

////2.x  用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setValue:image forKey:@"UIImagePickerControllerOriginalImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

//// 用户选择取消
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
    self.imagePicker = nil;
}

-(UIImage*) OriginImage:(UIImage *)image   scaleToSize:(CGSize)size
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
#pragma mark - 提交数据 ---
- (IBAction)rightAction:(id)sender {
    
    [self.view.window endEditing:YES];
    
    __weak __typeof__(self) weakSelf = self;
    
    if (_extrendModel == YHExtrendModelUnpay) {
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         closeBlockPolicy:[YHTools getAccessToken]
         blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
         billId:_extrendOrderInfo[@"billId"]?_extrendOrderInfo[@"billId"]:_dataSource[@"billId"]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showSuccess:@"关闭成功！" toView:weakSelf.navigationController.view];
                 [[NSNotificationCenter
                   defaultCenter]postNotificationName:notificationOrderListChange
                  object:Nil
                  userInfo:nil];
                 [weakSelf popViewController:nil];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                     [weakSelf showErrorInfo:info];
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];;
         }];
        
    }else if(_extrendModel == YHExtrendModelCanceled){
        
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         recoveryBlockPolicy:[YHTools getAccessToken]
         blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showSuccess:@"恢复成功！" toView:weakSelf.navigationController.view];
                 [[NSNotificationCenter
                   defaultCenter]postNotificationName:notificationOrderListChange
                  object:Nil
                  userInfo:nil];
                 [weakSelf popViewController:nil];
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
        
        
        NSMutableDictionary *others = [@{}mutableCopy];
        
        if (![self.carOwner isEqualToString:@""] && self.carOwner.length >= 8 && self.carOwner.length <= 18) {
            [others setValue:self.carOwner forKey:@"cardNumber"];
        }else{
            [MBProgressHUD showError:@"请填写正确证件号码"];
            return;
        }
        if (![self.choiceDate isEqualToString:@""] && self.choiceDate) {
            
            NSString *strDate = [NSString stringWithFormat:@"%@",self.choiceDate];
            strDate = [strDate stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([strDate isEqualToString:@"1年"] || [strDate isEqualToString:@"12个月"]) {
                self.choiceDate = @"12";
            }
            if ([strDate isEqualToString:@"3个月"]) {
                self.choiceDate = @"3";
            }
            if ([strDate isEqualToString:@"6个月"]) {
                self.choiceDate = @"6";
            }
           
            [others setValue:self.choiceDate forKey:@"validTime"];
        }else{
            [MBProgressHUD showError:@"请选择服务期限"];
            return;
        }
        if (![self.protocolSerialNumber isEqualToString:@""] && self.protocolSerialNumber) {
            [others setValue:self.protocolSerialNumber forKey:@"agreementNumer"];
        }else{
            [MBProgressHUD showError:@"请填写保单号"];
            return;
        }
//        if (![_invoiceTitleL.text isEqualToString:@""]) {
//            [others setValue:_invoiceTitleL.text forKey:@"invoiceTitle"];
//        }else{
//            [MBProgressHUD showError:@"请填写发票抬头"];
//            return;
//        }
//        if (![_invoiceIdL isEqualToString:@""]) {
//            [others setValue:_invoiceIdL.text forKey:@"taxCode"];
//        }
        if (![self.etc_email isEqualToString:@""] && self.etc_email) {
            [others setValue:self.etc_email forKey:@"emailAddress"];
        }
        
        if (![self.km_number isEqualToString:@""] && self.km_number) {

            if ([self.sort isEqualToString:@"3"]) {

                if ([self.km_number intValue] < self.qualityKm) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"输入公里数不能小于%d公里！",self.qualityKm]];
                    return;
                }

                [others setValue:self.km_number forKey:@"carKm"];
            }else{
                
                 [others setValue:self.km_number forKey:@"carKm"];
            }
    
        }else{
            [MBProgressHUD showError:@"请填写公里数"];
            return;
        }
        if (![self.choiceCheckTeacher isEqualToString:@""] && self.choiceCheckTeacher) {
            [others setValue:self.choiceCheckTeacher forKey:@"qaId"];
        }else{
            [MBProgressHUD showError:@"请选择保单检测师"];
            return;
        }
        if (![self.choicSalePerson isEqualToString:@""] && self.choicSalePerson) {
            [others setValue:self.choicSalePerson forKey:@"sellerId"];
        }else{
            [MBProgressHUD showError:@"请选择保单销售员"];
            return;
        }
         
        NSMutableString *maintenanceString = [NSMutableString string];
        for (NSString *key in self.maintenanceItem.allKeys) {
            NSString *value = self.maintenanceItem[key];
            if ([value isEqualToString:@"1"]) {
                [maintenanceString appendString:key];
                [maintenanceString appendString:@","];
            }
        }
        if (maintenanceString.length > 0) {
            maintenanceString = [maintenanceString substringToIndex:maintenanceString.length - 1].mutableCopy;
            [others setValue:maintenanceString forKey:@"checkedItemIds"];
        }else{
            
        }
        
        if (!_originaldrivingLicenseImgStr) {
            [MBProgressHUD showError:@"请填上传行驶证主页"];
            return;
        }
        if (!_originaldrivingLicenseBackImgStr) {
            [MBProgressHUD showError:@"请填上传行驶证副页"];
            return;
        }
        if (!_originalidFrontImgStr) {
            [MBProgressHUD showError:@"请填上传身份证正面"];
            return;
        }
        if (!_originalidBackImgStr) {
            [MBProgressHUD showError:@"请填上传身份证背面"];
            return;
        }
        if (_agreementPicInfo.count == 0) {
            [MBProgressHUD showError:@"请填上传协议照片"];
            return;
        }
        if (_carPicInfo.count == 0) {
            [MBProgressHUD showError:@"请填上传车辆照片"];
            return;
        }
        NSMutableArray *agreementPic = [@[]mutableCopy];
        NSMutableArray *carPic = [@[]mutableCopy];
        for (NSDictionary *item in _agreementPicInfo) {
            [agreementPic addObject:item[@"loc"]];
        }
        for (NSDictionary *item in _carPicInfo) {
            [carPic addObject:item[@"loc"]];
        }
        
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         supplementBlockPolicy:[YHTools getAccessToken]
         blockPolicyId:_extrendOrderInfo[@"blockPolicyId"]
         idImg:@[_originalidFrontImgStr, _originalidBackImgStr]
         warrantyPactImg:agreementPic
         drivingImg:@[_originaldrivingLicenseImgStr, _originaldrivingLicenseBackImgStr]
         carImg:carPic
         others:others
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                 YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
//                 controller.titleStr = @"提交成功";
//                 controller.pay = YES;
//                 [self.navigationController pushViewController:controller animated:YES];
                 
                 [self submitDataSuccessToJump:nil pay:YES message:@"提交成功"];
                 
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
}
#pragma mark - 服务期限 ---
- (IBAction)serviceTimeAction:(UIButton *)sender {
    _choice = YHExtrendAgreementChoiceDate;
    if (!_isEditer && !(_extrendModel == YHExtrendModelAuditAotThrough)) {
        return;
    }
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"3个月", @"6个月", @"12个月"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;//CGRectMake(screenWidth * 0.5-50 , screenHeight * 0.5-50, 100, 100);
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        NSArray *info = @[@"3", @"6", @"12"];
        NSArray *infoStr = @[@"3个月", @"6个月", @"12个月"];
        buttonIndex -=2;
        if (info.count > buttonIndex) {
            _validityStr = info[buttonIndex];
            NSDictionary *item = nil;
            if (self.isExistMaintenance && self.isSelectProtocol) {
                NSArray *firstSectionArr = self.tableViewDataArr[self.selectEventIndexPath.section];
                item = firstSectionArr[self.selectEventIndexPath.row];
            }else{
                item = self.tableViewDataArr[self.selectEventIndexPath.row];
            }
            
            NSMutableDictionary *technician = item.mutableCopy;
            NSArray *subArr = technician[@"subArr"];
            NSDictionary *viewItem = subArr[self.viewIndex];
            NSMutableDictionary *viewDict = viewItem.mutableCopy;
            
//            _serviceTimeB.titleLabel.text = infoStr[buttonIndex];
//            [_serviceTimeB setTitle:infoStr[buttonIndex] forState:UIControlStateNormal];
            self.choiceDate = info[buttonIndex];
            [viewDict setValue:infoStr[buttonIndex] forKey:@"subTitle"];
            NSMutableArray *newSubArr = subArr.mutableCopy;
            [newSubArr replaceObjectAtIndex:self.viewIndex withObject:viewDict];
            [technician setValue:newSubArr forKey:@"subArr"];
            
            if (self.isExistMaintenance && self.isSelectProtocol) {
                
                NSMutableArray *firstSectionArr = [self.tableViewDataArr[self.selectEventIndexPath.section] mutableCopy];
                [firstSectionArr replaceObjectAtIndex:self.selectEventIndexPath.row withObject:technician];
                [self.tableViewDataArr replaceObjectAtIndex:self.selectEventIndexPath.section withObject:firstSectionArr];
                
            }else{
                [self.tableViewDataArr replaceObjectAtIndex:self.selectEventIndexPath.row withObject:technician];
            }
            
            [self refreshRelateData];
            [UIView performWithoutAnimation:^{
                 [self.detailTableView reloadRowsAtIndexPaths:@[self.selectEventIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_personIdF == textField) {
        if ([textField.text length]>=18)
            return NO;
    }
    return YES;
}
#pragma mark -- 服务技师 --
- (IBAction)technicianAction:(UIButton *)sender {
    _choice = YHExtrendAgreementChoiceTechnician;
    [self sheetShow:sender];
}
#pragma mark --服务销售 --
- (IBAction)salespersonAction:(UIButton *)sender {
    _choice = YHExtrendAgreementChoiceSalesperson;
    [self sheetShow:sender];
}

- (void)sheetShow:(UIButton *)sender{
    
    NSArray *staffList = _dataSource[@"staffList"];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSUInteger i = 0; staffList.count > i; i++) {
        
        NSDictionary *item = staffList[i];
        if (_choice == YHExtrendAgreementChoiceTechnician) {
            
            if ([[NSString stringWithFormat:@"%@",item[@"isCheck"]] isEqualToString:@"1"]) {
                [titles addObject:item[@"realName"]];
                [resultArr addObject:item];
            }
        }else{
            [titles addObject:item[@"realName"]];
        }
    }
    
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;//CGRectMake(screenWidth * 0.5-50 , screenHeight * 0.5-50, 100, 100);
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {

        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;

            buttonIndex -= 2;
        
//            NSArray *staffList = _dataSource[@"staffList"];
        NSDictionary *item = nil;
        if (self.isSelectProtocol && self.isExistMaintenance) {
            NSArray *sectionArr = self.tableViewDataArr[self.selectEventIndexPath.section];
            item = sectionArr[self.selectEventIndexPath.row];
        }else{
            item = self.tableViewDataArr[self.selectEventIndexPath.row];
        }
        
            NSMutableDictionary *technician = item.mutableCopy;
            NSArray *subArr = technician[@"subArr"];
            NSDictionary *viewItem = subArr[self.viewIndex];
            NSMutableDictionary *viewDict = viewItem.mutableCopy;
        
            if (_choice == YHExtrendAgreementChoiceTechnician) {
                self.technicianInfo = resultArr[buttonIndex];
                if (_technicianInfo) {
                    [viewDict setValue:_technicianInfo[@"realName"] forKey:@"subTitle"];
                    self.choiceCheckTeacher = _technicianInfo[@"userId"];
                }
            }else{
                self.salespersonInfo = staffList[buttonIndex];
                if (_salespersonInfo) {
                    [viewDict setValue:_salespersonInfo[@"realName"] forKey:@"subTitle"];
                    self.choicSalePerson = _salespersonInfo[@"userId"];
                }
            }
        
            NSMutableArray *newSubArr = subArr.mutableCopy;
            [newSubArr replaceObjectAtIndex:self.viewIndex withObject:viewDict];
            [technician setValue:newSubArr forKey:@"subArr"];
        
        
        if (self.isExistMaintenance && self.isSelectProtocol) {
            
            NSMutableArray *firstSectionArr = [self.tableViewDataArr[self.selectEventIndexPath.section] mutableCopy];
            [firstSectionArr replaceObjectAtIndex:self.selectEventIndexPath.row withObject:technician];
            [self.tableViewDataArr replaceObjectAtIndex:self.selectEventIndexPath.section withObject:firstSectionArr];
            
        }else{
            [self.tableViewDataArr replaceObjectAtIndex:self.selectEventIndexPath.row withObject:technician];
        }
        
            [self refreshRelateData];
        
        [UIView performWithoutAnimation:^{
              [self.detailTableView reloadRowsAtIndexPaths:@[self.selectEventIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }];
    
   
}
@end
