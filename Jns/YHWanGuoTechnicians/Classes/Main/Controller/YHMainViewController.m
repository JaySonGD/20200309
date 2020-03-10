//
//  YHMainViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/10/11.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHMainViewController.h"
#import "YHTools.h"

#import "YHNetworkManager.h"
#import "YHLoginViewController.h"
extern NSString *const notificationUpdataUserinfo;
@interface YHMainViewController ()

@end

@implementation YHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
