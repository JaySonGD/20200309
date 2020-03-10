//
//  PCBlutoothController.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralViewController.h"
#import "YHBaseViewController.h"
#import "PCPersonModel.h"
typedef enum : NSUInteger {
    PCFuncWifi,//wifi配置
    PCFuncPosture,//体态测量
    PCFuncFigure,//体形测量
} PCFunc;
@interface PCBlutoothController : YHBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic)BOOL isSetWifi;
@property (nonatomic)PCFunc func;
@end

