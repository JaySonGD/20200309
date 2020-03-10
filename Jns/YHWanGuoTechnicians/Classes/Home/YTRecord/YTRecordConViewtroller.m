//
//  YTRecordController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 4/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRecordConViewtroller.h"

#import <MAMapKit/MAMapKit.h>


//#import "StatusVxbiew.h"
//#import "AMapRouteRecord.h"
#import "YTRouteRecord.h"

#import "YTLatLngEntity.h"

#import "YHJspathAndVersionManager.h"

#import <MJExtension.h>



@interface YTRecordConViewtroller ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *distabceLB2;
@property (nonatomic, strong) MAMapView *mapView;


//@property (nonatomic, strong) StatusView *statusView;


@property (nonatomic, assign) BOOL isRecording;
@property (atomic, assign) BOOL isSaving;

//@property (nonatomic, strong) AMapRouteRecord *currentRecord;
@property (nonatomic, strong) YTRouteRecord *recorder;
//@property (nonatomic, strong) MATraceManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *durationLB2;

@property (weak, nonatomic) IBOutlet UILabel *durationLB;
@property (weak, nonatomic) IBOutlet UILabel *speedLB2;

@property (weak, nonatomic) IBOutlet UILabel *speedLB;
@property (weak, nonatomic) IBOutlet UILabel *distanceLB;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalDuration;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIView *buttomV;
@property (weak, nonatomic) IBOutlet UIView *buttomV2;

@end

@implementation YTRecordConViewtroller

#pragma mark - MapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *annotationIdentifier = @"lcoationIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        poiAnnotationView.image = [UIImage imageNamed:@"组 8917"];
        
        return poiAnnotationView;

    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"lcoationIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        //poiAnnotationView.pinColor = MAPinAnnotationColorGreen;
        poiAnnotationView.canShowCallout = NO;
        
        NSString *imageName = [annotation.title isEqualToString:@"start"]? @"组 8906" : @"组 8907";
        poiAnnotationView.image = [UIImage imageNamed:imageName];
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (!updatingLocation) return;
    if (!self.isRecording) return;
    if (!userLocation) return;

    
    if (userLocation.location.horizontalAccuracy < 100 &&
        userLocation.location.horizontalAccuracy > 0){
        
        if (!self.recorder.endLocation) {
            [self.recorder addLocation:[[YTLatLngEntity alloc] initWithLocation:userLocation.location]];
        }else{
            
            
            CLLocation *endLocation  = self.recorder.endLocation.currentLocation;
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(endLocation.coordinate.latitude,endLocation.coordinate.longitude));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude));
            
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            
            if (distance >= 5) {

                MAPolyline *commonPolyline = [self makePolylineWith:@[endLocation,userLocation]];//[MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
                
                
                //在地图上添加折线对象
                [_mapView addOverlay: commonPolyline];
                //设置地图中心位置
                _mapView.centerCoordinate = userLocation.location.coordinate;

                
                [self.recorder addLocation:[[YTLatLngEntity alloc] initWithLocation:userLocation.location]];
                
                
//                double speed = userLocation.location.speed > 0 ? userLocation.location.speed : 0;
//                self.speedLB.text = [NSString stringWithFormat:@"%.2f", speed * 3.6];
//
//                NSInteger seconds = [self.recorder.totalDuration integerValue];
//
//                NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
//                //format of minute
//                NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
//                //format of second
//                NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
//                //format of time
//                NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
//
//
//                self.durationLB.text = format_time;
//
//                self.distanceLB.text = [NSString stringWithFormat:@"%.2f",self.recorder.totalDistance];

//                [self.statusView showStatusWith:userLocation.location];
                
//                NSLog(@"%s---%fkm/h----%fm ----%fs", __func__,userLocation.location.speed,self.recorder.totalDistance,self.recorder.totalDuration);
            }
        }
        

    }
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *view = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        view.lineWidth = 10.0;
        view.strokeColor = [UIColor colorWithHexString:@"#77A3FF"];
        view.lineCapType = kMALineCapRound;
        view.lineJoinType = kMALineJoinRound;
        return view;
    }
    
    return nil;
}

#pragma mark - Handle Action

- (IBAction)actionRecordAndStop:(UIButton *)sender
{
    if (self.isSaving) return;
    //[self test];return;
    
    if (!self.mapView.userLocation) return;
    
    sender.selected = !sender.selected;

    self.isRecording = !self.isRecording;
    
    if (self.isRecording)
    {
        
        if (self.recorder == nil)
        {
            self.recorder = [[YTRouteRecord alloc] init];
        }
        
        [self setBackgroundModeEnable:YES];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        
       
        [self.recorder addLocation: [[YTLatLngEntity alloc] initWithLocation:self.mapView.userLocation.location]];
        
        MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
        
        startPoint.coordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude);
        startPoint.title = @"start";
        [self.mapView addAnnotation:startPoint];
        
        [self timer];
        self.totalDuration = 0;
        
    }
    else
    {
        
        [self.timer invalidate];
        self.timer = nil;
        self.totalDuration = 0;
        
        [self setBackgroundModeEnable:NO];
        
        
        MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
        endPoint.coordinate = CLLocationCoordinate2DMake(self.recorder.endLocation.currentLocation.coordinate.latitude, self.recorder.endLocation.currentLocation.coordinate.longitude);
        endPoint.title = @"end";
        [self.mapView addAnnotation:endPoint];
        
        [self actionSave];

        
    }
}

- (void)actionSave
{
    
    if (self.recorder.locations.count < 2) {
        [MBProgressHUD showError:@"路线太短！"];
        self.isRecording = NO;
        self.isSaving = NO;
        self.recorder = nil;
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];

    NSArray<YTLatLngEntity *>*locations = [self douglasAlgorithm:self.recorder.locations threshold:5];
    
    
//    startTime    是    string    开始时间
//    usedTime    是    string    总时长（秒数）， 单位-秒
//    miles    是    string    总路程
//    pointList    是    List    跑步点
//    —lng    是    String    经度
//    —lat    是    String    纬度
//    —pointTime
    NSDictionary *par = @{
                          @"startTime" : self.recorder.sTime,
                          @"usedTime" : self.recorder.totalDuration,
                          @"miles" : self.recorder.totalDistance,
                          @"pointList" : [NSArray mj_keyValuesArrayWithObjectArray:locations]
                          };
    
    [[YHJspathAndVersionManager sharedYHJspathAndVersionManager] qualityInputBytoken:self.accessToken parameters:par onComplete:^(NSDictionary *info) {
        NSInteger retCode = [[info valueForKey:@"code"] integerValue];
        [MBProgressHUD hideHUDForView:self.view];
        self.isSaving = NO;

        if (retCode == 1000) {
            [MBProgressHUD showError:@"提交成功"];
            return ;
        }
            
        [MBProgressHUD showError:info[@"message"]];

    } onError:^(NSError *error) {
      NSLog(@"%s", __func__);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedFailureReason];
        self.isSaving = NO;

    }];
    
    
    self.isRecording = NO;
    self.isSaving = YES;
    self.recorder = nil;

    ///
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.mapView removeAnnotations:self.mapView.annotations];
//        [self.mapView removeOverlays:self.mapView.overlays];
//        [self writeOverlay:locations];
//    });
  

}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone];
    }
    else
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
    }
}


#pragma mark - Utility

- (void)setBackgroundModeEnable:(BOOL)enable
{
    self.mapView.pausesLocationUpdatesAutomatically = !enable;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        self.mapView.allowsBackgroundLocationUpdates = enable;
    }
}


- (void)writeOverlay:(NSArray <YTLatLngEntity *>*)list{
    if (list.count < 2) return;

    NSMutableArray *locats = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(YTLatLngEntity  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CLLocation *cl = obj.currentLocation;
        [locats addObject:cl];
    }];
    
    double maxLog = [[[list valueForKey:@"lng"] valueForKeyPath:@"@max.floatValue"] floatValue];
    double minLog = [[[list valueForKey:@"lng"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    double maxLat = [[[list valueForKey:@"lat"] valueForKeyPath:@"@max.floatValue"] floatValue];
    double minLat = [[[list valueForKey:@"lat"] valueForKeyPath:@"@min.floatValue"] floatValue];
    double longitude = (maxLog+minLog)*0.5;
    double latitude = (maxLat+minLat)*0.5;

    
    MAPolyline *commonPolyline = [self makePolylineWith:locats];
    
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    //设置地图中心位置
    _mapView.centerCoordinate = center.coordinate;
    
    _mapView.region = MACoordinateRegionMake( center.coordinate, MACoordinateSpanMake((maxLat - minLat) * 1.2, (maxLog - minLog)*1.2));
    
    
    MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
    endPoint.coordinate = CLLocationCoordinate2DMake(list.lastObject.currentLocation.coordinate.latitude, list.lastObject.currentLocation.coordinate.longitude);
    endPoint.title = @"end";
    [self.mapView addAnnotation:endPoint];

    
    MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
    
    startPoint.coordinate = CLLocationCoordinate2DMake(list.firstObject.currentLocation.coordinate.latitude,list.firstObject.currentLocation.coordinate.longitude);
    startPoint.title = @"start";
    [self.mapView addAnnotation:startPoint];

}

- (MAPolyline *)makePolylineWith:(NSArray <CLLocation *>*)tracePoints
{
    if(tracePoints.count < 2)
    {
        return nil;
    }
    
    NSInteger count = tracePoints.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    
    for (NSInteger i = 0; i < count; i ++) {
        CLLocation  *location = tracePoints[i];
        commonPolylineCoords[i].latitude = location.coordinate.latitude;
        
        commonPolylineCoords[i].longitude = location.coordinate.longitude;

    }
    
    
    
    //构造折线对象
    
    
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];


    return commonPolyline;
}


#pragma mark - Initialization

//- (void)initStatusView
//{
//    self.statusView = [[StatusView alloc] initWithFrame:CGRectMake(5, 35, 150, 150)];
//
//    [self.view addSubview:self.statusView];
//}


- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.zoomLevel = 16.0;
    self.mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.mapView.showsIndoorMap = NO;
    self.mapView.delegate = self;
    
    [self.view insertSubview:self.mapView atIndex:0];
   

    //self.manager = [[MATraceManager alloc] init];
}





#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"去运动"];
    
    
    [self initMapView];
    
    
//    [self initStatusView];

    
    self.buttomV2.hidden = IsEmptyStr(self.Id);
    self.buttomV.hidden = !self.buttomV2.isHidden;
    self.mapView.userTrackingMode = self.Id? MAUserTrackingModeNone : MAUserTrackingModeFollow;


}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//
//}

- (void)setId:(NSString *)Id{
    _Id = Id;
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHJspathAndVersionManager sharedYHJspathAndVersionManager] qualityDetailBytoken:self.accessToken detailId:Id onComplete:^(NSDictionary *info) {
        NSLog(@"%s", __func__);
        
        NSInteger retCode = [[info valueForKey:@"code"] integerValue];
        [MBProgressHUD hideHUDForView:self.view];

        if (retCode == 1000) {
            NSArray *pointList = [YTLatLngEntity mj_objectArrayWithKeyValuesArray:info[@"data"][@"pointList"]];
            [self writeOverlay:pointList];
            
            NSNumber *miles = info[@"data"][@"miles"];
            NSNumber *speed = info[@"data"][@"speed"];
            NSNumber *usedTime = info[@"data"][@"usedTime"];

            self.speedLB2.text = [NSString stringWithFormat:@"%.2f", speed.doubleValue];
            
            NSInteger seconds = usedTime.integerValue;
            
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
            //format of minute
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
            //format of second
            NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
            //format of time
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            
            
            self.durationLB2.text = format_time;
            
            self.distabceLB2.text = [NSString stringWithFormat:@"%.2f",miles.doubleValue];
            return ;

        }
        
        [MBProgressHUD showError:info[@"message"]];

        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedFailureReason];
    }];
}

/**
 * 道格拉斯算法，处理coordinateList序列
 * 先将首末两点加入points序列中，然后在coordinateList序列找出距离首末点连线距离的最大距离值dmax并与阈值threshold进行比较，
 * 若大于阈值则将这个点加入points序列，重新遍历points序列。否则将两点间的所有点(coordinateList)移除
 * LatLngEntity是经纬度model
 * @return 返回经过道格拉斯算法后得到的点的序列
 */
- (NSArray<YTLatLngEntity *>*)douglasAlgorithm:(NSArray <YTLatLngEntity *>*)coordinateList
                                     threshold:(CGFloat)threshold{
    // 将首末两点加入到序列中
    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *list = [NSMutableArray arrayWithArray:coordinateList];
    
    [points addObject:list[0]];
    [points addObject:coordinateList[coordinateList.count - 1]];
    
    for (NSInteger i = 0; i<points.count - 1; i++)
    {
        NSUInteger start = (NSUInteger)[list indexOfObject:points[i]];
        NSUInteger end = (NSUInteger)[list indexOfObject:points[i+1]];
        if ((end - start) == 1)
        {//起始点之间没有其他点 直接跳过
            continue;
        }
        NSArray *values = [self getMaxDistance:list startIndex:start endIndex:end threshold:threshold];
        CGFloat maxDist = [values[0] floatValue];
        
        //大于阈值 将点加入到points数组
        if (maxDist >= threshold)
        {
            NSInteger position = [values[1] integerValue];
            [points insertObject:list[position] atIndex:i+1];
            // 将循环变量i初始化,即重新遍历points序列
            i = -1;
        }else
        {//将两点间的点全部删除
            NSInteger removePosition = start + 1;
            for (NSInteger j = 0; j < end - start - 1; j++)
            {
                [list removeObjectAtIndex:removePosition];
            }
        }
    }
    return points;
}

/**
 * 根据给定的始末点，计算出距离始末点直线的最远距离和点在coordinateList列表中的位置
 * @param startIndex 遍历coordinateList起始点
 * @param endIndex 遍历coordinateList终点
 * @return maxDistance 返回最大距离 position 在原始数组中位置
 */
- (NSArray <YTLatLngEntity *>*)getMaxDistance:(NSArray <YTLatLngEntity *>*)coordinateList
                                   startIndex:(NSInteger)startIndex
                                     endIndex:(NSInteger)endIndex
                                    threshold:(CGFloat)threshold{
    CGFloat maxDistance = -1;
    NSInteger position = -1;
    CGFloat distance = [self getDistance:coordinateList[startIndex] lastEntity:coordinateList[endIndex]];//首末两点的距离
    
    for(NSInteger i = startIndex; i < endIndex; i++)
    {
        CGFloat firstSide = [self getDistance:coordinateList[startIndex] lastEntity:coordinateList[i]];//中间点距离起点的距离
        if(firstSide < threshold)
        {//斜边小于阈值 直角边即这个点距离首尾连线的距离肯定小于阈值 直接跳过这个点 省去了后面的运算
            continue;
        }
        
        CGFloat lastSide = [self getDistance:coordinateList[endIndex] lastEntity:coordinateList[i]];
        if(lastSide < threshold)
        {//斜边小于阈值 直角边即这个点距离首尾连线的距离肯定小于阈值 直接跳过这个点 省去了后面的运算
            continue;
        }
        
        // 使用海伦公式求距离
        CGFloat p = (distance + firstSide + lastSide) / 2.0;
        CGFloat dis = sqrt(p * (p - distance) * (p - firstSide) * (p - lastSide)) / distance * 2;
        
        if(dis > maxDistance)
        {
            maxDistance = dis;
            position = i;
        }
    }
    return @[@(maxDistance),@(position)];
}

// 两点间距离公式
- (CGFloat)getDistance:(YTLatLngEntity*)firstEntity lastEntity:(YTLatLngEntity*)lastEntity{
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:[firstEntity.lat doubleValue] longitude:[firstEntity.lng doubleValue]];
    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:[lastEntity.lat doubleValue] longitude:[lastEntity.lng doubleValue]];
    
    CGFloat  distance  = [firstLocation distanceFromLocation:lastLocation];
    return  distance;
}


- (NSTimer *)timer{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    
    return _timer;
}

- (void)update{
    
    self.totalDuration += 1;
    
    MAUserLocation *userLocation  = self.mapView.userLocation;
    double  totalDistance = self.recorder.totalDistance.doubleValue  + [self.recorder.endLocation.currentLocation distanceFromLocation:userLocation.location];

    
    double speed = userLocation.location.speed > 0 ? userLocation.location.speed : 0;
    self.speedLB.text = [NSString stringWithFormat:@"%.2f", speed * 3.6];
    
    NSInteger seconds = self.totalDuration;
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    
    self.durationLB.text = format_time;
    
    self.distanceLB.text = [NSString stringWithFormat:@"%.2f",totalDistance];
    
//    [self.statusView showStatusWith:userLocation.location];
    
    NSLog(@"%s---%fkm/h----%fm ----%fs", __func__,userLocation.location.speed,self.recorder.totalDistance,self.recorder.totalDuration);
}
@end
