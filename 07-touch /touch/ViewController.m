//
//  ViewController.m
//  touch
//
//  Created by pkss on 2017/5/12.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import "PreViewController.h"
#import "PHMPopViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *touchVie;

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //检测3D Touch
    [self check3DTouch];
}

-  (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 检测3D Touch
- (void)check3DTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //在self下创建一个新的3D Touch预览功能
        [self registerForPreviewingWithDelegate:(id)self sourceView:_touchVie];
    }
}
#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    //3D Touch防止重复加入
    if ([self.presentedViewController isKindOfClass:[PreViewController class]]) {
        return nil;
    }else {
        //触发预览功能时返回peekViewController
        PreViewController *peekViewController = [[PreViewController alloc] init];
        return peekViewController;
    }
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    PHMPopViewController *popViewController = [[PHMPopViewController alloc] init];
//    [self showDetailViewController:popViewController sender:self];
//    //Push Navigation
//   // [self showViewController:popViewController sender:self];
//}

//深入点击后转入PHMPopViewController
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    PHMPopViewController *popViewController = [[PHMPopViewController alloc] init];
    [self showDetailViewController:popViewController sender:self];
    //Push Navigation
    //[self showViewController:popViewController sender:self];
}
//用户有意修改了设备的3D Touch功能，重新检测
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self check3DTouch];
}


@end
