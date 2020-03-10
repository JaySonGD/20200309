//
//  YHSetModifyProjectVc.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetModifyProjectVc.h"
#import "YHSetPartSearchVc.h"
#import "YHAddPartVC.h"

#import "YHReplacePartCell.h"
#import "YHCommon.h"
#import <Masonry.h>
#import "YHStoreTool.h"
#import "YHTools.h"
#import "YHNetworkPHPManager.h"



#define background_color [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]
#define text_color [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0]


@interface YHSetModifyProjectVc () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *projectTableView ;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, weak) UIImageView *partImageV;

@property (nonatomic, weak) UILabel *premptL;
/** 是否点击保存按钮 */
@property (nonatomic, assign) BOOL isClickedSaveBtn;

@end

@implementation YHSetModifyProjectVc

- (NSMutableArray *)projectDataSource{
    if (!_projectDataSource.count) {
        _projectDataSource = [NSMutableArray array];
    }
    return _projectDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initSetModifyProjectBase];
    
    [self initSetModifyProjectUI];
    
    [self initData];
    
    [self addBackPopViewBtn];
}
#pragma mark - 导航栏返回按钮 ------
- (void)addBackPopViewBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;

}
- (void)popViewController:(UIButton *)btn{
    
    NSArray *relArr = [self.projectDataSource valueForKeyPath:@"repairProjectName"];
    NSMutableArray *newSubmit = [NSMutableArray array];
    for (NSString *element in relArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:element forKey:@"repairProjectName"];
        [newSubmit addObject:dict];
    }
    self.projectDataSource = newSubmit;
    if (_saveProjectBlock) {
        _saveProjectBlock(self.projectDataSource);
    }
    
    self.isClickedSaveBtn = NO;
    [self caseDetailBtnClickEvent];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[YHStoreTool ShareStoreTool] setAlreadyProjects:self.projectDataSource];
}

- (void)initData{
    
    NSDictionary *temporaryData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporaryData[@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
//    NSArray *repairModeData = temporarySave[@"repairModeData"];
    NSArray *repairModeData = self.catchDataArr;
    NSDictionary *dict = nil;
    for (NSDictionary *itemDict in repairModeData) {
        if ([itemDict[@"repairIndex"] integerValue] == self.index) {
            dict = itemDict;
            break;
        }
    }
    
    if (dict) {
        NSMutableArray *originArr = [NSMutableArray arrayWithArray:dict[@"repairItem"]];
        if (self.projectDataSource.count) {
           NSArray *resultArr = [self combineDataArr:self.projectDataSource otherArr:originArr];
           originArr = [NSMutableArray arrayWithArray:resultArr];
        }
        if (self.repairItemList.count) {
            NSArray *resultArr1 = [self combineDataArr:originArr otherArr:self.repairItemList];
           originArr = [NSMutableArray arrayWithArray:resultArr1];
        }
        self.projectDataSource = originArr;
    }else{
    
        if (self.repairItemList.count) {
            NSArray *resultArr = [self combineDataArr:self.projectDataSource otherArr:self.repairItemList];
            self.projectDataSource = [NSMutableArray arrayWithArray:resultArr];
        }
        
    }
   
    if (self.projectDataSource.count) {
        self.premptL.hidden = YES;
        self.partImageV.hidden = YES;
        self.projectTableView.hidden = NO;
    }else{
        
        self.premptL.hidden = NO;
        self.partImageV.hidden = NO;
        self.projectTableView.hidden = YES;
    }
    [self.projectTableView reloadData];
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
- (void)initSetModifyProjectBase{
    
    self.isClickedSaveBtn = NO;
    
    self.title = @"设置维修项目";
    self.view.backgroundColor = background_color;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addProjectBtnClick)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upadteTableViewDataSource:) name:@"updateModifyProjectTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUISearchSuccessForPart:) name:@"searchSuccessForProjectNotification" object:nil];
}
#pragma mark - 搜索配件耗材返回维修项目的通知 -----
- (void)updateUISearchSuccessForPart:(NSNotification *)noti{
    
    NSArray *searchProjectArr = noti.userInfo[@"repaireListWithPart"];
    self.repairItemList = [NSMutableArray arrayWithArray:searchProjectArr];
    [self initData];
}
#pragma mark - 通知 ----
- (void)upadteTableViewDataSource:(NSNotification *)noti{
    
    NSArray *selectProjects = noti.userInfo[@"selectProjects"];
    self.projectDataSource = [self filterArrar:self.projectDataSource arr2:selectProjects];
    if (self.projectDataSource.count) {
        self.premptL.hidden = YES;
        self.partImageV.hidden = YES;
        self.projectTableView.hidden = NO;
    }else{
        
        self.premptL.hidden = NO;
        self.partImageV.hidden = NO;
        self.projectTableView.hidden = YES;
    }
    
    [self.projectTableView reloadData];
}

#pragma mark - 防止重复添加数据 ---
- (NSMutableArray *)filterArrar:(NSMutableArray *)arr1 arr2:(NSArray *)arr2{
    
    NSMutableArray *newArr1 = [NSMutableArray arrayWithArray:arr1];
    for (int i = 0; i<arr2.count; i++) {
        NSDictionary *item2 = arr2[i];
        BOOL isExist = NO;
        NSInteger index = -1;
        for (int j = 0; j<arr1.count; j++) {
            NSDictionary *item1 = arr1[j];
            if ([item2[@"repairProjectId"] intValue] == [item1[@"repairProjectId"] intValue]) {
                isExist = YES;
                index = j;
            }
        }
        if (isExist) {
            [newArr1 replaceObjectAtIndex:index withObject:item2];
        }else{
            [newArr1 addObject:item2];
        }
    }
    
    return newArr1;
}
- (void)initSetModifyProjectUI{
    
    UIButton *caseDetailBtn = [[UIButton alloc] init];
    [self.view addSubview:caseDetailBtn];
    caseDetailBtn.backgroundColor = YHNaviColor;
    caseDetailBtn.layer.cornerRadius = 5.0;
    caseDetailBtn.layer.masksToBounds = YES;
    [caseDetailBtn setTitle:@"添加维修项目" forState:UIControlStateNormal];
    [caseDetailBtn addTarget:self action:@selector(saveCaseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [caseDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(caseDetailBtn.superview).offset(-10);
        make.bottom.equalTo(caseDetailBtn.superview).offset(bottomMargin);
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
    premptL.text = @"暂无项目信息，请点击上方添加";
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
    UITableView *projectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:projectTableView];
    self.projectTableView = projectTableView;
    projectTableView.delegate = self;
    projectTableView.dataSource = self;
    projectTableView.tableFooterView = [[UIView alloc] init];
    projectTableView.backgroundColor = [UIColor clearColor];
    projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topMargin = iPhoneX ? 88 : 64;
    [projectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(caseDetailBtn.mas_top);
        make.top.equalTo(@(topMargin));
        
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewGesTure)];
    tapGes.delegate = self;
    [projectTableView addGestureRecognizer:tapGes];
}
#pragma mark - UIGestureRecognizerDelegate ---
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:NSClassFromString(@"YHSetPartNameView")]) {
        return NO;
    }
    return YES;
}

- (void)tapTableViewGesTure{
    
    YHReplacePartCell *selectCell = [self.projectTableView cellForRowAtIndexPath:self.currentIndexPath];
    [selectCell hideRemoveBtn];
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
- (void)saveCaseBtnClicked{
    
    YHSetPartSearchVc *addProjectVc = [[YHSetPartSearchVc alloc] initWithControllerType:YHAddProjectType];
    addProjectVc.index = self.index;
    addProjectVc.numbers = self.projectDataSource.count;
    [self.navigationController pushViewController:addProjectVc animated:YES];
  
}
#pragma mark - 保存方案 ---
- (void)caseDetailBtnClickEvent{
    
    if (!self.projectDataSource.count && !self.requireSaveParts.count) {
        [MBProgressHUD showError:@"配件耗材和维修项目必须填写一项"];
        return;
    }
    
    NSDictionary *temporaryData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporaryData[@"temporarySave"];
    NSDictionary *checkResult = temporarySave[@"checkResult"];
//    NSArray *repairModeData = temporarySave[@"repairModeData"];
    NSArray *repairModeData = self.catchDataArr;
    NSMutableArray *saveRepairArr = [NSMutableArray arrayWithArray:repairModeData];
    
    NSMutableDictionary *newSaveItem = [NSMutableDictionary dictionary];
    NSMutableArray *resultArr = [self transformPartArr:self.requireSaveParts];
    if (resultArr.count) {
        [newSaveItem setValue:resultArr forKey:@"parts"];
    }
    
    if (self.projectDataSource.count) {
        [newSaveItem setValue:self.projectDataSource forKey:@"repairItem"];
    }
    
    if (!resultArr.count && !self.projectDataSource.count) {
        return;
    }
    [newSaveItem setValue:@(self.index) forKey:@"repairIndex"];
    
    BOOL isExist = NO;
    NSInteger index = 0;
    
    for (int i = 0; i<repairModeData.count; i++) {
        NSDictionary *item = repairModeData[i];
        if ([item[@"repairIndex"] integerValue] == self.index) {
            isExist = YES;
            index = i;
        }
    }
    
    if (isExist) { // 已存在
        [saveRepairArr replaceObjectAtIndex:index withObject:newSaveItem];
        
    }else{
        [saveRepairArr addObject:newSaveItem];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveModifyPattern:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] checkResult:checkResult repairModeData:saveRepairArr onComplete:^(NSDictionary *info) {

        [MBProgressHUD hideHUDForView:self.view];
        
        int code = [info[@"code"] intValue];
        NSString *msg = info[@"msg"];
        if (code == 20000) {
            if (self.isClickedSaveBtn) {
              [MBProgressHUD showError:msg];
            }

            [self.navigationController popToViewController:self.popVc animated:YES];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:newSaveItem forKey:@"add_newModifyParttern"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCaseNotification" object:nil userInfo:dict];
        }else{
            if (self.isClickedSaveBtn) {
                [MBProgressHUD showError:msg];
            }
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
 
}
#pragma mark - 保存 ---
- (void)addProjectBtnClick{
    
    self.isClickedSaveBtn = YES;
    [self caseDetailBtnClickEvent];
   
}
#pragma mark - UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.projectDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *replaceCellID = @"projectCell";
    YHReplacePartCell *replaceCell = [tableView dequeueReusableCellWithIdentifier:replaceCellID];
    __weak typeof(self)weakSelf = self;
    if (!replaceCell) {
        replaceCell = [[YHReplacePartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replaceCellID];
        replaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        replaceCell.replacePartDeleBtnClickBlock = ^(YHReplacePartCell *cell, NSIndexPath *indexPath) {
            // 取消之前的选中
            YHReplacePartCell *upSelectCell = [tableView cellForRowAtIndexPath:weakSelf.currentIndexPath];
            if (cell != upSelectCell) {
                [upSelectCell hideRemoveBtn];
            }
            // 获取最新的indexPath
            weakSelf.currentIndexPath = indexPath;
        };
    }
    
    replaceCell.replacePartRemoveBtnClickBlock = ^(YHReplacePartCell *cell, NSIndexPath *indexPath) {
        
        weakSelf.currentIndexPath = nil;
        NSMutableArray *newResult = [NSMutableArray arrayWithArray:weakSelf.projectDataSource];
        [newResult removeObjectAtIndex:indexPath.row];
        weakSelf.projectDataSource = [NSMutableArray arrayWithArray:newResult];
        [weakSelf.projectTableView reloadData];
    };
    
    if (!self.currentIndexPath) {
        [replaceCell hideRemoveBtn];
    }
    
    NSDictionary *info = self.projectDataSource[indexPath.row];
    NSLog(@"info---------------%@",NSStringFromClass([info class]));
    replaceCell.infoDict = info;
    NSLog(@"---------------------------------");
    replaceCell.indexPath = indexPath;
    return replaceCell;
}
#pragma mark - UITableViewDelegate ---
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 62.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    UILabel *secL = [[UILabel alloc] init];
    secL.textColor = text_color;
    [sectionView addSubview:secL];
    secL.text = @"维修项目";
    [secL sizeToFit];
    
    [secL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(sectionView);
        make.top.equalTo(@0);
    }];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.projectDataSource.count) {
        return 0;
    }
    return 44.0;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@__dead",NSStringFromClass([self class]));
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHReplacePartCell *selectCell = [self.projectTableView cellForRowAtIndexPath:self.currentIndexPath];
    [selectCell hideRemoveBtn];
}

@end
