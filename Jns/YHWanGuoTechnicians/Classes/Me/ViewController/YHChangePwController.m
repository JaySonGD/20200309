//
//  YHChangePwController.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHChangePwController.h"
#import "YHNetworkPHPManager.h"
#import "YHCommon.h"
//#import "MBProgressHUD+MJ.h"


@interface YHChangePwController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwF;
@property (weak, nonatomic) IBOutlet UITextField *PwF;
@property (weak, nonatomic) IBOutlet UITextField *reNewPwf;

@end

@implementation YHChangePwController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if (self.oldPwF.text == nil|| [_oldPwF.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入信息"];
        return;
    }
    
}
@end
