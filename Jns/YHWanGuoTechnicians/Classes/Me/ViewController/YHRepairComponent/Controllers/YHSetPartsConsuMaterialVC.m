//
//  YHSetPartsConsuMaterialVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartsConsuMaterialVC.h"
#import <Masonry.h>
#import "YHCommon.h"

#import "YHSetPartCell.h"
#import "YHSetPartSearchVc.h"
#import "YHNetworkPHPManager.h"
#import "YHStoreTool.h"
#import "YHTools.h"
#import "YHSetModifyProjectVc.h"



#define text_color [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0]
#define background_color [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]

@interface YHSetPartsConsuMaterialVC () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
/** 展示配件耗材详细信息 */
@property (nonatomic, weak) UITableView *partTableView;

@property (nonatomic, strong) NSMutableArray *setPartInfoArr;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, weak) UIImageView *partImageV;

@property (nonatomic, weak) UILabel *premptL;
/** 是否是配件组  只有一组的情况时判断 */
@property (nonatomic, assign) BOOL isPartGroup;
/** 需要提交的项目数据 */
@property (nonatomic ,strong) NSMutableArray *projectArrs;
/** 是否已进入过设置项目控制器 */
@property (nonatomic,assign) BOOL isFistEnterProjectVc;
@property (nonatomic, strong) NSMutableArray *parttypeList;
@property (nonatomic, strong) NSMutableArray *partTypeNameList;

@end

@implementation YHSetPartsConsuMaterialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetPartsConsuMaterialVCBase];
    [self initUI];
    [self initBaseData];
    [self addNavigationBarBackBtn];
    [self getPartTypeList];
}

- (void)addNavigationBarBackBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
    
}
- (void)popViewController:(UIButton *)btn{
    
    [self savePartsToTempory];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initSetPartsConsuMaterialVCBase{
    
    self.isFistEnterProjectVc = NO;
    self.title = @"设置配件耗材";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 绑定一个唯一标识符
    if (self.isNewAdd) {
//        self.modifyParttenTitle = [NSString getCurrentTimeStr];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPartNotication:) name:@"YHAddPartVC_addPart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeNotification:) name:@"textFieldChangeNotification" object:nil];
   
}
#pragma KVO  监听通知 ---
- (void)textFieldChangeNotification:(NSNotification *)noti{
    
    NSString *classType = noti.userInfo[@"class"];
   
    if ([classType isEqualToString:@"number"]) {
        
        NSString *newText = noti.userInfo[@"scalar"];
        NSIndexPath *indexPath = noti.userInfo[@"indexPath"];
        NSDictionary *item = self.setPartInfoArr[indexPath.section][indexPath.row];
        NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
        [newItem setValue:[NSNumber numberWithFloat:[newText floatValue]] forKey:@"scalar"];
        [self.setPartInfoArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:newItem];
        
    }
    
    if ([classType isEqualToString:@"unit"]) {

        NSString *partsUnitText = noti.userInfo[@"partsUnit"];
        NSIndexPath *indexPath = noti.userInfo[@"indexPath"];
        NSDictionary *item = self.setPartInfoArr[indexPath.section][indexPath.row];
        NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
        [newItem setValue:partsUnitText forKey:@"partsUnit"];
        [self.setPartInfoArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:newItem];
    }

}
#pragma mark - 添加配件耗材通知 ----
- (void)addPartNotication:(NSNotification *)noti{
   
    id class = noti.userInfo[@"class"];
    if ([NSStringFromClass(class) isEqualToString:@"YHAddPartVC"]) {
        NSDictionary *addPortDict = noti.userInfo[@"addPart"];
        [self addPartToDataSource:addPortDict];
    }
    
    if ([NSStringFromClass(class) isEqualToString:@"YHSetPartSearchVc"]) {
        NSArray *addPortArr = noti.userInfo[@"selectParts"];
        for (NSDictionary *item in addPortArr) {
            [self addPartToDataSource:item];
        }
    }
      [self.partTableView reloadData];
}

- (void)addPartToDataSource:(NSDictionary *)partItem{
    
    NSMutableDictionary *newPartItem = [NSMutableDictionary dictionaryWithDictionary:partItem];
    [newPartItem setValue:@"1" forKey:@"scalar"];
    
    self.partTableView.hidden = NO;
    self.premptL.hidden = YES;
    self.partImageV.hidden = YES;
    
    // 判断数据是否已存在
    BOOL isExistForData = [self isExistedForData:newPartItem];
    if (isExistForData) {
        return;
    }
    
    NSString *type = newPartItem[@"type"];
    //0：全部 1：配件 2：耗材 （APP才有0）
    if (self.setPartInfoArr.count) { // 至少有一组
        
        // 这里默认设置第一组是配件组  第二组是耗材组
        NSMutableArray *resultArr = [NSMutableArray arrayWithArray:self.setPartInfoArr];
        if (self.setPartInfoArr.count == 1) {
            
            NSArray *firstArr = self.setPartInfoArr.firstObject;
            NSDictionary *oneItem = [firstArr firstObject];
            if ([oneItem[@"type"] isEqualToString:type]) {
                
                NSMutableArray *newFirstArr = [NSMutableArray arrayWithArray:firstArr];
                [newFirstArr addObject:newPartItem];
                [resultArr replaceObjectAtIndex:0 withObject:newFirstArr];
                
            }else{
                // 传入的和已存在的不是同一组
                if ([oneItem[@"type"] isEqualToString:@"1"]) { // 已存在的是配件组，所以传入的是属于耗材组，此时应放在第二组
                    
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [arr1 addObject:newPartItem];
                    [resultArr insertObject:arr1 atIndex:1];
                    
                }else{ // 与上面相反
                    
                    NSMutableArray *arr2 = [NSMutableArray array];
                    [arr2 addObject:newPartItem];
                    [resultArr insertObject:arr2 atIndex:0];
                }
            }
        }
        
        if (self.setPartInfoArr.count == 2) {
            
            if ([type isEqualToString:@"1"]) {
                BOOL isExist = NO;
                NSArray *arr1 =  [self.setPartInfoArr firstObject];
                for (int i = 0; i<arr1.count; i++) {
                    NSDictionary *item1 = arr1[i];
                    if ([item1[@"partsName"] isEqualToString:newPartItem[@"partsName"]] ) {
                        isExist = YES;
                        break;
                    }
                }
                
                if (!isExist) {
                    NSMutableArray *newFirst = [NSMutableArray arrayWithArray:arr1];
                    [newFirst addObject:newPartItem];
                    [resultArr replaceObjectAtIndex:0 withObject:newFirst];
                }
            }
            
            if ([type isEqualToString:@"2"]) {
                
                BOOL isExist = NO;
                NSArray *arr2 =  [self.setPartInfoArr lastObject];
                for (int i = 0; i<arr2.count; i++) {
                    NSDictionary *item1 = arr2[i];
                    if ([item1[@"partsName"] isEqualToString:newPartItem[@"partsName"]] ) {
                        isExist = YES;
                        break;
                    }
                }
                
                if (!isExist) {
                    NSMutableArray *newLast = [NSMutableArray arrayWithArray:arr2];
                    [newLast addObject:newPartItem];
                    [resultArr replaceObjectAtIndex:1 withObject:newLast];
                }
            }
        }
        
        self.setPartInfoArr = [NSMutableArray arrayWithArray:resultArr];
        
    }else{
        // 新加入的情况
        NSMutableArray *resultArr = [NSMutableArray array];
        if ([type isEqualToString:@"1"]) {
            NSMutableArray *firArr = [NSMutableArray array];
            [firArr addObject:newPartItem];
            [resultArr addObject:firArr];
        }
        if ([type isEqualToString:@"2"]) {
            NSMutableArray *lastArr = [NSMutableArray array];
            [lastArr addObject:newPartItem];
            [resultArr addObject:lastArr];
        }
        self.setPartInfoArr = [NSMutableArray arrayWithArray:resultArr];
    }
    
    NSMutableDictionary *newItem = nil;
    int index = -1;
    for (int i = 0; i<self.catchDataArr.count; i++) {
        NSDictionary *item = self.catchDataArr[i];
        if ([item[@"repairIndex"] integerValue] == self.index) {
            newItem = [NSMutableDictionary dictionaryWithDictionary:item];
            index = i;
        }
    }
    if (newItem) {
        NSMutableArray *parts = [NSMutableArray array];
        if (self.setPartInfoArr.count == 1) {
            if ([self.setPartInfoArr.firstObject isKindOfClass:[NSArray class]]) {
                [parts addObjectsFromArray:self.setPartInfoArr.firstObject];
            }else{
                 [parts addObjectsFromArray:self.setPartInfoArr];
            }
        }
        if (self.setPartInfoArr.count == 2) {
           
            NSArray *firstArr = self.setPartInfoArr.firstObject;
            if (firstArr.count) {
                if ([firstArr.firstObject isKindOfClass:[NSArray class]]){
                    [parts addObjectsFromArray:firstArr.firstObject];
                }else{
                    [parts addObjectsFromArray:firstArr];
                }
            }
            
            NSArray *lastArr = self.setPartInfoArr.lastObject;
            if (lastArr.count) {
                if ([lastArr.firstObject isKindOfClass:[NSArray class]]){
                    [parts addObjectsFromArray:lastArr.firstObject];
                }else{
                    [parts addObjectsFromArray:lastArr];
                }
            }
        }
        [newItem setValue:parts forKey:@"parts"];
        [self.catchDataArr replaceObjectAtIndex:index withObject:newItem];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[YHStoreTool ShareStoreTool] setAlreadyParts:self.setPartInfoArr];
}

- (BOOL)isExistedForData:(NSDictionary *)dict{
    
    BOOL isExist = NO;
    if (self.setPartInfoArr.count == 1) {
        NSArray *arr1 = self.setPartInfoArr.firstObject;
        for (int i = 0; i<arr1.count; i++) {
            NSDictionary *item = arr1[i];
            if ([item[@"partsName"] isEqualToString:dict[@"partsName"]]) {
                isExist = YES;
                break;
            }
        }
    }
    
    if (self.setPartInfoArr.count == 2) {
        
        NSArray *arr1 = self.setPartInfoArr.firstObject;
        for (int i = 0; i<arr1.count; i++) {
            NSDictionary *item = arr1[i];
            if ([item[@"partsName"] isEqualToString:dict[@"partsName"]]) {
                isExist = YES;
                break;
            }
        }
        
        NSArray *arr2 = self.setPartInfoArr.firstObject;
        for (int i = 0; i<arr2.count; i++) {
            NSDictionary *item = arr1[i];
            if ([item[@"partsName"] isEqualToString:dict[@"partsName"]]) {
                isExist = YES;
                break;
            }
        }
    }
    
    return isExist;
}

#pragma mark - 下一部按钮 ----
- (void)rightBtnClick{
    
    [self jumpToModifyProjectVc];
}
- (void)initUI{
    
    UIButton *bottomBtn = [[UIButton alloc] init];
    [self.view addSubview:bottomBtn];
    bottomBtn.backgroundColor = YHNaviColor;
    bottomBtn.layer.cornerRadius = 5.0;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn setTitle:@"添加配件耗材" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomClickEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(bottomBtn.superview).offset(-10);
        make.bottom.equalTo(bottomBtn.superview).offset(bottomMargin);
        make.height.equalTo(@40);
    }];
    
    UIImageView *partImageV = [[UIImageView alloc] init];
    self.partImageV = partImageV;
    partImageV.image = [UIImage imageNamed:@"noParts"];
    [partImageV sizeToFit];
    partImageV.hidden = YES;
    [self.view addSubview:partImageV];
    [partImageV sizeToFit];
    
    UILabel *premptL = [[UILabel alloc] init];
    premptL.hidden = YES;
    self.premptL = premptL;
    premptL.textColor = text_color;
    premptL.text = @"暂无配件耗材信息，请点击添加";
    [premptL sizeToFit];
    [self.view addSubview:premptL];
    
    CGFloat marginY =  iPhoneX ? 74.0 : 40.0;
    CGFloat pratTopMargin = (screenHeight - (partImageV.image.size.height + 25.0 + premptL.bounds.size.height) - marginY)/2.0;
    [partImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(partImageV.superview);
        make.top.equalTo(@(pratTopMargin));
    }];
    
    [premptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(premptL.superview);
        make.top.equalTo(partImageV.mas_bottom).offset(25.0);
        
    }];
    
    // tableView
    UITableView *partTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:partTableView];
    self.partTableView = partTableView;
    partTableView.delegate = self;
    partTableView.dataSource = self;
    partTableView.tableFooterView = [[UIView alloc] init];
    partTableView.backgroundColor = [UIColor clearColor];
    partTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topMargin = iPhoneX ? 88 : 64;
    [partTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(bottomBtn.mas_top);
        make.top.equalTo(@(topMargin));
        
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPartTableViewGes)];
    tapGes.delegate = self;
    [partTableView addGestureRecognizer:tapGes];
}

#pragma mark - 根据配件名称搜索维修项目 ----
- (void)getRepairItemListByPartsName{
    
    if (!self.setPartInfoArr.count) {
        return;
    }
    
    NSArray *resultArr = [self transformPartArr:self.setPartInfoArr];
    
    NSMutableString *paramStr = [NSMutableString string];
    
    for (int i = 0; i<resultArr.count; i++) {
        NSDictionary *item = resultArr[i];
        NSString *partsName = item[@"partsName"];
        [paramStr appendString:partsName];
        if (i != resultArr.count - 1) {
            [paramStr appendString:@","];
        }
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getRepairItemList:[YHTools getAccessToken] partsName:paramStr onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            NSArray *repairList = data[@"repairItemList"];
            self.repaireListWithPart = [NSMutableArray arrayWithArray:repairList];
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            if (self.repaireListWithPart) {
                [userDict setValue:self.repaireListWithPart forKey:@"repaireListWithPart"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchSuccessForProjectNotification" object:nil userInfo:userDict];
            }
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (void)initBaseData{
    
    NSDictionary *temporaryData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporaryData[@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
    NSArray *repairModeData = temporarySave[@"repairModeData"];
    if (!repairModeData){
        repairModeData = nil;
    }
    if (!repairModeData.count) {
        repairModeData = nil;
    }
    
    if (self.isNewAdd) {
        
        self.partTableView.hidden = YES;
        self.partImageV.hidden = !self.partTableView.hidden;
        self.premptL.hidden = self.partImageV.hidden;
        
    }else{
        
        NSMutableDictionary *dict = nil;
//        for (NSDictionary *item in repairModeData) {
//            if ([self.modifyParttenTitle isEqualToString:item[@"title"]]) {
//                dict = [NSMutableDictionary dictionaryWithDictionary:item];
//            }
//        }
        for (NSDictionary *item in self.catchDataArr) {
            if (self.index == [item[@"repairIndex"] integerValue]) {
                dict = [NSMutableDictionary dictionaryWithDictionary:item];
            }
        }
        NSArray *parts = dict[@"parts"];
        
        self.partTableView.hidden = parts.count == 0 ? YES : NO;
        self.partImageV.hidden = !self.partTableView.hidden;
        self.premptL.hidden = self.partImageV.hidden;
        if (parts.count > 0) {
            self.setPartInfoArr = [self getDataSourceWithArr:parts];
            [self.partTableView reloadData];
        }
    }
}

- (NSMutableArray *)getDataSourceWithArr:(NSArray *)arr{
    
    NSMutableArray *partsArr = [NSMutableArray array];
    NSMutableArray *expendArr = [NSMutableArray array];
    for (NSDictionary *item in arr) {
        NSString *type = [NSString stringWithFormat:@"%@",item[@"type"]];
        //0：全部 1：配件 2：耗材 （APP才有0）
        if ([type isEqualToString:@"1"]) {
            [partsArr addObject:item];
        }
        if ([type isEqualToString:@"2"]) {
            [expendArr addObject:item];
        }
    }
    // 配件
    NSMutableArray *resultArr = [NSMutableArray array];
    if (partsArr.count) {
        [resultArr addObject:partsArr];
    }
    // 耗材
    if (expendArr.count) {
        [resultArr addObject:expendArr];
    }
    
    return resultArr;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}
- (void)tapPartTableViewGes{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"YHSetPartCellHideRemoveBtn" object:nil];
}

- (void)setNaviBarTitle:(NSString *)naviBarTitle{
    self.title = naviBarTitle;
}
#pragma mark - 底部按钮点击 ---
- (void)bottomClickEvent{
    

    NSInteger numbers = 0;
    
    if (self.setPartInfoArr.count == 1) {
        NSArray *arr1 = self.setPartInfoArr.firstObject;
        numbers = arr1.count;
    }
    if (self.setPartInfoArr.count == 2) {
        NSArray *arr1 = self.setPartInfoArr.firstObject;
        NSArray *arr2 = self.setPartInfoArr.lastObject;
        numbers = arr1.count + arr2.count;
    }
    
    YHSetPartSearchVc *searchVc = [[YHSetPartSearchVc alloc] initWithControllerType:YHConsuMaterialType];
    searchVc.isNewAdd = self.isNewAdd;
    searchVc.numbers = numbers;
    searchVc.index = self.index;
    searchVc.catchDataArr = self.catchDataArr;
    [self.navigationController pushViewController:searchVc animated:YES];
}
#pragma mark - 把配件耗材数据源数组混合成一个数组 ---
- (NSMutableArray *)transformPartArr:(NSMutableArray *)partArrs{
    
    NSMutableArray *resultArr = [NSMutableArray array];
    if (!partArrs.count) {
        return resultArr;
    }
    if (partArrs.count == 1) {
        NSArray *arr1 = partArrs.firstObject;
        for (NSDictionary *item in arr1) {
            [resultArr addObject:item];
        }
        return resultArr;
    }else{
        
        NSArray *arr1 = partArrs.firstObject;
        for (NSDictionary *item in arr1) {
            [resultArr addObject:item];
        }
        
        NSArray *arr2 = partArrs.lastObject;
        for (NSDictionary *item in arr2) {
            [resultArr addObject:item];
        }
    }
    return resultArr;
}

#pragma mark - 保存配件耗材数据 -----
- (void)savePartsToTempory{
    
    NSMutableArray *resultArr = [self transformPartArr:self.setPartInfoArr];
    
    if (!self.projectArrs.count && !resultArr.count) {
        [MBProgressHUD showError:@"配件耗材和维修项目必须填写一项"];
        return;
    }
    
    NSDictionary *temporaryData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporaryData[@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
//    NSArray *repairModeData = temporarySave[@"repairModeData"];
    NSArray *repairModeData = self.catchDataArr;
    NSDictionary *checkResultArr = temporarySave[@"checkResult"];
    NSMutableArray *saveRepairArr = [NSMutableArray arrayWithArray:repairModeData];
    
    BOOL isExist = NO;
    NSInteger index = 0;
    NSMutableDictionary *existItem = nil;
    for (int i = 0; i<repairModeData.count; i++) {
        NSDictionary *item = repairModeData[i];
        
        if ([item[@"repairIndex"] integerValue] == self.index) {
            isExist = YES;
            index = i;
            existItem = [NSMutableDictionary dictionaryWithDictionary:item];
        }
    }
    
    NSMutableDictionary *newSaveItem = [NSMutableDictionary dictionary];
    if (resultArr.count) {
        [newSaveItem setValue:resultArr forKey:@"parts"];
    }
    
    if (self.projectArrs.count) { // 表示用户已进入过维修项目列表
        [newSaveItem setValue:self.projectArrs forKey:@"repairItem"];
    }else{
        // 没有进入维修项目列表时只需合并缓存返回的和配件搜索带出来的
        if (isExist) {
            
            NSMutableArray *existArr =  existItem[@"repairItem"];
//            if (self.repaireListWithPart.count) {
//                NSArray *resultArr = [self combineDataArr:existArr otherArr:self.repaireListWithPart];
//                [newSaveItem setValue:resultArr forKey:@"repairItem"];
//            }else{
                [newSaveItem setValue:existArr forKey:@"repairItem"];
//            }
            
        }else{
//            [newSaveItem setValue:self.repaireListWithPart forKey:@"repairItem"];
        }
    }
   
     [newSaveItem setValue:@(self.index) forKey:@"repairIndex"];
    
    if (isExist) { // 已存在
        [saveRepairArr replaceObjectAtIndex:index withObject:newSaveItem];
        
    }else{
        [saveRepairArr addObject:newSaveItem];
    }
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveModifyPattern:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] checkResult:checkResultArr repairModeData:saveRepairArr onComplete:^(NSDictionary *info) {
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            // 发送通知
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:newSaveItem forKey:@"addPrtUpdate"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPortUpdateTableView" object:nil userInfo:dict];
        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (NSArray *)combineDataArr:(NSArray *)arr otherArr:(NSArray *)otherArr{
    
    if (!arr.count) {
        return [NSArray arrayWithArray:otherArr];
    }
    if (!otherArr.count) {
        return [NSArray arrayWithArray:arr];
    }
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
    for (NSDictionary *item in otherArr) {
        NSString *name = item[@"repairProjectName"];
        BOOL isExist = NO;
        for (NSDictionary *dict in arr) {
            NSString *dictName = dict[@"repairProjectName"];
            if ([name isEqualToString:dictName]) {
                isExist = YES;
            }
        }
        if (!isExist && item) {
            [newArr addObject:item];
        }
    }
    
    return [NSArray arrayWithArray:newArr];
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

- (void)alertListForSelect:(NSIndexPath *)indexPath{
    
    if (!(self.parttypeList.count > 1)) {
        return;
    }
    
    UITableViewCell *cell = [self.partTableView cellForRowAtIndexPath:indexPath];
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.partTypeNameList popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = cell;
        popover.sourceRect = cell.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex < 2) {
            return ;
        }
        //YHPartsModel *partModel = self.schemeModel.parts[indexPath.row];
        
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *g = self.setPartInfoArr[section];
        NSMutableDictionary *c = g[row];
        c = c.mutableCopy;
        g[row] = c;

        NSDictionary *element = self.parttypeList[buttonIndex - 2];
        
        [c setValue:[NSString stringWithFormat:@"%@",element[@"id"]] forKey:@"partsTypeId"];
//        c[@"partsTypeId"] = [NSString stringWithFormat:@"%@",element[@"id"]];
        //[c setValue:[NSString stringWithFormat:@"%@",element[@"value"]] forKey:@"partsTypeName"];
        c[@"partsTypeName"] = [NSString stringWithFormat:@"%@",element[@"value"]];
        
        //[self.partTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.partTableView reloadData];

    }];
}
- (void)jumpToModifyProjectVc{
    if (!self.isFistEnterProjectVc) {
        self.isFistEnterProjectVc = YES;
        // 根据配件耗材名称搜索维修项目
        [self getRepairItemListByPartsName];
    }
  
    YHSetModifyProjectVc *modifyProVc = [[YHSetModifyProjectVc alloc] init];
    __weak typeof(self)weakSelf = self;
    modifyProVc.saveProjectBlock = ^(NSMutableArray *projectArrs) {
        weakSelf.projectArrs = projectArrs;
    };
    modifyProVc.popVc = self.popVc;
    modifyProVc.isNewAdd = self.isNewAdd;
    modifyProVc.index = self.index;
    modifyProVc.requireSaveParts = self.setPartInfoArr;
    modifyProVc.catchDataArr = self.catchDataArr;
    
    if (weakSelf.projectArrs.count) {
        modifyProVc.projectDataSource = weakSelf.projectArrs;
    }
   
    [self.navigationController pushViewController:modifyProVc animated:YES];
}

#pragma mark - UITableViewDataSource ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.setPartInfoArr.count == 1) {
        // 只有一组
        NSArray *firstArr = [self.setPartInfoArr firstObject];
        NSDictionary *item = [firstArr firstObject];
        if ([item[@"type"] isEqualToString:@"1"]) {
            self.isPartGroup = YES;
        }else{
            self.isPartGroup = NO;
        }
    }
    return self.setPartInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionArr = self.setPartInfoArr[section];
    return sectionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *setPartCellID = @"setPartCellID";
    
    YHSetPartCell *cell = [tableView dequeueReusableCellWithIdentifier:setPartCellID];
    if (!cell) {
        cell = [[YHSetPartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setPartCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self)weakSelf = self;
        cell.deleBtnClickBlock = ^(YHSetPartCell *cell, NSIndexPath *indexPath) {
            // 取消之前的选中
            YHSetPartCell *upSelectCell = [tableView cellForRowAtIndexPath:weakSelf.selectIndexPath];
            if (cell != upSelectCell) {
                [upSelectCell hideRemoveBtn];
            }
            // 获取最新的indexPath
            weakSelf.selectIndexPath = indexPath;
        };
        
        cell.removeBtnClickBlock = ^(YHSetPartCell *cell, NSIndexPath *indexPath) {
            
            weakSelf.selectIndexPath = nil;
            NSArray *arr = weakSelf.setPartInfoArr[indexPath.section];
            NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
            [newArr removeObjectAtIndex:indexPath.row];
            NSMutableArray *newResult = [NSMutableArray arrayWithArray:weakSelf.setPartInfoArr];
            [newResult replaceObjectAtIndex:indexPath.section withObject:newArr];
            weakSelf.setPartInfoArr = [NSMutableArray arrayWithArray:newResult];
            [weakSelf.partTableView reloadData];
   
        };
    }
    
    if (!self.selectIndexPath) {
        [cell hideRemoveBtn];
    }
    
    cell.indexPath = indexPath;
    NSArray *sectionArr = self.setPartInfoArr[indexPath.section];
    // 每一组最后一行
    if (indexPath.row == sectionArr.count - 1) {
        [cell setSpaceViewHide:YES];
    }else{
        [cell setSpaceViewHide:NO];
    }
    
    if (self.setPartInfoArr.count == 1) {
        if (self.isPartGroup) {
            cell.type = YHSetPartCellParts; // 配件
        }else{
            cell.type = YHSetPartCellExpend;// 耗材
        }
    }else{ // 有2组
       
        if (indexPath.section == 0) {
            // 配件组
            cell.type = YHSetPartCellParts;
        }
        // 耗材组
        if (indexPath.section == 1) {
            cell.type = YHSetPartCellExpend;
        }
    }
    
    NSMutableArray *oneSectionArr = self.setPartInfoArr[indexPath.section];
    NSMutableDictionary *info = oneSectionArr[indexPath.row];
    info = info.mutableCopy;
    oneSectionArr[indexPath.row] = info;
    
    cell.infoDict = oneSectionArr[indexPath.row];
    cell.selectClassClickEvent = ^(NSIndexPath *indexPath) {
        [self alertListForSelect:indexPath];
    };
    return cell;
}
#pragma mark - UITableViewDelegate ---
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = background_color;
    UILabel *secL = [[UILabel alloc] init];
    secL.textColor = text_color;
    [sectionView addSubview:secL];
    
    if (self.setPartInfoArr.count == 1) {
        
        if (self.isPartGroup) {
            secL.text = @"配件";
        }else{
            secL.text = @"耗材";
        }
    }
    
    if (self.setPartInfoArr.count == 2) {
        
        if (section == 0) {
            secL.text = @"配件";
        }
        
        if (section == 1) {
            secL.text = @"耗材";
        }
    }
    [secL sizeToFit];
    
    [secL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(sectionView);
        make.top.equalTo(@0);
    }];
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isPartGroup = YES;
    if (self.setPartInfoArr.count == 1) {
        
        if (self.isPartGroup) {
            //secL.text = @"配件";
            isPartGroup = YES;
        }else{
            //secL.text = @"耗材";
            isPartGroup = NO;
        }
    }
    
    if (self.setPartInfoArr.count == 2) {
        
        if (indexPath.section == 0) {
            //secL.text = @"配件";
            isPartGroup = YES;
        }
        
        if (indexPath.section == 1) {
            //secL.text = @"耗材";
            isPartGroup = NO;
        }
    }

    
    NSArray *sectionArr = self.setPartInfoArr[indexPath.section];
    // 每一组最后一行
    if (indexPath.row == sectionArr.count -1) {
//        return 124.0;
        return isPartGroup? 175+10 : 140+10;
    }
    //return 134.0;
    return isPartGroup? 185+10 : 150+10;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.setPartInfoArr.count == 0) {
        return 0.0;
    }
    
   NSArray *arr = self.setPartInfoArr[section];
    if (arr.count) {
        return 44.0;
    }else{
        
        return 0.0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"YHSetPartCellHideRemoveBtn" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@__dead",NSStringFromClass([self class]));
}
@end
