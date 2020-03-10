//
//  YHPersonCenterVCView.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/5/7.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHPersonCenterVCView.h"

@implementation YHPersonCenterVCView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if(self.isMask){
        
        CGPoint redBtnPoint = [self convertPoint:point toView:self.btnMask];
        if ( [self.btnMask pointInside:redBtnPoint withEvent:event]) {
            return self.btnMask;
        }
        
       return nil;
        
    }
    
    for (UIView *view in self.headerV.subviews) {
        if([view isKindOfClass:[UIButton class]] && view.tag){
            CGPoint redBtnPoint = [self convertPoint:point toView:view];
            if (self.headerV.alpha && [view pointInside:redBtnPoint withEvent:event]) {
                return view;
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
