    //
//  ViewController.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//
#import <SDWebImage/UIImage+GIF.h>
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+RESideMenu.h"
#import "PCBlutoothController.h"
#import "YHNetworkManager.h"
#import "PCBluetoothManager.h"
#import "YHTools.h"
#import "PCBluetoothCell.h"
#import "PCSurveyController.h"
#import "MBProgressHUD+MJ.h"
#import "PCWifiController.h"
#import "PCAlertViewController.h"
//screen width and height
#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCBlutoothController ()<UITableViewDelegate>{
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
}

//定位管理器
@property (nonatomic, strong) CLLocationManager *localM;

@property (nonatomic, strong)CLGeocoder *geocoder;

@property(nonatomic, assign) CBManagerState state;
@property (weak, nonatomic) IBOutlet UIView *connectingV;
@property (weak, nonatomic) IBOutlet UIView *connectListV;
@property (weak, nonatomic) IBOutlet UIView *connectPrepareV;
@property (weak, nonatomic) IBOutlet UIView *connectSettingV;
@property (weak, nonatomic) IBOutlet UILabel *wifiCountL;
@property (nonatomic)BOOL isStart;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingCancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic)MBProgressHUD *hud;
@end

@implementation PCBlutoothController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"蓝牙连接" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
   self.imgV.image = [UIImage sd_imageWithGIFData:imageData];
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [PCBluetoothManager sharedPCBluetoothManager].baby;
    [self babyDelegate];
    
    self.connectPrepareV.hidden = NO;
    self.connectSettingV.hidden = YES;
    self.connectingV.hidden = NO;
    self.connectListV.hidden = YES;
    self.cancelBtn.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    YHLayerBorder(self.settingCancelBtn, YHNaviColor, 1.5);
    
    //开始定位
    [self getLocation];
    [self prepareStartAction:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    YHLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //设置蓝牙委托
    [self babyDelegate];
    WeakSelf
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        YHLog(@"%@", responseObject)
        NSNumber *code = [responseObject objectForKey:@"action"];
        switch (code.integerValue) {
            case 200003://3.3.3. 获取设备联网信息
            {
                //            statue:联网结果,
                //                0:表示已经配网,
                //                1:已经配网但网络不通
                //                2: 没有配网
                
                [MBProgressHUD hideHUDForView:weakSelf.view];
                NSNumber *statue = [responseObject objectForKey:@"statue"];
                if (statue.integerValue == 0) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
                    PCSurveyController *controller = [board instantiateViewControllerWithIdentifier:@"PCSurveyController"];
                    controller.isPosture = (self.func == PCFuncPosture);
                    [self.navigationController pushViewController:controller animated:YES];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    PushControllerBlockAnimated(@"Bluetooth", @"PCWifiController", ((PCWifiController*)controller).func = weakSelf.func;, YES);
                }
            }
                break;
                
            case 990000:
            {
                YHLog(@"蓝牙自动连接成功！");
                
                [self.hud setCompletionBlock:nil];

                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD showError:@"蓝牙连接成功！" toView:self.navigationController.view];
                if (self.func == PCFuncWifi) {
//                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    PushControllerBlockAnimated(@"Bluetooth", @"PCWifiController", ((PCWifiController*)controller).func = weakSelf.func;, YES);
                }else{

//                    [MBProgressHUD hideHUDForView:weakSelf.view];
//                    [MBProgressHUD showError:@"蓝牙连接成功！" toView:self.navigationController.view];
                    [self getDeviceNet];
                }
            }
                break;
            case 990001 :
            {
                YHLog(@"蓝牙已断开！");
                
//                [MBProgressHUD sh:weakSelf.view];
                [[PCBluetoothManager sharedPCBluetoothManager] stop];
                [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
                    ;
                }];
//                [peripheralDataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf babyDelegate];
                [MBProgressHUD showError:@"连接失败" toView:self.view];
            }
                break;
                case 990002 :
            {
                YHLog(@"蓝牙连接失败！");
                [MBProgressHUD showError:@"连接失败" toView:self.view];
            }
                                break;
            case 990004://保存蓝牙数据失效
            {
                
                [MBProgressHUD hideHUDForView:weakSelf.view];
                YHLog(@"保存蓝牙数据失效！");
                [weakSelf babyDelegate];
                
                [weakSelf scanBluetooth];
                weakSelf.connectPrepareV.hidden = YES;
                weakSelf.connectSettingV.hidden = YES;
                weakSelf.connectingV.hidden = YES;
                weakSelf.connectListV.hidden = NO;
                weakSelf.cancelBtn.hidden = YES;
            }
                break;
                
            default:
                break;
        }
   
    }];
    
    if ([[PCBluetoothManager sharedPCBluetoothManager] isSavedBluetooth]) {
        [[PCBluetoothManager sharedPCBluetoothManager] start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    YHLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}

-(void)su{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    PCSurveyController *controller = [board instantiateViewControllerWithIdentifier:@"PCSurveyController"];
    [self.navigationController pushViewController:controller animated:YES];
}

//3.3.3. 获取设备联网信息
- (void)getDeviceNet{
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
       @"action": @"100003"
       }
     ];
}



- (void)scanBluetooth{
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

- (IBAction)cancelConnectAction:(id)sender {
    self.isStart = NO;
    self.connectPrepareV.hidden = NO;
    self.connectSettingV.hidden = YES;
    self.connectingV.hidden = NO;
    self.connectListV.hidden = YES;
    self.cancelBtn.hidden = YES;
}

//准备蓝牙配对
- (IBAction)prepareStartAction:(id)sender {
    self.isStart = YES;
    [MBProgressHUD showMessage:@"蓝牙启动中..." toView:self.view];
    [self blutoothStateDo:[[PCBluetoothManager sharedPCBluetoothManager] blutoothState]];
    [self scanBluetooth];
}

//取消设置蓝牙
- (IBAction)cancelSettingAction:(id)sender {
    
    self.isStart = NO;
    self.connectPrepareV.hidden = NO;
    self.connectSettingV.hidden = YES;
    self.connectingV.hidden = NO;
    self.connectListV.hidden = YES;
    self.cancelBtn.hidden = YES;
}

//开启蓝牙
- (IBAction)settingAction:(id)sender {
//    [MBProgressHUD showError:@"在“设置”中开启蓝牙"];
    WeakSelf
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"在“设置”中开启蓝牙" message:nil];
    [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [weakSelf blutoothStateDo:[[PCBluetoothManager sharedPCBluetoothManager] blutoothState]];
        [weakSelf scanBluetooth];
    }];
    [weakSelf presentViewController:vc animated:NO completion:nil];
}

//取消蓝牙列表
- (IBAction)cancelConnetListAction:(id)sender {
    self.isStart = NO;
    self.connectPrepareV.hidden = NO;
    self.connectSettingV.hidden = YES;
    self.connectingV.hidden = NO;
    self.connectListV.hidden = YES;
    self.cancelBtn.hidden = YES;
    
    
    //停止扫描
    [baby cancelScan];
}

- (void)blutoothStateDo:(CBManagerState)state{
    WeakSelf
    
    [MBProgressHUD hideHUDForView:weakSelf.view];
    if (!self.isStart) {
        return;
    }
    if (state == CBCentralManagerStatePoweredOn) {
//        [MBProgressHUD showError:@"设备打开成功，开始扫描设备"];
        weakSelf.connectPrepareV.hidden = YES;
        weakSelf.connectSettingV.hidden = YES;
        weakSelf.connectingV.hidden = NO;
        weakSelf.connectListV.hidden = YES;
        weakSelf.cancelBtn.hidden = YES;
        [weakSelf scanBluetooth];
        
    }else{
        weakSelf.connectPrepareV.hidden = YES;
        weakSelf.connectSettingV.hidden = NO;
        weakSelf.connectingV.hidden = YES;
        weakSelf.connectListV.hidden = YES;
        weakSelf.cancelBtn.hidden = NO;
    }
}
#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        weakSelf.state = central.state;
        [weakSelf blutoothStateDo:central.state];
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        YHLog(@"搜索到了设备:%@, %@",peripheral, advertisementData);
        
        NSString *peripheralName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        if (peripheralName) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            weakSelf.connectPrepareV.hidden = YES;
            weakSelf.connectSettingV.hidden = YES;
            weakSelf.connectingV.hidden = YES;
            weakSelf.connectListV.hidden = NO;
            weakSelf.cancelBtn.hidden = YES;
            [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }];
    
   
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        YHLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            YHLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        YHLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        YHLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            YHLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        YHLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    

    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        NSString *name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        //最常用的场景是查找某一个前缀开头的设备
        if ([name hasPrefix:@"L-RUL001"] ) {
            return YES;
        }
//        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
//        if (peripheralName.length >0) {
//            return YES;
//        }
        return NO;
    }];

    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        YHLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        YHLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
        
        参数分别使用在下面这几个地方，若不使用参数则传nil
        - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
        - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
        - [peripheral discoverServices:discoverWithServices];
        - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
        
        该方法支持channel版本:
            [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    

}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSString *peripheralName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
            
        //名称重复过滤
        [peripheralDataArray enumerateObjectsUsingBlock:^(NSDictionary *p, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *advertisementDataOld = p[@"advertisementData"];
            NSString *peripheralNameOld = [advertisementDataOld objectForKey:@"kCBAdvDataLocalName"];
            if ([peripheralName isEqualToString:peripheralNameOld]) {
                [peripheralDataArray removeObject:p];
                *stop = YES;
            }
        }];
//        peripherals = [peripheralDataArray valueForKey:@"peripheral"];
//
//        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
//        [indexPaths addObject:indexPath];
//
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.wifiCountL.text = [NSString stringWithFormat:@"已经搜索到%d个塑形尺可进行连接", peripheralDataArray.count];
     return peripheralDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCBluetoothCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    [cell loadName:peripheralName];
//    cell.textLabel.text = peripheralName;
    //信号和服务
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //停止扫描
    [baby cancelScan];
    self.hud = [MBProgressHUD showMessage:@"" toView:self.view];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    [self performSelector:@selector(connect:) withObject:item afterDelay:1.];
    
}

-(void)connect:(NSDictionary*)item{
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    [[PCBluetoothManager sharedPCBluetoothManager] start:[peripheral.identifier UUIDString]];
    WeakSelf
    [self.hud setCompletionBlock:^{
       
//        [peripheralDataArray removeObject:item];
        [weakSelf.tableView reloadData];

        [weakSelf babyDelegate];
        //启动重新搜索
        weakSelf.isStart = YES;
        [weakSelf performSelector:@selector(scanBluetooth) withObject:nil afterDelay:1.];
        [MBProgressHUD showError:@"连接失败" toView:self.view];
    }];
}
//{
//    //停止扫描
//    [baby cancelScan];
//
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PeripheralViewController *vc = [[PeripheralViewController alloc]init];
//    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
//    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
//    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
//    [YHTools setbuluetoothName:[peripheral.identifier UUIDString]];
//    vc.currPeripheral = peripheral;
//    vc->baby = self->baby;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}


- (IBAction)popViewController:(id)sender{
    [MBProgressHUD hideHUDForView:self.view];
//    [[PCBluetoothManager sharedPCBluetoothManager] stop];
//    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
//        ;
//    }];
    if (self.func == PCFuncPosture) {
        [super popViewController:sender];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (self.isSetWifi) {
            [self presentLeftMenuViewController:sender];
        }
    }
}


#pragma mark - gps定位

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.localM = [[CLLocationManager alloc]init];
        self.localM.delegate = self;
        //        [self.localM requestAlwaysAuthorization];
        [self.localM requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.localM.desiredAccuracy = kCLLocationAccuracyBest;
        self.localM.distanceFilter = 5.0;
        [self.localM startUpdatingLocation];
    }else{
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"打开位置定位可增强蓝牙效果" message:nil];
        [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        }];
        [self presentViewController:vc animated:NO completion:nil];
    }
}

//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.localM stopUpdatingLocation];
    //设置提示提醒用户打开定位服务
    self.localM = nil;
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"打开位置定位可增强蓝牙效果" message:nil];
    
    [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
    }];
    [self presentViewController:vc animated:NO completion:nil];
}

/*
 CLLocationManagerDelegate方法：更新定位信息
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.localM stopUpdatingLocation];
    //取出位置信息
    CLLocation *location = [locations firstObject];
    
    //获取当前位置经纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    YHLog(@"latitude: %f, longitude: %f", coordinate.latitude, coordinate.longitude);
    [self coordinateToAdressWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.localM = nil;
    //    //获取当前位置海拔
    //    CLLocationDistance altitude = location.altitude;
    //    YHLog(@"海拔: %f", altitude);
    //
    //    //获取当前航向，取值0.0度-359.9度，0.0为真北方向
    //    CLLocationDirection course = location.course;
    //    YHLog(@"航向: %f", course);
    //
    //    //获取当前行走速度
    //    CLLocationSpeed speed = location.speed;
    //    YHLog(@"航向: %f", speed);
}
/*
 自定义方法：将经纬度转为地址
 */
- (void)coordinateToAdressWithLatitude:(CLLocationDegrees)latitude
                             longitude:(CLLocationDegrees)longitude{
    
    WeakSelf
    self.geocoder = [[CLGeocoder alloc]init];
    //根据经纬度值创建地址对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //反编码经纬度为地址
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        //经纬度错误
        if(error){
            return;
        }
        if (placemarks.count > 0) {
            
            //取出首个地址
            CLPlacemark *placemark = [placemarks firstObject];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) { //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            [YHTools setprovince:placemark.administrativeArea];
            [YHTools setcityName:city];
            [YHTools setarea:placemark.subLocality];
        }
        weakSelf.geocoder = nil;
    }];
}
@end
