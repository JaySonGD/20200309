//
//  PCSurveyController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/7/5.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <UIImageView+WebCache.h>
#import <WebKit/WebKit.h>
#import "PCSurveyController.h"
#import "YHTools.h"
#import "YBPopupMenu.h"
#import "PCBluetoothManager.h"
#import "YHTools.h"
#import "SVProgressHUD.h"
#import "YHCommon.h"
#import "MBProgressHUD+MJ.h"
#import "PCAlertViewController.h"
#import "PCBlutoothController.h"
#import "PCWifiController.h"
#import "YHNetworkManager.h"
#import "CheckNetwork.h"
#define ChanrgrSkip NO
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
extern NSString *const notificationReloadLoginInfo;
extern NSString *const notificationCheckUser;
@interface PCSurveyController () <YBPopupMenuDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray<PCPersonModel *> *models;
@property (weak, nonatomic) IBOutlet UIView *continueV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIPickerView *weightP;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (strong, nonatomic)NSNumber *chanrge;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImg;
- (IBAction)weightAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *weightV;
@property (weak, nonatomic) IBOutlet UILabel *continueL;
@property (weak, nonatomic) IBOutlet UIImageView *manImg;
@property (weak, nonatomic) IBOutlet UILabel *checkingL;
@property (weak, nonatomic) IBOutlet UIButton *weightFBtn;

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
- (IBAction)weightPAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (nonatomic, strong)WKWebView *webView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *checkStateL;
@property (weak, nonatomic) IBOutlet UIView *finishV;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *voiceSG;
@property (weak, nonatomic) IBOutlet UIButton *contiuneCancelB;
@property (nonatomic)NSInteger weight;
@property (nonatomic)BOOL isEditerWeight;//编辑体重
@property (nonatomic)BOOL isReady;//是否准备好开始测量
@property (nonatomic)BOOL isMeasure;//是否测量中
@property (nonatomic)BOOL isStartBtn;//是否点击开始
@property (weak, nonatomic) IBOutlet UIImageView *voiceIcon;
- (IBAction)cancelAction:(id)sender;
- (IBAction)sexAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtl;
@property (nonatomic)BOOL isToWifi;
- (IBAction)changeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *postuerStep;
@property (weak, nonatomic) IBOutlet UIView *figureStep;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *postureStep1;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *postureStep2;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *figureStep1;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *figureStep2;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *figureStep3;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation PCSurveyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bluetoothDelegate];
    [self sliderUIInit];
    
    [self getPersionList];
    [self initUi];
}

- (void)initUi{
    
    [self startBtnLoad];
    YHLayerBorder(self.contiuneCancelB, [UIColor blackColor], 1);
    //    [self getPersionList];
    
    self.pageCtl.numberOfPages = ((self.isPosture)? (2) : (2));
    self.postuerStep.hidden =  NO;//!(self.isPosture);
    self.figureStep.hidden = YES;//self.isPosture;
    self.bannerView.imageURLStringsGroup = ((self.isPosture)? (@[@"",@""]) : (@[@"",@""]));
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor clearColor]; // 自定义分页控件小圆标颜色
    self.bannerView.pageDotColor = [UIColor clearColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = nil;
    self.bannerView.autoScroll = NO;
    self.bannerView.infiniteLoop = NO;
    self.bannerView.delegate =self;
    self.bannerView.backgroundColor =[UIColor clearColor];
    self.checkStateL.text = (self.isPosture) ? @"请站在设备正前方2米处，进行正面和侧面的拍照" : @"请在设备2米前站位";
    self.startBtn.titleLabel.text = (self.isPosture) ? @"开始体态测量" : @"开始体形测量";
    [self.startBtn setTitle:(self.isPosture) ? @"开始体态测量" : @"开始体形测量" forState:UIControlStateNormal];
    self.weightBtn.hidden = self.isPosture;
    self.weightFBtn.hidden = self.isPosture;
    if (self.isPosture) {
        self.weightFBtn = nil;
    }
    PCPersonModel *model = [YHTools sharedYHTools].masterPersion;
    self.weight = model.weight;
    [self personUpadte];
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //    self.pageCtl.currentPage = index;
    [self page:index isPosture:self.isPosture];
    NSString *str = @"";
    if (self.isPosture) {
        str = @[@"请站在设备正前方2米处，进行正面和侧面的拍照", @"请站在设备正前方2米处，进行正面和侧面的拍照", ][index];
        [self.manImg setImage:[UIImage imageNamed:((index == 0)? (@"postureS1") : (@"posture"))]];
    }else{
        str = @[@"请在设备2米前站位", @"请攥紧双拳，两臂向左右分开至45度，\n双脚分开与肩同宽", @"请原地匀速旋转2圈"][index];
        [self.manImg setImage:[UIImage imageNamed:((index == 0)? (@"figureS1") : (@"figureS2"))]];
    }
    
    self.checkStateL.text = str;
}

- (void)page:(NSUInteger)index isPosture:(BOOL)isPosture{
    
    //    if (isPosture) {
    if (index == 0) {
        [self.postureStep1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = YHColor0X(0XDBBA92, 1);
        }];
        [self.postureStep2 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = YHColor0X(0XD8D8D8, 1);
        }];
    }else{
        [self.postureStep1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = YHColor0X(0XDBBA92, 1);
        }];
        [self.postureStep2 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = YHColor0X(0XDBBA92, 1);
        }];
    }
    //    }else{
    //        if (index == 0) {
    //            [self.figureStep1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //            [self.figureStep2 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XD8D8D8, 1);
    //            }];
    //            [self.figureStep3 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XD8D8D8, 1);
    //            }];
    //        }else  if (index == 1) {
    //            [self.figureStep1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //            [self.figureStep2 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //            [self.figureStep3 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XD8D8D8, 1);
    //            }];
    //        }else{
    //            [self.figureStep1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //            [self.figureStep2 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //            [self.figureStep3 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                obj.backgroundColor = YHColor0X(0XDBBA92, 1);
    //            }];
    //        }
    //    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self bluetoothDelegate];
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
}

- (void)noNetwork{
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"网络连接失败，请检查网络" message:nil];
    WeakSelf
    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [weakSelf popViewController:nil];
    }];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isToWifi) {
        //        [[PCBluetoothManager sharedPCBluetoothManager] stop];
    }
    //    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
    //        ;
    //    }];
}

- (void)getPersionList{
    
    self.models =  [YHTools sharedYHTools].personList;
    if (!self.isMeasure) {
        [MBProgressHUD showMessage:@"" toView:self.view];
        [self getDeviceNet];
    }
}

-(void)personUpadte{
    PCPersonModel *model = [YHTools sharedYHTools].masterPersion;
    [self.nameBtn setTitle:model.personName forState:UIControlStateNormal];
    self.nameBtn.titleLabel.text = model.personName;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.headImg]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.weightBtn setTitle:[NSString stringWithFormat:@"体重：%ldkg", self.weight] forState:UIControlStateNormal];
    self.weightBtn.titleLabel.text = [NSString stringWithFormat:@"体重：%ldkg", self.weight];
    //    if (self.weight > 20) {
    //        [self.weightP selectRow:(self.weight - 20) inComponent:1 animated:NO];
    //    }
}



- (void)sliderUIInit{
    UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"slider"] scaleToSize:CGSizeMake(12, 12)];
    [self.slider  setThumbImage:imagea forState:UIControlStateNormal];
    [self.slider  setThumbImage:imagea forState:UIControlStateFocused];
    [self.slider  setThumbImage:imagea forState:UIControlStateHighlighted];
}

- (void)startBtnLoad{
    return;
    if (self.isReady) {
        [self.startBtn setBackgroundColor:YHColor0X(0XD1B182, 1)];
    }else{
        [self.startBtn setBackgroundColor:YHCellColor];
    }
}
- (void)bluetoothDelegate{
    WeakSelf
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        YHLog(@"%@", responseObject)
        DebugTime
        NSNumber *code = [responseObject objectForKey:@"action"];
        switch (code.integerValue) {
                
            case 200003://3.3.3. 获取设备联网信息
            {
                //            statue:联网结果,
                //                0:表示已经配网,
                //                1:已经配网但网络不通
                //                2: 没有配网
                
                NSNumber *statue = [responseObject objectForKey:@"statue"];
                if (statue.integerValue == 0) {
                    [weakSelf getRulerInfo];
                    //                    [weakSelf getChanrge];
                }else {
                    weakSelf.isToWifi = YES;
                    [MBProgressHUD hideHUDForView:self.view];
                    //                    [MBProgressHUD showError:@"请配置网络！"];
                    PushControllerBlockAnimated(@"Bluetooth", @"PCWifiController", ((PCWifiController*)controller).func = (weakSelf.isPosture ? (PCFuncPosture) : (PCFuncFigure));, YES);
                }
            }
                break;
            case 200004://3.3.4. 配置测量账户信息信息
            {
                //            result:联网结果,
                //            ok:登陆成功,
                //            fail:登陆失败
                NSString *result = [responseObject objectForKey:@"result"];
                if ([result isEqualToString:@"ok"]) {
                    //                    self.isMeasure = NO;
                    if (self.isEditerWeight) {
                        self.isEditerWeight = NO;
                        [MBProgressHUD hideHUDForView:self.view];
                        //                        [MBProgressHUD showError:@"设置成功！"];
                    }else  if (self.isStartBtn) {
                        self.isStartBtn = NO;
                        if (self.isPosture) {
                            [self startPosture];
                        }else{
                            [self startSurvey];
                        }
                    }
                }else{
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:@"配置失败！"];
                    weakSelf.isMeasure = NO;
                    weakSelf.startBtn.hidden = NO;
                    weakSelf.voiceSG.hidden = NO;
                    weakSelf.arrowBtn.hidden = NO;
                    weakSelf.weightFBtn.hidden = NO;
                    weakSelf.checkingL.hidden = YES;
                    weakSelf.loadingImg.hidden = YES;
                }
            }
                break;
            case 200005://3.3.5. 开始体态测量
            {
                //            result:
                //                ok表示开启测量成功
                //                fail.开启测量失败
                NSString *result = [responseObject objectForKey:@"result"];
                if ([@"ok" isEqualToString:result]) {
                    //                    [MBProgressHUD showError:@"测量成功"];
                    //                    [MBProgressHUD showError:@"开始测量成功"];
                    //                    [self finish];
                }else{
                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"本次测量失败，请重新测量" message:nil];
                    
                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                        [weakSelf setAccountInfo];
                    }];
                    [weakSelf presentViewController:vc animated:NO completion:nil];
                    
                    weakSelf.isMeasure = NO;
                    weakSelf.startBtn.hidden = NO;
                    weakSelf.voiceSG.hidden = NO;
                    weakSelf.arrowBtn.hidden = NO;
                    weakSelf.weightFBtn.hidden = NO;
                    weakSelf.checkingL.hidden = YES;
                    weakSelf.loadingImg.hidden = YES;
                }
            }
                break;
            case 200006://3.3.6. 设置音量
            {
                //            result:ok表示设置成功
                //                fail：:表示设置失败
                
            }
                break;
                
            case 200007:
            {
                //3.3.9. 获取设备音量
                NSNumber *volume = [responseObject objectForKey:@"volume"];
                weakSelf.slider.value = volume.integerValue;
                [self getVoice];
            }
                break;
            case 200008:
            {
                NSNumber *chanrge = [responseObject objectForKey:@"chanrge"];
                weakSelf.chanrge = chanrge;
                if (chanrge.doubleValue <= 10.0 && !ChanrgrSkip) {
                    WeakSelf
                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"电量不足，无法完成本次测量\n请充电后使用" message:nil];
                    
                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                        [weakSelf popViewController:nil];
                    }];
                    [self presentViewController:vc animated:NO completion:nil];
                    return ;
                    
                }
                //                [MBProgressHUD showError:[NSString stringWithFormat:@"当前电量:%@", chanrge]];
                [weakSelf getVolume];
            }
                break;
            case 200009:
            {
                //1.3.11. 推送设备最新版本号
                weakSelf.isReady = YES;
                [weakSelf startBtnLoad];
                //                [MBProgressHUD showError:@"连接设备成功"];
                [MBProgressHUD hideHUDForView:self.view];
                if (weakSelf.isPosture) {
                    //                    [weakSelf setAccountInfo];
                    [MBProgressHUD hideHUDForView:self.view];
                }else{
                    [weakSelf showWeightAction];
                }
            }
                break;
            case 200010://1.3.12. 开始体形测量
            {
                /*
                 result:ok设置ok
                 fail:设置fail
                 
                 */
                
                NSString *result = [responseObject objectForKey:@"result"];
                if ([@"ok" isEqualToString:result]) {
                    //                    [self finish];
                    //                    [MBProgressHUD showError:@"开始测量成功"];
                }else{
                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"本次测量失败，请重新测量" message:nil];
                    
                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                        [weakSelf setAccountInfo];
                    }];
                    [weakSelf presentViewController:vc animated:NO completion:nil];
                    
                    weakSelf.isMeasure = NO;
                    weakSelf.startBtn.hidden = NO;
                    weakSelf.voiceSG.hidden = NO;
                    weakSelf.arrowBtn.hidden = NO;
                    weakSelf.weightFBtn.hidden = NO;
                    weakSelf.checkingL.hidden = YES;
                    weakSelf.loadingImg.hidden = YES;
                    weakSelf.loadingImg.hidden = YES;
                    
                    //                    [MBProgressHUD showError:@"开始测量失败"];
                    //                    weakSelf.isMeasure = NO;
                    //                    weakSelf.startBtn.hidden = NO;
                    //                    weakSelf.voiceSG.hidden = NO;
                    //                    weakSelf.arrowBtn.hidden = NO;
                    //                    weakSelf.weightFBtn.hidden = NO;
                    //                    weakSelf.checkingL.hidden = YES;
                    //                    weakSelf.loadingImg.hidden = YES;
                    //                    [weakSelf setAccountInfo];
                }
            }
                break;
            case 200011://1.3.14. 男女声切换
            {
                /*
                 result:ok设置ok
                 fail:设置fail
                 
                 */
                
                NSString *result = [responseObject objectForKey:@"result"];
                if ([@"ok" isEqualToString:result] ) {
                    [MBProgressHUD hideHUDForView:self.view];
                    //                    [MBProgressHUD showError:@"切换成功！"];
                }else{
                    //                    [MBProgressHUD showError:@"切换失败！"];
                }
            }
                break;
            case 200012://1.3.15. 获取当前男女声信息
            {
                /*
                 type:0: 男声
                 1:女声
                 
                 
                 */
                
                NSString *type = [responseObject objectForKey:@"type"];
                self.voiceSG.selectedSegmentIndex = (type.integerValue == 0 ? 1 : 0);
                
                
                [self getMac];
            }
                break;
            case 200013://1.3.17. 获取设备mac 和 version
            {
                /*
                 action:动作码
                 mac:设备地址
                 version:设备版本号
                 */
                
                NSString *mac = [responseObject objectForKey:@"mac"];
                NSString *version = [responseObject objectForKey:@"version"];
                [weakSelf getVersion:@{@"deviceVersionBaseNum" : version, @"deviceSn" : mac}];
            }
                break;
            case 200014://1.3.18. 获取设备信息
            {
                /*
                 Mac:设备地址
                 Version:设备版本号
                 Volume:音量
                 audio_type:声音类型,
                 0,男声
                 1,女声
                 Vol:电量
                 
                 */
                
                
                NSNumber *volume = [responseObject objectForKey:@"volume"];
                weakSelf.slider.value = volume.integerValue;
                
                
                NSString *type = [responseObject objectForKey:@"audio_type"];
                self.voiceSG.selectedSegmentIndex = (type.integerValue == 0 ? 1 : 0);
                
                
                NSNumber *chanrge = [responseObject objectForKey:@"vol"];
                weakSelf.chanrge = chanrge;
                if (chanrge.doubleValue <= 10.0 && !ChanrgrSkip) {
                    WeakSelf
                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"电量不足，无法完成本次测量\n请充电后使用" message:nil];
                    
                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                        [weakSelf popViewController:nil];
                    }];
                    [self presentViewController:vc animated:NO completion:nil];
                    return ;
                    
                }
                
                
                NSString *mac = [responseObject objectForKey:@"mac"];
                NSString *version = [responseObject objectForKey:@"version"];
                [weakSelf getVersion:@{@"deviceVersionBaseNum" : version, @"deviceSn" : mac}];
            }
                break;
                
            case 300001://1.3.7. 返回体形测量结果
            case 300003://1.3.16. 返回体态测量结果
            {
                //                status:0:等待中
                //                1:测量中
                //                2:测量结束
                NSNumber *status = [responseObject objectForKey:@"status"];
                if (status.integerValue == -1) {
                    //                    [MBProgressHUD showError:@"测量失败！"];
                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"本次测量失败，请重新测量" message:nil];
                    
                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                        [weakSelf setAccountInfo];
                    }];
                    [weakSelf presentViewController:vc animated:NO completion:nil];
                    
                    weakSelf.isMeasure = NO;
                    weakSelf.startBtn.hidden = NO;
                    weakSelf.voiceSG.hidden = NO;
                    weakSelf.arrowBtn.hidden = NO;
                    weakSelf.weightFBtn.hidden = NO;
                    weakSelf.checkingL.hidden = YES;
                    weakSelf.loadingImg.hidden = YES;
                }else if (status.integerValue == 0) {
                    //                    [MBProgressHUD showError:@"等待中！"];
                }else if(status.integerValue == 1){
                    //                    [MBProgressHUD showError:@"测量中！"];
                    weakSelf.isMeasure = YES;
                }else{
                    weakSelf.isMeasure = NO;
                    [weakSelf finish];
                }
                //                if (code.integerValue == 300001) {
                //                    [self replyCheck];
                //                }else{
                //                    [self replyPosture];
                //                }
            }
                break;
                
            case 300002://3.3.8. 网络断开通知
            {
                //            status:
                //                0:wifi网络断开
                //                1:Token实效
                NSNumber *statue = [responseObject objectForKey:@"statue"];
                if (statue.integerValue == 1) {
                    //                    [MBProgressHUD showError:@"登录过期！"];
                    //                    [self setAccountInfo];
                    [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
                }else if(statue.integerValue == 0){
                    PushControllerBlockAnimated(@"Bluetooth", @"PCWifiController", ((PCWifiController*)controller).func = (weakSelf.isPosture ? (PCFuncPosture) : (PCFuncFigure));, YES);
                }
            }
                break;
            case 990000:
            {
                YHLog(@"蓝牙自动连接成功！");
                if (!self.isMeasure) {
                    [MBProgressHUD showMessage:@"连接设备中..." toView:self.view];
                    [self getDeviceNet];
                }
            }
                break;
            case 990001 :
            {
                YHLog(@"蓝牙已断开！");
                [MBProgressHUD hideHUDForView:self.view];
                PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle: (self.isMeasure ? @"蓝牙中断，将正常生成测量报告" : @"蓝牙中断") message:nil];
                
                [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                    [[PCBluetoothManager sharedPCBluetoothManager] stop];
                    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
                        ;
                    }];
                    [weakSelf popViewController:nil];
                }];
                [weakSelf presentViewController:vc animated:NO completion:nil];
                
                //                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
                //                PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
                //                controller.func =(( self.isPosture)? (PCFuncPosture) : (PCFuncFigure));
                //                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case 990004://保存蓝牙数据失效
            {
                //                if (self.isMeasure) {
                //                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"蓝牙已断开，但测量不会受到影响" message:nil];
                //
                //                    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                //                        [weakSelf popViewController:nil];
                //                    }];
                //                    [self presentViewController:vc animated:NO completion:nil];
                //                }else{
                //                    [MBProgressHUD hideHUDForView:self.view];
                //                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
                //                    PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
                //                    controller.func =(( self.isPosture)? (PCFuncPosture) : (PCFuncFigure));
                //                    [self.navigationController pushViewController:controller animated:YES];
                //                }
                
            }
                break;
                
            default:
                break;
        }
    }];
}


//3.3.3. 获取设备联网信息
- (void)getDeviceNet{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100003"
     }
     ];
}

//3.3.4. 配置测量账户信息信息
- (void)setAccountInfo{
    DebugTime
    if ([YHTools accountId] == nil || [YHTools personId]  == nil || [YHTools rulerToken] == nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
        return;
    }
    __block PCPersonModel *model = [YHTools sharedYHTools].masterPersion;
    
    if (self.isEditerWeight) {
        [MBProgressHUD showMessage:@"设置中..." toView:self.view];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *personId = [f numberFromString:[YHTools personId]];
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100004",
         @"token": [YHTools rulerToken],
         @"accountId": [YHTools accountId] ,
         @"personId": personId,
         @"height": @(model.height),
         @"weight": @(self.weight),
         @"age": @(model.age),
         @"sex": @(model.sex),
         @"type": @(self.isPosture),
     }
     ];
}


//1.3.12. 开始体态测量
- (void)startPosture{
    DebugTime
    //    self.checkStateL.text = @"根据设备提示旋转测量";
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100005"
     }
     ];
}

//3.3.6. 设置音量
- (void)setVolume:(NSNumber*)volume{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100006",
         @"volume": volume,
     }
     ];
}

//g获取音量
- (void)getVolume{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100007"
     }
     ];
}

//3.3.10. 获取设备电量
- (void)getChanrge{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100008"
     }
     ];
}


//3.3.11. 推送设备最新版本号
- (void)deviceVersion:(NSString*)version isNow:(BOOL)isNow{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100009",
         @"version": version,
         @"type" : (isNow? @0 : @1)
     }
     ];
}



//3.3.5. 体形测量
- (void)startSurvey{
    //    [self finish];
    //    return;
    DebugTime
    if ([YHTools accountId] == nil || [YHTools accountId] == nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
        return;
    }
    
    //    self.checkStateL.text = @"根据设备提示旋转测量";
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *personId = [f numberFromString:[YHTools personId]];
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100010",
         @"accountId": [YHTools accountId],
         @"personId": personId,
     }
     ];
}



//1.3.14. 男女声切换 0: 男声 1:女声

- (void)voiceSwitching:(NSNumber *)voice{
    DebugTime
    //    [MBProgressHUD showMessage:@"切换中..." toView:self.view];
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100011",
         @"type" : voice
     }
     ];
}

//1.3.15. 获取当前男女声信息
- (void)getVoice{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100012"
     }
     ];
}

//1.3.17. 获取设备mac 和 version
- (void)getMac{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100013"
     }
     ];
}

//11.3.18. 获取设备信息
- (void)getRulerInfo{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"100014"
     }
     ];
}


//1.3.7. 返回体形测量结果果  答复
- (void)replyCheck{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"400001"
     }
     ];
}

//1.3.16. 返回体态测量结果  答复
- (void)replyPosture{
    DebugTime
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
         @"action": @"400003"
     }
     ];
}



- (IBAction)sliderChangedAction:(UISlider*)slider {
    
    [self setVolume:[NSNumber numberWithInt:slider.value]];
}

- (IBAction)startCheckAction:(UIButton*)sender {
    if (!self.finishV.isHidden) {
        [self popViewController:nil];
        return;
    }
    if (!self.isReady) {
        return;
    }
    if (self.isMeasure) {
        return;
    }
    self.isMeasure = YES;
    self.isStartBtn = YES;
    self.startBtn.hidden = YES;
    self.voiceSG.hidden = YES;
    self.arrowBtn.hidden = YES;
    self.weightFBtn.hidden = YES;
    self.checkingL.hidden = NO;
    self.loadingImg.hidden = NO;
    [self setAccountInfo];
    //    if (self.isPosture) {
    //        [self startPosture];
    //    }else{
    //        [self startSurvey];
    //    }
    
    //        [self performSelector:@selector(finish) withObject:nil afterDelay:2];
}

-(void)finish{
    self.startBtn.titleLabel.text = @"测量完成";
    [self.startBtn setTitle:@"测量完成" forState:UIControlStateNormal];
    self.checkStateL.text = @"测量完成，数据已经上传到云端，\n后续会发送到你的手机上";
    self.finishV.hidden = NO;
    self.voiceSG.hidden = YES;
    self.arrowBtn.hidden = YES;
    self.weightFBtn.hidden = YES;
    self.voiceIcon.hidden = YES;
    self.slider.hidden = YES;
    self.checkingL.hidden = YES;
    self.loadingImg.hidden = YES;
    self.cancelBtn.hidden = YES;
    [self performSelector:@selector(measureContinue) withObject:nil afterDelay:2];
}
- (IBAction)contuneCancl:(id)sender {
    self.continueV.hidden = YES;
    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        ;
    }];
    [self popViewController:nil];
}
- (IBAction)contiuneComfire:(id)sender {
    self.continueV.hidden = YES;
    if (!self.isPosture) {
        self.isPosture = YES;
        [self initUi];
    }
}

- (void)measureContinue{
    if (self.isPosture) {
        [self contuneCancl:nil];
        return;
    }
    WeakSelf
    weakSelf.startBtn.titleLabel.text = (self.isPosture) ? @"开始体态测量" : @"开始体形测量";
    [weakSelf.startBtn setTitle:(self.isPosture) ? @"开始体态测量" : @"开始体形测量" forState:UIControlStateNormal];
    weakSelf.isMeasure = NO;
    weakSelf.startBtn.hidden = NO;
    weakSelf.voiceSG.hidden = NO;
    weakSelf.arrowBtn.hidden = NO;
    weakSelf.weightFBtn.hidden = NO;
    weakSelf.checkingL.hidden = YES;
    weakSelf.loadingImg.hidden = YES;
    weakSelf.finishV.hidden = YES;
    weakSelf.continueV.hidden = NO;
    weakSelf.cancelBtn.hidden = NO;
    //    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否继续测量" message:nil];
    //    [vc addActionWithTitle:@"取消" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
    //        [weakSelf popViewController:nil];
    //    }];
    //    [vc addActionWithTitle:@"继续" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
    //        [weakSelf setAccountInfo];
    //    }];
    //    [weakSelf presentViewController:vc animated:NO completion:nil];
    
}

-(void)finishhidden{
    self.finishV.hidden = YES;
    self.startBtn.hidden = NO;
    self.voiceSG.hidden = NO;
    self.arrowBtn.hidden = NO;
    self.weightFBtn.hidden = NO;
    self.checkingL.hidden = YES;
    self.loadingImg.hidden = YES;
    //    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    //    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
    //        ;
    //    }];
    [self popViewController:nil];
}

-(void)getVersion:(NSDictionary*)info{
    WeakSelf
    
    [MBProgressHUD hideHUDForView:self.view];
    //    weakSelf.isReady = YES;
    //    [weakSelf startBtnLoad];
    //    [MBProgressHUD showError:@"连接设备成功"];
    //    if (weakSelf.isPosture) {
    //        [weakSelf setAccountInfo];
    //    }else{
    //        [weakSelf showWeightAction];
    //    }
    //    return ;
    
    NSString *oldVersion = [info objectForKey:@"deviceVersionBaseNum"];
    [[YHNetworkManager sharedYHNetworkManager]
     deviceType:info
     onComplete:^(NSDictionary * _Nonnull obj) {
        
        //         NSString *version = @"2223";
        NSString *version = obj[@"version"];
        if(!version) return;
        
        BOOL isForce = NO;//[obj[@"isForce"] boolValue];
        BOOL update = [YHTools compare:oldVersion newVersion:version];
        
        if(!update || (weakSelf.chanrge.integerValue < 30 && !ChanrgrSkip)) {
            weakSelf.isReady = YES;
            [weakSelf startBtnLoad];
            //             [MBProgressHUD showError:@"连接设备成功"];
            if (weakSelf.isPosture) {
                //                 [weakSelf setAccountInfo];
            }else{
                [weakSelf showWeightAction];
            }
            return ;
        }
        
        if(isForce) {
            [weakSelf deviceVersion:version isNow:YES];
            return ;
        }
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"" message:@"检测到新的固件版本，升级后可提高\n测量精度"];
        [vc addActionWithTitle:@"马上升级" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
            [weakSelf deviceVersion:version isNow:YES];
//            [[PCBluetoothManager sharedPCBluetoothManager] stop];
//            [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
//                ;
//            }];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //             weakSelf.isReady = YES;
            //             [weakSelf startBtnLoad];
            //             [MBProgressHUD showError:@"连接设备成功"];
            //             if (weakSelf.isPosture) {
            //                 [weakSelf setAccountInfo];
            //             }else{
            //                 [weakSelf showWeightAction];
            //             }
        }];
        [vc addActionWithTitle:@"测量完成后升级" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [weakSelf deviceVersion:version isNow:NO];
            weakSelf.isReady = YES;
            [weakSelf startBtnLoad];
            //             [MBProgressHUD showError:@"连接设备成功"];
            if (weakSelf.isPosture) {
                //                 [weakSelf setAccountInfo];
            }else{
                [weakSelf showWeightAction];
            }
        }];
        [weakSelf presentViewController:vc animated:NO completion:nil];
        
    } onError:^(NSError * _Nonnull error) {
        YHLog(@"%@", error);
        if (error.code == 0xFFFFFFF8) {
            [MBProgressHUD hideHUD];
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:nil message:@"网络连接失败，请检查网络"];
            [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                [weakSelf popViewController:nil];
            }];
            [weakSelf presentViewController:vc animated:NO completion:nil];
        }else{
            weakSelf.isReady = YES;
            [weakSelf startBtnLoad];
            //             [MBProgressHUD showError:@"连接设备成功"];
            if (weakSelf.isPosture) {
                //                 [weakSelf setAccountInfo];
            }else{
                [weakSelf showWeightAction];
            }
        }
    }];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    PCPersonModel *user = self.models[index];
    [YHTools setPersonId:user.personId];
    [YHTools sharedYHTools].masterPersion = user;
    self.weight = user.weight;
    [self personUpadte];
    if (self.isPosture) {
//        [self setAccountInfo];
    }else{
        [self showWeightAction];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationCheckUser object:Nil userInfo:nil];
}

-(void)showWeightAction{
    if (self.weight > 20) {
        [self.weightP selectRow:self.weight - 20 inComponent:1 animated:NO];
    }else{
        self.weight = 60;
        [self.weightP selectRow:60 - 20 inComponent:1 animated:NO];
    }
    [self weightAction:nil];
}
- (void)ybPopupMenuDidDismiss{
    self.arrowBtn.selected = NO;
}

- (IBAction)weightAction:(id)sender {
    if (self.isMeasure) {
        return;
    }
    self.weightV.hidden = NO;
}

- (IBAction)cancelAction:(id)sender {
    [self setAccountInfo];
}

- (IBAction)sexAction:(id)sender {
    [self voiceSwitching:((self.voiceSG.selectedSegmentIndex == 0)? (@1) : (@0))];
}

- (IBAction)changeAction:(id)sender {
    if (self.isMeasure) {
        return;
    }
    self.arrowBtn.selected = YES;
    [YBPopupMenu showRelyOnView:self.arrowBtn titles:[self.models valueForKeyPath:@"personName"] icons:nil menuWidth:150 delegate:self];
}


- (IBAction)weightPAction:(id)sender {
    self.weightV.hidden = YES;
    self.isEditerWeight = YES;
    PCPersonModel *model = [YHTools sharedYHTools].masterPersion;
    model.weight = self.weight;
    
//    [self setAccountInfo];
    [self personUpadte];
    

    [MBProgressHUD showMessage:@"" toView:self.view];
    if([[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [[YHNetworkManager sharedYHNetworkManager] modifyPerson:@{@"accountId" : YHTools.accountId,@"personId" : model.personId, @"weight" : @(self.weight)} onComplete:^(PCPersonModel * _Nonnull model) {

            self.isEditerWeight = NO;
            [MBProgressHUD hideHUDForView:self.view];;
        } onError:^(NSError * _Nonnull error) {

            self.isEditerWeight = NO;
            [MBProgressHUD hideHUDForView:self.view];;
        }];
    }else{
        self.isEditerWeight = NO;
        [MBProgressHUD hideHUDForView:self.view];
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:nil message:@"网络连接失败，请检查网络"];
        [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [self popViewController:nil];
        }];
        [self presentViewController:vc animated:NO completion:nil];
    }
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0 || component == 2) {
        return 1;
    }
    return 201 - 20;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return @"当前体重：";
    }
    if (component == 2) {
        return @"kg";
    }
    return [NSString stringWithFormat:@"%ld", (long)(row + 20)];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        self.weight = (row + 20);
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl = (UILabel *)view;
    if (lbl == nil) {
        lbl = [[UILabel alloc]init];
        //在这里设置字体相关属性
        lbl.font = [UIFont systemFontOfSize:20];
        [lbl setTextAlignment:NSTextAlignmentCenter];
    }
    //重新加载lbl的文字内容
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    if (row != 1) {
        //在该代理方法里添加以下两行代码删掉上下的黑线
        UIView *line1 = [pickerView.subviews objectAtIndex:1];
        UIView *line2 = [pickerView.subviews objectAtIndex:2];
        line1.backgroundColor = YHColor(230, 230, 230);
        line2.backgroundColor = YHColor(230, 230, 230);
        CGRect frame = pickerView.frame;
        CGRect lineFrame = line1.frame;
        lineFrame.origin.x = CGRectGetWidth(frame) / 3;
        lineFrame.size.width = CGRectGetWidth(frame) / 3;
        line1.frame = lineFrame;
        
        lineFrame = line2.frame;
        lineFrame.origin.x = CGRectGetWidth(frame) / 3;
        lineFrame.size.width = CGRectGetWidth(frame) / 3;
        line2.frame = lineFrame;
        
    }
    return lbl;
}


#pragma mark - 3d人型
//加载3d人型
- (void)loadWeb3D{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    configuration.userContentController = userController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) configuration:configuration];
    [userController addScriptMessageHandler:self name:@"h5ToApp"];
    self.webView = webView;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    NSString *filePath = [resPath stringByAppendingPathComponent:@"index.html"];
    [webView.configuration.preferences setValue:@(YES) forKey:@"allowFileAccessFromFileURLs"];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:filePath]]];
    [self.view insertSubview:webView atIndex:1];
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"h5ToApp"]) {
        NSString *cookiesStr = message.body;
        YHLog(@"当前的cookie为： %@", cookiesStr);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"JS调用的OC回调方法" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)appToH5:(NSDictionary*)info{
    NSString *sciptStr = [NSString stringWithFormat:@"appToH5(\'%@\')",[YHTools returnJSONStringWithDictionary:info]];
    [self.webView evaluateJavaScript:sciptStr completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        YHLog(@"alert");
    }];
}

/*
 对原来的图片的大小进行处理
 @param image 要处理的图片
 @param size  处理过图片的大小
 */
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (IBAction)popViewController:(id)sender{
    [MBProgressHUD hideHUDForView:self.view];
    //    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    //    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
    //        ;
    //    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
