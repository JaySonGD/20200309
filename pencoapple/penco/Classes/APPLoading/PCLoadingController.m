//
//  PCLoadingController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/21.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "PCLoadingController.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"
#import "MBProgressHUD+MJ.h"
#import "PCAdCell.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCLoadingController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (nonatomic,strong)NSDictionary *result;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic)BOOL isInterval;//是否是主动滑动
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@end

@implementation PCLoadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.skipBtn.hidden = YES;
    //    self.collectionV.la
    [self getGuide];
    [self addPagerView];
    [self addPageControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


-(void)getGuide{
    WeakSelf
    [[YHNetworkManager sharedYHNetworkManager] guideOnComplete:^(NSDictionary *info) {
        if ([info isKindOfClass:[NSDictionary class]] && ![info[@"code"] integerValue]) {
            NSDictionary *result = info[@"result"];
            weakSelf.result = [result mutableCopy];
//            NSArray *imgs = @[
//                @{
//                    @"url" : @"http://img2.imgtn.bdimg.com/it/u=1086708605,3636518425&fm=26&gp=0.jpg",
//                    @"sourceType" : @"PNG",
//                    @"interval" : @2
//                },
//                @{
//                    @"url" : @"http://flv2.bn.netease.com/videolib3/1510/25/bIHxK3719/SD/bIHxK3719-mobile.mp4",
//                    @"sourceType" : @"video",
//                    @"interval" : @6
//                },
//                @{
//                    @"url" : @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561130271121&di=bf4f04028b5220ea60567635f9be09df&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20151210%2Fmp47504103_1449723238181_1.gif",
//                    @"sourceType" : @"gif",
//                    @"interval" : @3
//                }
//            ];
            //            [weakSelf.result setValue:imgs forKey:@"imgs"];
            [weakSelf startTimer];
            [weakSelf.pagerView reloadData];
            //            [weakSelf.collectionV reloadData];
        }else if ([info isKindOfClass:[NSDictionary class]] && [info[@"code"] integerValue] == 5001) {
        }else{
            [MBProgressHUD showError:info[@"message"]];
        }
    } onError:^(NSError *error) {
    }];
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = NO;
    pagerView.autoScrollInterval = 0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    pagerView.collectionView.scrollEnabled = NO;
    // registerClass or registerNib
    [pagerView registerClass:[PCAdCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view insertSubview:pagerView atIndex:1];
    
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            //方法一适配
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_equalTo(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_equalTo(0);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_equalTo(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_equalTo(0);
            
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(12, 6);
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //    _pagerView.frame =CGRectMake(0, NavbarHeight, CGRectGetWidth(self.view.frame), ;
    //    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}

- (void)startTimer{
    NSArray *imgs = [self.result objectForKey:@"imgs"];
    if (!imgs || imgs.count == 0) {
        PushControllerAnimated(@"AppLoading", @"PCAgreementController", NO);
        return;
    }
    
    NSDictionary *item = imgs[0];
    NSNumber *interval = [item objectForKey:@"interval"];
//    interval = @2;
    if (interval == nil || interval.intValue == 0) {
        self.isInterval = NO;
        _pagerView.collectionView.scrollEnabled = YES;
        return;
    }
    self.isInterval = YES;
    //    interval = @5;
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval.doubleValue target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
    self.timer = timer;
    [timer setFireDate: [[NSDate date]dateByAddingTimeInterval:interval.doubleValue]];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)timerCallback:(id)info{
    NSArray *imgs = [self.result objectForKey:@"imgs"];
    if (self.pagerView.curIndex == imgs.count - 1) {
        [self.timer setFireDate:[NSDate distantFuture]];
        PushControllerAnimated(@"AppLoading", @"PCAgreementController", NO);
        return;
    }
    if (!self.isInterval) {
        return;
    }
    NSDictionary *item = imgs[self.pagerView.curIndex + 1];
    NSNumber *interval = [item objectForKey:@"interval"];
//        interval = @2;
    [self.pagerView scrollToItemAtIndex:(self.pagerView.curIndex + 1) animate:YES];
    [self.timer setFireDate: [[NSDate date]dateByAddingTimeInterval:interval.doubleValue]];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    NSArray *imgs = [self.result objectForKey:@"imgs"];
    return imgs.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    PCAdCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndex:index];
    //赋值给cell
    NSArray *imgs = [self.result objectForKey:@"imgs"];
    [cell loadData:imgs[imgs.count - index - 1]];
    return cell;
}
- (IBAction)skipAction:(id)sender {
    [self.timer setFireDate:[NSDate distantFuture]];
    PushControllerAnimated(@"AppLoading", @"PCAgreementController", NO);
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = pageView.frame.size;
    layout.itemSpacing = 0;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    
    layout.layoutType = TYCyclePagerTransformLayoutNormal;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    
    NSArray *imgs = [self.result objectForKey:@"imgs"];
    if (self.isInterval == NO && toIndex == (imgs.count - 1)) {
        self.skipBtn.hidden = NO;
    }else{
        self.skipBtn.hidden = YES;
    }
    YHLog(@"%ld ->  %ld",fromIndex,toIndex);
}

//- (void)pagerViewDidEndDragging:(TYCyclePagerView *)pageView willDecelerate:(BOOL)decelerate{
//    CGPoint translatedPoint = [pageView.collectionView.panGestureRecognizer translationInView:pageView.collectionView];
//    
//    NSArray *imgs = [self.result objectForKey:@"imgs"];
//    if (!(self.isInterval) && pageView.curIndex == imgs.count - 1) {
//        if(translatedPoint.x < 0){
//            PushControllerAnimated(@"AppLoading", @"PCAgreementController", NO);
//        }
//    }
//}


@end
