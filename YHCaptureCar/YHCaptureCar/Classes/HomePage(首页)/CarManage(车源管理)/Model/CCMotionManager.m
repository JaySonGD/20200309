

#import "CCMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface CCMotionManager() 

@property(nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation CCMotionManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1/15.0;
        if (!_motionManager.deviceMotionAvailable) {
            _motionManager = nil;
            return self;
        } 
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
    return self;
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            _videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            NSLog(@"%s-----UIDeviceOrientationPortraitUpsideDown", __func__);
        }
        else{
            _deviceOrientation = UIDeviceOrientationPortrait;
            _videoOrientation = AVCaptureVideoOrientationPortrait;
            NSLog(@"%s-----UIDeviceOrientationPortrait", __func__);

        }
    }
    else{
        if (x >= 0){
            _deviceOrientation = UIDeviceOrientationLandscapeRight;
            _videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            NSLog(@"%s-----UIDeviceOrientationLandscapeRight", __func__);

        }
        else{
            _deviceOrientation = UIDeviceOrientationLandscapeLeft;
            _videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            NSLog(@"%s-----UIDeviceOrientationLandscapeLeft", __func__);

        }
    }
}

- (void)stopDeviceMotionUpdates{
    [_motionManager stopDeviceMotionUpdates];
}

- (void)dealloc{
    [self stopDeviceMotionUpdates];
    NSLog(@"%s", __func__);
}



@end
