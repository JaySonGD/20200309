//
//  NextViewController.m
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL interaction;
@property (nonatomic, strong) UIColor *topViewColor;
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@end

@implementation NextViewController

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(self.view.bounds.size.width - 26 - 24, 30, 26, 26);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        [self.contentView addSubview:_backButton];
        _backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _backButton;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listView.tableFooterView = [UIView new];
        _listView.contentInset = UIEdgeInsetsMake(self.topView.bounds.size.height, 0, 0, 0);
        _listView.scrollIndicatorInsets = _listView.contentInset;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _listView;
}

- (UIImageView *)topView{
    if (!_topView) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _topView.backgroundColor = self.topViewColor;
        _topView.contentMode = UIViewContentModeScaleAspectFill;
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topView.image = [UIImage imageNamed:self.imgName];
        [self.contentView addSubview:_topView];
    }
    return _topView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
}


- (void)dealloc{
    NSLog(@"%s", __func__);
}


- (instancetype)initWithColor:(UIColor *)color bgView:(UIView *)bgView
{
    self = [super init];
    if (self) {
        self.topViewColor = color;
        self.bgView = bgView;

    }
    return self;
}
- (void)configureUI{
    [self.view addSubview:self.bgView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = self.view.bounds;
    [self.view addSubview:self.contentView];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.listView];
    [self.contentView bringSubviewToFront:self.topView];
    [self.contentView bringSubviewToFront:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.view.userInteractionEnabled = YES;
    self.panGes = pan;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

///计算手势百分比,用来更新动画的进度
- (CGFloat )getPresentWith:(UIPanGestureRecognizer *)gesture{

    CGFloat present = 0;
    CGPoint point = [gesture translationInView:self.view];
    CGFloat height = self.view.frame.size.height  * 0.26;
    CGFloat y = point.y;
    self.listView.scrollEnabled = y <= 0 ;
    if (y > 0) {
        CGFloat final_y = y? y : (y * -1);
        present = final_y / height;
    }
    
    NSLog(@"%s-计算手势百分比-%f --- %f", __func__,point.y,present);
    return present;
}

- (void)panAction:(UIPanGestureRecognizer *)sender{

    if (self.listView.contentOffset.y <= -400)
    {
        CGFloat present = [self getPresentWith:sender];
        if (present == 0)
        {
            return;
        }
        
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:

            {
                CGFloat scale = 1 - 0.2 * present;
                CGFloat corner = 8.0 * present;
                            if( present < 0.9)
                            {
                                self.contentView.transform = CGAffineTransformMakeScale(scale, scale);
                                self.contentView.layer.cornerRadius = corner;
                            }
                            else
                            {
                                self.contentView.transform =CGAffineTransformIdentity;
                                self.contentView.layer.cornerRadius = 0;
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }

            }
                break;
            case UIGestureRecognizerStateEnded:
                
            {
                //手势结束,关闭标记为false
                self.interaction = NO;
                            if (present >= 0.9)
                            {
                                self.contentView.transform = CGAffineTransformIdentity;
                                self.contentView.layer.cornerRadius = 0;
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                            else
                            {
                                self.contentView.transform = CGAffineTransformIdentity;
                            }
                self.listView.scrollEnabled = YES;

            }
                break;
            default:
            {
                self.contentView.transform = CGAffineTransformIdentity;
                self.listView.scrollEnabled = YES;

            }
                break;
        }
    }else {
        self.listView.scrollEnabled = YES;
    }
  }

- (void)backButtonClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
