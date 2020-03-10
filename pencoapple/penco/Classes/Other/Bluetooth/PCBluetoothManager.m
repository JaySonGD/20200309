//
//  PCBluetoothManager.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/18.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCBluetoothManager.h"
#import "BabyBluetooth.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "MBProgressHUD+MJ.h"
#define callbackBlock(...) if ([self __VA_ARGS__])   [self __VA_ARGS__ ]
#define callbackBlockWeak(...) if ([weakSelf __VA_ARGS__])   [weakSelf __VA_ARGS__ ]
#define localMsg(code, msg)  callbackBlockWeak(blockBluetoothDataFrame)\
(@{\
@"action" : code,\
@"msg" : msg\
}\
);

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
static NSString *const kCharacteristicUUIDNotice = @"FFF5";//通知频道
static NSString *const kCharacteristicUUIDRW = @"00009999-0000-1000-8000-00805F9B34FB";//读写频道
@interface PCBluetoothManager (){
    
    BOOL didSend;
}

@property (nonatomic,strong)CBCharacteristic *characteristicN;
@property (nonatomic,strong)CBCharacteristic *characteristicRW;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property (nonatomic)NSInteger receiveAll;
@property (nonatomic)NSInteger receiveCurrent;
@property (nonatomic,strong)NSMutableData *receiveData;
@property (nonatomic)NSInteger sendAll;
@property (nonatomic)NSInteger sendCurrent;
@property (nonatomic,strong)NSMutableData *sendData;
@end
@implementation PCBluetoothManager
DEFINE_SINGLETON_FOR_CLASS(PCBluetoothManager);

#pragma mark -对外接口
- (void)sendTo:(NSDictionary*)info{
    YHLog(@"%@", info);
    //模拟数据
    //    WeakSelf
    //    callbackBlockWeak(blockBluetoothDataFrame)(info);
    //    return;
    
    if (![[PCBluetoothManager sharedPCBluetoothManager] isConnected]) {
        WeakSelf
        localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！");
        return;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [self splitData:dataStr];
    
}


//未保存蓝牙启动和连接
-(void)start:(NSString*)identifier{
    //启动扫描
    [self babyDelegate];
    //延时自动连接蓝牙
//    [self performSelector:@selector(connectLocalBluetooth:) withObject:identifier afterDelay:2];
    [self connectLocalBluetooth:identifier];
    
}

//已保存蓝牙自动启动和连接
-(void)start{
    [self autoConnect];
}

//断开连接
-(void)stop{
    self.characteristicN = nil;
    self.characteristicRW = nil;
    self.currPeripheral = nil;
    //停止扫描
    [self.baby cancelScan];
    [self.baby cancelAllPeripheralsConnection];
}

//是否已有保存的蓝牙
- (BOOL)isSavedBluetooth{
    NSString *key =  [YHTools buluetoothName];
    return !([key isEqualToString:@""] || key == nil);
}

- (CBManagerState)blutoothState{
    return  self.baby.centralManager.state;
}


//是否已连接蓝牙
- (BOOL)isConnected{
    //        return YES;
    if (!(self.currPeripheral.state == CBPeripheralStateConnected)) {
        //        [MBProgressHUD showError:@"蓝牙已断开，请稍后再试！"];
    }
    return (self.currPeripheral.state == CBPeripheralStateConnected);
}

#pragma mark -内部逻辑

#define NOTIFY_MTU 120

- (void)splitData:(NSString*)info{
    if (didSend) {
        YHLog(@"发送中稍后再试！")
        return;
    }
    //    didSend = YES;
    self.sendData = [[info dataUsingEncoding:NSUTF8StringEncoding]mutableCopy];
    self.sendAll = self.sendData.length / NOTIFY_MTU + ((self.sendData.length % NOTIFY_MTU == 0)? (0) : (1));
    self.sendCurrent = 0;
    [self sendRunloop];
}

- (void)sendRunloop{
    if (self.sendCurrent >= self.sendAll) {
        didSend = NO;
        return ;
    }
    //    NSString *header = [NSData dataWithBytes:data.bytes length:2];//0xFF 0xFF
    //    NSData *count = [NSData dataWithBytes:&(self.sendAll) length:sizeof(b)];//数据包数量: 一个字节
    //    NSData *index = [NSData dataWithBytes:&(self.sendCurrent) length:sizeof(b)];//数据包索引:一个字节
    NSMutableData *chunk = [NSMutableData new];
    Byte header[] = {0XFF, 0XFF,self.sendAll,self.sendCurrent};
    NSData *dataHeader = [NSData dataWithBytes:&header length:4];
    [chunk appendData:dataHeader];
    //        3.1. 计算剩余多大数据量需要发送
    NSInteger amountToSend = self.sendData.length - (self.sendCurrent  * NOTIFY_MTU);
    //           不能大于120个字节
    if (amountToSend > NOTIFY_MTU)
        amountToSend = NOTIFY_MTU;
    //        3.2. copy出我们想要发送的数据
    [chunk appendData:[NSData dataWithBytes:self.sendData.bytes+(self.sendCurrent *NOTIFY_MTU)  length:amountToSend]];
    
    Byte tail[] = {0XEE, 0XEE};
    NSData *dataTail = [NSData dataWithBytes:&tail length:2];
    [chunk appendData:dataTail];
    
    [self writeValue:chunk];
    
    YHLog(@"send : %@", chunk);
    
    //    [self mergeData:chunk];
    //        3.5. 发送成功，修改已经发送成功数据index值
    self.sendCurrent += 1;
}

/*
 BLE一条指令通信组成:
 (1)包头:两个字节,分别为0xFF 0xFF
 (2)数据包数量: 一个字节
 (3)数据包索引:一个字节
 (4)数据:最多128个字节(为1.3节中的json数据)
 (5)包尾:两个字节 固定为0xEE 0xEE
 
 */
- (void)mergeData:(NSMutableData*)data{
    
    YHLog(@"receive : %@", data);
    if (data.length < 6) {//最短数据帧 6字节
        return;
    }
    NSInteger amount = data.length - 6;
    Byte *bytes = (Byte *)[data bytes];
    Byte count = bytes[2];//数据包数量: 一个字节
    Byte index = bytes[3];//数据包索引:一个字节
    NSData *chunk = [NSData dataWithBytes:data.bytes+4 length:amount];//数据:最多128个字节(为1.3节中的json数据)
    
    //    Byte b = 0XFF;
    //        NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    //
    if ((bytes[0] != 0XFF) && (bytes[1] != 0XFF)) {//帧头不对
        return;
    }
    if (self.receiveData == nil || index == 0) {//初始化接收池
        self.receiveData = [NSMutableData new];
        self.receiveCurrent = 0;
    }
    if (self.receiveCurrent != index) {//数据帧不对
        return;
    }
    [self.receiveData appendData:chunk];
    
    if (index + 1 == count) {//接收完毕
        WeakSelf
        NSString *receiveData = [[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
        
        NSDictionary *info = [YHTools dictionaryWithJsonString:receiveData];
        if ([[info objectForKey:@"action"] isEqualToString:@"301000"]) {
            [self sendRunloop];
        }else{
            callbackBlockWeak(blockBluetoothDataFrame)(info);
        }
    }
    self.receiveCurrent = index + 1;
}

//已有保存的蓝牙,自动连接
-(void)autoConnect{
    if (![YHTools buluetoothName]) {
        WeakSelf
        localMsg(bluetoothNotSavedCode, @"没有保存的蓝牙！");
        return;
    }
    
    //启动扫描
    [self babyDelegate];
    //延时自动连接蓝牙
    [self performSelector:@selector(connectLocalBluetooth:) withObject:nil afterDelay:2];
}

//连接保存的蓝牙
-(void)connectLocalBluetooth:(NSString*)identifier{
    //停止扫描
    [self.baby cancelScan];
    
    if (identifier == nil) {
        self.currPeripheral = [self.baby retrievePeripheralWithUUIDString:[YHTools buluetoothName]];
        NSArray *atmp = [NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0000180A-0000-1000-8000-00805F9B34FB"], nil];
        //    NSArray *atmp = [NSArray arrayWithObjects:[CBUUID UUIDWithString:[YHTools buluetoothName]], nil];
        NSArray *retrivedArray = [self.baby.centralManager retrieveConnectedPeripheralsWithServices:atmp];
        //b蓝牙重启，保存的蓝牙数据和新启动蓝牙数据不一致
        if (retrivedArray.count == 0) {
            
            [YHTools setbuluetoothName:nil];
            WeakSelf
            localMsg(bluetoothDelSavedCode, @"保存蓝牙数据失效！")
            return;
        }
    }else{
        self.currPeripheral = [self.baby retrievePeripheralWithUUIDString:identifier];
    }
//    [self.baby AutoReconnect:self.currPeripheral];
    self.baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}

- (BabyBluetooth *)baby{
    return [BabyBluetooth shareBabyBluetooth];
}

//写
-(void)writeValue:(NSData*)info{
    if(![self isConnected]){
        WeakSelf
        localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！")
        return;
    }
    
    if (self.characteristicRW == nil) {
        return;
    }
    [self.currPeripheral writeValue:info forCharacteristic:self.characteristicRW type:CBCharacteristicWriteWithResponse];
}


//读取服务
-(void)doing{
    self.baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristicRW);
}

//订阅一个值
-(void)setNotifiy{
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！")
        return;
    }
    if (self.characteristicN.properties & CBCharacteristicPropertyNotify ||  self.characteristicN.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.characteristicN.isNotifying) {
            //            [self.baby cancelNotify:self.currPeripheral characteristic:self.characteristicN];
            //            [btn setTitle:@"通知" forState:UIControlStateNormal];
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristicN];
            //            [btn setTitle:@"取消通知" forState:UIControlStateNormal];
            [self.baby notify:self.currPeripheral
               characteristic:self.characteristicN
                        block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                            YHLog(@"notify block");
                            //                YHLog(@"new value %@",characteristics.value);
                            //                       [self insertReadValues:characteristics];
                            //
                            //                            NSString *data = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
                            //                            NSDictionary *info = [YHTools dictionaryWithJsonString:data];
                            //                            callbackBlockWeak(blockBluetoothDataFrame)(info);
                            
                            [weakSelf mergeData:weakSelf.characteristicN.value];
                        }];
        }
        
        localMsg(bluetoothConnectedCode, @"蓝牙连接成功！")
    }
    else{
        localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！")
        return;
    }
    
}

-(void)babyDelegate{
    //    if (![self isSavedBluetooth]) {
    [self scanDelegate];
    //    }
    [self peripheralDelegate];
    [self characteristicDelegate];
}

//扫描
-(void)scanDelegate{
    
    __weak typeof(self)weakSelf = self;
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            //            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }else{
            localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！");
        }
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        YHLog(@"搜索到了设备:%@",peripheral.name);
        //        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        YHLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            YHLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        YHLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        YHLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            YHLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        YHLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"JingPiao"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        YHLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        YHLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:(NSString *)
     scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [self.baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
    //停止之前的连接
    [self.baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    self.baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

//peripheral设置
-(void)peripheralDelegate{
    
    
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        [YHTools setbuluetoothName:[peripheral.identifier UUIDString]];
    }];
    
    //设置设备连接失败的委托
    [self.baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        YHLog(@"设备：%@--连接失败",peripheral.name);
        localMsg(bluetoothConnectFailedCode, @"蓝牙连接失败！")
    }];
    
    //设置设备断开连接的委托
    [self.baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        localMsg(bluetoothDisconnectedCode, @"蓝牙已经断开连接！")
    }];
    
    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            //            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *c in service.characteristics) {
            if ([c.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUIDNotice]]) {
                weakSelf.characteristicN = c;
                [weakSelf setNotifiy];
            }
            if ([c.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUIDRW]]) {
                weakSelf.characteristicRW = c;
                weakSelf.characteristicN = c;
//                [weakSelf doing];
                [weakSelf setNotifiy];
            }
            YHLog(@"service name: %@ charateristic name is :%@", service.UUID, c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        YHLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        YHLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            YHLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        YHLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        YHLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        YHLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        YHLog(@"setBlockOnBeatsOver call");
    }];
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [self.baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

//Characteristic设置
-(void)characteristicDelegate{
    
    __weak typeof(self)weakSelf = self;
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //        YHLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        //        NSString *data = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
        //        if (data) {
        //            NSDictionary *info = [YHTools dictionaryWithJsonString:data];
        //            callbackBlockWeak(blockBluetoothDataFrame)(info);
        //        }
        [weakSelf mergeData:characteristics.value];
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        YHLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            YHLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            //            [weakSelf insertDescriptor:d];
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        
        YHLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置写数据成功的block
    [self.baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        YHLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
        
        // 读取数据
        [self.currPeripheral readValueForCharacteristic:self.characteristicRW];
    }];
    //设置通知状态改变的block
    [self.baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        YHLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
        if (!characteristic.isNotifying) {
            [weakSelf setNotifiy];
        }
    }];
}

////自定义初始化
//-(instancetype)init{
//    if (self = [super init]) {
//        //获取通知中心单例对象
//        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//        [center addObserver:self selector:@selector(mqttAction:) name:BabyNotificationAtCentralManagerDidUpdateState object:nil];
//
//    }
//    return self;
//}
//
//- (void)babyNotificationAtCentralManagerDidUpdateState:(NSNotification*)notice{
//    NSDictionary *info = notice.userInfo;
//    CBCentralManager *central = [info objectForKey:@"central"];
//}
//-(void)dealloc{
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end
