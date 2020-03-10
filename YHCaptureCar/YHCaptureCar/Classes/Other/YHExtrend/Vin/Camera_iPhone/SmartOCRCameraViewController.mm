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



//#import "ResultViewController.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机232
#import "SmartOCR.h"
#endif

@interface SmartOCRCameraViewController ()<UIAlertViewDelegate>{
    
    SmartOCROverView *_overView;//预览界面覆盖层,显示是否找到边
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    SmartOCR *_ocr;//核心
#endif
    UIButton *_takePicBtn;//拍照按钮
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
@property (strong, nonatomic) UILabel *middleLabel;
//当前类型的子类型
@property (strong, nonatomic) NSMutableArray *subTypes;


/************ 后添加 *************/
//确认按钮
@property (strong, nonatomic) UIButton *ensureBtn;
///扫描区域图片
@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation SmartOCRCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    self.view.backgroundColor = [UIColor clearColor];
    
    //初始化相机
    [self initialize];
    
    //初始化识别核心
    [self initOCRSource];
    
#endif
    //创建相机界面控件
    [self createCameraView];
    
}

- (void)dealloc{
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

    int uninit = [_ocr uinitOCREngine];
    NSLog(@"uninit=======%d", uninit);
#endif

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self.session startRunning];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除聚焦监听
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [self.session stopRunning];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}

#pragma mark - 初始化识别核心
//初始化相机
- (void) initialize{
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

//初始化识别核心
- (void) initOCRSource{
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
- (void) setROI{
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    
    //设置识别区域
    CGRect rect = [self setOverViewSmallRect];
    
    CGFloat tWidth = (kFocalScale-1)*kScreenWidth*0.5;
    CGFloat tHeight = (kFocalScale-1)*kScreenHeight*0.5;
    //previewLayer上点坐标
    CGPoint pLTopPoint = CGPointMake((CGRectGetMinX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);
    CGPoint pRDownPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMaxY(rect)+tHeight)/kFocalScale);
    CGPoint pRTopPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);

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
    //NSLog(@"t=%d b=%d l=%d r=%d",sTop,sBottom,sLeft,sRight);
    
#endif
    
}

#pragma mark - 设置检边区域的frmae
- (CGRect )setOverViewSmallRect{
    /*
     sRect 为检边框的frame，用户可以自定义设置
     以下是demo对检边框frame的设置，仅供参考.
     */
    CGFloat safeWidth = kScreenHeight-kSafeTopNoNavHeight-kSafeBottomHeight-100;//100为底部UITableView高度
    CGRect sRect = CGRectZero;
    if (self.recogOrientation == RecogInHorizontalScreen) {
        CGFloat cardScale = 5;
        CGFloat tempScale = 0.8;
        //横屏识别设置检边框frame
        CGFloat tempHeight = safeWidth*tempScale;
        CGFloat tempWidth = tempHeight/cardScale;
        sRect = CGRectMake((kScreenWidth-tempWidth)*0.5, (safeWidth-tempHeight)*0.5+kSafeTopNoNavHeight, tempWidth,tempHeight);
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

//创建相机界面
- (void)createCameraView{
    //设置检边视图层
    _overView = [[SmartOCROverView alloc] initWithFrame:self.view.bounds];
    _overView.backgroundColor = [UIColor clearColor];
    // 中间扫描区域的rect
    CGRect overSmallRect = [self setOverViewSmallRect];
    [_overView setSmallrect:overSmallRect];
    [self.view addSubview:_overView];
    
    //设置覆盖层
    [self drawShapeLayer];
    
    //显示当前识别类型
    self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    self.middleLabel.center = CGPointMake(CGRectGetMidX(overSmallRect),CGRectGetMidY(overSmallRect));
    self.middleLabel.backgroundColor = [UIColor clearColor];
    self.middleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    SubType *subtype = self.subTypes[0];
    self.middleLabel.text = [NSString stringWithFormat:@"请扫描%@", subtype.name];
    [self.view addSubview:self.middleLabel];
     // VAN_MR 竖屏
    if (self.recogOrientation == RecogInVerticalScreen) {
        self.middleLabel.frame = CGRectMake(0, 0, 300, 30);
        self.middleLabel.center = CGPointMake(CGRectGetMidX(overSmallRect),CGRectGetMidY(overSmallRect) - overSmallRect.size.height/2.0 - 25);
       
    }else{
        // 处理横屏的情况
    }
    
    self.resultDataSource = [NSMutableArray array];
    self.fieldDataSource = [NSMutableArray array];
    self.imagePaths = [NSMutableArray array];
    
    for (SubType *subtype in self.subTypes) {
        
        [self.resultDataSource addObject:@""];
        [self.fieldDataSource addObject:subtype.name];
        [self.imagePaths addObject:@""];
    }
    
    //返回按钮  navBack
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"back_camera_btn"] forState:UIControlStateNormal];
    UIImage *backImage = [UIImage imageNamed:@"back"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:backBtn];
    // 闪光灯按钮
    UIButton *flashBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [flashBtn setImage:[UIImage imageNamed:@"flash_camera_btn"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(flashBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    //添加拍照按钮
    _takePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // VAN_MR 隐藏拍照按钮
    _takePicBtn.hidden = YES;
    [_takePicBtn setImage:[UIImage imageNamed:@"take_pic_btn"] forState:UIControlStateNormal];
    [_takePicBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takePicBtn];
    
    if (self.recogOrientation==RecogInHorizontalScreen) { // 横屏
        _takePicBtn.frame = CGRectMake(CGRectGetMinX(overSmallRect),CGRectGetMaxY(overSmallRect)-CGRectGetWidth(overSmallRect),CGRectGetWidth(overSmallRect),CGRectGetWidth(overSmallRect));
        _takePicBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
        flashBtn.frame = CGRectMake(kScreenWidth-45, kScreenHeight-kSafeBottomHeight-20-35-100, 35, 35);
        backBtn.frame = CGRectMake(kScreenWidth-45, kSafeTopNoNavHeight+20, 35, 35);
        backBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
        flashBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.middleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    }else{ // 竖屏
        _takePicBtn.frame = CGRectMake((CGRectGetMaxX(overSmallRect)-CGRectGetHeight(overSmallRect)),CGRectGetMinY(overSmallRect),CGRectGetHeight(overSmallRect),CGRectGetHeight(overSmallRect));
        CGFloat sTopHeight =kSafeTopNoNavHeight + 15;
        flashBtn.frame = CGRectMake(kScreenWidth-50-kSafeLRX,sTopHeight, 35, 35);
//        backBtn.frame = CGRectMake(15+kSafeLRX,sTopHeight, 35, 35);
        backBtn.bounds = CGRectMake(0, 0, 25, 25);
        backBtn.center = CGPointMake(15+kSafeLRX + backBtn.bounds.size.width/2.0, flashBtn.center.y);
    }
    
    //确定按钮 ---基本没用
//    self.ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.ensureBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.ensureBtn.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
//    [self.ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [self.ensureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [self.ensureBtn addTarget:self action:@selector(pushToResultView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.ensureBtn];
//    //识别完成前隐藏确定按钮
//    self.ensureBtn.hidden = YES;
    
    //创建识别类型列表
    [self creatRecogTypeListView];
    
}
//重绘透明部分
- (void) drawShapeLayer{
    //设置覆盖层
    if (!self.maskWithHole) {
        self.maskWithHole = [CAShapeLayer layer];
    }
    
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
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
    [self.view.layer addSublayer:self.maskWithHole];
    [self.view.layer setMasksToBounds:YES];
}

- (void)creatRecogTypeListView{
    
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

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

//从摄像头缓冲区获取图像
#pragma mark - AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //获取当前帧数据
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    
    int width = (int)CVPixelBufferGetWidth(imageBuffer);
    int height = (int)CVPixelBufferGetHeight(imageBuffer);
    
    if (_isChangedType ==YES) {
        
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


- (void)recogWithData:(uint8_t *)baseAddress width:(int)width height:(int)height SampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    //加载图像,横屏识别RotateType传0，竖屏识别传1
    if (self.recogOrientation == RecogInHorizontalScreen) {
        int load = [_ocr loadStreamBGRA:baseAddress Width:width Height:height RotateType:0];
        NSLog(@"竖屏load = %d",load);
    }else{
        int load = [_ocr loadStreamBGRA:baseAddress Width:width Height:height RotateType:1];
        NSLog(@"竖屏load = %d",load);
    }
    
    //识别
    int recog = [_ocr recognize];
    NSLog(@"recog=%d",recog);
    if (recog == 0 || _isTakePicBtnClick) {
        _isRecoging = YES;
        _isTakePicBtnClick = NO;
        [_session stopRunning];
    
        //识别成功，取结果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        //获取识别结果
        NSString *result = [_ocr getResults];
        NSLog(@"result = %@",result);
        
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

- (void)pushControler:(NSString*)vin image:(UIImage*)image{
    if (_webController != nil) {
        NSString * base64String =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image, 0.3)]];
        //    NSString * base64String = [UIImagePNGRepresentation(image) ]
        [self.webController pushVin:vin image:base64String];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [_preController loaddata:vin image:image];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)reSet{
    
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
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self.session startRunning];
}
#pragma mark - ButtonAction
//返回按钮按钮点击事件
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击拍照按钮
- (void) takePhoto:(UIButton *)btn{
    btn.enabled = NO;
    _isTakePicBtnClick = YES;
}

//对焦
- (void)fouceMode{
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

//闪光灯按钮点击事件
- (void)flashBtn{
    
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if (![device hasTorch]) {
        //        NSLog(@"no torch");
    }else{
        [device lockForConfiguration:nil];
        if (!_on) {
            [device setTorchMode: AVCaptureTorchModeOn];
            _on = YES;
        }else{
            [device setTorchMode: AVCaptureTorchModeOff];
            _on = NO;
        }
        [device unlockForConfiguration];
    }
}
//获取摄像头位置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if (device.position == position){
            return device;
        }
    }
    return nil;
}

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
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

#pragma mark -- TableViewDelegate && TableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 不需要用到tableview的UI
    self.listDataSource = nil;
    return self.listDataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kListCellName forIndexPath:indexPath];
    if (!cell) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kListCellName];
    }
    MainType *mainType = self.listDataSource[indexPath.row];
    cell.textLabel.text = mainType.typeName;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainType *mainType = self.listDataSource[indexPath.row];
    self.subTypes = [DataSourceReader getSubTypeDataSource:mainType.type];
    
    //相机代理里根据此变量设置子模板
    _isChangedType = YES;
    
    //设置识别类型名字
    SubType *subtype = self.subTypes[0];
    self.middleLabel.text = subtype.name;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}


@end
