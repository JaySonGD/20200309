//
//  PCChartContentView.m
//  penco
//
//  Created by Jay on 12/8/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCChartContentView.h"

@implementation PCChartContentView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = self.safeAreaInsets;
    } else {
        // Fallback on earlier versions
    }
    
    CGRect chartFrame = CGRectMake(0, CGRectGetHeight(self.bounds)*0.75, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)*0.25);
    
    CGRect backFrame = CGRectMake(15+safeAreaInsets.left, safeAreaInsets.top, 44, 44);

    CGRect frame = CGRectMake(15+safeAreaInsets.left, safeAreaInsets.top+228, 90, 25);

    
    if (CGRectContainsPoint(chartFrame, point) || CGRectContainsPoint(backFrame, point) ||CGRectContainsPoint(frame, point)) {
        return YES;
    }
    return NO;
}

@end
