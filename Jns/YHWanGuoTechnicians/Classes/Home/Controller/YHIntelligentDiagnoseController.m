//
//  YHIntelligentDiagnoseController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHIntelligentDiagnoseController.h"
#import "YHDiagnoseView.h"
#import "YHPushPhoneView.h"
#import "YHPushPhoneView.h"
#import "YHBaseRepairTableViewCell.h"

#import "YHRepairAddController.h"

#import "YHIntelligentCheckModel.h"
#import <MJExtension.h>
#import "YHWebFuncViewController.h"
#import "YHNoPayStatusView.h"

#import "YHCarPhotoService.h"

#import "WXPay.h"

@interface YHIntelligentDiagnoseController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *repairTableview;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, strong) NSMutableArray *repairTitleArr;
@property (nonatomic, assign) BOOL isNOEdit;
@property (nonatomic,copy) NSDictionary *repairCellInfo;
@property(nonatomic, strong) YHReportModel *reportModel;
@property (nonatomic, strong) NSMutableArray *intelligentInfo;
@property (nonatomic, strong) NSMutableArray *repairProjectArr;
@property (nonatomic, strong) NSMutableDictionary *qualityItemDict;
@property (nonatomic, strong) NSMutableArray *parttypeList;
@property (nonatomic, strong) NSMutableArray *partTypeNameList;
@property (nonatomic, strong) YHSchemeModel *schemeModel;
@property (nonatomic, strong) NSString *pushPhone;

@property (nonatomic, weak) YHNoPayStatusView *noPayView;

@end

@implementation YHIntelligentDiagnoseController

- (YHNoPayStatusView *)noPayView{
    if (!_noPayView) {
       
    CGFloat bottonMargin = iPhoneX ? 34 : 0;
    CGFloat topMargin = IphoneX ? 88 : 64;
    
    YHNoPayStatusView *noPayView = [[NSBundle mainBundle] loadNibNamed:@"YHNoPayStatusView" owner:nil options:nil].firstObject;
    [self.view addSubview:noPayView];
    [self.view bringSubviewToFront:noPayView];
    [noPayView.immediatelyPayBtn addTarget:self action:@selector(immediatelyPayBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [noPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@(bottonMargin));
    }];
        _noPayView = noPayView;
    }
    return _noPayView;
}
#pragma mark --- 立即购买 ---
- (void)immediatelyPayBtnClickEvent{
    
    [[YHCarPhotoService new] airConditionOrderPay:self.order_id success:^(NSDictionary *info) {
        
        [[WXPay sharedWXPay] payByParameter:info success:^{
            NSLog(@"支付成功");
            [self getIntelligentReport];
        } failure:^{
             NSLog(@"支付失败");
            [self getIntelligentReport];
        }];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setBase];
    [self setUI];
    [self getIntelligentReport];
    [self getPartTypeList];
    [self setData];
}

- (void)getPartTypeList{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getPartTypeList:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            NSDictionary *dataDict = info[@"data"];
            NSArray *partTypeList = dataDict[@"list"];
            
            NSMutableArray *partTypeNameList = [NSMutableArray array];
            for (NSDictionary *element in partTypeList) {
                NSString *value = element[@"value"];
                [partTypeNameList addObject:value];
            }
            self.partTypeNameList = partTypeNameList;
            self.parttypeList = [NSMutableArray arrayWithArray:partTypeList] ;
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)getIntelligentReport{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getIntelligentCheckReport:[YHTools getAccessToken] order_id:self.order_id onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
           YHReportModel *reportModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            YHSchemeModel *schemeModel = reportModel.maintain_scheme[0];
            self.schemeModel = schemeModel;
            
           NSDictionary *order_info = info[@"data"][@"order_info"];
            if ([order_info[@"pay_status"] isEqualToString:@"0"]) { // 未支付
                self.noPayView.diagnoseContentL.text = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                [self.noPayView.immediatelyPayBtn setTitle:[NSString stringWithFormat:@"马上购买（￥%@）",order_info[@"pay_price"]] forState:UIControlStateNormal];
            }else{
                [self.noPayView removeFromSuperview];
                self.noPayView = nil;
                self.repairTableview.hidden = NO;
            }
            
            if (self.schemeModel.quality_km.floatValue == 0) {
                self.schemeModel.quality_km = @"";
            }
            
            if (self.schemeModel.quality_time.floatValue == 0) {
                self.schemeModel.quality_time = @"";
            }
            
            [schemeModel.parts enumerateObjectsUsingBlock:^(YHPartsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.part_price.floatValue == 0) {
                    obj.part_price = @"";
                }
                if (obj.part_count.intValue == 0) {
                    obj.part_count = @"";
                }
            }];
            [schemeModel.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.consumable_price.floatValue == 0) {
                    obj.consumable_price = @"";
                }
                if (obj.consumable_count.intValue == 0) {
                    obj.consumable_count = @"";
                }
            }];
            [schemeModel.labor enumerateObjectsUsingBlock:^(YHLaborModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.labor_price.floatValue == 0) {
                    obj.labor_price = @"";
                }
            }];
            self.reportModel = reportModel;
            [self.repairTableview reloadData];
        }
        
        NSLog(@"----------%@",info);
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (YHSchemeModel *)schemeModel{
    if (!_schemeModel) {
        YHSchemeModel *schemeModel = self.reportModel.maintain_scheme[0];
        _schemeModel = schemeModel;
    }
    return _schemeModel;
}

- (void)setData{
    
    self.repairTitleArr = [NSMutableArray array];
    
    [self.repairTitleArr addObject:@"诊断结果"];
    [self.repairTitleArr addObject:@"设置配件"];
    [self.repairTitleArr addObject:@"设置耗材"];
    [self.repairTitleArr addObject:@"维修项目"];
    [self.repairTitleArr addObject:@"维修总计"];
    [self.repairTitleArr addObject:@"质保内容"];
    [self.repairTitleArr addObject:@"推送手机号"];
    
    [self repairCellInfo];
    
}

- (void)setBase{
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.title = @"AI智能检测";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextContentChange:) name:@"textChangeWriteData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repairTextChangeNoti:) name:@"repairTextChange_notification" object:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新诊断" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClickEvent)];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}

- (void)textFieldTextContentChange:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    NSString *text = userInfo[@"textContent"];
    
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            self.schemeModel.quality_time = text;
        }
        
        if (indexPath.row == 1) {
            self.schemeModel.quality_km = text;
        }
    }
    [self.repairTableview reloadData];
}

- (void)repairTextChangeNoti:(NSNotification *)noti{
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}

- (void)popViewController:(id)sender{
    __block YHWebFuncViewController *vc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            vc = obj;
            *stop = YES;
        }
    }];
    
    NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"airCondition",@"token":[YHTools getAccessToken]} mj_JSONString];
    [vc appToH5:json];
}

- (void)rightBtnClickEvent{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI{
    
    CGFloat bottonMargin = iPhoneX ? 34 : 0;
    CGFloat topMargin = IphoneX ? 88 : 64;
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.repairTableview = tableview;
    tableview.hidden = YES;
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10 + topMargin));
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(tableview.superview).offset(-bottonMargin);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 73)];
    UIButton *bottomBtn = [UIButton new];
    self.bottomBtn = bottomBtn;
    //[bottomBtn setTitle:@"推送车主" forState:UIControlStateNormal];
    [bottomBtn setTitle:@"生成报告" forState:UIControlStateNormal];

    [bottomBtn addTarget:self action:@selector(bottomBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 8.0;
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.backgroundColor = YHNaviColor;
    [footView addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-20));
    }];
    tableview.tableFooterView = footView;

    if (@available(iOS 11.0, *)) {
        self.repairTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.repairTableview.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
}

- (NSDictionary *)repairCellInfo{
    if (!_repairCellInfo) {
        NSString *repairInfoPath  = [[NSBundle mainBundle] pathForResource:@"YHIntelligentCellList.plist" ofType:nil];
        NSDictionary *repairCellInfo = [NSDictionary dictionaryWithContentsOfFile:repairInfoPath];
        _repairCellInfo = repairCellInfo;
    }
    return _repairCellInfo;
}

- (NSMutableDictionary *)titleInfo{

    YHSchemeModel *schemeModel = self.reportModel.maintain_scheme[0];
    NSMutableDictionary *titleInfo = [NSMutableDictionary dictionary];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:@"0"];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:1] forKey:@"6"];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.repairProjectArr.count] forKey:@"4"];
    [titleInfo setValue:self.isNOEdit ? @1 : @2 forKey:@"5"];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.labor.count] forKey:@"3"];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.consumable.count] forKey:@"2"];
    [titleInfo setValue:[NSNumber numberWithUnsignedInteger:schemeModel.parts.count] forKey:@"1"];

    return titleInfo;
}
#pragma 底部按钮点击事件 ----
- (void)bottomBtnClickEvent:(UIButton *)bottomBtn{
    
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        [resultDict setValue:[YHTools getAccessToken] forKey:@"token"];
        [resultDict setValue:self.order_id forKey:@"order_id"];
    
        BOOL isLeastExistOne = NO;
        // 配件
        if (self.schemeModel.parts.count > 0) {
            NSMutableArray *partArr = [NSMutableArray array];
            for (YHPartsModel *partModel in self.schemeModel.parts) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                if (!partModel.part_name.length) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件名称不能为空",partModel.part_name]];
                    return ;
                }
                [mutableDict setValue:partModel.part_name forKey:@"part_name"];
                [mutableDict setValue:partModel.part_type forKey:@"part_type"];
                
                if (!partModel.part_unit.length) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件单位不能为空",partModel.part_name]];
                    return ;
                }
                [mutableDict setValue:partModel.part_unit forKey:@"part_unit"];
                
                if (IsEmptyStr(partModel.part_count)) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件数量不能为空",partModel.part_name]];
                    return ;
                }
                [mutableDict setValue:partModel.part_count forKey:@"part_count"];
                
                if (IsEmptyStr(partModel.part_price)) {
                     [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件价格不能为空",partModel.part_name]];
                    return ;
                }
                [mutableDict setValue:partModel.part_price forKey:@"part_price"];
                [partArr addObject:mutableDict];
            }
            
            [resultDict setValue:partArr forKey:@"parts"];
            if (partArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        // 耗材
        if (self.schemeModel.consumable.count > 0) {
            
            NSMutableArray *consumableArr = [NSMutableArray array];
            for (YHConsumableModel *consumableModel in self.schemeModel.consumable) {
                NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
                if (!consumableModel.consumable_name.length) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材名称不能为空",consumableModel.consumable_name]];
                    return ;
                }
                [consumableDict setValue:consumableModel.consumable_name forKey:@"consumable_name"];
                [consumableDict setValue:consumableModel.consumable_standard forKey:@"consumable_standard"];
                
                if (!consumableModel.consumable_unit.length) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材单位不能为空",consumableModel.consumable_name]];
                    return ;
                }
                [consumableDict setValue:consumableModel.consumable_unit forKey:@"consumable_unit"];
                
                if (IsEmptyStr(consumableModel.consumable_count)) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材数量不能为空",consumableModel.consumable_name]];
                    return ;
                }
                [consumableDict setValue:consumableModel.consumable_count forKey:@"consumable_count"];
                
                if (IsEmptyStr(consumableModel.consumable_price)) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材价格不能为空",consumableModel.consumable_name]];
                    return ;
                }
                [consumableDict setValue:consumableModel.consumable_price forKey:@"consumable_price"];
                [consumableArr addObject:consumableDict];
            }
            
            [resultDict setValue:consumableArr forKey:@"consumable"];
            if (consumableArr.count) {
                isLeastExistOne = YES;
            }
        }
        // 维修项目
    if (self.schemeModel.labor.count > 0) {
        
        NSMutableArray *laborArr = [NSMutableArray array];
        for (YHLaborModel *laborModel in self.schemeModel.labor) {
            NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
            if (!laborModel.labor_name.length) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目名称不能为空",laborModel.labor_name]];
                return ;
            }
            [laborDict setValue:laborModel.labor_name forKey:@"labor_name"];
            
            if (IsEmptyStr(laborModel.labor_price)) {
                 [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目价格不能为空",laborModel.labor_name]];
                return ;
            }
            [laborDict setValue:laborModel.labor_price forKey:@"labor_price"];
            [laborArr addObject:laborDict];
        }
        [resultDict setValue:laborArr forKey:@"labor"];
        if (laborArr.count) {
            isLeastExistOne = YES;
        }
    }
        
    if (!isLeastExistOne) {
        [MBProgressHUD showError:@"配件、耗材、维修项目至少要存在一个才能提交"];
        return ;
    }
    if (!self.schemeModel.quality_km) {
        [MBProgressHUD showError:@"质保公里不能为空！"];
        return ;
    }
    [resultDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
    if (!self.schemeModel.quality_time) {
        [MBProgressHUD showError:@"质保时长不能为空！"];
        return ;
    }
    [resultDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
    if (!self.pushPhone) {
        [MBProgressHUD showError:@"推送手机号不能为空！"];
        return ;
    }
    if (self.pushPhone.length != 11) {
        [MBProgressHUD showError:@"手机号码输入有误"];
        return ;
    }
    
    [resultDict setValue:self.pushPhone forKey:@"push_phone"];
    
    [bottomBtn YH_showStartLoadStatus];
    //bottomBtn.YH_loadStatusTitle = @"推送中...";
    bottomBtn.YH_loadStatusTitle = @"生成中...";

    [[YHNetworkPHPManager sharedYHNetworkPHPManager] savePushIntelligentCheckReport:resultDict onComplete:^(NSDictionary *info) {
        [bottomBtn YH_showEndLoadStatus];
        //bottomBtn.YH_normalTitle = @"推动车主";
        bottomBtn.YH_normalTitle = @"生成报告";

        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            //[MBProgressHUD showError:@"推送成功"];
            [MBProgressHUD showError:@"生成成功"];

            [self popViewController:nil];
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
    } onError:^(NSError *error) {
        [bottomBtn YH_showEndLoadStatus];
        //bottomBtn.YH_normalTitle = @"推动车主";
        bottomBtn.YH_normalTitle = @"生成报告";
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *sec = [NSString stringWithFormat:@"%ld",section];
    return [self.titleInfo[sec] integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *cellInfo = self.repairCellInfo[[NSString stringWithFormat:@"%ld",indexPath.section]];
    NSString *cellNameString = cellInfo[@"cellClass"];
    NSString *cellID =  [NSString stringWithFormat:@"%@_%ld",cellNameString,indexPath.section];
    YHBaseRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellNameString owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    // 删除
    __weak typeof(self)weakSelf = self;
    cell.removeCallBack = ^(NSIndexPath *indexPath) {
        [weakSelf removeItemForCell:indexPath];
    };
    // 点击分类
    cell.selectClassClickEvent = ^(NSIndexPath *indexPath) {
        [weakSelf alertListForSelect:indexPath];
    };
    
    void (^operation)(void) = [self getCellDataWithKey:indexPath cell:cell];
    if (operation) {
        operation();
    }
    
    NSString *sec = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSInteger rows = [self.titleInfo[sec] integerValue];
    if (indexPath.row == (rows - 1) && (rows >= 1)) {
        cell.isNeedRaidus = YES;
        cell.isHiddenSeprateLine = YES;
    }
    
    return cell;
}
- (void)alertListForSelect:(NSIndexPath *)indexPath{
    
    if (!(self.parttypeList.count > 1)) {
        return;
    }
    
      UITableViewCell *cell = [self.repairTableview cellForRowAtIndexPath:indexPath];
      [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.partTypeNameList popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
          popover.sourceView = cell;
          popover.sourceRect = cell.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex < 2) {
            return ;
        }
        YHPartsModel *partModel = self.schemeModel.parts[indexPath.row];
        NSDictionary *element = self.parttypeList[buttonIndex - 2];
        partModel.part_type = [NSString stringWithFormat:@"%@",element[@"id"]];
        partModel.part_type_name = [NSString stringWithFormat:@"%@",element[@"value"]];
        [self.repairTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark - 删除cell ---
- (void)removeItemForCell:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [self.schemeModel.parts removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 2) {
        [self.schemeModel.consumable removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 3) {
        [self.schemeModel.labor removeObjectAtIndex:indexPath.row];
    }
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}

- (void)reCountTotalPrice{
    // 维修项目
    __block CGFloat repairProjectTotalPrice = 0;
    // 配件耗材
    __block CGFloat partTotalPrice = 0;
    __block CGFloat consumableTotalPrice = 0;
    [self.schemeModel.parts enumerateObjectsUsingBlock:^(YHPartsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        partTotalPrice += [obj.part_price floatValue] *[obj.part_count floatValue];
    }];
    
    [self.schemeModel.consumable enumerateObjectsUsingBlock:^(YHConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        consumableTotalPrice += [obj.consumable_price floatValue] * [obj.consumable_count floatValue];
    }];
    
    [self.schemeModel.labor enumerateObjectsUsingBlock:^(YHLaborModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        repairProjectTotalPrice += [obj.labor_price floatValue];
    }];
    self.schemeModel.labor_total = [NSString stringWithFormat:@"%.2f",repairProjectTotalPrice];
    self.schemeModel.total_price = [NSString stringWithFormat:@"%.2f",partTotalPrice + repairProjectTotalPrice + consumableTotalPrice];
    self.schemeModel.parts_total = [NSString stringWithFormat:@"%f",partTotalPrice];
    self.schemeModel.consumable_total = [NSString stringWithFormat:@"%f",consumableTotalPrice];
}

- (NSMutableArray *)repairProjectArr{
    
    YHSchemeModel *schemeModel = self.reportModel.maintain_scheme[0];
    
    _repairProjectArr = [NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:schemeModel.labor_total forKey:@"price"];
    [dict1 setValue:@"维修项目" forKey:@"name"];
    [_repairProjectArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:[NSString stringWithFormat:@"%.2f",schemeModel.consumable_total.floatValue + schemeModel.parts_total.floatValue] forKey:@"price"];
    [dict2 setValue:@"配件耗材" forKey:@"name"];
    [_repairProjectArr addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:[NSString stringWithFormat:@"%.2f",(schemeModel.consumable_total.floatValue + schemeModel.parts_total.floatValue + [schemeModel.labor_total floatValue])] forKey:@"price"];
    [dict3 setValue:@"合计" forKey:@"name"];
    [_repairProjectArr addObject:dict3];
    return _repairProjectArr;
}

- (NSMutableDictionary *)qualityItemDict{
    
    _qualityItemDict = [NSMutableDictionary dictionary];
    if (self.isNOEdit) {
        
        NSMutableString *textString1 = [NSMutableString string];
        if (self.schemeModel.quality_time > 0){
            
            if (self.schemeModel.quality_time.integerValue >= 12) {
                NSInteger year = self.schemeModel.quality_time.integerValue / 12;
                NSInteger value = self.schemeModel.quality_time.integerValue % 12;
                if (year > 0) {
                    [textString1 appendString:[NSString stringWithFormat:@"%ld年",year]];
                    if (value > 0) {
                        [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                    }
                }else{
                    [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                }
            }else{
                [textString1 appendString:[NSString stringWithFormat:@"%ld个月",self.schemeModel.quality_time.integerValue]];
            }
        }
        NSMutableString *textString2 = [NSMutableString string];
        if (self.schemeModel.quality_km.integerValue > 0) {
            
            NSInteger num1 = self.schemeModel.quality_km.integerValue/10000; // 万
            NSInteger num2 = self.schemeModel.quality_km.integerValue % 10000;
            NSInteger num3 = num2 / 1000;  // 千
            NSInteger num4 = num2 % 1000;
            NSInteger num5 = num4 / 100; // 百
            if (num1 > 0) {
                if (num3 > 0 || num5 > 0) {
                    [textString2 appendString:[NSString stringWithFormat:@"%ld.%ld%ld万公里",num1,num3,num5]];
                }else{
                    [textString2 appendString:[NSString stringWithFormat:@"%ld万公里",num1]];
                }
            }else{
                [textString2 appendString:[NSString stringWithFormat:@"%ld公里",num2]];
            }
        }
        NSMutableString *resultString = [NSMutableString string];
        if (textString1.length > 0) {
            [resultString appendString:textString1];
            if (textString2.length > 0) {
                [resultString appendString:@"或"];
                [resultString appendString:textString2];
            }
        }else{
            if (textString2.length > 0) {
                [resultString appendString:textString2];
            }else{
                [resultString appendString:@"无质保"];
            }
        }
        [_qualityItemDict setValue:resultString forKey:@"text"];
    }else{
        
        [_qualityItemDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_km] forKey:@"quality_km"];
        [_qualityItemDict setValue:[NSString stringWithFormat:@"%@",self.schemeModel.quality_time] forKey:@"quality_time"];
    }
    
    return _qualityItemDict;
}

- (void (^)(void))getCellDataWithKey:(NSIndexPath *)indexPath cell:(YHBaseRepairTableViewCell *)cell{
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSMutableDictionary *dictOperation = [NSMutableDictionary dictionary];
    
    void(^operation)(void) = ^(void) {
        YHCheckResultArrModel *checkResultArrModel = self.reportModel.checkResultArr;
        cell.cellModel = checkResultArrModel.makeResult;
    };
    void(^operation1)(void) = ^(void) {
        cell.cellModel = self.schemeModel.parts[indexPath.row];
    };
    void (^operation2)(void) = ^(void) {
        cell.cellModel = self.schemeModel.consumable[indexPath.row];
    };
    void (^operation3)(void) = ^(void) {
        cell.cellModel = self.schemeModel.labor[indexPath.row];
    };
    void (^operation4)(void) = ^(void) {
        cell.cellModel = self.repairProjectArr[indexPath.row];
    };
    void (^operation5)(void) = ^(void) {
        cell.cellModel = self.qualityItemDict;
    };
    // 推送手机号
    void(^operation6)(void) = ^(void) {
        
        YHPushPhoneView *pushPhoneCell = (YHPushPhoneView *)cell;
        pushPhoneCell.phoneTft.text = self.pushPhone ? self.pushPhone : @"";
        __weak typeof(self)weakSelf = self;
        pushPhoneCell.textEditEndCallBack = ^(NSString * _Nonnull text) {
            weakSelf.pushPhone = text;
        };
    };
    
    [dictOperation setValue:operation forKey:@"0"];
    [dictOperation setValue:operation1 forKey:@"1"];
    [dictOperation setValue:operation2 forKey:@"2"];
    [dictOperation setValue:operation3 forKey:@"3"];
    [dictOperation setValue:operation4 forKey:@"4"];
    [dictOperation setValue:operation5 forKey:@"5"];
    [dictOperation setValue:operation6 forKey:@"6"];
    
    return dictOperation[key];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *sectionL = [UILabel new];
    sectionL.font = [UIFont boldSystemFontOfSize:18.0];
    [sectionView addSubview:sectionL];
    [sectionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.bottom.equalTo(@(-10));
    }];
    sectionL.text = self.repairTitleArr[section];
    
    UIButton *addBTn = [UIButton new];
    
    if (section == 0 || section > 3) {
        addBTn.hidden = YES;
    }else{
        addBTn.hidden = NO;
    }
    
    addBTn.tag = section + 999;
    [addBTn setTitle:@"增加" forState:UIControlStateNormal];
    [addBTn setTitleColor:[UIColor colorWithRed:63.0/255.0 green:159.0/255.0 blue:245.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    addBTn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    addBTn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    [sectionView addSubview:addBTn];
    [addBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionL);
        make.right.equalTo(@(-15));
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    [addBTn addTarget:self action:@selector(addItme:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sectionView setRounded:sectionView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
    });

    
    return sectionView;
}
#pragma mark - 增加 ---
- (void)addItme:(UIButton *)addBTn{
    
    YHRepairAddController *repairAddVc = [YHRepairAddController new];
    repairAddVc.base_info = self.reportModel.base_info;
    repairAddVc.repairType = (addBTn.tag - 1) - 999;
    __weak typeof(self)weakSelf = self;
    repairAddVc.addDataBlock = ^(NSArray *finalArr, NSInteger section) {
            section += 1;
        for (NSDictionary *element in finalArr) {

            if (section == 1) {
                YHPartsModel *partModel = [YHPartsModel mj_objectWithKeyValues:element];
                [weakSelf.schemeModel.parts addObject:partModel];
            }
            if (section == 2) {
                YHConsumableModel *consumableModel = [YHConsumableModel mj_objectWithKeyValues:element];
                [weakSelf.schemeModel.consumable addObject:consumableModel];
            }
            if (section == 3) {
                YHLaborModel *laborModel = [YHLaborModel mj_objectWithKeyValues:element];
                [weakSelf.schemeModel.labor addObject:laborModel];
            }
        }
        [weakSelf reCountTotalPrice];
        [weakSelf.repairTableview reloadData];
    };
    [self.navigationController pushViewController:repairAddVc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
       YHCheckResultArrModel *checkResultArrModel = self.reportModel.checkResultArr;
        
        CGFloat diagnoseHeight = [checkResultArrModel.makeResult boundingRectWithSize:CGSizeMake(screenWidth - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
       return diagnoseHeight + 90;
    }else{
        NSDictionary *cellInfo = self.repairCellInfo[[NSString stringWithFormat:@"%ld",indexPath.section]];
        return [cellInfo[@"cellHeight"] integerValue];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 45;
    }
}
@end
