//
//  YTRouteRecord.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 11/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRouteRecord.h"
#import "YTLatLngEntity.h"

#import <CoreLocation/CoreLocation.h>

@interface YTRouteRecord ()
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@end

@implementation YTRouteRecord
- (void)addLocation:(YTLatLngEntity *)location{
    _endTime = [NSDate date];
    [self.locations addObject:location];
}

- (YTLatLngEntity *)startLocation{
    return self.locations.firstObject;
}


- (YTLatLngEntity *)endLocation{
    return self.locations.lastObject;
}


- (NSMutableArray<YTLatLngEntity *> *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}

- (NSString *)totalDistance{
    double distance = 0;
    if (self.locations.count > 1){
        CLLocation *currentLocation = [self.locations firstObject].currentLocation;
        
        for (YTLatLngEntity *latLngEntity in self.locations){
            distance += [latLngEntity.currentLocation distanceFromLocation:currentLocation];
            currentLocation = latLngEntity.currentLocation;
        }
    }
    //return distance;
    return [NSString stringWithFormat:@"%.2f",distance];
}


- (instancetype)init{
    self = [super init];
    if (self){
        _startTime = [NSDate date];
        _endTime = _startTime;
    }
    return self;
}

- (NSString *)totalDuration{
    //return [self.endTime timeIntervalSinceDate:self.startTime];
    return [NSString stringWithFormat:@"%ld",(NSInteger)[self.endTime timeIntervalSinceDate:self.startTime]];

}

- (NSString *)sTime{
    return [NSString stringWithFormat:@"%ld",(NSInteger)self.startTime.timeIntervalSince1970 * 1000];
}

@end
