//
//  UIView+Touch.m
//  震动
//
//  Created by Jay on 26/7/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "UIView+Touch.h"

@implementation UIView (Touch)



//- (void)setTouch:(BOOL)touch{
//    
//    
//    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//    [self addGestureRecognizer:longP];
//}
//
//
//- (void)longAction:(UILongPressGestureRecognizer *)sender{
//    switch (sender.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            [UIView animateWithDuration:0.5 animations:^{
//                sender.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
//            } completion:^(BOOL finished) {
//                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];//重度
//                [generator prepare];
//                [generator impactOccurred];
//                
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                btn.frame = [UIScreen mainScreen].bounds;
//                [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//                
//                UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,btn.bounds.size.width,btn.bounds.size.height)];
//                toolbar.barStyle   = UIBarStyleBlack;
//                toolbar.alpha = 0.0;
//                toolbar.userInteractionEnabled = NO;
//                
//                [btn addSubview:toolbar];
//                [[UIApplication sharedApplication].keyWindow addSubview:btn];
//                
//                CGRect rectInWindow = [sender.view convertRect:sender.view.bounds toView:btn];
//                [sender.view removeFromSuperview];
//                sender.view.frame = rectInWindow;
//                [btn addSubview:sender.view];
//                
//                [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
//                    sender.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                    sender.view.userInteractionEnabled = NO;
//                    toolbar.alpha = 0.9;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }];
//            
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//            NSLog(@"%s", __func__);
//            break;
//            
//        default:
//            break;
//    }
//}


@end
