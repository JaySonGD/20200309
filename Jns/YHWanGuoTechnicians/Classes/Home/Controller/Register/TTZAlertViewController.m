//
//  TTZAlertViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZAlertViewController.h"

@interface TTZAlertViewController ()

@end

@implementation TTZAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)checkAction:(id)sender {
    !(_checkAction)? : _checkAction();
    [self close:nil];

}
- (IBAction)continueAction:(id)sender {
    !(_continueAction)? : _continueAction();
    [self close:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
