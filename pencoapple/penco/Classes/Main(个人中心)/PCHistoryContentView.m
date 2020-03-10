//
//  PCHistoryContentView.m
//  penco
//
//  Created by Jay on 1/8/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCHistoryContentView.h"
#import "YHHistoryController.h"

#import "PCTestRecordModel.h"
#import "PCMessageModel.h"
#import "PCHistoryContentCell.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"

#import "MBProgressHUD+MJ.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCHistoryContentView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableArray <YHHistoryController *>*vcs;
@property (nonatomic, assign) NSInteger indexRow;
@end

@implementation PCHistoryContentView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    UITableView *contentView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    [self.view addSubview:contentView];
//    self.contentView = contentView;
//
//
//    contentView.rowHeight = 100;//self.view.bounds.size.height;
//    contentView.dataSource = self;
//    contentView.delegate = self;
//    contentView.showsVerticalScrollIndicator = NO;
//    contentView.scrollEnabled = NO;
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(screenWidth, screenHeight * self.models.count);
    self.contentView = contentView;
    contentView.scrollEnabled = NO;
    contentView.backgroundColor = YHColor0X(0xEFF1F0, 1.0);
    self.view.backgroundColor = YHColor0X(0xEFF1F0, 1.0);

    if (@available(iOS 11.0, *)) {
        contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.vcs = [NSMutableArray array];
     __weak typeof(self) weakSelf = self;
    [self.models enumerateObjectsUsingBlock:^(PCTestRecordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YHHistoryController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHHistoryController"];
        vc.isNews = weakSelf.isNews;
        [weakSelf.vcs addObject:vc];
    }];
    self.indexRow = self.index;

    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"PCHistoryContentScrollPosition" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSIndexPath * index = [note.userInfo valueForKey:@"index"];
        if(index.row >= weakSelf.models.count || index.row < 0) return ;
        weakSelf.indexRow = index.row;
        
    }];
    
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [contentView setContentOffset:CGPointMake(0, weakSelf.indexRow * screenHeight) animated:YES];
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll:scrollView];
        }
    }
}

#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    
        NSInteger row = scrollView.contentOffset.y / scrollView.frame.size.height;
        self.indexRow = row;
    
}


- (void)dealloc{
    YHLog(@"%s", __func__);
}


- (void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
    
    if(!self.contentView) return;
    
    [UIView performWithoutAnimation:^{
        [self.contentView setContentOffset:CGPointMake(0, indexRow * self.contentView.bounds.size.height) animated:YES];
    }];
    
    
    if(!self.vcs[indexRow].view.superview){
        [self.contentView addSubview:self.vcs[indexRow].view];
        [self addChildViewController:self.vcs[indexRow]];
        
        CGRect frame = self.vcs[indexRow].view.bounds;
        frame.origin.y = indexRow * self.contentView.bounds.size.height;
        frame.origin.x = 0;
        //frame = CGRectMake(0, indexRow * self.contentView.bounds.size.height, screenWidth, screenHeight);
        self.vcs[indexRow].view.frame = frame;
    }
    
    
    PCTestRecordModel *model = self.models[indexRow];
    
    YHHistoryController *vc = self.vcs[indexRow];
    if ([model isKindOfClass:[PCTestRecordModel class]]) {
        NSString *status = @"";//model.status? @"" : @"(需确认)";
        NSString *createTime = (model.reportTime.length > 16)? ([model.reportTime substringToIndex:16]) : model.reportTime;

        self.navigationItem.title = [NSString stringWithFormat:@"%@ 测量 %@",createTime,status];
        vc.reportId = model.reportId;
        vc.personId = model.personId;
        vc.accountId = model.accountId;
        vc.scrollIndex = indexRow;
    }else if ([model isKindOfClass:[PCMessageModel class]]){
        
        PCMessageModel *m = (PCMessageModel *)model;
        NSString *status = @"";//m.info.confirmStatus? @"" : @"(需确认)";
        NSString *measureTime = (m.info.measureTime.length > 16)? ([m.info.measureTime substringToIndex:16]) : m.info.measureTime;

        self.navigationItem.title = [NSString stringWithFormat:@"%@ 测量 %@",measureTime,status];
        
        vc.reportId = m.info.reportId;
        vc.personId = m.info.personId;
        vc.accountId = m.info.accountId;
        vc.messageModel = m;
        vc.scrollIndex = indexRow;

        [self readMsg:m];
    }

    
    
        vc.view.tag = indexRow;
    
}


- (void)readMsg:(PCMessageModel *)model{
    if (model.status == 2) {
        [[YHNetworkManager sharedYHNetworkManager] readMessages:@{@"accountId":YHTools.accountId,@"msgType":model.msgType,@"businessId":model.info.reportId} onComplete:^{
            model.status = 3;
        } onError:^(NSError * _Nonnull error) {
        }];
    }
}

- (void)popViewController:(id)sender{
    if (self.isNews) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [super popViewController:sender];
}

@end
