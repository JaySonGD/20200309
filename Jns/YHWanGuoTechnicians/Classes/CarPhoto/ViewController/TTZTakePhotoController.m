//
//  Created by Jayson on 2019/6/22.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "TTZTakePhotoController.h"
#import "YHCarPhotoModel.h"
#import "YHPhotoManger.h"
#import "NSObject+BGModel.h"
#import "TTZDBModel.h"
#import "YHCommon.h"
#import "CCMotionManager.h"

#import "TTZSurveyModel.h"

#import "TTZTakePhotoCell.h"

#import <AVFoundation/AVFoundation.h>


@interface TTZTakePhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) NSMutableArray <TTZSurveyModel *>*uploadImgs;

@property (nonatomic, assign) NSInteger index;

@end

@implementation TTZTakePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        if ([self canUserCamear]) {
            [self initCamera];
            [self motionManager];
        }
    [self setUI];
    
}

- (void)dealloc{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
    NSLog(@"%s", __func__);
}
- (CCMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CCMotionManager alloc] init];
    }
    return _motionManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.uploadImgs.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!IsEmptyStr(self.uploadImgs[indexPath.item].dbImages.lastObject.fileId)){
    //if (![self.uploadImgs[indexPath.item].dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
        [self findEmpty];
        return;
    }
    
    [self.uploadImgs enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    self.uploadImgs[indexPath.item].isSelect = YES;
    
    [collectionView reloadData];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.index = indexPath.item;
    self.titleLB.text = self.uploadImgs[self.index].projectName;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTZTakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.uploadImgs[indexPath.item];
    
    return cell;
}

#pragma mark  -  事件监听

- (IBAction)backAction:(UIButton *)sender {
    !(_doClick)? : _doClick();
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)findEmpty{
    NSInteger i = self.index+1;
    
    for (; i < self.uploadImgs.count;i++) {
        TTZSurveyModel *model = self.uploadImgs[i];
        if(IsEmptyStr(model.dbImages.lastObject.fileId)){
        //if ([model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
            self.index = i;
            model.isSelect = YES;
            break;
        }
    }
    
    if (i >= self.uploadImgs.count) {
        [self backAction:nil];
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.titleLB.text = self.uploadImgs[self.index].projectName;

}

- (IBAction)saveClick:(UIButton *)sender {
    
    UIImage *image = self.imageView.image;
    TTZSurveyModel *selectSurveyModel = self.uploadImgs[self.index];
    
    TTZDBModel *selectModel = selectSurveyModel.dbImages.lastObject;
    
    NSString *fileName = [YHPhotoManger fileName];
    
    if(!selectModel.fileId.length) selectModel.fileId = fileName;
    selectModel.billId = selectSurveyModel.billId;
    selectModel.image = image;
    selectModel.file = fileName;
    selectModel.code = selectSurveyModel.code;
    selectModel.timestamp = selectModel.timestamp? selectModel.timestamp : YHPhotoManger.timestamp;

    [selectModel saveOrUpdate:@[@"image"]];
    
#pragma mark 保存图片
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [YHPhotoManger saveImage:image
                    subDirectory:selectSurveyModel.billId
                        fileName:fileName];
    });
    
    if (selectSurveyModel.dbImages.count<5) {
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        [selectSurveyModel.dbImages addObject:defaultModel];
    }else{//已经满了5个坑位 ，要寻找下一个空的空位
        selectSurveyModel.isSelect = NO;
        if(self.index >= (self.uploadImgs.count - 1)) [self backAction:nil];
        else [self findEmpty];
    }
    [self.collectionView reloadData];
    
    
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    self.takePhotoButton.hidden = NO;
    self.cannelButton.hidden = YES;
    self.saveButton.hidden = YES;
    
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
        
        NSLog(@"%@", [NSThread currentThread]);
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self.session stopRunning];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.contentView addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageWithData:imageData];
        _imageView = imageView;
        
        sender.hidden = YES;
        self.cannelButton.hidden = NO;
        self.saveButton.hidden = NO;
        
        NSLog(@"image size = %@",NSStringFromCGSize([UIImage imageWithData:imageData].size));
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
    
    
    self.titleLB.text = self.uploadImgs[self.index].projectName;
    CGFloat h = self.collectionView.frame.size.height;
    self.layout.itemSize = CGSizeMake(64+16, h);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    
    //[self.collectionView registerClass:[YHPhotoCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.navigationBarHeight.constant = kStatusBarAndNavigationBarHeight;
    self.buttomViewHeight.constant += kTabbarSafeBottomMargin;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.backBtn setImage:[[UIImage imageNamed:@"newBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];// ;
    self.backBtn.tintColor = [UIColor whiteColor];
    
    
}


- (void)setSysModel:(TTZSYSModel *)sysModel{
    _sysModel = sysModel;
    
    __block NSMutableArray <TTZSurveyModel *>*uploadImgs = [NSMutableArray array];
    
    [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gobj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gobj.list enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.uploadImgStatus) [uploadImgs addObject:obj];
            obj.isSelect = NO;
        }];
    }];
    
    self.index = [uploadImgs indexOfObject:self.model];
    self.model.isSelect = YES;
    self.uploadImgs = uploadImgs;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    });
    
}



@end
