//
//  PCAgreementController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/21.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCAgreementController.h"
#import "YHCommon.h"
#import "YHTools.h"
#import "YHPersonInfoController.h"
extern NSString *const notificationReloadLoginInfo;
@interface PCAgreementController ()
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementStrL;
@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
- (IBAction)backAction:(id)sender;

@end

@implementation PCAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url =[NSURL URLWithString:@"https://privacy.lenovo.com.cn/products/8d2e264212f11ed0.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webV loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)agreeAction:(UIButton*)button {
//    PushController(@"profile", @"YHPersonInfoController");
    if (!(self.agreementBtn.isSelected)) {
        [MBProgressHUD showError:@"请同意协议！"];
        return;
    }
    [YHTools setappAgreement:@"YES"];
    [YHTools setAccessToken:nil];
    [YHTools setAccountId:nil];
    [YHTools setRefreshToken:nil];
    [YHTools setRulerToken:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadLoginInfo object:nil userInfo:nil];
    
    
    [self performSelector:@selector(pop) withObject:nil afterDelay:.5];
}

- (void)pop{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)agreementAction:(UIButton*)button {
    button.selected = !(button.isSelected);
    [self.comfireBtn setBackgroundColor:((button.selected)? (YHNaviColor) : (YHCellColor))];
}

- (IBAction)backAction:(id)sender {
    exit(1);
}
@end
