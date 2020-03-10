//
//  PCBluetoothManager.h
//  penco
//
//  Created by Zhu Wensheng on 2019/6/18.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "SynthesizeSingleton.h"
NS_ASSUME_NONNULL_BEGIN
#define bluetoothConnectedCode @990000 //蓝牙连接成功
#define bluetoothDisconnectedCode @990001 //蓝牙断开连接
#define bluetoothConnectFailedCode @990002 //蓝牙连接失败
#define bluetoothNotSavedCode @990003 //没有保存的蓝牙
#define bluetoothDelSavedCode @990004 //保存蓝牙数据失效

#define channelOnPeropheralView @"babyDefault"
#define channelOnCharacteristicView @"CharacteristicView"
//找到Characteristics的block
typedef void (^PCBluetoothDataFrameBlock)(NSDictionary *responseObject);

@interface PCBluetoothManager : NSObject
DEFINE_SINGLETON_FOR_HEADER(PCBluetoothManager);
#pragma mark - callback block
//设备状态改变的委托
@property (nonatomic, copy) PCBluetoothDataFrameBlock blockBluetoothDataFrame;
@property (nonatomic, readonly) BabyBluetooth *baby;

- (void)sendTo:(NSDictionary*)info;

//未保存蓝牙启动和连接
-(void)start:(NSString*)identifier;

//已保存蓝牙自动启动和连接
-(void)start;

//断开连接
-(void)stop;

//是否已有保存的蓝牙
- (BOOL)isSavedBluetooth;

- (CBManagerState)blutoothState;

//是否已连接蓝牙
- (BOOL)isConnected;

- (void)sendRunloop;


//订阅一个值
-(void)setNotifiy;
@end

NS_ASSUME_NONNULL_END
