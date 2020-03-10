//
//  YHRichesController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichesController.h"
#import "YHRichesHeaderView.h"
#import "YHProfitDetailController.h"
#import "YHMyBankCardController.h"
#import "YHGetCashRecordController.h"
#import "YHRichesCell.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHRichBindBankCardController.h"
#import "YHSVProgressHUD.h"

@interface YHRichesController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataInfo;

@property (nonatomic, weak) UITableView *richTableView;

@property (nonatomic, weak) YHRichesHeaderView *richView;

@property (nonatomic, copy) NSString *isBindCard;

@property (nonatomic, copy) NSString *limitNum;
/** 余额 */
@property (nonatomic, assign) CGFloat balance;

@end

@implementation YHRichesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    [self initRichControllerView];
    
    // 获取账户余额
    [self getAccountBankBalance];
    
    [self initDataSource];
   
}
- (void)initBase{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"财富";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBankCardSuccess) name:@"bindOrModifyBankCardSuccessNotification" object:nil];
    
}
- (void)getAccountBankBalance{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] surplusAccountInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
       
        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        NSString *retMsg = info[@"retMsg"];
        if ([retCode isEqualToString:@"0"]) {
            NSDictionary *resultDict = info[@"result"];
            // 银行卡余额
            CGFloat balance = [resultDict[@"balance"] floatValue];
            self.balance = balance;
            NSString *balanceStr = [NSString stringWithFormat:@"￥%.2f",balance];
            [self.richView setAccountBalance:balanceStr];
            // 是否绑定
            NSString *isBindCard = [NSString stringWithFormat:@"%@",resultDict[@"isBindCard"]];
            // 提取最低限额
            NSString *limitNum = [NSString stringWithFormat:@"%@",resultDict[@"limitNum"]];
            self.limitNum = limitNum;
            // 可提取时间
            NSString *withDrawTime = [NSString stringWithFormat:@"%@",resultDict[@"withDrawTime"]];
            NSString *premptText = [NSString stringWithFormat:@"每周%@为提现日，最低提现金额为%.2f元",[self WeekconversionNumber:withDrawTime],[limitNum floatValue]];
            [self.richView setGetAccountBalancePremptText:premptText];
    
            self.isBindCard = isBindCard;
            [self.richTableView reloadData];
        }else{
            [MBProgressHUD showError:retMsg];
        }
        
    } onError:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
- (NSString *)weekDayWithCurrentDay{
    
    NSString *weakDayString = nil;
    NSInteger currentWeekDay = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    if (currentWeekDay - 1 > 0) {
        weakDayString = currentWeekDay - 1 > 0 ? [NSString stringWithFormat:@"%ld",(currentWeekDay - 1)] : @"7";
    }
    
    return weakDayString;
}
- (NSString *)WeekconversionNumber:(NSString *)numStr{

    NSMutableString *resultStr = [NSMutableString string];
    NSArray *numCharArr = [numStr componentsSeparatedByString:@","];
    NSString *weakDayString = [self weekDayWithCurrentDay];
    
    BOOL isExist = NO;
    
    for (int i = 0;i<numCharArr.count; i++) {
        
        NSString *numChar = numCharArr[i];
        
        if ([weakDayString isEqualToString:numChar]) {
            isExist = YES;
        }
        if ([numChar isEqualToString:@"1"]) {
            [resultStr appendString:@"一"];
        }
        if ([numChar isEqualToString:@"2"]) {
            [resultStr appendString:@"二"];
        }
        if ([numChar isEqualToString:@"3"]) {
            [resultStr appendString:@"三"];
        }
        if ([numChar isEqualToString:@"4"]) {
            [resultStr appendString:@"四"];
        }
        if ([numChar isEqualToString:@"5"]) {
            [resultStr appendString:@"五"];
        }
        if ([numChar isEqualToString:@"6"]) {
            [resultStr appendString:@"六"];
        }
        if ([numChar isEqualToString:@"7"]) {
            [resultStr appendString:@"七"];
        }
        if (i < numCharArr.count - 1) {
            [resultStr appendString:@"、"];
        }
    }
    
    [self.richView setApplyCashBtnEnable:isExist];
    
    return resultStr;
}
- (void)initRichControllerView{
    
    UITableView *richTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.richTableView = richTableView;
    richTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    richTableView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    [self.view addSubview:richTableView];
    
    YHRichesHeaderView *richView = [[NSBundle mainBundle] loadNibNamed:@"YHRicherHeaderView" owner:nil options:nil].firstObject;
    self.richView = richView;
    richView.autoresizingMask = UIViewAutoresizingNone;
    richView.frame = CGRectMake(0, 0, 0, 352.0);
    richTableView.tableHeaderView = richView;
    
    // 提现按钮点击事件
    __weak typeof(self)weakSelf = self;
    richView.applyCashBtnClickEvent = ^{
        // 不足100不可提现！
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否全部提现?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 提现
            [self getCash];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 取消事件
            
        }];
        [alertVc addAction:cancelAction];
        [alertVc addAction:sureAction];
        [weakSelf presentViewController:alertVc animated:YES completion:nil];
    };
    
    CGFloat topMargin = IphoneX ? 88 : 64;
    CGFloat bottomMargin = IphoneX ? 34 : 0;
    richTableView.delegate = self;
    richTableView.dataSource = self;
    [richTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    richTableView.tableFooterView = [[UIView alloc] init];
}
#pragma mark - 绑定银行卡成功 ----
- (void)bindBankCardSuccess{
    [self getAccountBankBalance];
}
#pragma mark - 提现 ----
- (void)getCash{
 
    if (self.balance < [self.limitNum floatValue]) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"不足%.2f不可提现!",[self.limitNum floatValue]]];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getCash:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        NSString *retMsg = info[@"retMsg"];
        if ([retCode isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"申请成功"];
            [self getAccountBankBalance];
        }else{
            [MBProgressHUD showError:retMsg];
        }
        
        
    } onError:^(NSError *error) {
          [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)dealloc{
    NSLog(@"%@--------dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initDataSource{
    
    self.dataInfo = @[
                      @{
                          @"title":@"收益明细",
                          @"subtitle":@"查看",
                          @"indicateImg":@""
                          },
                      @{
                          @"title":@"我的银行卡",
                          @"subtitle":@"未绑定",
                          @"indicateImg":@""
                          },
                      @{
                          @"title":@"提现记录",
                          @"subtitle":@"",
                          @"indicateImg":@""
                          }
                      ];
    
    [self.richTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *richCellId = @"richCellID";
    YHRichesCell *richCell = [tableView dequeueReusableCellWithIdentifier:richCellId];
    if (!richCell) {
        richCell = [[NSBundle mainBundle] loadNibNamed:@"YHRichesCell" owner:nil options:nil].firstObject;
        richCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    richCell.info = self.dataInfo[indexPath.row];
    
    if (indexPath.row == 1) {
        NSString *bindStr = [self.isBindCard isEqualToString:@"0"] ? @"未绑定" : @"";
        [richCell setPremptText:bindStr];
    }
    
    return richCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconImgV = [[UIImageView alloc] init];
    iconImgV.image = [UIImage imageNamed:@"cashIcon"];
    [iconImgV sizeToFit];
    [contentView addSubview:iconImgV];
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(iconImgV.superview);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:17.0];
    titleL.text = @"财富管理";
    titleL.textColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
    [titleL sizeToFit];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgV.mas_right).offset(10);
        make.centerY.equalTo(iconImgV);
    }];
    
    return contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        YHProfitDetailController *profitVc = [[YHProfitDetailController alloc] init];
        [self.navigationController pushViewController:profitVc animated:YES];
    }
    if (indexPath.row == 1) {
        
        if ([self.isBindCard isEqualToString:@"0"]) {
            // 未绑定
           YHRichBindBankCardController *bindCardVc = [[YHRichBindBankCardController alloc] init];
            bindCardVc.isModifyBank = NO;
            bindCardVc.bankCardId = @"";
           [self.navigationController pushViewController:bindCardVc animated:YES];
            
        }else{
            
            YHMyBankCardController *myBankVc = [[YHMyBankCardController alloc] init];
            [self.navigationController pushViewController:myBankVc animated:YES];
        }
    }
    
    if (indexPath.row == 2) {
        YHGetCashRecordController *getCashVc = [[YHGetCashRecordController alloc] init];
        [self.navigationController pushViewController:getCashVc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
