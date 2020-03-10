//
//  YHVinScanningController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//  扫描控制器
#import "YHVinScanningController.h"
#import "YHNetworkManager.h"
#import "UIImage+info.h"
#import "Masonry.h"
//#import "VINOCR.h"
#import "UIImage+info.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "YHNewOrderController.h"
#import "YHNetworkWeiXinManager.h"
#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;

#import "YHVinScanningController.h"

@interface YHVinScanningController ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    BOOL Camera_State;
}

@property (weak, nonatomic) IBOutlet UIView *bottmView;
@property (weak, nonatomic) IBOutlet UIView *testV;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (nonatomic)BOOL isUpdata;
@property (weak, nonatomic) IBOutlet UIView *callV;
@property (weak, nonatomic) IBOutlet UIButton *restartB;
@property (weak, nonatomic) IBOutlet UIButton *netAndLocationB;
- (IBAction)netOrLocationAction:(id)sender;
@property (strong, nonatomic)UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *timeOutL;
@property (weak, nonatomic)NSTimer *timer;
@property (nonatomic)NSInteger timerIndex;
@end


@implementation YHVinScanningController

- (IBAction)cancelAction:(id)sender {
    [self popViewController:nil];
}

- (IBAction)reStartAction:(id)sender {
    //    if (![self.captureSession isRunning]) {
    //        self.restartB.hidden = YES;
    //        _isUpdata = NO;
    //        [self.captureSession startRunning];
    //    }
    [self popViewController:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isLocation = NO;
    _isUpdata = YES;
    _callV.layer.borderWidth  = 2;
    _callV.layer.borderColor  = [UIColor redColor].CGColor;
    __weak __typeof__(self) weakSelf = self;
    [_callV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(40);
        make.centerY.equalTo(weakSelf.view.mas_centerY).with.offset(0);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0);
        //        make.width.equalTo(@280);
        make.height.equalTo(((_isLocation)? (@200) : (@60)));
    }];
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.callV.mas_left).with.offset(0);
        make.top.equalTo(weakSelf.callV.mas_top).with.offset(0);
        make.bottom.equalTo(weakSelf.callV.mas_bottom).with.offset(0);
        make.right.equalTo(weakSelf.callV.mas_right).with.offset(0);
    }];
    [self initCapture];
    
    // Do any additional setup after loading the view, typically from a nib.
    //        [[VINOCR sharedVINOCR] setDelegate:self];
    
    
}

- (IBAction)torchOnOrOff:(UIButton*)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [sender setTitle:@"关灯" forState:UIControlStateNormal];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        [sender setTitle:@"开灯" forState:UIControlStateNormal];
    }
    [device unlockForConfiguration];
}

- (void)vinOCRValue:(NSString *)retVal{
    if (retVal || ![retVal isEqualToString:@""]) {
        NSString *vin = [retVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        vin = [vin stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        vin = [vin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        vin = [vin stringByReplacingOccurrencesOfString:@" " withString:@""];
        vin = [vin uppercaseString];
        vin = [vin stringByReplacingOccurrencesOfString:@"I" withString:@"1"];
        vin = [vin stringByReplacingOccurrencesOfString:@"O" withString:@"0"];
        //str就是去掉的string
        
        self.vinL.text = vin;
        if (vin.length == 17) {
            [self.captureSession stopRunning];
            self.restartB.hidden = NO;
            
            [self pushControler:vin image:_image];
            return;
        }
        //        _isUpdata = NO;
        [self timeOutStart:3];
    }else{
        self.vinL.text = @"识别不到";
        //        _isUpdata = NO;
        [self timeOutStart:3];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![self.captureSession isRunning]) {
        //        _isUpdata = NO;
        [self timeOutStart:3];
        [self.captureSession startRunning];
    }
}
/**
 * 初始化摄像头
 */
- (void)initCapture {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device  error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    // captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    [self.captureSession startRunning];
    
    self.customLayer = [CALayer layer];
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height = frame.size.height - 64;
    
    self.customLayer.frame = frame;
    self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
    //    [self.view.layer insertSublayer:self.customLayer atIndex:0];
    //    [self.view.layer addSublayer:self.customLayer ];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 64, 100, 100);
    //    [self.view addSubview:self.imageView];
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
    self.prevLayer.frame = CGRectMake(100, 64, 100, 100);
    self.prevLayer.frame = screenBound;
    self.prevLayer.videoGravity = AVLayerVideoGravityResize;
    //    self.prevLayer.visibleRect = screenBound;
    //    [self.view.layer addSublayer: self.prevLayer];
    [self.view.layer insertSublayer:self.prevLayer atIndex:0];
    
    //    UIButton *back = [[UIButton alloc]init];
    //    [back setTitle:@"Back" forState:UIControlStateNormal];
    //    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //
    //    [back sizeToFit];
    //    frame = back.frame;
    //    frame.origin.y = 25;
    //    back.frame = frame;
    //    [self.view addSubview:back];
    //    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self timeOutStart:5];
}

-(void)back:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,                                                  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    id object = (__bridge id)newImage;
    // http://www.cnblogs.com/zzltjnh/p/3885012.html
    //    [self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: object waitUntilDone:YES];
    
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    // release
    CGImageRelease(newImage);
    
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    if (!_isUpdata  ) {
        _isUpdata = YES;
        
        CGRect fr = self.callV.frame;
        UIImage *image2 = [UIImage image:image scaleToSize:screenBound.size];
        //
        //            fr.origin.y = fr.origin.y - 20;
        image2 = [UIImage imageFromImage:image2 inRect:fr];
        self.image = image2;
        //        [self.imageV performSelectorOnMainThread:@selector(setImage:) withObject:image2 waitUntilDone:YES];
        
        //        if (_isLocation) {
        //            [VINOCR vinRecognition:image2];
        //        }else{
        [ self checkAction:image2];
        //        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}


- (void)timeOutStart:(NSUInteger)timerIndex{
    _timeOutL.hidden = NO;
    _vinL.hidden = YES;
    self.timerIndex = timerIndex;
    self.timeOutL.text = [NSString stringWithFormat:@"%lu", (unsigned long)_timerIndex];
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
}

- (void)timeOut:(id)obj{
    self.timerIndex -= 1;
    if (self.timerIndex <= 0) {
        if (_timer.isValid) {
            [_timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
            _timer=nil;            // 将销毁定时器
        }
        
        _isUpdata = NO;
        _timeOutL.hidden = YES;
        _vinL.hidden = NO;
        
    }else{
        self.timeOutL.text = [NSString stringWithFormat:@"%lu", (unsigned long)_timerIndex];
    }
}

- (void)checkAction:(UIImage*)image {
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        weakSelf.vinL.text = @"识别中...";
    });
    if (_isLocation){
        [YHNetworkWeiXinManager  analysisVin:UIImageJPEGRepresentation(image, 1.0) onComplete:^(NSDictionary *info) {
            NSArray *outputs = info[@"outputs"];
            if (outputs.count != 0) {
                NSDictionary *output = outputs[0];
                NSDictionary *outputValue = output[@"outputValue"];
                NSString *dataValueStr = outputValue[@"dataValue"];
                NSDictionary *dataValue = [YHTools dictionaryWithJsonString:dataValueStr];
                NSString *vin = dataValue[@"vin"];
                if (vin || ![vin isEqualToString:@""]) {
                    NSLog(@"data : %@", dataValueStr);
                    weakSelf.vinL.text = vin;
                    if (vin.length == 17) {
                        [weakSelf.captureSession stopRunning];
                        weakSelf.restartB.hidden = NO;
                        
                        [weakSelf pushControler:vin image:weakSelf.image];
                        return ;
                    }
                }else{
                    weakSelf.vinL.text = @"识别不到";
                }
            }else{
                weakSelf.vinL.text = @"识别不到";
            }
            [weakSelf timeOutStart:3];
            //            _isUpdata = NO;
        } onError:^(NSError *error) {
            weakSelf.vinL.text = @"识别不到";
            //            _isUpdata = NO;
            [weakSelf timeOutStart:3];
        }];
    }else{
        
        [[YHNetworkManager sharedYHNetworkManager]  updatePictureImageDate:[@[UIImageJPEGRepresentation(image, 1.0)] mutableCopy] onComplete:^(NSDictionary *info) {
            NSString *retVal = info[@"retVal"];
            if (retVal || ![retVal isEqualToString:@""]) {
                weakSelf.vinL.text = retVal;
                if (retVal.length == 17) {
                    [weakSelf.captureSession stopRunning];
                    weakSelf.restartB.hidden = NO;
                    
                    [weakSelf pushControler:retVal image:weakSelf.image];
                    return ;
                }
            }else{
                weakSelf.vinL.text = @"识别不到";
            }
            
            //            _isUpdata = NO;
            [weakSelf timeOutStart:3];
        } onError:^(NSError *error) {
            weakSelf.vinL.text = @"识别不到";
            //            _isUpdata = NO;
            [weakSelf timeOutStart:3];
        }];
    }
}

- (void)pushControler:(NSString*)vin image:(UIImage*)image{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHNewOrderController *controller = [board instantiateViewControllerWithIdentifier:@"YHNewOrderController"];
    controller.vin = vin;
    controller.image = image;
    controller.webController = _webController;
    controller.isCar = !_isLocation;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload {
    [self.captureSession stopRunning];
    self.imageView = nil;
    self.customLayer = nil;
    self.prevLayer = nil;
}

- (IBAction)netOrLocationAction:(id)sender {
    self.isLocation = !_isLocation;
    [self vinBoxLaout];
}

- (void)vinBoxLaout{
    __weak __typeof__(self) weakSelf = self;
    [_callV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(40);
        make.centerY.equalTo(weakSelf.view.mas_centerY).with.offset(0);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0);
        //        make.width.equalTo(@280);
        make.height.equalTo(((_isLocation)? (@200) : (@60)));
    }];
}
@end
