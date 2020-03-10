//
//  PCTextController.m
//  penco
//
//  Created by Jay on 15/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCTextController.h"

@interface PCTextController ()

@end

@implementation PCTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    [self.textTV setContentOffset:CGPointMake(0, 0)];

    });
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
