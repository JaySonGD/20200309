//
//  PCSurplusGoods.h
//  penco
//
//  Created by Zhu Wensheng on 2019/9/10.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kApplicationTimeoutIn 60
#define kApplicationDidTimeoutNotification @"APPSurplusGoods"

@interface PCSurplusGoods : UIApplication {
    
    NSTimer *myidleTimer;
}

-(void)resetIdleTimer;

@end
NS_ASSUME_NONNULL_END
