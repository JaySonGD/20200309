//
//  MapManager.m


#import "MapManager.h"
#import "SpeechSynthesizer.h"
#import "MoreMenuView.h"

#import "YHReservationVC.h"
#import "YHReservationNewVC.h"
#import "YHCommon.h"
#import "YHReservationModel.h"

#import "YHAnnotationView.h"
#import "YHPointAnnotation.h"

#import "YHMapSheetView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface MapManager()<MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate,AMapNaviWalkViewDelegate,AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate,MoreMenuViewDelegate,YHReservationVCDelegate>

@property (nonatomic, strong)NSMutableArray *searchResultArr;
@property (nonatomic, strong) MoreMenuView *moreMenu;//导航页面菜单选项
@property (nonatomic, strong) UIButton *gpsButton;

/**
 预约控制器
 */
@property (nonatomic, strong)YHReservationVC *ReservationVC;

/**
 大头针视图
 */
@property(nonatomic,strong)MAAnnotationView *annotationView;




@end

static CLLocationCoordinate2D distinateCoor;//目的地坐标

@implementation MapManager

#pragma mark --创建一个单例类对象
+(instancetype)sharedManager{
    static MapManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化单例对象
        instance = [[MapManager alloc]init];
    });
    return instance;
}

#pragma mark --初始化地图对象
-(void)initMapView{
    
    [self initSearch];
    
    ///初始化地图
    MAMapView * mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64)];
    _mapView = mapView;
    ///把地图添加至view
    [self.controller.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //设置地图缩放比例，即显示区域
    [_mapView setZoomLevel:19.0 animated:YES];
    _mapView.delegate = self;
    
    //设置定位精度
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    
    //设置定位距离
    _mapView.distanceFilter = 5.0f;
    
    //把中心点设成自己的坐标
    _mapView.centerCoordinate = self.currentLocation.coordinate;
    
    //添加进行入大缩小按钮
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(_mapView.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        _mapView.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
    
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_mapView addSubview:zoomPannelView];
    
    //添加定位当前位置按钮
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        _mapView.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
    [_mapView addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
}
#pragma mark - 放大控件与缩小控件方法
- (UIView *)makeZoomPannelView{
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

- (void)zoomPlusAction{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

#pragma mark - 定位当前位置控件及方法
- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}


#pragma mark --带block的地图初始化方法
-(void)initMapViewWithBlock:(MapBlock)block{
    //    [self initSearch];
    //    ///初始化地图
    //    _mapView = [[MAMapView alloc] initWithFrame:self.controller.view.bounds];
    //    ///把地图添加至view
    //    [self.controller.view addSubview:_mapView];
    //    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    //    _mapView.showsUserLocation = YES;
    //    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //    //设置地图缩放比例，即显示区域
    //    [_mapView setZoomLevel:15.1 animated:YES];
    //    _mapView.delegate = self;
    //    //设置定位精度
    //    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //    //设置定位距离
    //    _mapView.distanceFilter = 5.0f;
    
    [self initMapView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}
#pragma mark --初始化导航管理类对象
- (void)initWalkManager
{
    if (self.walkManager == nil)
    {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
    }
}
#pragma mark --初始化导航管理类对象
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        
        //        Showing Recent Issues
        //        /Users/liusong/Desktop/Code/YHCaptureCar/YHCaptureCar/Classes/AMap/MapTool/MapManager.m:162:59: 'init' is unavailable: since 5.4.0 init 已被禁止使用，请使用单例 [AMapNaviDriveManager sharedInstance] 替代，且在调用类的 dealloc 函数里或其他适当时机(如导航ViewController被pop时)，调用 [AMapNaviDriveManager destroyInstance] 来销毁单例（需要注意如未销毁成功，请检查单例是否被强引用)
        
        //        self.driveManager = [[AMapNaviDriveManager alloc] init];
        self.driveManager = [AMapNaviDriveManager sharedInstance];
        [self.driveManager setDelegate:self];
    }
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

- (void)fixZoom{
    
    if(!self.updatedLocation) return;
    
    if (!_reservationArr.count) return;
    
    //2.过滤数据
    [_reservationArr enumerateObjectsUsingBlock:^(YHReservationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.distance = [self calculateDistanceWithTargetLatitude:[obj.latitude doubleValue] longitude:[obj.longitude doubleValue]];
    }];
    
    //3.排序
    [_reservationArr sortUsingComparator:^NSComparisonResult(YHReservationModel *obj1, YHReservationModel *obj2) {
        return obj1.distance > obj2.distance;
    }];
    
    
    
    YHReservationModel *lastModel = _reservationArr.lastObject;
    
    if (_reservationArr.count>=5) {
        lastModel = _reservationArr[4];
    }
    
    
    CLLocation *centerL = self.currentLocation;
    if (!centerL) return;
    
    NSLog(@"%s----ios-MKCoordinateRegion setRegion 问题——CSDN问答频道", __func__);
    
    
    
    CLLocationDegrees latitudeDelta = fabs(2* ([lastModel.latitude doubleValue] - centerL.coordinate.latitude));
    latitudeDelta += latitudeDelta * 0.25;
    CLLocationDegrees longitudeDelta = fabs(2 * ([lastModel.longitude doubleValue] - centerL.coordinate.longitude));
    longitudeDelta += longitudeDelta * 0.25;
    
    MACoordinateRegion region = MACoordinateRegionMake(self.currentLocation.coordinate, MACoordinateSpanMake( latitudeDelta,  longitudeDelta));
    
    [self.mapView setRegion:region];
    
    [self mapView:self.mapView regionDidChangeAnimated:NO];
    
    
}



- (void)setReservationArr:(NSMutableArray *)reservationArr
{
    _reservationArr = reservationArr;
    self.models = reservationArr.mutableCopy;
    //[self mapView:self.mapView regionDidChangeAnimated:NO];
    [self fixZoom];
}

#pragma mark --标记添加大头针
-(void)addAnomationWithCoor:(CLLocationCoordinate2D)coor
{
    //地理坐标反编码为文字
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    [_search AMapReGoecodeSearch:request];
    _anomationPoint = [[MAPointAnnotation alloc]init];
    _anomationPoint.coordinate = coor;
    [self.mapView addAnnotation:_anomationPoint];
    //    //将标记点的位置放在地图的中心
    //    _mapView.centerCoordinate = coor;
}

#pragma mark --标记添加大头针
-(void)addAnomationModel:(YHReservationModel *)model
//-(void)addAnomationWithCoor:(CLLocationCoordinate2D)coor ID:(NSString *)Id
{
    CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);

    YHPointAnnotation *anomationPoint = [[YHPointAnnotation alloc]init];
    anomationPoint.coordinate = locationCoordinate2D;
    anomationPoint.ID = model.ID;
    anomationPoint.sceneIcon = model.sceneIcon;
    [self.mapView addAnnotation:anomationPoint];
}


#pragma mark --设置大头针：地图移动结束后
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    YHLog(@"%s--地图移动结束后调用此接口", __func__);
    if (self.models.count == 0 || !self.models) {
        
        self.destinationImgName = @"云虎";
        self.locationPointImgName = @"云虎";
        
//        CLLocationCoordinate2D coor;
//        coor.latitude = self.endPoint.latitude;
//        coor.longitude = self.endPoint.longitude;
//        [self addAnomationWithCoor:coor];
    }else{
        
        for (YHReservationModel *reservationM in self.models.reverseObjectEnumerator) {
            
            CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake([reservationM.latitude doubleValue], [reservationM.longitude doubleValue]);
            CGPoint point =   [mapView convertCoordinate:locationCoordinate2D toPointToView:mapView];
            //NSLog(@"%s----(%@)-----", __func__,reservationM.name);

            if (CGRectContainsPoint(mapView.bounds, point)) {
                [self.models removeObject:reservationM];
                //NSLog(@"%s----[%@]-----", __func__,reservationM.name);

                self.destinationImgName = @"云虎";
                self.locationPointImgName = @"云虎";
                //[self addAnomationWithCoor:locationCoordinate2D];
                //[self addAnomationWithCoor:locationCoordinate2D ID:reservationM.ID];
                [self addAnomationModel:reservationM];
            }
        }
    }
}

#pragma mark --设置大头针上方气泡的内容的代理方法
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    //大头针标注
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        YHAnnotationView*annotationView = (YHAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[YHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 100, 100);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        
        //设置大头针显示的图片
        if (!self.locationPointImgName) {
            annotationView.image = [UIImage imageNamed:@"定位"];
        }else{
            annotationView.image = [UIImage imageNamed:self.locationPointImgName];
        }
        
        
        
        //设置大头针显示的图片
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            annotationView.image = [UIImage imageNamed:@"定位"];
        }else{
            annotationView.image = [UIImage imageNamed:self.locationPointImgName];
        }
        
        
        if ([annotation isKindOfClass:[YHPointAnnotation class]]) {
            annotationView.ID = ((YHPointAnnotation *)annotation).ID;
            annotationView.image = [UIImage imageNamed:((YHPointAnnotation *)annotation).sceneIcon];
            //annotationView.image = [UIImage imageNamed:@"jns"];

        }else{
            annotationView.ID = nil;
        }

        

        //------------------------导航-----------------------
        //大头针默认视图暂时不用
        //点击大头针显示的左边的视图
        UIImageView *imageV = [[UIImageView alloc]init];
        if (!self.destinationImgName) {
            imageV.image = [UIImage imageNamed:@"目的地"];
        }else{
            imageV.image = [UIImage imageNamed:self.destinationImgName];
        }
        annotationView.leftCalloutAccessoryView = imageV;
        
        //点击大头针显示的右边视图
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        rightButton.backgroundColor = [UIColor grayColor];
        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(navBtnClick) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        //---------------------------------------------------
        
        annotationView.canShowCallout = (self.models.count == 0 || !self.models);
        annotationView.canShowCallout = NO;

        return annotationView;
    }
    return nil;
}

#pragma mark - ReservationVCDelegate
-(void)pushToNewReservationVCWithReserM:(YHReservationModel*)reservationM{
    [self.ReservationVC dismissViewControllerAnimated:YES completion:^{
        //push出 新增预约控制器
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
        YHReservationNewVC *newResVC = [YHReservationNewVC new];
        newResVC.reservationM = reservationM;  //跳转过去的时候将对应的模型数据传入
        [self.controller.navigationController pushViewController:newResVC animated:YES];
    }];
}

#pragma mark --导航点击事件
-(void)navBtnClick{
    
    self.controller.navigationController.navigationBar.hidden = YES;
    NSLog(@"%lf---%lf",distinateCoor.latitude,distinateCoor.longitude);
    
    //初始化起点和终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    //    self.endPoint   = [AMapNaviPoint locationWithLatitude:distinateCoor.latitude longitude:distinateCoor.longitude];
    [self initDriveManager];
    self.driveView = [[AMapNaviDriveView alloc] init];
    self.driveView.frame = self.controller.view.frame;
    self.driveView.delegate = self;
    [self.controller.view addSubview:self.driveView];
    [self.driveManager addDataRepresentative:self.driveView];
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

#pragma mark serach初始化
-(void)initSearch{
    _search =[[AMapSearchAPI alloc] init];
    _search.delegate=self;
}

#pragma mark --初始化导航菜单键
- (void)initMoreMenu
{
    if (self.moreMenu == nil)
    {
        self.moreMenu = [[MoreMenuView alloc] init];
        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.moreMenu setDelegate:self];
    }
}

#pragma mark --地图纠偏
-(CLLocationCoordinate2D)currectGpsWithLocation:(CLLocationCoordinate2D)coor{
    CLLocationCoordinate2D gcjPt = [JZLocationConverter wgs84ToGcj02:coor];
    NSLog(@"%lf,%lf",gcjPt.latitude,gcjPt.longitude);
    return gcjPt;
}
#pragma mark 搜索请求发起后的回调,用于标记自己当前的位置
/**失败回调*/
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSLog(@"request: %@------error:  %@",request,error);
}
//*成功回调
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    //我们把编码后的地理位置，显示到 大头针的标题和子标题上
    NSString *title =response.regeocode.addressComponent.city;
    NSLog(@"%@",title);
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    //    NSLog(@"=====%@",request.location);
    if (request.location.latitude == _currentLocation.coordinate.latitude&&request.location.longitude == _currentLocation.coordinate.longitude) {
        _mapView.userLocation.title = title;
        _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    }else{
        self.anomationPoint.title = title;
        self.anomationPoint.subtitle = response.regeocode.formattedAddress;
    }
}
#pragma mark 定位更新回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation){
        self.currentLocation = [userLocation.location copy];
        if (self.updatedLocation) {
            return;
        }
        self.updatedLocation = YES;
        [self fixZoom];

    }

}
-(void)setCurrentLocation:(CLLocation *)currentLocation{
    
    if (!_currentLocation) {
        _currentLocation = currentLocation;
        _mapView.centerCoordinate = currentLocation.coordinate;
        [self reGeoCoding];
    }
}
#pragma mark 逆地理编码,经纬度编码成地址
-(void)reGeoCoding{
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request =[[AMapReGeocodeSearchRequest alloc] init];
        request.location =[AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}
#pragma mark --地址编码成经纬度
-(void)GeocodingWithAddress:(NSString *)address{
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
    request.address = address;
    [_search AMapGeocodeSearch:request];
}

#pragma mark --地址编码回调
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count > 0) {
        AMapGeoPoint *point = response.geocodes[0].location;
        NSLog(@"----%lf====%lf",point.longitude,point.latitude);
        CLLocationCoordinate2D coor;
        coor.latitude = point.latitude;
        coor.longitude = point.longitude;
        [self addAnomationWithCoor:coor];
        _mapView.centerCoordinate = coor;
        self.endPoint = [AMapNaviPoint locationWithLatitude:point.latitude longitude:point.longitude];
    }
}
#pragma mark --选中某个大头针后回调的方法
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    //取消选中
    
    if (self.models.count == 0 || !self.models) {
    }else{
        [self.mapView deselectAnnotation:view.annotation animated:YES];
    }
    //    NSLog(@"%lf------%lf",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    distinateCoor = view.annotation.coordinate;
    YHLog(@"高德纬度%f---高德经度%f",distinateCoor.latitude,distinateCoor.longitude);
    if(![view isKindOfClass:[YHAnnotationView class]]) return;
    for (YHReservationModel *reservationM in self.reservationArr) {
        //获得服务器返回经纬度数据 调成跟高德返回数据一样的位数
        //NSRange rangelat = [reservationM.latitude rangeOfString:@"."];
        //NSString *latitudeS = [reservationM.latitude substringToIndex:rangelat.location+7];
        //NSRange rangeLong = [reservationM.longitude rangeOfString:@"."];
        //NSString *longitudeS = [reservationM.longitude substringToIndex:rangeLong.location+7];
        
        //将高德地图返回的经纬度 转化成字符串 与后台返回经纬度进行字符串匹配就可以了,就不会因为 floatValue而出现精度的问题
        //NSString *latitudeGD = [NSString stringWithFormat:@"%f",distinateCoor.latitude];
        //NSString *longitudeGD = [NSString stringWithFormat:@"%f",distinateCoor.longitude];
        //        YHLog(@"latitudeS=%@ --latitudeGD=%@ --longitudeS=%@ --longitudeGD=%@",latitudeS,latitudeGD,longitudeS,longitudeGD);
        
        YHAnnotationView *selectView = (YHAnnotationView *)view;
        if([selectView.ID isEqualToString:reservationM.ID]){
        //if ([latitudeGD isEqualToString:latitudeS] && [longitudeGD isEqualToString:longitudeS]) {
            //获得大头针的那个模型
            YHLog(@"点击的大头针模型---reservationM=%@  ----%@----%@",reservationM,reservationM.name,reservationM.tel);
            
            //modal出一个控制器出来就好了;
//            self.ReservationVC = [[YHReservationVC alloc]initWithShowFrame:CGRectMake(0, SCREEN_H-217, SCREEN_W, 217) ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(id callback) {
//
//                [self.ReservationVC dismissViewControllerAnimated:YES completion:nil];
//                //                    YHNewReservationVC *newResVC = [[YHNewReservationVC alloc]initWithNibName:@"YHNewReservationVC" bundle:nil];
//                //                    newResVC.reservationM = reservationM;  //跳转过去的时候将对应的模型数据传入
//                //                    [self.controller.navigationController pushViewController:newResVC animated:YES];
//            }];
//            _ReservationVC.reservationM = reservationM;
//            _ReservationVC.delegate = self;
//            [self.controller presentViewController:_ReservationVC animated:YES completion:nil];
            
            [YHMapSheetView showAnnotation:reservationM].didSelectBlock = ^(YHReservationModel *reservationM) {
                //        YHNewReservationVC *newResVC = [[UIStoryboard storyboardWithName:@"AMap" bundle:nil] instantiateViewControllerWithIdentifier:@"YHNewReservationVC"];
                //        newResVC.reservationM = reservationM;  //跳转过去的时候将对应的模型数据传入
                YHReservationNewVC *newResVC = [YHReservationNewVC new];
                newResVC.reservationM = reservationM;
                [self.controller.navigationController pushViewController:newResVC animated:YES];
            };
            
            break;
            //有时可以dissmiss,有时不可以diss 这个是因为大头针有多个,如果点击弹出那个控制器的时候会有多个相同的经度,或者纬度那么这个方法就会去进行多次调用,那么再点击那个dismiss的时候就会出现有时候弹出来的情况,   调试的时候注意结合界面进行代码调试同时注意查看控制台返回相关异常的信息,定位到问题点所在;
        }
    }
}

#pragma mark --步行导航代理方法
-(void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    [walkManager startGPSNavi];
}
#pragma mark --关闭导航的方法
-(void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView{
    self.controller.navigationController.navigationBar.hidden = NO;
    [self.walkManager stopNavi];
    [walkView removeFromSuperview];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

#pragma mark --行车导航回调
-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    [self initMoreMenu];
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [self.driveManager addDataRepresentative:self.driveView];
    [driveManager startGPSNavi];
}
-(void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    self.controller.navigationController.navigationBar.hidden = NO;
    [self.driveManager stopNavi];
        [driveView removeFromSuperview];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
//    [self.controller.navigationController popViewControllerAnimated:YES];
}
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    //配置MoreMenu状态
    [self.moreMenu setTrackingMode:self.driveView.trackingMode];
    [self.moreMenu setShowNightType:self.driveView.showStandardNightType];
    
    [self.moreMenu setFrame:self.controller.view.bounds];
    [self.controller.view addSubview:self.moreMenu];
}
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeNormal];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];
    }
}
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}
#pragma mark --周边搜索方法
-(void)searchAroundWithKeyWords:(NSString *)keywords{
    if (_currentLocation==nil||_search==nil) {
        NSLog(@"location = %@---search=%@",_currentLocation,_search);
        NSLog(@"搜索失败,定位或搜索对象未初始化");
        return;
    }
    
    AMapPOIAroundSearchRequest  *request=[[AMapPOIAroundSearchRequest alloc] init];
    //设置搜索范围，以显示在地图上
    request.radius = 10000;
    request.location=[AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.keywords = keywords;
    [_search AMapPOIAroundSearch:request];
}
#pragma mark 周边搜索回调
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (response.pois.count>0) {
        
        self.searchResultArr = [response.pois mutableCopy];
        //        NSLog(@"%@",self.dataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setupPointAnotation:self.searchResultArr];
            
        });
    }else{
        NSLog(@"搜索失败，附近暂无搜索内容");
    }
}
#pragma mark --构造折线数据对象
-(void)drawLineWithArray:(NSArray *)array{
    //    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[array.count];
    for (int i = 0; i<array.count; i++) {
        NSString *location = array[i];
        commonPolylineCoords[i].latitude = [location substringToIndex:9].floatValue;
        commonPolylineCoords[i].longitude = [location substringFromIndex:10].floatValue;
    }
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    //将地图的中心点设为固定的点
    _mapView.centerCoordinate = commonPolylineCoords[array.count/2];
    
}
#pragma mark --标记转折点的位置(轨迹回放)
-(void)addAnomationWithArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        CLLocationCoordinate2D coor;
        coor.latitude = [array[i] substringToIndex:9].floatValue;
        coor.longitude = [array[i] substringFromIndex:10].floatValue;
        MAPointAnnotation *coorPoint = [[MAPointAnnotation alloc]init];
        coorPoint.coordinate = coor;
        coorPoint.title = [NSString stringWithFormat:@"位置%d",i+1];
        [self.mapView addAnnotation:coorPoint];
    }
}
#pragma mark --设置折线代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 12.f;
        //设置轨迹颜色
        //        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        //将轨迹设置为自定义的样式
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"map_history"]];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark --搜索附近成功后设置大头针
-(void)setupPointAnotation:(NSMutableArray *)array{
    [_mapView setZoomLevel:13.1 animated:YES];
    for (int i = 0; i < array.count; i++) {
        CLLocationCoordinate2D coor;
        AMapPOI *poi = self.searchResultArr[i];
        coor.latitude = poi.location.latitude;
        coor.longitude = poi.location.longitude;
        MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
        point.coordinate = coor;
        point.title = poi.name;
        [self.mapView addAnnotation:point];
    }
    //把中心点设成自己的坐标
    self.mapView.centerCoordinate = self.currentLocation.coordinate;
}
#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked
{
    [self.moreMenu removeFromSuperview];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType
{
    [self.driveView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode
{
    [self.driveView setTrackingMode:trackingMode];
}

@end
