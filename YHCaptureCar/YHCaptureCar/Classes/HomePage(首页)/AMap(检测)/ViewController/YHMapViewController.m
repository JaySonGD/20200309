//
//  YHMapViewController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/17.
//  Copyright © 2018年 YH. All rights reserved.
//

//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>
#import <MJExtension.h>
#import "YHMapViewController.h"
#import "MapManager.h"
#import "YHNetworkManager.h"
#import "YHReservationModel.h"
#import "YHTools.h"
#import "YHMapSearchCell.h"
#import "YHReservationVC.h"
#import "YHMapSheetView.h"
#import "YHNewReservationVC.h"
#import "YHReservationNewVC.h"

@interface YHMapViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YHReservationModel *> *searchArray;

@property (nonatomic, strong) MapManager *manager;

@property (nonatomic,strong)NSMutableArray *reservationArr;

@end

@implementation YHMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
}

//FIXME:  -  ---------------------------------UI---------------------------------
- (void)initUI
{
    [self initNav];
}

//FIXME:  - 1.导航栏
- (void)initNav
{
    self.navigationItem.title = @"地图页面";
    self.view.backgroundColor = [UIColor whiteColor];
}

//FIXME:  - 3.搜索框
- (void)initSearchView
{
    CGFloat searchHeight = 40;
    
    //搜索视图
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(20, NavbarHeight+10, screenWidth-40, searchHeight)];
    self.searchView.backgroundColor = YHWhiteColor;
    [self.view addSubview:self.searchView];
    
    //搜索按钮
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(0, 0, 40, searchHeight);
    self.searchBtn.backgroundColor = YHWhiteColor;
    [self.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchView addSubview:self.searchBtn];
    
    //搜索输入框
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame), 0, self.searchView.frame.size.width - self.searchBtn.frame.size.width, searchHeight)];
    self.searchTF.delegate = self;
    self.searchTF.clearButtonMode = UITextFieldViewModeAlways;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.placeholder = @"请输入查询地区或店名";
    [self.searchView addSubview:self.searchTF];
}

//FIXME:  - 4.搜索列表
- (void)initTableView
{
    if ((self.searchArray.count * 55) <= (screenHeight-NavbarHeight-100)) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, self.searchArray.count * 55)];
    } else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, screenHeight-NavbarHeight-100)];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YHMapSearchCell" bundle:nil] forCellReuseIdentifier:@"YHMapSearchCell"];
    [self.view addSubview:self.tableView];
}

//FIXME:  -  ---------------------------------数据---------------------------------
- (void)initData
{
    //1.车辆详情
    if (self.isNavi) {
        
        [self navi];
    //2.其它
    }else{
        //(1).加载预约数据
        [self loadReservationData];
        
        //(2).不管什么地图都先定位自己的位置
        [self locationOnlySelf];
        
        [self initSearchView];
    }
}

//FIXME:  -  -------------------------------1.车辆详情-------------------------------
-(void)navi
{
    MapManager *manager = [MapManager sharedManager];
    manager.controller = self;
    [manager initMapView];
    manager.reservationArr = nil;
    [manager GeocodingWithAddress:_addrStr];
}

//FIXME:  -  ---------------------------------2.其它---------------------------------
#pragma mark - (1).加载预约数据
-(void)loadReservationData
{
    WeakSelf;
    [[YHNetworkManager sharedYHNetworkManager]repairShopListAddrWithToken:[YHTools getAccessToken] keyWord:nil onComplete:^(NSDictionary *info) {
        
        YHLog(@"====哈哈哈:%@====",info);
        
        //数据解析
        NSArray *stationListArr = info[@"result"][@"stationList"];
        
        weakSelf.reservationArr = [YHReservationModel mj_objectArrayWithKeyValuesArray:stationListArr];
        
        [MapManager sharedManager].reservationArr = weakSelf.reservationArr;
        
    } onError:^(NSError *error) {
    
    }];
}

#pragma mark - (2).不管什么地图都先定位自己的位置
-(void)locationOnlySelf
{
    MapManager *manager = [MapManager sharedManager];
    manager.controller = self;
    [manager initMapView];
}

//FIXME:  -  ------------------------------textField代理方法-------------------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1.清除之前所有数据源
    [self.searchArray removeAllObjects];
    
    //2.过滤数据
    for (int i = 0; i < self.reservationArr.count; i++) {
        YHReservationModel *model = self.reservationArr[i];
        if ([model.name containsString:self.searchTF.text] || [model.addr containsString:self.searchTF.text]) {
            model.distance = [self calculateDistanceWithTargetLatitude:[model.latitude doubleValue] longitude:[model.longitude doubleValue]];
            [self.searchArray addObject:model];
        }
    }
    
    //3.排序
    [self.searchArray sortUsingComparator:^NSComparisonResult(YHReservationModel *obj1, YHReservationModel *obj2) {
        return obj1.distance > obj2.distance;
    }];
    
    //4.收起键盘
    [textField resignFirstResponder];
    
    //5.数据源不为空，创建列表
    if (self.searchArray.count != 0) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
        [MBProgressHUD showError:@"暂无数据"];
        [_tableView removeFromSuperview];
        self.tableView = nil;
    }
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    return YES;
}

//FIXME:  -  ------------------------------tableView代理方法-------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHMapSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHMapSearchCell"];
    [cell refreshUIWithModel:self.searchArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHReservationModel *selectmodel = self.searchArray[indexPath.row];
    
    [[MapManager sharedManager].mapView setCenterCoordinate:CLLocationCoordinate2DMake([selectmodel.latitude doubleValue], [selectmodel.longitude doubleValue]) animated:YES];
    
    [YHMapSheetView showAnnotation:selectmodel].didSelectBlock = ^(YHReservationModel *reservationM) {
//        YHNewReservationVC *newResVC = [[UIStoryboard storyboardWithName:@"AMap" bundle:nil] instantiateViewControllerWithIdentifier:@"YHNewReservationVC"];
//        newResVC.reservationM = reservationM;  //跳转过去的时候将对应的模型数据传入
        YHReservationNewVC *newResVC = [YHReservationNewVC new];
        newResVC.reservationM = reservationM;
        [self.navigationController pushViewController:newResVC animated:YES];
    };
    
    [self.tableView removeFromSuperview];
    _tableView = nil;
}

- (double)calculateDistanceWithTargetLatitude:(CLLocationDegrees)latitude1 longitude:(CLLocationDegrees)longitude1
{
    //1.将两个经纬度点转成投影点(latitude,longitude)
    //(1)目标定位
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude1,longitude1));

    //(2)当前定位:MAUserLocation *userLocation;
    MAMapPoint point2 = MAMapPointForCoordinate([MapManager sharedManager].mapView.userLocation.location.coordinate);

    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);

    return distance;
}

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    [self popViewController:nil];
}
    
//给一个坐标，在地图上显示大头针
-(void)addAnonationWithLatitude:(double)latitude longitude:(double)longitude
{
    [MapManager sharedManager].destinationImgName = @"云虎";
    [MapManager sharedManager].locationPointImgName = @"云虎";
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    [[MapManager sharedManager] addAnomationWithCoor:coor];
}

//FIXME:  -  ---------------------------------懒加载----------------------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        if ((self.searchArray.count * 55) <= (screenHeight-NavbarHeight-100)) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, self.searchArray.count * 55)];
        } else {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, screenHeight-NavbarHeight-100)];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"YHMapSearchCell" bundle:nil] forCellReuseIdentifier:@"YHMapSearchCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)reservationArr
{
    if (!_reservationArr) {
        _reservationArr = [[NSMutableArray alloc]init];
    }
    return _reservationArr;
}

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
}

-(void)dealloc
{
    NSLog(@"挂了没有挂了为什么");
    [MapManager sharedManager].currentLocation = nil;
    [MapManager sharedManager].updatedLocation = NO;
    [MapManager sharedManager].models = nil;

}

@end
