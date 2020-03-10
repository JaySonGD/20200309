//
//  YHGetCashRecordController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHGetCashRecordController.h"
#import "YHGetCashRecordCell.h"
#import <MJRefresh/MJRefresh.h>
#import "YHProfitSearchView.h"
#import "YHCustomDatePicker.h"
#import "YHNetworkManager.h"
#import "YHTools.h"

#import "YHSVProgressHUD.h"

@interface YHGetCashRecordController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *getCashRecordTableView;

@property (nonatomic, weak) MJRefreshAutoGifFooter *footer;

@property (nonatomic, weak) YHProfitSearchView *searchView;

@property (nonatomic, weak) YHCustomDatePicker *customPicker;

@property (nonatomic, weak)  UILabel *noDataPremptL;

@property (nonatomic, strong) NSMutableArray *getCashArr;
/** 页码 */
@property (nonatomic, assign) int page;

@end

@implementation YHGetCashRecordController

- (YHCustomDatePicker *)customPicker{
    if (!_customPicker) {
        YHCustomDatePicker *customPicker = [[YHCustomDatePicker alloc] init];
        _customPicker = customPicker;
        [self.view addSubview:customPicker];
        [customPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(self.getCashRecordTableView.mas_bottom);
            make.height.equalTo(@244);
        }];
        __weak typeof(self)weakSelf = self;
        customPicker.datePickerValueChange = ^(UIDatePicker *picker) {
            
            NSInteger year = [picker.calendar component:NSCalendarUnitYear fromDate:picker.date];
            NSInteger month = [picker.calendar component:NSCalendarUnitMonth fromDate:picker.date];
            NSInteger day = [picker.calendar component:NSCalendarUnitDay fromDate:picker.date];
            NSLog(@"---------year =%ld-----month =%ld--------day =%ld",year,month,day);
            
            NSString *resultTimeStr = [NSString stringWithFormat:@"%ld-%.02ld-%.02ld",year,month,day];
            if (weakSelf.searchView.selectTimeType == YHProfitSearchViewSelectTimeStart) {
                [weakSelf.searchView setStartTimeLabelText:resultTimeStr];
            }
            
            if (weakSelf.searchView.selectTimeType == YHProfitSearchViewSelectTimeEnd) {
                [weakSelf.searchView setEndTimeLableText:resultTimeStr];
            }
        };
    }
    return _customPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    self.view.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
   
    [self initUI];
    [self requestGetCashRecordData];
}
- (void)initUI{

    // 检索
    YHProfitSearchView *searchView = [[[NSBundle mainBundle] loadNibNamed:@"YHProfitSearchView" owner:nil options:nil] firstObject];
    self.searchView = searchView;
    searchView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:searchView];
    CGFloat topMargin = IphoneX ? 88.0 : 64.0;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    // 设置默认选择日期
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    NSInteger year = [currentCalender component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month = [currentCalender component:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger day = [currentCalender component:NSCalendarUnitDay fromDate:[NSDate date]];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    if (month == 1) {
        year-= 1;
    }
    NSString *lastDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month - 1,day - 1];
    [searchView setStartTimeLabelText:lastDateStr];
    [searchView setEndTimeLableText:currentDateStr];
    
    // tableView
    UITableView *getCashRecordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    getCashRecordTableView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    getCashRecordTableView.delegate = self;
    getCashRecordTableView.dataSource = self;
    self.getCashRecordTableView = getCashRecordTableView;
     getCashRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:getCashRecordTableView];
    
    CGFloat bottomMargin = IphoneX ? 34.0 : 0;
    [getCashRecordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
    // 请求无数据提示
    UILabel *noDataPremptL = [[UILabel alloc] init];
    noDataPremptL.hidden = YES;
    noDataPremptL.font = [UIFont systemFontOfSize:20.0];
    noDataPremptL.backgroundColor = [UIColor whiteColor];
    noDataPremptL.textAlignment = NSTextAlignmentCenter;
    self.noDataPremptL = noDataPremptL;
    noDataPremptL.text = @"没有数据";
    noDataPremptL.textColor = [UIColor colorWithRed:227.0/255.0 green:94.0/255.0 blue:69.0/255.0 alpha:1.0];
    [self.view addSubview:noDataPremptL];
    [noDataPremptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(self.getCashRecordTableView);
        make.height.equalTo(@65);
    }];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新了");
        [self requestGetCashRecordData:_page];
        
    }];
    
    footer.ignoredScrollViewContentInsetBottom = 120;
    [footer setTitle:@"上拉查看更多提现记录" forState:MJRefreshStateIdle];
    [footer setBackgroundColor:[UIColor whiteColor]];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多提现记录了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    footer.frame = CGRectMake(0, 0, 0, 70);
    footer.stateLabel.textColor = YHNaviColor;
    getCashRecordTableView.mj_footer = footer;
    getCashRecordTableView.tableFooterView = [[UIView alloc] init];
    
    [self searchViewTouchUpInsideEvent];
}
#pragma mark - 获取最新数据 -----
- (void)requestGetCashRecordData{
    
     _page = 1;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getProfitDetailList:[YHTools getAccessToken] startTime:[NSString stringWithFormat:@"%@ 00:00:00",[self.searchView getStartTimeText]] endTime:[NSString stringWithFormat:@"%@ 23:59:59",[self.searchView getEndTimeText]] page:@"1" pageSize:@"10" onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            NSArray *resultArr = info[@"result"];
            self.getCashRecordTableView.mj_footer.hidden = resultArr.count < 10;
            self.noDataPremptL.hidden = resultArr.count ? YES : NO;
            self.getCashArr = resultArr.mutableCopy;
            [self.getCashRecordTableView reloadData];
        }else{
            NSString *retMsg = info[@"retMsg"];
            [MBProgressHUD showError:retMsg];
            self.getCashRecordTableView.mj_footer.hidden = YES;
            
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
#pragma mark - 分页数据 ---
- (void)requestGetCashRecordData:(int)page{
    
    _page++;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getProfitDetailList:[YHTools getAccessToken] startTime:[NSString stringWithFormat:@"%@ 00:00:00",[self.searchView getStartTimeText]] endTime:[NSString stringWithFormat:@"%@ 23:59:59",[self.searchView getEndTimeText]] page:[NSString stringWithFormat:@"%d",page] pageSize:@"10" onComplete:^(NSDictionary *info) {
    
        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            NSArray *resultArr = info[@"result"];
            
            if (!resultArr.count) {
                _page--;
                self.getCashRecordTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                [self.getCashArr addObjectsFromArray:resultArr];
                [self.getCashRecordTableView reloadData];
                self.getCashRecordTableView.mj_footer.state = MJRefreshStateIdle;
            }
            
        }else{
            NSString *retMsg = info[@"retMsg"];
            [MBProgressHUD showError:retMsg];
             _page--;
        }
        
    } onError:^(NSError *error) {
        _page--;
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)searchViewTouchUpInsideEvent{
    
    __weak typeof(self)weakSelf = self;
    // 开始时间
    self.searchView.clickStartTimeBlock = ^{
//        [weakSelf customPicker];
        [weakSelf.customPicker setDatePickerMaxDate:[weakSelf.searchView getEndDate]];
        [weakSelf datePickerAnimate];
    };
    // 结束时间
    self.searchView.clickEndTimeBlock = ^{
        [weakSelf.customPicker setDatePickerMinDate:[weakSelf.searchView getStartDate]];
        [weakSelf datePickerAnimate];
    };
    // 查询
    self.searchView.clickQueryBtnBlock = ^{
        [weakSelf requestGetCashRecordData];
    };
}

- (void)datePickerAnimate{
   
//    [self.customPicker mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.bottom.equalTo(self.getCashRecordTableView.mas_bottom);
//        make.height.equalTo(@0);
//    }];
    
    self.customPicker.alpha = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            
//            [self.customPicker mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(@0);
//                make.right.equalTo(@0);
//                make.bottom.equalTo(self.getCashRecordTableView.mas_bottom);
//                make.height.equalTo(@244);
//            }];
            self.customPicker.alpha = 1;
        
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.getCashArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *getCashCellId = @"YHGetCashRecordCellId";
    YHGetCashRecordCell *getCashCell = [tableView dequeueReusableCellWithIdentifier:getCashCellId];
    if (!getCashCell) {
        getCashCell = [[[NSBundle mainBundle] loadNibNamed:@"YHGetCashRecordCell" owner:nil options:nil] firstObject];
        getCashCell.autoresizingMask = UIViewAutoresizingNone;
        getCashCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    getCashCell.info = self.getCashArr[indexPath.row];
    return getCashCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.getCashArr[indexPath.row];
    if ([info[@"status"] isEqualToString:@"2"]) {
         return 115.0;
    }else{
          return 70.0;
    }
}
@end
