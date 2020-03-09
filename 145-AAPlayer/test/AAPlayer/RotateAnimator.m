
#import "RotateAnimator.h"

@implementation RotateAnimator

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC  AAFullController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = containerView.bounds;
    [containerView addSubview:toViewController.view];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.frame = containerView.bounds;
    [containerView addSubview:fromViewController.view];
    
    //播放器视图
    UIView* playView = [fromViewController.view viewWithTag:1234];
    
    BOOL isPresent = [fromViewController.presentedViewController isEqual:toViewController];//如果底层的视图弹出的视图是顶层的，那么是present出来的
    
    if (isPresent) {
        [containerView bringSubviewToFront:fromViewController.view];
        
//        CGRect playViewSmallFrame = [[playView valueForKeyPath:@"playViewSmallFrame"] CGRectValue];
//        playView.frame = playViewSmallFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
//            playView.transform = CGAffineTransformMakeRotation(M_PI_2);
//            playView.bounds = CGRectMake(0, 0, CGRectGetHeight(playView.superview.bounds), CGRectGetWidth(playView.superview.bounds));
//            playView.center = CGPointMake(CGRectGetMidX(playView.superview.bounds), CGRectGetMidY(playView.superview.bounds));
//            [playView layoutIfNeeded];

            
//            playView.frame  = CGRectMake(0, 0, size.height, size.width);
//            playView.transform = CGAffineTransformMakeRotation(M_PI_2);
//            playView.center = playView.superview.center;
//            toViewController.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//            [playView layoutIfNeeded];

        } completion:^(BOOL finished) {
            playView.transform = CGAffineTransformIdentity;
            [playView removeFromSuperview];
            [toViewController.view addSubview:playView];
            playView.frame = toViewController.view.bounds;
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
            
        }];
    }else{
        [containerView bringSubviewToFront:fromViewController.view];
        playView = [fromViewController.view viewWithTag:1234];
        
        
        CGRect playViewSmallFrame = [[playView valueForKeyPath:@"playViewSmallFrame"] CGRectValue];
        
//        playView.frame = CGRectMake(0, 0, CGRectGetWidth(playView.superview.bounds), CGRectGetHeight(playView.superview.bounds));

        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

//            playView.transform = CGAffineTransformMakeRotation(M_PI_2);
//            playView.frame = CGRectMake(CGRectGetMinY(playViewSmallFrame), CGRectGetMinX(playViewSmallFrame), CGRectGetHeight(playViewSmallFrame),CGRectGetWidth(playViewSmallFrame));
//
//            fromViewController.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
//            [playView layoutIfNeeded];

            
        } completion:^(BOOL finished) {
            
            
            [playView removeFromSuperview];

            
            if ([toViewController isKindOfClass:[UITabBarController class]]) {
                UIViewController* navvc = ((UITabBarController*)toViewController).selectedViewController;
                if ([navvc isKindOfClass:[UINavigationController class]]) {
                    UIViewController* vc = ((UINavigationController*)navvc).viewControllers.lastObject;
                    [vc.view addSubview:playView];
                }else [navvc.view addSubview:playView];
                
            }else if ([toViewController isKindOfClass:[UINavigationController class]]) {
                UIViewController* vc = ((UINavigationController*)toViewController).viewControllers.lastObject;
                [vc.view addSubview:playView];
            }else{
                [toViewController.view addSubview:playView];
            }
            
            
            playView.transform = CGAffineTransformIdentity;
            playView.frame = playViewSmallFrame;
            
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
            
        }];
    }
    
}

@end
