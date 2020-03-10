//
//  YTDetailViewController.m
//  YHCaptureCar
//
//  Created by Jay on 25/5/2019.
//  Copyright © 2019 YH. All rights reserved.
//

#import "YTDetailViewController.h"
#import "YHWebFuncViewController.h"

#import "YTDetailInfoCell.h"

#import "YHNetworkManager.h"


#import <SDCycleScrollView.h>
#import <UShareUI/UShareUI.h>  //分享面板
#import <MBProgressHUD.h>

#import "YHTools.h"

#import "YHPayServiceFeeView.h"
#import "YHHelpSellService.h"

#import "TTZCarModel.h"

#import "YTCarModel.h"

#import "WXPay.h"
#import "YHDiagnosisBaseTC.h"

#import <MJExtension.h>

#import "YHCarBaseModel.h"

#import "YHHUPhotoBrowser.h"

#import "YHMapViewController.h"
@interface YTDetailViewController ()<UITableViewDataSource,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstrains;
@property (weak, nonatomic) IBOutlet UIButton *bottomERPAuthView;

@property (weak, nonatomic) IBOutlet UIView *bottomHelpSellView;
@property (weak, nonatomic) IBOutlet UIButton *bottomHelpSellPrice;
@property (weak, nonatomic) IBOutlet UIButton *bottomHelpSellLove;
@property (weak, nonatomic) IBOutlet UIButton *bottomHelpSellPReport;
@property (weak, nonatomic) IBOutlet UILabel *bottomHelpSellTitle;


//功能视图
@property (nonatomic, strong) UIView *functionView;

//支付服务费视图
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;

@property (nonatomic, strong) YTCarModel *detail;

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*tableData;

@property (nonatomic, weak) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UILabel * bannerL;
@end

@implementation YTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)loadERPDetail{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [YHHelpSellService erpAuthDetailWithCarId:self.carModel.carId onComplete:^(YTCarModel *obj) {
        [MBProgressHUD hideHUDForView:self.view];
        self.detail = obj;
        [self refreshBottom];

    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
}

- (void)loadHelpBuyDetail{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [YHHelpSellService helpBuyAuthDetailWithCarId:self.carModel.carId onComplete:^(YTCarModel *obj) {
        [MBProgressHUD hideHUDForView:self.view];
        self.detail = obj;
        self.tableData = [NSMutableArray array];
        [self.tableData addObject:@{@"title":@"车牌属地",@"name":IsEmptyStr(obj.plateNo)?@"未提供":[obj.plateNo substringToIndex:2]}];
        //[self.tableData addObject:@{@"title":@"车架号",@"name":IsEmptyStr(obj.vin)?@"未提供":obj.vin}];
        [self.tableData addObject:@{@"title":@"车辆里程",@"name":IsEmptyStr(obj.tripDistance)?@"未提供":obj.tripDistance}];
        [self.tableData addObject:@{@"title":@"车辆全称",@"name":IsEmptyStr(obj.carFullName)?@"未提供":obj.carFullName}];
        [self.tableData addObject:@{@"title":@"排放标准",@"name":IsEmptyStr(obj.emissionsStandards)?@"未提供":obj.emissionsStandards}];
        [self.tableData addObject:@{@"title":@"出厂日期",@"name":IsEmptyStr(obj.productionDate)?@"未提供":obj.productionDate}];
        [self.tableData addObject:@{@"title":@"注册日期",@"name":IsEmptyStr(obj.registrationDate)?@"未提供":obj.registrationDate}];
        [self.tableData addObject:@{@"title":@"发证日期",@"name":IsEmptyStr(obj.issueDate)?@"未提供":obj.issueDate}];
        [self.tableData addObject:@{@"title":@"车辆性质",@"name":IsEmptyStr(obj.carNature)?@"未提供":obj.carNature}];
        //[self.tableData addObject:@{@"title":@"车辆性质",@"name":obj.carNature?@"非营运":@"营运"}];
        //[self.tableData addObject:@{@"title":@"使用性质",@"name":obj.userNature?@"公户":@"私户"}];
        [self.tableData addObject:@{@"title":@"使用性质",@"name":IsEmptyStr(obj.userNature)?@"未提供":obj.userNature}];

        
        [self.tableData addObject:@{@"title":@"商业险到期时间",@"name":IsEmptyStr(obj.businessInsuranceDate)?@"未提供":obj.businessInsuranceDate}];

        [self.tableData addObject:@{@"title":@"年检到期时间",@"name":IsEmptyStr(obj.endAnnualSurveyDate)?@"未提供":obj.endAnnualSurveyDate}];
        [self.tableData addObject:@{@"title":@"交强险到期时间",@"name":IsEmptyStr(obj.trafficInsuranceDate)?@"未提供":obj.trafficInsuranceDate}];
        [self.tableData addObject:@{@"title":@"商业险到期时间",@"name":IsEmptyStr(obj.businessInsuranceDate)?@"未提供":obj.businessInsuranceDate}];
        if (obj.payStatus) {
            void (^navBlock)(void) = ^(){
                [self gotoMap:obj.carLocation];
            };
            [self.tableData addObject:@{@"title":@"检测地点",@"name":IsEmptyStr(obj.carLocation)?@"未提供":obj.carLocation,@"icon":@"icon_landmark",@"action":navBlock}];

            
            [self.tableData addObject:@{@"title":@"联系人",@"name":IsEmptyStr(obj.carContact)?@"未提供":obj.carContact}];
            
            void (^callBlock)(void) = ^(){
                NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", obj.carContactTel];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                }

            };
            
            [self.tableData addObject:@{@"title":@"联系电话",@"name": IsEmptyStr(obj.carContactTel)?@"未提供": obj.carContactTel,@"icon":@"icon_IPhone",@"action":callBlock}];

        }else{
            
            [self.tableData addObject:@{@"title":@"检测地点",@"name":IsEmptyStr(obj.carLocation)?@"未提供":obj.carLocation}];

        }

        
        [self refreshBottom];
        [self.tableView reloadData];
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
}


- (void)initUI{
    //[self refreshBottom];

    if (self.bottomStyle == YTDetailBottomStyleERPAuth) {
        
        self.webView.hidden = NO;
        //self.webView.delegate = self;
        [self loadERPDetail];
        return;
    }
    
    if (self.bottomStyle == YTDetailBottomStyleHelpSellAuth) {
        
        self.tableView.hidden = NO;
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.rowHeight = 44;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YTDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
        
        
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth*(360./750.0))];
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        bannerView.autoScrollTimeInterval = 4.;
        bannerView.delegate = self;
        bannerView.backgroundColor = YHLineColor;
        bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        bannerView.placeholderImage = [UIImage imageNamed:@"carPicture"];
        self.tableView.tableHeaderView = bannerView;
        self.bannerView = bannerView;
        self.tableView.tableFooterView = [UIView new];
        
        //标题
        self.bannerL = [[UILabel alloc]initWithFrame:CGRectMake(0, screenWidth*(360./750.0)-40, screenWidth, 40)];
        self.bannerL.textAlignment = NSTextAlignmentCenter;
        self.bannerL.textColor = YHWhiteColor;
        [self.bannerView addSubview:self.bannerL];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"样例" style:UIBarButtonItemStyleDone target:self action:@selector(egAction)];

        
        [self loadHelpBuyDetail];
        return;
    }

}

- (void)egAction{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
    controller.urlStr =   @"https://www.wanguoqiche.com/intro/aj2019/demo.html";
    controller.title = @"样例";
    controller.barHidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshBottom{
    
    if (self.bottomStyle == YTDetailBottomStyleNone) {
        self.bottomViewBottomConstrains.constant = -(SafeAreaBottomHeight+49);
        return;
    }
    self.bottomViewBottomConstrains.constant = 0;

    if (self.bottomStyle == YTDetailBottomStyleERPAuth) {
        self.bottomERPAuthView.hidden = NO;
        self.bottomERPAuthView.selected = (self.detail.status == 5);//已经上帮买了
        self.url = [NSString stringWithFormat:SERVER_PHP_URL_H5_Vue"/index.html?bucheToken=%@&jnsAppStep=E003_buche_detection_report&status=ios&bill_id=%@&#/appToH5",[YHTools getAccessToken],self.detail.workOrderId];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];


        return;
    }
    
    if (self.bottomStyle == YTDetailBottomStyleHelpSellAuth) {
        self.bottomHelpSellView.hidden = NO;
        
        self.bottomHelpSellLove.selected = self. self.detail.favorite;
        [self.bottomHelpSellPrice setTitle:[NSString stringWithFormat:@"%@万",self.detail.carPrice] forState:UIControlStateNormal];
        
        self.bottomHelpSellTitle.text = self.detail.payStatus? @"查看报告":@"信息查询";
        self.bottomHelpSellPReport.selected = self.detail.payStatus;

        //轮播图图片
        if (!IsEmptyStr(self.detail.carPic)) {
            NSArray *carPictureArray = [self.detail.carPic componentsSeparatedByString:@","];
            NSMutableArray *imagesStringsArray = [@[]mutableCopy];
            for (NSString *str in carPictureArray) {
                
                NSString *carPictureURL = self.carModel.flag ? [YHTools hmacsha1YHJns:str width:(long)screenWidth] : [YHTools hmacsha1YH:str width:(long)screenWidth];

                [imagesStringsArray addObject:carPictureURL];
                
            }
            self.bannerView.imageURLStringsGroup = imagesStringsArray;
        } else {
            self.bannerView.localizationImageNamesGroup = @[@"carPicture"];
        }
        
        //轮播图标题
        if ( !IsEmptyStr(self.detail.plateNo) && !IsEmptyStr(self.detail.carFullName) ) {
           
            self.bannerL.text = [NSString stringWithFormat:@"%@",self.detail.carFullName];
        } else {
            self.bannerL.hidden = YES;
        }
        
        return;
    }
    
}

- (IBAction)erpButtomAction:(UIButton *)sender {
    
    if(self.detail.status == 5){
        [self cannelHelpBuy];
        return;
    }
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"YHSupBaseInfoVC" bundle:nil];
    YHDiagnosisBaseTC *carVersionVC = [board instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseTC"];
    carVersionVC.model = [YHCarBaseModel mj_objectWithKeyValues:self.detail.mj_keyValues];// self.detail.mj_keyValues;
    carVersionVC.model.carId = self.carModel.carId;
    carVersionVC.vinStr = self.detail.vin;
    carVersionVC.isSupInfo = YES;
    
    carVersionVC.doAciton = ^(YHCarBaseModel *model) {
        [self loadERPDetail];
    };
    
    [self.navigationController pushViewController:carVersionVC animated:YES];
    
    
}

- (void)cannelHelpBuy{
    
    [[YHNetworkManager sharedYHNetworkManager]cancelHelpSellAndUpCaptureCarWithToken:[YHTools getAccessToken] carId:self.carModel.carId auctionId:@"" type:@"0" onComplete:^(NSDictionary *info) {
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            [MBProgressHUD showSuccess:info[@"retMsg"]];
            [self loadERPDetail];
        } else {
            [self showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}

- (IBAction)liveAction:(UIButton *)sender {
    
    [[YHNetworkManager sharedYHNetworkManager]favoriteWithToken:[YHTools getAccessToken] carId:self.carModel.carId favStatus:[NSString stringWithFormat:@"%d",!self.detail.favorite] onComplete:^(NSDictionary *info) {
                    if ([info[@"retCode"] isEqualToString:@"0"]) {
                        self.detail.favorite = !self.detail.favorite;
                        
                        self.detail.favorite? [MBProgressHUD showSuccess:@"收藏成功"]:[MBProgressHUD showSuccess:@"取消收藏"];
                        self.bottomHelpSellLove.selected = self.detail.favorite;
                        
                    } else {
                        [self showErrorInfo:info];
                    }
                } onError:^(NSError *error) {
                    [MBProgressHUD showError:@"请求失败"];
                }];
}

- (IBAction)reportAction:(UIButton *)sender {
   
    if (self.detail.payStatus) {//to h5

        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];

        NSString *urlString =  [NSString stringWithFormat:SERVER_PHP_URL_H5_Vue"/index.html?bucheToken=%@&jnsAppStep=E003_buche_detection_report&status=ios&bill_id=%@&#/appToH5",[YHTools getAccessToken],self.detail.workOrderId];
        
        controller.urlStr = urlString;
        controller.title = @"报告详情";
        controller.barHidden = NO;
        [self.navigationController pushViewController:controller animated:YES];
        
        
        return;
    }
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService toHelpBuyCarPayWithId:self.detail.workOrderId payType:1 onComplete:^(NSDictionary *h5Par, NSDictionary *wxPar) {
        [MBProgressHUD hideHUDForView:self.view];
        if (wxPar) {
            [[WXPay sharedWXPay] payWithDict:wxPar success:^{
                //支付结果回调
                [MBProgressHUD showError:@"支付成功！" toView:self.view];

                [self loadHelpBuyDetail];
            } failure:^{
            }];
            return ;
        }
        [MBProgressHUD showError:@"该报告已购买" toView:self.view];

    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *obj = self.tableData[indexPath.row];
    cell.title.text = obj[@"title"];
    cell.name.text = obj[@"name"];
    cell.nameRight.constant = obj[@"icon"]? 46 : 10;
    [cell.action setImage:[UIImage imageNamed:obj[@"icon"]]  forState:UIControlStateNormal];
    cell.block = obj[@"action"];
    return cell;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *imagesStringsArray = [@[]mutableCopy];
    if (!IsEmptyStr(self.detail.carPic)) {
        NSArray *carPictureArray = [self.detail.carPic componentsSeparatedByString:@","];
        for (NSString *str in carPictureArray) {
            
            NSString *carPictureURL = self.carModel.flag ? [YHTools hmacsha1YHJns:str width:(long)0] : [YHTools hmacsha1YH:str width:(long)0];

            [imagesStringsArray addObject:carPictureURL];
        }
    } else {
        return;
        //[MBProgressHUD showError:@"图片字段为空"];
    }
    
    [YHHUPhotoBrowser showFromImageView:nil withURLStrings:imagesStringsArray placeholderImage:[UIImage imageNamed:@"carPicture"] atIndex:0 dismiss:^(UIImage *image, NSInteger index) {
        
    }];
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
                
                
                /*payReportOrder*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"payReportOrder"]){
                    
                    NSArray *para = [[arrFucnameAndParameter objectAtIndex:2] componentsSeparatedByString:@","];
                    NSString *price = para.firstObject;
                    NSString *code = para.lastObject;
                    [self showPayFreeView:price code:code];
                    NSLog(@"%s", __func__);
                    
                }
                
                
                /*back*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    self.navigationController.navigationBar.hidden = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
#if 0
                self.bottowView = [self.view viewWithTag:self.bottowTag];
                
                /*hideBottomBar*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"hideBottomBar"]) {
                    self.bottowView.hidden = YES;
                    self.webViewBottomConstraint.constant = 0;
                    //self.navigationController.navigationBar.hidden = YES;
                } else if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"showBottomBar"]) {
                    self.bottowView.hidden = NO;
                    self.webViewBottomConstraint.constant = 55;
                    //self.navigationController.navigationBar.hidden = NO;
                }
#endif
                /*share*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"share"]) {
                    [self share:[urlString componentsSeparatedByString:@"share/"]];
                }
            }
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - share

- (IBAction)shareAction:(id)sender {
//    开发：https://www.mhace.cn/jnsDev/buche.html?billId=xxxx#/carInfo
//    测试：https://www.mhace.cn/jnsTest/buche.html?billId=xxxx#/carInfo
//    生产：https://www.wanguoqiche.com/jns/buche.html?billId=xxxx#/carInfo
    NSString *address = [NSString stringWithFormat:@"%@/buche.html?billId=%@#/carInfo",SERVER_SHARE_URL_H5,self.detail.workOrderId];
    NSString *titles = [NSString stringWithFormat:@"【一手车源】%@",self.detail.carFullName];
    NSString *describe = [NSString stringWithFormat:@"%@年|%@公里",[self.detail.productionDate substringToIndex:4],self.detail.tripDistance];
    
    NSString *str = [self.detail.carPic componentsSeparatedByString:@","].firstObject;

    NSString *imageUrl = IsEmptyStr(str)? [UIImage imageNamed:@"shere_default"] : (self.carModel.flag ? [YHTools hmacsha1YHJns:str width:(long)50] : [YHTools hmacsha1YH:str width:(long)50]);
    
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType describe:describe titles:titles imageUrl:imageUrl address:address];
    }];

}
- (void)share:(NSArray *)shareArray0{
    NSString *address = @"";
    NSString *titles = @"";
    NSString *describe = @"";
    NSString *imageUrl = @"";
    
    if (shareArray0.count >= 2) {
        NSString *shareString0 = shareArray0[1];
        NSArray *shareArray1 = [shareString0 componentsSeparatedByString:@","];
        if (shareArray1.count == 1) {
            address = shareArray1[0];
        } else if (shareArray1.count == 2) {
            address = shareArray1[0];
            titles = [YHTools decodeString:shareArray1[1]];
        } else if (shareArray1.count == 3) {
            address = shareArray1[0];
            titles = [YHTools decodeString:shareArray1[1]];
            describe = [YHTools decodeString:shareArray1[2]];
        } else if (shareArray1.count == 4) {
            address = shareArray1[0];
            titles = [YHTools decodeString:shareArray1[1]];
            describe = [YHTools decodeString:shareArray1[2]];
            imageUrl = shareArray1[3];
        }
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType describe:describe titles:titles imageUrl:imageUrl address:address];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                          describe:(NSString *)describe
                          titles:(NSString *)titles
                          imageUrl:(NSString *)imageUrl
                          address:(NSString *)address

{
    //1.创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //2.创建网页内容对象
    if (IsEmptyStr(describe)) {
        describe = @"下载捕车APP，查看更多车源！";
    }
    
    //imageUrl = @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=00af05b334f33a87816d061af65d1018/8d5494eef01f3a29f863534d9725bc315d607c8e.jpg";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:describe thumImage:imageUrl];
    
    NSLog(@"------%@======",address);
    
    //3.设置网页地址
    shareObject.webpageUrl = address;
    
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
                
                UMSocialShareResponse *resp = data;
                
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark - 支付报告费
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
#pragma mark - .支付成功
                
                
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


- (void)gotoMap:(NSString *)address{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        // 高德地图
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&t=0",@"我的位置",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]){
        // 苹果地图
        NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
    
    YHMapViewController *VC = [[YHMapViewController alloc]init];
    VC.isNavi = YES;
    VC.addrStr = address;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
