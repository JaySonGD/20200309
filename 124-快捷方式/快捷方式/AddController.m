//
//  AddController.m
//  快捷方式
//
//  Created by Jay on 26/4/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "AddController.h"

@interface AddController ()

@end

@implementation AddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)show:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://127.0.0.1/app/public/tv/cut.html"] options:nil completionHandler:^(BOOL success) {
        
    }];
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
