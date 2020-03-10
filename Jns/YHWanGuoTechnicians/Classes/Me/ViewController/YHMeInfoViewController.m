//
//  YHMeInfoViewController.m
//  YHTechnician
//
//  Created by Zhu Wensheng on 16/9/2.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import "YHMeInfoViewController.h"
#import "YHChangeInfoViewController.h"
#import "AppDelegate.h"
#import "YHNetworkPHPManager.h"
#import "YHNetworkWeiXinManager.h"
//#import "YHLoginViewController.h"
#import "YHCommon.h"

#import "YHTools.h"
#import "YHAppIntroduceController.h"
#import "YHWebFuncViewController.h"

#import "YHModifyPassWordController.h"

#import "YHNewLoginController.h"

#import "YHNewLoginStationListController.h"

#import "YHStoreTool.h"

#import "YTBalanceController.h"

#import "YTRecordConViewtroller.h"

//#import "YTPayInfoController.h"
//#import "YTCounterController.h"


NSString *const notificationLogout = @"YHNnotificationLogout";
extern NSString *const notificationChangeSuc;
@interface YHMeInfoViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accountLable;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *phonesNumLable;
@property (weak, nonatomic) IBOutlet UILabel *cropNameLable;
@property (weak, nonatomic) IBOutlet UILabel *qqNumLable;
@property (weak, nonatomic) IBOutlet UIButton *touxiangButton;
@property (nonatomic, strong)UIImagePickerController *picker;
@property (strong, nonatomic)UIActionSheet *sheet;
@property (strong, nonatomic)NSDictionary *personInfo;
@property (weak, nonatomic) IBOutlet UILabel *ogNameL;
- (IBAction)logoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *modifyPasswordContentView;
@property (weak, nonatomic) IBOutlet UIButton *switchSiteBtn;
@property (weak, nonatomic) IBOutlet UIView *redPointV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookOrderTotalH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stationNumberLH;

//站点列表
@property (nonatomic, strong) NSArray *stationList;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberL;

@end

@implementation YHMeInfoViewController

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stationNumberL.text = [[YHStoreTool ShareStoreTool] orgPoints];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(noticeReload:) name:notificationChangeSuc object:nil];
    [self reloadInfo:NO];
    
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);    
    self.modifyPasswordContentView.hidden = [[[app.loginInfo valueForKey:@"data"] valueForKey:@"is_experience"] boolValue];
    
    if (!self.isShowBookOrderTotal) {
          self.bookOrderTotalH.constant = 0;
    }
  
    //切换站点(MWF)
    [self switchSiteInterface];
    
    NSString *orgPointsStatus = [[YHStoreTool ShareStoreTool] orgPointsStatus];
    self.stationNumberLH.constant = [orgPointsStatus isEqualToString:@"0"] ? 0 : 57;
    if ([orgPointsStatus isEqualToString:@"0"]) {
        self.redPointV.hidden = YES;
    }else{
        
        BOOL isHideRedPoint = [[YHStoreTool ShareStoreTool] isHideRedPoint];
        if (isHideRedPoint) {
            self.redPointV.hidden = YES;
        }else{
            self.redPointV.hidden = !self.isShowBookOrderTotal;
        }
    }
}

#pragma mark -财富 ----
- (IBAction)wealthBtnClicked:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title = @"优供";
    controller.urlStr = [NSString stringWithFormat:@"%@%@/wealth_copy.html?token=%@&status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -修改密码 ----
- (IBAction)modifyPasswordBtnClicked:(id)sender {
    YHModifyPassWordController *modifyViewController = [[YHModifyPassWordController alloc] init];
    [self.navigationController pushViewController:modifyViewController animated:YES];
}
#pragma mark --预订单统计 ----
- (IBAction)bookingOrderTotalClickde:(id)sender {
    
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title =  @"预订单统计";
    BOOL isFirst = [(AppDelegate*)[[UIApplication sharedApplication] delegate] isFirstLogin];
    if (isFirst) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:NO];
    }
    
//    controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/%@.html?token=%@&status=ios%@&menuCode=%@&menuName=%@", @"wealth", [YHTools getAccessToken], isFirst ? @"&first=1" : @"",@"menu_division",@"%E9%A2%84%E8%AE%A2%E5%8D%95%E7%BB%9F%E8%AE%A1"];
    
    NSString *name = [YHTools encodeString:self.bookOrderName];
    controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&menuName=%@&menuCode=menu_division&status=ios#/personal/bookingOrder",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken], name];
    
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - 站点余额 ----
- (IBAction)stationBalanceClickEvent:(id)sender {
    [[YHStoreTool ShareStoreTool] setRedPointHideStatus:YES];
    self.redPointV.hidden = YES;
    YTBalanceController *vc = [[UIStoryboard storyboardWithName:@"Balance" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBalanceController"];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.barTintColor = YHWhiteColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:YHNagavitionBarTextColor}];
    self.navigationController.navigationBar.tintColor = YHNagavitionBarTextColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)popViewController:(id)popVc{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)noticeReload:(NSNotification*)notice{
    
    [self reloadInfo:YES];
}

- (void)reloadInfo:(BOOL)isReload{
    if (isReload) {
         
         __weak __typeof__(self) weakSelf = self;
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] userInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
            
            [MBProgressHUD hideHUDForView:self.view];
            if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:[info mutableCopy]];
            }else{
                if(![weakSelf networkServiceCenter:info[@"code"]]){
                    YHLogERROR(@"");
                }
            }
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];;
        }];
        
    }else{
        [self loadInfo:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo][@"data"]];
    }
}

- (void)loadInfo:(NSDictionary*)info{
    _userNameLable.text = info[@"realname"];
    _ogNameL.text = info[@"orgName"];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    YHChangeInfoViewController *controller = segue.destinationViewController;
    //    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo];
    //    NSDictionary *btlmch_data = userInfo[@"btlmch_data"];
    //    controller.isNick = [segue.identifier isEqualToString:@"nick"];
    //    controller.infoStr = [segue.identifier isEqualToString:@"nick"] ? (btlmch_data[@"btlmch_alias"]) : (btlmch_data[@"btlmch_qq"]);
}

- (IBAction)touxiangAction:(id)sender {
    return;
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从手机相册选择", @"拍照", nil];
    
    // Show the sheet
    [self.sheet showInView:self.view];
}

#pragma mark - 头像上传
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        [self takePhotoBy:buttonIndex];
    }
}

//获取相片
-(void)takePhotoBy:(UIImagePickerControllerSourceType)type{
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: type]){
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        self.picker.allowsEditing = YES;
        //资源类型为照相机
        self.picker.sourceType = type;
        [self presentViewController:self.picker animated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"无该设备"];
        NSLog(@"无该设备");
    }
}

//3.x  用户选中图片后的回调
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    //    image = [self OriginImage:image scaleToSize:CGSizeMake(60, 60)];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [YHNetworkWeiXinManager analysisVin:imageData onComplete:^(NSDictionary *info) {
        NSLog(@"%@", info);
    } onError:^(NSError *error) {
        ;
    }];
    //    [[YHNetworkManager sharedYHNetworkManager] analysisVin:imageData onComplete:nil onError:nil];
    
    //    __weak 
    //    [[YHNetworkPHPManager sharedYHNetworkPHPManager] updatePictureImageDate:imageData userId:loginInfo[@"btlmch_key"] onComplete:^(NSDictionary *info) {
    //        NSNumber *res = info[@"res"];
    //        if (res.integerValue == 1) {
    //            [[YHNetworkPHPManager sharedYHNetworkPHPManager] getUserInfoById:loginInfo[@"btlmch_key"] onComplete:^(NSDictionary *info) {
    //                NSNumber *res = info[@"res"];
    //                if (res.integerValue == 1) {
    //                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setUserInfo:info];
    //                    [[NSNotificationCenter defaultCenter]postNotificationName:notificationChangeSuc object:Nil userInfo:nil];
    //                    [MBProgressHUD showSuccess:@"设置成功！"];
    //                }else{
    //                    [MBProgressHUD showError:info[@"tips"]];
    //                }
    //
    //            } onError:^(NSError *error) {
    //                YHLog(@"%@", error);
    //            }];
    //
    //        }else{
    //            [MBProgressHUD showError:info[@"tips"]];
    //        }
    //    } onError:^(NSError *error) {
    //        YHLog(@"%@", error);
    //        if (error.code == 0xFFFFFFF8) {
    //            NSDictionary *info = error.userInfo;
    //            [MBProgressHUD showError:info[@"info"]];
    //        }
    //    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
}

////2.x  用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setObject:image forKey:@"UIImagePickerControllerOriginalImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

//// 用户选择取消
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
}

-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
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

#pragma mark - 应用介绍
- (IBAction)lookUpAppIntroduce:(UIButton *)sender
{
    YHAppIntroduceController *VC = [[UIStoryboard storyboardWithName:@"YHAppIntroduce" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAppIntroduceController"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 反馈建议
- (IBAction)FeedBack:(UIButton *)sender
{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@"%@%@%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,[NSString stringWithFormat:@"/suggestion.html?token=%@&appId=yh1XqnVMsZxJNrqAPs&status=ios",[YHTools getAccessToken]]];
    controller.title = @"反馈建议";
    controller.barHidden = NO;
    controller.isFeedBackPush = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 切换站点(MWF)
- (IBAction)switchSite:(UIButton *)sender {
    YHNewLoginStationListController *stationListVC = [[YHNewLoginStationListController alloc] init];
    stationListVC.stationListArr = self.stationList;
    stationListVC.userName = [YHTools getName];
    stationListVC.passWord = [YHTools getPassword];
    [self.navigationController pushViewController:stationListVC animated:YES];
}

#pragma mark - 切换站点接口(MWF)
- (void)switchSiteInterface{
    
    self.switchSiteBtn.hidden = YES;
    self.switchSiteBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.switchSiteBtn.layer.borderWidth = 1.0f;
    
    WeakSelf;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]newLoginUserName:[YHTools getName]
                                                            passWord:[YHTools md5:[YHTools getPassword]]
                                                              org_id:@""
                                                        confirm_bind:NO
                                                          onComplete:^(NSDictionary *info)
    {
        int code = [info[@"code"] intValue];

        //登录成功绑定一家店铺
        if (code == 20000) {
            weakSelf.switchSiteBtn.hidden = YES;
            return;
        }
        
        //登录成功绑定多家店铺
        if (code == 30100) {
            weakSelf.switchSiteBtn.hidden = NO;
            if ([info[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
                weakSelf.stationList = info[@"data"][@"list"];
            }
            return;
        }

        if(![weakSelf networkServiceCenter:info[@"code"]]){
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {

    }];
}

#pragma mark - 退出登录
- (IBAction)logoutAction:(id)sender {
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] LogoutOnComplete:^(NSDictionary *info) {
           
       } onError:^(NSError *error) {
           
       }];

    [YHTools setAccessToken:nil];
    
    YHNewLoginController *newLoginVc = [[YHNewLoginController alloc] init];
    [self.navigationController pushViewController:newLoginVc animated:YES];
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogout object:Nil userInfo:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.loginInfo = nil;
   
}
@end
