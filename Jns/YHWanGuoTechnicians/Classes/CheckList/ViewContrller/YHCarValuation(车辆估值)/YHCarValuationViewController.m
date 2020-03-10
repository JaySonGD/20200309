//
//  YHCarValuationViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarValuationViewController.h"
#import <MJExtension.h>
#import <UShareUI/UShareUI.h>
#import "YHCarValuationCell.h"
#import "YHCarValuationView.h"
#import "YHNetworkPHPManager.h"

@interface YHCarValuationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) YHCarValuationView *carValuationView;
@property (nonatomic, strong) UITextField *setCarPriceTextField;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation YHCarValuationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - ------------------------------------初始化变量----------------------------------------
- (void)initVar {
    self.isPush = NO;
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI {
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCarValuationCell" bundle:nil] forCellReuseIdentifier:@"YHCarValuationCell"];
}

#pragma mark - ------------------------------------初始化数据------------------------------------------
- (void)initData {
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getAssessInfoWithToken:[YHTools getAccessToken]
                                                                     billId:[NSString stringWithFormat:@"%@",self.billId]
                                                                 onComplete:^(NSDictionary *info)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view];
         if ([info[@"code"] longLongValue] == 20000) {
             weakSelf.model = [YHCarValuationModel mj_objectWithKeyValues:info[@"data"]];
             [weakSelf.tableView reloadData];
         } else {
             [MBProgressHUD showError:info[@"msg"]];
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

#pragma mark - --------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCarValuationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHCarValuationCell"];
    [cell refreshUIWithModel:self.model isPush:self.isPush controller:self shareBtn:self.shareBtn pushBtn:self.pushBtn];
    self.setCarPriceTextField = cell.setCarPriceTextField;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}

#pragma mark - -------------------------------------点击事件--------------------------------------------
#pragma mark - 1.返回按钮
- (IBAction)back:(UIButton *)sender {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 2.分享
- (IBAction)share:(UIButton *)sender {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType WithModel:self.model];
    }];
}

#pragma mark - 3.推送车主
- (IBAction)pushCarOwner:(UIButton *)sender {
    if (self.setCarPriceTextField.text.length == 0) {
        [MBProgressHUD showError:@"请设置车辆估值"];
        return;
    }

    if (!self.carValuationView) {
        self.carValuationView = [[NSBundle mainBundle]loadNibNamed:@"YHCarValuationView" owner:self options:nil][0];
        self.carValuationView.backgroundColor = YHColorA(127, 127, 127, 0.5);
        self.carValuationView.pushPhoneTF.delegate = self;
        self.carValuationView.pushPhoneTF.text = self.model.phone;
        if (!IsEmptyStr(self.model.phone)) {self.carValuationView.pushBtn.backgroundColor = YHNaviColor;}
        [self.view addSubview:self.carValuationView];
    }
    
    WeakSelf;
    self.carValuationView.btnClickBlock = ^(UIButton *button) {
        if (IsEmptyStr(weakSelf.carValuationView.pushPhoneTF.text)) {
            [MBProgressHUD showError:@"请输入推送客户手机号码"];
            return;
        } else {
            if (![[weakSelf.carValuationView.pushPhoneTF.text substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"] || (weakSelf.carValuationView.pushPhoneTF.text.length != 11)) {
                [MBProgressHUD showError:@"请输入正确的手机号码"];
                return;
            }
        }
        
        [MBProgressHUD showMessage:@"" toView:weakSelf.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]saveAssessReportPushWithToken:[YHTools getAccessToken]
                                                                               billId:weakSelf.billId
                                                                                phone:weakSelf.carValuationView.pushPhoneTF.text
                                                                                price:weakSelf.setCarPriceTextField.text
                                                                           onComplete:^(NSDictionary *info)
        {
            NSLog(@"\n保存二手车评估报告推送接口:\n%@,%@,%@",info,info[@"msg"],info[@"code"]);
            [MBProgressHUD hideHUDForView:weakSelf.view];
            if ([info[@"code"] longLongValue] == 20000) {
                [weakSelf.carValuationView removeFromSuperview];
                weakSelf.isPush = YES;
                [weakSelf initData];
                [MBProgressHUD showSuccess:@"推送成功"];
                return;
            }
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
    };
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType WithModel:(YHCarValuationModel *)model{
    //1.创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //2.创建网页内容对象
    NSString *iamge;
    if (!IsEmptyStr(model.shareImg)) {
        iamge = [NSString stringWithFormat:@"%@",model.shareImg];
    }else{
        iamge = [NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", model.carBrandLogo];
    }

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.shareHeading descr:model.shareSubheading thumImage:iamge];

    //3.设置网页地址
    shareObject.webpageUrl = model.reportUrl;

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.carValuationView.pushPhoneTF) {
        self.carValuationView.pushBtn.backgroundColor = YHNaviColor;
        if (self.carValuationView.pushPhoneTF.text.length >= 11) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.carValuationView.pushPhoneTF) {
        if (textField.text.length == 0 ) {
            self.carValuationView.pushBtn.backgroundColor = YHBackgroundColor;
        }
    }
}

@end
