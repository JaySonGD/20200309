//
//  YHProfitDetailController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHProfitDetailController.h"
#import "YHProfitDetailCell.h"
#import "YHProfitSearchView.h"
#import "YHCustomDatePicker.h"
#import "YHTools.h"
#import "YHNetworkManager.h"

#import "YHSVProgressHUD.h"

@interface YHProfitDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *profitTableView;

@property (nonatomic, weak) YHProfitSearchView *searchView;

@property (nonatomic, weak) YHCustomDatePicker *customPicker;

@property (nonatomic, strong) NSMutableArray *profitArr;

@property (nonatomic, weak) UILabel *noDataPremptL;

@end

@implementation YHProfitDetailController

- (YHCustomDatePicker *)customPicker{
    if (!_customPicker) {
        YHCustomDatePicker *customPicker = [[YHCustomDatePicker alloc] init];
        _customPicker = customPicker;
        [self.view addSubview:customPicker];
        [customPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(self.profitTableView.mas_bottom);
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
    self.title = @"收益明细";
    self.view.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    [self initProfitDetailView];

//    [self searchViewTouchUpInsideEvent];
    
    [self getProfitDetailList];
    
}
- (void)getProfitDetailList{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [[YHNetworkManager sharedYHNetworkManager] getProfitDetailList:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
       
       [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            
            NSArray *resultDict = info[@"result"];
            self.profitArr = [resultDict mutableCopy];
            if (self.profitArr.count) {
                self.profitTableView.hidden = NO;
                self.noDataPremptL.hidden = YES;
                [self.profitTableView reloadData];
            }else{
                self.profitTableView.hidden = YES;
                self.noDataPremptL.hidden = NO;
            }
            
        }else{
            
            NSString *retMsg = info[@"retMsg"];
            [MBProgressHUD showError:retMsg];
        }
        
    } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)initProfitDetailView{
    
    // 检索
//    YHProfitSearchView *searchView = [[[NSBundle mainBundle] loadNibNamed:@"YHProfitSearchView" owner:nil options:nil] firstObject];
//    self.searchView = searchView;
//    searchView.autoresizingMask = UIViewAutoresizingNone;
//    [self.view addSubview:searchView];
    CGFloat topMargin = IphoneX ? 88.0 : 64.0;
//    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(topMargin));
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.height.equalTo(@50);
//    }];
    
    // 设置默认选择日期
//    NSCalendar *currentCalender = [NSCalendar currentCalendar];
//    NSInteger year = [currentCalender component:NSCalendarUnitYear fromDate:[NSDate date]];
//    NSInteger month = [currentCalender component:NSCalendarUnitMonth fromDate:[NSDate date]];
//    NSInteger day = [currentCalender component:NSCalendarUnitDay fromDate:[NSDate date]];
//    NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
//    if (month == 1) {
//        year-= 1;
//    }
//    NSString *lastDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month - 1,day - 1];
//    [searchView setStartTimeLabelText:lastDateStr];
//    [searchView setEndTimeLableText:currentDateStr];
    
    // tableView
    UITableView *profitTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    profitTableView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    profitTableView.delegate = self;
    profitTableView.dataSource = self;
    self.profitTableView = profitTableView;
    [self.view addSubview:profitTableView];
    
    CGFloat bottomMargin = IphoneX ? 34.0 : 0;
    [profitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + 10));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
    profitTableView.tableFooterView = [[UIView alloc] init];
    profitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    profitTableView.hidden = YES;
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
        make.top.equalTo(self.profitTableView);
        make.height.equalTo(@65);
    }];
    
}
//- (void)searchViewTouchUpInsideEvent{
//
//    __weak typeof(self)weakSelf = self;
//    // 开始时间
//    self.searchView.clickStartTimeBlock = ^{
//        [weakSelf customPicker];
//    };
//    // 结束时间
//    self.searchView.clickEndTimeBlock = ^{
//         [weakSelf customPicker];
//    };
//    // 查询
//    self.searchView.clickQueryBtnBlock = ^{
//
//    };
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.profitArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *profitCellId = @"profitCellId";
    YHProfitDetailCell *profitCell = [tableView dequeueReusableCellWithIdentifier:profitCellId];
    if (!profitCell) {
        profitCell = [[[NSBundle mainBundle] loadNibNamed:@"YHProfitDetailCell" owner:nil options:nil] firstObject];
        profitCell.autoresizingMask = UIViewAutoresizingNone;
        profitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    profitCell.info = self.profitArr[indexPath.row];
    return profitCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 115.0;
}
@end
