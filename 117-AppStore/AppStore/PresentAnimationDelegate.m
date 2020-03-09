//
//  PresentAnimationDelegate.m
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//
#import "PresentAnimationDelegate.h"

typedef NS_ENUM(NSInteger, PresentAnimationType) {
    PresentAnimationTypePresented,          // regular table view
    PresentAnimationTypePresenting         // preferences style table view
};


@interface PresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) PresentAnimationType presentType;
@property (nonatomic, copy)void (^animations)(CompleteBlock,UIView *);


- (instancetype)initWithPresentType:(PresentAnimationType )type
                         animations:(void (^)(CompleteBlock,UIView *))animations;

@end


@interface PresentAnimationDelegate ()<UIViewControllerTransitioningDelegate>
//@property (nonatomic, strong) UIViewController *presentingVC;
@property (nonatomic, copy)void (^presentedAnimations)(CompleteBlock,UIView *);
@property (nonatomic, copy)void (^presentingAnimations)(CompleteBlock,UIView *);

@end

@implementation PresentAnimationDelegate


- (void)animationWithPresented:(UIViewController *)presented
                    presenting:(UIViewController *)presenting
           presentedAnimations:(void (^)(CompleteBlock,UIView *))presentedAnimations
          presentingAnimations:(void (^)(CompleteBlock,UIView *))presentingAnimations
                      complete:(void (^)(BOOL))complete{

    presenting.transitioningDelegate = self;
//    self.presentingVC = presenting;
    self.presentedAnimations = presentedAnimations;
    self.presentingAnimations = presentingAnimations;
    
    [presented presentViewController:presenting animated:YES completion:^{
        complete(true);
    }];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentAnimation alloc] initWithPresentType:PresentAnimationTypePresenting animations:self.presentingAnimations];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[PresentAnimation alloc] initWithPresentType:PresentAnimationTypePresented animations:self.presentedAnimations];
}

//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return nil;
//}
//
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return nil;
//}


@end



@implementation PresentAnimation



- (instancetype)initWithPresentType:(PresentAnimationType )type
                         animations:(void (^)(CompleteBlock,UIView *))animations{
    self = [super init];
    if (self) {
        self.presentType = type;
        self.animations = animations;
        
    }
    return self;
}



- (NSTimeInterval)timeInterval{
    return 1;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.presentType) {
        case PresentAnimationTypePresenting:
            [self presenting:transitionContext];
            break;
        case PresentAnimationTypePresented:
            [self presented:transitionContext];
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [self timeInterval];
}

-(void)presenting:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];//ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];//NextViewController
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromVC || !toVC || !fromView || !toView) {
        return;
    }
    
    UIView *animationView = transitionContext.containerView;
    [animationView addSubview:toView];
    
    CompleteBlock complete = ^(BOOL finished) {
        if (finished && !transitionContext.transitionWasCancelled) {
            [transitionContext completeTransition:YES];
        }else{
            [toView removeFromSuperview];
            fromView.hidden = NO;
            [transitionContext completeTransition:NO];
        }
    };
    self.animations(complete,animationView);

}
-(void)presented:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];//NextViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];//ViewController
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromVC || !toVC || !fromView || !toView) {
        return;
    }
    
    UIView *animationView = transitionContext.containerView;
    [animationView addSubview:toView];
    [animationView bringSubviewToFront:fromView];

    CompleteBlock complete = ^(BOOL finished) {
        if (finished && !transitionContext.transitionWasCancelled) {
            [transitionContext completeTransition:YES];
        }else{
            [toView removeFromSuperview];
            fromView.hidden = NO;
            [transitionContext completeTransition:NO];
        }
    };
    
    
    self.animations(complete,animationView);
}


//-(void)presenting1:(id<UIViewControllerContextTransitioning>)transitionContext{
//
//    ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    NextViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//
//    if (!fromVC || !toVC || !fromView || !toView) {
//        return;
//    }
//
//    UIView *animationView = transitionContext.containerView;
//    [animationView addSubview:toView];
//
//    CGRect rect = [fromVC.tableView convertRect:self.cell.frame toView:fromView];
//
//    toVC.contentView.frame = rect;
//    toVC.contentView.layer.cornerRadius = 8.0;
//    toVC.contentView.layer.masksToBounds = YES;
//
//    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        self.cell.contentView.hidden = YES;
//        [animationView layoutIfNeeded];
//        toVC.contentView.frame = CGRectMake(30, 60, fromView.frame.size.width - 60, fromView.frame.size.height - 120);
//    } completion:^(BOOL finished) {
//
//
//        [UIView animateWithDuration:[self timeInterval] - 0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
//            [animationView layoutIfNeeded];
//            toVC.contentView.frame = fromView.frame;
//            toVC.contentView.layer.cornerRadius = 0.0;
//            toVC.contentView.layer.masksToBounds = YES;
//
//        } completion:^(BOOL finished) {
//
//            self.cell.contentView.hidden = NO;
//            if (finished && !transitionContext.transitionWasCancelled) {
//                [transitionContext completeTransition:YES];
//            }else{
//                [toView removeFromSuperview];
//                fromView.hidden = NO;
//                [transitionContext completeTransition:NO];
//            }
//        }];
//
//
//
//    }];
//}

//-(void)presented1:(id<UIViewControllerContextTransitioning>)transitionContext{
//
//    NextViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//
//    if (!fromVC || !toVC || !fromView || !toView) {
//        return;
//    }
//
//    UIView *animationView = transitionContext.containerView;
//
//    toView.frame = [animationView convertRect:fromView.frame fromView:fromView.superview];
//
//
//    [animationView addSubview:toView];
//    [animationView bringSubviewToFront:fromView];
//
//
//    CGRect rect = self.cellFrame;
//    self.cell.alpha = 0.0;
//    fromVC.bgView.alpha = 0.0;
//    fromView.backgroundColor = [UIColor clearColor];
//
//
//    [UIView animateWithDuration:[self timeInterval] - 0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
//
//        [animationView layoutIfNeeded];
//        fromVC.contentView.layer.cornerRadius = 8.0;
//        fromVC.contentView.layer.masksToBounds = YES;
//        fromVC.backButton.alpha = 0.0;
//        fromVC.contentView.frame = rect;
//        fromVC.topView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
//        fromVC.topView.layer.cornerRadius = 8.0;
//        fromVC.topView.layer.masksToBounds = YES;
//        fromVC.listView.alpha = 0;
//
//    } completion:^(BOOL finished) {
//
//        self.cell.alpha = 1.0;
//        if (finished && !transitionContext.transitionWasCancelled) {
//            [transitionContext completeTransition:YES];
//        }else{
//            [toView removeFromSuperview];
//            fromView.hidden = NO;
//            [transitionContext completeTransition:NO];
//        }
//    }];
//
//}

@end
