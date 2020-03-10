//
//  PCTestBluetoothController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/19.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCTestBluetoothController.h"
#import "PCBluetoothManager.h"
#import "YHTools.h"
#import "YHCommon.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCTestBluetoothController ()
@property (weak, nonatomic) IBOutlet UIImageView *pcV;
@end

@implementation PCTestBluetoothController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        YHLog(@"%@", responseObject)
        NSNumber *code = [responseObject objectForKey:@"action"];
        if (code.integerValue == bluetoothConnectedCode.integerValue) {
            YHLog(@"蓝牙自动连接成功！");
        }
    }];
    
    //    [self rload];
    
    
    
    
    
    NSArray *info =  @[
                       @{@"color" : @(0X0),
                         @"points" : @[@{
                                           @"x" : @10,
                                           @"y" : @30
                                           },
                                       @{
                                           @"x" : @230,
                                           @"y" : @80
                                           },
                                       @{
                                           @"x" : @100,
                                           @"y" : @300
                                           },
                                       @{
                                           @"x" : @300,
                                           @"y" : @200
                                           },
                                       @{
                                           @"x" : @400,
                                           @"y" : @500
                                           },
                                       ]
                         }
                       ];
    [self.pcV setImage:[YHTools image:[UIImage imageNamed:@"man1"] withInfo:info]];
    
}

- (IBAction)shareAction:(id)sender{
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
       @"action": @"100001"
       }
     ];
}

- (IBAction)setAction:(id)sender{
    [YHTools setbuluetoothName:nil];
    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        ;
    }];
    [self rload];
}

- (void)rload{
    if ([[PCBluetoothManager sharedPCBluetoothManager] isSavedBluetooth] && NO) {
        [[PCBluetoothManager sharedPCBluetoothManager] start];
    }else{
        PushController(@"Bluetooth", @"PCBlutoothController");
    }
}
@end
