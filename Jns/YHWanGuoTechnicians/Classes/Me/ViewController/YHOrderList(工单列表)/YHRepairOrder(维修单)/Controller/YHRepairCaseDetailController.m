//
//  YHRepairCaseDetailController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairCaseDetailController.h"
#import "YHRepairCollectionViewCell.h"

#import "YHBaseRepairTableViewCell.h"
#import "YHRepairPartTableViewCell.h"
#import "YHRepairTotalTableViewCell.h"
#import "YHRepairProjectTableViewCell.h"
#import "YHQualityTableViewCell.h"
#import "YHFoursPriceCell.h"

#import "YHRepairAddController.h"
#import "YHRepairMoreView.h"
#import "YHDeleteRepairCaseView.h"

#import "YTPlanModel.h"

#import <MJExtension.h>


@interface YHRepairCaseDetailController () <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *repairTitleArr;

@property (nonatomic,weak) YHDeleteRepairCaseView *repairAlertview;

@property (nonatomic, weak) YHRepairMoreView *moreView;

@property (nonatomic,copy) NSDictionary *repairCellInfo;

@property (nonatomic, weak) UITableView *repairTableview;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSIndexPath *selectIndexPathForCollectionView;

@property (nonatomic, strong) NSMutableArray *parttypeList;

@property (nonatomic, strong) NSMutableArray *partTypeNameList;

@property (nonatomic, strong) YTPlanModel *planModel;

@property (nonatomic, strong) NSMutableArray *repairProjectArr;

@property (nonatomic, strong) NSMutableDictionary *qualityItemDict;

@property (nonatomic, weak) UIButton *bottomBtn;

@property (nonatomic, assign) BOOL isNOEdit;

@property (nonatomic,assign) BOOL is_sysCase;

@property (nonatomic, copy) NSString *price_ssss;

@end

static NSString *repairCollectCellID = @"repairCaseDetail_collectionViewCellId";

@implementation YHRepairCaseDetailController

+ (void)submitRepairCaseModel:(YTDiagnoseModel *)model completeBlock:(void(^)(BOOL isSuccess,NSString *message))completeBlock{
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setValue:[YHTools getAccessToken] forKey:@"token"];
    
    BOOL isLeastExistOne = NO;
    
    if (!model.billId.length) {
        return completeBlock(NO,@"工单ID不能为空");
    }
    [resultDict setValue:model.billId forKey:@"billId"];
    
    YTCResultModel *checkResultModel = model.checkResultArr;
    if ( !checkResultModel.makeResult.length) {
         return completeBlock(NO,@"诊断结果不能为空");
    }
    NSMutableDictionary *checkResult = [NSMutableDictionary dictionary];
    [checkResult setValue:checkResultModel.makeResult forKey:@"makeResult"];
    [resultDict setValue:checkResult forKey:@"checkResult"];
    
    if (model.maintain_scheme.count > 5) {
        return completeBlock(NO,@"维修方案不能多于5个");
    }
   
    NSMutableString *sys_maintain_scheme_ids = [NSMutableString string];
     NSArray *maintain_scheme = model.maintain_scheme;
    NSMutableArray *maintainsschemeLocal = [NSMutableArray array];
    for (YTPlanModel *planModel in maintain_scheme) {
        
        if (planModel.is_sys) {
            [sys_maintain_scheme_ids appendString:[NSString stringWithFormat:@"%@,",planModel.Id]];
            continue;
        }
        NSMutableDictionary *planCaseInfo = [NSMutableDictionary dictionary];
        // 配件
        if (planModel.parts.count > 0) {
            NSMutableArray *partArr = [NSMutableArray array];
            for (YTPartModel *partModel in planModel.parts) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                if (!partModel.part_name.length) {
                   return completeBlock(NO,[NSString stringWithFormat:@"%@的配件名称不能为空",planModel.name]);
                }
                [mutableDict setValue:partModel.part_name forKey:@"part_name"];
                [mutableDict setValue:partModel.part_type forKey:@"part_type"];
                
                if (!partModel.part_unit.length) {
                   return completeBlock(NO,[NSString stringWithFormat:@"%@的配件单位不能为空",planModel.name]);
                }
                [mutableDict setValue:partModel.part_unit forKey:@"part_unit"];
                
                if (!partModel.part_count.length) {
                    return completeBlock(NO,[NSString stringWithFormat:@"%@的配件数量不能为空",planModel.name]);
                }
                [mutableDict setValue:partModel.part_count forKey:@"part_count"];
                
                if (!partModel.part_price.length) {
                    return completeBlock(NO,[NSString stringWithFormat:@"%@的配件价格不能为空",planModel.name]);
                }
                [mutableDict setValue:partModel.part_price forKey:@"part_price"];
                [partArr addObject:mutableDict];
            }
            
            [planCaseInfo setValue:partArr forKey:@"parts"];
            if (partArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        // 耗材
        if (planModel.consumable.count > 0) {
            
            NSMutableArray *consumableArr = [NSMutableArray array];
            for (YTConsumableModel *consumableModel in planModel.consumable) {
                NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
                if (!consumableModel.consumable_name.length) {
                    return completeBlock(NO,[NSString stringWithFormat:@"%@的耗材名称不能为空",planModel.name]);
                }
                [consumableDict setValue:consumableModel.consumable_name forKey:@"consumable_name"];
                [consumableDict setValue:consumableModel.consumable_standard forKey:@"consumable_standard"];
                
                if (!consumableModel.consumable_unit.length) {
                   return completeBlock(NO,[NSString stringWithFormat:@"%@的耗材单位不能为空",planModel.name]);
                }
                [consumableDict setValue:consumableModel.consumable_unit forKey:@"consumable_unit"];
                
                if (!consumableModel.consumable_count.length) {

                    return completeBlock(NO,[NSString stringWithFormat:@"%@的耗材数量不能为空",planModel.name]);
                }
                [consumableDict setValue:consumableModel.consumable_count forKey:@"consumable_count"];
                
                if (!consumableModel.consumable_price.length) {
                     return completeBlock(NO,[NSString stringWithFormat:@"%@的耗材价格不能为空",planModel.name]);
                }
                [consumableDict setValue:consumableModel.consumable_price forKey:@"consumable_price"];
                [consumableArr addObject:consumableDict];
            }
            
             [planCaseInfo setValue:consumableArr forKey:@"consumable"];
            if (consumableArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        if (planModel.labor.count > 0) {
            
            NSMutableArray *laborArr = [NSMutableArray array];
            for (YTLaborModel *laborModel in planModel.labor) {
                NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
                if (!laborModel.labor_name.length) {
                  return completeBlock(NO,[NSString stringWithFormat:@"%@的维修项目名称不能为空",planModel.name]);
                }
                [laborDict setValue:laborModel.labor_name forKey:@"labor_name"];
                
                if (!laborModel.labor_price.length) {
                    return completeBlock(NO,[NSString stringWithFormat:@"%@的维修项目价格不能为空",planModel.name]);
                }
                [laborDict setValue:laborModel.labor_price forKey:@"labor_price"];
                [laborArr addObject:laborDict];
            }
             [planCaseInfo setValue:laborArr forKey:@"labor"];
            if (laborArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        if (!isLeastExistOne) {
           return completeBlock(NO,@"配件、耗材、维修项目至少要存在一个才能提交");
        }
        
        [planCaseInfo setValue:[NSString stringWithFormat:@"%ld",planModel.quality_km] forKey:@"quality_km"];
        [planCaseInfo setValue:[NSString stringWithFormat:@"%ld",planModel.quality_time] forKey:@"quality_time"];
        [maintainsschemeLocal addObject:planCaseInfo];
    }
    if (sys_maintain_scheme_ids.length) {
        NSString *sysScheme = [sys_maintain_scheme_ids substringToIndex:sys_maintain_scheme_ids.length - 1];
         [resultDict setValue:sysScheme forKey:@"sys_maintain_scheme_ids"];
    }

    [resultDict setValue:maintainsschemeLocal forKey:@"maintain_scheme"];
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitRepairCaseData:resultDict onComplete:^(NSDictionary *info) {
    
        if ([[NSString stringWithFormat:@"%@",info[@"code"]] isEqualToString:@"20000"]) {
            completeBlock(YES,@"提交成功");
        }else{
//            completeBlock(NO,@"提交失败");
            completeBlock(NO,info[@"msg"]);

        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark - 提交数据J004 ---
- (void)submitDataForJ004:(YTDiagnoseModel *)model{
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setValue:[YHTools getAccessToken] forKey:@"token"];
    BOOL isLeastExistOne = NO;
    
    if (!model.billId.length) {
        return [MBProgressHUD showError:@"工单ID不能为空"];
    }
    [resultDict setValue:model.billId forKey:@"billId"];
    
    YTCResultModel *checkResultModel = model.checkResultArr;
//    if ( !checkResultModel.makeResult.length) {
//        return [MBProgressHUD showError:@"诊断结果不能为空"];
//    }
    NSMutableDictionary *checkResult = [NSMutableDictionary dictionary];
    [checkResult setValue:checkResultModel.makeResult forKey:@"makeResult"];
    [resultDict setValue:checkResult forKey:@"checkResult"];
    
    NSMutableString *sys_maintain_scheme_ids = [NSMutableString string];
    NSArray *maintain_scheme = model.maintain_scheme;
    NSMutableArray *maintainsschemeLocal = [NSMutableArray array];
    for (YTPlanModel *planModel in maintain_scheme) {
        planModel.name = @"维修方案";
//        if (planModel.is_sys) {
//            [sys_maintain_scheme_ids appendString:[NSString stringWithFormat:@"%@,",planModel.Id]];
//            continue;
//        }
        NSMutableDictionary *planCaseInfo = [NSMutableDictionary dictionary];
        // 配件
        if (planModel.parts.count > 0) {
            NSMutableArray *partArr = [NSMutableArray array];
            for (YTPartModel *partModel in planModel.parts) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                if (!partModel.part_name.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件名称不能为空",planModel.name]];
                }
                [mutableDict setValue:partModel.part_name forKey:@"part_name"];
                [mutableDict setValue:partModel.part_type forKey:@"part_type"];
                
                if (!partModel.part_unit.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件单位不能为空",planModel.name]];
                }
                [mutableDict setValue:partModel.part_unit forKey:@"part_unit"];
                
                if (!partModel.part_count.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件数量不能为空",planModel.name]];
                }
                [mutableDict setValue:partModel.part_count forKey:@"part_count"];
                
                if (!partModel.part_price.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的配件价格不能为空",planModel.name]];
                }
                [mutableDict setValue:partModel.part_price forKey:@"part_price"];
                [partArr addObject:mutableDict];
            }
            
            [planCaseInfo setValue:partArr forKey:@"parts"];
            if (partArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        // 耗材
        if (planModel.consumable.count > 0) {
            
            NSMutableArray *consumableArr = [NSMutableArray array];
            for (YTConsumableModel *consumableModel in planModel.consumable) {
                NSMutableDictionary *consumableDict = [NSMutableDictionary dictionary];
                if (!consumableModel.consumable_name.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材名称不能为空",planModel.name]];
                }
                [consumableDict setValue:consumableModel.consumable_name forKey:@"consumable_name"];
                [consumableDict setValue:consumableModel.consumable_standard forKey:@"consumable_standard"];
                
                if (!consumableModel.consumable_unit.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材单位不能为空",planModel.name]];
                }
                [consumableDict setValue:consumableModel.consumable_unit forKey:@"consumable_unit"];
                
                if (!consumableModel.consumable_count.length) {
                    
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材数量不能为空",planModel.name]];
                }
                [consumableDict setValue:consumableModel.consumable_count forKey:@"consumable_count"];
                
                if (!consumableModel.consumable_price.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的耗材价格不能为空",planModel.name]];
                }
                [consumableDict setValue:consumableModel.consumable_price forKey:@"consumable_price"];
                [consumableArr addObject:consumableDict];
            }
            
            [planCaseInfo setValue:consumableArr forKey:@"consumable"];
            if (consumableArr.count) {
                isLeastExistOne = YES;
            }
        }
        
        if (planModel.labor.count > 0) {
            
            NSMutableArray *laborArr = [NSMutableArray array];
            for (YTLaborModel *laborModel in planModel.labor) {
                NSMutableDictionary *laborDict = [NSMutableDictionary dictionary];
                if (!laborModel.labor_name.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目名称不能为空",planModel.name]];
                }
                [laborDict setValue:laborModel.labor_name forKey:@"labor_name"];
                
                if (!laborModel.labor_price.length) {
                    return [MBProgressHUD showError:[NSString stringWithFormat:@"%@的维修项目价格不能为空",planModel.name]];
                }
                [laborDict setValue:laborModel.labor_price forKey:@"labor_price"];
                [laborArr addObject:laborDict];
            }
            [planCaseInfo setValue:laborArr forKey:@"labor"];
            if (laborArr.count) {
                isLeastExistOne = YES;
            }
        }
        if (self.price_ssss.floatValue > 0) {
            [planCaseInfo setValue:self.price_ssss forKey:@"price_ssss"];
        }
         [maintainsschemeLocal addObject:planCaseInfo];
    }
    
    if (!isLeastExistOne) {
        return [MBProgressHUD showError:@"配件、耗材、维修项目至少要存在一个才能提交"];
    }
    
    if (sys_maintain_scheme_ids.length) {
        NSString *sysScheme = [sys_maintain_scheme_ids substringToIndex:sys_maintain_scheme_ids.length - 1];
        [resultDict setValue:sysScheme forKey:@"sys_maintain_scheme_ids"];
    }
    
    [resultDict setValue:maintainsschemeLocal forKey:@"maintain_scheme"];
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitRepairCaseDataForJ004:resultDict onComplete:^(NSDictionary *info) {
        
        if ([[NSString stringWithFormat:@"%@",info[@"code"]] isEqualToString:@"20000"]) {
            [MBProgressHUD showError:@"提交成功"];
            if (self.refreshOrderStatusBlock) {
                self.refreshOrderStatusBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //[MBProgressHUD showError:@"提交失败"];
            [MBProgressHUD showError:info[@"msg"]];

        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    
}

- (NSDictionary *)repairCellInfo{
    if (!_repairCellInfo) {
        NSString *repairInfoPath  = [[NSBundle mainBundle] pathForResource:@"YHRepairCellList.plist" ofType:nil];
        NSDictionary *repairCellInfo = [NSDictionary dictionaryWithContentsOfFile:repairInfoPath];
        _repairCellInfo = repairCellInfo;
    }
    return _repairCellInfo;
}

- (NSMutableDictionary *)titleInfo{

        NSMutableDictionary *titleInfo = [NSMutableDictionary dictionary];
        [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.repairProjectArr.count] forKey:@"维修总计"];
        [titleInfo setValue:self.isNOEdit ? @1 : @2 forKey:@"质保内容"];
        [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.planModel.labor.count] forKey:@"维修项目"];
        NSString *keyConsumable =  self.isNOEdit ? @"所需耗材" :@"设置耗材";
        [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.planModel.consumable.count] forKey:keyConsumable];
        NSString *keyPart =  self.isNOEdit ? @"所需配件" :@"设置配件";
        [titleInfo setValue:[NSNumber numberWithUnsignedInteger:self.planModel.parts.count] forKey:keyPart];
    
    return titleInfo;
}

- (NSMutableArray *)repairProjectArr{
    
        _repairProjectArr = [NSMutableArray array];
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:self.planModel.labor_total forKey:@"price"];
        [dict1 setValue:@"维修项目" forKey:@"name"];
        [_repairProjectArr addObject:dict1];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setValue:[NSString stringWithFormat:@"%.2f",self.planModel.consumable_total.floatValue + self.planModel.parts_total.floatValue] forKey:@"price"];
        [dict2 setValue:@"配件耗材" forKey:@"name"];
        [_repairProjectArr addObject:dict2];
        
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        [dict3 setValue:[NSString stringWithFormat:@"%.2f",(self.planModel.consumable_total.floatValue + self.planModel.parts_total.floatValue + [self.planModel.labor_total floatValue])] forKey:@"price"];
        [dict3 setValue:@"合计" forKey:@"name"];
        [_repairProjectArr addObject:dict3];
    return _repairProjectArr;
}

- (NSMutableDictionary *)qualityItemDict{
    
     _qualityItemDict = [NSMutableDictionary dictionary];
    if (self.isNOEdit) {
       
        NSMutableString *textString1 = [NSMutableString string];
        if (self.planModel.quality_time > 0){
            
            if (self.planModel.quality_time >= 12) {
                NSInteger year = self.planModel.quality_time / 12;
                NSInteger value = self.planModel.quality_time % 12;
                if (year > 0) {
                    [textString1 appendString:[NSString stringWithFormat:@"%ld年",year]];
                    if (value > 0) {
                        [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                    }
                }else{
                    [textString1 appendString:[NSString stringWithFormat:@"%ld个月",value]];
                }
            }else{
                [textString1 appendString:[NSString stringWithFormat:@"%ld个月",self.planModel.quality_time]];
            }
        }
        
        NSMutableString *textString2 = [NSMutableString string];
        if (self.planModel.quality_km > 0) {
            
            NSInteger num1 = self.planModel.quality_km/10000; // 万
            NSInteger num2 = self.planModel.quality_km % 10000;
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
       
    [_qualityItemDict setValue:[NSString stringWithFormat:@"%ld",self.planModel.quality_km] forKey:@"quality_km"];
    [_qualityItemDict setValue:[NSString stringWithFormat:@"%ld",self.planModel.quality_time] forKey:@"quality_time"];
    }
    return _qualityItemDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"方案详情";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextContentChange:) name:@"textChangeWriteData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextForJ004ContentChange:) name:@"textChangeWriteDataForJ004" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repairTextChangeNoti:) name:@"repairTextChange_notification" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClickEvent)];
   
    if ([self.billType isEqualToString:@"J004"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.model.maintain_scheme.count) {
        YTPlanModel *planModel = self.model.maintain_scheme[_index];
        self.planModel = planModel;
        self.price_ssss = planModel.price_ssss;
    }else{
        self.planModel = [YTPlanModel new];
        self.model.maintain_scheme[_index] = self.planModel;
    }
    
    [self setUI];
    
    [self bottomBtnControlHandleWithStatus];
    [self getPartTypeList];
    [self setData];
   
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)repairTextChangeNoti:(NSNotification *)noti{
    
//    NSMutableDictionary *userInfo = noti.userInfo.mutableCopy;
//    NSIndexPath *indexPath =  userInfo[@"indexPath"];
//    [self.repairTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
}
- (void)reCountTotalPrice{
    // 维修项目
    __block CGFloat repairProjectTotalPrice = 0;
    // 配件耗材
    __block CGFloat partTotalPrice = 0;
    __block CGFloat consumableTotalPrice = 0;
    [self.planModel.parts enumerateObjectsUsingBlock:^(YTPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        partTotalPrice += [obj.part_price floatValue] *[obj.part_count floatValue];
    }];
    
    [self.planModel.consumable enumerateObjectsUsingBlock:^(YTConsumableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        consumableTotalPrice += [obj.consumable_price floatValue] * [obj.consumable_count floatValue];
    }];
    
    [self.planModel.labor enumerateObjectsUsingBlock:^(YTLaborModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        repairProjectTotalPrice += [obj.labor_price floatValue];
    }];
    self.planModel.labor_total = [NSString stringWithFormat:@"%.2f",repairProjectTotalPrice];
    self.planModel.total_price = [NSString stringWithFormat:@"%.2f",partTotalPrice + repairProjectTotalPrice + consumableTotalPrice];
    self.planModel.parts_total = [NSString stringWithFormat:@"%f",partTotalPrice];
    self.planModel.consumable_total = [NSString stringWithFormat:@"%f",consumableTotalPrice];
}
- (void)textFieldTextContentChange:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    NSString *text = userInfo[@"textContent"];
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            self.planModel.quality_time = [text integerValue];
        }
        
        if (indexPath.row == 1) {
            self.planModel.quality_km = [text integerValue];
        }
    }
}
- (void)textFieldTextForJ004ContentChange:(NSNotification *)noti{
    
    self.price_ssss = noti.userInfo[@"textContent"];
    [self.repairTableview reloadData];
}
- (void)bottomBtnControlHandleWithStatus{
    
    
    if ([self.billType isEqualToString:@"J004"]) {
     
        if ([self.model.nowStatusCode isEqualToString:@"consulting"] || [self.model.nowStatusCode isEqualToString:@"initialSurvey"] || [self.model.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"]) {
            self.bottomBtn.hidden = NO;
            self.isNOEdit = NO;
        }else{
            self.bottomBtn.hidden = YES;
            self.isNOEdit = YES;
        }

    }else{
    
    if ([self.model.nextStatusCode isEqualToString:@"initialSurveyCompletion"]) {
        
           self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClickEvent)];
        [self.bottomBtn setTitle:@"保存方案" forState:UIControlStateNormal];
        self.bottomBtn.hidden = self.planModel.is_sys ? YES : NO;
        
    }else if ([self.model.nextStatusCode isEqualToString:@"affirmMode"]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        NSString *bottonText = self.model.isTechOrg ? @"使用该方案":@"选择该方案";
        [self.bottomBtn setTitle:bottonText forState:UIControlStateNormal];
        // 技师已选择
        if (self.model.selectiveRepairModeId.length > 0) {
            self.bottomBtn.hidden = YES;
            
        }else{
            // 技师没有选择
            if (self.model.ownerRepairModeId.length > 0) {
                // 用户选择
                self.bottomBtn.hidden = self.model.isTechOrg ? NO : YES;
            }else{
                // 技师 用户都没有选择
                self.bottomBtn.hidden = NO;
            }
        }
        self.isNOEdit = YES;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        // 其他情况
        self.bottomBtn.hidden = YES;
        self.isNOEdit = YES;
    }
    
    if (self.planModel.is_sys) {
        // 系统方案
        self.isNOEdit = YES;
        self.is_sysCase = YES;
    }
}
    [self.repairTableview reloadData];
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
- (void)setUI{
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 44);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topMargin, self.view.bounds.size.width, 44) collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.bounces = NO;
    [collectionView registerClass:[YHRepairCollectionViewCell class] forCellWithReuseIdentifier:@"repairCaseDetail_collectionViewCellId"];
    
    CGFloat bottonMargin = iPhoneX ? 34 : 0;
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.repairTableview = tableview;
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(tableview.superview).offset(-bottonMargin);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 73)];
    UIButton *bottomBtn = [UIButton new];
    self.bottomBtn = bottomBtn;
    [bottomBtn setTitle:@"保存方案" forState:UIControlStateNormal];
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
}
- (void)setData{
    
    self.repairTitleArr = [NSMutableArray array];
    NSString *title1 = @"设置配件";
    NSString *title2 = @"设置耗材";
    if (self.isNOEdit) {
        title1 = @"所需配件";
        title2 = @"所需耗材";
    }
    [self.repairTitleArr addObject:title1];
    [self.repairTitleArr addObject:title2];
    [self.repairTitleArr addObject:@"维修项目"];
    [self.repairTitleArr addObject:@"维修总计"];
    [self.repairTitleArr addObject:@"质保内容"];
    
    [self repairCellInfo];
    
}
- (void)bottomBtnClickEvent:(UIButton *)bottomBtn{
    
    if ([self.billType isEqualToString:@"J004"]) {
        [self submitDataForJ004:self.model];
        return;
    }
    if ([[self.bottomBtn titleForState:UIControlStateNormal] isEqualToString:@"保存方案"]) {
        [self.model saveDiagnose];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        // 选择方案
        [self requireSideToChoiceCase];
    }
}
#pragma mark - 选择方案 ---
- (void)requireSideToChoiceCase{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] requireToChoiceCase:[YHTools getAccessToken] billId:[self.model.billId intValue] repairModelId:self.planModel.Id isTechnique:self.model.isTechOrg onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[NSString stringWithFormat:@"%@",info[@"code"]] isEqualToString:@"20000"]) {
            [self.navigationController popViewControllerAnimated:YES];
             [MBProgressHUD showError:@"选择成功"];
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
    
#pragma mark - 更多 ----
- (void)rightBtnClickEvent{
    
    YHRepairMoreView *moreView = [[NSBundle mainBundle] loadNibNamed:@"YHRepairMoreView" owner:nil options:nil].firstObject;
    moreView.is_sysCase = self.is_sysCase;
    self.moreView = moreView;
    moreView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.navigationController.view addSubview:moreView];

    [moreView.caseButton addTarget:self action:@selector(copyCaseDetail) forControlEvents:UIControlEventTouchUpInside];
    [moreView.removeBtn addTarget:self action:@selector(removeCaseDetail) forControlEvents:UIControlEventTouchUpInside];
    [moreView.reNameBtn addTarget:self action:@selector(reNameCaseDetail) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self)weakSelf = self;
    moreView.tapViewGesTure = ^{
        [weakSelf.moreView removeFromSuperview];
    };
}
#pragma mark - 复制方案 ---
- (void)copyCaseDetail{
    [self closeEvent];
    
    YTPlanModel *oldPlan = self.model.maintain_scheme[self.index];
    NSDictionary *planDict = [oldPlan mj_JSONObject];
    
    NSArray *localPlans = [self.model.maintain_scheme filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_sys < 1"]];
    NSArray *localNames = [localPlans valueForKey:@"name"];
    
    NSInteger sysC = self.model.maintain_scheme.count - localPlans.count;
    NSInteger i = sysC + 1;
    while ([localNames containsObject:[NSString stringWithFormat:@"解决方案%ld",i]]) {
        i++;
    }
    YTPlanModel *copyPlan = [YTPlanModel mj_objectWithKeyValues:planDict];
    copyPlan.is_sys = 0;
    copyPlan.name = [NSString stringWithFormat:@"解决方案%ld",i];

    [self.model.maintain_scheme addObject:copyPlan];
    [self.model saveDiagnose];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - 删除方案 ---
- (void)removeCaseDetail{

    YHDeleteRepairCaseView *repairAlertview = [YHDeleteRepairCaseView alertToView:self.navigationController.view];
    self.repairAlertview = repairAlertview;
    [repairAlertview.closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    repairAlertview.closeBtn.hidden = YES;
    [repairAlertview.sureBtn addTarget:self action:@selector(sureEvent) forControlEvents: UIControlEventTouchUpInside];
    [repairAlertview.cancelBtn addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelEvent{
    [self closeEvent];

}
- (void)sureEvent{
    [self closeEvent];
    [self.model.maintain_scheme removeObjectAtIndex:self.index];
    [self.model saveDiagnose];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeEvent{
    [self.repairAlertview.hudView removeFromSuperview];
    [self.moreView removeFromSuperview];
}
#pragma mark - 重命名方案 ---
- (void)reNameCaseDetail{
    [self closeEvent];

    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"是否要修改方案名称？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!alertViewController.textFields.firstObject.hasText) {
            [MBProgressHUD showError:@"方案名称不能为空！"];
            return ;
        }
        
        self.model.maintain_scheme[self.index].name = alertViewController.textFields.firstObject.text;
        [self.model saveDiagnose];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [alertViewController addAction:sureAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertViewController addAction:cancelAction];
    
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入方案名称";
        textField.text = self.model.maintain_scheme[self.index].name;
    }];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.repairTitleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *secTitle = self.repairTitleArr[section];
    if ([secTitle isEqualToString:@"质保内容"] && [self.billType isEqualToString:@"J004"]) {
        return 1;
    }
    return [self.titleInfo[secTitle] integerValue];
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
    // J004
    if ([cell isKindOfClass:NSClassFromString(@"YHQualityTableViewCell")] && [self.billType isEqualToString:@"J004"]) {
        YHFoursPriceCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YHFoursPriceCell" owner:nil options:nil].firstObject;
        cell.cellModel = self.price_ssss;
        return cell;
    }
    
    cell.isTechOrg = self.model.isTechOrg;
    cell.isNOCanEdit = self.isNOEdit;
    cell.indexPath = indexPath;
    // 删除
    __weak typeof(self)weakSelf = self;
    cell.removeCallBack = ^(NSIndexPath *indexPath) {
        [weakSelf removeItemForCell:indexPath];
    };
    // 点击分类
    cell.selectClassClickEvent = ^(NSIndexPath *indexPath) {
        if (!weakSelf.isNOEdit) {
            [weakSelf alertListForSelect:indexPath];
        }
    };
    
   void (^operation)(void) = [self getCellDataWithKey:indexPath cell:cell];
    if (operation) {
         operation();
    }
    
    NSString *secTitle = self.repairTitleArr[indexPath.section];
    NSInteger rows = [self.titleInfo[secTitle] integerValue];
    if (indexPath.row == (rows - 1) && (rows >= 1)) {
        cell.isNeedRaidus = YES;
        cell.isHiddenSeprateLine = YES;
    }
    
    return cell;
}
- (void (^)(void))getCellDataWithKey:(NSIndexPath *)indexPath cell:(YHBaseRepairTableViewCell *)cell{
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSMutableDictionary *dictOperation = [NSMutableDictionary dictionary];
    void(^operation)(void) = ^(void) {
        cell.cellModel = self.planModel.parts[indexPath.row];
    };
    void (^operation1)(void) = ^(void) {
       cell.cellModel = self.planModel.consumable[indexPath.row];
    };
    void (^operation2)(void) = ^(void) {
        cell.cellModel = self.planModel.labor[indexPath.row];
    };
    void (^operation3)(void) = ^(void) {
        cell.cellModel = self.repairProjectArr[indexPath.row];
    };
    void (^operation4)(void) = ^(void) {
        cell.cellModel = self.qualityItemDict;
    };
    
    [dictOperation setValue:operation forKey:@"0"];
    [dictOperation setValue:operation1 forKey:@"1"];
    [dictOperation setValue:operation2 forKey:@"2"];
    [dictOperation setValue:operation3 forKey:@"3"];
    [dictOperation setValue:operation4 forKey:@"4"];
    
    return dictOperation[key];
}
#pragma mark - 删除cell ---
- (void)removeItemForCell:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self.planModel.parts removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 1) {
        [self.planModel.consumable removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 2) {
        [self.planModel.labor removeObjectAtIndex:indexPath.row];
    }
    
    [self reCountTotalPrice];
    [self.repairTableview reloadData];
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
        YTPartModel *partModel = self.planModel.parts[indexPath.row];
        NSDictionary *element = self.parttypeList[buttonIndex - 2];
        partModel.part_type = [NSString stringWithFormat:@"%@",element[@"id"]];
        partModel.part_type_name = [NSString stringWithFormat:@"%@",element[@"value"]];
        [self.repairTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
//    [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.partTypeNameList popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
//
//    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//
//        if (buttonIndex < 2) {
//            return ;
//        }
//        YTPartModel *partModel = self.planModel.parts[indexPath.row];
//        NSDictionary *element = self.parttypeList[buttonIndex - 2];
//        partModel.part_type = [NSString stringWithFormat:@"%@",element[@"id"]];
//        partModel.part_type_name = [NSString stringWithFormat:@"%@",element[@"value"]];
//        [self.repairTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellInfo = self.repairCellInfo[[NSString stringWithFormat:@"%ld",indexPath.section]];
    return [cellInfo[@"cellHeight"] integerValue];
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
    addBTn.hidden = section > 2;
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
    
    if (section > 2) {
        addBTn.hidden = YES;
    }else{
        addBTn.hidden = self.isNOEdit;
    }
    return sectionView;
}
#pragma mark - 增加 ---
- (void)addItme:(UIButton *)addBTn{
    
    YHRepairAddController *repairAddVc = [YHRepairAddController new];
    repairAddVc.baseInfo = self.model.baseInfo;
    repairAddVc.repairType = addBTn.tag - 999;
    __weak typeof(self)weakSelf = self;
    repairAddVc.addDataBlock = ^(NSArray *finalArr, NSInteger section) {
        
        for (NSDictionary *element in finalArr) {
            
            if (section == 0) {
               YTPartModel *partModel = [YTPartModel mj_objectWithKeyValues:element];
                [weakSelf.planModel.parts addObject:partModel];
            }
            
            if (section == 1) {
                YTConsumableModel *consumableModel = [YTConsumableModel mj_objectWithKeyValues:element];
                [weakSelf.planModel.consumable addObject:consumableModel];
            }
           
            if (section == 2) {
                YTLaborModel *laborModel = [YTLaborModel mj_objectWithKeyValues:element];
                [weakSelf.planModel.labor addObject:laborModel];
            }
        }
        
        [weakSelf reCountTotalPrice];
        [weakSelf.repairTableview reloadData];
    };
    [self.navigationController pushViewController:repairAddVc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     NSString *secTitle = self.repairTitleArr[section];
    if ([secTitle isEqualToString:@"质保内容"]) {
        return 0;
    }
    return 45;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.repairTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHRepairCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairCaseDetail_collectionViewCellId" forIndexPath:indexPath];
    cell.title = self.repairTitleArr[indexPath.row];
    cell.isNoCanEdit = self.isNOEdit;
    if (self.selectIndexPathForCollectionView) {
        [cell setSelectTitle:(indexPath == self.selectIndexPathForCollectionView)];
    }else{
        if (indexPath.row == 0) {
            [cell setSelectTitle:YES];
            self.selectIndexPathForCollectionView = indexPath;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    YHRepairCollectionViewCell *cell = (YHRepairCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    YHRepairCollectionViewCell *selectCell = (YHRepairCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectIndexPathForCollectionView];
    [selectCell setSelectTitle:NO];
    [cell setSelectTitle:YES];
    self.selectIndexPathForCollectionView = indexPath;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // 最大偏移量
    CGFloat maxOffsetY = self.repairTableview.contentSize.height - self.repairTableview.frame.size.height;
    CGFloat requireOffsetY = [self getOffsetYValue:indexPath];
    
    if (requireOffsetY > maxOffsetY) {
        requireOffsetY = maxOffsetY;
    }
    [self.repairTableview setContentOffset:CGPointMake(0, requireOffsetY) animated:YES];
    
}
- (CGFloat)getOffsetYValue:(NSIndexPath *)indexPath{
    
    CGFloat offY = 0;
    NSDictionary *rowhItem = @{
                               @"0":@"195",
                               @"1":@"195",
                               @"2":@"110",
                               @"3":@"55",
                               @"4":@"55"
                               };
    
    for (int i = 0; i<indexPath.row; i++) {
        NSString *secTitle = self.repairTitleArr[i];
        NSInteger rows = [self.titleInfo[secTitle] integerValue];
        CGFloat rowH = [rowhItem[[NSString stringWithFormat:@"%d",i]] floatValue];
        offY += rows *rowH;
    }
     offY += (indexPath.row)*45;
    
    return offY;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.collectionView == scrollView) {
        return;
    }
    NSArray *indexPathArr = self.repairTableview.indexPathsForVisibleRows;
    NSInteger middleIndex = indexPathArr.count/2;
    NSIndexPath *middleIndexPath = indexPathArr[middleIndex];
    NSIndexPath *selectIndexPathForCollectionView = [NSIndexPath indexPathForRow:middleIndexPath.section inSection:0];
    self.selectIndexPathForCollectionView = selectIndexPathForCollectionView;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:selectIndexPathForCollectionView atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
