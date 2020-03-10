//
//  YHHelpCheckMapController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpCheckMapController.h"

#import "YHReservationModel.h"
#import "YHPointAnnotation.h"
#import "YHAnnotationView.h"

#import "YHMapSheetView.h"

#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"


#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MJExtension/MJExtension.h>
#import "YHCommon.h"
#import "YHStoreBookingViewController.h"

#import "YHMapSearchCell.h"

@interface YHHelpCheckMapController ()<MAMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YHReservationModel *> *searchArray;

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) NSMutableArray <YHReservationModel *>*tempModels;
@property (nonatomic, strong) NSMutableArray <YHReservationModel *>*models;

@property (nonatomic, strong) CLLocation * userLocation;

@end

@implementation YHHelpCheckMapController
@synthesize models = _models;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

//FIXME:  -  ---------------------------------UI---------------------------------
- (void)initUI
{
    [self initNav];
    
    [self initMapView];
    
    [self initSearchView];
}

//FIXME:  - 1.导航栏
- (void)initNav
{
    self.navigationItem.title = @"优选技术支持服务商";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

//FIXME:  - 2.地图
- (void)initMapView
{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    
    ///把地图添加至view
    [self.view addSubview:mapView];
    
    mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    //设置地图缩放比例，即显示区域
    //[mapView setZoomLevel:15.0 animated:YES];
    mapView.delegate = self;
    mapView.mapType = MAMapTypeStandard;
    //设置定位精度
    mapView.desiredAccuracy = kCLLocationAccuracyBest;
    
    //设置定位距离
    mapView.distanceFilter = 5.0f;
    
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView = mapView;
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
    [self.searchBtn setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [self.searchView addSubview:self.searchBtn];
    
    //搜索输入框
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame), 0, self.searchView.frame.size.width - self.searchBtn.frame.size.width, searchHeight)];
    self.searchTF.delegate = self;
    self.searchTF.clearButtonMode = UITextFieldViewModeAlways;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.placeholder = @"请输入查询地区或店名";
    [self.searchView addSubview:self.searchTF];
}

- (double)calculateDistanceWithTargetLatitude:(CLLocationDegrees)latitude1 longitude:(CLLocationDegrees)longitude1
{
    //1.将两个经纬度点转成投影点(latitude,longitude)
    //(1)目标定位
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude1,longitude1));
    
    //(2)当前定位:MAUserLocation *userLocation;
    MAMapPoint point2 = MAMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
    
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    return distance;
}

//FIXME:  -  ---------------------------------数据---------------------------------
-(void)initData
{
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getSolutionOrgListWithToken:[YHTools getAccessToken]
                                                                            name:@""
                                                                      onComplete:^(NSDictionary *info)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view];
         NSLog(@"\n站点列表:\n%@",info);
         
         if ([[info[@"code"]stringValue] isEqualToString:@"20000"]) {
             NSArray *tempArray = info[@"data"][@"list"];
             self.models = [YHReservationModel mj_objectArrayWithKeyValuesArray:tempArray];
         } else {
             
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

- (void)fixZoom{
   
    if(!self.userLocation) return;
    if (!_models.count) return;

    //2.过滤数据
    [_models enumerateObjectsUsingBlock:^(YHReservationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.distance = [self calculateDistanceWithTargetLatitude:[obj.lat doubleValue] longitude:[obj.lng doubleValue]];
    }];
    
    //3.排序
    [_models sortUsingComparator:^NSComparisonResult(YHReservationModel *obj1, YHReservationModel *obj2) {
        return obj1.distance > obj2.distance;
    }];

    
    
    YHReservationModel *lastModel = _models.lastObject;
    
    if (_models.count>=5) {
        lastModel = _models[4];
    }
    
    CLLocation *centerL = self.userLocation;
    if (!centerL) return;
    
    CLLocationDegrees latitudeDelta = fabs(2* ([lastModel.lat doubleValue] - centerL.coordinate.latitude));
    latitudeDelta += latitudeDelta * 0.2;
    CLLocationDegrees longitudeDelta = fabs(2 * ([lastModel.lng doubleValue] - centerL.coordinate.longitude));
    longitudeDelta += longitudeDelta * 0.2;

    MACoordinateRegion region = MACoordinateRegionMake(self.mapView.userLocation.location.coordinate, MACoordinateSpanMake( latitudeDelta,  longitudeDelta));
    
    [self.mapView setRegion:region];

    [self mapView:self.mapView regionDidChangeAnimated:NO];
    

}

#pragma mark  -  get/set 方法
- (void)setModels:(NSMutableArray <YHReservationModel *>*)models
{
    _models = models;
    _tempModels = models.mutableCopy;
    
    [self fixZoom];
}


#pragma mark --标记添加大头针
-(void)addAnomationWithCoor:(CLLocationCoordinate2D)coor ID:(NSString *)Id image:(NSString *)name
{
    YHPointAnnotation *anomationPoint = [[YHPointAnnotation alloc]init];
    anomationPoint.coordinate = coor;
    anomationPoint.ID = Id;
    anomationPoint.imageName = name;
    [self.mapView addAnnotation:anomationPoint];
}

#pragma mark --设置大头针：地图移动结束后
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s--地图移动结束后调用此接口", __func__);
    if (self.models.count == 0 || !self.models) {
        
    }else{
        for (YHReservationModel *reservationM in self.tempModels.reverseObjectEnumerator) {
            
            CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake([reservationM.lat doubleValue], [reservationM.lng doubleValue]);
            CGPoint point = [mapView convertCoordinate:locationCoordinate2D toPointToView:mapView];
            
            if (CGRectContainsPoint(mapView.bounds, point)) {
                [self.tempModels removeObject:reservationM];
                [self addAnomationWithCoor:locationCoordinate2D ID:reservationM.ID image:reservationM.coordinate_ico];
            }
        }
    }
}

#pragma mark --设置大头针上方气泡的内容的代理方法
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，
    if ([annotation isKindOfClass:[MAUserLocation class]]) return nil;
    //大头针标注
    //if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//如果不是自己的定位气泡，比如大头针就会进入
    if ([annotation isKindOfClass:[YHPointAnnotation class]]) {//如果不是自己的定位气泡，比如大头针就会进入
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        YHAnnotationView *annotationView = (YHAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[YHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 30, 30);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        //annotationView.pinColor = MAPinAnnotationColorPurple;
//        annotationView.backgroundColor = YHRandomColor;
        

        annotationView.image = [UIImage imageNamed:((YHPointAnnotation *)annotation).imageName];

        annotationView.ID = ((YHPointAnnotation *)annotation).ID;
        
//        if (self.searchArray.count) {
//            annotationView.hidden = ![annotationView.ID isEqualToString:self.searchArray[[self.tableView indexPathForSelectedRow].row].ID] ;// ;
//        }
        annotationView.canShowCallout = (self.models.count == 0 || !self.models);
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"%s", __func__);
    
    if(!updatingLocation) return;
    
    if (self.userLocation) {
        return;
    }
    
    self.userLocation = userLocation.location;
    
    [self fixZoom];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (self.models.count == 0 || !self.models) {
    }else{
        [self.mapView deselectAnnotation:view.annotation animated:YES];
    }
    
    //CLLocationCoordinate2D  distinateCoor = view.annotation.coordinate;
    //YHLog(@"高德纬度%f---高德经度%f",distinateCoor.latitude,distinateCoor.longitude);
    
    for (YHReservationModel *reservationM in self.models) {
        //获得服务器返回经纬度数据 调成跟高德返回数据一样的位数
        //NSRange rangelat = [reservationM.latitude rangeOfString:@"."];
        //NSString *latitudeS = [reservationM.latitude substringToIndex:rangelat.location+7];
        //NSRange rangeLong = [reservationM.longitude rangeOfString:@"."];
        //NSString *longitudeS = [reservationM.longitude substringToIndex:rangeLong.location+7];
        
        //将高德地图返回的经纬度 转化成字符串 与后台返回经纬度进行字符串匹配就可以了,就不会因为 floatValue而出现精度的问题
        //NSString *latitudeGD = [NSString stringWithFormat:@"%f",distinateCoor.latitude];
        //NSString *longitudeGD = [NSString stringWithFormat:@"%f",distinateCoor.longitude];
        
        //if ([latitudeGD isEqualToString:latitudeS] && [longitudeGD isEqualToString:longitudeS]) {
        YHAnnotationView *selectView = (YHAnnotationView *)view;
        if ([selectView isKindOfClass:[YHAnnotationView class]] && [selectView.ID isEqualToString:reservationM.ID]) {
            
            //获得大头针的那个模型
            NSLog(@"点击----%@----%@----%@",reservationM.name,reservationM.contact_tel,reservationM.address);
            
            WeakSelf;
            [YHMapSheetView showAnnotation:reservationM].didSelectBlock = ^(YHReservationModel *model) {
                !(_chooseAddr)? : _chooseAddr(model);
                YHStoreBookingViewController *VC = [[UIStoryboard storyboardWithName:@"YHStoreBooking" bundle:nil] instantiateViewControllerWithIdentifier:@"YHStoreBookingViewController"];
                VC.siteModel = weakSelf.siteModel;
                VC.reservationModel = model;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            };
            break;
        }
    }
    
}

#pragma mark - 添加缩放跟当前位置按钮
-(void)addZoomAndLocationButton
{
    //添加进行入大缩小按钮
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(_mapView.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        _mapView.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 150);
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_mapView addSubview:zoomPannelView];
    
    //添加定位当前位置按钮
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        _mapView.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 150);
    [_mapView addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
}

#pragma mark - 放大控件与缩小控件方法
- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

#pragma mark - 定位当前位置控件及方法
- (UIButton *)makeGPSButtonView
{
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction
{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}

#pragma mark - -----------------------------------------搜索视图----------------------------------------------
#pragma mark - ------------------------------textField代理方法-------------------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //1.清除之前所有数据源
    [self.searchArray removeAllObjects];
    
    //2.过滤数据
    for (int i = 0; i < self.models.count; i++) {
        YHReservationModel *model = self.models[i];
        if ([model.name containsString:self.searchTF.text] || [model.address containsString:self.searchTF.text]) {
            model.distance = [self calculateDistanceWithTargetLatitude:[model.lat doubleValue] longitude:[model.lng doubleValue]];
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
        [MBProgressHUD showError:@"暂无数据"];
        self.tableView.hidden = YES;
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    return YES;
}

#pragma mark - ------------------------------tableView代理方法-------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHMapSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHMapSearchCell"];
    [cell refreshUIWithModel:self.searchArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YHReservationModel *selectmodel = self.searchArray[indexPath.row];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([selectmodel.lat doubleValue], [selectmodel.lng doubleValue]) animated:YES];
    
    WeakSelf;
    [YHMapSheetView showAnnotation:selectmodel].didSelectBlock = ^(YHReservationModel *model) {
        !(_chooseAddr) ? : _chooseAddr(model);
        YHStoreBookingViewController *VC = [[UIStoryboard storyboardWithName:@"YHStoreBooking" bundle:nil] instantiateViewControllerWithIdentifier:@"YHStoreBookingViewController"];
        VC.siteModel = weakSelf.siteModel;
        VC.reservationModel = model;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}


#pragma mark - ---------------------------------懒加载---------------------------------
#pragma mark - 地图数组
- (NSMutableArray<YHReservationModel *> *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc]init];
    }
    return _models;
}

#pragma mark - 搜索数组
- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
}

#pragma mark - 搜索列表
- (UITableView *)tableView
{
    if (!_tableView) {
        if ((self.searchArray.count * 55) <= (screenHeight-NavbarHeight-100)) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, self.searchArray.count * 55)];
        } else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchView.frame)+10, screenWidth-40, screenHeight-NavbarHeight-100)];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"YHMapSearchCell" bundle:nil] forCellReuseIdentifier:@"YHMapSearchCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
