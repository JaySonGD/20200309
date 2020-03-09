//
//  ViewController.m
//  Boom
//
//  Created by Jay on 3/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Boom.h"

#import "DDSliderView.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UIImageView *MYVIEW;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DDSliderView *s = [[DDSliderView alloc] initWithFrame:CGRectMake(50, 100, 300, 50)];
//    s.value = 0.5;
    s.bufferValue = 0.5001;
//    [s setBackgroundImage:[UIImage imageNamed:@"dd_slider_dd"] forState:UIControlStateNormal];
    s.minimumTrackImage = [UIImage imageNamed:@"dd_progressbar_n_dd"];
    s.bufferTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    s.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [self.view addSubview:s];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_MYVIEW boom];
}

@end
