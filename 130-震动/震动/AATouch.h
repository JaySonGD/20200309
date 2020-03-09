//
//  AATouch.h
//  震动
//
//  Created by Jay on 26/7/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^Action) (NSInteger buttonIndex);

@interface AATouch : NSObject
- (void)popTouchView:(UIView *)view
               title:(NSArray *)titles
                icon:(NSArray *)icons
         actionBlock:(Action)block;

@end

NS_ASSUME_NONNULL_END
