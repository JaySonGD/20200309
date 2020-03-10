//
//  YHFindOfferController.m
//  YHCaptureCar
//
//  Created by Jay on 14/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHFindOfferController.h"

#import <MJRefresh.h>
#import <LYEmptyView/LYEmptyViewHeader.h>

#import "YHHelpSellService.h"
#import "NSDate+BRAdd.h"

#import "UIView+Frame.h"
#import "YHOfferCell.h"

#import "TTZCarModel.h"

@interface YHFindOfferController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<offerModel *> *models;
@end

@implementation YHFindOfferController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI{
    
    self.navigationItem.title = @"查看出价列表";
    
    

    
//    self.tableView.tableHeaderView = ({
//        
//        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//        
//        topView.backgroundColor = [UIColor whiteColor];
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 10)];
//        line.backgroundColor = YHBackgroundColor;
//        [topView addSubview:line];
//        
//        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 50)];
//        titleLB.text = @"筛选时间";
//        titleLB.font = [UIFont systemFontOfSize:15];
//        titleLB.textColor = YHColor(58, 58, 58);
//        [topView addSubview:titleLB];
//        
//        UIButton *indexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        indexBtn.frame = CGRectMake(kScreenWidth - 12 - 15, 0, 12, 50);
//        [indexBtn setImage:[UIImage imageNamed:@"进入选择"] forState:UIControlStateNormal];
//        [topView addSubview:indexBtn];
//        
//        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(indexBtn.x - 15 - 200, 0, 200, 50)];
//        timeLB.textAlignment = NSTextAlignmentRight;
//        timeLB.font = [UIFont systemFontOfSize:15];
//        timeLB.textColor = YHColor(96, 96, 96);
//        
//        NSString *today = [NSDate currentDateStringWithFormat:@"yyyy-MM-dd"];
//        NSString *endday = [NSDate getPriousorLaterDateFromDate:[NSDate date] formatter:@"yyyy-MM-dd" withMonth:-1];
//        timeLB.text = [NSString stringWithFormat:@"%@  -  %@",today,endday];
//        [topView addSubview:timeLB];
//        
//        topView;
//    });
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}
- (void)loadData{
    [YHHelpSellService findOfferListWithCarId:self.carId
                                    startTime:@"2017-09-09"
                                      endTime:@"2018-09-09" onComplete:^(NSMutableArray<offerModel *> *models) {
                                          self.models = models;
                                          [self.tableView reloadData];
                                      } onError:^(NSError *error) {
                                          
                                      }];
}
#pragma mark  -  UITableViewDataSource



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    YHOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHOfferCell"];
    
    cell.model = self.models[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}





//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark  -  get/set 方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHOfferCell" bundle:nil] forCellReuseIdentifier:@"YHOfferCell"];
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata"
                                                            titleStr:@"暂无数据"
                                                           detailStr:nil];
        
        
//        __weak typeof(self) weakSelf = self;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        }];
        
        
        _tableView.rowHeight = 115;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
        
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        footer.refreshingTitleHidden = YES;
//        footer.height = 35.f;
//        footer.stateLabel.font = [UIFont systemFontOfSize:12.0];
//        footer.stateLabel.textColor =  YHColor0X(0x666666, 1.0);
//        footer.backgroundColor = YHBackgroundColor;
//        footer.triggerAutomaticallyRefreshPercent = 0.1f;
//        [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
        
//        _tableView.mj_footer = footer;
//        _tableView.mj_footer.hidden = YES;
        
    }
    return _tableView;
}

@end
