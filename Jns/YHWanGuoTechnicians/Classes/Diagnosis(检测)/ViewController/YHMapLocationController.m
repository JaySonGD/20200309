//
//  YHMapLocationController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHMapLocationController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YHCommon.h"
#import "UIColor+ColorChange.h"
#import "YSLCustomButton.h"
@interface YHMapLocationController ()
//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
//地图
@property (nonatomic, strong) MAMapView *mapView;
//大头针
@property (nonatomic, strong) MAPointAnnotation *annotation;
//逆地理编码
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
//逆地理编码使用的
@property (nonatomic, strong) AMapSearchAPI *search;

//地址
@property(nonatomic,strong)UITextField *textF;

@property(nonatomic,strong)YSLCustomButton *button;

@property (nonatomic, strong) UIButton *gpsButton;

@end

@implementation YHMapLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"选择地址";
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    //在viewDidLoad里面添加背景和定位功能
    //地图
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsScale = NO;
    
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 80); //设置指南针位置
    
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x -20, 80);  //设置比例尺位置
    
    [self addZoomAndLocationButton];  //添加缩放及当前位置按钮

    //定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            return ;
        }
        //添加大头针
        _annotation = [[MAPointAnnotation alloc]init];
        
        _annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [_mapView addAnnotation:_annotation];
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) animated:YES];
        //让地图在缩放过程中移到当前位置试图
        [_mapView setZoomLevel:16.1 animated:YES];
    }];
    
    [self setUpAddressUI];   //添加获取地址的UI信息
}

#pragma mark - 添加获取地址的UI
-(void)setUpAddressUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight -135, screenWidth, 135)];
    [self.view addSubview:view];
    
    self.button = [[YSLCustomButton alloc]initWithFrame:CGRectMake(15, 0, screenWidth -30, 52)];
    [view addSubview:self.button];
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.ysl_spacing = 0;
    self.button.ysl_buttonType = YSLCustomButtonImageLeft;
    self.button.layer.cornerRadius = 10;
    self.button.layer.masksToBounds = YES;
    self.button.titleLabel.numberOfLines = 0;
    self.button.layer.borderColor = [UIColor colorWithHexString:@"#E2E2E5"].CGColor;
    self.button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.layer.borderWidth = 1.0f;
    [self.button setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateSelected];
    self.button.userInteractionEnabled = NO;
    [self.button setTitle:@"正在获取定位..." forState:UIControlStateNormal];
    self.button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10,CGRectGetWidth(self.button.frame) - 30);
//    self.button.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
//    //地址
//    _textF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, screenWidth -30, 52)];
//    _textF.backgroundColor = [UIColor whiteColor];
//    _textF.placeholder = @"正在获取定位...";
//    _textF.layer.cornerRadius = 10;
//    _textF.layer.masksToBounds = YES;
//    _textF.layer.borderColor = [UIColor colorWithHexString:@"#E2E2E5"].CGColor;
//    _textF.font = [UIFont systemFontOfSize:14];
//    _textF.layer.borderWidth = 1.0f;
//    [view addSubview:_textF];
//    //文本框左视图
//    UIView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,35, 52)];
//    leftView.backgroundColor = [UIColor clearColor];
//    //添加图片
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 15, 18)];
//    imageV.image = [UIImage imageNamed:@"定位"];
//    [leftView addSubview:imageV];
//    _textF.leftView = leftView;
//    _textF.leftViewMode = UITextFieldViewModeAlways;
    
    //确定按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.button.frame)+10, screenWidth -30, 58)];
    [view addSubview:button];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.backgroundColor = YHNaviColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(selectTheCarAddress:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 选择看车地址  点击确定回传
-(void)selectTheCarAddress:(UIButton *)sender{
    if (self.addressBlock) {
        self.addressBlock(self.button.currentTitle);
    }
    if (!NULLString(self.button.currentTitle)) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"请重新获取看车地址" toView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - 添加缩放跟当前位置按钮
-(void)addZoomAndLocationButton{
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

#pragma mark - 放大控件与缩小控件方法 ---
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIdetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdetifier];
        }
        //放一张大头针图片即可
        annotationView.image = [UIImage imageNamed:@"定位"];
        annotationView.centerOffset = CGPointMake(0, 0);
        return annotationView;
    }
    
    return nil;
}

#pragma mark - 让大头针不跟着地图滑动，时时显示在地图最中间
- (void)mapViewRegionChanged:(MAMapView *)mapView {
    _annotation.coordinate = mapView.centerCoordinate;
}
#pragma mark - 滑动地图结束修改当前位置
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.regeo.location = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    [self.search AMapReGoecodeSearch:self.regeo];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *reocode = response.regeocode;
        
//        self.button.titleLabel.text = reocode.formattedAddress;
        [self.button setTitle:reocode.formattedAddress forState:UIControlStateNormal];
        //地图标注的点的位置信息全在reoceode里面了
        NSLog(@"%@", reocode.formattedAddress);
    }
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout = 2;
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

- (AMapReGeocodeSearchRequest *)regeo {
    if (!_regeo) {
        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
        _regeo.requireExtension = YES;
    }
    return _regeo;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}

@end
