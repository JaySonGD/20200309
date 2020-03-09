//
//  ViewController.m
//  WJStatusBarHUD
//
//  Created by 吴计强 on 16/2/29.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ViewController.h"
#import "WJStatusBarHUD.h"
#import "FullViewController.h"

static UIWindow *window_;


@interface ViewController ()
@property (nonatomic, weak)  UIView *v ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UITextView *v = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200)];
//    [self.view addSubview:v];
//    v.text = @"    window_.backgroundColor = [UIColor redColor]";
//    v.backgroundColor = [UIColor orangeColor];
//    self.v = v;
}

- (void)test{
    window_.hidden = YES;
    window_ = [[UIWindow alloc]init];
    window_.backgroundColor = [UIColor redColor];
    window_.windowLevel = UIWindowLevelNormal;
    window_.frame = CGRectMake(0, 0, 375, 300);
    window_.hidden = NO;
    window_.rootViewController = [FullViewController new];

    
    [window_ addSubview:self.v];
    self.v.frame = window_.bounds;

}

- (BOOL)shouldAutorotate{
    return NO;
}

/// 旋转支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (window_) {
        window_ = nil;
        [UIViewController attemptRotationToDeviceOrientation];
        return;
    }
    [self test];
}

- (IBAction)clickInfo:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:{
            [WJStatusBarHUD showSuccessImageName:nil text:nil];
        }
            break;
        case 102:{
            [WJStatusBarHUD showErrorImageName:nil text:nil];
        }
            break;
        case 103:{
            [WJStatusBarHUD showWarningImageName:nil text:nil];
        }
            break;
        case 104:{
            [WJStatusBarHUD showLoading:nil];
        }
            break;
        case 105:{
            [WJStatusBarHUD hide];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
