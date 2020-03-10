//
//  YHRichSelectBankController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichSelectBankController.h"
#import <UIImageView+WebCache.h>
#import "YHNetworkManager.h"
#import "YHBankLogoCell.h"

@interface YHRichSelectBankController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *selectBankTableView;

@property (nonatomic, strong) NSMutableArray *bankDataArr;

@end

@implementation YHRichSelectBankController

- (NSMutableArray *)bankDataArr{
    if (!_bankDataArr.count) {
        _bankDataArr = @[
                         @{
                             @"logo":@"1_icbc.png",
                             @"title":@"中国工商银行"
                             },
                         @{
                             @"logo":@"2_abc.png",
                             @"title":@"中国农业银行"
                             },
                         @{
                             @"logo":@"3_bc.png",
                             @"title":@"中国银行"
                             },
                         @{
                             @"logo":@"4_ccb.png",
                             @"title":@"中国建设银行"
                             },
                         @{
                             @"logo":@"5_boc.png",
                             @"title":@"交通银行"
                             },
                         @{
                             @"logo":@"6_sbc.png",
                             @"title":@"中国邮政储蓄银行"
                             },
                         @{
                             @"logo":@"7_cmb.png",
                             @"title":@"招商银行"
                             },
                         @{
                             @"logo":@"8_pab.png",
                             @"title":@"平安银行"
                             },
                         @{
                             @"logo":@"9_cmb.png",
                             @"title":@"民生银行"
                             },
                         @{
                             @"logo":@"10_ceb.png",
                             @"title":@"中国光大银行"
                             },
                         @{
                             @"logo":@"11_hxb.png",
                             @"title":@"华夏银行"
                             },
                         @{
                             @"logo":@"12_ccb.png",
                             @"title":@"中信银行"
                             },
                         @{
                             @"logo":@"13_spdb.png",
                             @"title":@"浦发银行"
                             },
                         @{
                             @"logo":@"14_cgb.png",
                             @"title":@"广发银行"
                             },
                         @{
                             @"logo":@"15_ibc.png",
                             @"title":@"兴业银行"
                             }
                         ].mutableCopy;
    }
    /*
     1_icbc.png 中国工商银行
     2_abc.png 中国农业银行
     3_bc.png 中国银行
     4_ccb.png 中国建设银行
     5_boc.png 交通银行
     6_sbc.png 中国邮政储蓄银行
     7_cmb.png 招商银行
     8_pab.png 平安银行
     9_cmb.png 民生银行
     10_ceb.png 中国光大银行
     11_hxb.png 华夏银行
     12_ccb.png 中信银行
     13_spdb.png 浦发银行
     14_cgb.png 广发银行
     15_ibc.png 兴业银行
     */
    return _bankDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"选择开户行";
    
    UITableView *selectBankTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    selectBankTableView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:239.0/255.0 alpha:1.0];
    selectBankTableView.delegate = self;
    selectBankTableView.dataSource = self;
    self.selectBankTableView = selectBankTableView;
    selectBankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:selectBankTableView];
    
    CGFloat bottomMargin = IphoneX ? 34.0 : 0;
    CGFloat topMargin = IphoneX ? 88.0 : 64.0;
    [selectBankTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    selectBankTableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *richSelectBankCellId = @"richSelectBankCellId";
    YHBankLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:richSelectBankCellId];
    if (cell == nil) {
        cell = [[YHBankLogoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:richSelectBankCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    测试： http://192.168.1.220/files/images/bank_logo/1_icbc.png
//    开发： http://192.168.1.200/files/images/bank_logo/1_icbc.png
    NSDictionary *bankDict = self.bankDataArr[indexPath.row];
    [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s/files/images/bank_logo/%@",SERVER_JAVA_URL,bankDict[@"logo"]]]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *selectBankDict = self.bankDataArr[indexPath.row];
    if (_selectCellEvent) {
        _selectCellEvent(selectBankDict);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
