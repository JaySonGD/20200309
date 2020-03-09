//
//  TableViewController.m
//  NativeAdvancedExample
//
//  Created by Jay on 25/12/2019.
//  Copyright © 2019 Google. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#import "YYNativeAdView.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

static NSString *const TestAdUnit = @"ca-app-pub-3940256099942544/3986624511";

@interface TableViewController ()<GADUnifiedNativeAdLoaderDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdDelegate>
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong)  GADUnifiedNativeAd *nativeAd;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) YYNativeAdView *adview;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAd:)];
}

- (IBAction)refreshAd:(id)sender {
    // Loads an ad for unified native ad.
    self.adview = [YYNativeAdView yy_NativeAdView:self nativeAdType:YYNativeAdTypeLandscape didRecordImpression:^{
        [self.tableView reloadData];
    }];

    return;
//    GADNativeAdMediaAdLoaderOptions *mediaAdOptions = [[GADNativeAdMediaAdLoaderOptions alloc] init];
//    mediaAdOptions.mediaAspectRatio = GADMediaAspectRatioPortrait;//GADMediaAspectRatioLandscape;// GADMediaAspectRatioPortrait;//GADMediaAspectRatioSquare;//GADMediaAspectRatioLandscape;
//    //
//    //    GADMultipleAdsAdLoaderOptions *multipleAdsOptions = [[GADMultipleAdsAdLoaderOptions alloc] init];
//    //    multipleAdsOptions.numberOfAds = 3;
//    //    //图片相关
//    //    GADNativeAdImageAdLoaderOptions *imageOptions = [[GADNativeAdImageAdLoaderOptions alloc] init];
//    //    imageOptions.shouldRequestMultipleImages = YES;
//    
//    //设置logo的位置
//    //    GADNativeAdViewAdOptions *adViewOptions = [[GADNativeAdViewAdOptions alloc] init];
//    //    adViewOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomRightCorner;
//    
//    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
//    
//    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:TestAdUnit
//                                       rootViewController:self
//                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
//                                                  options:@[ videoOptions ]];
//    self.adLoader.delegate = self;
//    [self.adLoader loadRequest:[GADRequest request]];
}


#pragma mark GADUnifiedNativeAdLoaderDelegate implementation

/// Called when adLoader fails to load an ad.
//- (void)adLoader:(nonnull GADAdLoader *)adLoader
//didFailToReceiveAdWithError:(nonnull GADRequestError *)error{
//
//}


//- (void)adLoader:(nonnull GADAdLoader *)adLoader
//didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd{
//    self.nativeAd = nativeAd;
//
//    [self.tableView reloadData];
//
//}


//#pragma mark GADVideoControllerDelegate implementation
//
//- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
//    //self.videoStatusLabel.text = @"Video playback has ended.";
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.adview?1:0;

//    return self.nativeAd?1:0;
}

//#pragma mark - 修改约束multiplier属性
//- (NSLayoutConstraint *)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
//        [NSLayoutConstraint deactivateConstraints:@[constraint]];
//        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
//        newConstraint.priority = constraint.priority;
//        newConstraint.shouldBeArchived = constraint.shouldBeArchived;
//        newConstraint.identifier = constraint.identifier;
//        [NSLayoutConstraint activateConstraints:@[newConstraint]];
//    return newConstraint;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    if (!self.adview) {
        return cell1;
    }
    [cell1.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [cell1.contentView addSubview:self.adview];

    UIView *view = self.adview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *vod_pic = view.superview;
    [view.superview addConstraints:@[
                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],

                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                     ]];



    return cell1;
////    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ad" ];
//
//    // Configure the cell...
//    GADUnifiedNativeAdView *nativeAdView = self.adview.subviews.firstObject; //cell.contentView.subviews.firstObject;
//
//
//
//    GADUnifiedNativeAd *nativeAd = self.nativeAd;
//    nativeAdView.nativeAd = nativeAd;
//
//    // Set ourselves as the ad delegate to be notified of native ad events.
//    nativeAd.delegate = self;
//
//    // Populate the native ad view with the native ad assets.
//    // The headline and mediaContent are guaranteed to be present in every native ad.
//    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
//    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
//
//    // This app uses a fixed width for the GADMediaView and changes its height
//    // to match the aspect ratio of the media content it displays.
//    if (nativeAd.mediaContent.aspectRatio > 0) {
//
////        cell.r = [self changeMultiplierOfConstraint:cell.r multiplier:nativeAd.mediaContent.aspectRatio];
//
//    }else{
////        cell.r = [self changeMultiplierOfConstraint:cell.r multiplier:1000];
//    }
//
//    if (nativeAd.mediaContent.hasVideoContent) {
//        // By acting as the delegate to the GADVideoController, this ViewController
//        // receives messages about events in the video lifecycle.
//        nativeAd.mediaContent.videoController.delegate = self;
//
//        //self.videoStatusLabel.text = @"Ad contains a video asset.";
//    } else {
//        //self.videoStatusLabel.text = @"Ad does not contain a video.";
//    }
//
//    // These assets are not guaranteed to be present. Check that they are before
//    // showing or hiding them.
//    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
//    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
//
//    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
//                                                 forState:UIControlStateNormal];
//    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
//
//    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
//    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;
//
//    ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating];
//    nativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;
//
//    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
//    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;
//
//    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
//    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;
//
//    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
//    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
//
//    // In order for the SDK to process touch events properly, user interaction
//    // should be disabled.
//    nativeAdView.callToActionView.userInteractionEnabled = NO;
//
//
//
////    [cell1.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        [obj removeFromSuperview];
////    }];
////    [cell1.contentView addSubview:self.adview];
////
////    UIView *view = self.adview;
////    view.translatesAutoresizingMaskIntoConstraints = NO;
////    UIView *vod_pic = view.superview;
////    [view.superview addConstraints:@[
////                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
////
////                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
////                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
////                                     [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:vod_pic attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
////                                     ]];
//
//    return cell1;
}


//- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
//    double starRating = numberOfStars.doubleValue;
//    if (starRating >= 5) {
//        return [UIImage imageNamed:@"stars_5"];
//    } else if (starRating >= 4.5) {
//        return [UIImage imageNamed:@"stars_4_5"];
//    } else if (starRating >= 4) {
//        return [UIImage imageNamed:@"stars_4"];
//    } else if (starRating >= 3.5) {
//        return [UIImage imageNamed:@"stars_3_5"];
//    } else {
//        return nil;
//    }
//}
//

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
