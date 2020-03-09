//
//  YYNativeAdView.m
//  NativeAdvancedExample
//
//  Created by Jay on 26/12/2019.
//  Copyright © 2019 Google. All rights reserved.
//

#import "YYNativeAdView.h"


static NSString *const TestAdUnit = @"ca-app-pub-3940256099942544/3986624511";
@interface YYNativeAdView ()<GADUnifiedNativeAdLoaderDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaContentAspectRatio;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, copy) dispatch_block_t recordImpression;
@property(nonatomic, weak, nullable) IBOutlet UILabel *starRatingLabel;

@end

@implementation YYNativeAdView


+(YYNativeAdView *)yy_NativeAdView:(UIViewController *)presentController
                      nativeAdType:(YYNativeAdType)type
               didRecordImpression:(dispatch_block_t)block{
    
    YYNativeAdView *adView = [[NSBundle mainBundle] loadNibNamed:@"YYNativeAdView" owner:nil options:nil].firstObject;
    
    
    
    GADNativeAdMediaAdLoaderOptions *mediaAdOptions = [[GADNativeAdMediaAdLoaderOptions alloc] init];
    mediaAdOptions.mediaAspectRatio = (GADMediaAspectRatio)type;//GADMediaAspectRatioPortrait;// GADMediaAspectRatioSquare;//GADMediaAspectRatioLandscape;
    
    //设置logo的位置
    GADNativeAdViewAdOptions *adLogoOptions = [[GADNativeAdViewAdOptions alloc] init];
    adLogoOptions.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    
    adView.adLoader = [[GADAdLoader alloc] initWithAdUnitID:TestAdUnit
                                         rootViewController:presentController
                                                    adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                    options:@[mediaAdOptions,adLogoOptions,videoOptions]];
    adView.adLoader.delegate = adView;
    [adView.adLoader loadRequest:[GADRequest request]];
    adView.recordImpression = block;
    return adView;
}


#pragma mark - 修改约束multiplier属性
- (NSLayoutConstraint *)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
    return newConstraint;
}

#pragma mark GADUnifiedNativeAdLoaderDelegate implementation

/// Called when adLoader fails to load an ad.
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error{
    NSLog(@"广告数据加载失败: %@", error);
}


- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd{
    NSLog(@"广告数据加载成功");
    
    GADUnifiedNativeAdView *nativeAdView = self.subviews.firstObject;
    
    nativeAdView.nativeAd = nativeAd;
    
    // Set ourselves as the ad delegate to be notified of native ad events.
    nativeAd.delegate = self;
    
    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
    
    // This app uses a fixed width for the GADMediaView and changes its height
    // to match the aspect ratio of the media content it displays.
    if (nativeAd.mediaContent.aspectRatio > 0) {
        
        self.mediaContentAspectRatio = [self changeMultiplierOfConstraint:self.mediaContentAspectRatio multiplier:nativeAd.mediaContent.aspectRatio];
        
    }else{
        self.mediaContentAspectRatio = [self changeMultiplierOfConstraint:self.mediaContentAspectRatio multiplier:1000];
    }
    
    if (nativeAd.mediaContent.hasVideoContent) {
        // By acting as the delegate to the GADVideoController, this ViewController
        // receives messages about events in the video lifecycle.
        nativeAd.mediaContent.videoController.delegate = self;
        
        //self.videoStatusLabel.text = @"Ad contains a video asset.";
    } else {
        //self.videoStatusLabel.text = @"Ad does not contain a video.";
    }
    
    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
    
    [((UIButton *)nativeAdView.callToActionView) setTitle:[NSString stringWithFormat:@"        %@        ",nativeAd.callToAction]
                                                 forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

    
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;
    
    ((StarRatingView *)nativeAdView.starRatingView).rating = nativeAd.starRating.floatValue;
    nativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;
    self.starRatingLabel.text = [NSString stringWithFormat:@"%.1f",nativeAd.starRating.floatValue];
    self.starRatingLabel.hidden = nativeAdView.starRatingView.isHidden;

    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;
    
    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;
    
    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;
    
    !(_recordImpression)? : _recordImpression();
    
}

#pragma mark GADVideoControllerDelegate


- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"视频播放完毕.");
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s---广告点击", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}



- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
    double starRating = numberOfStars.doubleValue;
    if (starRating >= 5) {
        return [UIImage imageNamed:@"stars_5"];
    } else if (starRating >= 4.5) {
        return [UIImage imageNamed:@"stars_4_5"];
    } else if (starRating >= 4) {
        return [UIImage imageNamed:@"stars_4"];
    } else if (starRating >= 3.5) {
        return [UIImage imageNamed:@"stars_3_5"];
    } else {
        return nil;
    }
}


@end


#import <QuartzCore/QuartzCore.h>

@interface StarRatingView()
@property (nonatomic,strong) CALayer* tintLayer;
@property (nonatomic,weak) CALayer* starBackgroundLayer;

@end

@implementation StarRatingView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    self.opaque = NO;
    
    CGRect newrect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    
    CALayer* starBackground = [CALayer layer];
    starBackground.contents = (__bridge id)(self.starImage.CGImage);
    starBackground.frame = newrect;
    [self.layer addSublayer:starBackground];
    self.starBackgroundLayer = starBackground;
    
    self.tintLayer = [CALayer layer];
    self.tintLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    
    [self.tintLayer setBackgroundColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.57 alpha:1.00].CGColor];
    
    [self.layer addSublayer:self.tintLayer];
    CALayer* starMask = [CALayer layer];
    starMask.contents = (__bridge id)(self.starImage.CGImage);
    starMask.frame = newrect;
    [self.layer addSublayer:starMask];
    self.tintLayer.mask = starMask;
    
    //self.rating = rating;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tintLayer.mask.frame =  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.starBackgroundLayer.frame = self.tintLayer.mask.frame;
}

- (void)setRating:(CGFloat)rating{
    _rating = (rating > 5.0)? 5.0 : rating;
    [self ratingDidChange];
}


-(void)ratingDidChange
{
    [self.tintLayer setBackgroundColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.57 alpha:1.00].CGColor];
    float barWitdhPercentage = (_rating/5.0f) *  (self.bounds.size.width);
    self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
}

- (UIImage*)starImage{
    
    NSString *strEncodeData = @"iVBORw0KGgoAAAANSUhEUgAAAOwAAAAmCAMAAADwfof0AAAAOVBMVEVHcEyRkpWRkpWSk5b09PX///+Rk5ePkJOmpqm2t7mUlZjJycvl5eaWl5qPkZOcnZ/f3+DV1daTlZeaxyeEAAAAE3RSTlMAevjo//8dU/T3ovz/0Tj0//659ok2agAAAVtJREFUeAHdl0eS60AMQ0Wqc1C6/2H/Sr9VDZszWmKwNR6cnqvo5UNElhfhBkR1fTHLDajzGt4sEwMxeZ/fWMMMlOp963aHF0AD/CtpiIFt9x4doAZsA7w/0AFiwDYAHaAGbANsB5gBMMBwgB4AAwwH2AEwwHCAHhDtI3rexab9EfkbQNSjPeL/pz2Tyr1LDYj6X6Re9zA3oNn92Mvjp04OlL3ZNZeuscsORK1W71QZq/xA6Om7BnndpmF2QPT4XGt7gV16YFvzp17VuGD4gWtHDVI3Di5qIOrc3O37jBkI6ufiN2H4AQHjz8tcZgZ6m4tOsUUKoAGQhA7wA2iALQ090I/74ZqdLQ09EHSczGVv6AA/gAacKo+z+iwLhh/oxziZx1ltSEMMBJ1OZtEDHeAF0ICqcT6rKzrAD1yHd6kH+PvvVhylB658quBZXVPHUX5Arg3xcOGnSAz8AywaWUh6NV+iAAAAAElFTkSuQmCC";
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
    
}

@end
