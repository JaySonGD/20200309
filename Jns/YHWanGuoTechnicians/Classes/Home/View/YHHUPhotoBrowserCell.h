//
//  HUPhotoBrowserCell.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef HUPhotoBrowser_const_h
#define HUPhotoBrowser_const_h

#define kScreenRect [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenRatio kScreenWidth / kScreenHeight
#define kScreenMidX CGRectGetMaxX(kScreenRect)
#define kScreenMidY CGRectGetMaxY(kScreenRect)

#endif

#define kPhotoBrowserCellID @"HUPhotoBrowserCell"
static NSString * const kPhotoCellDidZommingNotification = @"kPhotoCellDidZommingNotification";
static NSString * const kPhotoCellDidImageLoadedNotification = @"kPhotoCellDidImageLoadedNotification";

@interface YHHUPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

//@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)resetZoomingScale;

//- (void)configureCellWithURLStrings:(NSString *)URLStrings;

@property (nonatomic, copy) void(^tapActionBlock)(UITapGestureRecognizer *tapGesture);

@end
