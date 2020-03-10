//
//  YHTakePhotoController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHTakePhotoController.h"

#import "YHCarPhotoModel.h"
#import "YHPhotoManger.h"
#import "NSObject+BGModel.h"
#import "TTZDBModel.h"
#import "YHCommon.h"
#import "CCMotionManager.h"

#import "YHPhotoCell.h"

//#import "YHtestViewController.h"


#import <AVFoundation/AVFoundation.h>

@interface YHTakePhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//@property (nonatomic)BOOL isCanCamera;


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

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cannelButton;

@property (nonatomic ,weak)UIView *focusView;
@property (nonatomic ,weak)UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

//@property (nonatomic, strong) NSArray *picturnCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHeight;

@property(nonatomic, strong) CCMotionManager * motionManager;


@end

@implementation YHTakePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        if ([self canUserCamear]) {
            [self initCamera];
            [self motionManager];
        }
        [self setUI];

}

- (CCMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CCMotionManager alloc] init];
    }
    return _motionManager;
}

- (void)dealloc{
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.models enumerateObjectsUsingBlock:^(YHPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        if (obj.image) {
        obj.isSelected = NO;
        
        //        }
    }];
    
    self.index = indexPath.item;
    self.models[self.index].isSelected = YES;
    
    
    [collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.item];
    
    return cell;
}

#pragma mark  -  事件监听

- (IBAction)backAction:(UIButton *)sender {
    !(_doClick)? : _doClick();
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)saveClick:(UIButton *)sender {
    
    UIImage *image = self.imageView.image;

    self.models[self.index].image = image;
    self.models[self.index].isSelected = NO;
    
    NSString *imageName = [YHPhotoManger fileName];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [YHPhotoManger saveImage:image
                        subDirectory:self.billId
                            fileName:imageName];
    });

    
    if ([self.models[self.index].name containsString:@"其他"]) {
        
        
        if(self.models.count < 10){
            YHPhotoModel *model =[YHPhotoModel new];
            model.name = [NSString stringWithFormat:@"其他-%ld",(unsigned long)self.models.count];
            [self.models addObject:model];
        }
        
        TTZDBModel *selectModel = nil;
        if (self.otherTempImage.count > self.index) {
            selectModel = self.otherTempImage[self.index];
            selectModel.file = imageName;
        }else{
            selectModel = [TTZDBModel new];
            selectModel.file = imageName;
            selectModel.fileId = imageName;
            selectModel.code = YHPhotoManger.picturnCode.lastObject;
            selectModel.billId = self.billId;
            self.otherTempImage[self.index] = selectModel;
            
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [selectModel saveOrUpdate:@[@"image"]];
        });
        
        
    }else{
        
        NSString *picCode = YHPhotoManger.picturnCode[self.index];
        NSString *billId = self.billId;
        NSInteger index = self.index;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            TTZDBModel *selectModel = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",billId,picCode]].firstObject;
            
            if (selectModel) {
                selectModel.file = imageName;
            }else{
                selectModel = [TTZDBModel new];
                selectModel.file = imageName;
                selectModel.fileId = imageName;
                selectModel.code = YHPhotoManger.picturnCode[index];
                selectModel.billId = billId;
            }
            
            if([selectModel saveOrUpdate:@[@"image"]]){
                NSLog(@"%s---保存OK", __func__);
            }
        });

    }
    
    _index ++;
    
    if (self.index > self.models.count-1) {
        _index = 0;
    }
    
    for (NSInteger i = self.index  ; i < self.models.count; i ++) {
        if (!self.models[i].image){
            self.models[i].isSelected = YES;
            self.index = i;
            
            [self.collectionView reloadData];
            [self.imageView removeFromSuperview];
            [self.session startRunning];
            self.takePhotoButton.hidden = NO;
            self.cannelButton.hidden = YES;
            self.saveButton.hidden = YES;
            
            
            return;
        }
        
    }
    
    if (!self.index) {
        [self backAction:nil];
        
        return;
    }
    
    for (NSInteger i = 0; i < self.index ; i ++) {
        if (!self.models[i].image){
            self.models[i].isSelected = YES;
            self.index = i;
            
            [self.collectionView reloadData];
            [self.imageView removeFromSuperview];
            [self.session startRunning];
            self.takePhotoButton.hidden = NO;
            self.cannelButton.hidden = YES;
            self.saveButton.hidden = YES;
            
            
            return;
        }
        
    }
    
    [self backAction:nil];
    
    
    
}


- (IBAction)cannelClick:(UIButton *)sender {
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    self.takePhotoButton.hidden = NO;
    self.cannelButton.hidden = YES;
    self.saveButton.hidden = YES;

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


- (IBAction)takePhoto:(UIButton *)sender {
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }

    if (videoConnection.isVideoOrientationSupported) {
        videoConnection.videoOrientation = [self currentVideoOrientation];
    }
    
    sender.hidden = YES;
    self.cannelButton.hidden = NO;
    self.saveButton.hidden = NO;
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSLog(@"%@", [NSThread currentThread]);
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self.session stopRunning];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.contentView addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageWithData:imageData];
        _imageView = imageView;
        
        NSLog(@"image size = %@",NSStringFromCGSize([UIImage imageWithData:imageData].size));
        
//        UIImage *image = [[UIImage alloc]initWithData:imageData];
//
//        YHtestViewController *vc = [[YHtestViewController alloc]initWithImage:image frame:self.previewLayer.frame];
//        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

#pragma mark  -  自定义方法

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
    self.previewLayer.frame = [UIScreen mainScreen].bounds;//self.contentView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.contentView.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.device unlockForConfiguration];
    }
    
    
}


- (void)setUI{
    
    [self.navigationController setNavigationBarHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.contentView addGestureRecognizer:tapGesture];
    
    UIView * focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    focusView.layer.borderWidth = 1.0;
    focusView.layer.borderColor =[UIColor greenColor].CGColor;
    focusView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:focusView];
    focusView.hidden = YES;
    _focusView = focusView;
    
    
    self.titleLB.text = self.models[self.index].name;
    CGFloat h = self.collectionView.frame.size.height;
    self.layout.itemSize = CGSizeMake(h, h);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    
    [self.collectionView registerClass:[YHPhotoCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.navigationBarHeight.constant = NavbarHeight;
    self.buttomViewHeight.constant += kTabbarSafeBottomMargin;

}

- (void)setIndex:(NSInteger)index
{
    
    
    _index = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    });
    
    self.titleLB.text = self.models[index].name;
    
    
    return;

    if (index>self.models.count-1) {
        index = 0;
    }
    
    YHPhotoModel *model = self.models[index];
    NSUInteger i = 0;
    
    while (model.image) {
        index ++ ;
        i ++;
        if (index>self.models.count-1) {
            index = 0;
        }
        model = self.models[index];

        if (i > self.models.count) {
            break;
        }
    }
    
    if (i > self.models.count) {
        index = 0;
        [self backAction:nil];
        return;
    }


    _index = index;
    for (NSInteger i = 0; i < self.models.count; i++) {
        YHPhotoModel *model = self.models[i];
        model.isSelected = (index == i);
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    });
    
    self.titleLB.text = self.models[index].name;

    
}

//- (NSArray *)picturnCode{
//    if(!_picturnCode){
//        _picturnCode = @[@"car_surface_front",@"car_surface_back",@"car_surface_left",
//                         @"car_surface_right",@"car_engine_room",@"car_rear_box",@"car_interior_1",
//                         @"car_interior_2",@"car_interior_3",@"car_instrument_panel",@"car_other"];
//    }
//    return _picturnCode;
//}


@end
