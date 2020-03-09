//
//  PresentAnimationDelegate.h
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompleteBlock)(BOOL);

@interface PresentAnimationDelegate : NSObject

- (void)animationWithPresented:(UIViewController *)presented
                    presenting:(UIViewController *)presenting
           presentedAnimations:(void (^)(CompleteBlock,UIView *))presentedAnimations
          presentingAnimations:(void (^)(CompleteBlock,UIView *))presentingAnimations
                      complete:(void (^)(BOOL))complete;
@end



NS_ASSUME_NONNULL_END
