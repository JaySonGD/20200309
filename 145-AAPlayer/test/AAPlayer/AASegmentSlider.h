//
//  VSegmentSlider.h
//  VPlayer
//
//  Created by erlz nuo on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@interface AASegmentSlider : UISlider
{
	NSArray *_segments;
}

@property (atomic, retain) NSArray *segments;

@property (nonatomic, assign) CGFloat segment;

@end


@interface AAFastView : UIView
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *fastTitleLB;
@property (nonatomic, strong) UIImageView *fastIconImageView;
@property (nonatomic, strong) UIProgressView *fastProgressView;
@end

@interface AAbrightnessView : UIView

@property (nonatomic, assign) CGFloat brightness;

@end

@interface AAWebController : UIViewController
@property (nonatomic,copy) NSString *url;
@end

@interface AAFullController : UIViewController
@end


