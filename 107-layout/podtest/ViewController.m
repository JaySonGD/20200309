//
//  ViewController.m
//  podtest
//
//  Created by Jay on 17/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
//#import <YHLibSrc/MBProgressHUD+MJ.h>
//#import <YHLibSrc/YHCategoryHeader.h>

#import "UIView+Layout.h"

@interface ViewController ()
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];

    
    [self.view addSubview:redView];
    self.redView = redView;
    __weak typeof(self) weakSelf = self;
    
    [redView setLayout:^(LayoutModel * _Nonnull layout) {
//        layout.lyHeight().relativeToViewBlock(weakSelf.view)
//                         .multiplierBlock(0.6);
//        layout.lyWidth().constantBlock(200);
//        layout.lyCenterX();
//        layout.lyCenterY();
        
        layout.lyleft().constantBlock(10);
        layout.lyTop().constantBlock(10);
        layout.lyRight().constantBlock(-10);
        layout.lyButtom().constantBlock(-10);
    }];


    UISwitch *sw = [UISwitch new];
    [redView addSubview:sw];
    [sw setLayout:^(LayoutModel * _Nonnull layout) {
        layout.lyCenterY();
        layout.lyCenterX();
    }];
    
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [redView addSubview:add];
    [add setLayout:^(LayoutModel * _Nonnull layout) {
        layout.lyTop().constantBlock(10);
        
        layout.lyleft().constantBlock(30);
    }];


}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.heightConstraint.constant = 300;
    self.redView.lyHeight.constant = 100;
//    [self.view removeConstraint:self.heightConstraint];
//
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100]];
}

@end
