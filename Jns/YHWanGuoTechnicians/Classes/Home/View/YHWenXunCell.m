//
//  YHWenXunCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWenXunCell.h"
#import "YHCommon.h"
#import "Masonry.h"
//#import "MBProgressHUD+MJ.h"
#import "AccidentDiagnosisCell.h"
#import "UIAlertController+Blocks.h"
#import "TTZDBModel.h"
#import "YHPhotoManger.h"
#import "NSObject+BGModel.h"

#import "YHTools.h"
#import "YHStoreTool.h"
#import <UIButton+WebCache.h>

#import "YHDelayCareOptionView.h"

typedef NS_ENUM(NSInteger, YHButtonThree) {
    YHButtonThreeLeft ,//正常
    YHButtonThreeright ,//异常
    YHButtonThreeNone ,//未选择
};

NSString *const notificationSysPhenomenonChange = @"YHNotificationSysPhenomenonChange";
NSString *const notificationOrderProjectSel = @"YHNotificationOrderProjectSel";
NSString *const notificationFault = @"YHNotificationFault";
NSString *const notificationSysPower = @"YHNotificationSysPower";
NSString *const notificationProjectAddItem = @"YHNotificationProjectAddItem";
NSString *const notificationProjectCarSelAll = @"YHNotificationProjectCarSelAll";
NSString *const notificationOutletTemperature = @"YHNotificationOutletTemperature";//出风口温度
NSString *const notificationProjectFaultCode = @"notificationProjectFaultCode";

NSString *const notificationEngineWaterTProjectList = @"notificationEngineWaterTProjectList";//获取发动机水温检测项目列表


@interface YHWenXunCell () <UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *swBleftB;
@property (weak, nonatomic) IBOutlet UIButton *swRightB;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIG;
@property (weak, nonatomic) IBOutlet UISwitch *onSW;
@property (weak, nonatomic) IBOutlet UIView *onSWBox;
@property (weak, nonatomic) IBOutlet UILabel *descSubL;
@property (weak, nonatomic) IBOutlet UILabel *unitValueL;
@property (weak, nonatomic) IBOutlet UIImageView *descIG;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
- (IBAction)onSwAction:(id)sender;
- (IBAction)onAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sel2Button;

@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIImageView *lampIG;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic)NSUInteger index;
@property (weak, nonatomic) IBOutlet UILabel *faultDesc;

@property (weak, nonatomic) NSMutableDictionary *itemInfo;

@property (weak, nonatomic) IBOutlet UIButton *selButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIButton *helpB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedB;
@property (weak, nonatomic) IBOutlet UIButton *saveB;

@property (weak, nonatomic) IBOutlet UIImageView *selFlagIG;
@property (nonatomic)BOOL isExtrend;
- (IBAction)selAction:(id)sender;
/** 图片是否可编辑 */
@property (nonatomic, assign) BOOL isCanEdit;

@property (nonatomic, assign) NSInteger willSelectIndex ;

@property (nonatomic, weak) UIPickerView *pikerView ;

@property (nonatomic, weak) UIView *optionView;

@end

static NSString *registerKey = @"YHwenXun_registerKeys";

@implementation YHWenXunCell

- (UIView *)optionView{
    if (!_optionView) {
        UIView *optionView = [[UIView alloc] init];
        _optionView = optionView;
        [self.contentView addSubview:optionView];
    }
    return _optionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _onSWBox.layer.borderColor  = YHCellColor.CGColor;
    _onSWBox.layer.borderWidth  = 1;
    
    self.isClickLeakBtn = NO;
    
    [self.photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"cell"];
    self.photoView.showsHorizontalScrollIndicator = NO;
    self.photoView.backgroundColor = [UIColor whiteColor];
    // 默认不可编辑
    self.isCanEdit = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerKeyBoardOpration) name:registerKey object:nil];
}
#pragma mark - textField退出键盘通知 ----
- (void)registerKeyBoardOpration{
    [self.numberTF resignFirstResponder];
    
    for (UIView *subview in _boxView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *sub = (UITextField *)subview;
            [sub resignFirstResponder];
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//FIXME:  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!_isCanEdit) {
        NSArray *listArr = self.itemInfo[@"projectRelativeImgList"];
        return listArr.count;
    }
    NSInteger count = [[self.itemInfo valueForKey:@"photo"] count];
    return (count > 5) ? 5 : count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!_isCanEdit) { // 有数据且不可编辑
        NSArray *listArr = self.itemInfo[@"projectRelativeImgList"];
        if (listArr && [listArr isKindOfClass:[NSArray class]]) {
            cell.clearnBtn.hidden = YES;
            NSString *urlStr = listArr[indexPath.row];
            NSString *resultUrl = [YHTools hmacsha1YHJns:urlStr width:40];
            [cell.imageBtn sd_setImageWithURL:[NSURL URLWithString:resultUrl] forState:UIControlStateNormal];
        }
        return cell;
    }
    
    TTZDBModel *model = [self.itemInfo valueForKey:@"photo"][indexPath.item];
    
    [cell.imageBtn setImage:model.image forState:UIControlStateNormal];
    cell.clearnBtn.hidden = !((BOOL)(model.file));//[cell.imageBtn.currentImage isEqual:[UIImage imageNamed:@"otherAdd"]];
    
    __weak typeof(self) weakSelf = self;
    cell.clearnAction = ^{
        
        NSMutableArray <TTZDBModel *>*models = [weakSelf.itemInfo valueForKey:@"photo"];
        [models removeObject:model];
        
        [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where fileId ='%@'",model.fileId]];
        
        if (models.count < 5 && ![models.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
            TTZDBModel *defaultModel = [TTZDBModel new];
            defaultModel.image = [UIImage imageNamed:@"otherAdd"];
            [models addObject:defaultModel];
        }
        [weakSelf.photoView  reloadData];
    };
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isCanEdit) {
        return;
    }
    UICollectionViewCell *sender = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIAlertController showInViewController:self.viewController withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self setPhotoPickerVC:indexPath.item];
            return;
        }
        [self setCameraPickerVC:indexPath.item];
        
    }];
    
}

- (void)setOptionInfo:(NSDictionary *)optionInfo{
    _optionInfo = optionInfo;
    [self.optionView removeFromSuperview];
    self.optionView = nil;
    if ([optionInfo isKindOfClass:[NSNull class]] || !optionInfo) {
        return;
    }

    NSString *name = optionInfo[@"childName"];
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.font = [UIFont systemFontOfSize:16.0];
    nameLable.textAlignment = NSTextAlignmentLeft;
    nameLable.textColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    nameLable.text = name;
    [self.optionView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.top.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(nameLable.superview).offset(-32);
    }];
    
    NSMutableDictionary *delayCareLeakOptionData = [YHStoreTool ShareStoreTool].delayCareLeakOptionData;
    NSMutableArray *arrayOptions = delayCareLeakOptionData[self.itemInfo[@"id"]];
     NSArray *arr = optionInfo[@"childList"];
    for (int i = 0; i<arr.count; i++) {
        YHDelayCareOptionView *fatherView = [[YHDelayCareOptionView alloc] init];
        fatherView.info = arr[i];
        for (int j = 0; j<arrayOptions.count; j++) {
            NSMutableDictionary *optionItem = arrayOptions[j];
            if ([arr[i][@"value"] isEqualToString:optionItem[@"value"]]) {
                fatherView.isSelected = YES;
                break;
            }
        }
        
        fatherView.optionIdStr = [NSString stringWithFormat:@"%@",self.itemInfo[@"id"]];
        fatherView.groupName = self.itemInfo[@"projectName"];
        [self.optionView addSubview:fatherView];
        
        [fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(fatherView.superview).offset(-32);
            make.height.equalTo(@40);
            make.top.equalTo(@((i*40)+40));
            make.left.equalTo(@16);
        }];
    }
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.optionView.superview);
        make.height.equalTo(self.optionView.superview);
        make.left.equalTo(self.optionView.superview);
        make.top.equalTo(@55);
    }];
}
#pragma mark  -  Camera
- (void)setCameraPickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark  -  PhotoLibrary
- (void)setPhotoPickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark  -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *models = [self.itemInfo valueForKey:@"photo"];
    
    TTZDBModel *selectModel = models[self.willSelectIndex];
    
    NSString *fileName = [YHPhotoManger fileName];
    
    if(!selectModel.fileId.length) selectModel.fileId = fileName;
    selectModel.billId = [NSString stringWithFormat:@"%@",[self.itemInfo valueForKey: @"billId"]];
    selectModel.image = image;
    selectModel.file = fileName;
    selectModel.code = [NSString stringWithFormat:@"%@",[self.itemInfo valueForKey: @"code"]];//[self.itemInfo valueForKey:@"code"];
    selectModel.timestamp = selectModel.timestamp? selectModel.timestamp : YHPhotoManger.timestamp;

    [selectModel saveOrUpdate:@[@"image"]];
    //        self.model.images[self.willSelectIndex] = image;
    
#pragma mark 保存图片
    [YHPhotoManger saveImage:image
                subDirectory:selectModel.billId
                    fileName:fileName];
    
    if (self.willSelectIndex<4 && self.willSelectIndex == models.count - 1) {
        //[self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        //defaultModel.billId = self.model.billId;
        //defaultModel.code = self.model.Id;
        [models addObject:defaultModel];
    }
    
    //    if (self.willSelectIndex<4 && self.willSelectIndex == self.model.images.count - 1) {
    //        [self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
    //    }
    [self.photoView reloadData];
}
//FIXME:  -  分割线
- (IBAction)addAction:(id)sender {
    
    NSMutableArray *addItems = _itemInfo[@"addItems"];
    if (!addItems) {
        addItems = [@[]mutableCopy];
        [_itemInfo setObject:addItems forKey:@"addItems"];
    }
    
    NSString *intervalType = _itemInfo[@"intervalType"];
    NSString *name = @"";
    if([intervalType isEqualToString:@"sameIncrease"]
       || [intervalType isEqualToString:@"form"]
       ){
        NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
        NSNumber *maxNumber = intervalRange[@"maxNumber"];//添加个数限制
        if (maxNumber.integerValue <= addItems.count && maxNumber) {
            return;
        }
        if ([intervalType isEqualToString:@"sameIncrease"]) {
            name = [NSString stringWithFormat:@"%lu%@", addItems.count +1, intervalRange[@"name"]];
        }
    }
    
    [addItems addObject:[@{@"name" : name,
                           @"val" : @""}mutableCopy]];
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationProjectAddItem
     object:Nil
     userInfo:nil];
}

- (void)delAction:(UIButton*)button {
    NSMutableArray *addItems = _itemInfo[@"addItems"];
    NSDictionary *item = addItems[button.tag];
    [addItems removeObjectAtIndex:button.tag];
    //    if (_isExtrend) {//延长保修点保存更新项目，备份删除故障码
    //        NSMutableArray *addItemsB = _itemInfo[@"addItemsB"];
    //        if (!addItemsB) {
    //            addItemsB = [@[]mutableCopy];
    //            [_itemInfo setObject:addItemsB forKey:@"addItemsB"];
    //        }
    //        [addItemsB addObject:item];
    //    }
    NSString *intervalType = _itemInfo[@"intervalType"];
    if([intervalType isEqualToString:@"sameIncrease"]){
        
        NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
        for (NSUInteger i = 0; i < addItems.count; i++) {
            NSMutableDictionary *item = addItems[i];
            [item setObject:[NSString stringWithFormat:@"%lu%@", i + 1, intervalRange[@"name"]] forKey:@"name"];
        }
    }
    
    if ([_itemInfo[@"className"] isEqualToString:@"电控故障码"]) {
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationFault
         object:Nil
         userInfo:@{@"item" : item,
                    @"index" : @(_index >> 16),
                    @"row" : [NSNumber numberWithInteger:(_index>=65536)? (_index & 0XFFFF) : _index]}];
    }
    
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationProjectAddItem
     object:Nil
     userInfo:@{@"item" : item,@"row" : [NSNumber numberWithInteger:(_index>=65536)? (_index & 0XFFFF) : _index]}];
}

- (IBAction)selAction:(UIButton*)sender {
    [_itemInfo setObject:[NSNumber numberWithInteger:sender.tag]forKey:@"tag"];
    [_itemInfo setObject:@1 forKey:@"sel"];
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationOrderProjectSel
     object:Nil
     userInfo:@{@"info" : _itemInfo,
                @"index" : [NSNumber numberWithInteger:_index]
                }];
}

- (void)selBlock:(UIButton *)sender{
    
    NSMutableDictionary *faultData = [self.itemInfo valueForKey:@"faultData"];
    faultData[@"sel"] = @(![[faultData valueForKey:@"sel"] boolValue]);
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationProjectFaultCode
     object:Nil
     userInfo:nil];
}

- (void)loadDatasource:(NSDictionary*)desc number:(NSString*)number isSel:(BOOL)isSel{
    _descL.text = desc[@"realname"];
    _descSubL.text = number;
    _descSubL.hidden = NO;
    _onSW.hidden = YES;
    _onSWBox.hidden = YES;
    _arrowIG.hidden = YES;
    _lampIG.hidden = YES;
    [_selFlagIG setImage:[UIImage imageNamed:((isSel)? (@"turnP") : (@"turnN"))]];
}

- (void)loadDatasource:(NSDictionary*)desc number:(NSString*)number{
    [self loadDatasource:desc number:number isSel:NO];
}

- (void)loadDatasource:(NSDictionary*)desc assign:(NSString*)assign{
    _descL.text = desc[@"title"];
    _descSubL.text = assign;
    _descSubL.hidden = !assign;
    _onSW.hidden = YES;
    _onSWBox.hidden = YES;
    _arrowIG.hidden = NO;
    _lampIG.hidden = YES;
}

- (void)loadDatasource:(NSDictionary*)desc descSub:(NSString*)descSub model:(YHWenXunModel)model{
    _descL.text = desc[@"title"];
    _faultDesc.text = descSub;
    _descSubL.hidden = YES;
    _onSW.hidden = (model != YHWenXunModelEngine);
    _arrowIG.hidden = (model != YHWenXunModelDesc);
    _lampIG.hidden = (model != YHWenXunModelLamp);
    
    NSNumber *sel = desc[@"sel"];
    [_lampIG setImage:[UIImage imageNamed:((sel.boolValue)? (@"order_8") : (@"me_46"))]];
    [_arrowIG setImage:[UIImage imageNamed:((descSub && ![descSub isEqualToString:@""])? (@"order_17") : (@"me_7"))]];
}

- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info index:(NSUInteger)index isExtrend:(BOOL)isExtrend{
    
    
    NSInteger uploadImgStatus = [info[@"uploadImgStatus"] integerValue];
    _isCanEdit = uploadImgStatus == 0 ? NO : YES;
    _isExtrend = isExtrend;
    _helpB.tag = index;
    _saveB.tag = index;
    self.index = index;
    [self loadDatasourceInitialInspection:info];
}

- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info {
    
    self.itemInfo = info;
    [self.photoView reloadData];
    NSString *isRequir = info[@"isRequir"];
    NSString *imgSrc = info[@"imgSrc"];
    _helpB.hidden = IsEmptyStr(imgSrc);
    
    NSDictionary *intervalRangeDict = [info valueForKey:@"intervalRange"];
    NSString *placeholder;
    if ([intervalRangeDict isKindOfClass:[NSDictionary class]]) {
        placeholder = [intervalRangeDict valueForKey:@"placeholder"];
    }
    placeholder = placeholder? placeholder : @"请输入";
    
    _numberTF.placeholder = (([isRequir isEqualToString:@"1"]) ? (@"必填") : (placeholder));
//    if([[info valueForKey:@"projectName"] isEqualToString:@"刹车片厚度"] && ![isRequir isEqualToString:@"1"]) _numberTF.placeholder = @"请输入直接测量值(含背板厚度)";
//    if([[info valueForKey:@"projectName"] isEqualToString:@"轮胎生产时间"] && ![isRequir isEqualToString:@"1"]) _numberTF.placeholder = @"如输入数字0218 (02代表周，18代表年)";

    
    _numberTF.inputView = nil;
    NSDictionary *intervalRange = info[@"intervalRange"];
    
    NSString *intervalType = info[@"intervalType"];
    NSString *dataType = info[@"dataType"];
    
    if([intervalRange isKindOfClass:[NSDictionary class]]){
        NSArray *list = [intervalRange valueForKey:@"list"];
        if([list isKindOfClass:[NSArray class]]){
            NSDictionary *obj = list.firstObject;
            if([obj isKindOfClass:[NSDictionary class]]){
                NSString *type = [obj valueForKey:@"dataType"];
                dataType = type? type:dataType;
            }
        }else{
            NSString *type = [intervalRange valueForKey:@"dataType"];
            dataType = type? type:dataType;
        }
    }
    _sel2Button.hidden = YES;
    _addButton.hidden = YES;
    _saveB.hidden = YES;
    _descL.text = info[@"projectName"];
    _unitL.hidden = NO;
    //    if (_isExtrend) {
    //        if ([intervalRange isKindOfClass:[NSDictionary class]]) {
    //            NSNumber *min = intervalRange[@"min"];
    //            NSNumber *max = intervalRange[@"max"];
    //            _numberTF.placeholder = [NSString stringWithFormat:@"填写%@-%@", min, max];
    //        }else{
    //            _numberTF.placeholder = @"请输入";
    //        }
    //    }
    
    //    if([intervalRange isKindOfClass:[NSDictionary class]]){
    //
    //        NSArray *list = [intervalRange valueForKey:@"list"];
    //        if ([list isKindOfClass:[NSArray class]] && [list.firstObject valueForKey:@"tips"]) {
    //            /////
    //            NSMutableArray *message = [NSMutableArray arrayWithCapacity:list.count];
    //            [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                [message addObject:[NSString stringWithFormat:@"%@:%@",obj[@"name"],obj[@"tips"]]];
    //            }];
    //            [UIAlertController showAlertInViewController:self.viewController withTitle:nil message:nil cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:message tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
    //            }];
    //        }
    //
    //    }
    
    
    if ([dataType isEqualToString:@"year"]
        || [dataType isEqualToString:@"int"]
        || [dataType isEqualToString:@"number"]
        || [dataType isEqualToString:@"float"]) {
        _numberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else {
        _numberTF.keyboardType = UIKeyboardTypeDefault;
    }
    [_boxView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    if ((id)intervalRange == [NSNull null] || [intervalRange isKindOfClass:[NSString class]]) {
        _onSW.hidden = YES;
        _onSWBox.hidden = YES;
        _unitValueL.hidden = YES;
        _numberTF.hidden = NO;
        _selButton.hidden = YES;
        
    }else if([intervalType isEqualToString:@"gatherInputAdd"]
             || [intervalType isEqualToString:@"sameIncrease"]
             || [intervalType isEqualToString:@"form"]
             || [intervalType isEqualToString:@"elecCodeForm"]) {
        //                static BOOL ii = YES;
        //                if ([intervalType isEqualToString:@"form"] && ii) {
        //                    ii = NO;
        //                    intervalRange = [info[@"intervalRange"] mutableCopy];
        //                    [info setObject:intervalRange forKey:@"intervalRange"];
        //                    NSMutableArray *list = [intervalRange[@"list"] mutableCopy];
        //                    [list addObject:list[0]];
        //                    [intervalRange setValue:list forKey:@"list"];
        //                }
        BOOL isSameIncrease = [intervalType isEqualToString:@"sameIncrease"];
        [_addButton setTitle:((isSameIncrease)? (@"添加") : (@"添加")) forState:UIControlStateNormal];
        NSMutableArray *addItems = info[@"addItems"];
        NSDictionary *faultData = [info valueForKey:@"faultData"];
        
        if([intervalType isEqualToString:@"sameIncrease"]
           || [intervalType isEqualToString:@"form"]
           ){
            NSNumber *maxNumber = intervalRange[@"maxNumber"];//添加个数限制
            _addButton.hidden = (addItems.count == maxNumber.integerValue);
        }else{
            _addButton.hidden = NO;
        }
        
        for (NSUInteger i = 0; i < addItems.count; i++) {
            
            NSDictionary *item = addItems[i];
            UITextField *txNameFT = [[UITextField alloc] initWithFrame:CGRectZero];
            txNameFT.placeholder = @"模块名";
            txNameFT.tag = i+0X1000;
            txNameFT.delegate = self;
            //            txNameFT.backgroundColor = [UIColor redColor];
            txNameFT.text = item[@"name"];
            txNameFT.enabled = !isSameIncrease;
            txNameFT.hidden = (((NSArray *)intervalRange).count == 1);
            
            UITextField *txValFT = [[UITextField alloc] initWithFrame:CGRectZero];
            txValFT.placeholder = ((isSameIncrease)? (@"请输入") : (@"请输入"));
            txValFT.tag = i;
            txValFT.delegate = self;
            txValFT.text = item[@"val"];
            
            if( [intervalType isEqualToString:@"form"]){
                NSArray *list = ((NSDictionary *)intervalRange)[@"list"];
                if(list.count == 2){
                    txNameFT.placeholder = @"请输入";
                    txNameFT.hidden = NO;
                }else{
                    txNameFT.hidden = YES;
                }
            }
            
            if ([dataType isEqualToString:@"year"]
                || [dataType isEqualToString:@"int"]
                || [dataType isEqualToString:@"number"]
                || [dataType isEqualToString:@"float"]) {
                txValFT.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }else {
                txValFT.keyboardType = UIKeyboardTypeDefault;
            }

            
            UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
            [lineL setBackgroundColor:YHLineColor];
            
            UIButton *delB = [[UIButton alloc] initWithFrame:CGRectZero];
            [delB setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            delB.tag = i;
            [delB addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
            [_boxView addSubview:txNameFT];
            [_boxView addSubview:txValFT];
            [_boxView addSubview:lineL];
            [_boxView addSubview:delB];
            
            __weak __typeof__(self) weakSelf = self;
            [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxView.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.boxView.mas_right).with.offset(0);
                make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i -1);
                make.height.equalTo(@1);
            }];
            
            if (addItems.count == i + 1) {
                
                [txNameFT mas_makeConstraints:^(MASConstraintMaker *make) {
                    //                    make.left.equalTo(weakSelf.boxView.mas_left).with.offset(60);
                    make.right.equalTo(txValFT.mas_left).with.offset(10);
                    make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i);
                    if (!faultData ||  ![[faultData valueForKey:@"encyDescs"] length])  make.bottom.equalTo(weakSelf.boxView.mas_bottom).with.offset(0);
                    make.width.equalTo(@100);
                    make.height.equalTo(@55);
                }];
#if 1
                if (faultData && [[faultData valueForKey:@"encyDescs"] length])
                {
                    
                    UIView *encyDescsContentView = [[UIView alloc] init];
                    kViewBorderRadius(encyDescsContentView, 5, 1, [UIColor colorWithWhite:0 alpha:0.7]);
                    [_boxView addSubview:encyDescsContentView];
                    [encyDescsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(txNameFT.mas_bottom);
                        make.left.mas_equalTo(_boxView).offset(15);
                        make.right.mas_equalTo(_boxView).offset(-15);
                        make.bottom.mas_equalTo(_boxView.mas_bottom).offset(-10);
                    }];
                    
                    UILabel *title = [[UILabel alloc] init];
                    title.text = @"百科";
                    title.textColor = [UIColor colorWithWhite:0 alpha:0.7];
                    [encyDescsContentView addSubview:title];
                    [title mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(encyDescsContentView.mas_top).offset(10);
                        make.left.mas_equalTo(encyDescsContentView).offset(10);
                        make.height.mas_equalTo(20);
                    }];
                    
                    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    upBtn.selected = [[faultData valueForKey:@"sel"] boolValue];
                    [upBtn setTitle:@"展开" forState:UIControlStateNormal];
                    [upBtn setTitle:@"收起" forState:UIControlStateSelected];
                    [upBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
                    [upBtn addTarget:self action:@selector(selBlock:) forControlEvents:UIControlEventTouchUpInside];
                    [encyDescsContentView addSubview:upBtn];
                    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(title);
                        make.right.mas_equalTo(encyDescsContentView).offset(-10);
                    }];
                    
                    UILabel *desLB = [UILabel new];
                    //desLB.backgroundColor = [UIColor redColor];
                    desLB.textColor = YHColorWithHex(0x888888);
                    desLB.preferredMaxLayoutWidth = _boxView.frame.size.width;
                    desLB.numberOfLines = 0;
                    desLB.text = upBtn.isSelected? [faultData valueForKey:@"encyDescs"] : @"";
                    [encyDescsContentView addSubview:desLB];
                    [desLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(title.mas_bottom).offset(10);
                        make.left.mas_equalTo(encyDescsContentView).offset(10);
                        make.right.mas_equalTo(encyDescsContentView).offset(-10);
                        make.bottom.mas_equalTo(encyDescsContentView.mas_bottom).offset(-10);
                    }];
                }
#endif
                
            }else{
                [txNameFT mas_makeConstraints:^(MASConstraintMaker *make) {
                    //                make.left.equalTo(weakSelf.boxView.mas_left).with.offset(60);
                    make.right.equalTo(txValFT.mas_left).with.offset(10);
                    make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i);
                    make.width.equalTo(@100);
                    make.height.equalTo(@55);
                }];
            }
            
            [txValFT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxView.mas_right).with.offset(-80);
                make.left.equalTo(txNameFT.mas_right).with.offset(10);
                make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i );
                //                make.width.equalTo(txNameFT.mas_width);
                make.width.equalTo(@100);
                make.height.equalTo(@55);
            }];
            
            
            [delB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxView.mas_right).with.offset(-20);
                make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i);
                make.width.equalTo(@55);
                make.height.equalTo(@55);
            }];
            
            if (isSameIncrease) {
                UILabel *lineUnit = [[UILabel alloc] initWithFrame:CGRectZero];
                lineUnit.text = intervalRange[@"unit"];
                [_boxView addSubview:lineUnit];
                
                [lineUnit mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxView.mas_right).with.offset(-80);
                    //                    make.left.equalTo(txNameFT.mas_right).with.offset(10);
                    make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i );
                    //                make.width.equalTo(txNameFT.mas_width);
                    //                    make.width.equalTo(@100);
                    make.height.equalTo(@55);
                }];
            }
            
            if ([intervalType isEqualToString:@"form"]) {
                
                NSArray *list = ((NSDictionary *)intervalRange)[@"list"];
                if(list.count == 2){
                    NSDictionary *item1 = list[0];
                    UILabel *lineUnit1 = [[UILabel alloc] initWithFrame:CGRectZero];
                    lineUnit1.text = item1[@"unit"];
                    [_boxView addSubview:lineUnit1];
                    
                    [lineUnit1 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(txValFT.mas_left).with.offset(-5);
                        //                    make.left.equalTo(txNameFT.mas_right).with.offset(10);
                        make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i );
                        //                make.width.equalTo(txNameFT.mas_width);
                        //                    make.width.equalTo(@100);
                        make.height.equalTo(@55);
                    }];
                    
                    NSDictionary *item2 = list[1];
                    UILabel *lineUnit = [[UILabel alloc] initWithFrame:CGRectZero];
                    lineUnit.text = item2[@"unit"];
                    [_boxView addSubview:lineUnit];
                    
                    [lineUnit mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(weakSelf.boxView.mas_right).with.offset(-80);
                        //                    make.left.equalTo(txNameFT.mas_right).with.offset(10);
                        make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i );
                        //                make.width.equalTo(txNameFT.mas_width);
                        //                    make.width.equalTo(@100);
                        make.height.equalTo(@55);
                    }];
                    
                }else{
                    NSDictionary *item1 = list[0];
                    UILabel *lineUnit = [[UILabel alloc] initWithFrame:CGRectZero];
                    lineUnit.text = item1[@"unit"];
                    [_boxView addSubview:lineUnit];
                    
                    [lineUnit mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(weakSelf.boxView.mas_right).with.offset(-80);
                        //                    make.left.equalTo(txNameFT.mas_right).with.offset(10);
                        make.top.equalTo(weakSelf.boxView.mas_top).with.offset(55. * i );
                        //                make.width.equalTo(txNameFT.mas_width);
                        //                    make.width.equalTo(@100);
                        make.height.equalTo(@55);
                    }];
                }
            }
        }
        
        _saveB.hidden = !(_isExtrend && [intervalType isEqualToString:@"elecCodeForm"]);
        //        _addButton.hidden = NO;
        _onSW.hidden = YES;
        _onSWBox.hidden = YES;
        _lineV.hidden = YES;
        _unitL.hidden = YES;
        _unitValueL.hidden = YES;
        _numberTF.hidden = YES;
        _selButton.hidden = YES;
        _sel2Button.hidden = YES;
        return;
    }else if([intervalRange isKindOfClass:[NSDictionary class]] ) {
        NSArray *list = intervalRange[@"list"];
        NSString *ajaxUrl = intervalRange[@"ajaxUrl"];
        if(ajaxUrl){
            NSDictionary *valueSel = info[@"valueSel"];
            if (valueSel) {
                [_selButton setTitle:valueSel[@"name"] forState:UIControlStateNormal];
            }else{
                [_selButton setTitle:@"请选择" forState:UIControlStateNormal];
            }
            _onSW.hidden = YES;
            _onSWBox.hidden = YES;
            _unitValueL.hidden = YES;
            _numberTF.hidden = YES;
            _selButton.hidden = NO;
            _sel2Button.hidden = YES;
            
        }else if(!list) {
            _onSW.hidden = YES;
            _onSWBox.hidden = YES;
            _unitValueL.hidden = YES;
            _numberTF.hidden = NO;
            _selButton.hidden = YES;
        }else {
            _onSW.hidden = NO;
            _onSWBox.hidden = NO;
            _unitValueL.hidden = NO;
            _numberTF.hidden = YES;
            _selButton.hidden = YES;
        }
    }else if([intervalType isEqualToString:@"gangedAjaxSelect"]) {
        NSDictionary *valueSel = info[@"valueSel"];
        if (valueSel) {
            [_selButton setTitle:valueSel[@"name"] forState:UIControlStateNormal];
        }else{
            [_selButton setTitle:@"请选择" forState:UIControlStateNormal];
        }
        NSDictionary *valueSel2 = info[@"valueSel2"];
        if (valueSel2) {
            [_sel2Button setTitle:valueSel2[@"name"] forState:UIControlStateNormal];
        }else{
            [_sel2Button setTitle:@"请选择" forState:UIControlStateNormal];
        }
        _onSW.hidden = YES;
        _onSWBox.hidden = YES;
        _lineV.hidden = YES;
        _unitL.hidden = YES;
        _unitValueL.hidden = YES;
        _numberTF.hidden = YES;
        _selButton.hidden = NO;
        _sel2Button.hidden = NO;
        return;
    }else {
    }
    
    if (info[@"value"]) {
        _numberTF.text = info[@"value"];
    }else{
        _numberTF.text = @"";
    }
    NSNumber *sel = _itemInfo[@"sel"];
    if (sel) {
        [self unitValue:sel.boolValue];
    }else{
        [self unitValue:YHButtonThreeNone];
        _unitValueL.text = @"";
        _onSW.on = NO;
    }
    _unitL.text = info[@"unit"];
    _lineV.hidden = YES;
}

- (void)unitValue:(YHButtonThree)model{
    NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
    [_swBleftB setBackgroundColor:[UIColor whiteColor]];
    [_swBleftB setTitleColor:YHCellColor forState:UIControlStateNormal];
    [_swRightB setBackgroundColor:[UIColor whiteColor]];
    [_swRightB setTitleColor:YHCellColor forState:UIControlStateNormal];
    
    if (model == YHButtonThreeLeft) {
        [_swBleftB setBackgroundColor:YHNaviColor];
        [_swBleftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (model == YHButtonThreeright) {
        [_swRightB setBackgroundColor:YHNaviColor];
        [_swRightB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ((id)intervalRange == [NSNull null] || [intervalRange isKindOfClass:[NSString class]] || [intervalRange isKindOfClass:[NSArray class]] || ![intervalRange isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *list = intervalRange[@"list"];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //        if (_isExtrend) {
        if (([item[@"value"] isEqualToString:@"1"]) || [item[@"value"] isEqualToString:@"无"] || [item[@"value"] isEqualToString:@"正常"]) {
            _swBleftB.titleLabel.text = item[@"name"];
            [_swBleftB setTitle:item[@"name"] forState:UIControlStateNormal];
        }
        //            if(![item[@"value"] isEqualToString:@"0"])
        else{
            _swRightB.titleLabel.text = item[@"name"];
            [_swRightB setTitle:item[@"name"] forState:UIControlStateNormal];
        }
        //        }else{
        //            if (([item[@"value"] isEqualToString:@"1"])) {
        //                _swRightB.titleLabel.text = item[@"name"];
        //                [_swRightB setTitle:item[@"name"] forState:UIControlStateNormal];
        //            }
        //            if (([item[@"value"] isEqualToString:@"0"])) {
        //                _swBleftB.titleLabel.text = item[@"name"];
        //                [_swBleftB setTitle:item[@"name"] forState:UIControlStateNormal];
        //            }
        //        }
        
    }];
    
    //    NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
    //    if ((id)intervalRange == [NSNull null] || [intervalRange isKindOfClass:[NSString class]]) {
    //        return;
    //    }
    //    NSArray *list = intervalRange[@"list"];
    //    _unitValueL.textColor = ((!on)? (YHNaviColor) : (YHCellColor));
    //    _onSW.on = !on;
    //    [list enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //        if (_isExtrend) {
    //            if (([item[@"value"] isEqualToString:@"1"]) && !on) {
    //                _unitValueL.text = item[@"name"];
    //                *stop = YES;
    //            }
    //            if(![item[@"value"] isEqualToString:@"1"] && on){
    //                _unitValueL.text = item[@"name"];
    //                *stop = YES;
    //            }
    //        }else{
    //            if (([item[@"value"] isEqualToString:@"1"]) && !on) {
    //                _unitValueL.text = item[@"name"];
    //            }
    //            if (([item[@"value"] isEqualToString:@"0"]) && on) {
    //                _unitValueL.text = item[@"name"];
    //            }
    //        }
    //
    //    }];
}

- (void)loadDatasource:(NSString*)desc unit:(NSString*)unit isOnly:(BOOL)isOnly{
    _descL.text = desc;
    _onSW.hidden = isOnly;
    _numberTF.hidden = !isOnly;
    _unitL.hidden = !isOnly;
    _unitL.text = unit;
    _lineV.hidden = isOnly;
}

- (void)loadDatasource:(NSString*)desc unit:(NSString*)unit isOnly:(BOOL)isOnly index:(NSUInteger)index isOn:(BOOL)isOn{
    _descL.text = desc;
    _onSW.hidden = isOnly;
    _numberTF.hidden = !isOnly;
    _unitL.hidden = !isOnly;
    _unitL.text = unit;
    _lineV.hidden = isOnly;
    _onSW.on = isOn;
    self.index = index;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)onSwAction:(id)sender {
    if (_itemInfo) {
        [self unitValue:!(_onSW.isOn)];
        [_itemInfo setObject:[NSNumber numberWithBool:!(_onSW.isOn)] forKey:@"sel"];
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationProjectCarSelAll
         object:Nil
         userInfo:@{@"index" : @(self.index)}];
    }else{
        
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationSysPhenomenonChange
         object:Nil
         userInfo:@{@"sel" : [NSNumber numberWithBool:!(_onSW.isOn)], @"index" : [NSNumber numberWithInteger:_index]}];
    }
}


- (IBAction)onSWExtrendAction:(UIButton*)sender {
    BOOL on = !(sender.tag);
    NSDictionary *intervalRange = self.itemInfo[@"intervalRange"];
    // 是否联动
    BOOL isRelate = (!intervalRange[@"isChild"] || [intervalRange[@"isChild"] intValue] != 1) ? NO : YES;
    if (_itemInfo) {
        
        NSNumber *sel = _itemInfo[@"sel"];
        if (sel.integerValue == !on && sel) { // 没有任何按钮被选中的情况
            [_itemInfo removeObjectForKey:@"sel"];
            [self unitValue:YHButtonThreeNone];
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationProjectCarSelAll
             object:Nil
             userInfo:@{@"index" : @(_index + on),@"on":@(on),@"isSelect":@"NO",@"id":self.itemInfo[@"id"],@"projectName":self.itemInfo[@"projectName"],@"isRelate":[NSNumber numberWithBool:isRelate],@"indexPath":self.indexPath}];
        }else{
            [self unitValue:!(on)];
            //[_itemInfo setObject:[NSNumber numberWithBool:!(on)] forKey:@"sel"];
            [_itemInfo setObject:@(!on) forKey:@"sel"];
            
            NSArray *list = [[_itemInfo valueForKey:@"intervalRange"] valueForKey:@"list"];
            [list enumerateObjectsUsingBlock:^(NSDictionary * item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (on == YES) {
                    // 选择正常
                    NSMutableDictionary *delayCareLeakOptionData = [[YHStoreTool ShareStoreTool].delayCareLeakOptionData mutableCopy];
                    [delayCareLeakOptionData setValue:[NSMutableArray array] forKey:self.itemInfo[@"id"]];
                    [[YHStoreTool ShareStoreTool] setDelayCareLeakOptionData:delayCareLeakOptionData];
                    
                    if (([item[@"value"] isEqualToString:@"1"]) || [item[@"value"] isEqualToString:@"无"] || [item[@"value"] isEqualToString:@"正常"]) {
                        [_itemInfo setObject:item[@"value"] forKey:@"sel_value"];
                        *stop = YES;
                    }
                    
                }else{
                    // 选择异常
                    if (([item[@"value"] isEqualToString:@"1"]) || [item[@"value"] isEqualToString:@"无"] || [item[@"value"] isEqualToString:@"正常"]) {
                        
                    }else{
                        [_itemInfo setObject:item[@"value"] forKey:@"sel_value"];
                        *stop = YES;
                    }
                }
            }];
            
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationProjectCarSelAll
             object:Nil
             userInfo:@{@"index" : @(_index + on),@"on":@(on),@"isSelect":@"YES",@"id":self.itemInfo[@"id"],@"projectName":self.itemInfo[@"projectName"],@"isRelate":[NSNumber numberWithBool:isRelate],@"indexPath":self.indexPath}];
        }
        
    }else{
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationSysPhenomenonChange
         object:Nil
         userInfo:@{@"sel" : [NSNumber numberWithBool:!(on)], @"index" : [NSNumber numberWithInteger:_index]}];
    }
}


- (IBAction)onAction:(id)sender {
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationSysPower
     object:Nil
     userInfo:@{@"sel" : [NSNumber numberWithBool:_onSW.isOn], @"index" : [NSNumber numberWithInteger:_index]}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_numberTF == textField) {
        [_itemInfo setObject:@1 forKey:@"sel"];
        if (self.pikerView) {
            self.pikerView.hidden = YES;
            [self.pikerView removeFromSuperview];
        }
        
        if (_isExtrend) {
            NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
            NSString *val = textField.text;
            if ([intervalRange isKindOfClass:[NSDictionary class]]) {
                NSNumber *min = intervalRange[@"min"];
                NSNumber *max = intervalRange[@"max"];
                
                if (min && max && min != max && ((val.floatValue < min.floatValue || val.floatValue > max.floatValue)
                                                 && ![val isEqualToString:@""] )|| [val isEqualToString:@"-"]) {
                    
                    //                if (((val.floatValue < min.floatValue || val.floatValue > max.floatValue)
                    //                     && ![val isEqualToString:@""] )|| [val isEqualToString:@"-"]) {
                    textField.text = @"";
                    [MBProgressHUD showError:@"数值异常，请输入有效数值"];
                    return;
                }
            }
            /*
             空调出风口温度	标准低压压力(bar)	  标准高压压力(bar)
             0~8	         	0.5~3.0     	   6~15
             
             如果空调出风口温度是0~8，判断高低压数据是否有在此范围值，如果不是，返回空调数据有误，请填写真实检测数据
             如果空调出风口温度不是0~8或者高低压在范围值内，往下走
             */
            
            NSDictionary *temperature = _itemInfo[@"temperature"];
            if ([_itemInfo[@"projectName"] isEqualToString:@"空调系统低压压力"]) {
                if (![val isEqualToString:@""]) {
                    NSString *valOutlet = temperature[@"valOutlet"];
                    if (valOutlet.floatValue >= 0 && valOutlet.floatValue <= 8 && !(val.floatValue >= 0.5 && val.floatValue <= 3.) && valOutlet && ![valOutlet isEqualToString:@""]) {
                        textField.text = @"";
                        [MBProgressHUD showError:@"空调数据有误，请填写真实检测数据"];
                        return;
                    }
                }
                
                [[NSNotificationCenter
                  defaultCenter]postNotificationName:notificationOutletTemperature
                 object:Nil
                 userInfo:@{@"valD" : val}];
            }
            
            if ([_itemInfo[@"projectName"] isEqualToString:@"空调系统高压压力"]) {
                if (![val isEqualToString:@""]) {
                    NSString *valOutlet = temperature[@"valOutlet"];
                    if (valOutlet.floatValue >= 0 && valOutlet.floatValue <= 8 && !(val.floatValue >= 6 && val.floatValue <= 15) && valOutlet && ![valOutlet isEqualToString:@""]) {
                        textField.text = @"";
                        [MBProgressHUD showError:@"空调数据有误，请填写真实检测数据"];
                        return;
                    }
                }
                [[NSNotificationCenter
                  defaultCenter]postNotificationName:notificationOutletTemperature
                 object:Nil
                 userInfo:@{@"valG" : val}];
            }
            
            if ([_itemInfo[@"projectName"] isEqualToString:@"出风口温度"]) {
                NSString *valG = temperature[@"valG"];
                NSString *valD = temperature[@"valD"];
                if (![val isEqualToString:@""]) {
                    
                    if ((valG && ![valG isEqualToString:@""])
                        || (valD && ![valD isEqualToString:@""])) {
                        if ((!(valD.floatValue >= 0.5 && valD.floatValue <= 3.) || !(valG.floatValue >= 6 && valG.floatValue <= 15))
                            && (val.floatValue >= 0 && val.floatValue <= 8)) {
                            textField.text = @"";
                            [MBProgressHUD showError:@"空调数据有误，请填写真实检测数据"];
                            return;
                        }
                    }
                    
                    [[NSNotificationCenter
                      defaultCenter]postNotificationName:notificationOutletTemperature
                     object:Nil
                     userInfo:@{@"valOutlet" : val}];
                }
            }
            //#pragma mark - 发动机水温 ---
            //            if ([_itemInfo[@"projectName"] isEqualToString:@"发动机水温"]) {
            //                NSLog(@"%s---发动机水温", __func__);
            //                [[NSNotificationCenter
            //                  defaultCenter]postNotificationName:notificationEngineWaterTProjectList
            //                 object:Nil
            //                 userInfo:@{@"projectVal" : val,@"projectId":_itemInfo[@"id"],@"index":@(_index)}];
            //
            //            }
            
        }
        
#pragma mark - 发动机水温 ---
        
        NSInteger depth = [[_itemInfo valueForKey:@"depth"] integerValue];
        if (depth && depth < 3) {
            
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationEngineWaterTProjectList
             object:Nil
             userInfo:@{@"projectVal" : textField.text,@"projectId":_itemInfo[@"id"],@"index":@(_index)}];
            
        }else if ([_itemInfo[@"projectName"] isEqualToString:@"发动机水温"]) {
            NSLog(@"%s---发动机水温", __func__);
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationEngineWaterTProjectList
             object:Nil
             userInfo:@{@"projectVal" : textField.text,@"projectId":_itemInfo[@"id"],@"index":@(_index)}];
        }
        
        if (![textField.text isEqualToString:@""]) {
            [_itemInfo setObject:textField.text forKey:@"value"];
        }else{
            [_itemInfo removeObjectForKey:@"value"];
            [_itemInfo removeObjectForKey:@"sel"];
        }
    }else{
        
        NSDictionary *intervalRange = _itemInfo[@"intervalRange"];
        NSString *intervalType = _itemInfo[@"intervalType"];
        NSMutableArray *addItems = _itemInfo[@"addItems"];
        NSUInteger tag = textField.tag;
        NSString *text = textField.text;
        NSUInteger index = tag & 0XFFF;
        if (addItems.count <= index) {
            return;
        }
        
        NSMutableDictionary *item = addItems[tag & 0XFFF];
        if (tag >= 0X1000) {
            if ([intervalType isEqualToString:@"form"]) {//延长保修单： 发动机点火提前角、前后氧传感器数据这几个数据做限制
                NSArray *list = intervalRange[@"list"];
                NSDictionary *rangeItem = list[0];
                NSString *val = textField.text;
                if ([intervalRange isKindOfClass:[NSDictionary class]]) {
                    NSNumber *min = rangeItem[@"min"];
                    NSNumber *max = rangeItem[@"max"];
                    if (((val.floatValue < min.floatValue || val.floatValue > max.floatValue)
                         && ![val isEqualToString:@""] )|| [val isEqualToString:@"-"]) {
                        textField.text = @"";
                        [MBProgressHUD showError:@"数值异常，请输入有效数值"];
                        return;
                    }
                }
            }
            [item setObject:text forKey:@"name"];
        }else{
            for (NSDictionary *sub in addItems) {
                NSString *val = sub[@"val"];
                if ([val isEqualToString:text] && item != sub && ![textField.text isEqualToString:@""]
                    && [intervalType isEqualToString:@"elecCodeForm"]) {
                    textField.text = @"";
                    [MBProgressHUD showError:@"输入故障码已存在！"];
                    return;
                }
            }
            if ([intervalType isEqualToString:@"form"]) {
                NSArray *list = intervalRange[@"list"];
                NSDictionary *rangeItem;
                if (list.count == 1) {
                    rangeItem = list[0];
                }else{
                    rangeItem = list[1];
                }
                NSString *val = textField.text;
                if ([intervalRange isKindOfClass:[NSDictionary class]]) {
                    NSNumber *min = rangeItem[@"min"];
                    NSNumber *max = rangeItem[@"max"];
                    if (((val.floatValue < min.floatValue || val.floatValue > max.floatValue)
                         && ![val isEqualToString:@""] )|| [val isEqualToString:@"-"]) {
                        textField.text = @"";
                        [MBProgressHUD showError:@"数值异常，请输入有效数值"];
                        return;
                    }
                }
            }
            
            
            [item setObject:text forKey:@"val"];
            //故障码 匹配出初检项
            if (intervalRange.count == 1 && !_isExtrend) {
                [[NSNotificationCenter
                  defaultCenter]postNotificationName:notificationFault
                 object:Nil
                 userInfo:@{@"item" : item,
                            @"index" : @(_index >> 16),
                            //@"row" : [NSNumber numberWithInteger:(_index>=65536)? (_index >> 16) : _index],
                            @"row" : [NSNumber numberWithInteger:(_index>=65536)? (_index & 0XFFFF) : _index],
                            }];
            }
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    // 轮胎生产时间项对应ID
    //    NSString *tyreProductTimeId = _itemInfo[@"id"];
    NSString *projectName = _itemInfo[@"projectName"];
    if ([projectName isEqualToString:@"轮胎生产时间"]) {
//        [self popTimeSelectView:textField];
        return YES;
    }
    
    if ([_itemInfo[@"dataType"] isEqualToString:@"date"]) {
        [_itemInfo setObject:@0 forKey:@"tag"];
        [_itemInfo setObject:@1 forKey:@"sel"];
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationOrderProjectSel
         object:Nil
         userInfo:@{@"info" : _itemInfo,
                    @"index" : [NSNumber numberWithInteger:_index]}];
        return NO;
    }
    return YES;
}
#pragma mark - textField为轮胎生产时间item时弹出时间选择器 ---
- (void)popTimeSelectView:(UITextField *)textField{
    
    UIPickerView *pikerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, self.frame.size.width, 216)];
    pikerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    pikerView.delegate = self;
    pikerView.dataSource = self;
    self.pikerView = pikerView;
    
    textField.inputView = pikerView;
    textField.text = [NSString stringWithFormat:@"%ld",[self getCurrentYear:14]];
    // 默认选中当前时间
    [pikerView selectRow:14 inComponent:0 animated:YES];
    
}
#pragma mark - UIPickerViewDataSource --
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 15;
}
#pragma mark - UIPickerViewDelegate --
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return self.frame.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35.0 * [UIScreen mainScreen].bounds.size.width/375.0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    for(UIView *singleLine in pickerView.subviews){
        
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor grayColor];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35.0 * [UIScreen mainScreen].bounds.size.width/375.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld",[self getCurrentYear:row]];
    return label;
}
-  (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _numberTF.text = [NSString stringWithFormat:@"%ld",[self getCurrentYear:row]];
}
- (NSInteger)getCurrentYear:(NSInteger)row{
    
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    NSInteger year = [components year];
    NSInteger startYear = year - 14;
    NSInteger resultYear = startYear + row;
    return resultYear;
}

@end
