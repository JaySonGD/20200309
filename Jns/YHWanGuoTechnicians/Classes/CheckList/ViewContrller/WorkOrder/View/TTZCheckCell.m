//
//  TTZCheckCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZCheckCell.h"
#import "TTZHeaderTagCell.h"
#import "AccidentDiagnosisCell.h"
#import "TTZFaultCodeAlertView.h"
#import "TTZPhotoView.h"

#import "TTZSurveyModel.h"
#import "TTZDBModel.h"

#import "NSObject+BGModel.h"
#import "UIAlertController+Blocks.h"
#import "YHPhotoManger.h"
#import "UIView+add.h"
#import "YHHUPhotoBrowser.h"

#import <UIButton+WebCache.h>
#import <MJExtension.h>
//#import "MBProgressHUD+MJ.h"
#import "UIView+Frame.h"

#import "YHCarPhotoService.h"

#define kInPutViewHeight 37
#define kcheckBoxCellHeight 37
#define kcheckBoxCellSpacing 10
#define kPhotoHeight 55
#define kAddFaultCodeButtonHeight 45


@interface TTZCheckCell ()
<
UICollectionViewDelegate,UICollectionViewDataSource,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UITableViewDataSource,UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *imgSrcButton;

//@property (weak, nonatomic) IBOutlet UICollectionView *checkBoxView;
//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *checkBoxViewLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxViewHeight;
@property (weak, nonatomic) IBOutlet UIView *checkBoxContentView;


@property (weak, nonatomic) IBOutlet UITextField *inPutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inPutViewHeight;
@property (weak, nonatomic) UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faultCodeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *faultCodeView;
@property (weak, nonatomic) IBOutlet UIButton *addCodeButton;
@property (weak, nonatomic) IBOutlet UITableView *faultCodeListView;

@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *photoViewLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *encyDesViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *encyDesLB;
@property (weak, nonatomic) IBOutlet UIButton *isShowBtn;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTableViewHeight;
@property (nonatomic, weak) UILabel *selectTableViewHeaderTitleLB;

@property (nonatomic, assign) NSInteger willSelectIndex;
@property (weak, nonatomic) IBOutlet UIView *add2CylinderBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *add2CylinderHeight;
@property (weak, nonatomic) IBOutlet UIButton *add2CylinderBtn;

@end


@implementation TTZCheckCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUI];
}

//FIXME:  -  自定义方法
- (void)setUI{
    
//    [self.checkBoxView registerClass:[TTZValueCell class] forCellWithReuseIdentifier:@"TTZValueCell"];
//    self.checkBoxViewLayout.itemSize = CGSizeMake((screenWidth - 50 - 10)*0.5, 37);
//    self.checkBoxViewLayout.minimumLineSpacing = 5;
//    self.checkBoxViewLayout.minimumInteritemSpacing = 5;
    
    kViewBorderRadius(self.addCodeButton, 8, 0.5, YHNaviColor);
    
    [self.photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"YHPhotoAddCell"];
    self.photoViewLayout.itemSize = CGSizeMake(52, 52);
    self.photoViewLayout.minimumLineSpacing = 0;
    self.photoViewLayout.minimumInteritemSpacing = 0;
    
    [self.faultCodeListView registerClass:[TTZFaultCodeCell class] forCellReuseIdentifier:@"TTZFaultCodeCell"];
    self.faultCodeListView.separatorInset = UIEdgeInsetsZero;
    self.faultCodeListView.layoutMargins = UIEdgeInsetsZero;
    self.faultCodeListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.faultCodeListView.rowHeight = 44;
//    self.faultCodeListView.scrollEnabled = YES;

    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 22)];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    unitLabel.font = [UIFont systemFontOfSize:15.0];
    self.inPutView.rightView = unitLabel;
    self.inPutView.rightViewMode = UITextFieldViewModeAlways;
    _unitLabel = unitLabel;
    self.inPutView.delegate = self;
    self.inPutView.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.selectTableView registerClass:[TTZChildCell class] forCellReuseIdentifier:@"TTZChildCell"];
    self.selectTableView.separatorInset = UIEdgeInsetsZero;
    self.selectTableView.layoutMargins = UIEdgeInsetsZero;
    self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.selectTableView.rowHeight = 44;
    self.selectTableView.scrollEnabled = NO;

    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.selectTableView.tableHeaderView = titleLB;
    self.selectTableViewHeaderTitleLB = titleLB;

//    if (@available(iOS 11.0, *)) {
//        self.checkBoxView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.photoView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.faultCodeListView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//
//    if (@available(iOS 10.0, *)) {
//
//        self.checkBoxView.prefetchingEnabled = NO;
//        self.photoView.prefetchingEnabled = NO;
//    }
}



- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.model.isLastProject) {
                [self.view setRounded:self.view.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
            }else{
                [self.view setRounded:self.view.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:0];
            }
        });
}


- (void)setModel:(TTZSurveyModel *)model{
    _model = model;
    
    
    NSString *projectName = [NSString stringWithFormat:@"%@%@",model.isRequir? @"* ":@"",model.projectName];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:projectName];

    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:17.0]
                    range:[projectName rangeOfString:projectName]];
    if (model.isRequir) {
         [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:[projectName rangeOfString:@"*"]];
        
        [attrStr addAttribute:NSBaselineOffsetAttributeName value:@(-3) range:[projectName rangeOfString:@"*"]];

    }
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:[projectName rangeOfString:model.projectName]];
    
    self.projectNameLabel.attributedText = attrStr;
    //self.projectNameLabel.text = model.projectName;
    self.imgSrcButton.hidden = IsEmptyStr(model.imgSrc) && IsEmptyStr(model.intervalRange.list.firstObject.tips);
    
    
    self.inPutView.userInteractionEnabled = NO;
    self.inPutView.hidden = YES;
    self.checkBoxContentView.hidden = YES;
    self.faultCodeView.hidden = YES;
    self.unitLabel.hidden = YES;
    self.checkBoxViewHeight.constant = 0;
    self.faultCodeViewHeight.constant = 0;
    self.inPutViewHeight.constant = 0;
    self.encyDesViewHeight.constant = 0;
    self.selectTableViewHeight.constant = 0;
    
    self.add2CylinderBox.hidden = YES;
    self.add2CylinderHeight.constant = 0;

    /** 数据类型 range范围 select 多选 radio 单选 input输入文本框 integer 整数 */
    
    if ([model.intervalType isEqualToString:@"select"] || [model.intervalType isEqualToString:@"radio"]) {
        self.checkBoxContentView.hidden = NO;
        NSArray *list = model.intervalRange.list;
        if(list.count) {
            self.checkBoxViewHeight.constant = (list.count+1)/2 * kcheckBoxCellHeight + ((list.count+1)/2 - 1) * kcheckBoxCellSpacing;//
//            self.checkBoxViewHeight.constant = (list.count+1)/2 * kcheckBoxCellHeight + ((list.count+1)/2) * kcheckBoxCellSpacing;//

            
        }
        else {
            self.checkBoxViewHeight.constant = 0;
        }
        //37 10
//        [self.checkBoxView reloadData];
        
    }else if ([model.intervalType isEqualToString:@"input"] || [model.intervalType isEqualToString:@"text"]){
        self.inPutView.hidden = NO;
        self.unitLabel.hidden = NO;
        self.inPutView.userInteractionEnabled = YES;
        self.inPutViewHeight.constant = kInPutViewHeight;
        self.inPutView.placeholder = model.intervalRange.placeholder?model.intervalRange.placeholder:@"请输入";
        self.inPutView.text = model.intervalRange.interval;
        self.unitLabel.text = model.unit;
        
        
        //string number
        self.inPutView.keyboardType = [model.dataType isEqualToString:@"string"]?UIKeyboardTypeDefault:UIKeyboardTypeNumbersAndPunctuation;
        
    }else if ([model.intervalType isEqualToString:@"gatherInputAdd"]){
        self.faultCodeView.hidden = NO;
        self.faultCodeViewHeight.constant = kAddFaultCodeButtonHeight + self.faultCodeListView.rowHeight * model.codes.count;
        //[self.faultCodeListView reloadData];
    }else if ([model.intervalType isEqualToString:@"elecCodeForm"]){//intervalType    String    elecCodeForm
        CGFloat encyDesHegiht = IsEmptyStr(model.encyDescs)? 0 : 40;
        if(model.isShowDes) encyDesHegiht += model.encyDesHeight;
        self.faultCodeView.hidden = NO;
        self.faultCodeViewHeight.constant = kAddFaultCodeButtonHeight + self.faultCodeListView.rowHeight * model.codes.count + encyDesHegiht;
        self.encyDesViewHeight.constant = encyDesHegiht;
        self.encyDesLB.text = model.encyDescs;
        self.isShowBtn.selected = model.isShowDes;
        //[self.faultCodeListView reloadData];
    }else if ([model.intervalType isEqualToString:@"form"]){//intervalType

        self.faultCodeView.hidden = NO;
        self.faultCodeViewHeight.constant = kAddFaultCodeButtonHeight + self.faultCodeListView.rowHeight * model.codes.count;
        [self.addCodeButton setTitle:@"添加"forState:UIControlStateNormal];
        //[self.faultCodeListView reloadData];
    }else if ([model.intervalType isEqualToString:@"sameIncrease"]){//intervalType    String    sameIncrease
        
        self.faultCodeView.hidden = NO;
        self.faultCodeViewHeight.constant = kAddFaultCodeButtonHeight + self.faultCodeListView.rowHeight * model.codes.count;
        [self.addCodeButton setTitle:@"添加"forState:UIControlStateNormal];
        //[self.faultCodeListView reloadData];
    }else if ([model.intervalType isEqualToString:@"independent"]){
        
        self.checkBoxContentView.hidden = NO;
        NSArray *list = model.intervalRange.list;
        if(list.count) {
            self.checkBoxViewHeight.constant = (list.count+1)/2 * kcheckBoxCellHeight + ((list.count+1)/2 - 1) * kcheckBoxCellSpacing;
        }
        else {
            self.checkBoxViewHeight.constant = 0;
        }

        TTZValueModel  *child =  [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]].firstObject;
        if (child && child.value != 1) {
            self.add2CylinderBox.hidden = NO;
            CGFloat topSpacing = 3;
            CGFloat titleHeight = 32;
            CGFloat add2CylinderBtnH = kcheckBoxCellHeight;
            
            self.add2CylinderHeight.constant = (child.cylinderList.count+1)/2 * (kcheckBoxCellHeight + kcheckBoxCellSpacing) + add2CylinderBtnH + topSpacing + titleHeight;
            [self reloadAdd2Cylinder:child];

        }else{
            self.add2CylinderBox.hidden = YES;
            self.add2CylinderHeight.constant = 0;
        }
        self.model.add2CylinderHeight = self.add2CylinderHeight.constant;

    }
    
    
    
    CGFloat photoHeight = model.uploadImgStatus? kPhotoHeight : (model.projectRelativeImgList.count? kPhotoHeight : 0);
    self.photoViewHeight.constant = photoHeight;
    
    if(photoHeight == kPhotoHeight) self.photoViewLayout.itemSize = CGSizeMake(52, 52);
    else self.photoViewLayout.itemSize = CGSizeZero;
    //    self.photoViewLayout.itemSize = CGSizeZero;
    //    self.photoViewLayout.itemSize = CGSizeMake(52, 52);
    [self.photoView reloadData];
    
    //    [self.photoView reloadData];
    //    self.checkBoxViewHeight.constant = 0;
//    [self.checkBoxView reloadData];
    [self.faultCodeListView reloadData];
    [self reloadCheckBox];

}

- (void)reloadAdd2Cylinder:(TTZValueModel *)model{
    CGFloat x = 0;
    CGFloat y = 3;
    CGFloat w = (screenWidth - 50 - kcheckBoxCellSpacing)*0.5;
    CGFloat h = kcheckBoxCellHeight;
    
    [self.add2CylinderBox.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    self.add2CylinderBtn.hidden = NO;
    UILabel *titleLB =  [self.add2CylinderBox viewWithTag:-1+2000];
    if (!titleLB) {
        titleLB  = [[UILabel alloc] initWithFrame:CGRectMake(x, y, screenWidth - 50, 32)];
        [self.add2CylinderBox addSubview:titleLB];
        titleLB.tag = -1+2000;
        titleLB.font = [UIFont systemFontOfSize:15.0];
        titleLB.textColor = [UIColor blackColor];
    }
    titleLB.text = [NSString stringWithFormat:@"选择%@缸",model.name];
    titleLB.hidden = NO;
    
    y = CGRectGetMaxY(titleLB.frame);
    [model.cylinderList enumerateObjectsUsingBlock:^(TTZChildModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *cellBtn =  [self.add2CylinderBox viewWithTag:idx+2000];
        if (!cellBtn) {
            cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [cellBtn setTitleColor:YHColor(89, 87, 85) forState:UIControlStateNormal];
            cellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cellBtn addTarget:self action:@selector(cylinderAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.add2CylinderBox addSubview:cellBtn];
        }
        cellBtn.hidden = NO;
        cellBtn.tag = idx+2000;
        cellBtn.x = (idx%2 * (w + kcheckBoxCellSpacing)) + x;
        cellBtn.y = idx/2 * (h + kcheckBoxCellSpacing) + y;
        cellBtn.height = h;
        cellBtn.width = w;
        [cellBtn setTitle:obj.name forState:UIControlStateNormal];
        cellBtn.selected = obj.isSelected;
        if (obj.isSelected) {
            cellBtn.backgroundColor = YHNaviColor;
            kViewBorderRadius(cellBtn, 8, 0.5, YHNaviColor);
        }else{
            cellBtn.backgroundColor = [UIColor whiteColor];
            kViewBorderRadius(cellBtn, 8, 0.5, YHColor(171, 174, 174));
        }
        
    }];

}

- (void)reloadCheckBox{
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (screenWidth - 50 - kcheckBoxCellSpacing)*0.5;
    CGFloat h = kcheckBoxCellHeight;
    //[self.checkBoxContentView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    [self.checkBoxContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *cellBtn =  [self.checkBoxContentView viewWithTag:idx+1000];
        if (!cellBtn) {
            cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [cellBtn setTitleColor:YHColor(89, 87, 85) forState:UIControlStateNormal];
            cellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cellBtn addTarget:self action:@selector(checkBoxButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.checkBoxContentView addSubview:cellBtn];
        }
        cellBtn.hidden = NO;
        cellBtn.tag = idx+1000;
        cellBtn.x = (idx%2 * (w + kcheckBoxCellSpacing)) + x;
        cellBtn.y = idx/2 * (h + kcheckBoxCellSpacing) + y;
        cellBtn.height = h;
        cellBtn.width = w;
        [cellBtn setTitle:obj.name forState:UIControlStateNormal];
        cellBtn.selected = obj.isSelected;
        if (obj.isSelected) {
            cellBtn.backgroundColor = YHNaviColor;
            kViewBorderRadius(cellBtn, 8, 0.5, YHNaviColor);
            self.selectTableViewHeight.constant = self.selectTableView.rowHeight * (obj.childList.count? (obj.childList.count+1) : 0);
            self.selectTableViewHeaderTitleLB.text = obj.childName;
            self.model.tableViewHeight = self.selectTableViewHeight.constant;
            [self.selectTableView reloadData];
        }else{
            cellBtn.backgroundColor = [UIColor whiteColor];
            kViewBorderRadius(cellBtn, 8, 0.5, YHColor(171, 174, 174));
        }
        
    }];
}


- (CGFloat)rowHeight:(TTZSurveyModel *)model{
    self.model = model;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    return CGRectGetMaxY(self.photoView.frame) + 15;
}

#pragma mark  - 拍照
- (void)setPhotoImagePickerVC:(NSInteger)index {
    
    !(_takePhotoBlock)? : _takePhotoBlock(self.model);
    return;
    
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark  - 相册
- (void)setImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)add2CylinderAction:(UIButton *)sender {
    
    TTZValueModel  *child =  [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]].firstObject;
    NSInteger index = child.cylinderList.count+1;
    
    for (NSInteger i = index; i < index+2; i++) {
        TTZChildModel *c  = [TTZChildModel new];
        c.name = [NSString stringWithFormat:@"第%ld缸",(long)i];
        c.value = [NSString stringWithFormat:@"%ld",i];
        [child.cylinderList addObject:c];
    }
    
    self.model.cellHeight += 1 * (kcheckBoxCellHeight + kcheckBoxCellSpacing);
    !(_reloadBlock)? : _reloadBlock();
}
//FIXME:  -  事件监听
- (IBAction)helpAction {
    !(_helpBlock)? : _helpBlock(self.model);
}
- (IBAction)isShowDesAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.model.isShowDes = sender.isSelected;
    if (self.model.isShowDes) {
        self.model.cellHeight += self.model.encyDesHeight;
    }else{
        self.model.cellHeight -= self.model.encyDesHeight;
    }
    !(_getElecCtrlProjectListBlock)? : _getElecCtrlProjectListBlock(@[]);
}

- (BOOL)isNumber:(NSString *)strValue{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}


- (IBAction)addCodeAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.model.intervalRange.maxNumber && self.model.codes.count >= self.model.intervalRange.maxNumber )  {
        [MBProgressHUD showError:[NSString stringWithFormat:@"最多只允许输入%ld项",(long)self.model.intervalRange.maxNumber]];
        return ;
    }
    NSString *dataType = IsEmptyStr(self.model.intervalRange.list.firstObject.dataType)? (IsEmptyStr(self.model.intervalRange.dataType)? self.model.dataType :  self.model.intervalRange.dataType) :  self.model.intervalRange.list.firstObject.dataType;
    
    [TTZFaultCodeAlertView showAlertViewWithTitle:self.model.projectName
                                      placeholder:IsEmptyStr(self.model.intervalRange.placeholder)? @"请添加": self.model.intervalRange.placeholder
                                         codeType:self.model.intervalType
                                     keyBoardType:dataType
                                      didComplete:^(NSString *txt) {
        

                                          
                                          ///
                                          CGFloat  max = self.model.intervalRange.list.firstObject.max.floatValue;
                                          CGFloat  min = self.model.intervalRange.list.firstObject.min.floatValue;
                                          CGFloat  val = [txt floatValue];
                                          
                                          if ([dataType isEqualToString:@"number"] &&
                                              min != max &&
                                              (![self isNumber:txt] || val > max || val < min)) {
                                              
                                              [MBProgressHUD showError:@"数值异常,请输入有效数值"];
                                              return;
                                          }
                                          ///
        
        [weakSelf.model.codes addObject:txt];
        weakSelf.model.cellHeight += weakSelf.faultCodeListView.rowHeight;
        !(weakSelf.reloadBlock)? : weakSelf.reloadBlock();
        weakSelf.model.isChange = ![weakSelf.model.projectVal isEqualToString:[weakSelf.model.codes componentsJoinedByString:@","]];
        
        weakSelf.model.projectVal = [weakSelf.model.codes componentsJoinedByString:@","];
        //带出数据的故障码
        if ([weakSelf.model.intervalType isEqualToString:@"elecCodeForm"]){
            [weakSelf getElecCtrlProjectList];
            return ;
        }

    }];
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text{
    if (IsEmptyStr(text)) {
        return 0;
    }
    
    CGFloat width = self.encyDesLB.width;
    UIFont * font = self.encyDesLB.font;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

- (void)getElecCtrlProjectList{
    
    if (self.model.elecCtrlProjectList.count || !IsEmptyStr(self.model.encyDescs)) {
        if(self.model.isShowDes) {
            self.model.cellHeight -= self.model.encyDesHeight;
            self.model.isShowDes = NO;
        }
        if(self.encyDesViewHeight.constant >= 40){
            self.model.cellHeight -= self.model.encyDescs? 40 : 0;
            self.encyDesViewHeight.constant = 0;
        }

        self.model.encyDescs = nil;
        self.model.encyDesHeight = 0;

        !(_removeElecCtrlProjectListBlock)? : _removeElecCtrlProjectListBlock(self.model.elecCtrlProjectList);
        self.model.elecCtrlProjectList = nil;
    }
    
    if(!self.model.codes.count) return;
        
     __weak typeof(self) weakSelf = self;
    __strong typeof(weakSelf.viewController) strongVC = weakSelf.viewController;

    
    [MBProgressHUD showMessage:nil toView:self.viewController.view];
    [[YHCarPhotoService new] getElecCtrlProjectListByBillId:self.model.billId//self.model.Id
                                                 sysClassId:self.model.sysClassId
                                                  faultCode:[self.model.codes componentsJoinedByString:@","]
                                                    success:^(NSDictionary *obj) {
                                                        
                                                        //__strong typeof(weakSelf) strongSelf = weakSelf;

                                                        [MBProgressHUD hideHUDForView:strongVC.view];

                                                        NSString *des = [obj valueForKey:@"encyDescs"];
                                                        NSArray *lists = [obj valueForKey:@"list"];
                                                        weakSelf.model.encyDescs = des;
                                                        if(weakSelf.encyDesViewHeight.constant < 40) weakSelf.model.cellHeight += IsEmptyStr(des)? 0 : 40;
                                                        
                                                        weakSelf.model.encyDesHeight = [weakSelf getLabelHeightWithText:des];
                                                        
                                                        
                                                        if (lists.count) {
                                                            NSArray <TTZSurveyModel *>*elecCtrlProjectList = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:lists];
                                                            weakSelf.model.elecCtrlProjectList = elecCtrlProjectList;

                                                            !(weakSelf.getElecCtrlProjectListBlock)? : weakSelf.getElecCtrlProjectListBlock(elecCtrlProjectList);
                                                            NSLog(@"%s", __func__);
                                                            return ;
                                                        }
                                                        
                                                        weakSelf.model.elecCtrlProjectList = nil;

                                                        if(!IsEmptyStr(des)) {
                                                            weakSelf.isShowBtn.selected = YES;
                                                            weakSelf.model.isShowDes = weakSelf.isShowBtn.isSelected;
                                                            weakSelf.model.cellHeight += weakSelf.model.encyDesHeight;
                                                            !(weakSelf.reloadBlock)? : weakSelf.reloadBlock();
                                                            return;
                                                        }
                                                      [MBProgressHUD showError:@"该故障码暂无匹配数据"];
                                                    } failure:^(NSError *error) {
                                                        [MBProgressHUD hideHUDForView:strongVC.view];
                                                    }];
}

- (NSArray <TTZSurveyModel *>*)findSubSurveyModel:(NSArray <TTZSurveyModel *>*)modesl{
    NSMutableArray *temps = [NSMutableArray array];
    [temps addObjectsFromArray:modesl];
    [modesl enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger count = obj.elecCtrlProjectList.count;
        if (count) {
            [temps addObjectsFromArray:[self findSubSurveyModel:obj.elecCtrlProjectList]];
        }
    }];
    return temps;
}

- (void)getEngineWaterTProjectList:(NSString *)projectVal{
    if (self.model.elecCtrlProjectList) {
        NSArray *removes = [self findSubSurveyModel:self.model.elecCtrlProjectList];
        self.model.elecCtrlProjectList = nil;
        !(_removeElecCtrlProjectListBlock)? : _removeElecCtrlProjectListBlock(removes);
    }
    [MBProgressHUD showMessage:nil toView:self.viewController.view];
    [[YHCarPhotoService new] getEngineWaterTProjectListByBillId:self.model.billId
                                                      projectId:self.model.Id
                                                     projectVal:projectVal
                                                        success:^(NSArray *lists) {
                                                            [MBProgressHUD hideHUDForView:self.viewController.view];
                                                            if (lists.count) {
                                                                NSArray <TTZSurveyModel *>*elecCtrlProjectList = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:lists];
                                                                //[elecCtrlProjectList makeObjectsPerformSelector:@selector(setIsRequirRequest:) withObject:@(YES)];
                                                                [elecCtrlProjectList enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                    obj.isRequirRequest = YES;
                                                                }];
                                                                self.model.elecCtrlProjectList = elecCtrlProjectList;
                                                                !(_getElecCtrlProjectListBlock)? : _getElecCtrlProjectListBlock(elecCtrlProjectList);
                                                                return ;
                                                            }

                                                        }
                                                        failure:^(NSError *error) {
                                                            [MBProgressHUD hideHUDForView:self.viewController.view];
                                                        }];
}

//FIXME:  -  UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.hasText){
        
        CGFloat  max = self.model.intervalRange.max.floatValue;
        CGFloat  min = self.model.intervalRange.min.floatValue;
        
        CGFloat  val = [textField.text floatValue];
        
        if (min != max && (val > max || val < min)) {
            //[MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%@~%@内",self.model.intervalRange.min,self.model.intervalRange.max]];
            [MBProgressHUD showError:@"数值异常,请输入有效数值"];

            textField.text = @"";
            return;
        }
    }
    self.model.intervalRange.interval = textField.text;
    
//    self.model.isChange = ![self.model.projectVal isEqualToString:self.model.intervalRange.interval];
    
    self.model.projectVal = self.model.intervalRange.interval;
    if (self.model.isRequirRequest && !IsEmptyStr(textField.text)) {
        [self getEngineWaterTProjectList:textField.text];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![self.model.dataType isEqualToString:@"string"]) {
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
            [MBProgressHUD showError:@"只能输入两位小数"];
            return NO;
        }
        //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4){
            [MBProgressHUD showError:@"只能输入两位小数"];
            return NO;
        }
        
        if([string isEqualToString:@"-"] && [textField.text rangeOfString:@"-"].location == NSNotFound  && self.model.intervalRange.min.floatValue < 0 && string.length > 0 && [str rangeOfString:@"-"].location == 0 ){
            return YES;
        }
        
        if (![@"0123456789." containsString:string] && string.length > 0) {
            [MBProgressHUD showError:@"只能输入数字和小数点"];
            return NO;
        }
    }
    return YES;
}

- (IBAction)textFieldChangeEnd:(UITextField *)sender {
    self.model.isChange = ![sender.text isEqualToString:self.model.intervalRange.interval];
    self.model.projectVal = sender.text;

    return;
    CGFloat  max = self.model.intervalRange.max.floatValue;
    CGFloat  min = self.model.intervalRange.min.floatValue;
    
    CGFloat  val = [sender.text floatValue];
    
    if (min != max && (val > max)) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%@~%@内",self.model.intervalRange.min,self.model.intervalRange.max]];
        sender.text = @"";
        return;
    }
    self.model.intervalRange.interval = sender.text;
    
}


//FIXME:  -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.selectTableView) {
        NSArray <TTZValueModel *>*childList =  [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
        return childList.firstObject.childList.count;
    }
    return self.model.codes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    if (tableView == self.selectTableView) {
        TTZChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZChildCell"];
        NSArray <TTZValueModel *>*childList =  [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
        cell.model = childList.firstObject.childList[indexPath.row];
        cell.didSelectBlock = ^{
            NSArray <TTZChildModel *>*selectChildList = [childList.firstObject.childList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
            NSArray *values = [selectChildList valueForKeyPath:@"value"];
            weakSelf.model.projectVal = [values componentsJoinedByString:@","];
        };
        return cell;
    }

    
    TTZFaultCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZFaultCodeCell"];
    cell.titleLabel.text = self.model.codes[indexPath.row];
    cell.unitLabel.text = IsEmptyStr(self.model.intervalRange.list.firstObject.unit)?(IsEmptyStr(self.model.intervalRange.unit)?self.model.unit : self.model.intervalRange.unit) : self.model.intervalRange.list.firstObject.unit;
    
    if ([self.model.intervalType isEqualToString:@"sameIncrease"]) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%ld%@",indexPath.row+1,self.model.intervalRange.name];
    }else{
        cell.nameLabel.text = nil;
    }
    
    cell.removeBlock = ^(NSString *txt) {
        weakSelf.model.cellHeight -= self.faultCodeListView.rowHeight;
        [weakSelf.model.codes removeObjectAtIndex:indexPath.row];
        !(weakSelf.reloadBlock)? : weakSelf.reloadBlock();

        weakSelf.model.isChange = ![weakSelf.model.projectVal isEqualToString:[weakSelf.model.codes componentsJoinedByString:@","]];
        weakSelf.model.projectVal = [weakSelf.model.codes componentsJoinedByString:@","];

        //带出数据的故障码
        if ([weakSelf.model.intervalType isEqualToString:@"elecCodeForm"]){
                [weakSelf getElecCtrlProjectList];
        }
    };
    return cell;
}


- (void)deleteRemoteImage:(TTZDBModel *)dbModel
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] deleteBillImageByBillId:self.model.billId
                                              imgURL:[dbModel.fileId componentsSeparatedByString:@";"].lastObject
                                                type:1
                                             success:^{
                                                 !(success)? : success();
                                                 [MBProgressHUD hideHUDForView:self.view];
                                             }
                                             failure:^(NSError *error) {
                                                 !(failure)? : failure(error);
                                                 [MBProgressHUD hideHUDForView:self.view];
                                                 [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                             }];
}


//FIXME:  -  UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    if (collectionView == self.checkBoxView) {
//        NSLog(@"--%@--checkBoxView-numberOfItemsInSection-%lu--",self.model.projectName,(unsigned long)self.model.intervalRange.list.count);
//        return self.model.intervalRange.list.count;
//    }
    
    /// 缓存图片
    if(self.model.uploadImgStatus == NO) {
        //NSLog(@"%s--网络图片--%@--checkBoxView-numberOfItemsInSection-%lu", __func__,self.model.projectName,self.model.projectRelativeImgList.count);
        return self.model.projectRelativeImgList.count;
        //return self.model.projectRelativeImgList.count?self.model.projectRelativeImgList.count:1;
    }
    
    /// 上传图片
    //NSLog(@"%s--上传图片--%@--photoView-numberOfItemsInSection-%lu", __func__,self.model.projectName,self.model.dbImages.count);
    return (self.model.dbImages.count > 5)? 5 : self.model.dbImages.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (collectionView == self.checkBoxView) {
//        NSLog(@"--%@--checkBoxView-cellForItemAtIndexPath-",self.model.projectName);
//        TTZValueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTZValueCell" forIndexPath:indexPath];
//        cell.model = self.model.intervalRange.list[indexPath.row];
//        return cell;
//    }
    ///
    YHPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHPhotoAddCell" forIndexPath:indexPath];
    
    if(self.model.uploadImgStatus == NO){
        //NSLog(@"%s--缓存图片--%@--cellForItemAtIndexPath--%@", __func__,self.model.projectName,self.model.projectRelativeImgList);
        cell.clearnBtn.hidden = YES;
        NSString *urlString = @"";
        //if(self.model.projectRelativeImgList.count) urlString = self.model.projectRelativeImgList[indexPath.item];
        urlString = self.model.projectRelativeImgList[indexPath.item];
        
        NSURL *url = [NSURL URLWithString:[YHTools hmacsha1YHJns:urlString width:65]];//[NSURL URLWithString:urlString];
        [cell.imageBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"carModelDefault"]];
        return cell;
    }
    
    __weak typeof(self) weakSelf = self;
    //NSLog(@"%s--上传图片--%@--cellForItemAtIndexPath--%@", __func__,self.model.projectName,self.model.dbImages);
    
    if([self.model.dbImages[indexPath.item].fileId containsString:@"http"]){
        cell.clearnBtn.hidden = NO;
        NSString *url = [self.model.dbImages[indexPath.item].fileId componentsSeparatedByString:@";"].firstObject;
        [cell.imageBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"carModelDefault"] options:SDWebImageRetryFailed completed:nil];
        cell.clearnAction = ^{
            
            [weakSelf deleteRemoteImage:weakSelf.model.dbImages[indexPath.item] success:^{
                
                NSString *thumbImg = [weakSelf.model.dbImages[indexPath.item].fileId componentsSeparatedByString:@";"].firstObject;
                NSString *relativeImg = [weakSelf.model.dbImages[indexPath.item].fileId componentsSeparatedByString:@";"].lastObject;

                [weakSelf.model.projectThumbImgList removeObject:thumbImg];
                [weakSelf.model.projectRelativeImgList removeObject:relativeImg];
                
                TTZDBModel *deleteModel = weakSelf.model.dbImages[indexPath.item];
                [weakSelf.model.dbImages removeObject:deleteModel];
                
                if (weakSelf.model.dbImages.count < 5 && ![self.model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
                                TTZDBModel *defaultModel = [TTZDBModel new];
                                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                                [weakSelf.model.dbImages addObject:defaultModel];
                
                }
                [weakSelf.photoView  reloadData];

                
            } failure:nil];
            NSLog(@"%s", __func__);
        };

    }else{
    
        [cell.imageBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:self.model.dbImages[indexPath.item].image];
        //[cell.imageBtn setImage:self.model.dbImages[indexPath.item].image forState:UIControlStateNormal];
        cell.clearnBtn.hidden = !((BOOL)(self.model.dbImages[indexPath.item].file));
        cell.clearnAction = ^{
            
            TTZDBModel *deleteModel = weakSelf.model.dbImages[indexPath.item];
            [weakSelf.model.dbImages removeObject:deleteModel];
            [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where fileId ='%@'",deleteModel.fileId]];
            
            if (self.model.dbImages.count < 5 && ![self.model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
                TTZDBModel *defaultModel = [TTZDBModel new];
                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                [self.model.dbImages addObject:defaultModel];
                
            }
            [weakSelf.photoView  reloadData];
        };
    }
    return cell;
}

- (void)cylinderAction:(UIButton *)sender{
    TTZValueModel  *child =  [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]].firstObject;

    NSInteger row = sender.tag - 2000;
    TTZChildModel  *model = child.cylinderList[row];
    model.isSelected = !model.isSelected;
    //sender.selected = model.isSelected;
    //0_1,0_n
    NSArray <TTZChildModel *>*selectChild = [child.cylinderList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
    NSArray *vlaues = [selectChild valueForKeyPath:@"value"];
    NSMutableArray *selectValues = [NSMutableArray array];
    
    [vlaues enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectValues addObject:[NSString stringWithFormat:@"%@_%@",@(child.value),obj]];
    }];
    self.model.projectVal = [selectValues componentsJoinedByString:@","];
    
    
    
    //异常：第1缸,第n缸
    NSString *selectNames = [[selectChild valueForKeyPath:@"name"] componentsJoinedByString:@","];
    
    self.model.projectOptionName = [NSString stringWithFormat:@"%@:%@",child.name,selectNames];

    !(_reloadBlock)? : _reloadBlock();

}
//FIXME:  -  单选框
- (void)checkBoxButton:(UIButton *)sender{
    
    NSInteger row = sender.tag - 1000;
    
    TTZValueModel  *model = self.model.intervalRange.list[row];
    /// 不可以点击
    if(model.clickStauts){
        [MBProgressHUD showError:model.clickMsg];
        return;
    }
    
    if (self.model.isRequirRequest) {
        [self getEngineWaterTProjectList:model.isSelected?@"":[NSString stringWithFormat:@"%@",@(model.value)]];
    }
    
    /// 单选
    if ([self.model.intervalType isEqualToString:@"radio"] || [self.model.intervalType isEqualToString:@"independent"]) {
        [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj != model) obj.isSelected = NO;
        }];
    }
    model.isSelected = !model.isSelected;
    //[collectionView reloadData];
    //[self reloadCheckBox];
    
    if (model.isSelected) {
        self.model.cellHeight -= self.selectTableViewHeight.constant;
        
        self.model.cellHeight += self.selectTableView.rowHeight * (model.childList.count? (model.childList.count+1) : 0);
        
        NSString *projectValString = [NSString stringWithFormat:@"%@",@(model.value)];
        NSString *projectOptionName = self.model.projectName;

        if (model.childList.count) {
            NSArray <TTZChildModel *>*selectChild = [model.childList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
            projectValString = [[selectChild valueForKeyPath:@"value"] componentsJoinedByString:@","];
        }
        
        if ([self.model.intervalType isEqualToString:@"independent"]) {
            if (model.value != 1) {//选择异常
                CGFloat topSpacing = 3;
                CGFloat titleHeight = 32;
                CGFloat add2CylinderBtnH = kcheckBoxCellHeight;
                self.model.cellHeight -= self.add2CylinderHeight.constant;
                self.model.cellHeight += (model.cylinderList.count+1)/2 * (kcheckBoxCellHeight + kcheckBoxCellSpacing) + add2CylinderBtnH + topSpacing + titleHeight;
                
                //0_1,0_n
                NSArray <TTZChildModel *>*selectChild = [model.cylinderList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                NSArray *vlaues = [selectChild valueForKeyPath:@"value"];
                NSMutableArray *selectValues = [NSMutableArray array];
                
                [vlaues enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [selectValues addObject:[NSString stringWithFormat:@"%@_%@",@(model.value),obj]];
                }];
                projectValString = [selectValues componentsJoinedByString:@","];
                
                
                
                //异常：第1缸,第n缸
                NSString *selectNames = [[selectChild valueForKeyPath:@"name"] componentsJoinedByString:@","];

                projectOptionName = [NSString stringWithFormat:@"%@:%@",model.name,selectNames];
                
            }else{//选择正常
                self.model.cellHeight -= self.add2CylinderHeight.constant;
            }
        }

        
        self.model.projectVal = projectValString;
        self.model.projectOptionName = projectOptionName;

        
        if (model.value != 1.0) {
            [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.value == 1.0) obj.isSelected = NO;
            }];
        }else{
            [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.value != 1.0) obj.isSelected = NO;
            }];
        }
        
    }else{
        self.model.cellHeight -= self.selectTableViewHeight.constant;
        self.model.projectVal = nil;
        
        self.model.cellHeight -= self.add2CylinderHeight.constant;
        self.model.projectOptionName = nil;
    }
    
    
    !(_reloadBlock)? : _reloadBlock();

    
    __block BOOL isContainFault = NO;
    [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value != 1 && obj.isSelected) {
            isContainFault = YES;
            *stop = YES;
        }
    }];
    
    
    if (self.model.showFaultCode != isContainFault) {
        self.model.showFaultCode = isContainFault;
        
        if(self.model.faultModel){
            [self.model.faultModel.codes removeAllObjects];
            self.model.faultModel.cellHeight = 0;
            !(_reloadAllBlock)? : _reloadAllBlock();
        }
//        [self.model.faultModel.codes removeAllObjects];
//        self.model.faultModel.cellHeight = 0;
//
//        !(_reloadAllBlock)? : _reloadAllBlock();
    }
    
    NSArray *selectArray = [self.model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
    self.model.isChange = ![self.model.projectVal isEqualToString:[selectArray componentsJoinedByString:@","]];

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (collectionView == self.checkBoxView) {
//        
//        TTZValueModel  *model = self.model.intervalRange.list[indexPath.row];
//        /// 不可以点击
//        if(model.clickStauts){
//            [MBProgressHUD showError:model.clickMsg];
//            return;
//        }
//        /// 单选
//        if ([self.model.intervalType isEqualToString:@"radio"]) {
//            [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if(obj != model) obj.isSelected = NO;
//            }];
//        }
//        model.isSelected = !model.isSelected;
//        [collectionView reloadData];
//        
//        __block BOOL isContainFault = NO;
//        [self.model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.value != 1 && obj.isSelected) {
//                isContainFault = YES;
//                *stop = YES;
//            }
//        }];
//        
//        
//        if (self.model.showFaultCode != isContainFault) {
//            self.model.showFaultCode = isContainFault;
//            
//            [self.model.faultModel.codes removeAllObjects];
//            self.model.faultModel.cellHeight = 0;
//            
//            !(_reloadAllBlock)? : _reloadAllBlock();
//        }
//        return;
//    }
    
    ///查看大图
    if(self.model.uploadImgStatus == NO){
        
        NSMutableArray *urls = [NSMutableArray array];
        [self.model.projectRelativeImgList enumerateObjectsUsingBlock:^(NSString * _Nonnull urlString, NSUInteger idx, BOOL * _Nonnull stop) {
           [urls addObject: [YHTools hmacsha1YHJns:urlString width:65]];
        }];
        [YHHUPhotoBrowser showFromImageView:nil withURLStrings:urls placeholderImage:[UIImage imageNamed:@"carModelDefault"] atIndex:indexPath.item dismiss:nil];
        return;
    }
    
    
    if(![self.model.dbImages[indexPath.item].image isEqual:[UIImage imageNamed:@"otherAdd"]]) return;
    
    UICollectionViewCell *sender = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIAlertController showInViewController:self.viewController withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self setImagePickerVC:indexPath.item];
            return;
        }
        [self setPhotoImagePickerVC:indexPath.item];
        
    }];
}



//FIXME:  -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    TTZDBModel *selectModel = self.model.dbImages[self.willSelectIndex];
    
    NSString *fileName = [YHPhotoManger fileName];
    
    if(!selectModel.fileId.length) selectModel.fileId = fileName;
    selectModel.billId = self.model.billId;
    selectModel.image = image;
    selectModel.file = fileName;
    selectModel.code = self.model.code;
    selectModel.timestamp = selectModel.timestamp? selectModel.timestamp : YHPhotoManger.timestamp;

    [selectModel saveOrUpdate:@[@"image"]];
    
#pragma mark 保存图片
    [YHPhotoManger saveImage:image
                subDirectory:self.model.billId
                    fileName:fileName];
    
    if (self.willSelectIndex<4 && self.willSelectIndex == self.model.dbImages.count - 1) {
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        [self.model.dbImages addObject:defaultModel];
    }
    [self.photoView reloadData];
    
}


@end



@implementation TTZCheckHeaderCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = YHBackgroundColor;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 20 , 56)];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView setRounded:bgView.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
        [self.contentView addSubview:bgView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55.5, bgView.bounds.size.width, 0.5)];
        line.backgroundColor = YHBackgroundColor;
        [bgView addSubview:line];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 56)];
        titleLB.font = [UIFont systemFontOfSize:16.0];
        titleLB.textColor = YHColor(48, 48, 48);
        [bgView addSubview:titleLB];
        _titleLabel = titleLB;
        
    }
    return self;
}


@end

@implementation TTZFaultCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 12, 44)];
        nameLB.font = [UIFont systemFontOfSize:15.0];
        nameLB.textColor = YHColor(48, 48, 48);
        [self.contentView addSubview:nameLB];
        _nameLabel = nameLB;
        [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(5);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 12, 44)];
        titleLB.font = [UIFont systemFontOfSize:15.0];
        titleLB.textColor = YHColor(48, 48, 48);
        [self.contentView addSubview:titleLB];
        _titleLabel = titleLB;
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLB.mas_right).offset(5);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *unitLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 12, 44)];
        unitLB.font = [UIFont systemFontOfSize:15.0];
        unitLB.textColor = YHColor(48, 48, 48);
        [self.contentView addSubview:unitLB];
        _unitLabel = unitLB;
        
        [unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLB.mas_right).offset(5);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearnBtn setImage:[UIImage imageNamed:@"重新拍摄"] forState:UIControlStateNormal];
        [self.contentView addSubview:clearnBtn];
        [clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.contentView).offset(0);
            make.width.mas_equalTo(44);
        }];
        
        [clearnBtn addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)removeAction:(UIButton *)sender{
    !(_removeBlock)? : _removeBlock(self.titleLabel.text);
}

@end


@implementation TTZChildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 12, 44)];
        nameLB.font = [UIFont systemFontOfSize:15.0];
        nameLB.textColor = YHColor(48, 48, 48);
        [self.contentView addSubview:nameLB];
        _nameLabel = nameLB;
        [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(5);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearnBtn setImage:[UIImage imageNamed:@"buttonP"] forState:UIControlStateSelected];
        [clearnBtn setImage:[UIImage imageNamed:@"buttonN"] forState:UIControlStateNormal];

        [self.contentView addSubview:clearnBtn];
        [clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.contentView).offset(0);
            make.width.mas_equalTo(44);
        }];
        
        [clearnBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn = clearnBtn;
    }
    return self;
}

- (void)setModel:(TTZChildModel *)model{
    _model = model;
    self.selectBtn.selected = model.isSelected;
    self.nameLabel.text = model.name;
}

- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.model.isSelected = sender.isSelected;
    !(_didSelectBlock)? : _didSelectBlock();

}

@end


