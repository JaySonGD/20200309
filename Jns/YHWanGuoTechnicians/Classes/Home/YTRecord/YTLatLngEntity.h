//
//  YTLatLngEntity.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 11/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTLatLngEntity : NSObject
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *pointTime;
//@property (nonatomic, strong) CLLocation *currentLocation;

- (instancetype)initWithLocation:(CLLocation *)location;
- (CLLocation *)currentLocation;
@end

NS_ASSUME_NONNULL_END
