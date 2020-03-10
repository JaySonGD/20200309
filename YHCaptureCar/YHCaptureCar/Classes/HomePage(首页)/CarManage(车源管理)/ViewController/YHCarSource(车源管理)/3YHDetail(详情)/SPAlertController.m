//
//  SPAlertController.m
//  YHCaptureCar
//
//  Created by Jay on 15/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "SPAlertController.h"

@interface SPAlertController ()
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray <UIButton *>*actions;
@property (nonatomic, strong) NSMutableDictionary *handlers;

@end

@implementation SPAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message{
    SPAlertController *alertVC = [[self alloc] init];
    alertVC.alertTitle = title;
    alertVC.message = message;
    alertVC.actions = @[].mutableCopy;
    alertVC.handlers = @{}.mutableCopy;
    return alertVC;
}

- (void)addActionWithTitle:(NSString *)title
                     style:(SPAlertActionStyle)style
                   handler:(void (^)(SPAlertController *))handler{
    UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAction setTitle:title forState:UIControlStateNormal];
    NSArray *styleColors = @[YHNaviColor,YHColor(33, 33, 33),[UIColor redColor]];
    [btnAction setTitleColor:styleColors[style] forState:UIControlStateNormal];
    btnAction.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btnAction addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actions addObject:btnAction];
    if (handler) {
        [self.handlers setValue:handler forKey:title];
    }
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.view addSubview:({
        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        coverBtn.frame = [UIScreen mainScreen].bounds;
        coverBtn;
    })];
    
    NSInteger count = self.actions.count;
    NSInteger section = (count > 2)? count:(count? 1 : 0);
    [self.view addSubview:({
  
        UITabBar *contentView = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 70, 125 + 51 * section)];
        contentView.userInteractionEnabled = YES;
        contentView.center = self.view.center;
        YHViewRadius(contentView, 10);
        [contentView addSubview:({
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame = CGRectMake(contentView.bounds.size.width - 42, 0, 42, 42);
            [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            
            closeBtn;
        })];
        
        [contentView addSubview:({
            UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, contentView.bounds.size.width, 44)];
            titleLB.text = self.alertTitle;
            titleLB.font = [UIFont systemFontOfSize:15];
            titleLB.textColor = YHColor(33, 33, 33);
            titleLB.textAlignment = NSTextAlignmentCenter;
            titleLB;
        })];
        
        [contentView addSubview:({
            UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, contentView.bounds.size.width, 40)];
            titleLB.text = self.message;
            titleLB.font = [UIFont systemFontOfSize:13];
            titleLB.textColor = YHColor(117, 117, 117);
            titleLB.textAlignment = NSTextAlignmentCenter;
            titleLB;
        })];
        if (section) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 125 , contentView.bounds.size.width, 1)];
            line.backgroundColor = YHColor(206, 206, 206);
            [contentView addSubview:line];

            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width * 0.5 - 0.5, 126 , 1, 50)];
            line2.backgroundColor = YHColor(206, 206, 206);
            [contentView addSubview:line2];
            
            self.actions.firstObject.frame = CGRectMake(0, 126, contentView.bounds.size.width * 0.5 - 0.5, 50);
             self.actions.lastObject.frame = CGRectMake(contentView.bounds.size.width * 0.5 + 0.5, 126, contentView.bounds.size.width * 0.5 - 0.5, 50);
            [contentView addSubview:self.actions.firstObject];
            [contentView addSubview:self.actions.lastObject];

        }
 

        contentView;
    })];
    
    [self.view.subviews[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth - 70);
        make.height.mas_equalTo(125 + 51 * section);
    }];
}

- (void)tapAction:(UIButton *)sender{
    
    void (^handler)(SPAlertController *)  = self.handlers[sender.currentTitle];
    !(handler)? : handler(self);

    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
