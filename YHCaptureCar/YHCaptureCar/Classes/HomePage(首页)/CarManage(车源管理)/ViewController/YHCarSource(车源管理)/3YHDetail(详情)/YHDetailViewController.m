//
//  YHDetailViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/3/26.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHDetailViewController.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "YHHUPhotoBrowser.h"
#import "YHNetworkManager.h"

#import <MJExtension.h>
#import <UShareUI/UShareUI.h>  //分享面板
#import <SDCycleScrollView/SDCycleScrollView.h>  //轮播图

#import "YHDetailModel0.h"
#import "YHDetailModel1.h"
#import "YHDetailModel2.h"

#import "YHAuctionDetailCell0.h"
#import "YHAuctionDetailCell1.h"

#import "YHDownShelfView.h"
#import "YHUpCaptureCarView.h"
#import "YHFailReasonView.h"
#import "YHBuyersInfoView.h"
#import "YHPayServiceFeeView.h"

#import "YHMapViewController.h"

#import "YHCaptureCarAlertView.h"
#import "YHFindOfferController.h"
#import "SPAlertController.h"
#import "SPDeatilPayView.h"

#import "YHHelpSellService.h"
#import "WXPay.h"


@interface YHDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate>


@property (nonatomic, assign) NSInteger tag;                    //页面标识tag
@property (nonatomic, assign) NSInteger bottowTag;              //底部视图tag
@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, strong) NSTimer *timer1;                           //倒计时定时器
@property (nonatomic, assign) NSTimeInterval timeInterval1;              //倒计时起始时间间隔

@property (nonatomic, strong) NSTimer *timer2;                           //竞价中当前价格定时器
@property (nonatomic, assign) NSTimeInterval timeInterval2;              //竞价中当前价格起始时间间隔

@property (nonatomic, strong) YHDetailModel0 *model0;
@property (nonatomic, strong) YHDetailModel1 *model1;
@property (nonatomic, strong) YHDetailModel2 *model2;

@property (nonatomic, strong) NSMutableArray *defineDataArray;           //信息描述数据源
@property (nonatomic, strong) NSMutableArray *dataArray0;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *downShelfButton;
@property (weak, nonatomic) IBOutlet UIButton *dropOffButton;


@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *bannerL;

@property (nonatomic, strong) UIView *headerView;               //组头
@property (nonatomic, strong) UIView *optionView;               //选项View
@property (nonatomic, strong) UIButton *optionButton;           //选项button
@property (nonatomic, strong) UIButton *selectedButton;         //选中
@property (nonatomic, strong) UIButton *unSelectedButton;       //未选中
@property (nonatomic, strong) UIView *optionLineView;           //选项View
@property (nonatomic, strong) UIView *selectedLineView;         //选中
@property (nonatomic, strong) UIView *unSelectedLineView;       //未选中

 //功能视图
@property (nonatomic, strong) UIView *functionView;

//下架视图
@property (nonatomic, weak) YHDownShelfView *downShelfView;

//上捕车视图
@property (nonatomic, weak) YHUpCaptureCarView *upCaptureCarView;

//失败原因视图
@property (nonatomic, weak) YHFailReasonView *failReasonView;

//交易信息视图
@property (nonatomic, weak) YHBuyersInfoView *buyersInfoView;

//支付服务费视图
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;

//底部视图
@property (nonatomic, strong) UIView *bottowView;

//1.帮卖详情
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UILabel *leftUpLabel1;
@property (weak, nonatomic) IBOutlet UIButton *rightUpButton1;

//2.认证检测详情
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton2;

//3.车商检测详情
@property (weak, nonatomic) IBOutlet UIView *bottomView3;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton3;

//4.设置帮卖价
@property (weak, nonatomic) IBOutlet UIView *bottomView4;
@property (weak, nonatomic) IBOutlet UITextField *leftTF4;

//5.取消帮卖
@property (weak, nonatomic) IBOutlet UIView *bottomView5;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton5;
@property (weak, nonatomic) IBOutlet UILabel *leftDowonLabel5;
@property (weak, nonatomic) IBOutlet UIButton *rightButton5;

//6.取消竞拍(待审核)
@property (weak, nonatomic) IBOutlet UIView *bottomView6;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton6;

//7.审核失败、审核不通过(查看原因)
@property (weak, nonatomic) IBOutlet UIView *bottomView7;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton7;

//8.销售成功
@property (weak, nonatomic) IBOutlet UIView *bottomView8;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton8;

//9.待安排
@property (weak, nonatomic) IBOutlet UIView *bottomView9;
@property (weak, nonatomic) IBOutlet UIButton *leftButton9;
@property (weak, nonatomic) IBOutlet UIButton *rightButton9;

//10.待开拍
@property (weak, nonatomic) IBOutlet UIView *bottomView10;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton10;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel10;
@property (weak, nonatomic) IBOutlet UIButton *rightUpButton10;
@property (weak, nonatomic) IBOutlet UILabel *rightDownLabel10;

//11.拍卖中
@property (weak, nonatomic) IBOutlet UIView *bottomView11;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton11;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel11;
@property (weak, nonatomic) IBOutlet UIButton *rightUpButton11;
@property (weak, nonatomic) IBOutlet UILabel *rightDownLabel11;

//12.流拍
@property (weak, nonatomic) IBOutlet UIView *bottomView12;
@property (weak, nonatomic) IBOutlet UIButton *leftUpButton12;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel12;
@property (weak, nonatomic) IBOutlet UIButton *rightButton12;

//13.服务费待支付
@property (weak, nonatomic) IBOutlet UIView *bottomView13;
@property (weak, nonatomic) IBOutlet UILabel *leftUpLabel13;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel13;
@property (weak, nonatomic) IBOutlet UIButton *rightButton13;

//14.服务费已支付
@property (weak, nonatomic) IBOutlet UIView *bottomView14;
@property (weak, nonatomic) IBOutlet UILabel *leftUpLabel14;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel14;
@property (weak, nonatomic) IBOutlet UIButton *rightButton14;

//15.已下架
@property (weak, nonatomic) IBOutlet UIView *bottomView15;

//16.竞拍结束
@property (weak, nonatomic) IBOutlet UIView *bottomView16;

//分享地址,分享title,分享副标题,分享图片地址
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *titles;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIView *priceInputView;
@property (weak, nonatomic) IBOutlet UIView *priceInputView2;
@property (weak, nonatomic) IBOutlet SPDeatilPayView *detailPayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView5OfferedWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView1CollectWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView1PayWidth;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;

@end

@implementation YHDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer1 invalidate];
    self.timer1 = nil;
    
    [self.timer2 invalidate];
    self.timer2 = nil;
}

#pragma mark - --------------------------------------一、加载UI------------------------------------------
- (void)initUI
{
    self.tag = 1;
    
    //1.导航栏
    //(1).标题
    if (!self.title) {
        self.navigationItem.title = self.jumpString;
    }
    
    self.dropOffButton.hidden = ![self.jumpString isEqualToString:@"在库车辆详情"];
    
    //(2).按钮
    if ([self.jumpString isEqualToString:@"在库车辆详情"] && ((self.carModel.carStatus == 0) || (self.carModel.carStatus == 2))) {///** 状态 0 库存  1 拍卖  2 帮卖  */
        self.downShelfButton.hidden = NO; //下架
    } else {
        self.downShelfButton.hidden = YES;
    }
    
    //2.webView还是tableView
    if ([self.jumpString isEqualToString:@"帮检详情"]) {
        //(1)初始化状态栏
        [self initBarView];
        
        //(2)隐藏系统导航栏
        [self.navigationController setNavigationBarHidden:YES animated:NO];

        //(3)隐藏中部视图
        self.tableView.hidden = YES;
        
        //(4)隐藏底部视图
        self.bottowView.hidden = YES;

        //(5)打开webView
        self.webView.hidden = NO;
        self.webViewBottomConstraint.constant = 0;
        
        //(6)加载webView:http://192.168.1.200/bucheService/report.html?code=334c17965ed148c9ab9f633a980e00f2&isInfoEnter=0&status=ios&version=3
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/report.html?code=%@&isInfoEnter=0&status=ios&version=3", self.rptCode]]]];
        
        NSLog(@"===>%@",[NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/report.html?code=%@&isInfoEnter=0&status=ios&version=3", self.rptCode]);
    } else {
        if (self.carModel.flag == 1) {/** 是否是认证检测  0 不是 1 是  */
            self.webView.hidden = NO;
            self.tableView.hidden = YES;
        } else {
            self.webView.hidden = YES;
            self.tableView.hidden = NO;
            [self initTableView];
        }
    }
    
    //3.底部视图
    self.bottomView1.hidden = YES;
    self.bottomView2.hidden = YES;
    self.bottomView3.hidden = YES;
    self.bottomView4.hidden = YES;
    self.bottomView5.hidden = YES;
    self.bottomView6.hidden = YES;
    self.bottomView7.hidden = YES;
    self.bottomView8.hidden = YES;
    self.bottomView9.hidden = YES;
    self.bottomView10.hidden = YES;
    self.bottomView11.hidden = YES;
    self.bottomView12.hidden = YES;
    self.bottomView13.hidden = YES;
    self.bottomView14.hidden = YES;
    self.bottomView15.hidden = YES;
    self.bottomView16.hidden = YES;
}

#pragma mark - 1.initBarView
- (void)initBarView
{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ((IphoneX)? (44) : (20)))];
    statusBarView.backgroundColor = YHNaviColor;
    [self.view addSubview:statusBarView];
}

#pragma mark - 2.initTableView
- (void)initTableView
{
    //(1).init表头
    [self initHeaderView];
    
    //(2).initCell
    [self initCell];
    
    //(3).init手势
    [self initGesture];
}

#pragma mark - (1).init表头
- (void)initHeaderView
{
    //图片
    self.bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth*(360./750.0))];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    self.bannerView.autoScrollTimeInterval = 4.;
    self.bannerView.delegate = self;
    self.bannerView.backgroundColor = YHLineColor;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableHeaderView = self.bannerView;
    
    //标题
    self.bannerL = [[UILabel alloc]initWithFrame:CGRectMake(0, screenWidth*(360./750.0)-40, screenWidth, 40)];
    self.bannerL.textAlignment = NSTextAlignmentCenter;
    self.bannerL.textColor = YHWhiteColor;
    [self.bannerView addSubview:self.bannerL];
    

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *imagesStringsArray = [@[]mutableCopy];
    if (!IsEmptyStr(self.model0.carPicture)) {
        NSArray *carPictureArray = [self.model0.carPicture componentsSeparatedByString:@","];
        for (NSString *str in carPictureArray) {
            [imagesStringsArray addObject:[YHTools hmacsha1YH:str width:(long)0]];
        }
    } else {
        //[MBProgressHUD showError:@"图片字段为空"];
    }
    
    [YHHUPhotoBrowser showFromImageView:nil withURLStrings:imagesStringsArray placeholderImage:[UIImage imageNamed:@"icon_auctionDetailBanner"] atIndex:0 dismiss:^(UIImage *image, NSInteger index) {
        
    }];
}

#pragma mark - (2).initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHAuctionDetailCell0" bundle:nil] forCellReuseIdentifier:@"YHAuctionDetailCell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHAuctionDetailCell1" bundle:nil] forCellReuseIdentifier:@"YHAuctionDetailCell1"];
}

#pragma mark - (3).init手势
- (void)initGesture
{
    //左滑
    UISwipeGestureRecognizer *s1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clicks:)];
    s1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:s1];
    
    //右滑
    UISwipeGestureRecognizer *s2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clicks:)];
    s2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:s2];
}

#pragma mark - (1).手势切换
- (void)clicks:(UISwipeGestureRecognizer *)s
{
    if (s.direction == UISwipeGestureRecognizerDirectionRight){
        self.tag = 1;
        [UIView animateWithDuration:1.0 animations:^{
            [self.selectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = NO;
            self.unSelectedLineView.hidden = YES;
        }];
    } else if (s.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.tag = 2;
        [UIView animateWithDuration:1.0 animations:^{
            [self.selectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = YES;
            self.unSelectedLineView.hidden = NO;
        }];
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - (2).点击切换
- (void)clickSelectBtn:(UIButton *)b
{
    self.tag = b.tag;
    switch (b.tag) {
        case 1:
        {
            [self.selectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = NO;
            self.unSelectedLineView.hidden = YES;
        }
            break;
        case 2:
        {
            [self.selectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = YES;
            self.unSelectedLineView.hidden = NO;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - -----------------------------------tableView代理方法----------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag == 1) {
        return self.dataArray0.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHAuctionDetailCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHAuctionDetailCell0"];
    YHAuctionDetailCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"YHAuctionDetailCell1"];
    
    if (self.tag == 1) {
        [cell0 refreshUIWithDefineDataArray:self.defineDataArray WithValueArray:self.dataArray0 WithRow:indexPath.row];
        if (!IsEmptyStr(self.model0.address)) {
            for (NSInteger i = 0; i < self.dataArray0.count; i++) {
                if ([self.dataArray0[i] isEqualToString:self.model0.address]) {
                    if (i == indexPath.row) {
                        cell0.landmarkImageView.hidden = NO;
                        cell0.landmarkImageView.image = [UIImage imageNamed:@"icon_landmark"];
                    } else {
                        cell0.landmarkImageView.hidden = YES;
                    }
                }
            }
        }
        if (!IsEmptyStr(self.model0.phone)) {
            for (NSInteger i = 0; i < self.dataArray0.count; i++) {
                if ([self.dataArray0[i] isEqualToString:self.model0.phone]) {
                    if (i == indexPath.row) {
                        cell0.landmarkImageView.hidden = NO;
                        cell0.landmarkImageView.image = [UIImage imageNamed:@"icon_IPhone"];
                    }
                }
            }
        }
        return cell0;
    } else {
        if (!IsEmptyStr(self.model0.carCaseDesc)) {
            cell1.textView.text = self.model0.carCaseDesc;
        } else {
            cell1.textView.text = @"该车暂无车况描述";
        }
        return cell1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag == 1) {
        return 50;
    } else {
        return 250;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat selectWidth = (screenWidth-1)/2;
    CGFloat selectHeight = 50;
    CGFloat underLineWidth = (screenWidth-1)/2;
    CGFloat underLineHeight = 2;
    NSArray *selectArray = @[@"车辆信息",@"车况描述"];
    
    //整个组头视图
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 55)];
        self.headerView.backgroundColor = YHBackgroundColor;
        //选项view
        for (int i = 0; i < 2; i++) {
            self.optionView = [[UIView alloc]initWithFrame:CGRectMake((screenWidth/2)*i, 0, selectWidth, selectHeight)];
            [self.headerView addSubview:self.optionView];
            
            //1.选项button
            self.optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.optionButton.tag = i+1;
            self.optionButton.backgroundColor = YHWhiteColor;
            self.optionButton.frame = CGRectMake(0, 0, selectWidth, selectHeight-underLineHeight);
            [self.optionButton setTitle:selectArray[i] forState:UIControlStateNormal];
            if (i == 0) {
                [self.optionButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
                self.selectedButton = self.optionButton;
            } else {
                [self.optionButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
                self.unSelectedButton = self.optionButton;
            }
            [self.optionButton addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.optionView addSubview:self.optionButton];
            
            //2.下划线
            self.optionLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.optionButton.frame), underLineWidth, underLineHeight)];
            self.optionLineView.backgroundColor = YHNaviColor;
            if (i == 0) {
                self.optionLineView.hidden = NO;
                self.selectedLineView = self.optionLineView;
            } else {
                self.optionLineView.hidden = YES;
                self.unSelectedLineView = self.optionLineView;
            }
            [self.optionView addSubview:self.optionLineView];
        }
    }
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!IsEmptyStr(self.model0.address)) {
        for (NSInteger i = 0; i < self.dataArray0.count; i++) {
            if ([self.dataArray0[i] isEqualToString:self.model0.address]) {
                if (i == indexPath.row) {
                    YHMapViewController *VC = [[YHMapViewController alloc]init];
                    VC.isNavi = YES;
                    VC.addrStr = self.model0.address;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } else if ([self.dataArray0[i] isEqualToString:self.model0.phone]) {
                if (i == indexPath.row) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc]initWithFormat:@"tel:%@",self.model0.phone]]];
                }
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - --------------------------------------二、加载数据---------------------------------------------
- (void)initData
{
    [self initData1];
}

//FIXME:  车辆详情
- (void)initData1
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]requestCarDetailsWithToken:[YHTools getAccessToken] carId:self.carModel.carId onComplete:^(NSDictionary *info) {
        NSLog(@"\n1=======>%@<=======>%@<=======",info,info[@"retMsg"]);
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            weakSelf.model0 = [YHDetailModel0 mj_objectWithKeyValues:info[@"result"]];
            
            
//            weakSelf.model0.parStatus = 1;
////            weakSelf.model0.isOffer = YES;
////            weakSelf.model0.buyerPrice = @"88";
////            weakSelf.model0.brokerage = @"88";

            [weakSelf refreshMiddleUI];
            [weakSelf refreshBottowUI];
            if (!IsEmptyStr(weakSelf.model0.auctionId)) {
                [weakSelf initData2];
            }
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
    
    
    if (self.carModel.flag && self.carModel.carStatus == 0) {
        [YHHelpSellService findSuggestPriceWithCarId:self.carModel.carId type:0 onComplete:^(NSString *suggestPrice, BOOL isEnquiry) {
            weakSelf.carModel.suggestPrice = suggestPrice;
            weakSelf.carModel.isEnquiry = isEnquiry;
        } onError:nil];
    }
}

//FIXME:  -  获取竞拍状态，成交价格，买家信息，支付服务费
- (void)initData2
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]auctionEndWithToken:[YHTools getAccessToken] auctionId:self.model0.auctionId onComplete:^(NSDictionary *info) {
        NSLog(@"\n2=======>%@<=======>%@<=======",info,info[@"retMsg"]);
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            weakSelf.model1 = [YHDetailModel1 mj_objectWithKeyValues:info[@"result"]];
            weakSelf.model2 = weakSelf.model1.buyInfo;
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 刷新中部视图UI
- (void)refreshMiddleUI
{
    //http://192.168.1.200/bucheService/report.html?isShare=1&code=
    //https://www.51buche.com/bucheService/report.html?isShare=1&code=
    //http://192.168.1.200/bucheService/report.html?code=%@&isInfoEnter=1&status=ios
    if ([self.jumpString isEqualToString:@"帮检详情"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/report.html?code=%@&isInfoEnter=1&status=ios", self.rptCode]]]];
    } else {
        //1.webView显示
        if (self.carModel.flag == 1) { // 认证
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/report.html?code=%@&isInfoEnter=1&status=ios", self.model0.url]]]];
        //2.tableView显示
        } else { // 非认证
            //(1).刷新轮播图
            //轮播图图片
            if (!IsEmptyStr(self.model0.carPicture)) {
                NSArray *carPictureArray = [self.model0.carPicture componentsSeparatedByString:@","];
                NSMutableArray *imagesStringsArray = [@[]mutableCopy];
                for (NSString *str in carPictureArray) {
                    [imagesStringsArray addObject:[YHTools hmacsha1YH:str width:(long)screenWidth]];
                }
                self.bannerView.imageURLStringsGroup = imagesStringsArray;
            } else {
                self.bannerView.localizationImageNamesGroup = @[@"icon_auctionDetailBanner"];
            }
            
            //轮播图标题
            if (!IsEmptyStr(self.model0.carNo) && (!IsEmptyStr(self.model0.fullName) || !IsEmptyStr(self.model0.carName) || !IsEmptyStr(self.model0.desc))) {
                if (!IsEmptyStr(self.model0.fullName)) {
                    self.bannerL.text = [NSString stringWithFormat:@"NO.%@%@",self.model0.carNo,self.model0.fullName];
                } else if (!IsEmptyStr(self.model0.carName)) {
                    self.bannerL.text = [NSString stringWithFormat:@"NO.%@%@",self.model0.carNo,self.model0.carName];
                } else if (!IsEmptyStr(self.model0.desc)) {
                    self.bannerL.text = [NSString stringWithFormat:@"NO.%@%@",self.model0.carNo,self.model0.desc];
                }
            } else {
                self.bannerL.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void)verticalImageAndTitleButton:(UIButton *)btn verticalSpacing:(CGFloat)spacing
{
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}


#pragma mark - 刷新底部视图UI
- (void)refreshBottowUI
{
    NSLog(@"=跳转界面:%@=列表状态:%ld=检测状态:%d=待审核状态:%@=",self.jumpString,self.carModel.carStatus,self.carModel.flag,self.model0.autditStatus);
    

    //[MBProgressHUD showSuccess:[NSString stringWithFormat:@"=列表:%ld=检测:%d=审核:%@=",self.carModel.status,self.carModel.flag,self.model0.autditStatus]];
    
    //[MBProgressHUD showError:[NSString stringWithFormat:@"详情页:%ld=列价:%@=模价:%@",self.bottowTag,self.carModel.price,self.model0.price]];

    //(1)确定底部视图的tag值
    if ([self.jumpString isEqualToString:@"帮卖详情"]) {//帮买／帮卖进来的／我的收藏／搜索
        
        self.bottowTag = self.bottomView1.tag;
        
    } else if ([self.jumpString isEqualToString:@"在库车辆详情"]){//在库车辆
        switch (self.carModel.carStatus) {
            case 0://0、库存
            {
                switch (self.carModel.flag) {
                    case NO://车商检测
                    {
                        self.bottowTag = self.bottomView3.tag;
                    }
                        break;
                    case YES://认证检测
                    {
                        //审核状态
                        if (!IsEmptyStr(self.model0.autditStatus)) {
                            switch ([self.model0.autditStatus integerValue]) {
                                //0 待审核()√
                                case 0:
                                    self.bottowTag = self.bottomView2.tag;
                                    break;
                                //1 审核通过（待安排）
                                case 1:
                                    ///////后台下架
                                    self.bottowTag = self.bottomView7.tag;

                                    break;
                                //2 审核失败(审核不通过，查看原因)√
                                case 2:
                                    self.bottowTag = self.bottomView7.tag;
                                    break;
                                //4（待开拍状态： 审核状态 = 4 and 竞拍开始时间不等于空）(开拍中： 审核状态 = 4 and 竞拍开始时间不等于空 and 竞拍开始时间 < 当前时间 )
                                case 4:

                                    break;
                                default:
                                    break;
                            }
                        } else {//√
                            //[MBProgressHUD showError:@"审核状态为空"];
                            self.bottowTag = self.bottomView2.tag;
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1://1、拍卖
            {
                if (!IsEmptyStr(self.model0.autditStatus)) {//审核状态
                    switch ([self.model0.autditStatus integerValue]) {
                        //0 待审核√
                        case 0:
                        {
                            self.bottowTag = self.bottomView6.tag;
                            self.downShelfButton.hidden = NO;//取消竞拍==>下架按钮
                        }
                            break;
                        //1 审核通过（待安排）√
                        case 1:
                        {
                            self.bottowTag = self.bottomView9.tag;
                        }
                            break;
                        //2 审核失败(审核不通过，查看原因)
                        case 2:
                            self.bottowTag = self.bottomView7.tag;
                            break;
                        //4（待开拍状态： 审核状态 = 4 and 竞拍开始时间不等于空）(开拍中： 审核状态 = 4 and 竞拍开始时间不等于空 and 竞拍开始时间 < 当前时间 )
                        case 4:
                            if (!IsEmptyStr(self.model0.startTime)) {
                                //拍卖中√
                                if ([self compareTimeWithStartTime:self.model0.startTime WithNowTime:self.model0.nowTime] == YES) {
                                    self.bottowTag = self.bottomView11.tag;
                                //待开拍√
                                } else {
                                    self.bottowTag = self.bottomView10.tag;
                                }
                            }
                            break;
                        default:
                            break;
                    }
                } else {
                    //[MBProgressHUD showError:@"审核状态为空"];
                }
            }
                break;
            case 2://2、帮卖
                self.bottowTag = self.bottomView5.tag;
                break;
            case 5://5、帮买
                self.bottowTag = self.bottomView5.tag;
                break;

            default:
                break;
        }
    } else if ([self.jumpString isEqualToString:@"销售记录详情"]){
        switch (self.carModel.carStatus) {
            case 1://1、拍卖成功
            {
                NSLog(@"---------====交易状态1：%@====----------", self.model0.tradeStatus);
                if (!IsEmptyStr(self.model0.tradeStatus)) {
                    switch ([self.model0.tradeStatus integerValue]) {//交易状态
                        case 0://0 流拍
                            self.bottowTag = self.bottomView12.tag;
                            break;
                        case 1://1 交易完成
                            self.bottowTag = self.bottomView14.tag;
                            break;
                        case 2://2 服务费待支付
                            self.bottowTag = self.bottomView13.tag;
                            break;
                        default:
                            break;
                    }
                } else {
                    //[MBProgressHUD showError:@"交易信息为空"];
                }
            }
                break;
            case 2://2、销售成功
                self.bottowTag = self.bottomView8.tag;
                break;
            default:
                
                break;
        }
    } else if ([self.jumpString isEqualToString:@"正在竞价详情"]){
        switch (self.carModel.carStatus) {
            case 0://0、待安排
                self.bottowTag = self.bottomView9.tag;
                break;
            case 1://1、待开拍
                self.bottowTag = self.bottomView10.tag;
                break;
            case 2://2、拍卖中
                self.bottowTag = self.bottomView11.tag;
                break;
            default:
                break;
        }
    } else if ([self.jumpString isEqualToString:@"竞价记录详情"]){
        switch (self.carModel.carStatus) {
            case 0://0、流拍
                self.bottowTag = self.bottomView12.tag;
                break;
            case 1://1、服务费待支付(支付服务费)
                self.bottowTag = self.bottomView13.tag;
                break;
            case 2://2、交易完成(服务费已支付)
                self.bottowTag = self.bottomView14.tag;
                break;
            default:
                break;
        }
    }
    
    //(2)根据tag值确定底部视图
    switch (self.bottowTag) {
        case 1:
        {
            self.bottomView1.hidden = NO;
            [self displayPriceWithString:self.leftUpLabel1];//价格
            if ([self.model0.favorite isEqualToString:@"1"]) {//收藏
                [self.rightUpButton1 setImage:[UIImage imageNamed:@"icon_collected"] forState:UIControlStateNormal];
            } else if ([self.model0.favorite isEqualToString:@"0"]){
                [self.rightUpButton1 setImage:[UIImage imageNamed:@"icon_unCollected"] forState:UIControlStateNormal];
            } else {
                [self.rightUpButton1 setImage:[UIImage imageNamed:@"icon_unCollected"] forState:UIControlStateNormal];
            }
 /////////////////////
            
            if (self.carModel.flag && self.carModel.carStatus == 5) {//帮买
                if (self.model0.parStatus != 1) {//wei shi fu
                     __weak typeof(self) weakSelf = self;
                    self.bottomView1CollectWidth.constant =  screenWidth * 0.5 - 1;
                    self.offerButton.hidden = YES;
                    self.detailPayView.activityPrice = self.model0.activityPrice;
                    self.detailPayView.price = self.model0.originalPrice;
                    self.detailPayView.tapBlock = ^{
                        [weakSelf showPayFreeView:IsEmptyStr(self.model0.activityPrice)? self.model0.originalPrice:self.model0.activityPrice code:self.model0.code];
                    };
                    
                }else{
                    self.offerButton.selected = self.model0.isOffer;

                    self.offerButton.backgroundColor = self.model0.isOffer?[UIColor whiteColor]:YHNaviColor;
                    self.offerButton.hidden = NO;
                    [self verticalImageAndTitleButton:self.offerButton verticalSpacing:5];
                    
                
                }
            }else{
                self.bottomView1PayWidth.constant = - screenWidth * 0.5+1;
            }

            
        }
            break;
        case 2:
        {
            self.bottomView2.hidden = NO;
            [self displayPriceWithString:self.leftUpButton2];
        }
            break;
        case 3:
        {
            self.bottomView3.hidden = NO;
            [self displayPriceWithString:self.leftUpButton3];
        }
            break;
        case 4:
        {
            self.bottomView4.hidden = NO;
        }
            break;
        case 5:
        {
            self.bottomView5.hidden = NO;
            [self.rightButton5 setTitle:self.carModel.flag?@"取消帮买":@"取消帮卖" forState:UIControlStateNormal];
            self.bottomView5OfferedWidth.constant = - (1 - self.carModel.flag) * screenWidth /2.0;
            self.leftDowonLabel5.text = self.carModel.flag?@"帮买价":@"帮卖价";
            [self displayPriceWithString:self.leftUpButton5];
        }
            break;
        case 6:
        {
            self.bottomView6.hidden = NO;
            [self displayPriceWithString:self.leftUpButton6];
            
            //取消竞拍状态,可下架
            self.downShelfButton.hidden = NO;
        }
            break;
        case 7:
        {
            self.bottomView7.hidden = NO;
            [self displayPriceWithString:self.leftUpButton7];
        }
            break;
        case 8:
        {
            self.bottomView8.hidden = NO;
            [self displayPriceWithString:self.leftUpButton8];
        }
            break;
        case 9:
        {
            self.bottomView9.hidden = NO;
            [self displayPriceWithString:self.leftButton9];
        }
            break;
        case 10:
        {
            self.bottomView10.hidden = NO;
            
            //(1)起拍价
            [self displayPriceWithString:self.leftUpButton10];
    
            //(2)倒计时
            [self getTimeIntervalWithStartTime:self.model0.startTime WithEndTime:self.model0.endTime];
        }
            break;
        case 11:
        {
            self.bottomView11.hidden = NO;
            
            //(1)初始价格
            [self displayPriceWithString:self.leftUpButton11];
            
            //刷新价格
            [self refreshBiddingPriceUI];
            
            //(2)倒计时
            [self getTimeIntervalWithStartTime:self.model0.startTime WithEndTime:self.model0.endTime];
        }
            break;
        case 12:
        {
            self.bottomView12.hidden = NO;
            [self displayPriceWithString:self.leftUpButton12];
        }
            break;
        case 13:
        {
            self.bottomView13.hidden = NO;
            [self displayPriceWithString:self.leftUpLabel13];
        }
            break;
        case 14:
        {
            self.bottomView14.hidden = NO;
            [self displayPriceWithString:self.leftUpLabel14];
        }
            break;
        case 15:
        {
            self.bottomView15.hidden = NO;
        }
        case 16:
        {
            self.bottomView16.hidden = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 刷新竞价中当前价格
- (void)refreshBiddingPriceUI
{
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(action2:) userInfo:nil repeats:YES];
}

#pragma mark - -----------------------------------三、导航视图点击事件----------------------------------------
#pragma mark - 1.下架
- (IBAction)downShelfButton:(UIButton *)sender
{
    [self showDownShelfViewWithButton:sender];
}

//FIXME:  -  查看出价（帮买）
- (IBAction)findOfferAction:(UIButton *)sender {
    
    YHFindOfferController *offer = [YHFindOfferController new];
    offer.carId = self.carModel.carId;
    [self.navigationController pushViewController:offer animated:YES];
    
}

- (IBAction)offerAction:(UIButton *)sender {
    
    YHCaptureCarAlertView *presentVC = [[YHCaptureCarAlertView alloc] init];
    presentVC.isOffer = YES;
    presentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    presentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (sender.isSelected) {
        // 查看出价
        presentVC.price = self.model0.buyerPrice;
        presentVC.commission = self.model0.brokerage;
    }
    
 __weak typeof(self) weakSelf = self;
    presentVC.submitBlock = ^(NSString *price, NSString *helpSellPrice) {
        
        if (IsEmptyStr(price) || IsEmptyStr(helpSellPrice)) {
            [MBProgressHUD showError:@"车价和佣金不能为空"];
            return ;
        }
        //
        [MBProgressHUD showMessage:nil toView:weakSelf.view];
        [YHHelpSellService saveBuyerOfferWithCarId:self.carModel.carId price:price brokerage:helpSellPrice onComplete:^{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            
            weakSelf.model0.isOffer = YES;
            weakSelf.model0.brokerage = helpSellPrice;
            weakSelf.model0.buyerPrice = price;

            weakSelf.offerButton.selected = self.model0.isOffer;
            weakSelf.offerButton.backgroundColor = self.model0.isOffer?[UIColor whiteColor]:YHNaviColor;
            weakSelf.offerButton.hidden = NO;
            [weakSelf verticalImageAndTitleButton:weakSelf.offerButton verticalSpacing:5];
            
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
        }];
    };
    [self presentViewController:presentVC animated:NO completion:nil];
    return;
    //提交报价

}



#pragma mark - -----------------------------------四、底部视图点击事件----------------------------------------
#pragma mark - 1.帮卖详情
- (IBAction)rightUpButton1:(UIButton *)sender
{
    WeakSelf;
    
    //模型有值才去操作
    if (!self.model0) {
        return;
    }
    
    //如果已经收藏,点击变不收藏
    if ([self.model0.favorite isEqualToString:@"1"]) {
        [[YHNetworkManager sharedYHNetworkManager]favoriteWithToken:[YHTools getAccessToken] carId:self.carModel.carId favStatus:@"0" onComplete:^(NSDictionary *info) {
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                weakSelf.model0.favorite = @"0";
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                [weakSelf.rightUpButton1 setImage:[UIImage imageNamed:@"icon_unCollected"] forState:UIControlStateNormal];
            } else {
                YHLogERROR(@"");
                [weakSelf showErrorInfo:info];
            }
        } onError:^(NSError *error) {
            [MBProgressHUD showError:@"取消收藏失败"];
        }];
    //如果没有收藏,点击变收藏
    } else {
        [[YHNetworkManager sharedYHNetworkManager]favoriteWithToken:[YHTools getAccessToken] carId:self.carModel.carId favStatus:@"1" onComplete:^(NSDictionary *info) {
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                weakSelf.model0.favorite = @"1";
                [MBProgressHUD showSuccess:@"收藏成功"];
                [weakSelf.rightUpButton1 setImage:[UIImage imageNamed:@"icon_collected"] forState:UIControlStateNormal];
            } else {
                YHLogERROR(@"");
                [weakSelf showErrorInfo:info];
            }
        } onError:^(NSError *error) {
            [MBProgressHUD showError:@"收藏失败"];
        }];
    }
}

#pragma mark - 2、3、7.在库车辆认证、车商检测、取消帮卖详情点击
#pragma mark - (1).设置帮卖价
- (IBAction)leftUpButton23:(UIButton *)sender
{
    return;
    //1.隐藏原有视图
    switch (self.bottowTag) {
        case 2:
        {
            self.bottomView2.hidden = YES;
        }
            break;
        case 3:
        {
            self.bottomView3.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    //2.展示新视图
    self.bottomView4.hidden = NO;
    self.bottowTag = self.bottomView4.tag;
}

//FIXME:  -  +++++
#pragma mark - (2).找帮卖(2、3、7)
- (IBAction)middleUpButton23:(UIButton *)sender
{
    
    
    NSString *price;
    switch (self.bottowTag) {
        case 2:
            if (![self.leftUpButton2.titleLabel.text isEqualToString:@"面议"]) {
                if ([self.leftUpButton2.titleLabel.text containsString:@"万"]) {
                    price = [self.leftUpButton2.titleLabel.text stringByReplacingOccurrencesOfString:@"万" withString:@""];
                } else {
                    price = self.leftUpButton2.titleLabel.text;
                }
            } else {
                price = @"";
            }
            break;
        case 3:
            if (![self.leftUpButton3.titleLabel.text isEqualToString:@"面议"]) {
                if ([self.leftUpButton3.titleLabel.text containsString:@"万"]) {
                    price = [self.leftUpButton3.titleLabel.text stringByReplacingOccurrencesOfString:@"万" withString:@""];
                } else {
                    price = self.leftUpButton3.titleLabel.text;
                }
            } else {
                price = @"";
            }
            break;
        case 7:
            if (![self.leftUpButton7.titleLabel.text isEqualToString:@"面议"]) {
                if ([self.leftUpButton7.titleLabel.text containsString:@"万"]) {
                    price = [self.leftUpButton7.titleLabel.text stringByReplacingOccurrencesOfString:@"万" withString:@""];
                } else {
                    price = self.leftUpButton7.titleLabel.text;
                }
            } else {
                price = @"";
            }
            break;
        default:
            break;
    }
    
    WeakSelf;

        YHCaptureCarAlertView *presentVC = [[YHCaptureCarAlertView alloc] init];
    presentVC.isEnquiry = self.carModel.isEnquiry;
    presentVC.suggestPrice = self.carModel.suggestPrice;
        presentVC.isHelpBuy = self.carModel.flag;

        presentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        presentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        presentVC.submitBlock = ^(NSString *price, NSString *helpSellPrice) {
            NSLog(@"%s", __func__);

            [weakSelf helpSellAndUpCaptureCar:(price.length > 1)? price : @"" helpSellPrice:(helpSellPrice.length > 1)? helpSellPrice : @""];
        };
        if (price.length>1) {
            presentVC.price = price;
        }
    


    
        presentVC.enquirieBlock = ^{
            [MBProgressHUD showMessage:@"正在询价中，请稍后再查看" toView:[UIApplication sharedApplication].keyWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
            });
            [YHHelpSellService findSuggestPriceWithCarId:weakSelf.carModel.carId type:1 onComplete:^(NSString *suggestPrice, BOOL isEnquiry) {
                weakSelf.carModel.isEnquiry = YES;
                weakSelf.carModel.suggestPrice = suggestPrice;

            } onError:^(NSError *error) {
            }];

        };
    
        [self presentViewController:presentVC animated:NO completion:nil];
        return;
    
    [[YHNetworkManager sharedYHNetworkManager]helpSellAndUpCaptureCarWithToken:[YHTools getAccessToken] carId:self.carModel.carId price:price type:self.carModel.flag? @"2":@"0" onComplete:^(NSDictionary *info) {
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            //1.隐藏原有视图
            switch (weakSelf.carModel.flag) {
                case NO://车商检测
                    weakSelf.bottomView3.hidden = YES;
                    break;
                case YES://认证检测
                    switch (weakSelf.bottowTag) {
                        case 2:
                            weakSelf.bottomView2.hidden = YES;
                            break;
                        case 7:
                            weakSelf.bottomView7.hidden = YES;
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            
            //2.展示新视图,修改UI
            weakSelf.bottomView5.hidden = NO;
            weakSelf.bottowTag = weakSelf.bottomView5.tag;
            switch (self.carModel.flag) {
                case NO://车商检测
                {
                    if ([price isEqualToString:@"面议"]) {
                        [weakSelf.leftUpButton5 setTitle:price forState:UIControlStateNormal];
                    } else {
                        [weakSelf.leftUpButton5 setTitle:[NSString stringWithFormat:@"%@万",price] forState:UIControlStateNormal];
                    }
                }
                    break;
                case YES://认证检测
                {
                    if ([price isEqualToString:@"面议"]) {
                        [weakSelf.leftUpButton5 setTitle:price forState:UIControlStateNormal];
                    } else {
                        [weakSelf.leftUpButton5 setTitle:[NSString stringWithFormat:@"%@万",price] forState:UIControlStateNormal];
                    }
                }
                    
                    break;
            }
            
            //3.提示
            [MBProgressHUD showSuccess:info[@"retMsg"]];
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
    /////////////////////////////////////////////////////////////
}

//FIXME:  -  ++++++
- (void)helpSellAndUpCaptureCar:(NSString *)price
                  helpSellPrice:(NSString *)free{
    
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]helpSellAndUpCaptureCarWithToken:[YHTools getAccessToken]
                                                                         carId:self.carModel.carId
                                                                         price:price
                                                                         free:free
                                                                          type:self.carModel.flag? @"2":@"0"
                                                                    onComplete:^(NSDictionary *info) {
                                                                        
                                                                        if ([info[@"retCode"] isEqualToString:@"0"]) {
                                                                            //1.隐藏原有视图
                                                                            switch (weakSelf.carModel.flag) {
                                                                                case NO://车商检测
                                                                                    weakSelf.bottomView3.hidden = YES;
                                                                                    break;
                                                                                case YES://认证检测
                                                                                    switch (weakSelf.bottowTag) {
                                                                                        case 2:
                                                                                            weakSelf.bottomView2.hidden = YES;
                                                                                            break;
                                                                                        case 7:
                                                                                            weakSelf.bottomView7.hidden = YES;
                                                                                            break;
                                                                                        default:
                                                                                            break;
                                                                                    }
                                                                                    break;
                                                                                default:
                                                                                    break;
                                                                            }
                                                                            
                                                                            if(!weakSelf.carModel.flag){
                                                                                [weakSelf.dataArray0 removeLastObject];
                                                                                if (!IsEmptyStr(free)) {
                                                                                    [weakSelf.dataArray0 addObject:[NSString stringWithFormat:@"%.02f元",free.doubleValue]];
                                                                                }else{
                                                                                    [weakSelf.dataArray0 addObject:@"面议"];
                                                                                }
                                                                                [weakSelf.tableView reloadData];
                                                                            }
                                                                            
                                                                            //2.展示新视图,修改UI
                                                                            weakSelf.bottomView5.hidden = NO; //取消帮买／帮卖
                                                                            [weakSelf.rightButton5 setTitle:weakSelf.carModel.flag?@"取消帮买":@"取消帮卖" forState:UIControlStateNormal];
                                                                            weakSelf.bottomView5OfferedWidth.constant = - (1 - weakSelf.carModel.flag) * screenWidth /2.0;

                                                                            weakSelf.leftDowonLabel5.text = weakSelf.carModel.flag?@"帮买价":@"帮卖价";
                                                                            weakSelf.bottowTag = weakSelf.bottomView5.tag;
                                                                            switch (self.carModel.flag) {
                                                                                case NO://车商检测
                                                                                {
//                                                                                    if ([price isEqualToString:@"面议"]) {

                                                                                    if ([price isEqualToString:@""]) {
                                                                                        [weakSelf.leftUpButton5 setTitle:@"面议" forState:UIControlStateNormal];
                                                                                    } else {
                                                                                        [weakSelf.leftUpButton5 setTitle:[NSString stringWithFormat:@"%@万",price] forState:UIControlStateNormal];
                                                                                    }
                                                                                }
                                                                                    break;
                                                                                case YES://认证检测
                                                                                {
//                                                                                    if ([price isEqualToString:@"面议"]) {

                                                                                    if ([price isEqualToString:@""]) {
                                                                                        [weakSelf.leftUpButton5 setTitle:@"面议" forState:UIControlStateNormal];
                                                                                    } else {
                                                                                        [weakSelf.leftUpButton5 setTitle:[NSString stringWithFormat:@"%@万",price] forState:UIControlStateNormal];
                                                                                    }
                                                                                }
                                                                                    
                                                                                    break;
                                                                            }
                                                                            
                                                                            //3.提示
                                                                            [MBProgressHUD showSuccess:info[@"retMsg"]];
                                                                        } else {
                                                                            YHLogERROR(@"");
                                                                            [weakSelf showErrorInfo:info];
                                                                        }

                                                                        
            } onError:^(NSError *error) {
        
    }];
}

#pragma mark - (3).上捕车(2、7)
- (IBAction)rightUpButton2:(UIButton *)sender
{
    [self showUpCaptureCarView];
}

#pragma mark - 4.设置帮卖价(确定)
- (IBAction)rightButton4:(UIButton *)sender
{
    WeakSelf;
    if (!IsEmptyStr(self.leftTF4.text)) {
        if ([self.leftTF4.text floatValue] > 0) {
            [[YHNetworkManager sharedYHNetworkManager]setHelpSellPriceWithToken:[YHTools getAccessToken] carId:self.carModel.carId price:self.leftTF4.text onComplete:^(NSDictionary *info) {
                //1.隐藏原有视图
                weakSelf.bottomView4.hidden = YES;
                
                if ([info[@"retCode"] isEqualToString:@"0"]) {
                    //2.展示新视图,修改UI
                    switch (weakSelf.bottowTag) {
                        case 2:
                        {
                            weakSelf.bottomView2.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView2.tag;
                            [weakSelf.leftUpButton2 setTitle:[NSString stringWithFormat:@"%.02f万",[weakSelf.leftTF4.text floatValue]] forState:UIControlStateNormal];
                        }
                            break;
                        case 3:
                        {
                            weakSelf.bottomView3.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView3.tag;
                            [weakSelf.leftUpButton3 setTitle:[NSString stringWithFormat:@"%.02f万",[weakSelf.leftTF4.text floatValue]] forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            break;
                    }

                    //3.提示
                    [MBProgressHUD showSuccess:info[@"retMsg"]];
                    
                    //4.收起键盘
                    [weakSelf.leftTF4 resignFirstResponder];
                } else {
                    YHLogERROR(@"");
                    [weakSelf showErrorInfo:info];
                    [weakSelf.leftTF4 resignFirstResponder];
                }
            } onError:^(NSError *error) {
                [self.leftTF4 resignFirstResponder];
            }];
        } else {
            [MBProgressHUD showError:@"请设置大于0的价格"];
        }
    } else {
        [MBProgressHUD showError:@"请设置帮卖价"];
    }
}

#pragma mark - 5.取消帮卖
- (IBAction)rightButton5:(UIButton *)sender
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]cancelHelpSellAndUpCaptureCarWithToken:[YHTools getAccessToken] carId:self.model0.carId auctionId:@"" type:@"0" onComplete:^(NSDictionary *info) {
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            //1.隐藏原有视图
            weakSelf.bottomView5.hidden = YES;
            
            //2.展示新视图,修改UI
            switch (weakSelf.carModel.flag) {
                case NO://车商检测
                {
                    weakSelf.bottomView3.hidden = NO;
                    weakSelf.bottowTag = weakSelf.bottomView3.tag;
                    [weakSelf.leftUpButton3 setTitle:weakSelf.leftUpButton5.titleLabel.text forState:UIControlStateNormal];
                }
                    break;
                case YES://认证检测
                {//此时weakSelf.bottowTag = 5;
                    if (!IsEmptyStr(self.model0.autditStatus)) {
                        if ([self.model0.autditStatus isEqualToString:@"2"]) {
                            weakSelf.bottomView7.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView7.tag;
                            [weakSelf.leftUpButton7 setTitle:weakSelf.leftUpButton5.titleLabel.text forState:UIControlStateNormal];
                        } else {
                            weakSelf.bottomView2.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView2.tag;
                            [weakSelf.leftUpButton2 setTitle:weakSelf.leftUpButton5.titleLabel.text forState:UIControlStateNormal];
                        }
                    } else {
                        weakSelf.bottomView2.hidden = NO;
                        weakSelf.bottowTag = weakSelf.bottomView2.tag;
                        [weakSelf.leftUpButton2 setTitle:weakSelf.leftUpButton5.titleLabel.text forState:UIControlStateNormal];
                    }
                }
                    break;
                default:
                    break;
            }
            
            //3.提示
            [MBProgressHUD showSuccess:info[@"retMsg"]];
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 取消
- (IBAction)rightButton6:(UIButton *)sender
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]cancelHelpSellAndUpCaptureCarWithToken:[YHTools getAccessToken] carId:self.model0.carId auctionId:self.model0.auctionId type:@"1" onComplete:^(NSDictionary *info) {
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            //1.隐藏原有视图
            weakSelf.bottomView6.hidden = YES;
            
            //2.展示新视图,修改UI
            switch (weakSelf.carModel.flag) {
                case NO://车商检测
                    weakSelf.bottomView3.hidden = NO;
                    weakSelf.bottowTag = weakSelf.bottomView3.tag;
                    [weakSelf.leftUpButton3 setTitle:weakSelf.leftUpButton6.titleLabel.text forState:UIControlStateNormal];
                    break;
                case YES://认证检测
                    switch (weakSelf.bottowTag) {
                        case 2:
                        {
                            weakSelf.bottomView2.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView2.tag;
                            [weakSelf.leftUpButton2 setTitle:weakSelf.leftUpButton6.titleLabel.text forState:UIControlStateNormal];
                        }
                            break;
                        case 6:
                        {
                            weakSelf.bottomView7.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView7.tag;
                            [weakSelf.leftUpButton7 setTitle:weakSelf.leftUpButton6.titleLabel.text forState:UIControlStateNormal];
                        }
                            break;
                        case 7:
                        {
                            weakSelf.bottomView7.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView7.tag;
                            [weakSelf.leftUpButton7 setTitle:weakSelf.leftUpButton6.titleLabel.text forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            
                            break;
                    }
                    break;
                default:
                    
                    break;
            }
            
            //3.提示信息
            [MBProgressHUD showSuccess:info[@"retMsg"]];
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 7.审核不通过(查看原因)
- (IBAction)leftButton7:(UIButton *)sender
{
    [self showFailReasonView];
}

#pragma mark - 8.销售成功


#pragma mark - 9.待安排


#pragma mark - 10.待拍卖


#pragma mark - 11.拍卖中


#pragma mark - 12.流拍


#pragma mark - 13.支付服务费、服务费已支付
#pragma mark - (1).买家信息
- (IBAction)middleButton13:(UIButton *)sender
{
    [self showbuyersInfoView];
}

#pragma mark - (2).支付服务费、服务费已支付
- (IBAction)rightButton13:(UIButton *)sender
{
    [self showPayServiceFeeView];
}

#pragma mark - --------------------------------------五、功能模块代码------------------------------------------
#pragma mark - 1.上捕车
- (void)showUpCaptureCarView
{
    
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.upCaptureCarView) {
        self.upCaptureCarView = [[NSBundle mainBundle]loadNibNamed:@"YHUpCaptureCarView" owner:self options:nil][0];
        self.upCaptureCarView.frame = CGRectMake(30, (screenHeight-215)/2 - 100, screenWidth-60, 215);
        self.upCaptureCarView.layer.cornerRadius = 5;
        self.upCaptureCarView.layer.masksToBounds = YES;
        self.upCaptureCarView.priceTF.delegate = self;
        [self.functionView addSubview:self.upCaptureCarView];
    }
    
    if (!IsEmptyStr(self.model0.cashDeposit)) {
        self.upCaptureCarView.depositLabel.text = [NSString stringWithFormat:@"¥%@",self.model0.cashDeposit];
    } else {
        [MBProgressHUD showError:@"后台没有返回保证金"];
    }
    
    //点击事件
    self.upCaptureCarView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://取消
                [weakSelf.functionView removeFromSuperview];
                break;
            case 3://确定
            {
                if (!IsEmptyStr(weakSelf.upCaptureCarView.priceTF.text)) {
                    [[YHNetworkManager sharedYHNetworkManager]helpSellAndUpCaptureCarWithToken:[YHTools getAccessToken] carId:weakSelf.carModel.carId price:weakSelf.upCaptureCarView.priceTF.text type:@"1" onComplete:^(NSDictionary *info) {
                        if ([info[@"retCode"] isEqualToString:@"0"]) {
                            
                            [weakSelf.functionView removeFromSuperview];
                            
                            //1.隐藏原有视图
                            switch (weakSelf.bottowTag) {
                                case 2:
                                    weakSelf.bottomView2.hidden = YES;
                                    break;
                                case 7:
                                    weakSelf.bottomView7.hidden = YES;
                                    break;
                                default:
                                    break;
                            }
                            
                            //2.展示视图,修改UI
                            weakSelf.bottomView6.hidden = NO;
                            //weakSelf.bottowTag = weakSelf.bottomView6.tag;
                            [weakSelf.leftUpButton6 setTitle:[NSString stringWithFormat:@"%.02f万",[weakSelf.upCaptureCarView.priceTF.text floatValue]] forState:UIControlStateNormal];
                            
                            //3.点击上捕车==>取消竞拍==>下架按钮
                            weakSelf.downShelfButton.hidden = NO;

                            //4.提示
                            [MBProgressHUD showSuccess:info[@"retMsg"]];
                            
                        } else {
                            YHLogERROR(@"");
                            [weakSelf showErrorInfo:info];
                            [weakSelf.functionView removeFromSuperview];
                        }
                    } onError:^(NSError *error) {
                        [weakSelf.functionView removeFromSuperview];
                    }];
                } else {
                    [MBProgressHUD showError:@"请输入竞价起拍价"];
                }
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 2.下架
- (void)showDownShelfViewWithButton:(UIButton *)sender
{
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.downShelfView) {
        self.downShelfView = [[NSBundle mainBundle]loadNibNamed:@"YHDownShelfView" owner:self options:nil][0];
        self.downShelfView.frame = CGRectMake(30, (screenHeight-220)/2 - 100, screenWidth-60, 220);
        self.downShelfView.layer.cornerRadius = 5;
        self.downShelfView.layer.masksToBounds = YES;
        self.downShelfView.priceTF.delegate = self;
        [self.functionView addSubview:self.downShelfView];
    }
    
    //下架类型
    __block NSString *type;
    
    //点击事件
    WeakSelf;
    self.downShelfView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://售出
            {
                type = @"0";
                [weakSelf.downShelfView.soldBtn setImage:[UIImage imageNamed:@"icon_Select"] forState:UIControlStateNormal];
                [weakSelf.downShelfView.downShelfBtn setImage:[UIImage imageNamed:@"icon_UnSelect"] forState:UIControlStateNormal];
            }
                break;
            case 3://下架
            {
                type = @"1";
                [weakSelf.downShelfView.soldBtn setImage:[UIImage imageNamed:@"icon_UnSelect"] forState:UIControlStateNormal];
                [weakSelf.downShelfView.downShelfBtn setImage:[UIImage imageNamed:@"icon_Select"] forState:UIControlStateNormal];
            }
                break;
            case 4://取消
                [weakSelf.functionView removeFromSuperview];
                break;
            case 5://确定
            {
                if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
                    [[YHNetworkManager sharedYHNetworkManager]downShelfWithToken:[YHTools getAccessToken] carId:self.carModel.carId price:self.downShelfView.priceTF.text type:type onComplete:^(NSDictionary *info) {
                        if ([info[@"retCode"] isEqualToString:@"0"]) {
                            [weakSelf.functionView removeFromSuperview];
                            sender.userInteractionEnabled = NO;
                            [sender setTitle:@"已下架" forState:UIControlStateNormal];
                            weakSelf.bottomView15.hidden = NO;
                            weakSelf.bottowTag = weakSelf.bottomView15.tag;
                            [MBProgressHUD showSuccess:info[@"retMsg"]];
                        } else {
                            YHLogERROR(@"");
                            [weakSelf showErrorInfo:info];
                            [weakSelf.functionView removeFromSuperview];
                        }
                    } onError:^(NSError *error) {
                        [weakSelf.functionView removeFromSuperview];
                    }];
                } else {
                    [MBProgressHUD showError:@"请选择下架类型"];
                }
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 3.失败原因
- (void)showFailReasonView
{
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.failReasonView) {
        self.failReasonView = [[NSBundle mainBundle]loadNibNamed:@"YHFailReasonView" owner:self options:nil][0];
        self.failReasonView.frame = CGRectMake(30, (screenHeight-220)/2, screenWidth-60, 220);
        self.failReasonView.layer.cornerRadius = 5;
        self.failReasonView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.failReasonView];
    }
    
    //赋值
    if (!IsEmptyStr(self.model0.reason)) {
        self.failReasonView.textView.text = self.model0.reason;
    } else {
        //[MBProgressHUD showError:@"后台没有返回审核不通过原因"];
    }
    
    WeakSelf;
    self.failReasonView.btnClickBlock = ^(UIButton *button) {
        [weakSelf.functionView removeFromSuperview];
        
        //1.隐藏原有视图
        weakSelf.bottomView7.hidden = YES;
        
        //2.展示新视图,修改UI
        weakSelf.bottomView2.hidden = NO;
        weakSelf.bottowTag = weakSelf.bottomView2.tag;
        
        [weakSelf.leftUpButton2 setTitle:weakSelf.leftUpButton7.titleLabel.text forState:UIControlStateNormal];
    };
}

#pragma mark - 4.支付服务费
- (void)showPayServiceFeeView
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.payServiceFeeView) {
        self.payServiceFeeView = [[NSBundle mainBundle]loadNibNamed:@"YHPayServiceFeeView" owner:self options:nil][0];
        self.payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.payServiceFeeView.layer.cornerRadius = 5;
        self.payServiceFeeView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.payServiceFeeView];
    }
    
    //刷新UI
    self.payServiceFeeView.moneyLabel.text = [NSString stringWithFormat:@"%@元",self.model1.serviceAmt];
    
    //点击事件
    self.payServiceFeeView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://微信支付
            {
                //[weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatSelected"] forState:UIControlStateNormal];
                //[weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPayUnSelected"] forState:UIControlStateNormal];
                
                //更新页面
                [weakSelf gpaymentAuctionId:weakSelf.model0.auctionId isBuy:NO onComplete:^(NSDictionary *info) {
                    [weakSelf.functionView removeFromSuperview];
                    weakSelf.bottomView13.hidden = YES;
                    weakSelf.bottomView14.hidden = NO;
                    weakSelf.bottowTag = weakSelf.bottomView14.tag;
                }];
            }
                break;
            case 3://支付宝支付
            {
                //[weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatUnSelected"] forState:UIControlStateNormal];
                //[weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPaySelected"] forState:UIControlStateNormal];
                [MBProgressHUD showError:@"后期开通,敬请期待"];
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 5.支付报告费
- (void)showPayFreeView:(NSString *)price
                   code:(NSString *)code
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.payServiceFeeView) {
        self.payServiceFeeView = [[NSBundle mainBundle]loadNibNamed:@"YHPayServiceFeeView" owner:self options:nil][0];
        self.payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.payServiceFeeView.layer.cornerRadius = 5;
        self.payServiceFeeView.layer.masksToBounds = YES;
        self.payServiceFeeView.payRemindLabel.text = @"报告费";
        [self.functionView addSubview:self.payServiceFeeView];
    }
    
    //刷新UI
    self.payServiceFeeView.moneyLabel.text = [NSString stringWithFormat:@"%@元",price];
    
    //点击事件
    self.payServiceFeeView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://微信支付
            {
                //[weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatSelected"] forState:UIControlStateNormal];
                //[weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPayUnSelected"] forState:UIControlStateNormal];
                //[weakSelf pay:code];
                [weakSelf payVersionTwo:code];
            }
                break;
            case 3://支付宝支付
            {
                //[weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatUnSelected"] forState:UIControlStateNormal];
                //[weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPaySelected"] forState:UIControlStateNormal];
                [MBProgressHUD showError:@"后期开通,敬请期待"];
            }
                break;
            default:
                break;
        }
    };
}

- (void)payVersionTwo:(NSString *)code
{
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payRptTradeVersionTwoWithCode:code onComplete:^(NSDictionary *info) {
        [weakSelf.functionView removeFromSuperview];
        
        //发起微信支付
        [[WXPay sharedWXPay] payWithDict:info success:^{
            
            //支付结果回调
            [YHHelpSellService payCallBackWithId:info[@"result"][@"orderId"] onComplete:^{
                [weakSelf.webView reload];
                [MBProgressHUD hideHUDForView:weakSelf.view];
                //
                if (self.carModel.flag && self.model0.parStatus != 1) {
                    #pragma mark - .支付成功
                    self.model0.parStatus = 1;
                    self.offerButton.selected = self.model0.isOffer;
                    self.offerButton.backgroundColor = self.model0.isOffer?[UIColor whiteColor]:YHNaviColor;
                    self.offerButton.hidden = NO;
                    [self verticalImageAndTitleButton:self.offerButton verticalSpacing:5];
                }
                
            } onError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
            }];
        } failure:^{
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
    }];
}

- (void)pay:(NSString *)code
{
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payRptTradeWithCode:code onComplete:^(NSString *wxPrepayId, NSString *orderId) {
        [weakSelf.functionView removeFromSuperview];
        [[WXPay sharedWXPay] payByPrepayId:wxPrepayId success:^{
            [YHHelpSellService payCallBackWithId:orderId onComplete:^{
                [weakSelf.webView reload];
                [MBProgressHUD hideHUDForView:weakSelf.view];
            } onError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
            }];
        } failure:^{
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
    }];
}

#pragma mark - 5.买家信息
- (void)showbuyersInfoView
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.buyersInfoView) {
        self.buyersInfoView = [[NSBundle mainBundle]loadNibNamed:@"YHBuyersInfoView" owner:self options:nil][0];
        self.buyersInfoView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 130);
        self.buyersInfoView.layer.cornerRadius = 5;
        self.buyersInfoView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.buyersInfoView];
    }
    
    //刷新UI
    if (!IsEmptyStr(self.model2.buyer)) {
        self.buyersInfoView.nameLabel.text = self.model2.buyer;
    } else {
        self.buyersInfoView.nameLabel.text = @"暂无商户名称";
    }
    
    if (!IsEmptyStr(self.model2.buyerPhone)) {
        self.buyersInfoView.telePhoneLabel.text = [NSString stringWithFormat:@"%@",self.model2.buyerPhone];
    } else {
        self.buyersInfoView.telePhoneLabel.text = @"暂无联系电话";
    }
    
    self.buyersInfoView.btnClickBlock = ^(UIButton *button) {
        [weakSelf.functionView removeFromSuperview];
    };
}

#pragma mark - ------------------------------------获取时间代码------------------------------------------
#pragma mark - 1.获取时间间隔
- (void)getTimeIntervalWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    //1.首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //2.然后创建日期对象
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *currentDate = [NSDate date];
    
    //3.计算时间间隔（单位是秒）
    self.timeInterval1 = [startDate timeIntervalSinceDate:currentDate];
    
    //如果起始时间 > 当前时间,说明未开拍:startTime-now
    if (self.timeInterval1 > 0) {
        self.timeInterval1 = [startDate timeIntervalSinceDate:currentDate];
    //如果起始时间 < 当前时间,说明已开拍:endTime-now
    } else {
        self.timeInterval1 = [endDate timeIntervalSinceDate:currentDate];
    }
    
    //倒计时<0,关闭定时器1
    if (self.timeInterval1 > 0) {
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action1:) userInfo:nil repeats:YES];
    }
}

#pragma mark - 2.待开拍、竞价中倒计时
- (void)action1:(NSTimer *)timer
{
    //1.倒计时-1
    self.timeInterval1 -= 1;
    
    //2.关闭倒计时、更换视图
    if(self.timeInterval1 <= 0) {
        //(1)关闭倒计时
        [self.timer1 invalidate];
        self.timer1 = nil;
        [self.timer1 setFireDate:[NSDate distantFuture]];
        [self.timer2 invalidate];
        self.timer2 = nil;
        [self.timer2 setFireDate:[NSDate distantFuture]];
        
        //(2)更换视图
        switch (self.bottowTag) {
            case 10://待开拍==>拍卖中
            {
                self.bottomView10.hidden = YES;
                self.bottomView11.hidden = NO;
                self.bottowTag = self.bottomView11.tag;
                
                //(1)初始价格
                [self.leftUpButton11 setTitle:self.leftUpButton10.titleLabel.text forState:UIControlStateNormal];
                
                WeakSelf
                [[YHNetworkManager sharedYHNetworkManager]requestCarDetailsWithToken:[YHTools getAccessToken] carId:self.carModel.carId onComplete:^(NSDictionary *info) {
                    if ([info[@"retCode"] isEqualToString:@"0"]) {
                        weakSelf.model0 = [YHDetailModel0 mj_objectWithKeyValues:info[@"result"]];
                        [weakSelf refreshBiddingPriceUI];//价格刷新
                        [weakSelf getTimeIntervalWithStartTime:weakSelf.model0.startTime WithEndTime:weakSelf.model0.endTime];//倒计时
                    } else {
                        YHLogERROR(@"");
                        [weakSelf showErrorInfo:info];
                    }
                } onError:^(NSError *error) {
                    
                }];
            }
                break;
            case 11://拍卖中==>竞拍结束(竞拍成功、流拍)
            {
                self.bottomView11.hidden = YES;
                self.bottomView16.hidden = NO;
                self.bottowTag = self.bottomView16.tag;
            }
                break;
            default:
                break;
        }
        return;
    }
    
    //3.赋值
    int days = ((int)self.timeInterval1)/(3600*24);
    int hours = ((int)self.timeInterval1)%(3600*24)/3600;
    int minutes = ((int)self.timeInterval1)%(3600*24)%3600/60;
    int seconds = ((int)self.timeInterval1)%(3600*24)%3600%60;
    switch (self.bottowTag) {
        case 10://待开拍==>竞价中
        {
            self.rightDownLabel10.text = [[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
            NSLog(@"待开拍倒计时:%@",[[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds]);
        }
            break;
        case 11://竞价中==>竞价结束(竞价成功、流拍)
        {
            self.rightDownLabel11.text = [[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
            NSLog(@"竞价中倒计时:%@",[[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds]);
        }
            break;
        default:
            break;
    }
}

#pragma mark - 3.竞价中当前价格
- (void)action2:(NSTimer *)timer
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]requestCarDetailsWithToken:[YHTools getAccessToken] carId:self.carModel.carId onComplete:^(NSDictionary *info) {
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            weakSelf.model0 = [YHDetailModel0 mj_objectWithKeyValues:info[@"result"]];
            if (!IsEmptyStr(weakSelf.model0.price)) {
                [weakSelf.leftUpButton11 setTitle:[NSString stringWithFormat:@"%.2f万",[weakSelf.model0.price floatValue]] forState:UIControlStateNormal];
            } else {
                [weakSelf.leftUpButton11 setTitle:@"面议" forState:UIControlStateNormal];
            }
        } else {
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 比较两个时间先后顺序
- (BOOL)compareTimeWithStartTime:(NSString *)startTime WithNowTime:(NSString *)nowTime
{
    //1.首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //2.然后创建日期对象
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *nowDate = [dateFormatter dateFromString:nowTime];
    
    //3.计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:nowDate];
    
    //如果startTime < nowTime,说明拍卖中:nowTime-startTime
    if (timeInterval < 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 价格展示公共方法
- (void)displayPriceWithString:(id)obj
{
    NSLog(@"------------========模型价格:%@=========-------------",self.model0.price);
    
    NSString *str;
    
    if (!IsEmptyStr(self.model0.price) && [self.model0.price floatValue] > 0) {
        str = [NSString stringWithFormat:@"%.02f万",[self.model0.price floatValue]];
    } else {
        str = @"面议";
    }

    if ([obj isKindOfClass:[UILabel class]]) {
        ((UILabel *)obj).text = str;
    } else if ([obj isKindOfClass:[UIButton class]]) {
        [((UIButton *)obj) setTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark - 键盘输入控制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((textField == self.downShelfView.priceTF) || (textField == self.upCaptureCarView.priceTF))  {
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            _isHaveDian = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [MBProgressHUD showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [MBProgressHUD showError:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            [MBProgressHUD showError:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [MBProgressHUD showError:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        } else {
            return YES;
        }
    }
    return YES;
}

// Objective-C语言 "objc://" + "doFunc" + "/" + "payReportOrder/金额,code"
//objc,
//doFunc/payReportOrder/0.10,0dba35fd043b7650b3c50cb610ff8a91

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count]) {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc"]) {
                /*调用本地函数1*/
                NSLog(@"doFunc");
            }
        } else if(2 <= [arrFucnameAndParameter count]) {
            //有参数的
            if([funcStr isEqualToString:@"doFunc"] &&
               [arrFucnameAndParameter objectAtIndex:1]){
                
                
                
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"payReportOrder"]){
                    
                    NSArray *para = [[arrFucnameAndParameter objectAtIndex:2] componentsSeparatedByString:@","];
                    NSString *price = para.firstObject;
                    NSString *code = para.lastObject;
                    [self showPayFreeView:price code:code];
                    NSLog(@"%s", __func__);
                    
                }

                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    self.navigationController.navigationBar.hidden = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                self.bottowView = [self.view viewWithTag:self.bottowTag];
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"hideBottomBar"]) {
                    self.bottowView.hidden = YES;
                    self.webViewBottomConstraint.constant = 0;
                    //self.navigationController.navigationBar.hidden = YES;
                } else if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"showBottomBar"]) {
                    self.bottowView.hidden = NO;
                    self.webViewBottomConstraint.constant = 55;
                    //self.navigationController.navigationBar.hidden = NO;
                }
                
                
                //objc://doFunc/share/http://192.168.1.200/bucheService/report.html?code=334c17965ed148c9ab9f633a980e00f2&isInfoEnter=0&isShare=1,宝沃BX5%202018款%20g%20g,,http://imgs.static.com/EDQR7DTTPa3_VFlSQIHf7UeoYGU=/0x0/uploads/images/bill/201804/26/103030929104.png

                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"share"]) {
                    NSArray *shareArray0 = [urlString componentsSeparatedByString:@"share/"];
                    if (shareArray0.count >= 2) {
                        NSString *shareString0 = shareArray0[1];
                        NSArray *shareArray1 = [shareString0 componentsSeparatedByString:@","];
                        if (shareArray1.count == 1) {
                            self.address = shareArray1[0];
                            self.titles = @"";
                            self.describe = @"";
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 2) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = @"";
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 3) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = [YHTools decodeString:shareArray1[2]];
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 4) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = [YHTools decodeString:shareArray1[2]];
                            self.imageUrl = shareArray1[3];
                        }
                    }
                    
                    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        [self shareWebPageToPlatformType:platformType];
                    }];
                }
            }
        }
        
        return NO;
    }
    return YES;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //1.创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //2.创建网页内容对象
    if (IsEmptyStr(self.describe)) {
        self.describe = @"下载捕车APP，查看更多车源！";
    }
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titles descr:self.describe thumImage:self.imageUrl];
    
    NSLog(@"------%@======",self.address);
    
    //3.设置网页地址
    shareObject.webpageUrl = self.address;
    
    //4.分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //5.调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD showSuccess:@"分享失败" toView:self.view];
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                [MBProgressHUD showSuccess:@"分享成功" toView:self.view];

                //UMSocialShareResponse *resp = data;

                //分享结果消息
                //UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark - ----------------------------------------六、懒加载---------------------------------------------
- (NSMutableArray *)defineDataArray
{
    if (!_defineDataArray) {
        if (_model0) {
            _defineDataArray = [[NSMutableArray alloc]init];
            [_defineDataArray addObject:@"车辆全称"];
            if (!IsEmptyStr(_model0.plateNo)) {
                [_defineDataArray addObject:@"车牌"];//2
            }
            if (!IsEmptyStr(_model0.cc)) {
                [_defineDataArray addObject:@"排放标准"];//3
            }
            if (!IsEmptyStr(_model0.mileage)) {
                [_defineDataArray addObject:@"表显里程"];//4
            }
            if (!IsEmptyStr(_model0.userName)) {
                [_defineDataArray addObject:@"联系人名称"];//4
            }
            if (!IsEmptyStr(_model0.phone)) {
                [_defineDataArray addObject:@"联系人电话"];//5
            }
            if (!IsEmptyStr(_model0.address)) {
                [_defineDataArray addObject:@"看车地址"];//6
            }
            if (!IsEmptyStr(_model0.productDate)) {
                [_defineDataArray addObject:@"生产日期"];//7出厂日期
            }
            if (!IsEmptyStr(_model0.licenseTime)) {
                [_defineDataArray addObject:@"上牌时间"];//8注册日期
            }
            if (!IsEmptyStr(_model0.certificateTime)) {
                [_defineDataArray addObject:@"发证时间"];//9发证日期
            }
            if (!IsEmptyStr(_model0.carNature)) {
                [_defineDataArray addObject:@"车辆性质"];//10
            }
            if (!IsEmptyStr(_model0.useNature)) {
                [_defineDataArray addObject:@"所有者性质"];//11
            }
            if (!IsEmptyStr(_model0.asTime)) {
                [_defineDataArray addObject:@"年检到期时间"];//12.年检到期日
            }
            if (!IsEmptyStr(_model0.inExpireTime)) {
                [_defineDataArray addObject:@"交强险到期时间"];//13.交强险到期日
            }
            if (!IsEmptyStr(_model0.ciTime)) {
                [_defineDataArray addObject:@"商业险到期时间"];//14.商业险到期日
            }
            if (!IsEmptyStr(_model0.transferNun)) {
                [_defineDataArray addObject:@"过户次数"];
            }
            if (!IsEmptyStr(_model0.oilType)) {
                [_defineDataArray addObject:@"燃油类型"];
            }
            if (!IsEmptyStr(_model0.keyType)) {
                [_defineDataArray addObject:@"钥匙"];
            }
            if (!IsEmptyStr(_model0.color)) {
                [_defineDataArray addObject:@"车身颜色"];
            }
//            if (!IsEmptyStr(_model0.helpSellPrice)) {
                [_defineDataArray addObject:@"佣金"];
//            }

        }
    }
    return _defineDataArray;
}

- (NSMutableArray *)dataArray0
{
    if (!_dataArray0) {
        if (_model0) {
            _dataArray0 = [[NSMutableArray alloc]init];
            //            [_dataArray0 addObject: [NSString stringWithFormat:@"%@%@%@%@",_model0.carName,_model0.year,_model0.powerParam,_model0.model]];
            [_dataArray0 addObject: [NSString stringWithFormat:@"%@",_model0.carName]];
            if (!IsEmptyStr(_model0.plateNo)) {
                [_dataArray0 addObject:_model0.plateNo];
            }
            if (!IsEmptyStr(_model0.cc)) {
                [_dataArray0 addObject:_model0.cc];
            }
            if (!IsEmptyStr(_model0.mileage)) {
                [_dataArray0 addObject:[NSString stringWithFormat:@"%@km",_model0.mileage]];
            }
            if (!IsEmptyStr(_model0.userName)) {
                [_dataArray0 addObject:_model0.userName];
            }
            if (!IsEmptyStr(_model0.phone)) {
                [_dataArray0 addObject:_model0.phone];
            }
            if (!IsEmptyStr(_model0.address)) {
                [_dataArray0 addObject:_model0.address];
            }
            if (!IsEmptyStr(_model0.productDate)) {
                if (_model0.productDate.length >= 7) {
                    [_dataArray0 addObject:[_model0.productDate substringWithRange:NSMakeRange(0, 7)]];
                } else {
                    [_dataArray0 addObject:_model0.productDate];
                }
            }
            if (!IsEmptyStr(_model0.licenseTime)) {
                if (_model0.licenseTime.length >= 10) {
                    [_dataArray0 addObject:[_model0.licenseTime substringWithRange:NSMakeRange(0, 10)]];
                } else {
                    [_dataArray0 addObject:_model0.licenseTime];
                }
            }
            if (!IsEmptyStr(_model0.certificateTime)) {
                if (_model0.certificateTime.length >= 10) {
                    [_dataArray0 addObject:[_model0.certificateTime substringWithRange:NSMakeRange(0, 10)]];
                } else {
                    [_dataArray0 addObject:_model0.certificateTime];
                }
            }
            if (!IsEmptyStr(_model0.carNature)) {
                if ([_model0.carNature isEqualToString:@"0"]) {
                    [_dataArray0 addObject:@"营运"];
                } else if ([_model0.carNature isEqualToString:@"1"]){
                    [_dataArray0 addObject:@"非营运"];
                }
            }
            if (!IsEmptyStr(_model0.useNature)) {
                if ([_model0.useNature isEqualToString:@"0"]) {
                    [_dataArray0 addObject:@"私户"];
                } else if ([_model0.useNature isEqualToString:@"1"]){
                    [_dataArray0 addObject:@"公户"];
                }            }
            if (!IsEmptyStr(_model0.asTime)) {
                if (!IsEmptyStr(_model0.asTime)) {
                    if (_model0.asTime.length >= 7) {
                        [_dataArray0 addObject:[_model0.asTime substringWithRange:NSMakeRange(0, 7)]];
                    } else {
                        [_dataArray0 addObject:_model0.asTime];
                    }
                }
            }
            if (!IsEmptyStr(_model0.inExpireTime)) {
                if (!IsEmptyStr(_model0.inExpireTime)) {
                    if (_model0.inExpireTime.length >= 7) {
                        [_dataArray0 addObject:[_model0.inExpireTime substringWithRange:NSMakeRange(0, 7)]];
                    } else {
                        [_dataArray0 addObject:_model0.inExpireTime];
                    }
                }
            }
            if (!IsEmptyStr(_model0.ciTime)) {
                if (!IsEmptyStr(_model0.ciTime)) {
                    if (_model0.ciTime.length >= 10) {
                        [_dataArray0 addObject:[_model0.ciTime substringWithRange:NSMakeRange(0, 10)]];
                    } else {
                        [_dataArray0 addObject:_model0.ciTime];
                    }
                }
            }
            if (!IsEmptyStr(_model0.transferNun)) {
                [_dataArray0 addObject:_model0.transferNun];
            }
            if (!IsEmptyStr(_model0.oilType)) {
                [_dataArray0 addObject:_model0.oilType];
            }
            if (!IsEmptyStr(_model0.keyType)) {
                [_dataArray0 addObject:_model0.keyType];
            }
            if (!IsEmptyStr(_model0.color)) {
                [_dataArray0 addObject:_model0.color];
            }
            if (!IsEmptyStr(_model0.helpSellPrice) && _model0.helpSellPrice.doubleValue > 0) {
                [_dataArray0 addObject:[NSString stringWithFormat:@"%.02f元",_model0.helpSellPrice.doubleValue]];
            }else{
                [_dataArray0 addObject:@"面议"];
            }

        }
    }
    return _dataArray0;
}

@end
