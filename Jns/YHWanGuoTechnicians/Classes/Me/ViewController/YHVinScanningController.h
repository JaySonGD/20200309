//
//  YHVinScanningController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "YHBaseViewController.h"
#import "YHWebFuncViewController.h"
@interface YHVinScanningController : YHBaseViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
    CALayer *_customLayer;
    AVCaptureVideoPreviewLayer *_prevLayer;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic)BOOL isLocation;

@property (weak,nonatomic)YHWebFuncViewController *webController;
@end
