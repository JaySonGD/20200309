//
//  YHSetPartSearchVc.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartSearchVc.h"
#import "YHCommon.h"
#import <Masonry.h>

#import "YHSetPartSearchView.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"

#import "YHStoreTool.h"
#import "YHSetPartSearchCell.h"

#import "YHAddPartVC.h"
#import "YHAddModifyProjectVc.h"
#import "YJProgressHUD.H"

#define background_color [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]
#define text_color [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0]

static NSString *const setPartSearch = @"setPartSearchKey";
static NSString *const setProjectSearch = @"setProjectSearchKey";

typedef NS_ENUM(NSInteger, YHSetPartSearchVcShowStatus) {
    YHSetPartSearchVcShowNone, // 不显示任何记录
    YHSetPartSearchVcShowNewestResult, // 显示最近使用记录
    YHSetPartSearchVcShowSearchResult // 显示搜索结果
};

@interface YHSetPartSearchVc () <UITableViewDelegate, UITableViewDataSource, YHSetPartSearchViewDelegate>

@property (nonatomic, weak) UITableView *searchTableView;
/** 增加配件搜索记录数据源 */
@property (nonatomic, strong) NSMutableArray *dataPartArr;
/** 增加项目搜索记录数据源 */
@property (nonatomic, strong) NSMutableArray *dataProjcetArr;
/** 配件搜索返回的结果数据 */
@property (nonatomic, strong) NSMutableArray *resulrArr;
/** 项目搜索返回的结果数据 */
@property (nonatomic, strong) NSMutableArray *resulrProjectArr;
/** 显示信息类型 */
@property (nonatomic, assign) YHSetPartSearchVcShowStatus showStatus;
/** tableview的头部控件 */
@property (nonatomic, weak) YHSetPartSearchView *searchView;
/** 添加新配件耗材 */
@property (nonatomic, weak) UIButton *addPartBtn;
/** 提示语 */
@property (nonatomic, weak) UILabel *promptL;

@property (nonatomic, assign) YHSetPartsType type;
/** 添加项目时已选择的项目 */
@property (nonatomic, strong) NSMutableArray *selectedProjectArr;

/** 添加项目时已选择的项目 */
@property (nonatomic, strong) NSMutableArray *selectedPartArr;

@property (nonatomic, weak)  UILabel *indicateL;

@property (nonatomic, strong) UIWindow *indicateW;
/** 当前搜索框文本 */
@property (nonatomic, copy) NSString *currentSearchText;

@end

@implementation YHSetPartSearchVc

- (instancetype)initWithControllerType:(YHSetPartsType)type{
    if (self = [super init]) {
        
        [self initSearchUI];
        self.type = type;
        
        // 请求最近使用的数据
        [self requestNewestUseData];
    }
    return self;
}

- (NSMutableArray *)dataPartArr{
    if (!_dataPartArr.count) {
        _dataPartArr = [NSMutableArray array];
    }
    return _dataPartArr;
}
- (NSMutableArray<NSString *> *)dataProjcetArr{
    
    if (!_dataProjcetArr.count) {
        _dataProjcetArr = [NSMutableArray array];
    }
    return _dataProjcetArr;
}
- (NSMutableArray *)selectedProjectArr{
    if (!_selectedProjectArr.count) {
        _selectedProjectArr = [NSMutableArray array];
    }
    return _selectedProjectArr;
}
- (NSMutableArray *)selectedPartArr{
    if (!_selectedPartArr.count) {
        _selectedPartArr = [NSMutableArray array];
    }
    return _selectedPartArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addIndicateLable];
    
    [self initSearchBase];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.indicateW.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.indicateW.hidden = YES;
}
#pragma mark - 增加指示器 --
- (void)addIndicateLable{
    
    CGFloat topM = iPhoneX ? 35 : 11;
    UIWindow *indicateW = [[UIWindow alloc] initWithFrame:CGRectMake(35, topM, 16, 16)];
    self.indicateW = indicateW;
    indicateW.hidden = YES;
    
    UILabel *indicateL = [[UILabel alloc] init];
    indicateL.textAlignment = NSTextAlignmentCenter;
    indicateL.backgroundColor = [UIColor redColor];
    indicateL.layer.cornerRadius = 8.0;
    indicateL.layer.masksToBounds = YES;
    indicateL.font = [UIFont systemFontOfSize:11.0];
    indicateL.textColor = [UIColor whiteColor];
    self.indicateL = indicateL;
    [indicateW addSubview:indicateL];
    indicateL.frame = CGRectMake(0, 0, indicateW.frame.size.width, indicateW.frame.size.height);
    
}
- (void)requestNewestUseData{
    
    if (self.type == YHConsuMaterialType) {
        [self searchPartsData:nil];
    }
  
    if (self.type == YHAddProjectType) {
        [self searchProjectDate:nil];
    }
}
- (void)initSearchBase{
    
    self.view.backgroundColor = background_color;
    self.showStatus = YHSetPartSearchVcShowNone;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
    
}
#pragma mark - 点击返回按钮 ----
- (void)popViewController:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.type == YHConsuMaterialType) {
        // 根据配件名称搜索维修项目
        [self getRepairItemListByPartsName];
    }
    
    if (self.type == YHAddProjectType) {
        
        if (self.selectedProjectArr.count) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.selectedProjectArr forKey:@"selectProjects"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateModifyProjectTableView" object:nil userInfo:dict];
        }
    }
}
- (void)setType:(YHSetPartsType)type{
    
    _type = type;
    
    if (self.type == YHConsuMaterialType) {
        self.title = @"增加配件耗材";
        [self.searchView setTextFieldPlaceHolder:@"请输入配件或耗材名称"];
        [self.addPartBtn setTitle:@"添加新配件耗材" forState:UIControlStateNormal];
        self.promptL.text = @"没有搜索到对应的配件耗材";
    }
    
    if (self.type == YHAddProjectType) {
        self.title = @"添加项目";
        [self.searchView setTextFieldPlaceHolder:@"请输入项目名称"];
        [self.addPartBtn setTitle:@"添加新项目" forState:UIControlStateNormal];
        self.promptL.text = @"没有搜索到对应的项目";
    }
    
}
- (void)setNumbers:(NSInteger)numbers{
    _numbers = numbers;
  
    self.indicateL.hidden = numbers == 0 ? YES : NO;
    self.indicateL.text = [NSString stringWithFormat:@"%ld",(long)self.numbers];
    if (numbers >= 100) {
        CGRect frame = self.indicateL.frame;
        frame.size.width = 22;
        frame.size.height = 22;
        self.indicateL.layer.cornerRadius = 11.0;
        self.indicateL.layer.masksToBounds = YES;
        self.indicateL.frame = frame;
    }
}
- (void)initSearchUI{
    // 搜索框
    YHSetPartSearchView *searchView = [[YHSetPartSearchView alloc] init];
    self.searchView = searchView;
    searchView.delegate = self;
//    __weak typeof(self)weakSelf = self;
//    searchView.searchBtnClickBlock = ^(NSString *searchStr) {
//        // 搜索配件
//        if (weakSelf.type == YHConsuMaterialType) {
//            [weakSelf searchPartsData:searchStr];
//        }
//        // 搜索项目
//        if (weakSelf.type == YHAddProjectType) {
//            [weakSelf searchProjectDate:searchStr];
//        }
//    };
     CGFloat topMargin = iPhoneX ? 88 : 64;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    // initTableView
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.tableFooterView = [[UIView alloc] init];
    searchTableView.backgroundColor = [UIColor clearColor];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    self.searchTableView = searchTableView;
    [self.view addSubview:searchTableView];
    
    [searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    UIButton *addPartBtn = [[UIButton alloc] init];
    addPartBtn.hidden = YES;
    self.addPartBtn = addPartBtn;
    [self.view addSubview:addPartBtn];
    addPartBtn.backgroundColor = YHNaviColor;
    addPartBtn.layer.cornerRadius = 5.0;
    addPartBtn.layer.masksToBounds = YES;
    [addPartBtn addTarget:self action:@selector(addPartBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [addPartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(addPartBtn.superview).offset(-10);
        make.bottom.equalTo(addPartBtn.superview).offset(bottomMargin);
        make.height.equalTo(@40);
    }];
    // 提示语
    UILabel *promptL = [[UILabel alloc] init];
    self.promptL = promptL;
    promptL.textColor = text_color;
    promptL.hidden = YES;
   
    [self.view addSubview:promptL];
    [promptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.equalTo(@20);
        make.right.equalTo(@20);
        make.height.equalTo(@40);
    }];
}
#pragma mark - 根据配件名称搜索 ---
- (void)searchPartsData:(NSString *)searchStr{
    
    NSLog(@"-----------searchStr=%@---根据配件名称搜索 -------------",searchStr);
    if (!searchStr) {
        searchStr = @"";
    }

    __weak typeof(self)weakSelf = self;
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [YJProgressHUD showProgress:@"" inView:self.view];

    [[YHNetworkPHPManager sharedYHNetworkPHPManager] searchPartInfo:[YHTools getAccessToken] keys:@{@"partsName" : searchStr} billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] onComplete:^(NSDictionary *info) {
        
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        [YJProgressHUD hide];
        NSMutableArray *alreadyParts = [YHStoreTool ShareStoreTool].alreadyParts;
        NSMutableArray *newPartsArr = [self arrayChangeForOtherArray:alreadyParts];
        
        // 最近使用
        if (!searchStr.length) {
            
            weakSelf.showStatus = YHSetPartSearchVcShowNewestResult;
            NSDictionary *dataDict = info[@"data"];
            NSArray *partsNameList = dataDict[@"partsNameList"];
            NSArray *sourceArr =  [weakSelf combineDataArr:partsNameList otherArr:newPartsArr];
            NSArray *resultArr = [self getDataSourceWithArr:sourceArr];
            weakSelf.dataPartArr = [NSMutableArray arrayWithArray:resultArr];
            weakSelf.promptL.hidden = weakSelf.dataPartArr.count ? YES : NO;
        }else{
            // 搜索
            weakSelf.showStatus = YHSetPartSearchVcShowSearchResult;
            NSDictionary *dataDict = info[@"data"];
            NSArray *partsNameList = dataDict[@"partsNameList"];
            NSArray *sourceArr =  [weakSelf combineDataArr:partsNameList otherArr:newPartsArr];
            weakSelf.resulrArr = [weakSelf getDataSourceWithArr:sourceArr];
            weakSelf.promptL.hidden = weakSelf.resulrArr.count ? YES : NO;
        }
        
        weakSelf.addPartBtn.hidden = weakSelf.promptL.hidden;
        [weakSelf.searchTableView reloadData];
        
    } onError:^(NSError *error) {
        [YJProgressHUD hide];
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (NSMutableArray *)arrayChangeForOtherArray:(NSArray *)otherArray{
    
    if (otherArray.count == 1) {
        NSArray *oneArray = [otherArray firstObject];
        return [NSMutableArray arrayWithArray:oneArray];
    }
   
    if (otherArray.count == 2) {
        NSArray *oneArray = [otherArray firstObject];
        NSArray *twoArray = [otherArray lastObject];
       NSMutableArray *resultArr = [NSMutableArray arrayWithArray:oneArray];
        [resultArr addObjectsFromArray:twoArray];
        return resultArr;
    }
    return [NSMutableArray array];
}
#pragma mark - 过滤配件耗材数组数据 ---
- (NSArray *)combineDataArr:(NSArray *)arr otherArr:(NSArray *)otherArr{
    
    if (!otherArr.count) {
        return [NSArray arrayWithArray:arr];
    }
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
    for (NSDictionary *item in otherArr) {
        NSString *name = item[@"partsName"];
        NSString *type = item[@"type"];
        BOOL isExist = NO;
        NSDictionary *removeDict = nil;
        for (NSDictionary *dict in arr) {
            NSString *dictName = dict[@"partsName"];
            NSString *dictType = dict[@"type"];
            if ([name isEqualToString:dictName] && [type isEqualToString:dictType]) {
                isExist = YES;
                removeDict = dict;
            }
        }
        if (isExist) {
            [newArr removeObject:removeDict];
        }
    }
    
    return [NSArray arrayWithArray:newArr];
}

#pragma mark - 根据项目名称搜索 ---
- (void)searchProjectDate:(NSString *)searchStr{
    
    if (!searchStr) {
        searchStr = @"";
    }
    
     __weak typeof(self)weakSelf = self;
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [YJProgressHUD showProgress:@"" inView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] searchPartClass:[YHTools getAccessToken] page:@"1" billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] partsClassName:weakSelf.searchView.inputTf.text onComplete:^(NSDictionary *info) {
        
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        [YJProgressHUD hide];
        NSMutableArray *alreadyProjects = [YHStoreTool ShareStoreTool].alreadyProjects;
    
        NSLog(@"搜索项目结果searchStr = %@----info ======  %@---工单id======%d",searchStr,info,[[YHStoreTool ShareStoreTool].orderInfo[@"id"] intValue]);
        if (!searchStr.length) {
            
            weakSelf.showStatus = YHSetPartSearchVcShowNewestResult;
            NSDictionary *dataDict = info[@"data"];
            NSArray *partClassArr = dataDict[@"partsClass"];
            NSMutableArray *resultArr = [self fileProjectArrayData:partClassArr fileArr:alreadyProjects];
            weakSelf.dataProjcetArr = [NSMutableArray arrayWithArray:resultArr];
            weakSelf.promptL.hidden = weakSelf.dataProjcetArr.count ? YES : NO;
            
        }else{
            
            weakSelf.showStatus = YHSetPartSearchVcShowSearchResult;
            NSDictionary *dataDict = info[@"data"];
            NSArray *partClassArr = dataDict[@"partsClass"];
            NSMutableArray *resultArr = [self fileProjectArrayData:partClassArr fileArr:alreadyProjects];
            weakSelf.resulrProjectArr = [NSMutableArray arrayWithArray:resultArr];
            weakSelf.promptL.hidden = weakSelf.resulrProjectArr.count ? YES : NO;
            
        }
        
        weakSelf.addPartBtn.hidden = weakSelf.promptL.hidden;
        [weakSelf.searchTableView reloadData];
        
    } onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        [YJProgressHUD hide];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark - 过滤项目数组数据 ----
- (NSMutableArray *)fileProjectArrayData:(NSArray *)arr fileArr:(NSArray *)fileArr{
    
    if (!fileArr.count) {
        return [NSMutableArray arrayWithArray:arr];
    }
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
    for (NSDictionary *item in fileArr) {
        NSInteger Id = [item[@"repairProjectId"] integerValue];
        BOOL isExist = NO;
        NSDictionary *removeDict = nil;
        for (NSDictionary *dict in arr) {
            NSInteger dictId = [dict[@"repairProjectId"] integerValue];
            if (Id == dictId) {
                isExist = YES;
                removeDict = dict;
            }
        }
        if (isExist) {
            [newArr removeObject:removeDict];
        }
    }
    
    return newArr;
}
#pragma mark - 添加新项目 || 配件耗材 ----
- (void)addPartBtnClickEvent{
    
    __weak typeof(self)weakSelf = self;
    if (self.type == YHConsuMaterialType) {
        
        YHAddPartVC *addPartVc = [[YHAddPartVC alloc] init];
        addPartVc.notificationToSearchViewBlock = ^(NSString *text) {
            weakSelf.searchView.inputTf.text = text;
            [weakSelf searchPartsData:text];
        };
        addPartVc.searchText = self.currentSearchText;
        addPartVc.index = self.index;
        [self.navigationController pushViewController:addPartVc animated:YES];
    }
    // 添加新项目
    if (self.type == YHAddProjectType) {
        
        YHAddModifyProjectVc *addProjectVc = [[YHAddModifyProjectVc alloc] init];
        addProjectVc.notificationToSearchViewBlockFromProject = ^(NSString *text) {
            NSLog(@"TEXT ==== %@",text);
            weakSelf.searchView.inputTf.text = text;
            [weakSelf searchProjectDate:text];
        };
        addProjectVc.searchText = self.currentSearchText;
        [self.navigationController pushViewController:addProjectVc animated:YES];
    }
}

- (NSMutableArray *)getDataSourceWithArr:(NSArray *)arr{
    
    NSMutableArray *partsArr = [NSMutableArray array];
    NSMutableArray *expendArr = [NSMutableArray array];
    for (NSDictionary *item in arr) {
       NSString *type = item[@"type"];
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
#pragma mark - 根据配件名称搜索维修项目 ----
- (void)getRepairItemListByPartsName{

    if (self.type != YHConsuMaterialType || !self.selectedPartArr.count) {
        return;
    }

    NSMutableString *paramStr = [NSMutableString string];

    for (int i = 0; i<self.selectedPartArr.count; i++) {
        NSDictionary *item = self.selectedPartArr[i];
        NSString *partsName = item[@"partsName"];
        [paramStr appendString:partsName];
        if (i != self.selectedPartArr.count - 1) {
            [paramStr appendString:@","];
        }
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.selectedPartArr forKey:@"selectParts"];
    [dict setValue:[self class] forKey:@"class"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YHAddPartVC_addPart" object:nil userInfo:dict];

//    [MBProgressHUD showMessage:@"" toView:self.view];
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getRepairItemList:[YHTools getAccessToken] partsName:paramStr onComplete:^(NSDictionary *info) {
//        [MBProgressHUD hideHUDForView:self.view];
//        int code = [info[@"code"] intValue];
//        if (code == 20000) {
//            NSDictionary *data = info[@"data"];
//            NSArray *repairList = data[@"repairItemList"];
//            if (_searchPartGetProjectListNotification) {
//                _searchPartGetProjectListNotification([NSMutableArray arrayWithArray:repairList]);
//            }
//        }
//    } onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];

}
#pragma mark - UITableViewDataSource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 本地搜索记录
    if (self.type == YHConsuMaterialType) {
        
        if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
            return self.dataPartArr.count;
        }
        
        if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
            return self.resulrArr.count;
        }
    }
        return 1.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (self.type == YHAddProjectType) {
        
        if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
            return self.dataProjcetArr.count;
        }
        return self.resulrProjectArr.count;
    }
   
    if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
        NSArray *sectionArr = self.dataPartArr[section];
        return sectionArr.count;
    }else{
        NSArray *sectionArr = self.resulrArr[section];
        return sectionArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"YHSetPartSearchVCID";
    YHSetPartSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YHSetPartSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.numberOfLines = 2.0;
    }
    
    if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
        if (self.type == YHConsuMaterialType) {
            NSArray *sectionArr = self.dataPartArr[indexPath.section];
           NSDictionary *item = sectionArr[indexPath.row];
            cell.textLabel.text = item[@"partsName"];
        }else{
            NSDictionary *item = self.dataProjcetArr[indexPath.row];
            cell.textLabel.text = item[@"repairProjectName"];
        }
    }
    
    if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
        
        if (self.type == YHConsuMaterialType) {
            NSArray *itemArr = self.resulrArr[indexPath.section];
            NSDictionary *itemDict = itemArr[indexPath.row];
            cell.textLabel.text = itemDict[@"partsName"];
//            BOOL isExist = [self isExistToArrayForDict:itemDict key:@"partsName" inArr:self.selectedPartArr];
//            cell.statusBtn.selected = isExist;

        }
        
        if (self.type == YHAddProjectType) {
            
            NSDictionary *itemDict = self.resulrProjectArr[indexPath.row];
            cell.textLabel.text = itemDict[@"repairProjectName"];
//            cell.statusBtn.selected = [self isExistToArrayForDict:itemDict key:@"repairProjectName" inArr:self.selectedProjectArr] ? YES : NO;
        }
    }

//    if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
//        cell.statusBtn.hidden = NO;
//    }else{
//        cell.statusBtn.hidden = YES;
//    }
    
    return cell;
}
- (BOOL)isExistToArrayForDict:(NSDictionary *)item key:(NSString *)key inArr:(NSArray *)arr{
    
    BOOL isExist = NO;
    if (self.type == YHConsuMaterialType) {
        
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dict = arr[i];
            if ([item[key] isEqualToString:dict[key]] && [item[@"type"] isEqualToString:dict[@"type"]]) {
                isExist = YES;
            }
        }
        return isExist;
    }
    
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dict = arr[i];
        if ([item[key] isEqualToString:dict[key]]) {
            isExist = YES;
        }
    }
    return isExist;
}
#pragma mark - UITableViewDelegate --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
        
        if (self.type == YHAddProjectType) {
            return 10.0;
        }
    }
    
    if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
       
        if (self.type == YHConsuMaterialType && !self.dataPartArr.count) {
            return 0;
        }
        
        if (self.type == YHConsuMaterialType && self.dataPartArr.count == 2) {
            
            if (section == 1) {
                return 0;
            }
        }
        
        if (self.type == YHAddProjectType && !self.dataProjcetArr.count) {
            return 0;
        }
    }
    
    return 44.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = background_color;
    UILabel *secL = [[UILabel alloc] init];
    secL.textColor = text_color;
    [sectionView addSubview:secL];
    
    if (section == 0) {
        
        if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
            if (self.type == YHConsuMaterialType) {
                secL.text = @"最近使用";
            }
            
            if (self.type == YHAddProjectType) {
                secL.text = @"最近使用过项目";
            }
        }
        if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
            
            if (self.type == YHConsuMaterialType) {
                
                NSArray *firstArr = self.resulrArr[section];
                if (firstArr.count) {
                    NSDictionary *dict = firstArr[0];
                   NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
                    if ([type isEqualToString:@"1"]) {
                         secL.text = @"配件";
                    }
                    if ([type isEqualToString:@"2"]) {
                         secL.text = @"耗材";
                    }
                }
            }
        }
    }
    
    if (section == 1) {
        secL.text = @"耗材";
    }
    
    [secL sizeToFit];
    [secL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(sectionView);
        make.top.equalTo(@0);
    }];
    return sectionView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 处于最近使用状态时
    if (self.showStatus == YHSetPartSearchVcShowNewestResult) {
        
        if (self.type == YHConsuMaterialType) {
            
            if (!self.dataPartArr.count) {
                return;
            }
            
            NSArray *secArr = self.dataPartArr[indexPath.section];
            NSDictionary *item = secArr[indexPath.row];
            [self.selectedPartArr addObject:item];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataPartArr[indexPath.section]];
            [arr removeObjectAtIndex:indexPath.row];
            if (arr.count) {
                [self.dataPartArr replaceObjectAtIndex:indexPath.section withObject:arr];
            }else{
                
                [self.dataPartArr removeObjectAtIndex:indexPath.section];
            }
            
            [self.dataPartArr removeObject:item];
        }
        
        if (self.type == YHAddProjectType) {
            
            if (!self.dataProjcetArr.count) {
                return;
            }
            NSDictionary *item = self.dataProjcetArr[indexPath.row];
            [self.selectedProjectArr addObject:item];
            [self.dataProjcetArr removeObject:item];
        }
        
    }
    // 处于搜索状态
    if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
    
        if (self.type == YHAddProjectType) {
            if (!self.resulrProjectArr.count) {
                return;
            }
            
            [self.selectedProjectArr addObject:self.resulrProjectArr[indexPath.row]];
            [self.resulrProjectArr removeObjectAtIndex:indexPath.row];
        }
    }
    
    // 处于搜索状态
    if (self.showStatus == YHSetPartSearchVcShowSearchResult) {
        
        if (self.type == YHConsuMaterialType) {
            
            if (!self.resulrArr.count) {
                return;
            }
            
             NSArray *sectionArr = self.resulrArr[indexPath.section];
            [self.selectedPartArr addObject:sectionArr[indexPath.row]];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.resulrArr[indexPath.section]];
            [arr removeObjectAtIndex:indexPath.row];
            if (arr.count) {
                 [self.resulrArr replaceObjectAtIndex:indexPath.section withObject:arr];
            }else{
                
                [self.resulrArr removeObjectAtIndex:indexPath.section];
            }
           
        }
    }
     self.numbers++;
    
    [self.searchTableView reloadData];
}

- (void)dealloc{
    
    self.indicateW = nil;
    NSLog(@"%@--dead",NSStringFromClass([self class]));
}

#pragma mark - YHSetPartSearchViewDelegate --
- (void)setPartSearchViewTextFieldStartEdit:(NSString *)text{
    
    NSLog(@"setPartSearchViewTextFieldStartEdit----text = %@-------------",text);
    self.currentSearchText = text;
    if (!text.length) {
        self.showStatus = YHSetPartSearchVcShowNewestResult;
        self.promptL.hidden = YES;
       
    }else{
        // 搜索配件
        if (self.type == YHConsuMaterialType) {
            [self searchPartsData:text];
        }
        // 搜索项目
        if (self.type == YHAddProjectType) {
            [self searchProjectDate:text];
        }
    }
     [self.searchTableView reloadData];
}
@end
