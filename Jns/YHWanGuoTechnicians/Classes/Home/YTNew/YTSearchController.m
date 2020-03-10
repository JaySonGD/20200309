//
//  YTSearchController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTSearchController.h"

#import <Masonry.h>

#import "YTPlanModel.h"
#import "YHCarPhotoService.h"

@interface YTSearchController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <YTCheckResultModel *>*resultModels;
@property (nonatomic, weak) UISearchBar *search;
@property (nonatomic, weak) UIButton *msg;
@property (nonatomic, weak) UIButton *addBtn;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) NSMutableArray <NSString *> *historyDatas;

@property (nonatomic, strong) UITableView *hisView;
@end

@implementation YTSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UISearchBar *search = [[UISearchBar alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    search.placeholder = @"请输入诊断结果";
    [search becomeFirstResponder];
    search.returnKeyType = UIReturnKeySearch;
    search.enablesReturnKeyAutomatically = YES;
    search.delegate = self;
    
    self.navigationItem.titleView = search;
    _search = search;
    
    UIButton *msg = [UIButton buttonWithType:UIButtonTypeCustom];
    [msg setImage:[UIImage imageNamed:@"组 8632"] forState:UIControlStateNormal];
    [msg setTitle:@" 使用该方案" forState:UIControlStateNormal];
    msg.titleLabel.font = [UIFont systemFontOfSize:14];
    [msg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    [header addSubview:msg];
    _msg = msg;
    [msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(header).offset(10);
        make.top.mas_equalTo(header).offset(10);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableFooterView = header;

    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _tableView = tableView;
    
    
    
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = YHNaviColor;
    [addBtn setTitle:@"使用该方案" forState:UIControlStateNormal];
    kViewRadius(addBtn, 8);
    [self.view addSubview:addBtn];
    _addBtn = addBtn;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.view).offset(-20-kTabbarSafeBottomMargin);
    }];
    
    [addBtn addTarget:self action:@selector(addPlanAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITableView *hisView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [hisView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    hisView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view addSubview:hisView];
    hisView.dataSource = self;
    hisView.delegate = self;
    self.hisView = hisView;
    hisView.tableFooterView = [UIView new];


}

- (void)addPlanAction{
    self.diagnoseModel.checkResultArr.makeResult = self.search.text;
    !(_searchResultBlock)? : _searchResultBlock();
    [self close];
}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == self.hisView) {
        return (self.historyDatas.count > 10)? 10 : self.historyDatas.count;
    }
    
    tableView.tableFooterView.hidden  =  (BOOL)self.resultModels.count;
    [_msg setTitle:[NSString stringWithFormat:@" 没有搜索到\"%@\"",self.search.text] forState:UIControlStateNormal];


    if (self.search.text.length < 1) tableView.tableFooterView.hidden = YES;
    self.addBtn.hidden = tableView.tableFooterView.hidden;
    
    return self.resultModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]] && obj.tag == 999) {
            [obj removeFromSuperview];
        }
    }];
    
    if (tableView == self.hisView) {
        cell.textLabel.text = self.historyDatas[indexPath.row];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:deleteBtn];
        //deleteBtn.backgroundColor = YHRedColor;
        [deleteBtn setImage:[UIImage imageNamed:@"close_page"] forState:UIControlStateNormal];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.right.mas_equalTo(deleteBtn.superview).offset(-15);
            make.centerY.mas_equalTo(deleteBtn.centerY).offset(0);
        }];
        deleteBtn.tag = indexPath.row;
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else cell.textLabel.text = self.resultModels[indexPath.row].check_result;
   
    return cell;
}

- (void)deleteAction:(UIButton *)sender{
    [self.historyDatas removeObjectAtIndex:sender.tag];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDatas forKey:@"historyData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.hisView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (tableView == self.hisView) {
        self.search.text = self.historyDatas[indexPath.row];
        [self searchBarSearchButtonClicked:self.search];
        return;
    }else{
    
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] getQualitySolutionDataList:self.resultModels[indexPath.row].Id
                                               brand_id:self.diagnoseModel.baseInfo.carBrandId                                                line_id:self.diagnoseModel.baseInfo.carLineId
                                                 car_cc:self.diagnoseModel.baseInfo.carCc//[NSString stringWithFormat:@"%@L",self.diagnoseModel.baseInfo.carCc]
                                               car_year:self.diagnoseModel.baseInfo.carYear
                                                success:^(NSMutableArray<YTPlanModel *> *models) {
                                                    
                                                    [models enumerateObjectsUsingBlock:^(YTPlanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                        if (IsEmptyStr(obj.name)) {
                                                            obj.name = [NSString stringWithFormat:@"智能解决方案%ld",idx+1];
                                                        }
                                                    }];
                                                    
                                                    [models addObjectsFromArray:self.diagnoseModel.maintain_scheme];                                                    
                                                    self.diagnoseModel.maintain_scheme = models;
                                                    self.diagnoseModel.checkResultArr.makeResult = self.resultModels[indexPath.row].check_result;

                                                    !(_searchResultBlock)? : _searchResultBlock();

                                                    [MBProgressHUD hideHUDForView:self.view];
                                                    [self close];
                                                } failure:^(NSError *error) {
                                                    [MBProgressHUD hideHUDForView:self.view];
                                                    [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                    // called when text starts editing

{
    [self.hisView reloadData];
    self.hisView.hidden = NO;
    self.tableView.hidden = YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hisView.hidden = YES;
            self.tableView.hidden = NO;
    });

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] getCheckResultList:searchBar.text success:^(NSMutableArray<YTCheckResultModel *> *models) {
        [MBProgressHUD hideHUDForView:self.view];
        self.resultModels = models;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
    
    
    
    if([self.historyDatas containsObject:searchBar.text]) [self.historyDatas removeObject:searchBar.text];
    [self.historyDatas insertObject:searchBar.text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDatas forKey:@"historyData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSMutableArray<NSString *> *)historyDatas
{
    if (!_historyDatas) {
        
        NSMutableArray *datas = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"historyData"];
        if (datas.count) {
            _historyDatas = datas.mutableCopy;
        }else{
            _historyDatas = [NSMutableArray array];
        }
    }
    return _historyDatas;
}


@end
