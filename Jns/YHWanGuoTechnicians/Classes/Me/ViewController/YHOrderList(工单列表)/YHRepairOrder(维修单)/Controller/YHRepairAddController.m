//
//  YHRepairAddController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairAddController.h"
#import "YHAddRepairCell.h"
#import "partSearchModel.h"
#import <MJExtension.h>

#define key_name [self getKey]

@interface YHRepairAddController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSBlockOperation *_operation;
}

@property (nonatomic, weak) UIButton *submitBtn;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray <partSearchModel *>*resultArr;
/** 本地搜索记录 */
@property (nonatomic, strong) NSMutableArray *localHistoryRecordList;
/** 选择结果 */
@property (nonatomic, strong) NSMutableArray <partSearchModel *>*finalSelectArr;

@property (nonatomic, weak) UITableView *listTableView;

@property (nonatomic, weak)  UITextField *searchTft;

@property (nonatomic, assign) CGFloat sectionH;

@property (nonatomic,assign) YHRepairStatus status;

@property (nonatomic, weak) UILabel *noSearchResultL;

@end

static NSString *repairAddCellId = @"repairAddCellId";
static NSString *localSearchRecordPart = @"YHRepairAddController_localSearchRecord_part";
static NSString *localSearchRecordMaterial = @"YHRepairAddController_localSearchRecord_Material";
static NSString *localSearchRecordProject = @"YHRepairAddController_localSearchRecord_project";

@implementation YHRepairAddController

- (NSString *)getKey{

    if (self.repairType == YHRepairPartType) {
        return @"part_name";
    }
    return  @"item_name";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.finalSelectArr = [NSMutableArray array];
    // 显示本地搜索时的状态
    self.status = YHRepairStatusShowLocalRecord;
    
    [self setUI];
    
    NSArray *localArr = [[NSUserDefaults standardUserDefaults] arrayForKey:localSearchRecordPart];
    
    if (self.repairType == YHRepairMaterialType) {
        localArr = [[NSUserDefaults standardUserDefaults] arrayForKey:localSearchRecordMaterial];
    }
    
    if (self.repairType == YHRepairProjectType) {
         localArr = [[NSUserDefaults standardUserDefaults] arrayForKey:localSearchRecordProject];
    }
    NSMutableArray *localSearchRecordArr = [NSMutableArray arrayWithArray:localArr];
    
    self.localHistoryRecordList = localSearchRecordArr;
    
    if (!localSearchRecordArr.count) {
        self.localHistoryRecordList = [NSMutableArray array];
    }
    
    self.resultArr = [NSMutableArray arrayWithCapacity:10];
    
    if(self.models.count){
        for (NSString *str in self.models) {
            partSearchModel *model = [partSearchModel new];
            model.full_name = str;
            [self.resultArr addObject:model];
        }
        
    }else{
        
    self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:localSearchRecordArr];
        
    }
    
    if(self.resultArr.count){
        
        self.sectionH = 44.0;
    }
    
    [self.listTableView reloadData];
}

- (void)setBase_info:(YHBaseInfoModel *)base_info{
    
    if(!base_info)return;
    
    NSMutableDictionary *baseInfoNew = [base_info mj_keyValues];

    self.baseInfo = [YTBaseInfo mj_objectWithKeyValues:baseInfoNew];
}

- (void)setUI{
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancelBtn setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.right.equalTo(@(-15));
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    UITextField *searchTft = [UITextField new];
    searchTft.font = [UIFont systemFontOfSize:15.0];
    searchTft.returnKeyType = UIReturnKeySearch;
    searchTft.delegate = self;
    self.searchTft = searchTft;
    NSString *key = [NSString stringWithFormat:@"%ld",self.repairType];
    NSString *placeText = @{@"0":@"请输入配件名称",@"1":@"请输入耗材名称",@"2":@"请输入维修项目名称"}[key];
    searchTft.placeholder = placeText;
    searchTft.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [self.view addSubview:searchTft];
    [self.searchTft addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchTft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.left.equalTo(@15);
        make.height.equalTo(@35);
        make.right.equalTo(cancelBtn.mas_left);
    }];
    
    UIImageView *searchIcon = [UIImageView new];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.image = [UIImage imageNamed:@"searchIcon"];
    searchIcon.frame = CGRectMake(0, 0, 35, 35);
    searchTft.leftView = searchIcon;
    searchTft.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat bottom = iPhoneX ? 49 : 15;
    UIButton *submitBtn = [UIButton new];
    submitBtn.hidden = YES;
    self.submitBtn = submitBtn;
    [submitBtn setTitle:@"设置完毕" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    submitBtn.backgroundColor = YHNaviColor;
    submitBtn.layer.cornerRadius = 5.0;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@54);
        make.bottom.equalTo(@(-bottom));
    }];
    
    UILabel *noSearchResultL = [UILabel new];
    self.noSearchResultL = noSearchResultL;
    noSearchResultL.hidden = YES;
    noSearchResultL.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:noSearchResultL];
    [noSearchResultL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@15);
        make.height.equalTo(@40);
        make.top.equalTo(searchTft.mas_bottom).offset(15);
    }];
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [listTableView registerNib:[UINib nibWithNibName:@"YHAddRepairCell" bundle:nil] forCellReuseIdentifier:repairAddCellId];
    listTableView.backgroundColor = [UIColor whiteColor];
    listTableView.rowHeight = 44.0;
    self.listTableView = listTableView;
    listTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listTableView];
  
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchTft.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(submitBtn.mas_top);
    }];
}
- (void)submitBtnClickEvent{
    
    self.noSearchResultL.hidden = YES;
    self.listTableView.hidden = NO;
    
    if ([[self.submitBtn currentTitle] isEqualToString:@"设置完毕"]) {
        
        if (_addDataBlock) {
            _addDataBlock(self.finalSelectArr,self.repairType);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        partSearchModel *item = [partSearchModel new];
        item.full_name = self.searchTft.text;
        
        // 新增
        if (![self.finalSelectArr containsObject:item]) {
            [self.finalSelectArr addObject:item];
        }
        self.status = YHRepairStatusShowFinalSelectResult;
        self.resultArr = [NSMutableArray arrayWithArray:self.finalSelectArr];
        [self.listTableView reloadData];
        [self.submitBtn setTitle:@"设置完毕" forState:UIControlStateNormal];
    }
}
- (void)cancelEvent:(UIButton *)cancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.repairType == YHRepairPartType) {
        [[NSUserDefaults standardUserDefaults] setValue:self.localHistoryRecordList.copy forKey:localSearchRecordPart];
    }else if(self.repairType == YHRepairMaterialType){
        [[NSUserDefaults standardUserDefaults] setValue:self.localHistoryRecordList.copy forKey:localSearchRecordMaterial];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:self.localHistoryRecordList.copy forKey:localSearchRecordProject];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
    [_operation cancel];
    _operation = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHAddRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:repairAddCellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YHAddRepairCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleL.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
        cell.titleL.font = [UIFont systemFontOfSize:15.0];
    }
   
    cell.indexPath = indexPath;
    __weak typeof(self)weakSelf = self;
    cell.closeCellCallBbackBlock = ^(NSIndexPath *indexPath) {
        
        if(self.status != YHRepairStatusShowLocalRecord){
            
        [weakSelf.finalSelectArr removeObjectAtIndex:indexPath.row];
            
        if(!weakSelf.finalSelectArr.count)self.submitBtn.hidden = YES;
            
        }else{
    
        if(_removeCallBack){
            _removeCallBack(indexPath.row);
        }
            
        if(self.resultArr.count == 1 && !self.isNotZero) return;
            
        [self.models removeObjectAtIndex:indexPath.row];
            
        }
        
        [weakSelf.resultArr removeObjectAtIndex:indexPath.row];
        
        if(!weakSelf.resultArr.count && !weakSelf.finalSelectArr.count){
            
            if(self.models.count){
                
                for (NSString *str in self.models) {
                    partSearchModel *model = [partSearchModel new];
                    model.full_name = str;
                    [self.resultArr addObject:model];
                }
                
            }else{
            
               self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:weakSelf.localHistoryRecordList];
                
            }
            self.sectionH = 44;
            self.status = YHRepairStatusShowLocalRecord;
            self.searchTft.text = @"";
        }
        [weakSelf.listTableView reloadData];
    };
    
    partSearchModel *itemDict = self.resultArr[indexPath.row];
    if (self.status == YHRepairStatusShowLocalRecord || self.status == YHRepairStatusShowSearchResult) {
        cell.closeBtn.hidden = YES;
    }else{
        cell.closeBtn.hidden = NO;
    }
    
    if(self.status == YHRepairStatusShowLocalRecord  && self.models.count){
         cell.closeBtn.hidden = NO;
    }
        
    cell.titleL.text = itemDict.full_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.status == YHRepairStatusShowFinalSelectResult || (self.status == YHRepairStatusShowLocalRecord && self.models.count)) {
        return;
    }
    
    partSearchModel *item = self.resultArr[indexPath.row];
    if (self.status == YHRepairStatusShowLocalRecord) {
        
        if (self.repairType == YHRepairProjectType) {
            [self repairProjectSearch:item.full_name];
        }else{
            [self partSearchDark:item.full_name];
        }
        
            self.searchTft.text = item.full_name;

    }
    
    // 模糊搜索状态
    if (self.status == YHRepairStatusShowSearchResult) {
       
        // 配件精准搜索 (不再需要)
//        if (self.repairType == YHRepairPartType) {
//            [self partSearcheExact:item[key_name]];
//            return;
//        }
        
        if (![self.finalSelectArr containsObject:item]) {
            [self.finalSelectArr addObject:item];
        }
        self.status = YHRepairStatusShowFinalSelectResult;
         self.searchTft.text = item.full_name;
        self.resultArr = [NSMutableArray arrayWithArray:self.finalSelectArr];
        [self.listTableView reloadData];
        [self.submitBtn setTitle:@"设置完毕" forState:UIControlStateNormal];
        self.submitBtn.hidden = NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [UIView new];
    UILabel *textL = [UILabel new];
    textL.font = [UIFont systemFontOfSize:16.0];
    textL.text = self.models.count ? self.TitleText  : @"最近使用";
    [sectionView addSubview:textL];
    [textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@0);
        make.height.equalTo(textL.superview);
        make.top.equalTo(@0);
    }];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionH;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if(IsEmptyStr(textField.text)){//恢复
        
            if(self.models.count){
                self.resultArr = [NSMutableArray array];
                for (NSString *str in self.models) {
                    partSearchModel *model = [partSearchModel new];
                    model.full_name = str;
                    [self.resultArr addObject:model];
                }
                
            }else{
                
                self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:self.localHistoryRecordList];
                
            }
            self.sectionH = 44;
            self.status = YHRepairStatusShowLocalRecord;
            self.listTableView.hidden = NO;
        
            [self.listTableView reloadData];
        
    }
    
    //获取是否有高亮
    UITextRange *selectedRange = [textField markedTextRange];
    if(!selectedRange){
    //当检测到textfield发生变化0.7秒后会调用该方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(searchResultWithText:) withObject:textField.text afterDelay:0.1f];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(self.status == YHRepairStatusShowFinalSelectResult)return;
    
    if(self.status == YHRepairStatusShowLocalRecord && !self.models.count){
    self.listTableView.hidden = YES;
    self.submitBtn.hidden = YES;
    self.noSearchResultL.hidden = YES;
    return;
    }
    
    //获取是否有高亮
    UITextRange *selectedRange = [textField markedTextRange];
    if(!selectedRange){
        //当检测到textfield发生变化0.7秒后会调用该方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(searchResultWithText:) withObject:textField.text afterDelay:0.1f];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(IsEmptyStr(textField.text)){
        self.status = YHRepairStatusShowLocalRecord;
    }
    
    if(self.status == YHRepairStatusShowSearchResult){
        
        self.submitBtn.hidden = self.resultArr.count;
        self.noSearchResultL.hidden = NO;
        
    }else{
    
    self.listTableView.hidden = NO;
    
    if(self.status == YHRepairStatusShowFinalSelectResult){
        
        self.submitBtn.hidden = NO;
        return;
        
    }
        
    if(!self.models.count){
        //本地
        self.status = YHRepairStatusShowLocalRecord;
        self.sectionH = 44;
        self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:self.localHistoryRecordList];
    }
    
    [self.listTableView reloadData];
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (string.length == 0 && range.length == 1 && range.location == 0) {
//        self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:self.localHistoryRecordList];
//        self.sectionH = self.resultArr.count ? 44.0 : 0;
//        self.status = YHRepairStatusShowLocalRecord;
        self.submitBtn.hidden = YES;
        self.noSearchResultL.hidden = YES;
        self.listTableView.hidden = YES;
//        [self.listTableView reloadData];
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 16) {
        textField.text = [toBeString substringToIndex:16];
        [MBProgressHUD showError:@"最多输入16个字"];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    NSString *textResult = textField.text;
    if (!textField.text || textResult.length == 0 || [textField.text isEqualToString:@""]) {
        return YES;
    }
    if (_operation && _operation.isExecuting) {
        return YES;
    }
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
    [itemDict setValue:textResult forKey:key_name];
    
    if (![self.localHistoryRecordList containsObject:itemDict]) {
         [self.localHistoryRecordList insertObject:itemDict atIndex:0];
        
        if (self.localHistoryRecordList.count > 10) {
            [self.localHistoryRecordList removeLastObject];
        }
    }
    __weak typeof(self)weakSelf = self;
     self.submitBtn.hidden = YES;
    _operation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf searchResultWithText:textResult];
    }];
    [[NSOperationQueue mainQueue] addOperation:_operation];
    
    return YES;
}

- (void)searchResultWithText:(NSString *)text{
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉首尾空格
    if(!text.length)return;
    
    if (self.repairType == YHRepairPartType) {
        [self partSearchDark:text];
    }
    
    if (self.repairType == YHRepairMaterialType) {
        [self partSearchDark:text];
    }
    
    if (self.repairType == YHRepairProjectType) {
        [self repairProjectSearch:text];
    }
    
}
#pragma mark - 配件模糊搜索/耗材模糊搜索合并 ---
- (void)partSearchDark:(NSString *)text{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    dic[@"type"] = self.repairType == YHRepairPartType ? @(1) : @(2);
    dic[@"keyword"] = text;
    dic[@"brand_id"] = self.baseInfo.carBrandId.length ? @(self.baseInfo.carBrandId.intValue) : @(0);
    dic[@"line_id"] = self.baseInfo.carLineId.length ? @(self.baseInfo.carLineId.intValue) : @(0);
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] searchNewPartInfo:[YHTools getAccessToken] keys:dic onComplete:^(NSDictionary *info){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
//            NSDictionary *data = info[@"data"];
//            NSArray *list = data[@"list"];
//            NSMutableArray *searchPartArr = [NSMutableArray array];
//            [searchPartArr addObjectsFromArray:list];
            
            self.status = YHRepairStatusShowSearchResult;
            self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:info[@"data"][@"list"]];
            [self.listTableView reloadData];
            self.sectionH = 0;
            [self searchNoResult];
            
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
#pragma mark - 配件精准搜索 ---
//- (void)partSearcheExact:(NSString *)text{
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getPartsWithExactWay:[YHTools getAccessToken] partName:text brandId:[self.baseInfo.carBrandId intValue] lineId:[self.baseInfo.carLineId intValue] car_cc:self.baseInfo.carCc carYear:[self.baseInfo.carYear intValue] onComplete:^(NSDictionary *info) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
//        if ([code isEqualToString:@"20000"]) {
//            NSDictionary *data = info[@"data"];
//
//            if(!data.allKeys.count){
//                 [MBProgressHUD showError:@"暂未找到此项,请更换名称重试!"];
//                return;
//            }
//            if (![self.finalSelectArr containsObject:data]) {
//                [self.finalSelectArr addObject:data];
//            }
//            self.status = YHRepairStatusShowFinalSelectResult;
//            self.resultArr = [NSMutableArray array];
//            self.resultArr = [NSMutableArray arrayWithArray:self.finalSelectArr];
//            [self.listTableView reloadData];
//            [self.submitBtn setTitle:@"设置完毕" forState:UIControlStateNormal];
//            self.submitBtn.hidden = NO;
//        }else{
//
//            [MBProgressHUD showError:info[@"msg"]];
//        }
//
//    } onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
//
//}

#pragma mark - 耗材模糊搜索 ---
//- (void)consumableSearchDark:(NSString *)text{
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getConsumableWithDarkWay:[YHTools getAccessToken] itemName:text onComplete:^(NSDictionary *info) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
//        if ([code isEqualToString:@"20000"]) {
//            NSDictionary *data = info[@"data"];
//            NSArray *list = data[@"list"];
//            self.status = YHRepairStatusShowSearchResult;
//            self.sectionH = 0;
//            self.resultArr = [NSMutableArray array];
//            [self.resultArr addObjectsFromArray:list];
//            [self.listTableView reloadData];
//            [self searchNoResult];
//        }else{
//            [MBProgressHUD showError:info[@"msg"]];
//        }
//
//    } onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
//
//}

#pragma mark - 维修项目模糊搜索 ---
- (void)repairProjectSearch:(NSString *)text{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str = IsEmptyStr(self.baseInfo.carCc) ? self.base_info.car_cc : self.baseInfo.carCc;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getRepairProjectWithDark:[YHTools getAccessToken] itemName:text car_cc:str onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            //            NSDictionary *data = info[@"data"];
            //            NSArray *list = data[@"list"];
            //            NSMutableArray *searchPartArr = [NSMutableArray array];
            //            [searchPartArr addObjectsFromArray:list];
            
            self.status = YHRepairStatusShowSearchResult;
            self.resultArr = [partSearchModel mj_objectArrayWithKeyValuesArray:info[@"data"][@"list"]];
            [self.listTableView reloadData];
            self.sectionH = 0;
            [self searchNoResult];
            
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
             [self.listTableView reloadData];
               self.sectionH = 0;
               [self searchNoResult];
        }
    }];
}

- (void)searchNoResult{
    
    if (self.resultArr.count) {
        self.noSearchResultL.hidden = YES;
        self.listTableView.hidden = NO;
        
        [self.submitBtn setTitle:@"设置完毕" forState:UIControlStateNormal];
        
//        self.submitBtn.hidden = YES;
        
//        self.submitBtn.hidden = self.status == YHRepairStatusShowLocalRecord
        
        return;
    }
    
    
    if(IsEmptyStr(self.searchTft.text))return;
    
    NSString *key = [NSString stringWithFormat:@"%ld",self.repairType];
    NSString *text = @{@"0":@"新增为配件",@"1":@"新增为耗材",@"2":@"新增为维修项目"}[key];
    [self.submitBtn setTitle:text forState:UIControlStateNormal];
    self.submitBtn.hidden = NO;
    NSString *errorText = @{@"0":[NSString stringWithFormat:@"没有搜索到“%@”配件",self.searchTft.text],@"1":[NSString stringWithFormat:@"没有搜索到“%@”耗材",self.searchTft.text],@"2":[NSString stringWithFormat:@"没有搜索到“%@”维修项目",self.searchTft.text]}[key];
    self.noSearchResultL.text = errorText;
    self.noSearchResultL.hidden = NO;
    self.listTableView.hidden = YES;
    self.resultArr = [NSMutableArray array];
}

@end
