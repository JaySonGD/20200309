//
//  YHAddProjectController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHAddProjectController.h"

#import "YHCommon.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHProjectCell.h"
NSString *const notificationOptionSel = @"YHNotificationOptionSel";
@interface YHAddProjectController ()
- (IBAction)addAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *okB;
@property (weak, nonatomic) IBOutlet UITextField *projectNameFT;
@property (weak, nonatomic) IBOutlet UIButton *decsB;
- (IBAction)decsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *decsL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *valueL;
@property (weak, nonatomic) IBOutlet UITextField *nameFT;
@property (weak, nonatomic) IBOutlet UITextField *valueFT;
@property (weak, nonatomic) IBOutlet UIView *valueBox;

@property (weak, nonatomic) IBOutlet UIView *valueLine2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionTopLC;
@property (nonatomic) NSInteger selIndex;
@property (weak, nonatomic) IBOutlet UITextField *valueLine2FT;
@property (strong, nonatomic) IBOutlet UIPickerView *valueLine1PV;
@property (strong, nonatomic) IBOutlet UIPickerView *valueLine2PV;
@property (nonatomic)NSInteger pickerSel;
@property (weak, nonatomic) IBOutlet UILabel *value1FL;
@property (strong, nonatomic)NSString *otherId;
@end

@implementation YHAddProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @[@"添加细检项目",
                   @"添加维修项目",
                   @"添加配件/耗材",
                   @"新建项目"][_model];
    _valueBox.hidden = (_model == YHAddProjectActionSel) || (_model == YHAddProjectRepairItem);
    _tableView.hidden = !(_model == YHAddProjectActionSel);
    _valueLine2.hidden = (_model == YHAddProjectRepairItem) || (_model == YHAddProjectDepth);
    _optionTopLC.constant = ((_model == YHAddProjectActionSel)? (0) : (58));
    _selIndex = -1;
    _value1FL.text = ((_model == YHAddProjectDepth)? (@"单位") : (@"类型"));
    _valueFT.placeholder = ((_model == YHAddProjectDepth)? (@"请输入单位") : (@"请选择类型"));
    if (_model != YHAddProjectDepth) {
        [self initInput:_valueFT withInputView:_valueLine1PV target:self action:@selector(confirmValue1:)];
        [self initInput:_valueLine2FT withInputView:_valueLine2PV target:self action:@selector(confirmValue2:)];
    }
    
    [self getOtherSysClassId];
}
- (void)confirmValue1:(id)obj{
    //滑动收起键盘
    [[self view] endEditing:YES];
    _valueFT.text = [self dataSourceType][_pickerSel];
    _valueLine2.hidden = ([_valueFT.text isEqualToString:@"耗材"]);
}

- (void)confirmValue2:(id)obj{
    //滑动收起键盘
    [[self view] endEditing:YES];
    _valueLine2FT.text = [self dataSourceCategory][_pickerSel];
}

#pragma mark - UIPickerView data source
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _valueLine1PV) {
        return [self dataSourceType].count;
    }
    return [self dataSourceCategory].count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _valueLine1PV) {
        return [self dataSourceType][row];
    }else{
        return [self dataSourceCategory][row];
    }
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
    _pickerSel = row;
}


- (NSArray*)dataSourceCategory{
    return @[@"品牌（OEM）",@"原厂件",@"副厂件",@"二手件"];
}

- (NSArray*)dataSourceType{
    return @[@"配件", @"耗材"];
}

- (NSString*)getCategoryKeyByName:(NSString*)name{
    NSString *category = @{@"品牌（OEM）" : @"1",@"原厂件" : @"2",@"副厂件" : @"3",@"二手件" : @"4"}[name];
    if (!category) {
        category  = @"0";
    }
    return category;
}

- (NSString*)getTypeKeyByName:(NSString*)name{
    return @{@"配件" : @"1", @"耗材" : @"2"}[name];
}

- (IBAction)addAction:(id)sender {
    if (_model == YHAddProjectActionSel) {
        if (_selIndex == -1) {
            [MBProgressHUD showError:@"请选择操作"];
            return;
        }
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationOptionSel
         object:Nil
         userInfo:@{@"index" : @(_selIndex)}];
        [self popViewController:nil];
    }else  if (_model == YHAddProjectRepairItem) {
        
        if ([_nameFT.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请输入名称"];
            return;
        }
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         addRepairProject:[YHTools getAccessToken]
         repairProjectName:_nameFT.text
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showSuccess:@"添加成功" toView:weakSelf.navigationController.view];
                 [self popViewController:nil];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }else if (_model == YHAddProjectPart) {
        
        if ([_nameFT.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请输入名称"];
            return;
        }
        
        if ([_valueFT.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请选择类型"];
            return;
        }
        if ([_valueLine2FT.text isEqualToString:@""] && ![_valueFT.text isEqualToString:@"耗材"]) {
            [MBProgressHUD showError:@"请选择类别"];
            return;
        }
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         addParts:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         partsName:_nameFT.text
         type:[self getTypeKeyByName:_valueFT.text]
         partsTypeId:[self getCategoryKeyByName:_valueLine2FT.text]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showSuccess:@"添加成功" toView:weakSelf.navigationController.view];
                 [self popViewController:nil];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
             YHLogERROR(@"");
         }];
    }else{
        if ([_nameFT.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请输入名称"];
            return;
        }
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         addShopCheckReportDepthItem:[YHTools getAccessToken]
         projectName:_nameFT.text
         unit:_valueFT.text
         sysClassId:_otherId
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showSuccess:@"添加成功" toView:weakSelf.navigationController.view];
                 [self popViewController:nil];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

- (void)getOtherSysClassId{
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getSysClassListOnComplete:^(NSDictionary *info) {
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSArray *data = info[@"data"];
             for (NSDictionary *sysInfo  in data) {
                 if ([sysInfo[@"className"] isEqualToString:@"其他"]) {
                     weakSelf.otherId = sysInfo[@"id"];
                     break;
                 }
             }
         }else{
                 YHLogERROR(@"");
         }
     } onError:^(NSError *error) {
         YHLogERROR(@"");
     }];
}

- (IBAction)decsAction:(id)sender {
}

#pragma mark - Table view data source ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _repairActionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadData:_repairActionData[indexPath.row] isRepair:NO isSel:_selIndex == indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selIndex = indexPath.row;
    [_tableView reloadData];
}

@end
