//
//  BBCell.m
//  xiaoshuo
//
//  Created by Jay on 28/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "BBCell.h"

@implementation BBCell
- (IBAction)action:(UIButton *)sender {
    
    
    
    NSMutableArray <NSString *>*list = [[NSUserDefaults standardUserDefaults] arrayForKey:@"list"].mutableCopy;
    if (!list) {
        list = [NSMutableArray array];
    }
    if ([list containsObject:self.url]) {
        [list removeObject:self.url];
    }else [list insertObject:self.url atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uodate" object:nil];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    UILongPressGestureRecognizer *l = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation)];
//    [self.imageView addGestureRecognizer:l];
}
//- (IBAction)press:(UILongPressGestureRecognizer *)sender {
//
//   NSMutableArray <NSString *>*list = [[NSUserDefaults standardUserDefaults] arrayForKey:@"list"].mutableCopy;
//    if (!list) {
//        list = [NSMutableArray array];
//    }
//    if ([list containsObject:self.url]) {
//        [list removeObject:self.url];
//    }else [list insertObject:self.url atIndex:0];
//
//    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"list"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (void)setUrl:(NSString *)url{
    
    _url = url;
    NSMutableArray <NSString *>*list = [[NSUserDefaults standardUserDefaults] arrayForKey:@"list"].mutableCopy;
    if (!list) {
        list = [NSMutableArray array];
    }
    if ([list containsObject:self.url]) {
        self.btn.selected = YES;
    }else self.btn.selected = NO;
    
}


//- (void)startAnimation{
//    self.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);    } completion:^(BOOL finished) {
//            self.userInteractionEnabled = YES;
//            [self endAnimation];
//        }];
//}
//- (void)endAnimation{
//    self.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.imageView.transform = CGAffineTransformIdentity;
//
//    } completion:^(BOOL finished) {
//        self.userInteractionEnabled = YES;
//        [self press:nil];
//    }];
//
//}
@end
