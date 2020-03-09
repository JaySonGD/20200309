//
//  AATouch.m
//  震动
//
//  Created by Jay on 26/7/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "AATouch.h"


#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define KMinlistViewWidth (KScreenWidth * 0.5 + KlistViewcCellHeight)
#define KlistViewWidth ((KMinlistViewWidth > 250)? 250 : KMinlistViewWidth)

#define KlistViewcCellHeight 44
#define KMaxlistViewHeight (6 * KlistViewcCellHeight)



@interface AATouch ()

@property (nonatomic, weak) UIView *superview;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UIView *list;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;

@property (nonatomic, weak) Action block;


@end

@implementation AATouch

- (void)popTouchView:(UIView *)view
       title:(NSArray *)titles
        icon:(NSArray *)icons actionBlock:(nonnull Action)block{

    
    self.block = block;
    self.icons = icons;
    self.titles = titles;
    self.superview = view.superview;
    self.view = view;
    self.viewRect = view.frame;
    view.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [view addGestureRecognizer:longP];

}


- (UIImage *)nomalSnapshotImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}




- (void)longAction:(UILongPressGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:0.5 animations:^{
                sender.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];//重度
                [generator prepare];
                [generator impactOccurred];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = [UIScreen mainScreen].bounds;
                [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
                [[UIApplication sharedApplication].keyWindow addSubview:btn];

                UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,btn.bounds.size.width,btn.bounds.size.height)];
                toolbar.barStyle   = UIBarStyleBlack;
                toolbar.alpha = 0.0;
                toolbar.userInteractionEnabled = NO;
                [btn addSubview:toolbar];
                self.toolbar = toolbar;

                CGPoint pt =  sender.view.center;
                CGFloat h = [UIScreen mainScreen].bounds.size.height * 0.5;
                CGFloat w = [UIScreen mainScreen].bounds.size.width * 0.5;
                BOOL isRight;
                if (pt.x > w) {
                    isRight = NO;
                }else{
                    isRight = YES;
                }
                
                BOOL isTop;
                if (pt.y > h) {
                    isTop = YES;
                }else{
                    isTop = NO;
                }
                
                NSString *d;
                if (isRight) {
                    if (isTop) {
                        d = @"right-top";
                    }else{
                        d = @"right-buttom";
                    }
                    
                }else{
                    if (isTop) {
                        d = @"left-top";
                    }else{
                        d = @"left-buttom";
                    }
                }
                
                UIView *list = [[UIView alloc] init];
                //list.backgroundColor = [UIColor whiteColor];
                //list.frame = CGRectMake(0, 0, 200, 100);
                CGFloat x ;
                CGFloat y ;
                if ([d isEqualToString:@"right-top"]) {
                    x = self.viewRect.origin.x - self.viewRect.size.width * 0.1;
                    y = self.viewRect.origin.y - KlistViewcCellHeight * self.titles.count - 10 - self.viewRect.size.height * 0.1;
                }else if ([d isEqualToString:@"right-buttom"]){
                    x = self.viewRect.origin.x - self.viewRect.size.width * 0.1;
                    y = CGRectGetMaxY(self.viewRect) + 10 + self.viewRect.size.height * 0.1;
                }else if ([d isEqualToString:@"left-top"]){
                    //KlistViewWidth, KlistViewcCellHeight * self.titles.count
                    x = CGRectGetMaxX(self.viewRect) - KlistViewWidth + self.viewRect.size.width * 0.1;
                    y = self.viewRect.origin.y - KlistViewcCellHeight * self.titles.count - 10 - self.viewRect.size.height * 0.1;
                }else{
                    x = CGRectGetMaxX(self.viewRect) - KlistViewWidth + self.viewRect.size.width * 0.1;
                    y = CGRectGetMaxY(self.viewRect) + 10 + self.viewRect.size.height * 0.1;
                }
                

                [btn addSubview:list];
                self.list = list;
                
                CGRect rectInWindow = [sender.view convertRect:sender.view.bounds toView:btn];
                
                [sender.view removeFromSuperview];
                sender.view.frame = rectInWindow;
                [btn addSubview:sender.view];
                
//                UIImageView *iv = [[UIImageView alloc] initWithFrame:self.viewRect];
//                [btn addSubview:iv];
//                iv.image = [self nomalSnapshotImage:sender.view];
//                self.iv = iv;
//                iv.contentMode = UIViewContentModeScaleAspectFit;
//                iv.transform = CGAffineTransformMakeScale(0.8, 0.8);

                list.frame = rectInWindow;
                UIToolbar *listToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, KlistViewWidth, KlistViewcCellHeight * self.titles.count)];
                listToolbar.alpha = 0.97;
                list.clipsToBounds = YES;
                [list addSubview:listToolbar];
                list.layer.cornerRadius = 10;
                list.layer.masksToBounds = YES;
                
                
                [self.titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:obj forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:self.icons[idx]] forState:UIControlStateNormal];
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
                    btn.frame = CGRectMake(0, KlistViewcCellHeight * idx, KlistViewWidth, KlistViewcCellHeight);
                    [list addSubview:btn];
                    btn.tag = idx;
                    [btn addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), KlistViewWidth, 0.5)];
                    line.backgroundColor = [UIColor colorWithRed:0.68 green:0.67 blue:0.69 alpha:1.00];//[UIColor redColor];
                    [list addSubview:line];
                }];
                
                
                [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
                    sender.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    sender.view.userInteractionEnabled = NO;
                    toolbar.alpha = 0.9;
                    list.frame = CGRectMake(x, y, KlistViewWidth, KlistViewcCellHeight * self.titles.count);

                } completion:^(BOOL finished) {
                    
                    
                  
                    
                    
                }];
            }];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"%s", __func__);
            break;
            
        default:
            break;
    }
}

- (void)btnClose:(UIButton *)sender{
    
    [self close:(UIButton *)self.toolbar.superview];
    !(_block)? : _block(sender.tag);

}


- (void)close:(UIButton *)sender{
    
    UIView *red = self.view;
 
    
    [UIView animateWithDuration:0.25 animations:^{
        self.toolbar.alpha = 0.0;
        red.transform = CGAffineTransformIdentity;
        self.list.frame = red.frame;
        self.list.alpha = 0.0;

        
    } completion:^(BOOL finished) {
        red.userInteractionEnabled = YES;
        [red removeFromSuperview];
        red.frame = self.viewRect;
        [self.superview addSubview:red];
        
        [sender removeFromSuperview];
    }];
}


@end
