//
//  PCShareController.m
//  penco
//
//  Created by Jay on 12/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCShareController.h"
#import "PCSharePreviewController.h"
#import "YHCommon.h"

#import "PCShareCell.h"
#import "YHModelItem.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+Resize.h"

#import "YHTools.h"
#import "CCMotionManager.h"

#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件
#import <UShareUI/UShareUI.h>  //分享面板
#import <AVFoundation/AVFoundation.h>//#ACADA7

#import <Photos/Photos.h>

static const DDLogLevel ddLogLevel = DDLogLevelInfo;

@interface PCShareController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cannel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttomBox;


//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;


@property(nonatomic, strong) CCMotionManager * motionManager;

@property (nonatomic ,weak)UIView *focusView;
@property (nonatomic ,strong)UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomHeight;

@end

@implementation PCShareController
- (IBAction)cannelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.motionManager stopDeviceMotionUpdates];
        self.motionManager = nil;
    

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.image.image = [UIImage imageNamed:@"launchBack"];
//    self.qrCode.image = [YHTools createQRCode];
//    self.share.enabled = NO;
//    self.tableView.backgroundColor = [UIColor clearColor];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addImageAction:nil];
//    });
    
    if ([self canUserCamear]) {
        [self initCamera];
        [self motionManager];
    }
    [self setUI];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(_session && !_session.isRunning) [_session startRunning];
}

- (BOOL)canUserCamear{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
    
}

/// 转换摄像头
- (IBAction)switchCamera{
    
    if([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] < 1){
        [MBProgressHUD showError:@"设备不支持"];
        return;
    }

    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    AVCaptureDevicePosition position = [[self.input device] position];
    if (position == AVCaptureDevicePositionFront){
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        if(!newCamera){
            [MBProgressHUD showError:@"找不到后置摄像头"];
            return;
        }
        
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            
            self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
            
        }
        
    }else {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        if(!newCamera){
            [MBProgressHUD showError:@"找不到前置摄像头"];
            return;
        }
        if ([self.session canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            
            self.session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
            
        }
    }
    
    
    NSError*error;
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
    if(error || !newInput) {
        [MBProgressHUD showError:@"获取摄像头失败"];
        return;
    }
    
    [self.session stopRunning];
    [self.session beginConfiguration];
    [self.session removeInput:self.input];
    
    
    
    if ([self.session canAddInput:newInput]) {
        
        [self.session addInput:newInput];
        self.input = newInput;
        
    } else {
        
        [self.session addInput:self.input];
        [MBProgressHUD showError:@"无法切换摄像头"];
    }
    [self.session commitConfiguration];
    [self.session startRunning];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ){
        if ( device.position == position ) return device;
    }
    return nil;
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.contentView.bounds;//[UIScreen mainScreen].bounds;//self.contentView.bounds;
}

- (void)initCamera{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:NULL];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.contentView.bounds;//[UIScreen mainScreen].bounds;//self.contentView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.contentView.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        //闪光灯开关
//        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
//            [self.device setFlashMode:AVCaptureFlashModeAuto];
//        }
        //自动白平衡
//        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
//            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
//        }
        [self.device unlockForConfiguration];
    }
    
    
}


- (void)setUI{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.contentView addGestureRecognizer:tapGesture];

    UIView * focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    focusView.layer.borderWidth = 1.0;
    focusView.layer.borderColor =[UIColor greenColor].CGColor;
    focusView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:focusView];
    focusView.hidden = YES;
    _focusView = focusView;
    
    [self.cannel setImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];// ;
    self.cannel.tintColor = [UIColor whiteColor];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    UIView *h1 = [UIView new];
    h1.backgroundColor = YHColor0X(0xACADA7, 1.0);
    h1.frame = CGRectMake(w/3.0, 0, 0.5, h);
    [self.contentView addSubview:h1];
    
    UIView *h2 = [UIView new];
    h2.backgroundColor = YHColor0X(0xACADA7, 1.0);
    h2.frame = CGRectMake(2*w/3.0, 0, 0.5, h);
    [self.contentView addSubview:h2];
    
    
    UIView *l1 = [UIView new];
    l1.backgroundColor = YHColor0X(0xACADA7, 1.0);
    l1.frame = CGRectMake(0,(h-150)/3.0, w, 0.5);
    [self.contentView addSubview:l1];
    
    UIView *l2 = [UIView new];
    l2.backgroundColor = YHColor0X(0xACADA7, 1.0);
    l2.frame = CGRectMake(0,2*(h-150)/3.0, w, 0.5);
    [self.contentView addSubview:l2];
    

    self.buttomHeight.constant = IphoneX? 216 : 158;

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    
    CGSize size = self.contentView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}


- (void)dealloc{
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
    YHLog(@"%s", __func__);
}
- (CCMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CCMotionManager alloc] init];
    }
    return _motionManager;
}


//- (IBAction)addImageAction:(id)sender{
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [vc addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self openSuccWith:YES];
//    }]];
//    [vc addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self openSuccWith:NO];
//    }]];
//    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//
//    [self presentViewController:vc animated:YES completion:nil];
//}
// 打开相机/相册
- (void)openSuccWith:(BOOL )isCamera{
    
    UIImagePickerController *photoPicker = [UIImagePickerController new];
    photoPicker.delegate = self;
    //photoPicker.allowsEditing = YES;
    
    if (isCamera) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    if (!isCamera) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:photoPicker animated:YES completion:nil];
}
// 当前设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    
    switch (self.motionManager.deviceOrientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        
        //这里要注意，图片填充方式的选择让图片不要变形了
        
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

- (IBAction)openPhoto:(id)sender {
    [self.session stopRunning];
    [self openSuccWith:NO];
}

- (IBAction)savePhoto:(id)sender {
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        YHLog(@"take photo failed!");
        [MBProgressHUD showError:@"拍照失败"];
        return;
    }
    
    if (videoConnection.isVideoOrientationSupported) {
        videoConnection.videoOrientation = [self currentVideoOrientation];
    }
    
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            [MBProgressHUD showError:@"拍照失败"];
            return;
        }
        
        YHLog(@"%@", [NSThread currentThread]);
        
        
        [self.session stopRunning];


        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *originImage = [[UIImage alloc] initWithData:imageData];
        originImage = [originImage fixOrientation];
        CGFloat width = self.previewLayer.bounds.size.width;
        CGFloat height = self.previewLayer.bounds.size.height;
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(width*scale, height*scale);
        UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill size:size interpolationQuality:kCGInterpolationHigh];
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) * 0.5, (scaledImage.size.height - size.height) * 0.5, size.width, (screenHeight-self.buttomHeight.constant)*scale);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        
        
        [self toPreview:croppedImage];


        
        
        YHLog(@"image size = %@",NSStringFromCGSize([UIImage imageWithData:imageData].size));
    }];
    

}

////裁剪图片  裁剪图片 裁剪图片
//- (UIImage *)cutImage:(UIImage*)image oringImageView:(UIImageView *)imageView
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef = nil;
//
//    CGFloat height = imageView.frame.size.height;
//    CGFloat width  = imageView.frame.size.width;
//
//    CGFloat scale = (image.size.height / image.size.width) / (height / width);
//    //    || isnan(scale)
//    if ((image.size.width / image.size.height) < (width / height)) {
//        newSize.width  = image.size.width;
//        newSize.height = image.size.width * height / width;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * width / height;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//    }
//    return [UIImage imageWithCGImage:imageRef];
//}



//- (UIImage *)fixOrientation:(UIImage *)aImage {
//
//    //    return aImage;
//    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    switch (aImage.imageOrientation) {
//
//        case UIImageOrientationDown:
//
//        case UIImageOrientationDownMirrored:
//
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//
//            transform = CGAffineTransformRotate(transform, M_PI);
//
//            break;
//
//
//
//        case UIImageOrientationLeft:
//
//        case UIImageOrientationLeftMirrored:
//
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//
//            break;
//
//
//
//        case UIImageOrientationRight:
//
//        case UIImageOrientationRightMirrored:
//
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//
//            break;
//
//        default:
//
//            break;
//
//    }
//
//
//
//    switch (aImage.imageOrientation) {
//
//        case UIImageOrientationUpMirrored:
//
//        case UIImageOrientationDownMirrored:
//
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//
//            transform = CGAffineTransformScale(transform, -1, 1);
//
//            break;
//
//
//
//        case UIImageOrientationLeftMirrored:
//
//        case UIImageOrientationRightMirrored:
//
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//
//            transform = CGAffineTransformScale(transform, -1, 1);
//
//            break;
//
//        default:
//
//            break;
//
//    }
//
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//
//                                             CGImageGetColorSpace(aImage.CGImage),
//
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//
//    CGContextConcatCTM(ctx, transform);
//
//    switch (aImage.imageOrientation) {
//
//        case UIImageOrientationLeft:
//
//        case UIImageOrientationLeftMirrored:
//
//        case UIImageOrientationRight:
//
//        case UIImageOrientationRightMirrored:
//
//            // Grr...
//
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//
//            break;
//
//
//
//        default:
//
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//
//            break;
//
//    }
//
//
//
//    // And now we just create a new UIImage from the drawing context
//
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//
//    CGContextRelease(ctx);
//
//    CGImageRelease(cgimg);
//
//    return img;
//
//}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self toPreview:image];
    }
    
}

- (void)toPreview:(UIImage *)image{
    !(_choseImageBlock)? : _choseImageBlock(image);
    [self.navigationController popViewControllerAnimated:YES];
//    PCSharePreviewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCSharePreviewController"];
//    vc.shareImage = image;
//    vc.tableModels = self.tableModels;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    //vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    //vc.tableModels = self.tableModels;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.session startRunning];


}



@end
