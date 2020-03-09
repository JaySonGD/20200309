//
//  FullViewController.m
//  WJStatusBarHUD
//
//  Created by Jay on 19/8/2019.
//  Copyright © 2019 wj. All rights reserved.
//

#import "FullViewController.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 旋转支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskLandscape;
}


- (BOOL)prefersStatusBarHidden{
    return NO;
}




@end
