//
//  YHContactCustomerViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/10/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHContactCustomerViewController.h"

@interface YHContactCustomerViewController ()

@end

@implementation YHContactCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)ContactCustomer:(UIButton *)sender {
    NSString *allString = [NSString stringWithFormat:@"tel:%@", @"020-36297230"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

@end
