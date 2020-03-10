//
//  YHRichBindBankCardController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichBindBankCardController.h"
#import "YHRichBindBankCardInputCell.h"
#import "YHRichSelectBankController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHSVProgressHUD.h"

@interface YHRichBindBankCardController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *bindBankCardTableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation YHRichBindBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
   
    [self initRichBindBankCardControllerView];
    [self initDataSource];
    
}
- (void)initRichBindBankCardControllerView{
    
    UITableView *bindBankCardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    bindBankCardTableView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    bindBankCardTableView.delegate = self;
    bindBankCardTableView.dataSource = self;
    self.bindBankCardTableView = bindBankCardTableView;
    bindBankCardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bindBankCardTableView];
    
    CGFloat bottomMargin = IphoneX ? 34.0 : 0;
    CGFloat topMargin = IphoneX ? 88.0 : 64.0;
    [bindBankCardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    bindBankCardTableView.tableFooterView = [[UIView alloc] init];
    // 绑定银行卡
    UIBarButtonItem *sureBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = sureBarButtonItem;
}
#pragma mark - 点击确定按钮 ------
- (void)rightBtnClicked{
    
    for (NSDictionary *item in self.dataSourceArr) {
        if ([item[@"isArrow"] isEqualToString:@"NO"] && [item[@"subtitle"] isEqualToString:@""]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"请输入%@",item[@"title"]]];
            return;
        }
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *bankCardId = self.isModifyBank ? self.bankCardId : @"";
    [[YHNetworkManager sharedYHNetworkManager] addOrModifyBindBankCard:[YHTools getAccessToken] bankCardId:bankCardId bank:self.dataSourceArr[2][@"subtitle"] accountName:self.dataSourceArr.firstObject[@"subtitle"] cardNum:self.dataSourceArr[1][@"subtitle"] onComplete:^(NSDictionary *info) {

        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            
            [MBProgressHUD showError:info[@"retMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindOrModifyBankCardSuccessNotification" object:nil];
            
        }else{
            [MBProgressHUD showError:info[@"retMsg"]];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
- (void)initDataSource{
    
    self.dataSourceArr = @[
                           @{
                               @"title":@"开户姓名",
                               @"subtitle":@"",
                               @"isArrow":@"NO"
                               }.mutableCopy,
                           @{
                               @"title":@"银行卡号",
                               @"subtitle":@"",
                               @"isArrow":@"NO"
                               }.mutableCopy,
                           @{
                               @"title":@"开户行",
                               @"subtitle":@"请选择开户银行",
                               @"isArrow":@"YES"
                               }.mutableCopy
                           ].mutableCopy;
    [self.bindBankCardTableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *richBindBankCardInputCellId = @"RichBindBankCardInputCellId";
    YHRichBindBankCardInputCell *cell = [tableView dequeueReusableCellWithIdentifier:richBindBankCardInputCellId];
    if (cell == nil) {
        cell = [[YHRichBindBankCardInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:richBindBankCardInputCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.info = self.dataSourceArr[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        // 选择银行卡
       YHRichSelectBankController *selectBankVc = [[YHRichSelectBankController alloc] init];
        __weak typeof(self)weakSelf = self;
        selectBankVc.selectCellEvent = ^(NSDictionary *selectDict) {
            
          NSDictionary *selectBankDict = @{
              @"title":@"开户行",
              @"subtitle":[NSString stringWithFormat:@"%@",selectDict[@"title"]],
              @"isArrow":@"YES"
              };
            
            [weakSelf.dataSourceArr replaceObjectAtIndex:2 withObject:selectBankDict];
            [weakSelf.bindBankCardTableView reloadData];
        };
        [self.navigationController pushViewController:selectBankVc animated:YES];
    }
    
}
@end
