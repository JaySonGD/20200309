//
//  ViewController.m
//  11
//
//  Created by Jay on 20/3/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"

#import "Api.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Api registerAppKey:@"mnbvcxz1234567890"];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[Api shareApi] postRequest:@"http://127.0.0.1/app/public/api/t1" parameters:@{@"c":@"HK",@"l":@"zh-Hans-CN"} success:^(id respones) {
        NSLog(@"%s---%@", __func__,respones);
    } failure:^(NSError *error) {
       NSLog(@"%s", __func__);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
