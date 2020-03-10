//
//  YHInitialInspectionController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//


#import "YHInitialInspectionController.h"
#import "YHWenXunCell.h"
#import "YHCommon.h"
#import "YHOliCell.h"

#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHOrderListController.h"
#import "YHOrderDetailController.h"
#import "YHSuccessController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHTools.h"
#import "YHVideosController.h"
#import "YHCarSelAllCell.h"
#import "NSMutableArray+YH.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "UIAlertController+Blocks.h"

// van_mr
#import "YHAddPictureContentView.h"
#import "YHFourWheelsHeadView.h"
#import "YHCarPhotoService.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "TTZUpLoadService.h"
#import "NSString+add.h"

#import "YHStoreTool.h"

// 上传图片类
#import "YHBackgroundService.h"
#import "ApiService.h"

#import "YHInitialInspectionSysController.h"
#import "UIViewController+sucessJump.h"

extern NSString *const notificationOrderListChange;
extern NSString *const notificationOrderProjectSel;
extern NSString *const notificationProjectAddItem;
extern NSString *const notificationProjectCarSelAll;
extern NSString *const notificationFault;
extern NSString *const notificationOutletTemperature;
extern NSString *const notificationProjectFaultCode;
extern NSString *const notificationEngineWaterTProjectList;


@interface YHInitialInspectionController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rightB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)saveInfoAction:(id)sender;
- (IBAction)comfirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBoxHeightLC;
@property (weak, nonatomic) IBOutlet UIView *bottomBox;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *timeoutL;
@property (nonatomic, weak)NSTimer *timer;
@property (nonatomic)NSInteger times;
@property (strong, nonatomic)NSMutableArray *depthProjectVal;
@property (strong, nonatomic) IBOutlet UIPickerView *selPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSUInteger projectSelectRow;
- (IBAction)selComAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selBox;

@property (weak, nonatomic)NSMutableDictionary *selProjectInfo;
@property (strong, nonatomic)NSArray *selProjects;
@property (weak, nonatomic) IBOutlet UIButton *circuitB;
- (IBAction)carSelAllAction:(id)sender;
/** 基本字典数据 */
@property (nonatomic, copy) NSDictionary *basicInfo;

@property (nonatomic)YHCarAll state;

/** 刹车距离项 */
@property (nonatomic, strong) NSDictionary *brakeItem;

@property(nonatomic,weak) YHFourWheelsHeadView *headerView;

@property (nonatomic, assign)BOOL isBackBySide;
/** 记录已选择的类似泄露展开项 */
@property (nonatomic, strong) NSMutableArray *leakReportArr;

@end

@implementation YHInitialInspectionController
@dynamic orderInfo;

- (NSMutableArray *)leakReportArr{
    if (!_leakReportArr) {
        _leakReportArr = [NSMutableArray array];
    }
    return _leakReportArr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.delegate = self;
    
    if (!_isInitialInspectionSys) {
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(notificationOrderProjectSel:) name:notificationOrderProjectSel object:nil];
        [center addObserver:self selector:@selector(notificationFault:) name:notificationFault object:nil];
        [center addObserver:self selector:@selector(notificationProjectAddItem:) name:notificationProjectAddItem object:nil];
        [center addObserver:self selector:@selector(notificationProjectAddItem:) name:notificationProjectCarSelAll object:nil];
        [center addObserver:self selector:@selector(notificationOutletTemperature:) name:notificationOutletTemperature object:nil];
        [center addObserver:self selector:@selector(notificationProjectFaultCode:) name:notificationProjectFaultCode object:nil];
        [center addObserver:self selector:@selector(notificationEngineWaterTProjectList:) name:notificationEngineWaterTProjectList object:nil];
    }
    
    NSDate* minDate = [YHTools  dateFromString:@"1970-07-01" byFormatter:@"yyyy-MM-dd"];
    //    NSDate* maxDate = [YHTools  dateFromString:@"2020-01-01" byFormatter:@"yyyy-MM-dd"];
    
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = [NSDate date];
    
    _state = YHCarAllCenter;
    if (!_sysAr) {
        self.sysAr = [@[]mutableCopy];
        NSArray *sysClass = _sysData[@"sysClass"];
        for (NSDictionary *item in sysClass) {
            [_sysAr addObject:[@{@"title" : item[@"className"],
                                 @"sysClassId" : item[@"id"],
                                 @"sel" : @1}mutableCopy]];
        }
        if (![self.orderInfo[@"billType"] isEqualToString:@"J"]) {
            [_sysAr insertObject:
             [@{@"title" : @"其他",
                @"sysClassId" : @"0",
                @"sel" : @1}mutableCopy] atIndex:0];
        }
    }
    
    // 设置tableViewHeader
    if (self.isHasPhoto && [self.titleStr isEqualToString:@"四轮"]) {
        
        // 获取billID
        NSDictionary *billInfo =  _sysData[@"pBillInfo"];
        self.billId = [billInfo[@"billId"] integerValue];
        
        // 获取code
        NSMutableArray *initialSurveyCheckProject = [_sysData[@"initialSurveyCheckProject"] mutableCopy];
        
        for (int i = 0; i<initialSurveyCheckProject.count; i++) {
            
            NSDictionary *dict = initialSurveyCheckProject[i];
            NSString *name =  dict[@"projectName"];
            if ([name isEqualToString:@"刹车距离(50km/h)"]) {
                self.code = dict[@"code"];
                self.brakeItem = dict;
                break;
            }
        }
        YHFourWheelsHeadView *headerView = [[YHFourWheelsHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, 157) billd:[NSString stringWithFormat:@"%ld",self.billId]];
        self.headerView = headerView;
        headerView.billID = [NSString stringWithFormat:@"%ld",self.billId];
        headerView.brakeDict = self.brakeItem;
        _tableView.tableHeaderView = headerView;
    }else{
        _tableView.tableHeaderView = nil;
    }
    
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]
        || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"matchInitialSurvey"]//云细检数值填写
        || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]//云细检数值填写
        ){
        
        [self cloudDepthDetailInit];
        
        self.title = @"录入细检数据";
    }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudDepthQuote"]){
        [self depthDataInit];
    }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"] || self.isHasPhoto){
        //        [self depthDataInit];
        if (!_isInitialInspectionSys) {
            _rightB.titleLabel.text = @"保存";
            [_rightB setTitle:@"保存" forState:UIControlStateNormal];
            self.title = self.titleStr;
            _bottomBoxHeightLC.constant = 0;//返回使用
            for (NSInteger i = 0; i < _sysAr.count; i++) {
                [self checkCarAllInfo:i];
            }
            [self dataBackup];
        }else{
            [self dataInit];
        }
    }else{
        [self dataInit];
    }
    
    if (_is_circuitry.longValue == 1) {
        _topLC.constant = 60;
    }
    _circuitB.hidden = (_is_circuitry.longValue != 1);//电路图
    
    _bottomBox.layer.borderWidth = 1;
    _bottomBox.layer.borderColor = YHLineColor.CGColor;
    
    if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"] || self.isHasPhoto)) {
        _rightB.hidden = _isInitialInspectionSys;
    }else{
        _rightB.hidden = !((([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"A"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"])));
    }
    
    if(self.isHasPhoto){
        [self.sysAr enumerateObjectsUsingBlock:^(NSMutableDictionary  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *subSys = [obj valueForKey:@"subSys"];
            
            [subSys enumerateObjectsUsingBlock:^(NSMutableDictionary  * sub, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *billId = [self.orderInfo valueForKey:@"id"];//[[_sysData valueForKey:@"pBillInfo"] valueForKey:@"billId"];
                NSString *code = [sub valueForKey:@"code"];
                
                //                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:5];
                //                TTZDBModel *defaultModel = [TTZDBModel new];
                //                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                //                [photos addObject:defaultModel];
                sub[@"photo"] = [self dbImagesWithBillId:billId imageCode:code];
                sub[@"billId"] = billId;//[[_sysData valueForKey:@"pBillInfo"] valueForKey:@"billId"];
                
            }];
            
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[YHInitialInspectionSysController class]]) {
        if ((self.isInitialInspectionSys == NO) && ([self.orderInfo[@"billType"] isEqualToString:@"J001"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"])) {
            self.isBackBySide = YES;
            [self endBill:nil];
            return;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableArray *)dbImagesWithBillId:(NSString *)billId
                             imageCode:(NSString *)code
{
    NSMutableArray *_dbImages = [NSMutableArray array];
    NSArray <TTZDBModel *> *dbImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",billId,code]];
    
    if (dbImages.count) {
        [_dbImages addObjectsFromArray:dbImages];
        if(dbImages.count <5){
            TTZDBModel *defaultModel = [TTZDBModel new];
            defaultModel.image = [UIImage imageNamed:@"otherAdd"];
            [_dbImages addObject:defaultModel];
        }
    }else{
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        [_dbImages addObject:defaultModel];
    }
    
    return _dbImages;
}

- (void)dataBackup{    //深度备份数据，
    for (NSMutableDictionary *item in _sysAr) {
        for (NSMutableDictionary *subItem in item[@"subSys"]) {
            if (subItem[@"sel"]) {
                [subItem setObject:subItem[@"sel"] forKey:@"selB"];
            }
            if (subItem[@"value"]) {
                [subItem setObject:subItem[@"value"] forKey:@"valueB"];
            }
        }
        if (item[@"state"]) {
            [item setObject:item[@"state"] forKey:@"stateB"];
        }
    }
}

- (void)dataBackupRecovery{    //备份数据恢复
    for (NSMutableDictionary *item in _sysAr) {
        for (NSMutableDictionary *subItem in item[@"subSys"]) {
            if (subItem[@"selB"]) {
                [subItem setObject:subItem[@"selB"] forKey:@"sel"];
                [subItem removeObjectForKey:@"selB"];
            }else{
                [subItem removeObjectForKey:@"sel"];
            }
            if (subItem[@"valueB"]) {
                [subItem setObject:subItem[@"valueB"] forKey:@"value"];
                [subItem removeObjectForKey:@"valueB"];
            }else{
                [subItem removeObjectForKey:@"value"];
            }
        }
        
        if (item[@"stateB"]) {
            [item setObject:item[@"stateB"] forKey:@"state"];
            [item removeObjectForKey:@"stateB"];
        }else{
            [item removeObjectForKey:@"state"];
        }
    }
}

- (void)popController
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"当前页面有数据未进行保存，是否保存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[YHStoreTool ShareStoreTool] setDelayCareLeakOptionData:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super popViewController:nil];
        });
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //JNS(小虎)全车检测:J001;  JNS(小虎)安检:J002
        if ([self.orderInfo[@"billType"] isEqualToString:@"J001"] || [self.orderInfo[@"billType"] isEqualToString:@"J002"]) {
            [self endBill:nil];
        }else{
            [super popViewController:nil];
        }
    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:confirmAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - ----------------------------右侧保存按钮点击事件------------------------------
- (void)endBill:(id)sender
{
    // 退出键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YHwenXun_registerKeys" object:nil];
    
    if (_isInitialInspectionSys || ([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"])) {
        [super endBill:sender];
        return;
    }
    
    // 保存缓存数据
    if ([self.orderInfo[@"billType"] isEqualToString:@"J001"] || self.isHasPhoto) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[YHTools getAccessToken] forKey:@"token"];
        [param setValue:self.orderInfo[@"id"] forKey:@"billId"];
        
        NSMutableDictionary *val = [NSMutableDictionary dictionary];
        [val setValue:self.basicInfo forKey:@"baseInfo"];
        NSArray *requareArr = [self getInitialSurveyCheckProject];
        [val setValue:requareArr forKey:@"initialSurveyProjectVal"];
        [param setValue:val forKey:@"val"];
        

        [[YHNetworkPHPManager sharedYHNetworkPHPManager] temporaryDepositBasicInformationWithDictionary:param isHelp:YES onComplete:^(NSDictionary *info) {
            NSLog(@"info = %@",info);
        } onError:^(NSError *error) {
            if (error) {
                NSLog(@"error = %@",error);
            }
        }];
        
        if (self.isBackBySide == NO) {
            [super popViewController:nil];
        }
        return;
    }
    
    if (self.isBackBySide == NO) {
        [super popViewController:nil];
    }
}

#pragma mark - -----------------------------------返回监听-----------------------------------------
- (void)popViewController:(id)sender
{
    
//    if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"]) && !_isInitialInspectionSys) {
//        [self dataBackupRecovery];
//    }
    
    if (self.isInitialInspectionSys == NO) {
        [self popController];
        return;
    }
    
    [super popViewController:sender];
}

#pragma mark - 获取要提交的各项数据 ----
- (NSArray *)getInitialSurveyCheckProject
{
    // 取出缓存数据
    NSArray *saveArry = [YHStoreTool ShareStoreTool].orderDetailArr;
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:saveArry];
    
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
    NSMutableArray *projectVal = [NSMutableArray array];
  
    for (int i = 0; i<_sysAr.count; i++) {

        NSDictionary *sysItem = _sysAr[i];
        NSArray *subSys = sysItem[@"subSys"];
        NSDictionary *subItem = [subSys firstObject];
        [itemDict setValue:subItem[@"className"] forKey:@"sysId"];
        [itemDict setObject:@"back" forKey:@"saveType"];
        
        for (int j = 0; j<subSys.count; j++) {
            NSDictionary *item = subSys[j];
            
            NSDictionary *intervalRange = item[@"intervalRange"];
            NSString *intervalType = item[@"intervalType"];
                // 选择项
                if ([intervalType isEqualToString:@"radio"]/*radio*/) {
                    NSArray *list = intervalRange[@"list"];
                    if (!item[@"sel"]) {
                        continue;
                    }
                    NSInteger sel = [item[@"sel"] integerValue];
                    NSDictionary *listItem = list[sel];
                    
                    NSMutableDictionary *valDict = [NSMutableDictionary dictionary];
                    [valDict setValue:item[@"id"] forKey:@"id"];
                    [valDict setValue:listItem[@"name"] forKey:@"projectVal"];
                    [valDict setValue:item[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];
                    [projectVal addObject:valDict];
                    continue;
                }
                // 输入项
                 if ([intervalType isEqualToString:@"text"]/*text, int flaot*/) {
                    
                    NSMutableDictionary *valDict1 = [NSMutableDictionary dictionary];
                    [valDict1 setValue:item[@"id"] forKey:@"id"];
                    [valDict1 setValue:item[@"value"] forKey:@"projectVal"];
                    [valDict1 setValue:item[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];
                    [projectVal addObject:valDict1];
                     continue;
                }
                // addItem
                 if([intervalRange isKindOfClass:[NSString class]]
                         || (id)intervalRange == [NSNull null]
                         || [intervalType isEqualToString:@"gangedAjaxSelect"]
                         || [intervalType isEqualToString:@"sameIncrease"]
                         || [intervalType isEqualToString:@"form"]
                         || [intervalType isEqualToString:@"elecCodeForm"]
                         || [intervalType isEqualToString:@"gatherInputAdd"]){
                    
                     NSMutableDictionary *valDict2 = [NSMutableDictionary dictionary];
                     [valDict2 setValue:item[@"id"] forKey:@"id"];
                     [valDict2 setValue:item[@"addItems"] forKey:@"addItems"];
                     [valDict2 setValue:item[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];
                     [projectVal addObject:valDict2];
                     continue;
                }
        }

    }
    
        [itemDict setValue:projectVal forKey:@"projectVal"];
    
        NSArray *getArr = [self judgeIsContainArr:resultArr];
        BOOL isExist = [[getArr lastObject] boolValue]; // 是否已包含
    
        if (isExist) {
            NSInteger index = [[getArr firstObject] integerValue];
            [resultArr replaceObjectAtIndex:index withObject:itemDict];
        }else{
            [resultArr addObject:itemDict];
        }
    
      [[YHStoreTool ShareStoreTool] setOrderDetailArr:resultArr];
    
    return resultArr;
}

- (NSArray *)judgeIsContainArr:(NSArray *)arr{
    
    NSInteger index = 0;
    // 是否已存在
    BOOL isExist = NO;
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *resDict = arr[i];
        NSString *titel = resDict[@"sysId"];
        if ([titel isEqualToString:self.titleStr]) {
            index = i;
            isExist = YES;
            break;
        }
    }
    return @[[NSNumber numberWithInteger:index],[NSNumber numberWithBool:isExist]];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    _projectSelectRow = row;
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的单号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    NSDictionary *info =  _selProjects[row];
    return info[@"name"];
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return _selProjects.count;
}

- (IBAction)circuitAction:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
    controller.functionKey = YHFunctionIdCircuitDiagram;
    controller.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)notificationProjectAddItem:(NSNotification*)notice{
//    isRelate
    NSDictionary *info = notice.userInfo;
    NSNumber *index = info[@"index"];
    NSString *idStr = [NSString stringWithFormat:@"%@",info[@"id"]];
    NSString *projectName = info[@"projectName"];
    BOOL isSelect = [info[@"isSelect"] boolValue];
    // on == 1 ->点击了正常  on == 0 —>点击了异常 isSelect = YES ->当前点击的按钮处于选中状态
    NSInteger on = [[info valueForKey:@"on"] integerValue];
    BOOL isOpen = on == 0 && isSelect ? YES : NO;
    BOOL isRelate = [info[@"isRelate"] boolValue]; // 是否联动
    NSIndexPath *indexPath = info[@"indexPath"];
    if (isRelate) {
        if (isOpen) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:projectName forKey:@"projectName"];
            [dict setValue:indexPath forKey:@"indexPath"];
            [dict setValue:idStr forKey:@"id"];
            [self.leakReportArr addObject:dict];
        }else{
            int index = -1;
            for (int i = 0; i<self.leakReportArr.count; i++) {
                NSMutableDictionary *item = self.leakReportArr[i];
                if ([item[@"id"] isEqualToString:idStr]) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                [self.leakReportArr removeObjectAtIndex:index];
            }
        }
    }
    
    NSInteger row = ((index.integerValue & 0xffff) - on);
    
    NSMutableDictionary *itemInfo =  _sysAr[index.integerValue >> 16][@"subSys"][row];
    NSInteger depth = [[itemInfo valueForKey:@"depth"] integerValue];
    if (depth && depth < 3) {
        
        NSString *sel_value = [itemInfo valueForKey:@"sel_value"];
        NSNumber *sel = [itemInfo valueForKey:@"sel"];
        NSString *projectVal = sel_value? sel_value : sel? itemInfo[@"intervalRange"][@"list"][sel.integerValue][@"value"] : @"";
        
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationEngineWaterTProjectList
         object:Nil
         userInfo:@{@"projectVal" : projectVal ,@"projectId":itemInfo[@"id"],@"index":@(index.integerValue - on)}];
        
        return;
    }
    
    [self checkCarAllInfo:(index.unsignedIntValue) >> 16];
    NSDictionary *userInfo = notice.userInfo;
    //[self updataFault:userInfo[@"item"] section:0 isDel:YES];
    [self updataFault:userInfo section:0 isDel:YES];
    
}
- (void)notificationProjectFaultCode:(NSNotification *)noti{
    [self.tableView reloadData];
}

- (void)notificationEngineWaterTProjectList:(NSNotification *)noti{
    
    NSDictionary *userinfo = noti.userInfo;
    
    NSUInteger section = [userinfo[@"index"] integerValue] >> 16;
    NSUInteger row = [userinfo[@"index"] integerValue] & 0XFFFF;
    
    NSMutableDictionary *sysInfo = _sysAr[section];
    __block NSMutableArray *subSys = sysInfo[@"subSys"];
    NSMutableDictionary *itemInfo = subSys[row];
    NSInteger depth = [[itemInfo valueForKey:@"depth"] integerValue];
    
    //NSUInteger orginRow = [itemInfo valueForKey:@"orginRow"] ? [[itemInfo valueForKey:@"orginRow"] integerValue] : row;
    //NSUInteger orginRow = row;

    //NSMutableArray *mData = [itemInfo valueForKey:@"engineWaterTProjectList"];
    
    NSMutableArray *mData = [itemInfo valueForKey:@"childItem"];
    [mData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *mData1 = [obj valueForKey:@"childItem"];
        [mData1 enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mData2 = [obj1 valueForKey:@"childItem"];
            [mData2 enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *mData3 = [obj2 valueForKey:@"childItem"];
                [self array:subSys  del:mData3];
            }];
            [self array:subSys  del:mData2];
        }];
        [self array:subSys  del:mData1];

    }];
    [self array:subSys  del:mData];
    [itemInfo removeObjectForKey:@"childItem"];
    
    NSString *billId = self.orderInfo[@"id"];
    NSString *projectId = userinfo[@"projectId"];
    NSString *projectVal = userinfo[@"projectVal"];
    __weak typeof(self) weakSelf = self;
    [[YHCarPhotoService new] getEngineWaterTProjectListByBillId:billId
                                                      projectId:projectId
                                                     projectVal:projectVal
                                                        success:^(NSArray *lists) {
                                                            NSLog(@"%s", __func__);
                                                            
                                                            
                                                            NSMutableArray *mData = [@[]mutableCopy];
                                                            for (NSDictionary *item in lists) {
                                                                NSMutableDictionary *itemData = [item mutableCopy];
                                                                itemData[@"depth"] = @(depth + 1);
                                                                //itemData[@"orginRow"] = @(orginRow);
                                                                [mData addObject:itemData];
                                                            }
                                                            itemInfo[@"childItem"] = mData;

                                                            
                                                            
//                                                            NSMutableArray *bData = [_sysAr[section][@"subSys"][orginRow] valueForKey:@"engineWaterTProjectList"];
//                                                            if(!bData) bData = @[].mutableCopy;
//                                                            [bData addObjectsFromArray:mData];
//                                                            [_sysAr[section][@"subSys"][orginRow] setValue:bData.mutableCopy forKey:@"engineWaterTProjectList"];
                                                            
                                                            [itemInfo setValue:mData.mutableCopy forKey:@"engineWaterTProjectList"];
                                                            
                                                            [self array:mData del:subSys];
                                                            
                                                            
                                                            [subSys insertObjects:mData atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row+1, mData.count)]];
                                                            //[subSys addObjectsFromArray:mData];
                                                            
                                                            [weakSelf.tableView reloadData];
                                                            return ;
                                                            
                                                            
                                                        }
                                                        failure:^(NSError *error) {
                                                            [weakSelf.tableView reloadData];
                                                        }];
}

- (void)notificationOutletTemperature:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    /*
     如果空调出风口温度是0~8，判断高低压数据是否有在此范围值，如果不是，返回空调数据有误，请填写真实检测数据
     如果空调出风口温度不是0~8或者高低压在范围值内，往下走
     */
    
    for (NSUInteger i = 0; i <_sysAr.count; i++) {
        NSDictionary *itemSys = _sysAr[i];
        for (NSMutableDictionary *item in itemSys[@"subSys"]) {
            if ([item[@"projectName"] isEqualToString:@"空调系统低压压力"]
                || [item[@"projectName"] isEqualToString:@"空调系统高压压力"]
                || [item[@"projectName"] isEqualToString:@"出风口温度"]) {
                NSMutableDictionary *temperature = item[@"temperature"];
                if (!temperature) {
                    temperature = [@{}mutableCopy];
                }
                [temperature addEntriesFromDictionary:userInfo];
                [item setObject:temperature forKey:@"temperature"];
            }
        }
    }
}

- (void)notificationFault:(NSNotification*)notice{
    NSMutableDictionary *userInfo = notice.userInfo.mutableCopy;
    [self updataFault:userInfo section:((NSNumber*)userInfo[@"index"]).integerValue isDel:NO];
    
    //[self updataFault:userInfo[@"item"] section:((NSNumber*)userInfo[@"index"]).integerValue isDel:NO];
}

- (void)updataFault:(NSMutableDictionary*)itemInfo section:(NSUInteger)section isDel:(BOOL)isDel{
    
    NSInteger row = [itemInfo[@"row"] integerValue];
    
    itemInfo = itemInfo[@"item"];
    NSArray *sub = itemInfo[@"sub"];
    NSDictionary *sysInfo = _sysAr[section];
    
    if(row >= [sysInfo[@"subSys"] count])  return;
    
    NSMutableDictionary *item = sysInfo[@"subSys"][row];
    //item[@"faultData"] = nil;
    
    NSMutableArray *vals = [@[]mutableCopy];
    NSMutableArray *addItems = [item valueForKey:@"addItems"];
    for (NSDictionary *info in addItems)
    {
        [vals addObject:info[@"val"]];
    }
    
    NSString *faultCode = [vals componentsJoinedByString:@","];
    
    
    __block NSMutableArray *subSys = sysInfo[@"subSys"];
    //    [subSys removeObjectsInArray:sub];
    if (!([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"])) {
        [self array:subSys del:sub];
    }
    if (isDel) {
        [_tableView reloadData];
    }else{
        __weak __typeof__(self) weakSelf = self;
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        
        if (([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"])) {
            
        }else{
            
#if 1
            item[@"faultData"] = nil;
            
            [[YHCarPhotoService new] getElecCtrlProjectListByBillId:self.orderInfo[@"id"]
                                                         sysClassId:sysInfo[@"sysClassId"]
                                                          faultCode:faultCode
                                                            success:^(NSDictionary *obj) {
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                                NSMutableDictionary *data = obj.mutableCopy;
                                                                
                                                                data[@"sel"] = @(![[obj valueForKey:@"list"] count]);
                                                                item[@"faultData"] = data;
                                                                
                                                                NSString *des = [data valueForKey:@"encyDescs"];
                                                                NSArray *lists = [data valueForKey:@"list"];//data[@"list"];
                                                                if (lists.count) {
                                                                    
                                                                    NSMutableArray *mData = [@[]mutableCopy];
                                                                    for (NSDictionary *item in lists) {
                                                                        [mData addObject:[item mutableCopy]];
                                                                    }
                                                                    [itemInfo setValue:mData forKey:@"sub"];
                                                                    [itemInfo setValue:des forKey:@"encyDescs"];
                                                                    
                                                                    [self array:mData del:subSys];
                                                                    //[mData removeObjectsInArray:subSys];
                                                                    [subSys addObjectsFromArray:mData];
                                                                    [weakSelf.tableView reloadData];
                                                                    return ;
                                                                }
                                                                
                                                                
                                                                
                                                                if(des.length) {
                                                                    [weakSelf.tableView reloadData];
                                                                    return;
                                                                }
                                                                [MBProgressHUD showError:@"该故障码暂无匹配数据"];
                                                                [weakSelf.tableView reloadData];
                                                                
                                                            } failure:^(NSError *error) {
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                            }];
#else
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             getElecCtrlInspectionProjectList:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"] sysClassId:sysInfo[@"sysClassId"] faultCode:itemInfo[@"val"]
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     NSArray *data = info[@"data"];
                     NSMutableArray *mData = [@[]mutableCopy];
                     for (NSDictionary *item in data) {
                         [mData addObject:[item mutableCopy]];
                     }
                     [itemInfo setValue:mData forKey:@"sub"];
                     
                     [self array:mData del:subSys];
                     //                 [mData removeObjectsInArray:subSys];
                     [subSys addObjectsFromArray:mData];
                     [weakSelf.tableView reloadData];
                 }else {
                     [weakSelf.tableView reloadData];
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLog(@"");
                     }
                 }
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
#endif
        }
    }
}
/*
 延长保修更新故障码
 */
- (void)updataFaultExtrendSection:(NSUInteger)section {
    NSMutableDictionary *sysInfo = _sysAr[section >> 16];
    __block NSMutableArray *subSys = sysInfo[@"subSys"];
    NSMutableDictionary *itemInfo = subSys[section & 0XFFFF];
    NSMutableArray *subFaultB = itemInfo[@"subFaultB"];
    NSMutableArray *addItems = itemInfo[@"addItems"];
    [itemInfo removeObjectForKey:@"addItemsB"];
    //
    [sysInfo removeObjectForKey:@"subFaultB"];
    
    [self array:subSys del:subFaultB];
    NSMutableArray *vals = [@[]mutableCopy];
    
    for (NSDictionary *info in addItems)
    {
        [vals addObject:info[@"val"]];
        
    }
    [itemInfo setObject:vals forKey:@"codeValB"];//备份code
    
    NSString *faultCode = [vals componentsJoinedByString:@","];
    
    __weak __typeof__(self) weakSelf = self;
    
    
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    itemInfo[@"faultData"] = nil;
    
#if 1
    
    [[YHCarPhotoService new] getElecCtrlProjectListByBillId:self.orderInfo[@"id"]
                                                 sysClassId:sysInfo[@"sysClassId"]
                                                  faultCode:faultCode
                                                    success:^(NSDictionary *obj) {
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        NSMutableDictionary *data = obj.mutableCopy;
                                                        
                                                        data[@"sel"] = @(![[obj valueForKey:@"list"] count]);
                                                        itemInfo[@"faultData"] = data;
                                                        
                                                        NSString *des = [data valueForKey:@"encyDescs"];
                                                        NSArray *lists = [data valueForKey:@"list"];//data[@"list"];
                                                        if (lists.count) {
                                                            
                                                            
                                                            NSMutableArray *mData = [@[]mutableCopy];
                                                            for (NSDictionary *item in lists) {
                                                                [mData addObject:[item mutableCopy]];
                                                            }
                                                            
                                                            [itemInfo setValue:mData forKey:@"subFaultB"];
                                                            [sysInfo setValue:mData forKey:@"subFaultB"];
                                                            NSInteger loc = 0;
                                                            for (NSInteger i = 0; i < subSys.count; i++) {
                                                                NSDictionary *info = subSys[i];
                                                                if (info == itemInfo) {
                                                                    loc = i;
                                                                }
                                                            }
                                                            [itemInfo setValue:mData forKey:@"sub"];
                                                            [itemInfo setValue:des forKey:@"encyDescs"];
                                                            
                                                            [self array:mData del:subSys];
                                                            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                                                                   NSMakeRange(loc + 1,[mData count])];
                                                            [subSys insertObjects:mData atIndexes:indexes];
                                                            [weakSelf.tableView reloadData];
                                                            return ;
                                                        }
                                                        
                                                        if(des.length) {
                                                            [weakSelf.tableView reloadData];
                                                            return;
                                                        }
                                                        [MBProgressHUD showError:@"该故障码暂无匹配数据"];
                                                        [weakSelf.tableView reloadData];
                                                        
                                                    } failure:^(NSError *error) {
                                                        [MBProgressHUD hideHUDForView:self.view];
                                                        [weakSelf.tableView reloadData];
                                                        
                                                    }];
    
#else
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getElecCtrlProjectListByY:[YHTools getAccessToken]
     billId:self.orderInfo[@"id"]
     sysClassId:sysInfo[@"sysClassId"]
     faultCode:faultCode
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSArray *data = info[@"data"];
             NSMutableArray *mData = [@[]mutableCopy];
             for (NSDictionary *item in data) {
                 [mData addObject:[item mutableCopy]];
             }
             
             [itemInfo setValue:mData forKey:@"subFaultB"];
             [sysInfo setValue:mData forKey:@"subFaultB"];
             NSInteger loc = 0;
             for (NSInteger i = 0; i < subSys.count; i++) {
                 NSDictionary *info = subSys[i];
                 if (info == itemInfo) {
                     loc = i;
                 }
             }
             [itemInfo setValue:mData forKey:@"sub"];
             [self array:mData del:subSys];
             NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                    NSMakeRange(loc + 1,[mData count])];
             [subSys insertObjects:mData atIndexes:indexes];
             [weakSelf.tableView reloadData];
         }else {
             [MBProgressHUD showError:@"该故障码暂无匹配数据"];
             [weakSelf.tableView reloadData];
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
#endif
}

- (void)array:(NSMutableArray*)src del:(NSArray*)res{
    [src enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSDictionary *item in res) {
            if ([obj[@"id"] isEqualToString:item[@"id"]]) {
                [src removeObject:obj];
            }
        }
    }];
}

- (void)notificationOrderProjectSel:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    NSDictionary *info = userInfo[@"info"];
    NSDictionary *intervalRange = info[@"intervalRange"];
    self.selProjectInfo = info;
    _projectSelectRow = 0;
    if ([_selProjectInfo[@"dataType"] isEqualToString:@"date"]) {
        
        self.selBox.hidden = NO;
        self.selPicker.hidden = YES;
        self.datePicker.hidden = NO;
    }else{
        NSNumber *tag = info[@"tag"];
        
        NSString *pId;
        if (tag.integerValue == 1) {
            NSDictionary *valueSel =  _selProjectInfo[@"valueSel"];
            if (!valueSel) {
                [MBProgressHUD showError:@"请选择省"];
                return;
            }else{
                pId = valueSel[@"cityId"];
            }
        }
        
        if ([info[@"intervalType"] isEqualToString:@"gangedAjaxSelect"]) {
            intervalRange =  ((NSArray*)intervalRange)[tag.integerValue];
        }
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getProjectList:intervalRange[@"ajaxUrl"]
         pId:pId
         onComplete:^(NSDictionary *info) {
             
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 
                 weakSelf.selProjects = info[@"data"];
                 weakSelf.selBox.hidden = NO;
                 weakSelf.selPicker.hidden = NO;
                 weakSelf.datePicker.hidden = YES;
                 [weakSelf.selPicker reloadAllComponents];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

- (void)cloudDepthDetailInit{
    
    self.sysAr = [[NSMutableArray alloc] init];//[@[]mutableCopy];
    
    NSArray *depthProjectS = _sysData[@"cloudDepthDetail"];
    for (NSDictionary *item in depthProjectS) {
        BOOL isExit = NO;
        for (NSMutableDictionary *initialSurvey in _sysAr) {
            if ([item[@"sysClassId"] isEqualToString:initialSurvey[@"sysClassId"]]) {
                
                NSMutableArray *subSys = initialSurvey[@"subSys"];
                if (subSys == nil) {
                    subSys = [@[]mutableCopy];
                    [initialSurvey setObject:subSys forKey:@"subSys"];
                }
                NSMutableDictionary *tempItem = [item mutableCopy];
                [tempItem setObject:@"1" forKey:@"isRequir"];
                [self additionalCondition:tempItem];
                [subSys addObject:tempItem];
                isExit = YES;
            }
        }
        
        if (!isExit) {
            
            NSMutableDictionary *tempItem = [item mutableCopy];
            [tempItem setObject:@"1" forKey:@"isRequir"];
            [self additionalCondition:tempItem];
            [_sysAr addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                 @"sel" : @1,
                                 @"title" : item[@"className"],
                                 @"subSys" : [@[tempItem]mutableCopy]}mutableCopy]];
        }
    }
    
}
#pragma mark - 数据处理 ---
- (void)dataInit{
    
    NSMutableArray *initialSurveyCheckProject = [_sysData[@"initialSurveyCheckProject"] mutableCopy];
    NSDictionary *basicInfo = _sysData[@"baseInfo"];
    self.basicInfo = [NSDictionary dictionaryWithDictionary:basicInfo];
    [_sysAr enumerateObjectsUsingBlock:^(NSMutableDictionary *sysItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = sysItem[@"title"];
        if ([title containsString:@"刹车距离"]) {
            return ;
        }
        
        for (NSInteger row = 0; row < initialSurveyCheckProject.count; row++) {
            NSDictionary *item = initialSurveyCheckProject[row];
            if ([item[@"projectName"] isEqualToString:@"上牌时间"]) {
                ;
            }
            if ([item[@"projectName"] isEqualToString:@"启用时间"]) {
                ;
            }
            if ([item[@"projectName"] isEqualToString:@"使用地"]) {
                ;
            }
            
            if ([item[@"sysClassId"] isEqualToString:sysItem[@"sysClassId"]]) {
                NSMutableArray *subSys = sysItem[@"subSys"];
                if (subSys == nil) {
                    subSys = [@[]mutableCopy];
                    [sysItem setObject:subSys forKey:@"subSys"];
                }
                NSMutableDictionary * tmp = [item mutableCopy];
                [self additionalCondition:tmp];
                [subSys addObject:tmp];
            }
        }
    }];
    
    for (NSUInteger i = 0; i <_sysAr.count; ) {
        NSDictionary *item = _sysAr[i];
        NSArray *subSys = item[@"subSys"];
        if (subSys.count == 0 || !subSys) {
            [_sysAr removeObjectAtIndex:i];
            continue;
        }
        i++;
    }
    
    // 工单暂存数据
    NSDictionary *temporarySaveDict = _sysData[@"temporarySave"];
    NSArray *initialSurveyProjectVal = temporarySaveDict[@"initialSurveyProjectVal"];
     // 将网络返回的工单数据更新本地缓存的数据
    [[YHStoreTool ShareStoreTool] setOrderDetailArr:initialSurveyProjectVal];

    // van_mr 假如暂存数据
    for (NSDictionary *sysItem in _sysAr) {
        NSString *sysTitle = sysItem[@"title"];

        if (![initialSurveyProjectVal isKindOfClass:[NSArray class]]) {
            break;
        }
        for (int i = 0; i<initialSurveyProjectVal.count; i++) {

            NSDictionary *saveItem = initialSurveyProjectVal[i];
            NSArray *projectValArr = saveItem[@"projectVal"];
            
            if ([sysTitle isEqualToString:saveItem[@"sysId"]]) {
               NSArray *subSys = sysItem[@"subSys"];
                for (int i = 0; i<subSys.count; i++) {

                    NSDictionary *subSysItem = subSys[i];
                    NSString *subSysId = subSysItem[@"id"];

                    if (![projectValArr isKindOfClass:[NSArray class]]) {
                        break;
                    }
                    for (int j = 0; j<projectValArr.count; j++) {
                        NSDictionary *projectValDict = projectValArr[j];
                        if ([projectValDict isKindOfClass:[NSNull class]] || !projectValDict) {
                            continue;
                        }
                        NSString *proId = projectValDict[@"id"];

                        NSDictionary *intervalRange = subSysItem[@"intervalRange"];
                        NSString *intervalType = subSysItem[@"intervalType"];

                        if ([subSysId isEqualToString:proId]) {
                            if ([intervalType isEqualToString:@"radio"]/*radio*/) {

                                NSArray *list = intervalRange[@"list"];
                                for (int i = 0 ; i < list.count; i++) {
                                    NSString *name = list[i][@"name"] ;
                                    if ([name isEqualToString:projectValDict[@"projectVal"]]) {
                                        [subSysItem setValue:@(i) forKey:@"sel"];
                                        [subSysItem setValue:projectValDict[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];
                                    }
                                }
                            } else  if ([intervalType isEqualToString:@"text"]/*text, int flaot*/) {
        
                                [subSysItem setValue:projectValDict[@"projectVal"] forKey:@"value"];
                                 [subSysItem setValue:projectValDict[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];

                            }else if([intervalRange isKindOfClass:[NSString class]]
                                || (id)intervalRange == [NSNull null]
                                || [intervalType isEqualToString:@"gangedAjaxSelect"]
                                || [intervalType isEqualToString:@"sameIncrease"]
                                || [intervalType isEqualToString:@"form"]
                                || [intervalType isEqualToString:@"elecCodeForm"]
                                || [intervalType isEqualToString:@"gatherInputAdd"]){
                                
                                id addItems =projectValDict[@"addItems"];
                                NSMutableArray *newAddItems = [NSMutableArray array];
                                if ([addItems isKindOfClass:[NSArray class]]){
                                    for (id item in addItems) {
                                        if ([item isKindOfClass:[NSDictionary class]]) {
                                            NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
                                            [newAddItems addObject:newItem];
                                        }
                                    }
                                }
                                [subSysItem setValue:newAddItems forKey:@"addItems"];
                                [subSysItem setValue:projectValDict[@"projectRelativeImgList"] forKey:@"projectRelativeImgList"];
                            }
                        }
                    }

                }
            }
        }

    }
}

- (void)additionalCondition:(NSMutableDictionary*)src{
    return;
    NSArray *conditions =  @[ @{@"name" : @"环境温度",
                                @"rang" : @{@"min" : @"-15",
                                            @"max" : @"80"}
                                },
                              @{@"name" : @"环境湿度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"100"}
                                },
                              @{@"name" : @"空调高压压力",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"30"}
                                },
                              @{@"name" : @"空调低压压力",
                                @"rang" : @{@"min" : @"-30",
                                            @"max" : @"15"}
                                },
                              @{@"name" : @"低压管温度",
                                @"rang" : @{@"min" : @"-15",
                                            @"max" : @"30"}
                                },
                              @{@"name" : @"空调出风口温度",
                                @"rang" : @{@"min" : @"-15",
                                            @"max" : @"40"}
                                },
                              @{@"name" : @"冷媒加注量",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"3000"}
                                },
                              @{@"name" : @"冷凝器进口温度",
                                @"rang" : @{@"min" : @"10",
                                            @"max" : @"120"}
                                },
                              @{@"name" : @"冷凝器出口温度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"110"}
                                },
                              @{@"name" : @"空调出风口风速",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"电瓶电压",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"18"}
                                },
                              @{@"name" : @"发电电压",
                                @"rang" : @{@"min" : @"1",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"发动机转速",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"5000"}
                                },
                              @{@"name" : @"机油油温",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"180"}
                                },
                              @{@"name" : @"气缸压力",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"机油加注量",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"15"}
                                },
                              @{@"name" : @"冷却液加注量",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"冷却液冰点",
                                @"rang" : @{@"min" : @"-60",
                                            @"max" : @"60"}
                                },
                              @{@"name" : @"左前制动片厚度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"右前制动片厚度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"左后制动片厚度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"右后制动片厚度",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"20"}
                                },
                              @{@"name" : @"刹车油含水量",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"100"}
                                },
                              @{@"name" : @"波箱油加注量",
                                @"rang" : @{@"min" : @"0",
                                            @"max" : @"30"}
                                }
                              ];
    
    for (NSDictionary *condition  in conditions) {
        if ([src[@"projectName"] isEqualToString:condition[@"name"]]) {
            NSMutableDictionary *intervalRange = [src[@"intervalRange"] mutableCopy];
            if ([intervalRange isKindOfClass:[NSDictionary class]]) {
                [intervalRange addEntriesFromDictionary:condition[@"rang"]];
                [src setObject:intervalRange forKey:@"intervalRange"];
            }else{
                [src setObject:condition[@"rang"] forKey:@"intervalRange"];
            }
            return;
        }
    }
}

- (void)depthDataInit{
    self.sysAr = [@[]mutableCopy];
    
    NSArray *depthProjectS = _sysData[@"depth"];
    for (NSDictionary *item in depthProjectS) {
        BOOL isExit = NO;
        for (NSMutableDictionary *initialSurvey in _sysAr) {
            if ([item[@"sysClassId"] isEqualToString:initialSurvey[@"sysClassId"]]) {
                
                NSMutableArray *subSys = initialSurvey[@"subSys"];
                if (subSys == nil) {
                    subSys = [@[]mutableCopy];
                    [initialSurvey setObject:subSys forKey:@"subSys"];
                }else{
                    [subSys removeAllObjects];
                }
                
                NSMutableDictionary * tmp = [item mutableCopy];
                [self additionalCondition:tmp];
                [subSys addObject:tmp];
                isExit = YES;
            }
        }
        
        if (!isExit) {
            
            NSMutableDictionary * tmp = [item mutableCopy];
            [self additionalCondition:tmp];
            [_sysAr addObject:[@{@"sysClassId" : item[@"sysClassId"],
                                 @"subSys" : [@[tmp]mutableCopy]}mutableCopy]];
        }
    }
    
}

- (BOOL)isSelectAll:(NSDictionary*)info{//是否有全选功能
    return [info[@"title"] isEqualToString:@"车身系统"]
    || [info[@"title"] isEqualToString:@"灯光系统"]
    || [info[@"title"] isEqualToString:@"车身"]
    || [info[@"title"] isEqualToString:@"发动机舱"]
    || [info[@"title"] isEqualToString:@"底盘"]
    || [info[@"title"] isEqualToString:@"左前"]
    || [info[@"title"] isEqualToString:@"右前"]
    || [info[@"title"] isEqualToString:@"左后"]
    || [info[@"title"] isEqualToString:@"右后"]
    || [info[@"title"] isEqualToString:@"高位"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    for (int i = 0; i<_sysAr.count; i++) {
        NSDictionary *dict = _sysAr[i];
        NSString *title = dict[@"title"];
        if ([title containsString:@"刹车距离"]) {
            [_sysAr removeObject:dict];
            break;
        }
    }
    return _sysAr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sysInfo = _sysAr[section];
    NSNumber *sel = sysInfo[@"sel"];
    if (!sel.boolValue) {
        return 0;
    }
    NSArray *subSys = sysInfo[@"subSys"];
    if ([self isSelectAll:sysInfo]) {
        return subSys.count + 1;
    }
    return subSys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sysInfo = _sysAr[indexPath.section];
    NSArray *subSys = sysInfo[@"subSys"];
    NSMutableDictionary *subItem;
    
    NSString *billType = self.orderInfo[@"billType"];
    //维修单 添加故障码，没有保存按钮，自动查询初检项目
    BOOL isExtrend = ![billType isEqualToString:@"W"];// ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"A"]) || [billType isEqualToString:@"K"];
    
    CGFloat photoH = self.isHasPhoto? 50  : 0;
    
    NSUInteger realRow = indexPath.row;
    if ([self isSelectAll:sysInfo] ) {
        realRow = realRow - 1;//有一个全选的cell, 多一个数据
        if (indexPath.row != 0) {//有一个全选的cell
            subItem = subSys[realRow];
        }
    }else{
        subItem = subSys[indexPath.row];
    }
    NSDictionary *intervalRange = subItem[@"intervalRange"];
    NSString *intervalType = subItem[@"intervalType"];
    
    if (([intervalRange isKindOfClass:[NSString class]])
        || (id)intervalRange == [NSNull null]
        || [intervalType isEqualToString:@"gangedAjaxSelect"]
        || [intervalType isEqualToString:@"sameIncrease"]
        || [intervalType isEqualToString:@"form"]
        || [intervalType isEqualToString:@"elecCodeForm"]) {
        
        YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lampCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.photoH.constant = photoH;
        [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)isExtrend:isExtrend];
        return cell;
        
    }else if([intervalRange isKindOfClass:[NSDictionary class]]){
        NSArray *list = intervalRange[@"list"];
        // 是否联动
        BOOL isRelate = (!intervalRange[@"isChild"] || [intervalRange[@"isChild"] intValue] != 1) ? NO : YES;
        
        if (list.count == 2 || !list) {
            YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lampCell" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.photoH.constant = photoH;
            
            [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)isExtrend:isExtrend];
            
            if (isRelate) {
                cell.isDelayCare = YES;
                NSArray *list = intervalRange[@"list"];
                if (list.count >= 2) {
                     cell.optionInfo = list[1];
                }
            }else{
                cell.optionInfo = nil;
                cell.isDelayCare = NO;
            }
            return cell;
        }else{
            YHOliCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oilCell" forIndexPath:indexPath];
            [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)];
            return cell;
        }
    }else{
        
        if ([self isSelectAll:sysInfo] ) {
            if (indexPath.row == 0) {
                YHCarSelAllCell *cell ;
                if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"switchNew" forIndexPath:indexPath];
                }else{
                    cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
                }
                NSMutableDictionary *sysInfo = _sysAr[indexPath.section];
                NSNumber *state = sysInfo[@"state"];
                if (!state) {
                    state = @(YHCarAllCenter);
                }
                [cell loadButtonState:state.unsignedIntValue sysIndex:indexPath.section];
                cell.itemInfo = subItem;
                return cell;
            }
            YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lampCell" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.photoH.constant = photoH;
            [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)isExtrend:isExtrend];
            
            //  YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
            return cell;
        }else{
            YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lampCell" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.photoH.constant = photoH;
            
            [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)isExtrend:isExtrend];
            
            // YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //40 + 10
    CGFloat photoH = self.isHasPhoto ? 60  : 0;
    
    NSDictionary *sysInfo = _sysAr[indexPath.section];
    NSArray *subSys = sysInfo[@"subSys"];
    NSMutableDictionary *subItem;
    NSUInteger realRow = indexPath.row;
    if ([self isSelectAll:sysInfo]) {
        realRow = realRow - 1;//有一个全选的cell, 多一个数据
        if (indexPath.row == 0
            && (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]//云细检数值填写
                 || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"matchInitialSurvey"]//云细检数值填写
                 || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]//云细检数值填写
                 ))) {
            return 0;
        }
        if (indexPath.row != 0) {//有一个全选的cell
            subItem = subSys[realRow];
        }
    }else{
        subItem = subSys[realRow];
    }
    NSDictionary *intervalRange = subItem[@"intervalRange"];
    NSString *intervalType = subItem[@"intervalType"];
    if ((id)intervalRange == [NSNull null] ) {
        return 55 + photoH;
    }else if([intervalType isEqualToString:@"gatherInputAdd"]
             || [intervalType isEqualToString:@"sameIncrease"]
             || [intervalType isEqualToString:@"form"]
             || [intervalType isEqualToString:@"elecCodeForm"]) {
        float h =[tableView fd_heightForCellWithIdentifier:@"lampCell" configuration:^(YHWenXunCell* cell) {
            cell.photoH.constant = photoH?50:0;
            [cell loadDatasourceInitialInspection:subItem index:((indexPath.section << 16) + realRow)isExtrend:YES];
        }];
        return h;
    }else if([intervalRange isKindOfClass:[NSDictionary class]]){
        NSArray *list = intervalRange[@"list"];
        // 是否联动
        BOOL isRelate = (!intervalRange[@"isChild"] || [intervalRange[@"isChild"] intValue] != 1) ? NO : YES;
        if (list.count == 2 || !list) {
            
            if (isRelate && [self isAlreadySelectDelayCare:[NSString stringWithFormat:@"%@",subItem[@"id"]]]) {
                
                NSArray *listArr = intervalRange[@"list"];
                NSDictionary *optionInfoItem = listArr[1];
                NSArray *optionList = optionInfoItem[@"childList"];
                return 55 + optionList.count * 40 + 40;
            }
            
            return 55 + photoH;
        }else{
            return 140 + photoH;
        }
    }else{
        return 55 + (indexPath.row ? photoH : 0);
    }
}
- (BOOL)isAlreadySelectDelayCare:(NSString *)itemId{
    
    if (!self.leakReportArr.count) {
        return NO;
    }
    BOOL isExist = NO;
    for (int i = 0; i<self.leakReportArr.count; i++) {
        NSDictionary *item = self.leakReportArr[i];
        if ( [item[@"id"] isEqualToString:itemId]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    return 70;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *sysInfo = _sysAr[section];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    [contentView setBackgroundColor:YHColor(229, 229, 234)];
    
    UIView *contentViewSub = [[UIView alloc] initWithFrame:CGRectMake(0, (section == 0) ? 0 : 10, screenWidth, 60)];
    [contentViewSub setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *sysInfoDesc = [YHTools sysProjectByKey:sysInfo[@"sysClassId"]];
    
    UIImageView *imaggeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 33, 33)];  //van_modify
    //     UIImageView *imaggeView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imaggeView setImage:[UIImage imageNamed:sysInfoDesc[1]]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 13, 1, 33)];  //van_modify
    //     UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [lineView setBackgroundColor:YHLineColor];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, screenWidth, 60)];  //van_modify
    //    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, screenWidth, 60)];
    [titleL setText:sysInfo[@"title"]];
    NSNumber *sel = sysInfo[@"sel"];
    if (sel.boolValue) {
        [titleL setTextColor:YHNaviColor];
    }else{
        [titleL setTextColor:YHColor(178, 178, 178)];
    }
    [titleL setFont:[UIFont systemFontOfSize:17]];
    
    UIButton *arrowB = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 60, 0, 60, 60)];
    [arrowB setImage:[UIImage imageNamed:((sel.boolValue)? (@"me_45") : (@"me_7"))] forState:UIControlStateNormal];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    [button addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:section];
    
    
    [contentView addSubview:contentViewSub];
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"] || self.isHasPhoto) {
        titleL.frame = CGRectMake(15, 0, screenWidth, 60);
    }else{
        [contentViewSub addSubview:imaggeView];
        [contentViewSub addSubview:lineView];
    }
    [contentViewSub addSubview:titleL];
    [contentViewSub addSubview:arrowB];
    [contentViewSub addSubview:button];
    return contentView;
}

- (IBAction)helpAction:(UIButton*)sender {
    
    __weak __typeof__(self) weakSelf = self;
    NSUInteger tag = sender.tag;
    
    NSUInteger section = tag >> 16;
    NSUInteger row = tag & 0XFFFF;
    
    NSDictionary *sysInfo = _sysAr[section];
    NSArray *subSys = sysInfo[@"subSys"];
    NSMutableDictionary *subItem ;
    
    NSDictionary *intervalRange = [subSys[row] valueForKey:@"intervalRange"];
    if([intervalRange isKindOfClass:[NSDictionary class]]){
        
        NSArray *list = [intervalRange valueForKey:@"list"];
        if ([list isKindOfClass:[NSArray class]] && [list.firstObject valueForKey:@"tips"]) {
            /////
            NSMutableArray *message = [NSMutableArray arrayWithCapacity:list.count];
            [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [message addObject:[NSString stringWithFormat:@"%@:%@",obj[@"name"],obj[@"tips"]]];
            }];
            [UIAlertController showAlertInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:message tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
            return;
        }
    }
//    if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])) {//新全车有全选功能
//        subItem = subSys[row - 1];
//    }else{
        subItem = subSys[row];
//    }
    NSString *projectId = subItem[@"id"];
    if (!projectId) {
        projectId = subItem[@"projectId"];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];

    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getVideoList:[YHTools getAccessToken]
     projectId:projectId
     billId:self.orderInfo[@"id"]
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             NSArray *videos = data[@"showToolsData"];
             if (videos == nil || videos.count == 0) {
                 [MBProgressHUD showError:@"暂无视频"];
             }else{
                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                 YHVideosController *controller = [board instantiateViewControllerWithIdentifier:@"YHVideosController"];
                 controller.videos = videos;
                 [weakSelf.navigationController pushViewController:controller animated:YES];
             }
         }else {
             [MBProgressHUD showError:@"暂无视频"];
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD showError:@"暂无视频"];
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

//FIXME:  -  展开与龙和
- (void)headerAction:(UIButton*)button{
    NSMutableDictionary *sysInfo = _sysAr[button.tag];
    NSNumber *sel = sysInfo[@"sel"];
    [sysInfo setObject:[NSNumber numberWithBool:(!sel.boolValue)] forKey:@"sel"];
    [self.tableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //滑动收起键盘
    [[self view] endEditing:YES];
    self.selBox.hidden = YES;
}

- (IBAction)saveInfoAction:(UIButton*)sender {
    
}

- (void)auto2Row:(NSInteger)row inSection:(NSInteger)section{
    
    NSMutableDictionary *sysInfo = _sysAr[section];
    NSNumber *sel = sysInfo[@"sel"];
    if (!sel.boolValue) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = section;
        [self headerAction:button];
    }
    
    NSInteger totalRow = [self.tableView numberOfRowsInSection:section];
    
    if (row <0 || row > totalRow) {
        return;
    }
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSArray*)delLow2Sys:(NSMutableArray*)array{//新全车二级栏目删除，入左前、右前
    NSMutableArray *temp = [array mutableCopy];
    for (NSInteger i = 0; i < temp.count; i++) {
        NSDictionary *sysSubItem = temp[i];
        if (sysSubItem[@"isLow2"]) {
            [temp removeObjectAtIndex:i];
            i--;
        }
    }
    return temp;
}

- (BOOL)checkNewWholeALL{//是否是全填或全不填
    BOOL isNoEmptySys = NO ; //至少有一个填写了，除故障码
    BOOL isEmptySys = NO ; //至少有一个为空
    NSInteger firstEmptySelction = 0 ; //第一个为空的section
    NSInteger firstEmptyRow = 0 ; //第一个为空的row
    for (NSUInteger i = 0; i < _sysAr.count; i++) {
        NSDictionary *sys = _sysAr[i];
        NSArray *subSys = [self delLow2Sys:sys[@"subSys"]];
        
        for (NSUInteger j = 0; j < subSys.count; j++) {
            NSDictionary *item = subSys[j];
            if (item[@"value"] || item[@"sel"]) {
                isNoEmptySys = YES;
            }else{
                if (!isEmptySys) {
                    firstEmptySelction = i;
                    firstEmptyRow = j;
                }
                isEmptySys = YES;
            }
            if (isNoEmptySys && isEmptySys) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                [self auto2Row:firstEmptyRow inSection:firstEmptySelction];
                return NO;
            }
        }
    }
    return (isNoEmptySys && !isEmptySys) || (!isNoEmptySys && isEmptySys);
}


- (NSMutableArray *)pList{
    __block NSMutableArray *pList = [NSMutableArray array];
    [_sysAr enumerateObjectsUsingBlock:^(NSMutableDictionary * subItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *subSys = [subItem valueForKey:@"subSys"];
        [subSys enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto, NSUInteger idx, BOOL * _Nonnull stop) {
            ///
            NSNumber *depth = [itemInto valueForKey:@"depth"];
            if(depth) [pList addObject:itemInto];

//            NSMutableArray *childItem = [itemInto valueForKey:@"childItem"];
//            if(childItem) [pList addObjectsFromArray:childItem];
//            [childItem enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto1, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSMutableArray *childItem1 = [itemInto1 valueForKey:@"childItem"];
//                if(childItem1) [pList addObjectsFromArray:childItem1];
//                [childItem1 enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto2, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                    NSMutableArray *childItem2 = [itemInto2 valueForKey:@"childItem"];
//                    if(childItem2) [pList addObjectsFromArray:childItem2];
//
//                }];
//            }];
        }];
        
    }];
    return pList;
}

- (BOOL)checkNewWholeALLEmpty{ //是否是全不填
    
    BOOL isNoEmptySys = NO ; //至少有一个填写了，除故障码
    BOOL isEmptySys = NO ; //至少有一个为空
    NSInteger firstEmptySelction = 0 ; //第一个为空的section
    NSInteger firstEmptyRow = 0 ; //第一个为空的row
    for (NSUInteger i = 0; i < _sysAr.count; i++) {
        NSDictionary *sys = _sysAr[i];
        NSArray *subSys = [self delLow2Sys:sys[@"subSys"]];
        
        for (NSUInteger j = 0; j < subSys.count; j++) {
            NSDictionary *item = subSys[j];
            
            if([self.pList containsObject:item]) continue;
            
            if (item[@"value"] || item[@"sel"]) {
                isNoEmptySys = YES;
            }else{
                if (!isEmptySys) {
                    firstEmptySelction = i;
                    firstEmptyRow = j;
                }
                isEmptySys = YES;
            }
            if (isNoEmptySys && isEmptySys) {
                return NO;
            }
        }
    }
    
    if (!isNoEmptySys && isEmptySys) {
        [MBProgressHUD showError:@"请填写数据"];
        return YES;
    }
    return YES;
}


- (BOOL)array:(NSArray*)ar item:(id)item{
    for (NSInteger row = 0; row < ar.count; row++) {
        NSDictionary *info = ar[row];
        if (info == item) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkEngineWaterTProjectList{
    
    __block NSMutableArray *pList = [NSMutableArray array];
    [_sysAr enumerateObjectsUsingBlock:^(NSMutableDictionary * subItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *subSys = [subItem valueForKey:@"subSys"];
        [subSys enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto, NSUInteger idx, BOOL * _Nonnull stop) {
            ///
            NSNumber *depth = [itemInto valueForKey:@"depth"];
            if(depth) [pList addObject:itemInto];
//            NSMutableArray *childItem = [itemInto valueForKey:@"childItem"];
//            if(childItem) [pList addObjectsFromArray:childItem];
//            [childItem enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto1, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSMutableArray *childItem1 = [itemInto1 valueForKey:@"childItem"];
//                if(childItem1) [pList addObjectsFromArray:childItem1];
//                [childItem1 enumerateObjectsUsingBlock:^(NSMutableDictionary * itemInto2, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                    NSMutableArray *childItem2 = [itemInto2 valueForKey:@"childItem"];
//                    if(childItem2) [pList addObjectsFromArray:childItem2];
//
//                }];
//            }];
        }];
        
    }];
    
    __block BOOL isOnlyOne = NO ; //至少有一个填写
    [pList enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj valueForKey:@"sel"]) {
            isOnlyOne = YES;
            *stop = YES;
        }
    }];
    
    
    if (!isOnlyOne && pList.count) [MBProgressHUD showError:@"至少选择或填写一项"];

    return (isOnlyOne || !(pList.count));
}

- (BOOL)checkExtrendVerification{//故障码的搜索项必需填写一个，其他想要全填或不填
    BOOL isOnlyOne = NO ; //至少有一个填写了，除故障码
    NSInteger firstEmptySelction = 0 ; //第一个为空的section
    NSInteger firstEmptyRow = 0 ; //第一个为空的row
    for (NSUInteger section = 0; section < _sysAr.count; section++) {
        NSDictionary *sys = _sysAr[section];
        
        
        NSMutableArray *subSysTemp = [sys[@"subSys"] mutableCopy];
        NSMutableArray *faultTemp = [sys[@"subFaultB"] mutableCopy];
        //        [subSysTemp removeObjectsInArray:faultTemp];
        
        BOOL isNoEmptySys = NO ; //至少有一个填写了，除故障码
        BOOL isEmptySys = NO ; //至少有一个为空
        for (NSUInteger j = 0; j < subSysTemp.count; j++) {
            NSDictionary *item = subSysTemp[j];
            
            if([item[@"intervalType"] isEqualToString:@"gatherInputAdd"]
               || [item[@"intervalType"] isEqualToString:@"sameIncrease"]
               || [item[@"intervalType"] isEqualToString:@"elecCodeForm"]
               ) {//除故障码
                continue;
            }
            
            if([self.pList containsObject:item]) {
                continue;
            }
            if ([self array:faultTemp item:item]) {
                continue;
            }
            if([item[@"intervalType"] isEqualToString:@"form"]){
                NSDictionary *intervalRange = item[@"intervalRange"];
                NSArray *addItems = item[@"addItems"];
                NSArray *list = intervalRange[@"list"];
                if(!addItems || addItems.count == 0){
                    if (!isEmptySys) {
                        firstEmptySelction = section;
                        firstEmptyRow = j;
                    }
                    isEmptySys = YES;
                }else{
                    if(list.count == 1){
                        for (NSInteger i = 0; addItems.count > i; i++) {
                            NSDictionary *vauleItem = addItems[i];
                            if ([vauleItem[@"val"] isEqualToString:@""]) {
                                if (!isEmptySys) {
                                    firstEmptySelction = section;
                                    firstEmptyRow = j;
                                }
                                isEmptySys = YES;
                                break;
                            }
                        }
                    }else{
                        for (NSInteger i = 0; addItems.count > i; i++) {
                            NSDictionary *vauleItem = addItems[i];
                            if ([vauleItem[@"val"] isEqualToString:@""] || [vauleItem[@"name"] isEqualToString:@""]) {
                                if (!isEmptySys) {
                                    firstEmptySelction = section;
                                    firstEmptyRow = j;
                                }
                                isEmptySys = YES;
                                break;
                            }
                        }
                    }
                }
            }else{
                if (item[@"value"] || item[@"sel"]) {
                    isNoEmptySys = YES;
                    isOnlyOne = YES;
                }else{
                    if (!isEmptySys) {
                        firstEmptySelction = section;
                        firstEmptyRow = j;
                    }
                    isEmptySys = YES;
                }
            }
            if (isNoEmptySys && isEmptySys) {
                NSDictionary *item = subSysTemp[firstEmptyRow];
                NSDictionary *intervalRange = item[@"intervalRange"];
                NSArray *list;
                if([intervalRange isKindOfClass:[NSDictionary class]]){
                    list = intervalRange[@"list"];
                }
                if (list && ![item[@"intervalType"] isEqualToString:@"form"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请选择 %@",  item[@"projectName"]]];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                }
                
                [self auto2Row:firstEmptyRow inSection:section];
                return NO;
            }
        }
        
        BOOL isFaultFill = NO;//故障码搜索项是否填写
        NSInteger faultEmpty = -1;//故障码搜索项是否填写
        for (int j = 0; j < faultTemp.count; j++) {
            NSDictionary *item = faultTemp[j];
            if (item[@"value"] || item[@"sel"]) {
                isFaultFill = YES;
                break;
            }else{
                if (faultEmpty == -1) {
                    faultEmpty = j;
                }
            }
        }
        
        if (!isFaultFill && faultEmpty >= 0) {
            NSDictionary *item = faultTemp[faultEmpty];
            NSInteger index = 0;
            for (NSInteger row = 0; row < subSysTemp.count; row++) {
                if (subSysTemp[row] == item) {
                    index = row;
                    break;
                }
            }
            [MBProgressHUD showError:@"故障码选项至少选择一项"];
            [self auto2Row:index - 1 inSection:section];
            return NO;
        }
    }
    
    if (!isOnlyOne) {
        [MBProgressHUD showError:@"请填写数据"];
        return NO;
    }
    return YES;
}

- (BOOL)checkExtredIsSaved{//是否保存故障码
    for (NSUInteger i = 0; i < _sysAr.count; i++) {
        NSMutableDictionary *sys = _sysAr[i];
        NSArray *subSys = sys[@"subSys"];
        
        for (NSUInteger j = 0; j < subSys.count; j++) {
            NSMutableDictionary *itemInfo = subSys[j];
            NSString *intervalType = itemInfo[@"intervalType"];
            NSString *projectCheckType = itemInfo[@"projectCheckType"];
            if (([intervalType isEqualToString:@"gatherInputAdd"]
                 || [intervalType isEqualToString:@"elecCodeForm"])
                && [projectCheckType isEqualToString:@"extWarrantyDetection"]) {
                NSMutableArray *addItems = itemInfo[@"addItems"];
                NSMutableArray *vals = [@[]mutableCopy];
                NSArray *codeValB = itemInfo[@"codeValB"];
                if ((!addItems || addItems.count == 0) && (!codeValB || codeValB.count == 0)) {
                    continue;
                }
                for (NSDictionary *info in addItems)
                {
                    [vals addObject:info[@"val"]];
                    
                }
                
                if (![codeValB isEqualToArray:vals]) {
                    [self auto2Row:j inSection:i];
                    [MBProgressHUD showError:@"请保存故障码"];
                    return NO;
                }
            }
        }
    }
    return YES;
}


- (NSArray*)verificationData{
    
    NSMutableArray *initialSurveyVal =  [@[] mutableCopy];
    
    NSString *billType = self.orderInfo[@"billType"];
    // isWB是否必须要填写项（即value值不能为空）
    BOOL isWB = [billType isEqualToString:@"W"] || [billType isEqualToString:@"P"] || [billType isEqualToString:@"D"] || ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"]  || [billType isEqualToString:@"A"]);
    BOOL isTypeK = [billType isEqualToString:@"K"];
    
    //至少有一个填写了，包括自动填充 空，除故障码
    BOOL isOnlyOne = NO ;
    
    BOOL isLeastOne = NO ; //系统至少有一个有数据了，除故障码
    for (NSUInteger i = 0; i < _sysAr.count; i++) {
        
        NSDictionary *sys = _sysAr[i];
        NSArray *subSys = [self delLow2Sys:sys[@"subSys"]];
        
        BOOL isLeastSys = NO ; //子系统至少有一个填写了，除故障码
        BOOL isPreEmptySys = YES ; //至少有一个为空

        NSInteger isPreEmptyIndex = -1 ; //前一个空值，下标
        
        for (NSUInteger j = 0; j < subSys.count; j++) {
            
            NSDictionary *item = subSys[j];
            NSNumber *sel = item[@"sel"];
            NSString *isRequir = item[@"isRequir"];
            NSDictionary *intervalRange = item[@"intervalRange"];
            
            if ((id)intervalRange == [NSNull null]) {
                NSString *value = item[@"value"];
                if ((value.length == 0 || !value) && [isRequir isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                    [self auto2Row:j inSection:i];
                    return nil;
                }else{
                    if (!value && isWB) {
                        isPreEmptySys = NO;
                        isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                        continue;
                    }
                    if (!value){
                        value = @"";
                    }else{
                        isLeastOne = YES;
                    }
                    NSString *projectId = item[@"id"];
                    if (!projectId) {
                        projectId = item[@"projectId"];
                    }
                    NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                           @"projectVal" : value} mutableCopy];
                    NSString *type = item[@"type"];
                    if (type) {
                        [projectValue setObject:type forKey:@"type"];
                    }
                    [initialSurveyVal addObject:projectValue];
                    isLeastSys = YES;
                    isOnlyOne = YES;
                }
            }else if([item[@"intervalType"] isEqualToString:@"gatherInputAdd"]
                     || [item[@"intervalType"] isEqualToString:@"sameIncrease"]
                     || [item[@"intervalType"] isEqualToString:@"elecCodeForm"])
            {
                
                NSArray *addItems = item[@"addItems"];
                //                    value = @"2017-05";
                if ((addItems.count == 0 || !addItems) && [isRequir isEqualToString:@"1"]) {
                    [MBProgressHUD showError:@"添加故障码"];
                    [self auto2Row:j inSection:i];
                    return nil;
                }else{
                    if (!addItems && isWB) {
                        continue;
                    }
                    if (!addItems){
                        addItems = @[];
                    }else{
                        isLeastOne = YES;
                    }
                    NSString *projectId = item[@"id"];
                    if (!projectId) {
                        projectId = item[@"projectId"];
                    }
                    NSString *value = @"";
                    if ((((NSArray *)intervalRange).count == 1)) {
                        for (NSDictionary *item in addItems) {
                            NSString *val = item[@"val"];
                            if ([val isEqualToString:@""]) {
                                continue;
                            }
                            if ([value isEqualToString:@""]) {
                                value = [NSString stringWithFormat:@"%@",val];
                            }else{
                                value = [NSString stringWithFormat:@"%@,%@", value, val];
                            }
                        }
                    }else{
                        for (NSDictionary *item in addItems) {
                            NSString *name = item[@"name"];
                            NSString *val = item[@"val"];
                            if ([name isEqualToString:@""] && [val isEqualToString:@""]) {
                                continue;
                            }
                            if ([name isEqualToString:@""]) {
                                name = val;
                            }
                            if ([val isEqualToString:@""]) {
                                val = name;
                            }
                            NSString *unit = @"";
                            if([item[@"intervalType"] isEqualToString:@"sameIncrease"]){
                                unit = intervalRange[@"unit"];
                            }
                            if ([value isEqualToString:@""]) {
                                if (unit) {
                                    value = [NSString stringWithFormat:@"%@-%@%@", name, val, unit];
                                }else{
                                    value = [NSString stringWithFormat:@"%@-%@", name, val];
                                }
                            }else{
                                if (unit) {
                                    value = [NSString stringWithFormat:@"%@,%@-%@%@", value, name, val, unit];
                                }else{
                                    value = [NSString stringWithFormat:@"%@,%@-%@", value, name, val];
                                }
                            }
                        }
                    }
                    NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                           @"projectVal" : value} mutableCopy];
                    NSString *type = item[@"type"];
                    if (type) {
                        [projectValue setObject:type forKey:@"type"];
                    }
                    [initialSurveyVal addObject:projectValue];
                    //                    isOnlyOne = YES;
                }
            }else if([item[@"intervalType"] isEqualToString:@"form"]){
                
                NSArray *addItems = item[@"addItems"];
                if ((addItems.count == 0 || !addItems) && [isRequir isEqualToString:@"1"]) {
                    [MBProgressHUD showError:@"添加项目"];
                    [self auto2Row:j inSection:i];
                    return nil;
                }else{
                    if (!addItems && isWB) {
                        continue;
                    }
                    if (!addItems){
                        addItems = @[];
                    }else{
                        isLeastOne = YES;
                    }
                    NSString *projectId = item[@"id"];
                    if (!projectId) {
                        projectId = item[@"projectId"];
                    }
                    NSString *value = @"";
                    NSArray *list = intervalRange[@"list"];
                    if(list.count == 1){
                        NSDictionary *unitInfo = list[0];
                        for (NSDictionary *item in addItems) {
                            NSString *val = item[@"val"];
                            if ([val isEqualToString:@""]) {
                                [MBProgressHUD showError:@"请填写数据"];
                                [self auto2Row:j inSection:i];
                                return nil;
                            }
                            
                            if ([value isEqualToString:@""]) {
                                value = [NSString stringWithFormat:@"%@%@", val, unitInfo[@"unit"]];
                            }else{
                                value = [NSString stringWithFormat:@"%@,%@%@", value, val, unitInfo[@"unit"]];
                            }
                        }
                        
                    }else{
                        
                        NSDictionary *unitInfo = list[0];
                        NSDictionary *unitInfo2 = list[0];
                        for (NSDictionary *item in addItems) {
                            NSString *name = item[@"name"];
                            NSString *val = item[@"val"];
                            if ([name isEqualToString:@""] || [val isEqualToString:@""]) {
                                [MBProgressHUD showError:@"请填写数据"];
                                [self auto2Row:j inSection:i];
                                return nil;
                            }
                            
                            if ([value isEqualToString:@""]) {
                                value = [NSString stringWithFormat:@"%@%@-%@%@", name, unitInfo[@"unit"], val, unitInfo2[@"unit"]];
                            }else{
                                value = [NSString stringWithFormat:@"%@,%@%@-%@%@", value, name, unitInfo[@"unit"], val, unitInfo2[@"unit"]];
                            }
                        }
                    }
                    
                    NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                           @"projectVal" : value} mutableCopy];
                    NSString *type = item[@"type"];
                    if (type) {
                        [projectValue setObject:type forKey:@"type"];
                    }
                    [initialSurveyVal addObject:projectValue];
                    //                    isOnlyOne = YES;
                }
            }else if([intervalRange isKindOfClass:[NSDictionary class]]){
                
                NSArray *list = intervalRange[@"list"];
                NSString *ajaxUrl = intervalRange[@"ajaxUrl"];
                if(ajaxUrl){
                    NSDictionary *value = item[@"valueSel"];
                    if (!value && [isRequir isEqualToString:@"1"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"请选择 %@",  item[@"projectName"]]];
                        [self auto2Row:j inSection:i];
                        return nil;
                    }else{
                        NSString *projectId = item[@"id"];
                        if (!projectId) {
                            projectId = item[@"projectId"];
                        }
                        
                        if (!value && isWB) {
                            isPreEmptySys = NO;
                            isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                            continue;
                        }
                        if (!value) {
                            value = @{@"value" : @"",
                                      @"name" : @""};
                        }else{
                            isLeastOne = YES;
                        }
                        NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                               @"projectVal" : value[@"value"],
                                                               @"projectOptionName" : value[@"name"]} mutableCopy];
                        NSString *type = item[@"type"];
                        if (type) {
                            [projectValue setObject:type forKey:@"type"];
                        }
                        [initialSurveyVal addObject:projectValue];
                        isLeastSys = YES;
                        isOnlyOne = YES;
                    }
                }else if (list) {
                    if (!sel && [isRequir isEqualToString:@"1"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"请选择 %@",  item[@"projectName"]]];
                        [self auto2Row:j inSection:i];
                        return nil;
                    }else{
                        __block NSDictionary *itemValue;
                        if (sel) {
                            NSString *sel_value = [item valueForKey:@"sel_value"];
                            if (sel_value) {
                                [list enumerateObjectsUsingBlock:^(NSMutableDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if([[obj valueForKey:@"value"] isEqualToString:sel_value]){
                                        itemValue = obj;
                                        *stop = YES;
                                    }
                                }];
                            }
                            else itemValue = list[sel.integerValue];
                        }
                        //                        NSDictionary *itemValue = list[0];
                        NSString *projectId = item[@"id"];
                        if (!projectId) {
                            projectId = item[@"projectId"];
                        }
                        if (!itemValue && isWB) {
                            isPreEmptySys = NO;
                            isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                            continue;
                        }
                        if (!itemValue) {
                            itemValue = @{@"value" : @"",
                                          @"name" : @""};
                        }else{
                            isLeastOne = YES;
                        }
                        // 是否联动
                        BOOL isRelate = (!intervalRange[@"isChild"] || [intervalRange[@"isChild"] intValue] != 1) ? NO : YES;
                        if (!isRelate || [sel intValue] == 0) {
                            NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                                   @"projectVal" : itemValue[@"value"],
                                                                   @"projectOptionName" : itemValue[@"name"]} mutableCopy];
                            NSString *type = item[@"type"];
                            if (type) {
                                [projectValue setObject:type forKey:@"type"];
                            }
                            [initialSurveyVal addObject:projectValue];
                            isLeastSys = YES;
                            isOnlyOne = YES;
                        }
                    }
                }else{
                    NSString *value = item[@"value"];
                    if ((value.length == 0 || !value) && [isRequir isEqualToString:@"1"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                        [self auto2Row:j inSection:i];
                        return nil;
                    }else{
                        // value没有填写要求必须填写项时
                        if (!value && isWB) {
                            isPreEmptySys = NO;
                            isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                            continue;
                        }
                        if (!value){
                            value = @"";
                        }else{
                            isLeastOne = YES;
                        }
                        NSString *projectId = item[@"id"];
                        if (!projectId) {
                            projectId = item[@"projectId"];
                        }
                        NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                               @"projectVal" : value} mutableCopy];
                        NSString *type = item[@"type"];
                        if (type) {
                            [projectValue setObject:type forKey:@"type"];
                        }
                        [initialSurveyVal addObject:projectValue];
                        isLeastSys = YES;
                        isOnlyOne = YES;
                    }
                }
            }else if([item[@"intervalType"] isEqualToString:@"gangedAjaxSelect"]) {
                NSDictionary *value = item[@"valueSel"];
                NSDictionary *value2 = item[@"valueSel2"];
                if ((!value || !value2) && [isRequir isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请选择 %@",item[@"projectName"]]];
                    [self auto2Row:j inSection:i];
                    return nil;
                }else{
                    NSString *projectId = item[@"id"];
                    if (!projectId) {
                        projectId = item[@"projectId"];
                    }
                    
                    if ((!value || !value2) && isWB) {
                        isPreEmptySys = NO;
                        isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                        continue;
                    }
                    if (!value) {
                        value = @{@"cityId" : @"",
                                  @"name" : @""};
                    }else{
                        isLeastOne = YES;
                    }
                    
                    if (!value2) {
                        value2 = @{@"cityId" : @"",
                                   @"name" : @""};
                    }else{
                        isLeastOne = YES;
                    }
                    NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                           @"projectVal" : [NSString stringWithFormat:@"%@-%@", value[@"cityId"], value2[@"cityId"]],
                                                           @"projectOptionName" : [NSString stringWithFormat:@"%@-%@", value[@"name"], value2[@"name"]]} mutableCopy];
                    [initialSurveyVal addObject:projectValue];
                    isLeastSys = YES;
                    isOnlyOne = YES;
                }
            }else {//intervalRange == @""
                NSString *value = item[@"value"];
                //                    value = @"2017-05";
                if ((value.length == 0 || !value) && [isRequir isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                    [self auto2Row:j inSection:i];
                    return nil;
                }else{
                    if (!value && isWB) {
                        isPreEmptySys = NO;
                        isPreEmptyIndex = ((isPreEmptyIndex == -1) ? (j) : (isPreEmptyIndex));
                        continue;
                    }
                    if (!value){
                        value = @"";
                    }else{
                        isLeastOne = YES;
                    }
                    NSString *projectId = item[@"id"];
                    if (!projectId) {
                        projectId = item[@"projectId"];
                    }
                    NSMutableDictionary *projectValue = [@{@"projectId" : projectId,
                                                           @"projectVal" : value} mutableCopy];
                    NSString *type = item[@"type"];
                    if (type) {
                        [projectValue setObject:type forKey:@"type"];
                    }
                    [initialSurveyVal addObject:projectValue];
                    isLeastSys = YES;
                    isOnlyOne = YES;
                }
            }
        }
        if (isTypeK) {
            if (!isPreEmptySys && isLeastSys) {
                NSDictionary *item = subSys[isPreEmptyIndex];
                NSDictionary *intervalRange = item[@"intervalRange"];
                NSArray *list;
                if([intervalRange isKindOfClass:[NSDictionary class]]){
                    list = intervalRange[@"list"];
                }
                if (list) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请选择 %@",  item[@"projectName"]]];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@",  item[@"projectName"]]];
                }
                [self auto2Row:isPreEmptyIndex inSection:i];
                return nil;
            }
        }
    }
    
    // 刹车数据
    if (self.isHasPhoto) {
        NSMutableDictionary *brakeDict = [self getBrakeDistance];
        [initialSurveyVal addObject:brakeDict];
        NSString *brake_value = brakeDict[@"projectVal"];
        if (![NSString stringIsNull:brake_value]) {
            isOnlyOne = YES;
            isLeastOne = YES;
        }
    }
    
    // 空调泄露选项类型数据
        NSMutableDictionary *delayCareLeakOptionData = [YHStoreTool ShareStoreTool].delayCareLeakOptionData;
        NSMutableArray *arrayItem = [NSMutableArray array];
        for (int i = 0; i<delayCareLeakOptionData.allKeys.count; i++) {
            
            NSMutableString *resultStr = [NSMutableString string];
            NSString *key = delayCareLeakOptionData.allKeys[i];
            NSMutableArray *valueArr = delayCareLeakOptionData[key];
            for (int j = 0; j<valueArr.count; j++) {
                NSMutableDictionary *item = valueArr[j];
                if (item[@"value"] && ![item[@"value"] isEqualToString:@""] && ![item[@"value"] isKindOfClass:[NSNull class]]) {
                    [resultStr appendString:item[@"value"]];
                    if (j != valueArr.count -1) {
                        [resultStr appendString:@","];
                    }
                }
            }
            
            if (![resultStr isKindOfClass:[NSNull class]] && resultStr && ![resultStr isEqualToString:@""]) {
                NSMutableDictionary *item = [NSMutableDictionary dictionary];
                [item setValue:key forKey:@"id"];
                [item setValue:resultStr forKey:@"value"];
                [arrayItem addObject:item];
            }
        }
        
        if ([arrayItem isKindOfClass:[NSNull class]] || !arrayItem || !arrayItem.count) {
            if (self.leakReportArr.count) {
                // 取出第一个
                NSDictionary *firstItem = self.leakReportArr.firstObject;
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@至少选择一项",firstItem[@"projectName"]] toView:self.view];
                NSIndexPath *indexPath = firstItem[@"indexPath"];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                return nil;
            }
        }else{
            isOnlyOne = YES;
            isLeastOne = YES;
            for (int i = 0; i<arrayItem.count; i++) {
                NSString *projectId = arrayItem[i][@"id"];
                NSString *projectVal = arrayItem[i][@"value"];
                NSMutableDictionary *projectItem = [@{
                                                      @"projectId":projectId,
                                                      @"projectVal":projectVal
                                                      } mutableCopy];
                
                [initialSurveyVal addObject:projectItem];
            }
            
            for (int i = 0; i<self.leakReportArr.count; i++) {
                NSDictionary *item = self.leakReportArr[i];
               BOOL isExist = [self checkLeakReportItemExistInCatheData:item[@"id"]];
                if (!isExist) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@至少选择一项",item[@"projectName"]] toView:self.view];
                NSIndexPath *indexPath = item[@"indexPath"];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    break;
                }
            }
        }
    
    if (isTypeK || self.isHasPhoto) {
        if (!isOnlyOne || !isLeastOne) {
            if (!([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"] || !self.isHasPhoto)) {
                [MBProgressHUD showError:@"请填写数据"];
                return nil;
            }
            return initialSurveyVal;
        }
    }
    
    return initialSurveyVal;
}
- (BOOL)checkLeakReportItemExistInCatheData:(NSString *)reportId{
    
     NSMutableDictionary *delayCareLeakOptionData = [YHStoreTool ShareStoreTool].delayCareLeakOptionData;
    BOOL isExist = NO;
    for (int i = 0; i<delayCareLeakOptionData.allKeys.count; i++) {
        NSString *key = delayCareLeakOptionData.allKeys[i];
        if ([key isEqualToString:reportId]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}
#pragma mark - J002 工单下获取上传数据参数 ---
- (NSMutableDictionary *)getBrakeDistance{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *initialSurveyCheckProject = _sysData[@"initialSurveyCheckProject"];
    NSDictionary *billInfo =  _sysData[@"pBillInfo"];
    NSInteger billId = [billInfo[@"billId"] integerValue];
    for (int i = 0; i<initialSurveyCheckProject.count; i++) {
        NSDictionary *itemDict = initialSurveyCheckProject[i];
        NSString *code = itemDict[@"code"];
        if ([code isEqualToString:@"brake_distance"]) {
            
            [dict setObject:itemDict[@"id"]forKey:@"projectId"];
            
            NSString *key = [NSString stringWithFormat:@"%ld",billId];
            key = [key stringByAppendingString:@"YHFour_distance_brake"];
            
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            value = value == nil ? @"" : value;
            [dict setObject:value forKey:@"projectVal"];
        }
    }
    
    return dict;
}


- (IBAction)comfirmAction:(id)sender
{

    if (([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"])) {
        if (![self checkExtredIsSaved] || ![self checkEngineWaterTProjectList] || ![self checkExtrendVerification]) {
            return;
        }
    }
    if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])) {
        if ([self checkNewWholeALLEmpty]) {
            return;
        }
    }
    
    NSArray *initialSurveyVal =  [self verificationData];
    if (!initialSurveyVal) {
        return;
    }
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    
    if ([self.orderInfo[@"nowStatusCode"] isEqualToString:@"initialSurvey"]
        || [self.orderInfo[@"nowStatusCode"] isEqualToString:@"matchInitialSurvey"]
        || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeMakeMode"]){
        
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         saveWriteDepthToCloud:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         requestData:initialSurveyVal
         onComplete:^(NSDictionary *info) {
             
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                 YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                 NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                 [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                 controller.orderInfo = billStatus;
//                 controller.titleStr = @"提交成功";
//                 [weakSelf.navigationController pushViewController:controller animated:YES];
                 
                 [self submitDataSuccessToJump:billStatus pay:NO message:@"提交成功"];
                 
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
        
    }else{
        YHOrderModel model = YHOrderModelW;
        
        NSMutableArray *projectCheckType = [@[]mutableCopy];
        if ([self.orderInfo[@"billType"] isEqualToString:@"P"]) {
            model = YHOrderModelP;
            for (NSDictionary *project in _sysAr) {
                [projectCheckType addObject:project[@"projectCheckType"]];
            }
        }
        if ([self.orderInfo[@"billType"] isEqualToString:@"J"]) {
            model = YHOrderModelJ;
        }else if ([self.orderInfo[@"billType"] isEqualToString:@"E"]) {
            model = YHOrderModelE;
        }else if ([self.orderInfo[@"billType"] isEqualToString:@"V"]) {
            model = YHOrderModelV;
        }else if (([self.orderInfo[@"billType"] isEqualToString:@"Y"] || [self.orderInfo[@"billType"] isEqualToString:@"Y001"] || [self.orderInfo[@"billType"] isEqualToString:@"Y002"] || [self.orderInfo[@"billType"] isEqualToString:@"A"])) {
            model = YHOrderExtrend;
        }else if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])) {
            model = YHOrderModelK;
        }else if (self.isHasPhoto) {
            model = YHOrderModelJ002;
        }
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         saveInitialSurvey:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         checkProjectType:projectCheckType
         initialSurveyVal:initialSurveyVal
         orderModel:model
         isReplace:YES
         onComplete:^(NSDictionary *info) {
             
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                 YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                 NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                 [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                 controller.orderInfo = billStatus;
//                 controller.titleStr = @"提交成功";
//                 controller.pay = YES;
//                 [self.navigationController pushViewController:controller animated:YES];
                 
                 [self submitDataSuccessToJump:billStatus pay:YES message:@"提交成功"];
                 
#pragma mark  -  图片上传
                 NSString *billId = [self.orderInfo valueForKey:@"id"];//[[_sysData valueForKey:@"pBillInfo"] valueForKey:@"billId"];
                 [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",billId]];
//                 [[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:^{
//                     ;
//                 }];
                 [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:billId didHandle:nil];
                 
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLogERROR(@"");
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

- (void)timeout:(id)obj
{
    NSInteger count = self.times - 1;
    if (count > 0) {
        self.times -= 1;
        self.timeoutL.text = [NSString stringWithFormat:@"%ld秒后回到工单详情\n或点击下方按钮回到列表", (long)count];
    }else{
        [self.timer  invalidate];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
        controller.functionKey = YHFunctionIdNewWorkOrder;
        controller.orderInfo = self.orderInfo;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

- (IBAction)faultCodeSaveAction:(UIButton*)sender
{
    [self updataFaultExtrendSection:sender.tag];
}

- (IBAction)backAction:(id)sender
{
    [self.timer  invalidate];
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationOrderListChange
     object:Nil
     userInfo:nil];
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHOrderListController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            isBack = YES;
        }
    }];
    
    if (!isBack) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)selComAction:(id)sender
{
    if ([_selProjectInfo[@"dataType"] isEqualToString:@"date"]) {
        NSDate *selected = [_datePicker date];
        [_selProjectInfo setObject:[YHTools stringFromDate:selected byFormatter:@"yyyy-MM"] forKey:@"value"];
    }else{
        NSNumber *tag = _selProjectInfo[@"tag"];
        
        if (tag.integerValue == 1) {
            NSDictionary *info =  _selProjects[_projectSelectRow];
            [_selProjectInfo setObject:[info mutableCopy] forKey:@"valueSel2"];
        }else{
            NSDictionary *info =  _selProjects[_projectSelectRow];
            [_selProjectInfo setObject:[info mutableCopy] forKey:@"valueSel"];
        }
    }
    self.selBox.hidden = YES;
    [self.tableView reloadData];
}

- (IBAction)cancelAction:(id)sender
{
    self.selBox.hidden = YES;
}

- (IBAction)carSelAllAction:(UIButton*)button
{
    NSUInteger tag = button.tag;
    NSUInteger section = tag >> 16;
    NSMutableDictionary *sysInfo = _sysAr[section];
    YHCarAll state = tag & 0XFFFF;
    [sysInfo setObject:@(state) forKey:@"state"];
    NSString *title = sysInfo[@"title"];
    if (state == YHCarAllLeft) {
        for (NSMutableDictionary *item in [self getCarAllInfo:title]) {
            NSDictionary *intervalRange  = item[@"intervalRange"];
            if([intervalRange isKindOfClass:[NSDictionary class]]){
                NSArray *list = intervalRange[@"list"];
                if (list.count >= 2 || !list) {
                    [item setObject:@0 forKey:@"sel"];
                }
            }
        }
    }
    
    if (state == YHCarAllRight) {
        for (NSMutableDictionary *item in [self getCarAllInfo:title]) {
            NSDictionary *intervalRange  = item[@"intervalRange"];
            if([intervalRange isKindOfClass:[NSDictionary class]]){
                NSArray *list = intervalRange[@"list"];
                if (list.count >= 2 || !list) {
                    if (([self.orderInfo[@"billType"] isEqualToString:@"K"] || [self.orderInfo[@"billType"] isEqualToString:@"J001"])) {
                        [item removeObjectForKey:@"sel"];
                    }else{
                        [item setObject:@1 forKey:@"sel"];
                    }
                }
            }
        }
    }
    
    if (state == YHCarAllCenter) {
        return;
    }
    
    [_tableView reloadData];
}

- (NSArray *)getCarAllInfo:(NSString*)sys
{
    for (NSDictionary *item in _sysAr) {
        if ([item[@"title"] isEqualToString:sys]) {
            return item[@"subSys"];
        }
    }
    return nil;
}

- (void)checkCarAllInfo:(NSUInteger)index
{
    BOOL isLeft = NO;
    BOOL isCenter = NO;
    BOOL isRight = NO;
    NSMutableDictionary *sysInfo = _sysAr[index];
    NSString *title = sysInfo[@"title"];
    for (NSDictionary *info in [self getCarAllInfo:title]) {
        NSDictionary *intervalRange  = info[@"intervalRange"];
        if([intervalRange isKindOfClass:[NSDictionary class]]){
            NSArray *list = intervalRange[@"list"];
            if (list.count < 2 || !list) {
                continue;
            }
        }else{
            continue;
        }
        
        NSNumber *sel = info[@"sel"];
        if (!sel.boolValue) {
            isLeft = YES;
        }
        if (!sel) {
            isCenter = YES;
        }
        if (sel.boolValue) {
            isRight = YES;
        }
    }
    
    YHCarAll state = YHCarAllCenter;
    if (isCenter || (isLeft && isRight)) {
        state = YHCarAllCenter;
    }else if (isLeft && !isRight){
        state = YHCarAllLeft;
    }else{
        state = YHCarAllRight;
    }
    [sysInfo setObject:@(state) forKey:@"state"];
    [_tableView reloadData];
}

@end
