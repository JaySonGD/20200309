//
//  YHDepthController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/2.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHDepthController.h"
#import "YHEditRepairCell.h"
#import "YHDepthEditeController.h"
#import "YHCommon.h"
#import "NSArray+MutableDeepCopy.h"
#import "YHInitialInspectionController.h"

#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHSuccessController.h"
#import "YHInitialInspectionController.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "YHWebFuncViewController.h"

#import <Masonry.h>
#import "YHEditDiagnoseResultVc.h"
#import "YHSetPartsConsuMaterialVC.h"

#import "YHStoreTool.h"

#import "UIViewController+sucessJump.h"

extern NSString *const notificationRepairAdd;
extern NSString *const notificationRepairDel;
extern NSString *const notificationRepairModelAddRepair;
extern NSString *const notificationDepthAdd;
@interface YHDepthController () <YHRepairEditDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)copyResultAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *resultTV;
@property (weak, nonatomic) IBOutlet UITableView *eeditRepairTB;
@property (weak, nonatomic) IBOutlet UIView *editRepairBox;
@property (strong, nonatomic)NSMutableArray *repairs;
@property (weak, nonatomic) IBOutlet UIButton *resultB;

@property (weak, nonatomic) IBOutlet UILabel *resultFL;
@property (nonatomic)NSInteger selCloudIndex;//-1 无| 1 云 | 2 本地
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet UILabel *resultL;
@property (weak, nonatomic) IBOutlet UIButton *tableRightB;
@property (weak, nonatomic) IBOutlet UIView *tableLeftLine;
@property (weak, nonatomic) IBOutlet UIView *tableRightLine;
@property (weak, nonatomic) IBOutlet UIButton *tableLeftB;
- (IBAction)tablLeftAction:(id)sender;
- (IBAction)tablRightAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *repairBoxV;
@property (weak, nonatomic) IBOutlet UIButton *cloudSelB;
@property (weak, nonatomic) IBOutlet UIButton *cloudDescB;
@property (weak, nonatomic) IBOutlet UIButton *cloudEditB;
@property (weak, nonatomic) IBOutlet UILabel *cloudDateL;
@property (weak, nonatomic) IBOutlet UIView *loudLineL;

/** 诊断思路 */
@property (weak, nonatomic) IBOutlet UIView *diagnosisThink;
/** 诊断结果 */
@property (weak, nonatomic) IBOutlet UIView *diagnosisResultView;

@property (weak, nonatomic) IBOutlet UIButton *storeSelB;
@property (weak, nonatomic) IBOutlet UIButton *storeDescB;
@property (weak, nonatomic) IBOutlet UIButton *storeEditB;
@property (weak, nonatomic) IBOutlet UILabel *storeDateL;
@property (weak, nonatomic) IBOutlet UIView *storeLineL;

@property (weak, nonatomic) IBOutlet UITextView *diagnosisTV;


@property (strong, nonatomic)NSString *checkResult;//诊断结果
@property (strong, nonatomic)NSString *diagnosisResult;//诊断思路

@property (weak, nonatomic) IBOutlet UIButton *diagnosisB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repairtableViewTopLC;
- (IBAction)diagnosisAction:(id)sender;
@property (nonatomic)NSInteger selProgramme;// 0 没有选择  1 云 2 本地
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeTopLC;
- (IBAction)cloudEditAction:(id)sender;

- (IBAction)cloudSelAction:(id)sender;
- (IBAction)storeSelAction:(id)sender;
- (IBAction)storeEditAction:(id)sender;
/** 下拉箭头 */
@property(nonatomic, weak) IBOutlet UIButton *arrowBtn;
/** 是否是配件耗材的维修方式 */
@property (nonatomic, assign) BOOL isMinePartAndProjectWay;

@property (nonatomic, strong) NSMutableArray *modifyDataArr;
/** 本地维修方式时的编辑按钮 */
@property (nonatomic, weak) UIButton *editResultBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DiagnosisResultViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowBtnHeight;

@property (nonatomic, strong) NSMutableArray *catchDataArr;

@end

@implementation YHDepthController
@dynamic orderInfo;

- (NSMutableArray *)modifyDataArr{
    if (!_modifyDataArr.count) {
        _modifyDataArr = [NSMutableArray array];
    }
    return _modifyDataArr;
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    kViewRadius(_repairBoxV, 10);
//}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _editRepairBox.backgroundColor = YHBackgroundColor;
//    kViewRadius(_diagnosisResultView, 10);

     [[YHStoreTool ShareStoreTool] setOrderInfo:self.orderInfo];
    // 获取最新数据
    [self getNewBillData];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationRepairAdd:) name:notificationRepairAdd object:nil];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationRepairDel:) name:notificationRepairDel object:nil];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationRepairModelAddRepair:) name:notificationRepairModelAddRepair object:nil];
    [center addObserver:self selector:@selector(notificationDepthAdd:) name:notificationDepthAdd object:nil];
    _editRepairBox.hidden = !_isRepair;
    
    
    // 诊断结果编辑按钮
    UIButton *editResultBtn = [[UIButton alloc] init];
    self.editResultBtn = editResultBtn;
    [editResultBtn setImage:[UIImage imageNamed:@"setPartEdit"] forState:UIControlStateNormal];
    [_editRepairBox addSubview:editResultBtn];
    [editResultBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [editResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.right.equalTo(editResultBtn.superview).offset(-20);
        make.bottom.equalTo(_resultFL.mas_bottom);
    }];
//    // 箭头按钮
//    UIButton *arrowBtn = [[UIButton alloc] init];
//    arrowBtn.backgroundColor = [UIColor whiteColor];
    [self.arrowBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];
//    self.arrowBtn = arrowBtn;
    [self.arrowBtn addTarget:self action:@selector(arrowBtnTouchUpInEvent) forControlEvents:UIControlEventTouchUpInside];
//    [_editRepairBox addSubview:arrowBtn];
//    arrowBtn.frame = CGRectMake(_resultTV.frame.origin.x, CGRectGetMaxY(_resultTV.frame) - 15, _resultTV.frame.size.width, 15);
//    _resultTV.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"modeQuote"]//编辑人工费
        ) {
        [_tableRightB setTitle:@"工时报价" forState:UIControlStateNormal];
    }else if (([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudDepthQuote"])
              || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushDepth"]//本地细检报价
              ) {
        [_tableRightB setTitle:@"编辑报价" forState:UIControlStateNormal];
    }else{
        [_tableRightB setTitle:((_isRepair)? (@"编辑维修方式") : (@"细检方案")) forState:UIControlStateNormal];
    }
    
    _selCloudIndex = -1;
    _resultL.text = @"诊断结果 诊断结果诊断结果诊断结果 诊断结果诊断结果诊断结果 诊断结果诊断结果诊断结果 诊断结果诊断结果诊断结果 诊断结果诊断结果诊断结果 诊断结果诊断结果";
    self.repairs = [@[] mutableCopy];
    if (_isRepairPrice) {
        [self tablRightAction:nil ];
        _resultFL.text = @"质保(例:2年或者5万公里)";
    }else{
        [self tablLeftAction:nil ];
    }
    // textView设置
     _resultTV.editable = NO;
    NSDictionary *temporyData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporyData[@"temporarySave"];
    NSDictionary *checkResult = temporarySave[@"checkResult"];
    self.checkResult = checkResult[@"makeResult"];
    _resultTV.text = self.checkResult;
    self.arrowBtn.hidden = _resultTV.text.length == 0 ? YES : NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNewModifyPartternUpdateView:) name:@"saveCaseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNewPartUpdateView:) name:@"addPortUpdateTableView" object:nil];
    
    [self.tableRightB setImage:nil forState:UIControlStateNormal];
    [self.tableRightB setTitleColor:YHNaviColor forState:UIControlStateSelected];
    self.tableRightB.selected = YES;
    [self.tableLeftB setImage:nil forState:UIControlStateNormal];
    [self.tableLeftB setTitleColor:YHNaviColor forState:UIControlStateSelected];
    _tableLeftLine.backgroundColor = [UIColor whiteColor];
    _tableRightLine.backgroundColor = YHNaviColor;


}
#pragma mark - 保存方案后更新tableview ---
- (void)saveNewModifyPartternUpdateView:(NSNotification *)noti{
    
        NSDictionary *mode = noti.userInfo[@"add_newModifyParttern"];

        NSMutableDictionary *repair = [NSMutableDictionary dictionary];
        [repair setValue:@1 forKey:@"repairEdit"];
        [repair setValue:@(self.repairs.count) forKey:@"repairIndex"];
        [repair setValue:[NSString stringWithFormat:@"维修方式%lu",(self.repairs.count - self.cloudRepairs.count) + 1] forKey:@"repairStr"];
        [repair setValue:mode forKey:@"repairData"];
        NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
        NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
        [repair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
        [repair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];
    
    BOOL isExit1 = NO;
    NSInteger index1 = -1;
    for (int i = 0; i<self.catchDataArr.count; i++) {
        NSDictionary *item = self.catchDataArr[i];
        //        NSDictionary *repairMode = item[@"repairData"];
        if ([item[@"repairIndex"] integerValue] == [mode[@"repairIndex"] integerValue]) {
            isExit1 = YES;
            index1 = i;
            break;
        }
    }
    
    if (!isExit1) {
        [self.catchDataArr addObject:mode];
    }else{
        [self.catchDataArr replaceObjectAtIndex:index1 withObject:mode];
    }
    
    
    BOOL isExit = NO;
    NSInteger index = -1;
    for (int i = 0; i<self.repairs.count; i++) {
        NSDictionary *item = self.repairs[i];
//        NSDictionary *repairMode = item[@"repairData"];
        if ([item[@"repairIndex"] integerValue] == [mode[@"repairIndex"] integerValue]) {
            isExit = YES;
            index = i;
            break;
        }
    }
    
    if (!isExit) {
        [self.repairs addObject:repair];
    }else{
        NSDictionary *originRepair = [self.repairs objectAtIndex:index];
        NSMutableDictionary *newOriginRepair = [NSMutableDictionary dictionaryWithDictionary:originRepair];
        [newOriginRepair setValue:mode forKey:@"repairData"];
        
        NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
        NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
        [newOriginRepair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
        [newOriginRepair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];
        
        [self.repairs replaceObjectAtIndex:index withObject:newOriginRepair];
    }
        [_eeditRepairTB reloadData];
    
    [self getNewBillData];
}
#pragma mark - 保存配件耗材后更新tableview ---
- (void)saveNewPartUpdateView:(NSNotification *)noti{
    
    NSDictionary *mode = noti.userInfo[@"addPrtUpdate"];
    NSMutableDictionary *repair = [NSMutableDictionary dictionary];
    [repair setValue:@1 forKey:@"repairEdit"];
    [repair setValue:@(self.repairs.count) forKey:@"repairIndex"];
    [repair setValue:[NSString stringWithFormat:@"维修方式%lu",(self.repairs.count - self.cloudRepairs.count) + 1] forKey:@"repairStr"];
    [repair setValue:mode forKey:@"repairData"];
    NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
    NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
    [repair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
    [repair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];
    
    BOOL isExit = NO;
    NSInteger index = -1;
    for (int i = 0; i<self.catchDataArr.count; i++) {
        NSDictionary *item = self.catchDataArr[i];
//        NSDictionary *repairMode = item[@"repairData"];
        if ([item[@"repairIndex"] integerValue] == [mode[@"repairIndex"] integerValue]) {
            isExit = YES;
            index = i;
            break;
        }
    }
    
    if (!isExit) {
        [self.catchDataArr addObject:mode];
    }else{
        [self.catchDataArr replaceObjectAtIndex:index withObject:mode];
    }
    
    
    BOOL isExitForRepair = NO;
    NSInteger indexForRepair = -1;
    for (int i = 0; i<self.repairs.count; i++) {
        NSDictionary *item = self.repairs[i];
        //        NSDictionary *repairMode = item[@"repairData"];
        if ([item[@"repairIndex"] integerValue] == [mode[@"repairIndex"] integerValue]) {
            isExitForRepair = YES;
            indexForRepair = i;
            break;
        }
    }
    
    if (!isExitForRepair) {
        [self.repairs addObject:repair];
    }else{
        
        NSDictionary *originRepair = [self.repairs objectAtIndex:indexForRepair];
        NSMutableDictionary *newOriginRepair = [NSMutableDictionary dictionaryWithDictionary:originRepair];
        [newOriginRepair setValue:mode forKey:@"repairData"];

        NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
        NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
        [newOriginRepair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
        [newOriginRepair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];

        [self.repairs replaceObjectAtIndex:indexForRepair withObject:newOriginRepair];

    }
    
    [_eeditRepairTB reloadData];
    
    [self getNewBillData];
    
}
#pragma mark - 获取最新缓存数据 ------
- (void)getNewBillData{
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] isHistory:NO onComplete:^(NSDictionary *info) {
        
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            [[YHStoreTool ShareStoreTool] setTemporaryData:data];
            NSDictionary *temporarySave = data[@"temporarySave"];
            NSDictionary *checkResult = temporarySave[@"checkResult"];
            self.checkResult = checkResult[@"makeResult"];
            //_resultTV.text = self.checkResult;
            
            [self updateTextView];
             //self.arrowBtn.hidden = _resultTV.text.length == 0 ? YES : NO;
            [_eeditRepairTB reloadData];
        }
        
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)updateTextView{
    
    if(!self.checkResult) self.checkResult = @" ";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _resultTV.attributedText = [[NSAttributedString alloc] initWithString:self.checkResult attributes:attributes];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //CGFloat numLine = [self numLineOfTextView];
        CGFloat height = _resultTV.contentSize.height;
        
        //if(numLine <= 4) _arrowBtnHeight.constant = 0;
        if(height <= 102) _arrowBtnHeight.constant = 0;

        else _arrowBtnHeight.constant = 16.0;
        //if (numLine > 4) numLine = 4;
        //CGFloat height = 24 * numLine + 6;
        if(height > 102) height = 102;
        _repairtableViewTopLC.constant = 99 - 23 + _arrowBtnHeight.constant + height - 30;
        _DiagnosisResultViewHeight.constant = _repairtableViewTopLC.constant;
        [_arrowBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];

        
        NSLog(@"%s---%f", __func__,_resultTV.contentSize.height);
    });

}

- (NSInteger)numLineOfTextView{
    float textViewWidth = _resultTV.frame.size.width;//取得文本框高度
    
    CGSize contentSize = [_resultTV.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    float numLine=ceilf(contentSize.width/textViewWidth); //计算当前文字长度对应的行数
    return numLine;
}

#pragma mark - 箭头点击事件 --
- (void)arrowBtnTouchUpInEvent{
    
    //CGFloat numLine = [self numLineOfTextView];
    CGFloat height = _resultTV.contentSize.height;
    //CGFloat height = 24 * numLine + 6;


    if([self.arrowBtn.currentImage isEqual:[UIImage imageNamed:@"setPartArrow"]]){
    //if (_repairtableViewTopLC.constant == 115) {
        //if(numLine > 7) numLine = 7;
        //CGFloat height = 24 * numLine + 6;
        if(height > (24 * 7 + 6)) height = 24 * 7 + 6;
        
        _repairtableViewTopLC.constant = 115 - 23 + height - 30;
        _DiagnosisResultViewHeight.constant = _repairtableViewTopLC.constant;

        [self.arrowBtn setImage:[UIImage imageNamed:@"setPartUpArrow"] forState:UIControlStateNormal];
    }else{

        //if(numLine > 4) numLine = 4;
        //CGFloat height = 24 * numLine + 6;
        if(height > (24 * 4 + 6)) height = 24 * 4 + 6;
        
        _repairtableViewTopLC.constant = 115 - 23 + height - 30;
        _DiagnosisResultViewHeight.constant = _repairtableViewTopLC.constant;
        
        [self.arrowBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];
    }
    
    return;
//
//    _resultTV.frame = resFrame;
//    NSLog(@"%@",NSStringFromCGRect(resFrame));
//    CGFloat arrowMargin = CGRectGetMaxY(_resultTV.frame);
//    self.arrowBtn.frame = CGRectMake(_resultTV.frame.origin.x, arrowMargin - 15, _resultTV.frame.size.width, 15);
    
//    CGRect resFrame = _resultTV.frame;
    if (_repairtableViewTopLC.constant == 120) {
//        resFrame.size.height = 208;
        _repairtableViewTopLC.constant = 120 + 151;
        _DiagnosisResultViewHeight.constant = _repairtableViewTopLC.constant;
        [self.arrowBtn setImage:[UIImage imageNamed:@"setPartUpArrow"] forState:UIControlStateNormal];
    }else{

//        resFrame.size.height = 57;
        _repairtableViewTopLC.constant = 120;
        _DiagnosisResultViewHeight.constant = _repairtableViewTopLC.constant;

        [self.arrowBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];
    }

//    _resultTV.frame = resFrame;
//    NSLog(@"%@",NSStringFromCGRect(resFrame));
//    CGFloat arrowMargin = CGRectGetMaxY(_resultTV.frame);
//    self.arrowBtn.frame = CGRectMake(_resultTV.frame.origin.x, arrowMargin - 15, _resultTV.frame.size.width, 15);

    
}

#pragma mark --------- 判断View是否显示在屏幕上 -------
- (BOOL)isDisplayedInScreen:(UIView *)view{
    if (view == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若view 隐藏
    if (view.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (view.superview == nil) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 跳转到诊断结果 ---
- (void)editBtnClick{
    if (_selCloudIndex == 1) {
        [self copyResultAction:nil];
    }else{
        YHEditDiagnoseResultVc *editResultVc = [[YHEditDiagnoseResultVc alloc] init];
        editResultVc.diagnoseResultText = self.checkResult;
        __weak typeof(self)weakSelf = self;
        editResultVc.saveSuccessBackBlock = ^(NSString *text) {
            //weakSelf.resultTV.text = text;
            weakSelf.checkResult = text;
            
            [weakSelf updateTextView];

            //self.arrowBtn.hidden = self.checkResult.length == 0 ? YES : NO;
        };
        [self.navigationController pushViewController:editResultVc animated:YES];
    }
}
- (void)repairReslutUpdata{
//    return;
    NSArray *cloudRepairModeData = self.data[@"cloudRepairModeData"];
    NSDictionary *cloudCheckResult = self.data[@"cloudCheckResultArr"];
    
    NSArray *repairModeData = self.data[@"repairModeData"];
    NSDictionary *checkResultArr = self.data[@"checkResultArr"];
    
    //CGFloat addValue = _resultTV.frame.size.height == 208 ? 151 : 0;
    //207 - 57 : 151
    //57 - 57 : 0
    CGFloat addValue = _DiagnosisResultViewHeight.constant - (99 + _arrowBtnHeight.constant);
    
    
    if (((!cloudCheckResult || !checkResultArr) && ((cloudRepairModeData && cloudRepairModeData.count != 0) || (repairModeData && repairModeData.count != 0)) && _selCloudIndex != 2)) {
        //_repairtableViewTopLC.constant = 120 + addValue;
        _repairtableViewTopLC.constant = 99 + _arrowBtnHeight.constant + addValue;

    }else{
        if (_isRepairPrice) {
            _repairtableViewTopLC.constant = 0 + addValue;
        }else{
            //_repairtableViewTopLC.constant = 120 + addValue;
            _repairtableViewTopLC.constant = 99 + _arrowBtnHeight.constant + addValue;

        }
    }
}

- (void)orderDetail{
    [super orderDetail];
   
    [self initRepairs];
    [self tablRightAction:nil];
    [self repairReslutUpdata];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)popViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击cell中的复制按钮回调 ------
- (void)notificationRepairAdd:(NSNotification*)notice{
    
    if (self.repairs.count - self.cloudRepairs.count >= 5) {
        [MBProgressHUD showError:@"最多只能添加5种维修方式" toView:self.view];
        return;
    }
    NSMutableDictionary *item = [@{}mutableCopy];
    [item addEntriesFromDictionary:[notice.userInfo mutableDeepCopy]];
    
    // 重新生成的titleId
    NSInteger titleID = self.repairs.count;
    NSUInteger repairIndex = [_repairs indexOfObject:notice.userInfo];
    BOOL isCloud = (repairIndex < self.cloudRepairs.count);
    // 同步数据
    NSDictionary *temporyData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporyData[@"temporarySave"];
    NSMutableArray *repairData = [NSMutableArray arrayWithArray:temporarySave[@"repairModeData"]];
    
    NSMutableDictionary *repairDict = [NSMutableDictionary dictionary];
    NSDictionary *originRepairData = item[@"repairData"];
    [repairDict setValue:originRepairData[@"parts"] forKey:@"parts"];
    [repairDict setValue:originRepairData[@"repairItem"] forKey:@"repairItem"];
    if (isCloud) {
        [repairDict setValue:@(titleID) forKey:@"repairIndex"];
        [repairDict removeObjectForKey:@"preId"];
    }else{
       [repairDict setValue:@(titleID) forKey:@"repairIndex"];
    }
    
    [repairData addObject:repairDict];
    NSMutableDictionary *newTemporarySave = [NSMutableDictionary dictionaryWithDictionary:temporarySave];
    [newTemporarySave setValue:repairData forKey:@"repairModeData"];
    NSMutableDictionary *newTemporyData = [NSMutableDictionary dictionaryWithDictionary:temporyData];
    [newTemporyData setValue:newTemporarySave forKey:@"temporarySave"];
    [[YHStoreTool ShareStoreTool] setTemporaryData:newTemporyData];
        
    NSDictionary *checkResultArr = temporarySave[@"checkResult"];
    [self.catchDataArr addObject:repairDict];

    // 同步网络数据
    [self saveTemporaryData:checkResultArr repairModeData:self.catchDataArr];
    NSLog(@"repairData---------------%@",repairData);
    [item setValue:repairDict forKey:@"repairData"];
    [item setObject:[NSString stringWithFormat:@"维修方式%lu", self.repairs.count + 1] forKey:@"repairStr"];
//     [_repairs addObject:item];
    [_repairs addObject:repairDict];
    
    [self refreshTableViewWithRepair];
    
    [_eeditRepairTB reloadData];
}
#pragma mark - _repair数据变动后重新刷新tableView ----
- (void)refreshTableViewWithRepair{
    
    for (int i = 0; i<_repairs.count; i++) {
        NSMutableDictionary *repair = _repairs[i];
        if (i < self. cloudRepairs.count) {
            continue;
        }
        [repair setValue:[NSString stringWithFormat:@"维修方式%lu",i+1-self.cloudRepairs.count] forKey:@"repairStr"];
    }
    [_eeditRepairTB reloadData];
}

#pragma mark - 点击cell中删除按钮回调 ----
- (void)notificationRepairDel:(NSNotification*)notice{
    
    NSDictionary *removeRepair = notice.userInfo;
    NSInteger titleId = [removeRepair[@"repairIndex"] integerValue];
    // 同步数据
    NSDictionary *temporyData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporyData[@"temporarySave"];
//    NSMutableArray *repairDataArr = [NSMutableArray arrayWithArray:temporarySave[@"repairModeData"]];
    NSMutableArray *repairDataArr = self.catchDataArr;
    BOOL isExist = NO;
    NSUInteger index = 0;
    for (int i = 0; i<repairDataArr.count; i++) {
        NSDictionary *item = repairDataArr[i];
        if ([item[@"repairIndex"] integerValue] == titleId) {
            isExist = YES;
            index = i;
        }
    }
    NSMutableArray *newRepairDataArr = [NSMutableArray arrayWithArray:repairDataArr];
    if (isExist) {
        [newRepairDataArr removeObjectAtIndex:index];
        [self.catchDataArr removeObjectAtIndex:index];
    }
    NSLog(@"newRepairDataArr=======%@ ----count------%ld",newRepairDataArr,newRepairDataArr.count);
     NSDictionary *checkResultArr = temporarySave[@"checkResult"];
    // 本地同步数据
    NSMutableDictionary *newTemporarySave = [NSMutableDictionary dictionaryWithDictionary:temporarySave];
    [newTemporarySave setValue:newRepairDataArr forKey:@"repairModeData"];
    NSMutableDictionary *newTemporyData = [NSMutableDictionary dictionaryWithDictionary:temporyData];
    [newTemporyData setValue:newTemporarySave forKey:@"temporarySave"];
    [[YHStoreTool ShareStoreTool] setTemporaryData:newTemporyData];
    [_repairs removeObject:notice.userInfo];
    // 网络同步网络数据
    [self saveTemporaryData:checkResultArr repairModeData:self.catchDataArr];
    
    [self refreshTableViewWithRepair];
    [_eeditRepairTB reloadData];
}

- (void)notificationDepthAdd:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    self.storeDepthProjectVal =[@[@{@"subSys": userInfo[@"dataSource"]}] mutableCopy];
    [self selStoreProgramme:NO];
}

- (void)notificationRepairModelAddRepair:(NSNotification*)notice{
    
    NSMutableDictionary *userInfo = [notice.userInfo mutableCopy];
    NSNumber *repairEdit = userInfo[@"repairEdit"];
    if (repairEdit.boolValue) {
        NSNumber *repairIndex = userInfo[@"repairIndex"];
        if (_isRepairPrice) {
            NSNumber *repairIndex = userInfo[@"repairIndex"];
            NSDictionary *repairInfo = _repairs[repairIndex.integerValue];
            [userInfo setObject:repairInfo[@"preId"] forKey:@"preId"] ;
        }
        [_repairs replaceObjectsInRange:NSMakeRange(repairIndex.integerValue, 1) withObjectsFromArray:@[userInfo] range:NSMakeRange(0, 1)];
        if (repairIndex.integerValue < self.cloudRepairs.count) {
            [self.cloudRepairs replaceObjectsInRange:NSMakeRange(repairIndex.integerValue, 1) withObjectsFromArray:@[userInfo] range:NSMakeRange(0, 1)];
        }
    }else{
        [_repairs addObject:userInfo];
    }
    [_eeditRepairTB reloadData];
}


#pragma mark -  UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_isRepairPrice) {
        if (_repairs.count > _selCloudIndex || _selCloudIndex >= 0) {
            NSMutableDictionary *repairOld = _repairs[_selCloudIndex];
            if (![_resultTV.text isEqualToString:@""]) {
                [repairOld setObject:@{@"warrantyDay" : _resultTV.text} forKey:@"warrantyTime"];
            }
        }
    }
}
#pragma mark -  YHRepairEditDelegate -编辑按钮回调 ---
- (void)notificationRepairEdit:(NSDictionary*)info{
    
    [self getNewBillData];
    
    NSDictionary *repair = info;
    NSUInteger repairIndex = [_repairs indexOfObject:repair];
    BOOL isCloud = (repairIndex < self.cloudRepairs.count);
    if (isCloud) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHDepthEditeController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthEditeController"];
        controller.isRepair = _isRepair;
        controller.orderInfo= self.orderInfo;
        controller.checkResult= self.resultTV.text;
        controller.isRepairPrice = _isRepairPrice;
        controller.repairActionData = self.data[@"repairActionData"];
        controller.carBaseInfo = self.data[@"baseInfo"];
        controller.repairStr = repair[@"repairStr"];
        NSDictionary *warrantyTime = repair[@"warrantyTime"];
        if (warrantyTime) {
            controller.warrantyDay = warrantyTime[@"warrantyDay"];
        }
        
        NSDictionary *giveBack = repair[@"giveBack"];
        if (giveBack) {
            controller.dateTime = giveBack[@"giveBackTime"];
        }
        NSDictionary *scheme = repair[@"scheme"];
        if (scheme) {
            controller.schemeContent = scheme[@"schemeContent"];
        }
        controller.dataSource = repair[@"dataSourceModel"];
        controller.dataSourceSupplies = repair[@"dataSourceSupplies"];
        controller.repairIndex = repairIndex;
        controller.repairEdit = YES;
        controller.cloudRepair = isCloud;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        
//        [[YHStoreTool ShareStoreTool] setOrderInfo:self.orderInfo];
        // 跳转到配件耗材
        YHSetPartsConsuMaterialVC *partConsuMaterialVC = [[YHSetPartsConsuMaterialVC alloc] init];
//        NSDictionary *repairData = info[@"repairData"];
        partConsuMaterialVC.index = [info[@"repairIndex"] integerValue];
        partConsuMaterialVC.isNewAdd = NO;
        partConsuMaterialVC.popVc = self;
        partConsuMaterialVC.catchDataArr = self.catchDataArr;
        [self.navigationController pushViewController:partConsuMaterialVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_eeditRepairTB == tableView) {
        [_repairs removeObjectsInArray:self.cloudRepairs];
        [_repairs insertObjects:self.cloudRepairs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.cloudRepairs.count)]];
        return 1;
    }else{
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_eeditRepairTB == tableView) {
        
        return _repairs.count + ((_isRepairPrice)? (0) : (1));
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eeditRepairTB == tableView) {
        YHEditRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell loadDataSource:((indexPath.row != ((_repairs.count)))? (_repairs[indexPath.row]) : (nil)) isAdd:(indexPath.row == ((_repairs.count)) && !(_isRepairPrice)) isSel:((_isRepairPrice) ? (_selCloudIndex == indexPath.row) : (((indexPath.row < self.cloudRepairs.count) && _selCloudIndex == 1) || ((indexPath.row >= self.cloudRepairs.count) && _selCloudIndex == 2))) isCloud:(indexPath.row < self.cloudRepairs.count) isRepairPrice:_isRepairPrice isFirt:((_isRepairPrice) ? (_repairs.count == 1) : (NO))];
        [cell setDelegate:self];
       
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_eeditRepairTB == tableView) {
        return 55;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_eeditRepairTB == tableView) {
        if (indexPath.row ==  (_repairs.count)) {
            // 最多只能有5个维修方式
            if (self.repairs.count - self.cloudRepairs.count >= 5) {
                [MBProgressHUD showError:@"最多只能添加5种维修方式" toView:self.view];
                return;
            }
//            [[YHStoreTool ShareStoreTool] setOrderInfo:self.orderInfo];
            // 跳转到配件耗材
            YHSetPartsConsuMaterialVC *partConsuMaterialVC = [[YHSetPartsConsuMaterialVC alloc] init];
            partConsuMaterialVC.isNewAdd = YES;
            partConsuMaterialVC.popVc = self;
            partConsuMaterialVC.index = self.repairs.count;
            partConsuMaterialVC.catchDataArr = self.catchDataArr;
            [self.navigationController pushViewController:partConsuMaterialVC animated:YES];
            
            return;
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHDepthEditeController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthEditeController"];
            controller.isRepair = _isRepair;
            controller.orderInfo= self.orderInfo;
            controller.isRepairPrice = _isRepairPrice;
            controller.checkResult= self.resultTV.text;
            controller.repairActionData = self.data[@"repairActionData"];
            controller.repairStr = [NSString stringWithFormat:@"维修方式%ld", (long)indexPath.row + 1];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            if (!_isRepairPrice) {
                if (indexPath.row < self.cloudRepairs.count) {
                    self.checkResult = _resultTV.text;
                    self.diagnosisResult = _diagnosisTV.text;
                    _resultTV.text = self.cloudCheckResult[@"makeResult"];
                    _diagnosisTV.text = self.cloudCheckResult[@"makeIdea"];
                    _selCloudIndex = 1;
                    _resultB.hidden = NO; // 云维修方式的复试按钮
                    self.editResultBtn.hidden = YES;
                    _diagnosisB.hidden = NO;
                    _resultTV.editable = NO;
                     self.arrowBtn.hidden = _resultTV.text.length == 0 ? YES : NO;
                }else{
                    if (_selCloudIndex != -1) {
                        _resultTV.text = self.checkResult;
                        _diagnosisTV.text = self.diagnosisResult;
                    }
                    _selCloudIndex = 2;
                    _resultB.hidden = YES;
                    self.editResultBtn.hidden = NO;
                    _diagnosisB.hidden = YES;
                    _resultTV.editable = NO;
                     self.arrowBtn.hidden = _resultTV.text.length == 0 ? YES : NO;
                }
                [self repairReslutUpdata];
            }else{
                if (_repairs.count > _selCloudIndex || _selCloudIndex >= 0) {
                    NSMutableDictionary *repairOld = _repairs[_selCloudIndex];
                    if (![_resultTV.text isEqualToString:@""]) {
                        [repairOld setObject:@{@"warrantyDay" : _resultTV.text} forKey:@"warrantyTime"];
                    }
                }
                
                NSMutableDictionary *repair = _repairs[indexPath.row];
                NSDictionary *warrantyDay = repair[@"warrantyTime"];
                if (warrantyDay) {
                    _resultTV.text = warrantyDay[@"warrantyDay"];
                }else{
                    _resultTV.text = @"";
                }
                _selCloudIndex = indexPath.row;
                 self.arrowBtn.hidden = _resultTV.text.length == 0 ? YES : NO;
            }
        }
        [tableView reloadData];
    }else{
    
        if (tableView == _eeditRepairTB || tableView == _tableView) {
            return;
        }
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_eeditRepairTB == tableView) {
        return 0;
    }else{
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_eeditRepairTB == tableView) {
        return nil;
    }else{
        return [super tableView:tableView viewForHeaderInSection:section];
    }
}
#pragma mark - 点击左边查看工单详情 ----
- (IBAction)tablLeftAction:(id)sender {
   
    _tableLeftLine.backgroundColor = YHNaviColor;
    _tableRightLine.backgroundColor = [UIColor whiteColor];//YHLineColor;
    _repairBoxV.hidden = YES;
    _tableView.hidden = NO;
    
    _tableLeftB.selected = !_tableView.isHidden;
    _tableRightB.selected = !_repairBoxV.isHidden;
    
}
#pragma mark - 初始化数据源数据 ----
- (void)initRepairs{//帮检单转维修单 的维修方式 自动出维修方式
    // 默认为NO
    self.isMinePartAndProjectWay = NO;
    
    self.catchDataArr = [NSMutableArray array];
    if ([[self.orderInfo valueForKeyPath:@"billType"] isEqualToString:@"W"]
        && [[self.orderInfo valueForKeyPath:@"handleType"] isEqualToString:@"handle"]
        && [[self.orderInfo valueForKeyPath:@"nextStatusCode"] isEqualToString:@"initialSurveyCompletion"]) {//帮检单转维修单，维修方式暂存
//        else{
        
            NSArray *modes = self.data[@"repairModeData"];
            if (self.repairs == nil) {
                self.repairs = [@[]mutableCopy];
            }
            for (int i = 0 ; i < modes.count; i++) {
                NSDictionary *mode = modes[i];
                NSMutableDictionary *repair = [@{
                                                 @"repairEdit" : @0,
                                                 @"repairIndex" : @(i),
                                                 @"repairStr" : [NSString stringWithFormat:@"维修方式%d", i + 1] } mutableDeepCopy];
                
                NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
                NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
                [dataSourceModel enumerateObjectsUsingBlock:^(NSMutableDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                    [item removeObjectForKey:@"scalar"];
                }];
                [dataSourceSupplies enumerateObjectsUsingBlock:^(NSMutableDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                    [item removeObjectForKey:@"scalar"];
                }];
                [repair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
                [repair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];
                repair[@"repairModeKey"] = @(YES);
                [self.repairs addObject:repair];
            }
//        }
        
    }
    
    NSArray * temporarySave = [self.data objectForKey:@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
    if (!temporarySave.count) {
        temporarySave = nil;
    }
    if (temporarySave) {  // van_mr
        
        self.isMinePartAndProjectWay = YES;
        NSDictionary *temporarySave = self.data[@"temporarySave"];
        NSArray *modes = temporarySave[@"repairModeData"];
        for (int i = 0 ; i < modes.count; i++) {
            
            if (i < self.cloudRepairs.count) {
                continue;
            }
            NSDictionary *mode = modes[i];
            NSMutableDictionary *tempMode = mode.mutableCopy;
            NSMutableDictionary *repair = [NSMutableDictionary dictionary];
            [repair setValue:@1 forKey:@"repairEdit"];
            [repair setValue:@(i) forKey:@"repairIndex"];
            
            [repair setValue:[NSString stringWithFormat:@"维修方式%lu",i+1 - self.cloudRepairs.count] forKey:@"repairStr"];
            [repair setValue:mode forKey:@"repairData"];
            
            
            [tempMode setValue:@1 forKey:@"repairEdit"];
            [tempMode setValue:@(i) forKey:@"repairIndex"];
            [tempMode setValue:[NSString stringWithFormat:@"维修方式%lu",i+1 - self.cloudRepairs.count] forKey:@"repairStr"];
            
            NSMutableArray *dataSourceModel = [[mode valueForKeyPath:@"repairItem"] mutableDeepCopy];
            NSMutableArray *dataSourceSupplies = [[mode valueForKeyPath:@"parts"] mutableDeepCopy];
            [repair setObject:((dataSourceModel)? (dataSourceModel) : ([@[]mutableCopy])) forKey:@"dataSourceModel"];
            [repair setObject:((dataSourceSupplies)? (dataSourceSupplies) : ([@[]mutableCopy])) forKey:@"dataSourceSupplies"];
            [self.catchDataArr addObject:tempMode];
            [self.repairs addObject:repair];
        }
    }
    
}
#pragma mark - 点击右边的编辑维修方式 ---
- (IBAction)tablRightAction:(id)sender {
    
    if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"modeQuote"]//编辑人工费
        ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@/maintain_offer.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], self.orderInfo[@"id"]];http://dev.demo.com/app
        controller.title = @"工单";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudMakeDepth"]){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHDepthEditeController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthEditeController"];
        controller.isRepair = _isRepair;
        controller.orderInfo= self.orderInfo;
        controller.isRepairPrice = _isRepairPrice;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudDepthQuote"]
              || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"]
              || [self.orderInfo[@"nextStatusCode"] isEqualToString:@"storePushDepth"]){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
        controller.data = self.data;
        controller.orderInfo= self.orderInfo;
        controller.isDepth = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self selCloudProgramme:NO];
        [self selStoreProgramme:NO];
        _tableLeftLine.backgroundColor = [UIColor whiteColor];//YHLineColor;
        _tableRightLine.backgroundColor = YHNaviColor;
        _repairBoxV.hidden = NO;
        _tableView.hidden = YES;
        
        _tableLeftB.selected = !_tableView.isHidden;
        _tableRightB.selected = !_repairBoxV.isHidden;

        
        if (_isRepairPrice) {
            [_repairs removeAllObjects];
            NSArray *repairModeData = self.data[@"repairModeData"];
            for (NSMutableDictionary *item in repairModeData) {
                NSMutableDictionary *temp = [@{}mutableCopy];
                NSDictionary *itemDeep = [item mutableDeepCopy];
                NSMutableArray *repairItem = [@[]mutableCopy];
                NSMutableArray *parts = [@[]mutableCopy];
                for (NSDictionary *repairI in itemDeep[@"repairItem"]) {
                    [repairItem addObject:[repairI mutableCopy]];
                }
                
                for (NSDictionary *partI in itemDeep[@"parts"]) {
                    [parts addObject:[partI mutableCopy]];
                }
                if (item[@"repairModeQuality"]) {
                    [temp setObject:item[@"repairModeQuality"] forKey:@"warrantyTime"];
                }
                if (item[@"giveBack"]) {
                    [temp setObject:item[@"giveBack"] forKey:@"giveBack"];
                }
                
                if (item[@"scheme"]) {
                    [temp setObject:item[@"scheme"] forKey:@"scheme"];
                }
                [temp setObject:itemDeep[@"preId"] forKey:@"preId"];
                [temp setObject:repairItem forKey:@"dataSourceModel"];
                [temp setObject:parts forKey:@"dataSourceSupplies"];
                [temp setObject:[NSString stringWithFormat:@"维修方式%lu", ((unsigned long)_repairs.count + 1 - self.cloudRepairs.count)] forKey:@"repairStr"];
                [_repairs addObject:temp];
            }
        }
        
        [_eeditRepairTB reloadData];
    }
}

- (void)selStoreProgramme:(BOOL)isSelStore{
    [_storeSelB setImage:[UIImage imageNamed:((isSelStore)? (@"editS") : (@"unselect"))] forState:UIControlStateNormal];
    
    [_storeDescB setImage:[UIImage imageNamed:((isSelStore)? (@"me_57") : (@"editOrder"))] forState:UIControlStateNormal];
    [_storeDescB setTitleColor:((isSelStore)? (YHNaviColor) : (YHCellColor)) forState:UIControlStateNormal];
    _storeSelB.hidden = !self.storeDepthProjectVal && !self.depthProjectVal;
    _storeEditB.hidden = !self.storeDepthProjectVal && !self.depthProjectVal;
    _storeDateL.hidden = YES;
    _storeLineL.hidden = !self.storeDepthProjectVal && !self.depthProjectVal;
    
}

- (void)selCloudProgramme:(BOOL)isSelCloud{
    [_cloudSelB setImage:[UIImage imageNamed:((isSelCloud)? (@"editS") : (@"unselect"))] forState:UIControlStateNormal];
    
    [_cloudDescB setImage:[UIImage imageNamed:((isSelCloud)? (@"me_54") : (@"me_47"))] forState:UIControlStateNormal];
    [_cloudDescB setTitleColor:((isSelCloud)? (YHNaviColor) : (YHCellColor)) forState:UIControlStateNormal];
    _cloudSelB.hidden = !self.cloudDepthProjectVal;
    //    _cloudEditB.hidden = !self.cloudDepthProjectVal;
    
    NSArray *depthProjectS = self.data[@"cloudDepthDetail"];
    _cloudEditB.hidden = !depthProjectS;
    _cloudDateL.hidden = YES;//!self.cloudDepthProjectVal;
    _loudLineL.hidden = !self.cloudDepthProjectVal.count;
    _storeTopLC.constant = ((self.cloudDepthProjectVal.count)? (1) : (-60));
}
- (IBAction)cloudEditAction:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
    controller.sysData = self.data;
    controller.orderInfo = self.orderInfo;
    controller.is_circuitry = self.data[@"is_circuitry"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cloudSelAction:(id)sender {
    self.selProgramme = 1;
    [self selCloudProgramme:YES];
    [self selStoreProgramme:NO];
}

#pragma mark - 保存
//保存  不同
- (IBAction)updataAction:(id)sender{
    
    if (_isRepair) {
        if (_selCloudIndex == -1 && self.cloudRepairs.count != 0) {
            [MBProgressHUD showError:@"请选择维修方式"];
            return;
        }
        
        NSMutableArray *repairS = [@[]mutableCopy];
        NSArray *repairs ;
       // 云
        if (_selCloudIndex == 1 && self.cloudRepairs.count != 0) {
            repairs = self.cloudRepairs;
            for (NSDictionary *repair in repairs) {
               
                NSArray *dataSource = repair[@"dataSourceModel"];
                NSArray *dataSourceSupplies = repair[@"dataSourceSupplies"];
                
                if (dataSourceSupplies == nil) {
                    [repairS addObject:@{@"repairItem" : dataSource}];
                }else{
                    for (NSMutableDictionary *item in dataSourceSupplies) {
                        if (item[@"sysClassName"]) {
                            [item setObject:item[@"sysClassName"] forKey:@"className"];
                        }

                        if (!item[@"partsDesc"]) {
                            [item setObject:@"" forKey:@"partsDesc"];
                        }
                    }
                    [repairS addObject:@{@"repairItem" : dataSource,
                                         @"parts" : dataSourceSupplies
                                         }];
                }
            }
            
        }else{
        
            NSMutableArray *temp = [_repairs mutableCopy];
            [temp removeObjectsInArray:self.cloudRepairs];
            repairs = temp;
            for (NSDictionary *repair in repairs) {
                NSArray *dataSource = repair[@"dataSourceModel"];
                NSArray *dataSourceSupplies = repair[@"dataSourceSupplies"];
                
                for (NSMutableDictionary *item in dataSource) {
                    NSNumber *sel = item[@"sel"];
                    if (sel != nil) {
                        if (item[@"id"]) {
                            [item setObject:item[@"id"] forKey:@"partsClassId"];
                        }
                    }
                }
                NSMutableDictionary *repariInfo = [@{}mutableCopy];
                if (repair[@"preId"]) {
                    [repariInfo setObject:repair[@"preId"] forKey:@"preId"];
                }
                
                NSDictionary *warrantyTime = repair[@"warrantyTime"];
                if (warrantyTime) {
                    [repariInfo setObject:warrantyTime forKey:@"warrantyTime"];
                }
                
                NSDictionary *giveBack = repair[@"giveBack"];
                if (giveBack) {
                    [repariInfo setObject:giveBack forKey:@"giveBack"];
                }
                
                NSDictionary *scheme = repair[@"scheme"];
                if (scheme) {
                    [repariInfo setObject:scheme forKey:@"scheme"];
                }
                
                if (dataSourceSupplies == nil) {
                    [repariInfo setObject:dataSource forKey:@"repairItem"];
                }else{
                    for (NSMutableDictionary *item in dataSourceSupplies) {
                        
                        if (!item[@"partsDesc"]) {
                            [item setObject:@"" forKey:@"partsDesc"];
                        }
                        if (!item[@"partsUnit"]) {
                            [item setObject:@"" forKey:@"partsUnit"];
                        }
                        if (!item[@"modelNumber"]) {
                            [item setObject:@"" forKey:@"modelNumber"];
                        }
                    }
                    
                    [repariInfo setObject:dataSource forKey:@"repairItem"];
                    [repariInfo setObject:dataSourceSupplies forKey:@"parts"];
                }
                [repairS addObject:repariInfo];
            }
            
        }
        if (repairS.count == 0) {
            [MBProgressHUD showError:@"请添加维修方式"];
            return;
        }
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        if (_isRepairPrice) {
            
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             updateRepairMode:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             requestData:repairS
             isTiger:[self.orderInfo[@"channelCode"] isEqualToString:@"YHSYS10000"]
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
                 [MBProgressHUD hideHUDForView:self.view];
             }];
            
        }else{
            
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             saveMakeMode:[YHTools getAccessToken]
             billId:self.orderInfo[@"id"]
             checkResult:@{@"makeResult" : _resultTV.text,
                           @"makeIdea" : _diagnosisTV.text}
             requestData:repairS
             isStoreModel:![self.orderInfo[@"nextStatusCode"] isEqualToString:@"makeModeScheme"]
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
        }
        
    }else{
        
        if (self.selProgramme == 0) {
            [MBProgressHUD showError:@"请选择方案"];
            return;
        }
        
        NSMutableArray *requestDataTemp = [@[]mutableCopy];
        if (self.selProgramme == 1) {
            requestDataTemp = nil;
            //            for (NSDictionary *item in self.cloudDepthProjectVal) {
            //                NSArray *subSys = item[@"subSys"];
            //                for (NSDictionary *sub in subSys) {
            //                    [requestDataTemp addObject:@{@"sysClassId" : sub[@"sysClassId"],
            //                                                 @"quote" : sub[@"price"]}];
            //                }
            //            }//quote
        }
        if (self.selProgramme == 2) {
            for (NSDictionary *item in self.storeDepthProjectVal) {
                NSArray *subSys = item[@"subSys"];
                for (NSDictionary *sub in subSys) {
                    NSString *desc = sub[@"desc"];
                    if (desc) {
                        [requestDataTemp addObject:@{@"id" : sub[@"id"],
                                                     @"type" : sub[@"type"],
                                                     @"desc" : desc}];
                    }else{
                        [requestDataTemp addObject:@{@"id" : sub[@"id"],
                                                     @"type" : sub[@"type"]}];
                    }
                    
                }
            }
        }
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         saveStoreMakeDepth:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         depthType:(((self.selProgramme == 2))? (@"store") : (@"cloud"))
         storeDepth:requestDataTemp
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                 YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                 NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                 [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
//                 controller.orderInfo = billStatus;
//                 controller.titleStr = @"提交成功";
//                 [self.navigationController pushViewController:controller animated:YES];
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
    }
}

- (IBAction)storeSelAction:(id)sender {
    
    if (!self.storeDepthProjectVal && !self.depthProjectVal) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHDepthEditeController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthEditeController"];
        controller.isRepair = _isRepair;
        controller.orderInfo= self.orderInfo;
        controller.isRepairPrice = _isRepairPrice;
        controller.repairActionData = self.data[@"repairActionData"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        self.selProgramme = 2;
        [self selCloudProgramme:NO];
        [self selStoreProgramme:YES];
    }
}

- (IBAction)storeEditAction:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHDepthEditeController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthEditeController"];
    controller.isRepair = _isRepair;
    controller.orderInfo= self.orderInfo;
    controller.isRepairPrice = _isRepairPrice;
    
    if (self.storeDepthProjectVal.count != 0 && self.storeDepthProjectVal) {
        
        NSDictionary *info = self.storeDepthProjectVal[0];
        controller.dataSource = info[@"subSys"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)copyResultAction:(id)sender {
    
     self.checkResult = self.cloudCheckResult[@"makeResult"];
    if (self.checkResult.length == 0) {
        return;
    }
    [MBProgressHUD showError:@"复制成功"];
    
    NSDictionary *temporyData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporyData[@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
    NSArray *repairModeData = temporarySave[@"repairModeData"];
    
    if (!repairModeData) {
        repairModeData = nil;
    }
    
    NSMutableDictionary *checkResultDict = [NSMutableDictionary dictionary];
    [checkResultDict setValue:self.checkResult forKey:@"makeResult"];
    
    [self saveTemporaryData:checkResultDict repairModeData:repairModeData];
}
#pragma mark - 保存维修方式到缓存 ---
- (void)saveTemporaryData:(NSDictionary *)diagnoseResultDict repairModeData:(NSArray *)repairArr{
 
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveModifyPattern:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] checkResult:diagnoseResultDict repairModeData:repairArr onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
//            [MBProgressHUD showError:@"保存结果成功"];
        }else{
//            [MBProgressHUD showError:@"保存结果失败"];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (IBAction)diagnosisAction:(id)sender {
    self.diagnosisResult = self.cloudCheckResult[@"makeIdea"];
}
@end
