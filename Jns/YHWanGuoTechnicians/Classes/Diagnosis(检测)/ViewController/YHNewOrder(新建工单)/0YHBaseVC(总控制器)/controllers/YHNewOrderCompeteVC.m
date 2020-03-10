//
//  YHNewOrderCompeteVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/11.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHNewOrderCompeteVC.h"

#import "YHNewOrderComptCell.h"
#import <Masonry.h>
#import "YHTools.h"
#import "YHNetworkPHPManager.h"

#import "YHCommon.h"
#import "YHDiagnosisProjectVC.h"
#import "YHPhotoManger.h"
#import <MJExtension.h>

#import "TTZDBModel.h"
#import "TTZUpLoadService.h"
#import "NSObject+BGModel.h"

@interface YHNewOrderCompeteVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *comptInfoTableView;
/** 上一次选择的cell */
@property (nonatomic, weak) YHNewOrderComptCell *lastCell;

@end

@implementation YHNewOrderCompeteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseData];
    
    [self initUI];
}
- (void)initBaseData{
   
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] createNew:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *data = info[@"data"];
        NSArray *tech_list = data[@"tech_list"];
        NSArray *techArr = [NSArray arrayWithArray:tech_list];
        if (techArr.count) {
            NSMutableArray *infoArr = [NSMutableArray array];
            for (NSDictionary *dict in techArr) {
                BOOL isE001AndTure = [dict[@"is_E001"] boolValue];
                if (isE001AndTure) {
                    NSMutableDictionary *requareInfo = [NSMutableDictionary dictionary];
                    [requareInfo setValue:dict[@"realname"] forKey:@"realname"];
                    [requareInfo setValue:dict[@"userOpenId"] forKey:@"userOpenId"];
                    [infoArr addObject:requareInfo];
                }
            }
#ifdef DEBUG
//            if (!infoArr.count) {
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                [dict setValue:@"哈哈" forKey:@"realname"];
//                [dict setValue:@"123456" forKey:@"userOpenId"];
//                [infoArr addObject:dict];
//
//                NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
//                [dict1 setValue:@"呵呵" forKey:@"realname"];
//                [dict1 setValue:@"123456" forKey:@"userOpenId"];
//                [infoArr addObject:dict1];
//
//                NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
//                [dict2 setValue:@"哼哼" forKey:@"realname"];
//                [dict2 setValue:@"123456" forKey:@"userOpenId"];
//                [infoArr addObject:dict2];
//            }
#else
            
#endif
            self.technicianArr = [NSArray arrayWithArray:infoArr];
            [self.comptInfoTableView reloadData];
        };
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)initUI{
    
    self.title = @"指派技师";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 确定按钮
    UIButton *sureBTn = [[UIButton alloc] init];
    sureBTn.backgroundColor = YHNaviColor;
    sureBTn.layer.borderColor = sureBTn.backgroundColor.CGColor;
    sureBTn.layer.borderWidth = 1.0;
    sureBTn.layer.cornerRadius = 10.0;
    sureBTn.layer.masksToBounds = YES;
    [sureBTn setTitle:@"确认" forState: UIControlStateNormal];
    [sureBTn addTarget:self action:@selector(sureBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBTn];
    CGFloat safeAreaBottom = iPhoneX ? -34 : -10;
    [sureBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureBTn.superview).offset(safeAreaBottom);
        make.left.equalTo(sureBTn.superview).offset(10);
        make.right.equalTo(sureBTn.superview).offset(-10);
        make.height.equalTo(@50);
    }];
     // tableView
    CGFloat topMargin = iPhoneX ? 88 : 64;
    UITableView *comptInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.comptInfoTableView = comptInfoTableView;
    comptInfoTableView.delegate = self;
    comptInfoTableView.dataSource = self;
    comptInfoTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:comptInfoTableView];
    [comptInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(comptInfoTableView.superview).offset(topMargin);
        make.left.equalTo(comptInfoTableView.superview);
        make.right.equalTo(comptInfoTableView.superview);
        make.bottom.equalTo(sureBTn.mas_top);
    }];
    
//    if (!iPhoneX) {
//        // 状态栏背景view
//        UIView *statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//        statusBarBackground.backgroundColor = YHNaviColor;
//        [self.view addSubview:statusBarBackground];
//    }
}
#pragma mark - sureBtn click event --
- (void)sureBtnClickEvent{
    
    if (!self.lastCell) {
        [MBProgressHUD showError:@"请选择一个技师"];
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    for (id key in self.params.allKeys) {
        id value = self.params[key];
        [parm setObject:value forKey:key];
    }
        NSMutableArray *assign = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *userOpenId = self.lastCell.cellInfo[@"userOpenId"];
        [dict setValue:userOpenId forKey:@"userOpenId"];
        [dict setValue:@"E001" forKey:@"billTypeKey"];
        [dict setValue:@"system" forKey:@"type"];
        [assign addObject:dict];
        [parm setObject:assign forKey:@"assign"];
    
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        //新建工单网络请求
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitBasicInformationWithDictionary:parm isHelp:_isHelp onComplete:^(NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"info------%@",info);
            if ([info[@"code"] longLongValue] == 20000) {//请求成功
                
                NSDictionary *data = info[@"data"];
                NSDictionary *billStatus = data[@"billStatus"];
                NSInteger billId = [billStatus[@"billId"] integerValue];
                // 工单号
                NSString *billIdStr = [NSString stringWithFormat:@"%ld",billId];
                // 权限
                NSString *handleType = billStatus[@"handleType"];
                // 有权限
                if ([handleType isEqualToString:@"handle"]) {
                    //将字典转化成模型
                    YHBillStatusModel *billModel = [YHBillStatusModel mj_objectWithKeyValues:info[@"data"][@"billStatus"]];
                    YHDiagnosisProjectVC *diagnosisProjectVC = [[YHDiagnosisProjectVC alloc] init];
                    
                    diagnosisProjectVC.billModel = billModel;
                    diagnosisProjectVC.isHelp = _isHelp;
                    [self.navigationController pushViewController:diagnosisProjectVC animated:YES];
                    [YHPhotoManger moveItemAtPath:self.vinStr toPath:billModel.billId];
                }
                
                // 无权限 ->跳转到Vin扫描界面
                if ([handleType isEqualToString:@"detail"]) {
                    [self.navigationController popToViewController:self.vinController animated:YES];
                }
                
                [MBProgressHUD showError:@"指派成功" toView:self.navigationController.view];
                [YHPhotoManger moveItemAtPath:self.billId toPath:billIdStr];
                // 上传图片
                [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",billIdStr]];
                //[[TTZUpLoadService sharedTTZUpLoadService] uploadWithAlert];
                //[[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:nil];
                [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:billIdStr didHandle:nil];
                
            }else{  //错误信息提示
                [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];

        }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

#pragma mark - UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.technicianArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"newOrderComptCellId";
    YHNewOrderComptCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YHNewOrderComptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *cellInfo = self.technicianArr[indexPath.row];
        [cell setCellInfo:cellInfo];
    }
    return cell;
}
#pragma mark - UITableViewDelegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHNewOrderComptCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.lastCell) {
        self.lastCell.statusBtn.selected = NO;
    }
    selectCell.statusBtn.selected = YES;
    self.lastCell = selectCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}
@end
