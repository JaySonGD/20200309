//
//  YHDepthEditeController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/2.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHDepthEditeController.h"
#import "YHDepthEditCell.h"
#import "YHCommon.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHProjectSelController.h"
#import "YHSuccessController.h"
#import "YHProjectAddCell.h"
#import "YHAddProjectController.h"
#import "UIAlertView+Block.h"
#import "YHDateTimeCell.h"

#import "UIViewController+sucessJump.h"

extern NSString *const notificationProjectDel;
extern NSString *const notificationProjectAdd;
extern NSString *const notificationOptionSel;
extern NSString *const notificationDateTimeSel;
NSString *const notificationRepairModelAddRepair = @"YHNotificationRepairModelAddRepair";
NSString *const notificationDepthAdd = @"YHNotificationDepthAdd";
@interface YHDepthEditeController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *repairTitle;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *okB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLC;
@property (weak, nonatomic) IBOutlet UIView *tablLeftLine;
@property (weak, nonatomic) IBOutlet UIView *talbRightLine;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceL;
@property (weak, nonatomic) IBOutlet UIView *dateTimeBox;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePK;

- (IBAction)partTypeSelActions:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tablLeftAction:(id)sender;
- (IBAction)tablRightBAction:(id)sender;
@property (nonatomic)BOOL isRepairModel;//是维修方式还是耗材
@property (strong, nonatomic) IBOutlet UIPickerView *partTypePK;
@property (nonatomic)NSUInteger partTypeRow;
@property (nonatomic)NSUInteger partTypeRowSel;
@property (nonatomic)NSInteger index;
@property (weak, nonatomic) IBOutlet UIView *partTypeSelBoxV;
@property (weak, nonatomic) IBOutlet UITextView *programmeTV;

@end

@implementation YHDepthEditeController
@dynamic orderInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isRepairModel = YES;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationProjectDel:) name:notificationProjectDel object:nil];
    
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationProjectAdd:) name:notificationProjectAdd object:nil];
    
    [center addObserver:self selector:@selector(notificationOptionSel:) name:notificationOptionSel object:nil];
    
    [center addObserver:self selector:@selector(notificationDateTimeSel:) name:notificationDateTimeSel object:nil];
    
    
    _dateTimePK.minimumDate = [NSDate date];
    if (!_dataSource) {
        self.dataSource = [@[] mutableCopy];
        self.dataSourceSupplies = [@[] mutableCopy];
    }
    
    _topLC.constant = ((_isRepair)? (((_isRepairPrice)? (60) : (60))) : (0));
    if (!_isRepair) {
        [_topView removeFromSuperview];
    }
    //    _okB.backgroundColor = ((_dataSource.count)? (YHLineColor) : (YHNaviColor));
    _okB.backgroundColor = YHNaviColor;
    _repairTitle.text = _repairStr;
    self.title = ((_isRepair)? (@"编辑维修方式") : (@"编辑细检项目"));
    [self tablLeftAction:nil];
    self.index = -1;
    _programmeTV.text = _schemeContent;
}

- (void)notificationOptionSel:(NSNotification*)notice{
    if (_index < 0  || _index >= _dataSource.count) {
        return;
    }
    NSNumber *index = notice.userInfo[@"index"];
    NSMutableDictionary *item =  _dataSource[_index];
    [item setObject:index forKey:@"sel"];
    [_tableView reloadData];
}

- (void)notificationProjectDel:(NSNotification*)notice{
    if (_isRepair && !_isRepairModel) {
        
        NSNumber *index = notice.userInfo[@"index"];
        [_dataSourceSupplies removeObjectAtIndex:index.integerValue];
    }else{
        NSNumber *index = notice.userInfo[@"index"];
        [_dataSource removeObjectAtIndex:index.integerValue];
    }
    //    _okB.backgroundColor = (((_dataSource.count) || (_dataSourceSupplies.count))? (YHNaviColor) : (YHLineColor));
    [_tableView reloadData];
}

- (void)notificationProjectAdd:(NSNotification*)notice{
    NSArray *items = notice.userInfo[@"value"];
    
    if (_isRepair && !_isRepairModel) {
        _dataSourceSupplies = [[_dataSourceSupplies arrayByAddingObjectsFromArray:items] mutableCopy];
    }else{
        _dataSource = [[_dataSource arrayByAddingObjectsFromArray:items] mutableCopy];
    }
    //    _okB.backgroundColor = (((_dataSource.count) || (_dataSourceSupplies.count))? (YHNaviColor) : (YHLineColor));
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    YHProjectSelController *controller = segue.destinationViewController;
    controller.orderInfo = self.orderInfo;
    //    controller.isRepair = _isRepair;
    //    controller.isRepairModel = _isRepairModel;
    
    controller.model = ((_isRepair)? (((_isRepairModel)? (YHAddProjectRepairItem) : (YHAddProjectPart))) : (YHAddProjectDepth));
    controller.repairActionData = self.repairActionData;
    controller.carBaseInfo = _carBaseInfo;
    controller.isRepairPrice = _isRepairPrice;
    self.index = -1;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //        _okB.backgroundColor = (([_repairStr isEqualToString:textField.text])? (YHLineColor) : (YHNaviColor));
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isRepair && !_isRepairModel) {
        return _dataSourceSupplies.count + ((_cloudRepair)? (0) : (1)) + ((_isRepairPrice)? (1) : (0));
    }else{
        return _dataSource.count + ((_cloudRepair)? (0) : (1)) + ((_isRepairPrice)? (1) : (0));
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_cloudRepair && ((!_isRepair  && _dataSource.count == indexPath.row) || ((_isRepair && _isRepairModel) && _dataSource.count == indexPath.row) || ((_isRepair && !_isRepairModel) && _dataSourceSupplies.count == indexPath.row))) {
        YHProjectAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSString *str;
            if (_isRepair) {
                if (_isRepairModel) {
                    str = @"新增维修项目";
                }else{
                    str = @"新增配件耗材";
                }
            }else{
                str = @"新增细检项目";
            }
            [cell loadDataSource:str];
            return cell;
        }
    
    if (_isRepairPrice
        && ((_isRepairModel)? (_dataSource.count + 1 == indexPath.row ) : (_dataSourceSupplies.count + 1 == indexPath.row)) ) {
        YHDateTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDate" forIndexPath:indexPath];
        [cell loadDateStr:_dateTime];
        return cell;
    }
    YHDepthEditCell *cell = [tableView dequeueReusableCellWithIdentifier:((_isRepair)? (@"repairCell") : (@"editCell")) forIndexPath:indexPath];
    NSMutableDictionary *item;
    cell.repairActionData= _repairActionData;
    if (_isRepair && !_isRepairModel) {
        item = _dataSourceSupplies[indexPath.row];
    }else{
        item = _dataSource[indexPath.row];
    }
    [cell loadDatasource:item index:indexPath.row isRepair:_isRepair isRepairModel:_isRepairModel isCloud:_cloudRepair isRepairPrice:_isRepairPrice];
    return cell;
}


- (IBAction)selComAction:(id)sender {
    NSDate *selected = [_dateTimePK date];
    self.dateTime =  [YHTools stringFromDate:selected byFormatter:@"yyyy-MM-dd HH:mm"];
    self.dateTimeBox.hidden = YES;
    [self.tableView reloadData];
}

- (IBAction)cancelAction:(id)sender {
    
    self.dateTimeBox.hidden = YES;
}

- (IBAction)changeAction:(UIButton*)sender {
    if (_cloudRepair) {
        return;
    }
    self.index = sender.tag;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHAddProjectController *controller = [board instantiateViewControllerWithIdentifier:@"YHAddProjectController"];
    //    controller.isRepair = _isRepair;
    //    controller.isRepairOption = YES;
    //    controller.isRepairModel = _isRepairModel;
    controller.model = YHAddProjectActionSel;
    controller.repairActionData = self.repairActionData;
    controller.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)notificationDateTimeSel:(NSNotification*)notice{
    self.dateTimeBox.hidden = NO;
}


//http://192.168.1.135/wx/order_details.html?orgId=E33619F027084B2AB4AA3D4333C41C18&token=a87d0fddde4694145124357838e063be&id=986&status=ios

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isRepair && !_isRepairModel) {
        if (_dataSourceSupplies.count == indexPath.row) {
            return 100.;
        }
    }else{
        if (_dataSource.count == indexPath.row) {
            return 100.;
        }
    }
    if (_isRepairPrice
        && ((_isRepairModel)? (_dataSource.count + 1 == indexPath.row ) : (_dataSourceSupplies.count + 1 == indexPath.row)) ) {
        return 70;
    }

    return ((_isRepair)? (((_isRepairModel)? (((_isRepairPrice)? (135) : (90))) : (327 - 65))) : (160.));
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ((_isRepair)? (100) : (0));
}

- (IBAction)tablLeftAction:(id)sender {
    _tablLeftLine.backgroundColor = YHNaviColor;
    _talbRightLine.backgroundColor = YHCellColor;
    _isRepairModel = YES;
    
    [_tableView reloadData];
}

- (IBAction)tablRightBAction:(id)sender {
    _tablLeftLine.backgroundColor = YHCellColor;
    _talbRightLine.backgroundColor = YHNaviColor;
    _isRepairModel = NO;
    
    [_tableView reloadData];
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
    if (_isRepairPrice && !_partTypeSelBoxV.isHidden) {
        NSDictionary *partInfo = _dataSourceSupplies[_partTypeRow];
        NSArray *modelNumberList = partInfo[@"modelNumberList"];
        return modelNumberList.count;
    }
    return 0;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (_isRepairPrice && !_partTypeSelBoxV.isHidden) {
        NSDictionary *partInfo = _dataSourceSupplies[_partTypeRow];
        NSArray *modelNumberList = partInfo[@"modelNumberList"];
        NSDictionary *modelNumber = modelNumberList[row];
        return modelNumber[@"modelNumber"];
    }
    return @"";
    
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    _partTypeRowSel = row;
}

- (IBAction)okAction:(id)sender {
    
    if (_isRepair) {
        if (_dataSource.count == 0 && _dataSourceSupplies.count == 0) {
            [MBProgressHUD showError:@"请添加项目"];
            return;
        }
        //        if ( _dataSourceSupplies.count == 0) {
        //            [MBProgressHUD showError:@"请添加配件"];
        //            return;
        //        }
        for (NSDictionary *item in _dataSourceSupplies) {
            NSNumber *scalar = item[@"scalar"];
            if (!scalar || scalar.floatValue <= 0) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"请输入\"""%@\"""数量", item[@"partsName"]]];
                return;
            }
        }
        
        NSMutableDictionary *info = [@{@"dataSourceSupplies" : _dataSourceSupplies,
                                       @"dataSourceModel" : _dataSource,
                                       @"repairStr": _repairTitle.text,
                                       @"repairEdit" : @(_repairEdit),
                                       @"repairIndex" : @(_repairIndex)
                                       }mutableCopy];
        if (_warrantyDay) {
            [info setObject:@{@"warrantyDay" : _warrantyDay} forKey:@"warrantyTime"];
        }
        
        if (_dateTime) {
            [info setObject:@{@"giveBackTime" : _dateTime} forKey:@"giveBack"];
        }
        if (![_programmeTV.text isEqualToString:@""]) {
            [info setObject:@{@"schemeContent" : _programmeTV.text} forKey:@"scheme"];
        }
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationRepairModelAddRepair
         object:Nil
         userInfo:info];
        [self popViewController:nil];
        
    }else{
        if (_dataSource.count == 0 ) {
            [MBProgressHUD showError:@"请添加细检项目"];
            return;
        }
        if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudMakeDepth"]) {
            
            for (NSMutableDictionary *item in _dataSource) {
                [item setObject:item[@"id"] forKey:@"projectId"];
            }
            [MBProgressHUD showMessage:@"提交中..." toView:self.view];
            __weak __typeof__(self) weakSelf = self;
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveWriteDepthToCloud:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             requestData:_dataSource
             isPrice:NO
             onComplete:^(NSDictionary *info) {
                 
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                     YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                     NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                     [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                     controller.orderInfo = billStatus;
//                     controller.titleStr = @"提交成功";
//                     [self.navigationController pushViewController:controller animated:YES];
                     [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 }else{
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLogERROR(@"");
                         [weakSelf showErrorInfo:info];
                     }
                 }
                 
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];;
             }];
        }else{
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationDepthAdd
             object:Nil
             userInfo:@{@"dataSource" : _dataSource
                        }];
            [self popViewController:nil];
        }
    }
}

- (void)updataPartInfo:(NSUInteger)index{
     __block NSMutableDictionary *partInfo =  _dataSourceSupplies[index];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     searchPartInfo:[YHTools getAccessToken]
     keys:@{
        @"partsName" : partInfo[@"partsName"]
            }
     billId:self.orderInfo[@"id"]
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             NSArray *partsList = data[@"partsNameList"];
             if (partsList && partsList.count != 0) {
                 [partInfo addEntriesFromDictionary:partsList[0]];
                 [weakSelf.tableView reloadData];
             }
             
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                 }
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

- (IBAction)partTypeConfirmedAction:(id)sender {
    
    _partTypeSelBoxV.hidden = YES;
    NSMutableDictionary *partInfo = _dataSourceSupplies[_partTypeRow];
    NSArray *modelNumberList = partInfo[@"modelNumberList"];
    
    if (modelNumberList.count == 0 || modelNumberList.count <=  _partTypeRowSel) {
        return;
    }
    NSDictionary *modelNumber = modelNumberList[_partTypeRowSel];
    
    [partInfo setObject:modelNumber[@"modelNumber"] forKey:@"modelNumber"];
//    [partInfo setObject:modelNumber[@"partsId"] forKey:@"partsId"];
    [self updataPartInfo:_partTypeRow];
//    [_tableView reloadData];
}

- (IBAction)partTypeSelActions:(UIButton*)button {
    _partTypeRow = button.tag;
    _partTypeSelBoxV.hidden = NO;
    [_partTypePK reloadAllComponents];
    
}

- (IBAction)partTypeCancelAction:(id)sender {
    _partTypeSelBoxV.hidden = YES;
}
@end
