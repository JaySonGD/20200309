//
//  CameraViewController.m
//

#import "SmartOCRCameraViewController.h"
#import "SmartOCROverView.h"
#import "DataSourceReader.h"
#import "MainType.h"
#import "SubType.h"
#import "ListTableViewCell.h"

// 后添加
#import "ResultTableViewCell.h"
#import "YHNewOrderController.h"
#import "YHCommon.h"
#import "UIImage+info.h"
#import "YHNetworkWeiXinManager.h"
#import "YHTools.h"
#import "UIImage+Rotate.h"
#import "GTMBase64.h"

#import <CoreMotion/CoreMotion.h>


//#import "ResultViewController.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import "SmartOCR.h"
#endif

@interface SmartOCRCameraViewController ()<UIAlertViewDelegate>

{
    SmartOCROverView *_overView;//预览界面覆盖层,显示是否找到边
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    SmartOCR *_ocr;//核心
#endif
    
    UIView *_takePicView; //拍照视图
    UIButton *_takePicBtn;//拍照按钮
    UILabel *_takePicLabel;//拍照标签

    BOOL _isTakePicBtnClick;//是否点击拍照按钮
    BOOL _on;//闪光灯是否打开
    float _isIOS8AndFoucePixelLensPosition;//相位聚焦下镜头位置
    BOOL _isFoucePixel;//是否开启对焦
    BOOL _isChangedType;//切换识别类型
    
    // 后添加的
    int _currentRecogType;//当前识别的子类型
    
    int _maxCount;//找边最大次数
    int _pixelLensCount;//镜头位置稳定的次数
    float _aLensPosition;//默认镜头位置
    BOOL _drivingLicense;//是否是行驶证识别
    BOOL _isRecoging;//是否正在识别
}

@property (assign, nonatomic) BOOL adjustingFocus;//是否正在对焦

//当前类型的子类型
@property (strong, nonatomic) NSMutableArray *subTypes;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) CGRect overSmallRect;

//返回按钮
@property (nonatomic, strong) UIButton *backBtn;

//中部标题
@property (nonatomic, strong) UILabel *middleLabel;

//手动输入按钮
@property (nonatomic, strong) UIButton *autoInputBtn;

//闪光灯按钮
@property (nonatomic, strong) UIButton *flashBtn;
/** 底部关闭按钮 */
@property (nonatomic, strong) UIButton *bottomCloseBtn;

/** 提示语 */
@property (nonatomic, strong) UILabel *promptLOne;

/** 提示语 */
@property (nonatomic, strong) UILabel *promptLTwo;

//拍照按钮
@property (nonatomic, strong) UIButton *ensureBtn;

//头是否向左
@property (nonatomic, assign) BOOL isLeft;

//扫描区域图片
@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger signCode;

@end

@implementation SmartOCRCameraViewController

#pragma mark - ---------------------------1.视图加载完成-----------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    _isTakePicBtnClick = NO;
    
    self.signCode = 0;

    //1.监听横竖屏
    [self initNot];
    
    //2.初始化识别
    [self createScanVinView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
}

- (void)action:(NSTimer *)timer
{
    if (self.signCode < 3) {
        self.signCode += 1;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        _isTakePicBtnClick = YES;
    }
}

#pragma mark - ---------------------------2.视图即将出现-----------------------------
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    
    //如果已经对焦
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    
    [self.session startRunning];
}

#pragma mark - ---------------------------3.视图即将消失-----------------------------
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //移除聚焦监听
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    
    //如果已经对焦
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    [self.session stopRunning];
    
    [self.timer invalidate];
    self.timer = nil;
    _isTakePicBtnClick = NO;
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}

#pragma mark - ---------------------------4.视图已经消失-----------------------------
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - ---------------------------2.屏幕旋转检测-----------------------------
- (void)initNot
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        //改变朝向
        self.recogOrientation = RecogInVerticalScreen;

        //设置检边参数
        [self setROI];

        //创建相机界面
        [self rotateViewWithOrientation];
        
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        //改变朝向
        self.recogOrientation = RecogInHorizontalScreen;
        
        self.isLeft = YES;
        
        //设置检边参数
        [self setROI];
        
        //创建相机界面
        [self rotateViewWithOrientation];
        
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        //改变朝向
        self.recogOrientation = RecogInHorizontalScreen;

        self.isLeft = NO;

        //设置检边参数
        [self setROI];

        //创建相机界面
        [self rotateViewWithOrientation];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        

    }
}

#pragma mark - ---------------------------1.初始化识别-----------------------------
- (void)createScanVinView
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    self.view.backgroundColor = [UIColor clearColor];
    
    //1.初始化相机
    [self initialize];
    
    //2.初始化识别核心
    [self initOCRSource];
    
#endif
    //3.创建相机界面控件
//    [self createCameraView];
    [self initOrigionView];
}

- (void)initOrigionView{
    
    [self setOverViewRegion];
    
    [self createCameraView];
}
#pragma mark - -----------------------1.初始化识别核心-----------------------
- (void) initialize
{
    //判断摄像头授权
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"allowCamare", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alt show];
        return;
    }
    
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    
    //设置图片品质，此分辨率为最佳识别分辨率，建议不要改动
    [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if (device.position == AVCaptureDevicePositionBack){
            self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            self.device = device;
        }
    }
    [self.session addInput:self.captureInput];
    
    //创建、配置预览输出设备
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.session addOutput:captureOutput];
    
    //3.创建、配置输出
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.captureOutput];
    
    //设置预览
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.preview setAffineTransform:CGAffineTransformMakeScale(kFocalScale, kFocalScale)];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preview];
    
    //5.设置视频流和预览图层方向
    for (AVCaptureConnection *connection in captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                self.videoConnection = connection;
                break;
            }
        }
        if (self.videoConnection) { break; }
    }
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    //判断对焦方式
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = self.device.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFoucePixel = YES;
        }
    }
}

#pragma mark - -----------------------2.初始化识别核心-----------------------
- (void) initOCRSource
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    
    NSDate *before = [NSDate date];
    
    _ocr = [[SmartOCR alloc] init];
    int init = [_ocr initOcrEngineWithDevcode:kDevcode];
    NSLog(@"初始化返回值 = %d 核心版本号 = %@", init, [_ocr getVersionNumber]);
    
    //添加主模板
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"SZHY" ofType:@"xml"];
    int addTemplate = [_ocr addTemplateFile:templateFilePath];
    NSLog(@"添加主模板返回值 = %d", addTemplate);
    
    //设置子模板
    self.listDataSource = [DataSourceReader getMainTypeDataSource];
    MainType *mainType = self.listDataSource[0];
    self.subTypes = [DataSourceReader getSubTypeDataSource:mainType.type];
    SubType *subtype = self.subTypes[0];
    int currentTemplate = [_ocr setCurrentTemplate:subtype.OCRId];
    NSLog(@"设置当前模板返回值 =%d",currentTemplate);
    
    //设置检边参数
    [self setROI];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:before];
    NSLog(@"time：%f", time);
#endif
}

//设置检边参数
- (void)setROI
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    //设置识别区域
    CGRect rect = [self setOverViewSmallRect];
//    NSLog(@"=============1.rect:%f===============",rect);

    CGFloat tWidth = (kFocalScale-1)*kScreenWidth*0.5;
    CGFloat tHeight = (kFocalScale-1)*kScreenHeight*0.5;
    NSLog(@"=============1.tWidth:%f===tHeight:%f============",tWidth,tHeight);

    //previewLayer上点坐标
    CGPoint pLTopPoint = CGPointMake((CGRectGetMinX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);
    CGPoint pRDownPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMaxY(rect)+tHeight)/kFocalScale);
    CGPoint pRTopPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);
    //NSLog(@"=============2.tWidth:%f===tHeight:%f===pRTopPoint:%f============",pLTopPoint,pRDownPoint,pRTopPoint);

    //真实图片点坐标
    CGPoint iLTopPoint = [self.preview captureDevicePointOfInterestForPoint:pRTopPoint];
    CGPoint iLDownPoint = [self.preview captureDevicePointOfInterestForPoint:pLTopPoint];
    CGPoint iRTopPoint = [self.preview captureDevicePointOfInterestForPoint:pRDownPoint];
    
    /*
     计算roi、
     AVCaptureVideoOrientationLandscapeRight
     AVCaptureSessionPreset1920x1080
     */
    
    int sTop,sBottom,sLeft,sRight;
    if (self.recogOrientation == RecogInHorizontalScreen) {
        //横屏识别计算ROI
        sTop = iLTopPoint.y*kResolutionHeight;
        sBottom = iLDownPoint.y*kResolutionHeight;
        sLeft = iLTopPoint.x*kResolutionWidth;
        sRight = iRTopPoint.x*kResolutionWidth;
    }else{
        //竖屏识别计算ROI
        sTop = iLTopPoint.x*kResolutionWidth;
        sBottom = iRTopPoint.x*kResolutionWidth;
        sLeft = (1-iLDownPoint.y)*kResolutionHeight;
        sRight = (1-iLTopPoint.y)*kResolutionHeight;
    }
    
    [_ocr setROIWithLeft:sLeft Top:sTop Right:sRight Bottom:sBottom];
    NSLog(@"<<<=============t=%d b=%d l=%d r=%d===============>>>",sTop,sBottom,sLeft,sRight);
#endif
}

#pragma mark - 设置检边区域的frmae
- (CGRect )setOverViewSmallRect
{
    /*
     sRect 为检边框的frame，用户可以自定义设置
     以下是demo对检边框frame的设置，仅供参考.
     */
    CGFloat safeWidth = kScreenHeight-kSafeTopNoNavHeight-kSafeBottomHeight-100;//100为底部UITableView高度
    CGRect sRect = CGRectZero;
    
    //横屏
    if (self.recogOrientation == RecogInHorizontalScreen) {
        
        CGFloat cardScale = 5;
        CGFloat tempScale = 0.8;
        
        //横屏识别设置检边框frame
        CGFloat tempHeight = safeWidth*tempScale;
        CGFloat tempWidth = tempHeight/cardScale;
        
//        sRect = CGRectMake((kScreenWidth-tempWidth)*0.5, (safeWidth-tempHeight)*0.5+kSafeTopNoNavHeight, tempWidth,tempHeight);
         sRect = CGRectMake((kScreenWidth-tempWidth)*0.5, (kScreenHeight - tempHeight)*0.5, tempWidth,tempHeight);
    
    //竖屏
    }else{
        CGFloat cardScale = 4.5;
        CGFloat tempScale = 0.9;
        
        //竖屏识别设置检边框frame
        CGFloat tempWidth = kScreenWidth*tempScale;
        CGFloat tempHeight = tempWidth/cardScale;
        sRect = CGRectMake((kScreenWidth-tempWidth)*0.5, (safeWidth-tempHeight)*0.5+kSafeTopNoNavHeight, tempWidth,tempHeight);
    }
    return sRect;
}

- (void)setOverViewRegion{
    
    //设置检边视图层
    _overView = [[SmartOCROverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overView.backgroundColor = [UIColor clearColor];
    _overSmallRect = [self setOverViewSmallRect];// 中间扫描区域的rect
    [_overView setSmallrect:_overSmallRect];
    [self.view addSubview:_overView];
    
    [self productShapeLayer];
    //设置覆盖层
    [self drawShapeLayer];
}

#pragma mark - 屏幕旋转view布局 ----
- (void)rotateViewWithOrientation{
    
    // 重置中间扫描区域
    _overSmallRect = [self setOverViewSmallRect];
    [_overView setSmallrect:_overSmallRect];
    //设置覆盖层
    [self productShapeLayer];
    
    CGFloat flashBtnW = 50;
    CGFloat flashBtnH = 50;
    
    CGFloat bottomBtnW = 50;
    CGFloat bottomBtnH = 50;
    
    //竖屏
    if (self.recogOrientation == RecogInVerticalScreen) {
        
        
    //        //1.返回按钮
    //        _backBtn.frame = CGRectMake(20, 20, 30, 30);
    //        _backBtn.transform = CGAffineTransformMakeRotation(0);
    
    //2.中部标题
    //        _middleLabel.frame = CGRectMake((screenWidth-150)/2, 20, 150, 30);
    //        _middleLabel.transform = CGAffineTransformMakeRotation(0);
    
    //3.手动输入按钮
    //        _autoInputBtn.frame = CGRectMake(screenWidth-90, 20, 80, 30);
    //        _autoInputBtn.transform = CGAffineTransformMakeRotation(0);
        
    // 4.闪光灯按钮
        _flashBtn.transform = CGAffineTransformMakeRotation(0);
        _bottomCloseBtn.transform = CGAffineTransformMakeRotation(0);
        _promptLTwo.transform = CGAffineTransformMakeRotation(0);
        _promptLOne.transform = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:0.1 animations:^{
        _flashBtn.frame = CGRectMake(screenWidth- flashBtnW -10, 20, flashBtnW, flashBtnH);
        _bottomCloseBtn.frame = CGRectMake((screenWidth - bottomBtnW)/2.0, screenHeight - bottomBtnH - 20, bottomBtnW, bottomBtnH);
        _promptLOne.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_overSmallRect) + 20 + _promptLOne.frame.size.height/2.0);
        _promptLTwo.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_promptLOne.frame) + _promptLTwo.frame.size.height/2.0 + 5.0);
    }];
        
    //        //5.拍照按钮
    //        _takePicView.frame = CGRectMake((screenWidth-150)/2, screenHeight-250, 150, 150);
    //        _takePicView.transform = CGAffineTransformMakeRotation(0);
        
        //横屏
    } else {
        if (_isLeft == YES) {
        //            // 1.返回按钮
        //            _backBtn.frame = CGRectMake(screenWidth-40, 20, 30, 30);
        //            _backBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
        //
        //            //2.中部标题
        //            _middleLabel.frame = CGRectMake(260, self.view.center.y, 250, 30);
        //            _middleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        //
        //            //3.手动输入按钮
        //            _autoInputBtn.frame = CGRectMake(345, screenHeight-100, 80, 30);
        //            _autoInputBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
            
        // 4.闪光灯按钮
            _flashBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
            _bottomCloseBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
            _promptLOne.transform = CGAffineTransformMakeRotation(M_PI/2);
            _promptLTwo.transform = CGAffineTransformMakeRotation(M_PI/2);
        [UIView animateWithDuration:0.1 animations:^{
            _flashBtn.frame = CGRectMake(screenWidth - flashBtnW -20 , screenHeight- flashBtnH -10, flashBtnW, flashBtnH);
           _bottomCloseBtn.frame = CGRectMake( 20 , (screenHeight- bottomBtnW)/2.0, bottomBtnW, bottomBtnH);
            _promptLOne.center = CGPointMake(_overSmallRect.origin.x- 20 - _promptLOne.frame.size.width/2.0, self.view.center.y);
            _promptLTwo.center = CGPointMake(CGRectGetMinX(_promptLOne.frame) - _promptLTwo.frame.size.width/2.0 - 5.0, self.view.center.y);
        }];
            
        //     // 5.拍照按钮
        //      _takePicView.frame = CGRectMake(20, self.view.center.y-50, 150, 150);
        //      _takePicView.transform = CGAffineTransformMakeRotation(M_PI/2);
            
        } else if (_isLeft == NO) {
        //1.返回按钮
        //      _backBtn.frame = CGRectMake(20, screenHeight-40, 30, 30);
        //      _backBtn.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        //2.中部标题
        //     _middleLabel.frame = CGRectMake(-90, self.view.center.y, 250, 30);
        //     _middleLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        //3.手动输入按钮
        //     _autoInputBtn.frame = CGRectMake(-10, 50, 80, 30);
        //     _autoInputBtn.transform = CGAffineTransformMakeRotation(-M_PI/2);
        //
        // 4.闪光灯按钮
            _flashBtn.transform = CGAffineTransformMakeRotation(-M_PI/2);
            _bottomCloseBtn.transform = CGAffineTransformMakeRotation(-M_PI/2);
            _promptLOne.transform = CGAffineTransformMakeRotation(-M_PI/2);
            _promptLTwo.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [UIView animateWithDuration:0.1 animations:^{
            _flashBtn.frame = CGRectMake(20, 10, flashBtnW, flashBtnH);
           _bottomCloseBtn.frame = CGRectMake(screenWidth - bottomBtnW - 20 , (screenHeight- bottomBtnH)/2.0, bottomBtnW, bottomBtnH);
            _promptLOne.center = CGPointMake(CGRectGetMaxX(_overSmallRect) + _promptLOne.frame.size.width/2.0 + 20, self.view.center.y);
            _promptLTwo.center = CGPointMake(CGRectGetMaxX(_promptLOne.frame) + _promptLTwo.frame.size.width/2.0 + 5.0, self.view.center.y);
        }];
        
        //        // 5.拍照按钮
        //        _takePicView.frame = CGRectMake(screenWidth - 170, self.view.center.y-50, 150, 150);
        //        _takePicView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        } else {
            
        }
    }
    
    self.resultDataSource = [NSMutableArray array];
    self.fieldDataSource = [NSMutableArray array];
    self.imagePaths = [NSMutableArray array];
    for (SubType *subtype in self.subTypes) {
        [self.resultDataSource addObject:@""];
        [self.fieldDataSource addObject:subtype.name];
        [self.imagePaths addObject:@""];
    }
    
}

#pragma mark - ------------------------3.创建相机界面--------------------------
- (void)createCameraView
{
    //1.返回按钮
//    _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    //_backBtn.frame = CGRectMake(20, 20, 30, 30);
    //_backBtn.backgroundColor = [UIColor orangeColor];
//    [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    _backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
    
    //2.显示当前识别类型
//    _middleLabel = [[UILabel alloc] init];
    //_middleLabel.center = CGPointMake(CGRectGetMidX(overSmallRect),CGRectGetMidY(overSmallRect));
    //_middleLabel.frame = CGRectMake((screenWidth-150)/2, 20, 150, 30);
    //_middleLabel.backgroundColor = [UIColor orangeColor];
//    _middleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//    _middleLabel.textAlignment = NSTextAlignmentCenter;
//    _middleLabel.font = [UIFont boldSystemFontOfSize:20.f];
//    SubType *subtype = self.subTypes[0];
//    _middleLabel.text = [NSString stringWithFormat:@"请扫描%@", subtype.name];
//    [self.view addSubview:_middleLabel];
    
    //3.手动输入
//    _autoInputBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    //_autoInputBtn.frame = CGRectMake(screenWidth-90, 20, 80, 30);
    //_autoInputBtn.backgroundColor = [UIColor orangeColor];
//    _autoInputBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_autoInputBtn setTitle:@"手动输入" forState:UIControlStateNormal];
//    [_autoInputBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
//    [_autoInputBtn addTarget:self action:@selector(autoInputBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_autoInputBtn];
    
    //4.闪光灯按钮
    _flashBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    //_flashBtn.frame = CGRectMake(80, screenHeight-200, 50, 50);
    [_flashBtn setImage:[UIImage imageNamed:@"icon_CloseLamp"] forState:UIControlStateNormal];
    [_flashBtn addTarget:self action:@selector(flashBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashBtn];
    
    //5.添加拍照按钮
//    _takePicView = [[UIView alloc]init];
//    _takePicView.frame = CGRectMake((screenWidth-150)/2, screenHeight-250, 150, 150);
//    //_takePicView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:_takePicView];
//
//    _takePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _takePicBtn.frame = CGRectMake(0, 0, _takePicView.frame.size.width, _takePicView.frame.size.height);
//    [_takePicBtn setImage:[UIImage imageNamed:@"icon_UnTakePhoto"] forState:UIControlStateNormal];
//    [_takePicBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [_takePicView addSubview:_takePicBtn];
//
//    _takePicLabel = [[UILabel alloc]init];
//    _takePicLabel.frame = CGRectMake(0, 0, _takePicView.frame.size.width, _takePicView.frame.size.height);
//    _takePicLabel.text = @"开始\n扫描";
//    _takePicLabel.textColor = YHNaviColor;
//    _takePicLabel.numberOfLines = 0;
//    _takePicLabel.font = [UIFont systemFontOfSize:15];
//    _takePicLabel.textAlignment = NSTextAlignmentCenter;
//    [_takePicView addSubview:_takePicLabel];
//
//    if (self.signCode < 3) {
//        _takePicView.hidden = YES;
//    }
    
    // 5.底部关闭按钮
    _bottomCloseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_bottomCloseBtn setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
    [_bottomCloseBtn addTarget:self action:@selector(colseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomCloseBtn];
    
    // 提示语
    _promptLOne = [[UILabel alloc] initWithFrame:CGRectZero];
    _promptLOne.font = [UIFont systemFontOfSize:16.0];
    _promptLOne.textColor = [UIColor colorWithRed:122/255.0 green:124/255.0 blue:125/255.0 alpha:1.0];
    _promptLOne.text = @"避开车窗反光与调整识别环境";
    [_promptLOne sizeToFit];
    [self.view addSubview:_promptLOne];
    
    _promptLTwo = [[UILabel alloc] initWithFrame:CGRectZero];
    _promptLTwo.font = [UIFont systemFontOfSize:16.0];
    _promptLTwo.textColor = [UIColor colorWithRed:122/255.0 green:124/255.0 blue:125/255.0 alpha:1.0];
    _promptLTwo.text = @"能提高识别效率";
    [_promptLTwo sizeToFit];
    [self.view addSubview:_promptLTwo];
    
    [self rotateViewWithOrientation];
    
}
#pragma mark - 底部关闭按钮 ---
- (void)colseViewController:(UIButton *)bottomCloseBtn{
    
    _preController.isPushByOrderList = NO;
    [self.webController pushVin:@"" image:@""];
    _isTakePicBtnClick = NO;
    
    if (!self.navigationController) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 手动输入返回
-(void)autoInputBtn:(UIButton *)btn
{
    if (_webController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.webController pushVin:@"" image:@""];
    }else{
        _preController.isPushByOrderList = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 重绘透明部分
- (void)drawShapeLayer
{
    [self.view.layer addSublayer:self.maskWithHole];
    [self.view.layer setMasksToBounds:YES];
}
#pragma mark - 重新设置layer ---
- (void)productShapeLayer{
    
    //设置覆盖层
    if (!self.maskWithHole) {
        self.maskWithHole = [CAShapeLayer layer];
    }
    
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen]scale] >= 2) {
        offset = 0.5;
    }
    
    //设置检边视图层
    CGRect smallFrame = [self setOverViewSmallRect];
    CGRect smallerRect = CGRectInset(smallFrame, -offset, -offset) ;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [self.maskWithHole setPath:[maskPath CGPath]];
    [self.maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [self.maskWithHole setFillColor:[[UIColor colorWithWhite:0 alpha:0.5] CGColor]];

}

#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机

//从摄像头缓冲区获取图像
#pragma mark - -----------------------AVCaptureSession delegate----------------------
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //获取当前帧数据
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    
    int width = (int)CVPixelBufferGetWidth(imageBuffer);
    int height = (int)CVPixelBufferGetHeight(imageBuffer);
    
    if (_isChangedType == YES) {
        
        //选择当前识别模板
        SubType *subtype = self.subTypes[0];
        int currentTemplate = [_ocr setCurrentTemplate:subtype.OCRId];
        NSLog(@"设置模板返回值：%d", currentTemplate);
        [self setROI];
        _isChangedType = NO;
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        return;
    }
    
    if (!self.adjustingFocus) {
        //OCR识别
        [self recogWithData:baseAddress width:width height:height SampleBuffer:sampleBuffer];
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

- (void)recogWithData:(uint8_t *)baseAddress width:(int)width height:(int)height SampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    //加载图像,横屏识别RotateType传0，竖屏识别传1
    if (self.recogOrientation == RecogInHorizontalScreen) {
        int load;
        if (self.isLeft == YES) {
            load = [_ocr loadStreamBGRA:baseAddress Width:width Height:height RotateType:0];

        } else {
            load = [_ocr loadStreamBGRA:baseAddress Width:width Height:height RotateType:2];
        }
        NSLog(@"横屏load = %d",load);
    }else{
        int load = [_ocr loadStreamBGRA:baseAddress Width:width Height:height RotateType:1];
        NSLog(@"竖屏load = %d",load);
    }
    
    //0，识别成功
    int recog = [_ocr recognize];
    NSLog(@"-----recog=%d",recog);
    
    if (recog == 0 && (_isTakePicBtnClick == YES)) {
        
        //是否正在识别
        _isRecoging = YES;
        
        //是否点击拍照按钮
        _isTakePicBtnClick = NO;
        
        //会话停止
        [_session stopRunning];
        
        //识别成功，取结果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        //获取识别结果
        NSString *result = [_ocr getResults];
        NSLog(@"识别结果result = %@",result);
        
        //保存裁切图片
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        SubType *subtype = self.subTypes[0];
        NSString *imagePath = [documents[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",subtype.OCRId]];
        [_ocr saveImage:imagePath isRecogSuccess:recog];
        
        self.resultDataSource[_currentRecogType] = result;
        NSLog(@"%d,%@",  _currentRecogType, self.resultDataSource[_currentRecogType]);
        
        self.imagePaths[_currentRecogType] = imagePath;
        if (_isTakePicBtnClick) {
            self.resultDataSource[_currentRecogType] = @" ";
            _isTakePicBtnClick = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _takePicBtn.enabled = YES;
            [_session stopRunning];
            [self pushToResultView];
        });
    }
}
#endif

-(void) pushToResultView
{
    if (self.resultDataSource.count > 0) {
        NSString *vin = self.resultDataSource[0];
        if (![vin isEqualToString:@" "]) {
            [self pushControler:self.resultDataSource[0] image:[UIImage imageWithContentsOfFile:self.imagePaths[0]]];
            return;
        }
    }
    
    [self reSet];
}

- (void)pushControler:(NSString*)vin image:(UIImage*)image
{
        
        if (_webController != nil) {
            NSString *base64String =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image, 0.3)]];
            [self.webController pushVin:vin image:base64String];
    
        }else{
            
            if (_preController) {
                [_preController loaddata:vin image:image];
                _preController.isPushByOrderList = NO;
            }else{
                
                if (_scanSuccessBackCall) {
                    _scanSuccessBackCall(image,vin);
                }
            }
        }
    
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)reSet
{
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    //重置参数
    _pixelLensCount = 0;
    self.adjustingFocus = YES;
    _isRecoging = NO;
    _isTakePicBtnClick = NO;
    
    if (self.listTableView) {
        [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:((_drivingLicense)? (1) : (0)) inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [[self.listTableView delegate] tableView:self.listTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:((_drivingLicense)? (1) : (0)) inSection:0]];
    }
    
    AVCaptureDevice *camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self.session startRunning];
}

#pragma mark - --------------------返回按钮按钮点击事件---------------------
- (void)backAction
{
    _preController.isPushByOrderList = NO;
    
    [self.webController pushVin:@"" image:@""];

    _isTakePicBtnClick = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - -----------------------点击拍照按钮------------------------
- (void)takePhoto:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"icon_TakePhoto"] forState:UIControlStateNormal];
    _takePicLabel.text = @"识别中";
    _takePicLabel.textColor = YHWhiteColor;
    btn.enabled = NO;
    
    _isTakePicBtnClick = NO;
}

//对焦
- (void)fouceMode
{
    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [self.preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            NSLog(@"Error: %@", error);
        }
    }
}

#pragma mark - 闪光灯按钮点击事件
-(void)flashBtn:(UIButton *)btn
{
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if (![device hasTorch]) {
        //NSLog(@"no torch");
    }else{
        [device lockForConfiguration:nil];
        if (!_on) {
            [device setTorchMode: AVCaptureTorchModeOn];
            [btn setImage:[UIImage imageNamed:@"icon_OpenLamp"] forState:UIControlStateNormal];
            _on = YES;
        }else{
            [device setTorchMode: AVCaptureTorchModeOff];
            [btn setImage:[UIImage imageNamed:@"icon_CloseLamp"] forState:UIControlStateNormal];
            _on = NO;
        }
        [device unlockForConfiguration];
    }
}

//获取摄像头位置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if (device.position == position){
            return device;
        }
    }
    return nil;
}

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//数据帧转图片
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(quartzImage);
    
    //裁切预览时检边框区域图片
    CGRect tempRect = [self setOverViewSmallRect];
    CGFloat tWidth = (kFocalScale-1)*kScreenWidth*0.5;
    CGFloat tHeight = (kFocalScale-1)*kScreenHeight*0.5;
    
    //previewLayer上点坐标
    CGPoint pLTopPoint = CGPointMake((CGRectGetMinX(tempRect)+tWidth)/kFocalScale, (CGRectGetMinY(tempRect)+tHeight)/kFocalScale);
    CGPoint pRDownPoint = CGPointMake((CGRectGetMaxX(tempRect)+tWidth)/kFocalScale, (CGRectGetMaxY(tempRect)+tHeight)/kFocalScale);
    CGPoint pRTopPoint = CGPointMake((CGRectGetMaxX(tempRect)+tWidth)/kFocalScale, (CGRectGetMinY(tempRect)+tHeight)/kFocalScale);
    CGPoint pLDownPoint = CGPointMake((CGRectGetMinX(tempRect)+tWidth)/kFocalScale, (CGRectGetMaxY(tempRect)+tHeight)/kFocalScale);
    
    //真实图片点坐标
    CGPoint iLTopPoint = [_preview captureDevicePointOfInterestForPoint:pRTopPoint];
    CGPoint iLDownPoint = [_preview captureDevicePointOfInterestForPoint:pLTopPoint];
    CGPoint iRTopPoint = [_preview captureDevicePointOfInterestForPoint:pRDownPoint];
    //CGPoint iRDownPoint = [_preview captureDevicePointOfInterestForPoint:pLDownPoint];
    
    CGFloat y = iLTopPoint.y*kResolutionHeight;
    CGFloat x = iLTopPoint.x*kResolutionWidth;
    CGFloat w = (iRTopPoint.x-iLTopPoint.x)*kResolutionWidth;
    CGFloat h = (iLDownPoint.y-iLTopPoint.y)*kResolutionHeight;
    CGRect rect = CGRectMake(x, y, w, h);
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context1, rect, subImageRef);
    UIImage *image1 = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return (image1);
}

#pragma mark - 创建识别类型列表
- (void)creatRecogTypeListView
{
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self.recogOrientation==RecogInHorizontalScreen) {
        self.listTableView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    self.listTableView.frame = CGRectMake(0, kScreenHeight - 100-kSafeBottomHeight, kScreenWidth, 100+kSafeBottomHeight);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = [UIColor blackColor];
    self.listTableView.alpha = 0.7;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.listTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier: kListCellName];
    [self.view addSubview: self.listTableView];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark -- TableViewDelegate && TableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 不需要用到tableview的UI
    self.listDataSource = nil;
    return self.listDataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kListCellName forIndexPath:indexPath];
    if (!cell) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kListCellName];
    }
    MainType *mainType = self.listDataSource[indexPath.row];
    cell.textLabel.text = mainType.typeName;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainType *mainType = self.listDataSource[indexPath.row];
    self.subTypes = [DataSourceReader getSubTypeDataSource:mainType.type];
    
    //相机代理里根据此变量设置子模板
    _isChangedType = YES;
    
    //设置识别类型名字
    SubType *subtype = self.subTypes[0];
    self.middleLabel.text = subtype.name;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)dealloc
{
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    
    int uninit = [_ocr uinitOCREngine];
    NSLog(@"uninit=======%d", uninit);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

@end
