//
//  YYNativeAdView.h
//  NativeAdvancedExample
//
//  Created by Jay on 26/12/2019.
//  Copyright © 2019 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarRatingView : UIView
//0.0-5.0
@property (nonatomic, assign) CGFloat rating;
@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YYNativeAdType) {
    /// Unknown media aspect ratio.
    YYNativeAdTypeUnknown = 0,
    /// Any media aspect ratio.
    YYNativeAdTypeAny = 1,
    /// Landscape media aspect ratio.
    YYNativeAdTypeLandscape = 2,
    /// Portrait media aspect ratio.
    YYNativeAdTypePortrait = 3,
    /// Close to square media aspect ratio. This is not a strict 1:1 aspect ratio.
    YYNativeAdTypeSquare = 4
};


@interface YYNativeAdView : GADUnifiedNativeAdView

+(YYNativeAdView *)yy_NativeAdView:(UIViewController *)presentController
                      nativeAdType:(YYNativeAdType)type
               didRecordImpression:(dispatch_block_t)block;



@end

NS_ASSUME_NONNULL_END
