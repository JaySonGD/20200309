//
//  YHCarVersionVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarVersionVC.h"
#import "YHCarVersionCell.h"
#import "YHDiagnosisBaseVC.h"
#import "YHDiagnosisBaseTC.h"
#import "YHNetworkPHPManager.h"
#import <MJRefresh.h>
#import "YHTools.h"
#import "YHCarVersionModel.h"
#import <MJExtension.h>
#import "UIColor+ColorChange.h"
#import <Masonry.h>
//#import "MBProgressHUD+MJ.h"

static NSString * const YHCarVersionCellID = @"YHCarVersionCellID";

@interface YHCarVersionVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic)YHCarVersionCell *cell;
@property (nonatomic, strong) NSMutableArray *carVersionArray;  //汽车版本数组
@property (nonatomic, assign) NSInteger page;                    //页面标识tag
@property(nonatomic,strong)UILabel *label;                       //标题头部标签

@property(nonatomic,assign)BOOL isSelect;           //是否选中;

@property(nonatomic,strong)YHCarVersionModel *model;  //保存用户点击模型

@property(nonatomic,assign)BOOL isSelected;   //是否选中

/**
 确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *carVersionBtn;


@end

@implementation YHCarVersionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];

    [self initData];
}

#pragma mark - initUI
- (void)initUI
{
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"选择车辆版本";
    
    //注册cell
    [self.tableView registerClass:[YHCarVersionCell class] forCellReuseIdentifier:YHCarVersionCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e5"].CGColor;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 10;
    self.sureBtn.layer.masksToBounds = YES;
}

#pragma mark - initData(请求汽车版本数据)
- (void)initData
{
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]checkTheCarCreateNewWorkOrderWithToken:[YHTools getAccessToken] Vin:self.vinStr onComplete:^(NSDictionary *info) {
        
        NSLog(@"===2.汽车版本数据:%@===",info);
        
        if ([info[@"code"] longLongValue] == 20000) {
            
            for (NSDictionary *dict in info[@"data"]) {
                 YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:dict];
                [self.carVersionArray addObject:model];
            }
            
            YHCarVersionModel *lastModel = [YHCarVersionModel new];
            lastModel.carModelFullName = @"其它";
            [self.carVersionArray addObject:lastModel];
            
            [self.tableView reloadData];
        }
    } onError:^(NSError *error) {

    }];
}

#pragma mark - TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.carVersionArray count]?1:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carVersionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCarVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:YHCarVersionCellID];
    cell.model = self.carVersionArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cell = cell;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 55)];
        //添加标签
        UILabel * label = [[UILabel alloc]init];
        self.label = label;
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.centerX.mas_equalTo(headerView);
            make.center.centerY.mas_equalTo(headerView);
        }];
        
        //顶部标题栏
        YHCarVersionModel *model = self.carVersionArray[section];
        if ([model.carLineName containsString:model.carBrandName]) {
            self.label.text = model.carLineName;
        }else{
            self.label.text = [NSString stringWithFormat:@"%@%@",model.carBrandName,model.carLineName];
        }
        
        //添加下划线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height - 1, headerView.frame.size.width, 1)];
        [headerView addSubview:line];
        line.backgroundColor = [UIColor colorWithHexString:@"e2e2e5"];
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCarVersionCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    YHCarVersionModel *model = self.carVersionArray[indexPath.row];
    self.model = model;
    model.isSelect = 1;
    self.isSelected = 1;
    [cell.selectBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCarVersionCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    YHCarVersionModel *model = self.carVersionArray[indexPath.row];
    model.isSelect = 0;
    self.isSelected = 0;
    [cell.selectBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
}

#pragma mark - 点击确定提交(选择车辆版本)
- (IBAction)chooseCarVersion:(UIButton *)sender
{
    kPreventRepeatClickTime(1); //防止重复点击
    if (self.isSelected ==1) {
        YHDiagnosisBaseVC *baseVC = [[YHDiagnosisBaseVC alloc]init];
        baseVC.isHelp = NO;
        if ([self.model.carModelFullName isEqualToString:@"其它"]) {//判断这个字段是否为其它  或者判断是否为数组最后一个
            baseVC.isOther = 1;
        }else{
            baseVC.model = self.model;
        }
        baseVC.vinStr = self.vinStr;
        baseVC.bucheBookingId = self.bucheBookingId;
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }else{
        [MBProgressHUD showError:@"请选择车辆版本" toView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)carVersionArray
{
    if (!_carVersionArray) {
        _carVersionArray = [[NSMutableArray alloc]init];
    }
    return _carVersionArray;
}

- (NSMutableArray *)carver
{
    if (!_carVersionArray) {
        _carVersionArray = [[NSMutableArray alloc]init];
    }
    return _carVersionArray;
}



@end
