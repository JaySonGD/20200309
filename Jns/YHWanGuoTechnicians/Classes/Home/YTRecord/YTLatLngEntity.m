//
//  YTLatLngEntity.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 11/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTLatLngEntity.h"

@implementation YTLatLngEntity
- (CLLocation *)currentLocation{
    return [[CLLocation alloc] initWithLatitude:[self.lat doubleValue] longitude:[self.lng doubleValue]];
}

- (instancetype)initWithLocation:(CLLocation *)location{
    self = [super init];
    if (self) {
        self.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        self.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        self.pointTime = [NSString stringWithFormat:@"%ld",(NSInteger)location.timestamp.timeIntervalSince1970*1000];
    }
    return self;
}
@end
