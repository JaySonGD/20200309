//
//  YHChangeInfoViewController.m
//  YHTechnician
//
//  Created by Zhu Wensheng on 16/9/2.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHChangeInfoViewController.h"
#import "YHNetworkPHPManager.h"
#import "YHCommon.h"
//#import "MBProgressHUD+MJ.h"

#import "YHTools.h"
NSString *const notificationChangeSuc = @"YHNotificationChangeSuc";
@interface YHChangeInfoViewController ()
- (IBAction)confirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *infoFT;

@end

@implementation YHChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title = _isNick ? (@"修改昵称") : (@"修改QQ");
    _infoFT.text = _infoStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)confirmAction:(id)sender {
    if (self.infoFT.text == nil|| [_infoFT.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入信息"];
        return;
    }
    
    
     __weak __typeof__(self) weakSelf = self;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     editUserNickname:[YHTools getAccessToken]
     nickname:_infoFT.text
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [[NSNotificationCenter defaultCenter]postNotificationName:notificationChangeSuc object:nil userInfo:nil];
             [MBProgressHUD showSuccess:@"设置成功！" toView:(weakSelf.navigationController.view)];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
                 if ((((NSNumber*)info[@"code"]).integerValue == 40000)) {
                     NSDictionary *msg = info[@"msg"];
                     NSArray *values = [msg allValues];
                     [MBProgressHUD showSuccess:values[0]];
                 }else{
                     [MBProgressHUD showSuccess:info[@"msg"]];
                 }
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];;
     }];
    
}
@end
