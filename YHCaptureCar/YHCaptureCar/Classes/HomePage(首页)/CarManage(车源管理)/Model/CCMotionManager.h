
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CCMotionManager : NSObject

@property(nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;


- (void)stopDeviceMotionUpdates;
@end
