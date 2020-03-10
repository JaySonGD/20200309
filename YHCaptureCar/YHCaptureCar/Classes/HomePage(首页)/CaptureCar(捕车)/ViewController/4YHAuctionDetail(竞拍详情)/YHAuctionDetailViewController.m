//
//  YHAuctionDetailViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionDetailViewController.h"

#import "YHUnableAuctionView.h"
#import "YHMyPriceView.h"
#import "YHBusinessInfoView.h"
#import "YHPayServiceFeeView.h"

#import "YHAuctionDetailModel0.h"
#import "YHAuctionDetailModel1.h"
#import "YHAuctionDetailModel2.h"
#import "YHAuctionDetailModel3.h"

#import "YHAuctionDetailCell0.h"
#import "YHAuctionDetailCell1.h"
#import "YHAuctionDetailCell2.h"

#import "YHPayDepositController.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "YHNetworkManager.h"

#import <MJExtension.h>
#import <UShareUI/UShareUI.h>  //分享面板

#import "YHLoginViewController.h"

extern NSString *const notificationOrderListChange;

NSString *const notificationCarListChange = @"YHNotificationCarListChange";

@interface YHAuctionDetailViewController ()<UMSocialShareMenuViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *priceBox;
@property (weak, nonatomic) IBOutlet UIButton *comfireB;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UILabel *teachL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *changeL;
@property (weak, nonatomic) IBOutlet UIView *allBottomBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomAllBoxheightLC;


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *bidImageView;          //竞价结果标识


@property (weak, nonatomic) IBOutlet UIView *priceAndStateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceAndStateViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;                //左1
@property (weak, nonatomic) IBOutlet UILabel *priceRemindLabel;          //左2
@property (weak, nonatomic) IBOutlet UILabel *auctionFailMaxPriceLabel;  //竞价失败最高出价
@property (weak, nonatomic) IBOutlet UIImageView *ideaImageView;         //中1
@property (weak, nonatomic) IBOutlet UILabel *ideaRemindLabel;           //中2
@property (weak, nonatomic) IBOutlet UILabel *payAuctionLabel;           //右1
@property (weak, nonatomic) IBOutlet UILabel *payAuctionTimeLabel;       //中2

@property (weak, nonatomic) IBOutlet UIView *auctionView1;               //左
@property (weak, nonatomic) IBOutlet UIButton *auctionBtn1;              //左
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auctionView1Height;

@property (weak, nonatomic) IBOutlet UIView *auctionView2;               //中
@property (weak, nonatomic) IBOutlet UIButton *auctionBtn2;              //中
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auctionView2Height;


@property (weak, nonatomic) IBOutlet UIView *auctionView3;               //右
@property (weak, nonatomic) IBOutlet UIButton *auctionBtn3;              //右
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auctionView3Height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewBottom;

@property (nonatomic, strong) UIView *functionView;                      //功能视图
@property (nonatomic, weak) YHUnableAuctionView *unableAuctionView;      //无法竞价视图
@property (nonatomic, weak) YHMyPriceView *myPriceView;                  //我的出价视图
@property (nonatomic, weak) YHBusinessInfoView *businessInfoView;        //交易信息视图
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;      //支付服务费视图

@property (nonatomic, strong) YHAuctionDetailModel0 *model0;             //第6个接口:列表信息模型
@property (nonatomic, strong) YHAuctionDetailModel1 *model1;             //第7个接口:获取状态和价格
@property (nonatomic, strong) YHAuctionDetailModel2 *model2;             //第7个接口:竞价成功交易信息模型
@property (nonatomic, strong) YHAuctionDetailModel3 *model3;             //第8个接口:获取出价信息

@property (nonatomic, assign) BOOL isEditer;                             //是否编辑
@property (nonatomic, assign) BOOL isSelected;                           //标记是否为收藏状态
@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, strong) NSTimer *timer1;                           //定时器1
@property (nonatomic, strong) NSTimer *timer2;                           //定时器2
@property (nonatomic, strong) NSTimer *timer3;                           //定时器3

@property (nonatomic, assign) NSTimeInterval timeInterval1;              //时间间隔1
@property (nonatomic, assign) NSTimeInterval timeInterval2;              //时间间隔2

@property (nonatomic, assign) CGFloat initialRaisePrice;                 //初始加价幅度
@property (nonatomic, assign) CGFloat finalRaisePrice;                   //最终加价幅度

@property (nonatomic, strong) NSString *webpageUrl;                      //分享链接

@end

@implementation YHAuctionDetailViewController

#pragma mark - 视图即将出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 视图加载完成
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"质保车源";

    //加载UI
    [self initUI];
    
    //加载数据
    [self initData];
}

#pragma mark - --------------------------------------加载UI-------------------------------------------
- (void)initUI
{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ((IphoneX)? (44) : (20)))];
    statusBarView.backgroundColor = YHNaviColor;
    [self.view addSubview:statusBarView];
    
    if (self.isAppointment) {
        self.allBottomBox.hidden = YES;
        self.bottomAllBoxheightLC.constant = 0;
    }
}

#pragma mark - --------------------------------------加载数据-------------------------------------------
- (void)initData
{
    //1.列表信息
    [self initData1];
    
    if (!self.isAppointment) {
        //2.获取状态和价格
        [self initData2];
        
        //3.获取出价信息
        [self initData3];
    }
}

#pragma mark - 1.列表信息
- (void)initData1
{
    WeakSelf;
    if (self.isAppointment) {
        
        self.priceBox.hidden = YES;
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        
        [[YHNetworkManager sharedYHNetworkManager] carDetail:[YHTools getAccessToken] carId:self.auctionId onComplete:^(NSDictionary *info) {
            
            [SVProgressHUD dismiss];

            NSLog(@"\n1=======>%@<=======>%@<=======",info,info[@"retMsg"]);
            
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                //1.模型化
                weakSelf.model0 = [YHAuctionDetailModel0 mj_objectWithKeyValues:info[@"result"]];
                
                //2.底部隐藏
                [weakSelf bottomBox:YES];
                
                //3.刷新WebView
                [weakSelf refreshWebViewUI];
              } else {
                YHLogERROR(@"");
                [weakSelf showErrorInfo:info];
            }
        } onError:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [[YHNetworkManager sharedYHNetworkManager] requestCarDetailsWithAuctionId:self.auctionId onComplete:^(NSDictionary *info) {
            
            NSLog(@"\n1=======>%@<=======>%@<=======",info,info[@"retMsg"]);
            
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                //1.模型化
                weakSelf.model0 = [YHAuctionDetailModel0 mj_objectWithKeyValues:info[@"result"]];
                
                //2.刷新WebView
                [weakSelf refreshWebViewUI];
                
                //3.刷新轮播图、收藏UI
                [weakSelf refreshIdentifierAndCollectUI];
                
                //4.刷新竞价结果标识、收藏UI
                [weakSelf refreshStatusAndPriceUI];
            } else {
                YHLogERROR(@"");
                [self showErrorInfo:info];
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 2.获取状态价格
- (void)initData2
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager] getStatusInfoAndPriceWithAuctionId:self.auctionId onComplete:^(NSDictionary *info) {
        
        NSLog(@"\n2=======>%@<=======>%@<=======",info,info[@"retMsg"]);
        
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            //1.模型化
            weakSelf.model1 = [YHAuctionDetailModel1 mj_objectWithKeyValues:info[@"result"]];
            weakSelf.model2 = weakSelf.model1.tradeInfo;
            
            //2.刷新获取状态和价格UI
            [weakSelf refreshStatusAndPriceUI];
            
            //3.竞价中定时刷新价格和时间
            if ([weakSelf.model1.aucStatus isEqualToString:@"1"]) {
                weakSelf.timer1 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(action1:) userInfo:nil repeats:YES];
            }
            
        }else{
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 3.获取出价信息
- (void)initData3
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager] getBidInfo:self.auctionId onComplete:^(NSDictionary *info) {
        
        NSLog(@"\n3=======>%@<=======>%@<=======",info,info[@"retMsg"]);
        
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            //1.模型化
            weakSelf.model3 = [YHAuctionDetailModel3 mj_objectWithKeyValues:info[@"result"]];
            
            //2.刷新获取状态和价格UI
            [weakSelf refreshStatusAndPriceUI];
        } else {
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - -------------------------------------刷新UI代码------------------------------------------
#pragma mark - 1.刷新WebViewUI
- (void)refreshWebViewUI
{
    NSLog(@"====%@====",[NSString stringWithFormat:@"%s/bucheService/report.html?code=%@&status=ios",SERVER_PHP_URL_Statements_H5,self.model0.rptUrl]);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s/bucheService/report.html?code=%@&status=ios",SERVER_PHP_URL_Statements_H5,self.model0.rptUrl]]]];
}
//http://192.168.1.220/bucheService/report.html?code=b778b390499a7a4575549fa371844783&sellAmt=0.00&key=1F18386551E49E03B321BAA7BA95A4A1&status=ios#pragma mark - 2.刷新报价UI
- (void)refreshOfferUI
{
    self.bottomAllBoxheightLC.constant = (([self.model0.status isEqualToString:@"0"] || self.model0.status == nil)? (55) : (0));
    self.teachL.text = self.model0.techName;
    self.priceL.text = [NSString stringWithFormat:@"%.02f万",[self.model0.offer floatValue]];
}

#pragma mark - 3.刷新竞价结果标识、收藏UI
- (void)refreshIdentifierAndCollectUI
{
    //刷新竞价结果标识UI
//    if ([self.jumpString isEqualToString:@"竞价管理跳转"]) {
//        if ([self.model0.isStatus isEqualToString:@"1"]) {
//            [self.bidImageView setImage:[UIImage imageNamed:@"icon_auctionSuccessDeatil"]];
//        } else if ([self.model0.isStatus isEqualToString:@"0"]) {
//            [self.bidImageView setImage:[UIImage imageNamed:@"icon_uncompetitiveDeatil"]];
//        }
//    }
    
    //刷新竞价意向UI
    if ([self.model0.isPurpose isEqualToString:@"0"]) {
        self.isSelected = NO;
        [self.ideaImageView setImage:[UIImage imageNamed:@"icon_unSelected"]];
    } else if ([self.model0.isPurpose isEqualToString:@"1"]) {
        self.isSelected = YES;
        [self.ideaImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    }
}

#pragma mark - 4.刷新获取状态和价格UI
- (void)refreshStatusAndPriceUI
{
    //3个模型都有数据才去刷新UI
    if (!self.model0 || !self.model1 || !self.model3) {
        return;
    }
    
    //一.未竞价(即将开拍)
    if ([self.model1.aucStatus isEqualToString:@"0"]) {
        
        self.auctionBtn3.userInteractionEnabled = NO;
        
        //1.左边
        //(1)左上
        self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[self.model1.startPrice floatValue]];
        self.priceLabel.textColor = YHNaviColor;
        
        //(2)左下
        self.priceRemindLabel.text = @"起拍价";
        
        //2.右边
        self.auctionView3.backgroundColor = YHNaviColor;
        
        //(1)右上
        self.payAuctionLabel.text = @"即将开拍";
        self.payAuctionLabel.textColor = YHWhiteColor;
        
        //(2)右下
        [self getTimeIntervalWithStartTime:self.model1.startTime];
        self.payAuctionTimeLabel.textColor = YHWhiteColor;
        
    //二.竞价中(竞价中、正在参与)
    } else if ([self.model1.aucStatus isEqualToString:@"1"]) {
        
        //我当前是最高价
        if ([self.model1.isMax isEqualToString:@"1"]) {
            
            NSLog(@"===========---我是最高价---============");
            
            //1.左边
            //(1)左上
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[self.model1.maxPrice floatValue]];
            self.priceLabel.textColor = YHRedColor;
            
            //(2)左下
            self.priceRemindLabel.text = @"我的价格";
            
            //2.右边
            self.auctionView3.backgroundColor = YHRedColor;
            
            //(1)右上
            self.payAuctionLabel.text = @"最高价";
            self.payAuctionLabel.textColor = YHWhiteColor;
            
            //我是最高价, 不可点击
            self.auctionBtn3.userInteractionEnabled = NO;
            
        //我当前不是最高价
        } else if ([self.model1.isMax isEqualToString:@"0"]) {
            
            NSLog(@"===========我不是最高价============");
            
            //1.左边
            //(1)左上
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[self.model1.maxPrice floatValue]];
            self.priceLabel.textColor = YHNaviColor;
            
            //(2)左下
            self.priceRemindLabel.text = @"当前价格";
            
            //2.右边
            self.auctionView3.backgroundColor = YHNaviColor;
            
            self.payAuctionLabel.text = @"出价";
            self.payAuctionLabel.textColor = YHWhiteColor;
            
            //出价次数为0的时候
            if ([self.model3.bidNum isEqualToString:@"0"]) {
                self.payAuctionLabel.text = @"出价(剩余0次)";
                self.payAuctionLabel.textColor = YHWhiteColor;
                self.auctionView3.backgroundColor = YHLightGrayColor;
            }
            
            //保证金余额不足
            if ([self.model0.depositStatus isEqualToString:@"2"]) {
                self.auctionView3.backgroundColor = YHLightGrayColor;
                self.payAuctionLabel.text = @"可用保证金不足";
                self.payAuctionLabel.textColor = YHWhiteColor;
            }
            
            //我是最高价, 可点击
            self.auctionBtn3.userInteractionEnabled = YES;
        }
        
        //(2)右下
        self.payAuctionTimeLabel.text = [self getTimeIntervalWithStartTime:self.model1.startTime WithEndTime:self.model1.endTime];
        self.payAuctionTimeLabel.textColor = YHWhiteColor;
        
    //三.竞价成功(竞价成功、竞价记录点进来)
    } else if ([self.model1.aucStatus isEqualToString:@"2"]) {
        
        //1.左边
        //(1)左上
        self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[self.model1.maxPrice floatValue]];
        self.priceLabel.textColor = YHRedColor;
        
        //(2)左下
        self.priceRemindLabel.text = @"竞得价";
        
        //2.中间
        self.ideaImageView.hidden = YES;
        self.ideaRemindLabel.hidden = YES;
        [self.auctionBtn2 setTitle:@"查看交易信息" forState:UIControlStateNormal];
        [self.auctionBtn2 setTitleColor:YHBlackColor forState:UIControlStateNormal];
        
        //2.右边
        //(1)0待支付、2支付失败
        self.auctionBtn3.backgroundColor = YHRedColor;
        if ([self.model1.payStatus isEqualToString:@"0"] || [self.model1.payStatus isEqualToString:@"2"]) {
            [self.auctionBtn3 setTitle:@"支付服务费" forState:UIControlStateNormal];
        //(2)1支付成功
        } else if ([self.model1.payStatus isEqualToString:@"1"]) {
            [self.auctionBtn3 setTitle:@"服务费已支付" forState:UIControlStateNormal];
            self.auctionBtn3.userInteractionEnabled = NO;  //隐藏人机交互
        } else {
            [self.auctionBtn3 setTitle:@"其它" forState:UIControlStateNormal];
            self.auctionBtn3.userInteractionEnabled = NO;  //隐藏人机交互
        }
        [self.auctionBtn3 setTitleColor:YHWhiteColor forState:UIControlStateNormal];
        
    //四.竞价失败(竞价记录点进来)
    } else if ([self.model1.aucStatus isEqualToString:@"3"]) {
        
        self.auctionView1.hidden = YES;
        self.auctionView2.hidden = YES;
        self.auctionBtn1.hidden = YES;
        self.auctionBtn1.hidden = YES;
        self.auctionBtn3.userInteractionEnabled = NO;   //隐藏人机交互
        
        //1.左边
        self.auctionFailMaxPriceLabel.text = [NSString stringWithFormat:@"最终出价:%.02f万",[self.model1.maxPrice floatValue]];
        self.auctionFailMaxPriceLabel.textColor = YHRedColor;
        
        //2.右边
        self.auctionView3.backgroundColor = YHRedColor;
        
        //(1)右上
        self.payAuctionLabel.text = [NSString stringWithFormat:@"%.02f万",[self.model1.userPrice floatValue]];
        self.payAuctionLabel.textColor = YHWhiteColor;
        
        //(2)右下
        self.payAuctionTimeLabel.text = @"我的最高价";
        self.payAuctionTimeLabel.textColor = YHWhiteColor;
        
    //五.竞价结果计算中，请稍后查看
    } else if ([self.model1.aucStatus isEqualToString:@"4"]) {
        
        self.auctionView1.hidden = YES;
        self.auctionView2.hidden = YES;
        self.auctionBtn1.hidden = YES;
        self.auctionBtn1.hidden = YES;
        self.auctionBtn3.userInteractionEnabled = NO;   //隐藏人机交互
        
        //1.左边
        self.auctionFailMaxPriceLabel.text = @"中标信息计算中...";
        self.auctionFailMaxPriceLabel.textColor = YHRedColor;
        
        //2.右边
        self.payAuctionLabel.text = @"";
        self.payAuctionTimeLabel.text = @"";
        self.auctionView3.backgroundColor = YHLightGrayColor;
        [self.auctionBtn3 setTitle:@"竞价结束" forState:UIControlStateNormal];
        [self.auctionBtn3 setTitleColor:YHWhiteColor forState:UIControlStateNormal];
    }
}

#pragma mark - ----------------------------------竞价操作业务逻辑代码--------------------------------------
#pragma mark - 操作1
- (IBAction)AuctionOne:(UIButton *)sender
{
    
}

#pragma mark - 操作2
- (IBAction)AuctionTwo:(UIButton *)sender
{
    [self showBusinessInfoViewWithButton:sender];
}

#pragma mark - 操作3
- (IBAction)AuctionThree:(UIButton *)sender
{
    //1.如果是“竞价成功”状态
    //(1)待支付、支付失败
    if ([sender.titleLabel.text isEqualToString:@"支付服务费"]) {
        [self showPayServiceFeeView];
    //(2)服务费已支付
    } else if ([sender.titleLabel.text isEqualToString:@"服务费已支付"]) {
        return;
    //2.如果不是“竞价成功”状态
    } else {
        //0未交保证金(无法竞价)
        if ([self.model0.depositStatus isEqualToString:@"0"]) {
            [self showUnableToAuctionView];
        //1已交保证金(我的出价)
        } else if ([self.model0.depositStatus isEqualToString:@"1"]) {
            //加价初始幅度
            self.initialRaisePrice = self.model0.raisePrice.floatValue;
            NSLog(@"1<<<<<<------加价初始幅度:%f======",self.initialRaisePrice);
            
            //加价最终幅度
            self.finalRaisePrice = self.initialRaisePrice;
            NSLog(@"2<<<<<<------加价最终幅度:%f======",self.finalRaisePrice);
            
            //每次点击重新获取出价次数
            [self initData3];
            
            if (![self.model3.bidNum isEqualToString:@"0"]) {
                [self showMyPriceView];
            } else {
                [MBProgressHUD showError:@"出价次数不够了"];
            }
        //2保证金余额不足
        } else if ([self.model0.depositStatus isEqualToString:@"2"]) {
            self.auctionView3.backgroundColor = YHLightGrayColor;
            self.payAuctionLabel.text = @"可用保证金不足";
        }
    }
}

#pragma mark - 操作4
- (IBAction)comfireAction:(id)sender
{
    if (_isEditer) {
        if (self.priceTF.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入报价"];
            return;
        }
        [SVProgressHUD showWithStatus:@"提交中..."];
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkManager sharedYHNetworkManager] SetVehiclePricesWithToken:[YHTools getAccessToken] carId:_auctionId price:_priceTF.text onComplete:^(NSDictionary *info) {
            [SVProgressHUD dismiss];
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"报价成功" toView:weakSelf.navigationController.view];
                [[NSNotificationCenter
                  defaultCenter]postNotificationName:notificationCarListChange
                 object:Nil
                 userInfo:nil];
                [weakSelf popViewController:nil];
                //                 [weakSelf initData1];
            }else{
                YHLogERROR(@"");
                [weakSelf showErrorInfo:info];
            }
        } onError:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
    }
    _isEditer = !_isEditer;
    [self bottomBox:_isEditer];
}

- (void)bottomBox:(BOOL)isEditer
{
    NSString *price  = self.model0.offer;
    
    _teachL.hidden = isEditer;
    _priceTF.hidden = !isEditer;
    _unitL.hidden = !isEditer;
    _comfireB.titleLabel.text = ((isEditer)? (@"确定") : ((IsEmptyStr(price))? (@"设置价格") : (@"")));
    [_comfireB setTitle:((isEditer)? (@"确定") : ((IsEmptyStr(price))? (@"设置价格") : (@""))) forState:UIControlStateNormal];
    
    //_comfireB.hidden = !(IsEmptyStr(price)) && !_isEditer;
    _changeL.hidden = (IsEmptyStr(price)) || isEditer;
    _priceL.hidden = (IsEmptyStr(price)) || isEditer;
}

#pragma mark - ------------------------------------功能模块代码-------------------------------------------
#pragma mark - 1.我的出价
- (void)showMyPriceView
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.myPriceView) {
        self.myPriceView = [[NSBundle mainBundle]loadNibNamed:@"YHMyPriceView" owner:self options:nil][0];
        self.myPriceView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.myPriceView.layer.cornerRadius = 5;
        self.myPriceView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.myPriceView];
    }
    
    //刷新UI
    //(1)我的出价
    self.myPriceView.myPriceNumLabel.text = [NSString stringWithFormat:@"%.2f万",self.model1.maxPrice.floatValue + self.finalRaisePrice / 10000];
    
    //(2)加价幅度
    self.myPriceView.addRangeLabel.text = self.model0.raisePrice;
    
    //(3)是否第一次出价: 0是  1否 (如果是第一次，那么需要显示保证金金额)
    if ([self.model3.isFirstBid isEqualToString:@"0"]) {
        self.myPriceView.bidNumLabel.hidden = NO;
        self.myPriceView.depositLabel.hidden = NO;
        self.myPriceView.bidNumLabel2.hidden = YES;
        
        self.myPriceView.depositLabel.text = [NSString stringWithFormat:@"冻结保证金:%@元",self.model3.depositAmt];//3.保证金金额
        self.myPriceView.bidNumLabel.text = [NSString stringWithFormat:@"还可出价:%@次",self.model3.bidNum];//4.出价次数
    } else {
        self.myPriceView.depositLabel.hidden = YES;
        self.myPriceView.bidNumLabel.hidden = YES;
        self.myPriceView.bidNumLabel2.hidden = NO;
        
        self.myPriceView.bidNumLabel2.text = [NSString stringWithFormat:@"还可出价:%@次",self.model3.bidNum]; //出价次数
    }
    
    //点击事件
    self.myPriceView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://减价
                //如果最终减价幅度 > 原始减价幅度
                if (weakSelf.finalRaisePrice > weakSelf.initialRaisePrice) {
                    weakSelf.finalRaisePrice -= weakSelf.initialRaisePrice;
                    weakSelf.myPriceView.addRangeLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.finalRaisePrice];//减价幅度
                //如果最终减价幅度 <= 原始减价幅度
                } else {
                    weakSelf.myPriceView.addRangeLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.initialRaisePrice];//减价幅度
                    [MBProgressHUD showError:@"出价不能低于当前价格"];
                }
                weakSelf.myPriceView.myPriceNumLabel.text = [NSString stringWithFormat:@"%.2f万",weakSelf.model1.maxPrice.floatValue + weakSelf.finalRaisePrice / 10000];//我的出价
                break;
            case 3://加价
                weakSelf.finalRaisePrice += weakSelf.initialRaisePrice;
                weakSelf.myPriceView.addRangeLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.finalRaisePrice];//加价幅度
                weakSelf.myPriceView.myPriceNumLabel.text = [NSString stringWithFormat:@"%.2f万",weakSelf.model1.maxPrice.floatValue + weakSelf.finalRaisePrice / 10000];//我的出价
                break;
            case 4://取消
                [weakSelf.functionView removeFromSuperview];
                break;
                
            case 5://确定(保存出价)
            {
                if (![weakSelf.model3.bidNum isEqualToString:@"0"]) {
                    NSString *finalPrice = [NSString stringWithFormat:@"%f",weakSelf.model1.maxPrice.floatValue + weakSelf.finalRaisePrice / 10000];
                    [[YHNetworkManager sharedYHNetworkManager] saveBidPriceWithAuctionId:weakSelf.auctionId bidPrice:finalPrice onComplete:^(NSDictionary *info) {
                        if ([info[@"retCode"] isEqualToString:@"0"]) {
                            
                            [MBProgressHUD showSuccess:@"出价成功"];
                            
                            [weakSelf.functionView removeFromSuperview];
                            
                            //第一次出价成功后,就不是第一次出价了,isFirstBid字段置为1
                            weakSelf.model3.isFirstBid = @"1";
                            
                            //每次出价成功,model3的出价次数bidNum减1,避免下次网络数据没有出来,出价视图显示的出价次数还是上一次的出价次数
                            weakSelf.model3.bidNum = [NSString stringWithFormat:@"%d",[weakSelf.model3.bidNum intValue]-1];
                        } else {
                            YHLogERROR(@"");
                            [self showErrorInfo:info];
                        }
                    } onError:^(NSError *error) {
                        
                    }];
                } else {
                    [weakSelf.functionView removeFromSuperview];
                    [MBProgressHUD showError:@"出价次数不够了"];
                }
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 2.支付服务费
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
                [weakSelf gpaymentAuctionId:weakSelf.auctionId isBuy:YES onComplete:^(NSDictionary *info) {//更新页面;
                    [weakSelf initData];
                    [weakSelf.functionView removeFromSuperview];
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

#pragma mark - 3.无法竞价
- (void)showUnableToAuctionView
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.unableAuctionView) {
        self.unableAuctionView = [[NSBundle mainBundle]loadNibNamed:@"YHUnableAuctionView" owner:self options:nil][0];
        self.unableAuctionView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.unableAuctionView.layer.cornerRadius = 5;
        self.unableAuctionView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.unableAuctionView];
    }
    
    self.unableAuctionView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1:
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2:
                [weakSelf.functionView removeFromSuperview];
                break;
            case 3:
            {
                [weakSelf.unableAuctionView removeFromSuperview];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [weakSelf.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"YHPayDepositController"] animated:YES];
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 4.查看交易信息
- (void)showBusinessInfoViewWithButton:(UIButton *)button
{
    WeakSelf;
    //如果是“竞价成功”状态
    if ([button.titleLabel.text isEqualToString:@"查看交易信息"]) {
        self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
        [self.view addSubview:self.functionView];
        
        if (!self.businessInfoView) {
            self.businessInfoView = [[NSBundle mainBundle]loadNibNamed:@"YHBusinessInfoView" owner:self options:nil][0];
            self.businessInfoView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
            self.businessInfoView.layer.cornerRadius = 5;
            self.businessInfoView.layer.masksToBounds = YES;
            [self.functionView addSubview:self.businessInfoView];
        }
        
        //刷新UI
        if (!IsEmptyStr(self.model2.sellAddr)) {
            self.businessInfoView.tradingPlaceLabel.text = self.model2.sellAddr;
        } else {
            self.businessInfoView.tradingPlaceLabel.text = @"暂无交易地点";
        }
        
        if (!IsEmptyStr(self.model2.phone) && !IsEmptyStr(self.model2.contact)) {
            self.businessInfoView.telePhoneLabel.text = [NSString stringWithFormat:@"%@(%@)",self.model2.phone,self.model2.contact];
        } else if (!IsEmptyStr(self.model2.phone) && IsEmptyStr(self.model2.contact)){
            self.businessInfoView.telePhoneLabel.text = [NSString stringWithFormat:@"%@(%@)",self.model2.phone,@"暂无联系人"];
        }  else if (IsEmptyStr(self.model2.phone) && !IsEmptyStr(self.model2.contact)){
            self.businessInfoView.telePhoneLabel.text = [NSString stringWithFormat:@"%@(%@)",@"暂无联系电话",self.model2.contact];
        } else {
            self.businessInfoView.telePhoneLabel.text = @"暂无联系电话";
        }
        
        if (!IsEmptyStr(self.model2.note)) {
            self.businessInfoView.noteLabel.text = [NSString stringWithFormat:@"%@",self.model2.note];
        } else {
            self.businessInfoView.noteLabel.text = @"请于两天内凭本账号登记的身份证、手机号等相关资料前往交易地点办理交易手续并交款";
        }
        
        self.businessInfoView.btnClickBlock = ^(UIButton *button) {
            [weakSelf.functionView removeFromSuperview];
        };
        
    //如果不是“竞价成功”状态
    } else {
        //如果已经收藏,点击变不收藏
        if (self.isSelected == YES) {
            [[YHNetworkManager sharedYHNetworkManager] auctionInatentionWithAuctionId:self.auctionId FavStatus:@"2" onComplete:^(NSDictionary *info) {
                if ([info[@"retCode"] isEqualToString:@"0"]) {
                    weakSelf.isSelected = NO;
                    [MBProgressHUD showSuccess:@"取消收藏成功"];
                    [weakSelf.ideaImageView setImage:[UIImage imageNamed:@"icon_unSelected"]];
                } else {
                    YHLogERROR(@"");
                    [weakSelf showErrorInfo:info];
                }
            } onError:^(NSError *error) {
                [MBProgressHUD showError:@"取消收藏失败"];
            }];
        //如果没有收藏,点击变收藏
        } else {
            [[YHNetworkManager sharedYHNetworkManager] auctionInatentionWithAuctionId:self.auctionId FavStatus:@"1" onComplete:^(NSDictionary *info) {
                if ([info[@"retCode"] isEqualToString:@"0"]) {
                    weakSelf.isSelected = YES;
                    [MBProgressHUD showSuccess:@"收藏成功"];
                    [weakSelf.ideaImageView setImage:[UIImage imageNamed:@"icon_selected"]];
                }else{
                    YHLogERROR(@"");
                    [weakSelf showErrorInfo:info];
                }
            } onError:^(NSError *error) {
                [MBProgressHUD showError:@"收藏失败"];
            }];
        }
    }
}

#pragma mark - ------------------------------------获取时间代码------------------------------------------
#pragma mark - 1.获取时间间隔
- (NSString *)getTimeIntervalWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
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
    if (self.timeInterval1 < 0) {
        [self.timer1 invalidate];
        self.timer1 = nil;
        [self.timer1 setFireDate:[NSDate distantFuture]];
    }
    
    //4.计算天数、时、分、秒
    int days = ((int)self.timeInterval1)/(3600*24);
    int hours = ((int)self.timeInterval1)%(3600*24)/3600;
    int minutes = ((int)self.timeInterval1)%(3600*24)%3600/60;
    int seconds = ((int)self.timeInterval1)%(3600*24)%3600%60;
    if (days > 0) {
        NSLog(@"\n1=============>%@",[NSString stringWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds]);
        return [NSString stringWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
    } else {
        NSLog(@"\n2=============>%@",[NSString stringWithFormat:@"%i时%i分%i秒",hours,minutes,seconds]);
        return [NSString stringWithFormat:@"%i时%i分%i秒",hours,minutes,seconds];
    }
}

#pragma mark - 2.获取时间间隔
- (void)getTimeIntervalWithStartTime:(NSString *)startTime
{
    //1.首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //2.然后创建日期对象
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *currentDate = [NSDate date];
    
    //3.计算时间间隔（单位是秒）
    self.timeInterval2 = [startDate timeIntervalSinceDate:currentDate];
    
    if (!self.timer2) {
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action2:) userInfo:nil repeats:YES];
    }
}

#pragma mark - -------------------------------------定时器代码-------------------------------------------
#pragma mark - 1.获取状态和价格定时器
- (void)action1:(NSTimer *)timer
{
    NSLog(@"\n==================================1.获取状态和价格定时器===================================");
    [[YHNetworkManager sharedYHNetworkManager] getStatusInfoAndPriceWithAuctionId:self.auctionId onComplete:^(NSDictionary *info) {
        NSLog(@"\n222222=======>%@<=======>%@<=======",info,info[@"retMsg"]);
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            self.model1 = [YHAuctionDetailModel1 mj_objectWithKeyValues:info[@"result"]];
            self.model2 = self.model1.tradeInfo;
            [self refreshStatusAndPriceUI];//刷新获取状态和价格UI
        }else{
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 2.即将开拍倒计时定时器
- (void)action2:(NSTimer *)timer
{
    NSLog(@"\n==================================2.即将开拍倒计时定时器===================================");
    
    //倒计时-1
    self.timeInterval2 -= 1;
    
    if(self.timeInterval2 <= 0) {
        
        //关闭定时器2
        [self.timer2 invalidate];
        self.timer2 = nil;
        [self.timer2 setFireDate:[NSDate distantFuture]];
        
        //启用定时器3
        if (!self.timer3) {
            self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action3:) userInfo:nil repeats:YES];
        }
        return;
    }
    
    int days = ((int)self.timeInterval2)/(3600*24);
    int hours = ((int)self.timeInterval2)%(3600*24)/3600;
    int minutes = ((int)self.timeInterval2)%(3600*24)%3600/60;
    int seconds = ((int)self.timeInterval2)%(3600*24)%3600%60;
    self.payAuctionTimeLabel.text = [[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
    NSLog(@"剩下:%@",[[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds]);
}

#pragma mark - 3.即将开拍倒计时结束后变出价定时器
- (void)action3:(NSTimer *)timer
{
    NSLog(@"\n==================================3.即将开拍倒计时结束后变出价定时器===================================");
    
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager] getStatusInfoAndPriceWithAuctionId:weakSelf.auctionId onComplete:^(NSDictionary *info) {
        
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            weakSelf.model1 = [YHAuctionDetailModel1 mj_objectWithKeyValues:info[@"result"]];
            
            weakSelf.model2 = weakSelf.model1.tradeInfo;
            
            if ([weakSelf.model1.aucStatus isEqualToString:@"1"]) {
                
                NSLog(@"------------------------------------即将开拍------------>竞价中------------------------------------");
                //1.关闭、销毁定时器
                [self.timer3 invalidate];
                self.timer3 = nil;
                [self.timer3 setFireDate:[NSDate distantFuture]];
                
                //2.刷新获取状态和价格UI
                [weakSelf refreshStatusAndPriceUI];
                
                //3.竞价中定时刷新价格和时间
                if ([weakSelf.model1.aucStatus isEqualToString:@"1"]) {
                    weakSelf.timer1 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(action1:) userInfo:nil repeats:YES];
                }
            }
        } else if ([info[@"retCode"] isEqualToString:@"COMMON020"]) {
            //1.左边
            weakSelf.auctionFailMaxPriceLabel.text = [NSString stringWithFormat:@"起拍价格:%@万",self.model1.startPrice];
            weakSelf.auctionFailMaxPriceLabel.textColor = YHNaviColor;
            
            //2.右边
            weakSelf.auctionView3.backgroundColor = YHLightGrayColor;
            weakSelf.payAuctionLabel.text = @"已取消";
            weakSelf.payAuctionLabel.textColor = YHWhiteColor;
            
            weakSelf.auctionView1.hidden = YES;
            weakSelf.auctionView2.hidden = YES;
            weakSelf.auctionBtn1.hidden = YES;
            weakSelf.auctionBtn1.hidden = YES;
            weakSelf.auctionBtn3.userInteractionEnabled = YES;//隐藏人机交互
            
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - 4.视图即将消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer1 invalidate];
    self.timer1 = nil;
    [self.timer2 invalidate];
    self.timer2 = nil;
    [self.timer3 invalidate];
    self.timer3 = nil;
}

#pragma mark - -------------------------------------公共方法------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _priceTF )  {
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
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

// Objective-C语言
/*
 UIWebViewNavigationTypeLinkClicked,
 UIWebViewNavigationTypeFormSubmitted,
 UIWebViewNavigationTypeBackForward,
 UIWebViewNavigationTypeReload,
 UIWebViewNavigationTypeFormResubmitted,
 UIWebViewNavigationTypeOther
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"\n=========1:%@==========2:%@==========3:%ld=========",webView,request,navigationType);
    
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"\n------1、urlString：%@------",urlString);
//     urlString =    objc://doFunc/share/分享地址,分享title,分享副标题,分享图片地址
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"\n------2、urlComps：%@------",urlComps);
    
    if([urlComps count] && [[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSLog(@"\n------3、arrFucnameAndParameter：%@------",arrFucnameAndParameter);

        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        NSLog(@"\n------4、funcStr：%@------",funcStr);

        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc"])
            {
                /*调用本地函数1*/
                NSLog(@"doFunc");
            }
        }
        else if(2 <= [arrFucnameAndParameter count])
        {
            //有参数的
            if([funcStr isEqualToString:@"doFunc"] &&
               [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    [[NSNotificationCenter
                      defaultCenter]postNotificationName:notificationOrderListChange
                     object:Nil
                     userInfo:nil];
                    [self popViewController:nil];
                }
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"relogin"]) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"home"]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"share"]) {

                    self.webpageUrl = [NSString stringWithFormat:@"http://%@",urlComps[2]];
                    NSLog(@"\n------====分享链接：%@====------",self.webpageUrl);
                    
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
    //(1)分享主标题（车型名称)
    NSString *title;
    if (!IsEmptyStr(self.model0.carNo) && (!IsEmptyStr(self.model0.fullName) || !IsEmptyStr(self.model0.name) || !IsEmptyStr(self.model0.desc))) {
        if (!IsEmptyStr(self.model0.fullName)) {
            title = [NSString stringWithFormat:@"%@",self.model0.fullName];
        } else if (!IsEmptyStr(self.model0.name)) {
            title = [NSString stringWithFormat:@"%@",self.model0.name];
        } else if (!IsEmptyStr(self.model0.desc)) {
            title = [NSString stringWithFormat:@"%@",self.model0.desc];
        }
    } else {
        title = @"";
    }
    
    //(2)分享副标题（下载捕车APP，查看更多车源）
    NSString *descr = @"下载捕车APP，查看更多车源！";
    
    //(3)分享图片（详情页轮播图第一张）
    NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
    if (!IsEmptyStr(self.model0.carPicture)) {
        NSArray *array = [self.model0.carPicture componentsSeparatedByString:@","];
        for (NSString *str in array) {
            [imagesArray addObject:[NSString stringWithFormat:@"%@%@",SERVER_JAVA_IMAGE_URL,str]];
        }
    } else {
        [imagesArray addObject:[UIImage imageNamed:@"icon_auctionDetailBanner"]];
    }
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:imagesArray[0]];
    
    //3.设置网页地址
    shareObject.webpageUrl = self.webpageUrl;
    
    //4.分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //5.调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD showSuccess:@"分享失败" toView:self.view];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
