//
//  PCTestRecordController.m
//  penco
//
//  Created by Jay on 28/9/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCTestRecordController.h"

#import "UIViewController+RESideMenu.h"
#import "YHCommon.h"

#import <Masonry.h>

#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "YBPopupMenu.h"
#import "PCPersonModel.h"

@interface PCTestRecordController ()<UIScrollViewDelegate,YBPopupMenuDelegate>
@property (nonatomic, weak) UIView *topBox;
@property (nonatomic, weak) UIScrollView *contentBox;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, weak) UIButton *arrowBtn;
@property (nonatomic, weak) UILabel *nameLB;


@property (nonatomic, strong) NSMutableArray<PCPersonModel *> *models;
@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation PCTestRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    [self getUsers];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.contentBox setContentOffset:CGPointMake(self.contentBox.bounds.size.width*self.selectBtn.tag, 0) animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setModels:(NSMutableArray<PCPersonModel *> *)models{
    _models = models;
    self.titleView.hidden = !models.count;
    __block PCPersonModel *model = models.firstObject;
    NSString *lastTimePersionId = YHTools.personId;
    [models enumerateObjectsUsingBlock:^(PCPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([lastTimePersionId isEqualToString:obj.personId]){
            model = obj;
            *stop = YES;
        }
    }];
    [self changUser:model];

}

- (void)getUsers{
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getPersonsOnComplete:^(NSMutableArray<PCPersonModel *> *models) {
        [MBProgressHUD hideHUDForView:self.view];
        self.models = models;
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];

    }];
}

- (UIView *)titleView{
    if (!_titleView) {
        UIView *titleView = [[UIView alloc] init];
        
        UILabel *nameLB = [[UILabel alloc] init];
        [titleView addSubview:nameLB];
        _nameLB = nameLB;
        nameLB.text = @"";
        nameLB.font = [UIFont systemFontOfSize:27];
        [nameLB sizeToFit];
        nameLB.frame = CGRectMake(0, 0, nameLB.bounds.size.width, 44);
        
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn setImage:[UIImage imageNamed:@"上拉"] forState:UIControlStateNormal];
        [arrowBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateSelected];
        [titleView addSubview:arrowBtn];
        arrowBtn.frame =CGRectMake(nameLB.bounds.size.width+5, 0, 18, 44);
        arrowBtn.userInteractionEnabled = NO;
        self.arrowBtn = arrowBtn;
        
        
        UILabel *titleLB = [[UILabel alloc] init];
        [titleView addSubview:titleLB];
        //_nameLB = nameLB;
        titleLB.text = @"测量记录";
        titleLB.font = [UIFont systemFontOfSize:18];
        [titleLB sizeToFit];
        titleLB.frame = CGRectMake(CGRectGetMaxX(arrowBtn.frame), 0, titleLB.bounds.size.width, 44);

        
        
        titleView.frame = CGRectMake(0, 0, CGRectGetMaxX(arrowBtn.frame), 44);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [titleView addGestureRecognizer:tap];
        _titleView = titleView;
        _titleView.hidden = YES;
    }
    return _titleView;
}

- (void)tapAction{
    self.arrowBtn.selected = YES;
    [YBPopupMenu showRelyOnView:self.navigationItem.titleView titles:[self.models valueForKeyPath:@"personName"] icons:nil menuWidth:150 delegate:self];
}


- (void)addUI{
    self.navigationItem.titleView = self.titleView;
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    UIView *topBox = [[UIView alloc] init];
    [self.view addSubview:topBox];
    //topBox.backgroundColor = [UIColor redColor];
    self.topBox = topBox;
    
    [topBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(topBox.superview);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(topBox.superview.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        }
        make.height.mas_equalTo(43);
    }];
    
    UIButton *figureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBox addSubview:figureBtn];
    figureBtn.backgroundColor = [UIColor colorWithRed:0.86 green:0.73 blue:0.57 alpha:1.00];
    [figureBtn setTitle:@"体形" forState:UIControlStateNormal];
    [figureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [figureBtn setTitleColor:YHColor0X(0x333333, 1.0) forState:UIControlStateNormal];
    figureBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    figureBtn.tag = 0;
    [figureBtn addTarget:self action:@selector(tapClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = figureBtn;
    figureBtn.selected = YES;
    
    UIButton *postureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBox addSubview:postureBtn];
    postureBtn.backgroundColor = [UIColor whiteColor];
    [postureBtn setTitle:@"体态" forState:UIControlStateNormal];
    [postureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [postureBtn setTitleColor:YHColor0X(0x333333, 1.0) forState:UIControlStateNormal];
    postureBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    postureBtn.tag = 1;
    [postureBtn addTarget:self action:@selector(tapClick:) forControlEvents:UIControlEventTouchUpInside];

    [figureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(figureBtn.superview);
        make.right.mas_equalTo(postureBtn.mas_left);
    }];
    [postureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(postureBtn.superview);
        make.width.mas_equalTo(figureBtn);
    }];

    

    
    
    UIScrollView *box = [[UIScrollView alloc] init];
    [self.view addSubview:box];
    self.contentBox = box;
    box.scrollEnabled = NO;
    //box.backgroundColor = [UIColor orangeColor];
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(box.superview);
        make.top.mas_equalTo(topBox.mas_bottom).offset(6);
        CGFloat h = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.bounds.size.height;
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, h));
    }];
    //box.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 0);
    box.pagingEnabled = YES;
    box.delegate = self;
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHMessageCenterController"];

    [box addSubview:vc.view];
    [self addChildViewController:vc];
    
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.width.height.mas_equalTo(box);
    }];
    
    UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCPostureController"];
    [box addSubview:vc2.view];
    [self addChildViewController:vc2];
    
    [vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.width.height.mas_equalTo(box);
        make.left.mas_equalTo(box.mas_left).offset(screenWidth);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        // 停止后要执行的代码
        [self didEndScrollView:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            // 停止后要执行的代码
            [self didEndScrollView:scrollView];
        }
    }
}

- (void)didEndScrollView:(UIScrollView *)scrollView{
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width);
    [self.topBox.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            obj.selected = NO;
            obj.backgroundColor = [UIColor whiteColor];
        }else{
            obj.selected = YES;
            self.selectBtn = obj;
            obj.backgroundColor = [UIColor colorWithRed:0.86 green:0.73 blue:0.57 alpha:1.00];
        }
    }];
}

- (void)tapClick:(UIButton *)sender{
    
    [self.topBox.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.backgroundColor = [UIColor whiteColor];
    }];
    
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithRed:0.86 green:0.73 blue:0.57 alpha:1.00];
    self.selectBtn = sender;
    [self.contentBox setContentOffset:CGPointMake(self.contentBox.bounds.size.width*sender.tag, 0) animated:YES];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [self changUser:self.models[index]];
}
- (void)ybPopupMenuDidDismiss{
    self.arrowBtn.selected = NO;
}

- (void)changUser:(PCPersonModel *)user{
    if (user == nil) {
        return;
    }

    self.nameLB.text = user.personName;
    
    [self.nameLB sizeToFit];
    self.nameLB.frame = CGRectMake(0, 0, self.nameLB.bounds.size.width, 44);
    self.arrowBtn.frame = CGRectMake(CGRectGetMaxX(self.nameLB.frame)+5, 0, 18, 44);
    
    self.navigationItem.titleView.subviews.lastObject.frame = CGRectMake(CGRectGetMaxX(self.arrowBtn.frame)+10, 0, self.navigationItem.titleView.subviews.lastObject.bounds.size.width, 44);
    
    self.navigationItem.titleView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.navigationItem.titleView.subviews.lastObject.frame), 44);

    
    [self.childViewControllers.firstObject setValue:user.personId forKey:@"personId"];
    [self.childViewControllers.lastObject setValue:user.personId forKey:@"personId"];

    
}

- (void)popViewController:(id)sender{
    [super popViewController:sender];
    [self presentLeftMenuViewController:sender];
}
@end
