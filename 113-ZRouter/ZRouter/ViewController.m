//
//  ViewController.m
//  ZRouter
//
//  Created by Jay on 7/12/2018.
//  Copyright © 2018 ZZ. All rights reserved.
//

#import "ViewController.h"

#import "ZRouter.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *mcc = [carrier mobileCountryCode];
    
    NSString *mnc = [carrier mobileNetworkCode];
    
    NSLog(@"%@,%@",mcc,mnc);
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier1 = info.subscriberCellularProvider;
    NSLog(@"carrier:%@", [carrier1 description]);
    
//    基站的LAC 和cellID暂时只能获取一组 还在研究啊

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[ZRouter sharedRouter] registerPath:@"home/messagelist" actionBlock:^(ZRouterActionCallbackModel * _Nonnull callbackModel) {
//        
//    }];
    
    ZRouterURL *url = [[ZRouterURL alloc] initWithPath:@"home/messagelist" params:@{@"name":@"ca"}];
    url.viewController = self;
    
    ZRouterActionCallbackModel *model = [ZRouterActionCallbackModel new];
    model.url = url;
    model.actionCallbackBlock = ^(id result) {
        
    };
    [[ZRouter sharedRouter] runWithActionCallbackObject:model];

}
@end
