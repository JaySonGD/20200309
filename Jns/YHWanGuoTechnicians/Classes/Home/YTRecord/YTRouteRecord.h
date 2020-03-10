//
//  YTRouteRecord.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 11/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTLatLngEntity;

NS_ASSUME_NONNULL_BEGIN

@interface YTRouteRecord : NSObject

@property (nonatomic, strong) NSMutableArray<YTLatLngEntity *>*locations;

//- (NSString *)title;
//- (NSString *)subTitle;

- (void)addLocation:(YTLatLngEntity *)location;

- (YTLatLngEntity *)startLocation;

- (YTLatLngEntity *)endLocation;

- (NSString *)totalDistance;

- (NSString *)totalDuration;

- (NSString *)sTime;


@end

NS_ASSUME_NONNULL_END
