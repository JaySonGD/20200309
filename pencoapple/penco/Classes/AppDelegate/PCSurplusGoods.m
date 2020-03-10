//
//  PCSurplusGoods.m
//  penco
//
//  Created by Zhu Wensheng on 2019/9/10.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCSurplusGoods.h"

@implementation PCSurplusGoods

// 监听所有触摸，当屏幕被触摸，时钟将被重置
-(void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    
    if (!myidleTimer) [self resetIdleTimer];
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] > 0) {
        
        UITouchPhase phase= ((UITouch *)[allTouches anyObject]).phase;
        
        if (phase == UITouchPhaseBegan) {
            
            [self resetIdleTimer];
        }
    }
}

//重置时钟
-(void)resetIdleTimer {
    
    if (myidleTimer) [myidleTimer invalidate];
    
    //将超时时间由分钟转换成秒数
    int timeout = kApplicationTimeoutIn;
    
    myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

//当达到超时时间，发送APPSurplusGoods通知
-(void)idleTimerExceeded {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPSurplusGoods" object:nil];
    [self resetIdleTimer];
}

@end
