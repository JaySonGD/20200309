//
//  AccidentDiagnosisCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "AccidentDiagnosisCell.h"

#import "TTZTagView.h"
#import "TTZTagRightView.h"
#import "YHFromViewCell.h"
#import "TTZTextView.h"
#import "TTZTextField.h"

#import "YHCheckProjectModel.h"
#import "YHPhotoManger.h"
#import "TTZDBModel.h"

#import "UIView+Frame.h"
#import "NSObject+BGModel.h"
#import "UIAlertController+Blocks.h"


#import "YHCommon.h"
#import <Masonry.h>
//#import "MBProgressHUD+MJ.h"

@interface AccidentDiagnosisCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource>

/** 更多选择器<##>*/
@property (weak, nonatomic) IBOutlet TTZTagView *intervalMoreRangeView;


//@property (nonatomic, strong) NSArray *array;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intervalViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *photoLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoH;


@property (weak, nonatomic) IBOutlet UILabel *projectNameLB;
@property (weak, nonatomic) IBOutlet UILabel *intervalNameLB;

/** 右上角选择器<##>*/
@property (weak, nonatomic) IBOutlet TTZTagRightView *intervalRangeContentView;

/** 右上角文本输入框<##>*/
@property (weak, nonatomic) IBOutlet UIView *intervalContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitLB;
@property (weak, nonatomic) IBOutlet TTZTextField *valueTF;

@property (weak, nonatomic) IBOutlet UITableView *fromView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromViewH;

@property (weak, nonatomic) IBOutlet TTZTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewH;

@property (nonatomic, assign) NSInteger willSelectIndex ;


@end
@implementation AccidentDiagnosisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.valueTF.placeholder  = @"  ";
    //    UILabel *placeholderLabel = [self.valueTF valueForKeyPath:@"_placeholderLabel"];
    
    //    plb.font = [UIFont systemFontOfSize:10.0];
    //
    //    [self.valueTF setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //
    [self.valueTF setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    
    
    
    
    [self.photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.fromView registerNib:[UINib nibWithNibName:@"YHFromViewCell" bundle:nil] forCellReuseIdentifier:@"YHFromViewCell"];
    self.fromView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.fromView.rowHeight = 35;
    
}


- (CGFloat)rowHeight:(YHProjectListModel *)model{
    self.model = model;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    return CGRectGetMaxY(self.photoView.frame) + 10;
}
//radio 单选，range范围 select多选 text输入文本 textarea文本域框
- (void)setModel:(YHProjectListModel *)model
{
    _model = model;
    self.projectNameLB.text = model.projectName;
    
    //  range范围  input输入文本框 integer 整数
    self.intervalViewHeight.constant = 0;
    self.textViewH.constant = 0;
    
#pragma mark  -  select 多选 radio 单选
    if ([model.intervalType isEqualToString:@"select"] || [model.intervalType isEqualToString:@"radio"]) {
        
        self.intervalMoreRangeView.isMultipleChoice = [model.intervalType isEqualToString:@"select"];
        self.intervalRangeContentView.isMultipleChoice = [model.intervalType isEqualToString:@"select"];
        
        self.intervalContentView.hidden = YES;
        self.fromView.hidden = YES;
        self.textView.hidden = YES;
        self.intervalRangeContentView.hidden = (model.intervalRange.list.count >3);
        self.intervalMoreRangeView.hidden = !self.intervalRangeContentView.isHidden;
        
        __weak typeof(self) weakSelf = self;
        if (model.intervalRange.list.count > 3) {
            self.intervalMoreRangeView.models = model.intervalRange.list;
            self.intervalViewHeight.constant = [self.intervalMoreRangeView contentHeight:model.intervalRange.list];
            self.intervalMoreRangeView.clickAction = ^(NSArray<YHlistModel *> *selectModels) {
                if (selectModels.count>0) {
                    if (!weakSelf.photoH.constant){
                        weakSelf.photoH.constant = 76;
                        weakSelf.model.cellHeight += 76;
                        !(_reloadData)? : _reloadData();
                    }
                }else{
                    weakSelf.photoH.constant = 0;
                    weakSelf.model.cellHeight -= 76;
                    //weakSelf.model.images = nil;
                    [weakSelf.model cleanDBImages];
                    //[weakSelf.model.images removeAllObjects];
                    !(_reloadData)? : _reloadData();
                }
            };
        }else{
            self.intervalRangeContentView.models = model.intervalRange.list;
            self.intervalRangeContentView.clickAction = ^(NSArray<YHlistModel *> *selectModels) {
                if (selectModels.count>0) {
                    if (!weakSelf.photoH.constant){
                        weakSelf.photoH.constant = 76;
                        weakSelf.model.cellHeight += 76;
                        !(_reloadData)? : _reloadData();
                    }
                }else{
                    weakSelf.photoH.constant = 0;
                    weakSelf.model.cellHeight -= 76;
                    //weakSelf.model.images = nil;
                    [weakSelf.model cleanDBImages];
                    //[weakSelf.model.images removeAllObjects];
                    !(_reloadData)? : _reloadData();
                }
            };
        }
        
        
        //2）.模糊查询
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect > 0"];
        NSArray *filteredArray = [model.intervalRange.list filteredArrayUsingPredicate:predicate];
        
        self.photoH.constant = filteredArray.count? 76:0;
        
#pragma mark  -   （文本输入框）
    }else if ([model.intervalType isEqualToString:@"text"]){
        self.intervalContentView.hidden = NO;
        self.fromView.hidden = YES;
        self.intervalRangeContentView.hidden = YES;
        self.intervalMoreRangeView.hidden = YES;
        self.textView.hidden = YES;
        
        
        
        self.unitLB.text = model.unit;
        self.valueTF.placeholder = model.intervalRange.placeholder;
        self.valueTF.text = model.projectVal;
        
        self.photoH.constant = 0;
        //            self.photoH.constant = model.projectVal.length? 76:0;
        
#pragma mark  -  （TextView输入框）
        
    }else if ([model.intervalType isEqualToString:@"textarea"]){
        self.intervalContentView.hidden = YES;
        self.fromView.hidden = YES;
        self.intervalRangeContentView.hidden = YES;
        self.intervalMoreRangeView.hidden = YES;
        self.textView.hidden = NO;
        
        self.textViewH.constant = 152;
        self.fromViewH.constant = 0;
        self.textView.text = model.projectVal;
        //             __weak typeof(self) weakSelf = self;
        self.textView.textChange = ^(NSString *text) {
            model.projectVal = text;
            
            //                if (model.projectVal.length>0) {
            //                    if (!weakSelf.photoH.constant){
            //                        weakSelf.photoH.constant = 76;
            //                        weakSelf.model.cellHeight += 76;
            //                        !(_reloadData)? : _reloadData();
            //                    }
            //                }else{
            //                    weakSelf.photoH.constant = 0;
            //                    weakSelf.model.cellHeight -= 76;
            //                    //weakSelf.model.images = nil;
            //                    [weakSelf.model cleanDBImages];
            //
            //                    //[weakSelf.model.images removeAllObjects];
            //
            //                    !(_reloadData)? : _reloadData();
            //                }
            
        };
        self.photoH.constant = 0;
        
        //            self.photoH.constant = model.projectVal.length? 76:0;
        
        
    }else if ([model.intervalType isEqualToString:@"range"]){
        self.intervalContentView.hidden = NO;
        self.fromView.hidden = YES;
        self.intervalRangeContentView.hidden = YES;
        self.intervalMoreRangeView.hidden = YES;
        self.textView.hidden = YES;
        //self.photoH.constant = model.projectVal.length? 76:0;
        self.photoH.constant = 0;
        
    }
    else if ([model.intervalType isEqualToString:@"form"]){
        self.intervalContentView.hidden = YES;
        self.fromView.hidden = NO;
        self.intervalRangeContentView.hidden = YES;
        self.intervalMoreRangeView.hidden = YES;
        self.textView.hidden = YES;
        
        if(model.intervalRange.list.count == 0){
            YHlistModel *defaut = [YHlistModel new];
            [model.intervalRange.list addObject:defaut];
        }
        self.fromViewH.constant = 35 * model.intervalRange.list.count;
        [self.fromView reloadData];
        
        self.photoH.constant = 0;
        //self.photoH.constant = model.intervalRange.list.firstObject.name.length? 76:0;
        
    }
    
    [self.photoView reloadData];
    
    
    
}

#pragma mark  -  事件监听
- (IBAction)textFieldChange:(UITextField *)sender{
    NSInteger  max = self.model.intervalRange.max;
    NSInteger  min = self.model.intervalRange.min;
    
    NSInteger  val = [sender.text integerValue];
    !(_cheackBlock)? : _cheackBlock(max,min,val);
}
- (IBAction)textFieldChangeEnd:(UITextField *)sender {
    
    NSInteger  max = self.model.intervalRange.max;
    NSInteger  min = self.model.intervalRange.min;
    
    NSInteger  val = [sender.text integerValue];
    
    if (min != max && (val > max || val < min)) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%ld~%ld内",(long)min,(long)max]];
            sender.text = @"";
            return;
        }
        self.model.projectVal = sender.text;
    
}


#pragma mark  -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.model.intervalRange.list.count > self.model.intervalRange.maxNumber)?self.model.intervalRange.maxNumber : self.model.intervalRange.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHFromViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHFromViewCell"];
    __weak typeof(self) weakSelf = self;
    //cell.min = self.model.intervalRange.min;
    //cell.max = self.model.intervalRange.max;
    
    cell.model = self.model.intervalRange.list[indexPath.row];
    //        cell.textChange = ^(NSString *text) {
    
    //            NSInteger  max = self.model.intervalRange.max;
    //            NSInteger  min = self.model.intervalRange.min;
    //
    //            NSInteger  val = [text integerValue];
    //
    //            if (min != max && (val > max || val < min)) {
    //                [MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%ld~%ld内",(long)min,(long)max]];
    //                return;
    //            }
    
    
    //            __block NSString *saveText = text;
    //
    //            [weakSelf.model.intervalRange.list enumerateObjectsUsingBlock:^(YHlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                if (obj.name.length) {
    //                    saveText = obj.name;
    //                    *stop = YES;
    //                }
    //            }];
    //
    //            if (saveText.length>0) {
    //                if (!weakSelf.photoH.constant){
    //                    weakSelf.photoH.constant = 76;
    //                    weakSelf.model.cellHeight += 76;
    //                    !(_reloadData)? : _reloadData();
    //                }
    //            }else{
    //                weakSelf.photoH.constant = 0;
    //                weakSelf.model.cellHeight -= 76;
    //                //weakSelf.model.images = nil;
    //                [weakSelf.model cleanDBImages];
    //                //[weakSelf.model.images removeAllObjects];
    //
    //                !(_reloadData)? : _reloadData();
    //            }
    
    
    
    //        };
    cell.add = ^{
        
        if(weakSelf.model.intervalRange.list.count >= weakSelf.model.intervalRange.maxNumber ) return ;
        
        YHlistModel *model = [YHlistModel new];
        model.placeholder = weakSelf.model.intervalRange.list.firstObject.placeholder;
        model.unit = weakSelf.model.intervalRange.list.firstObject.unit;
        model.min = weakSelf.model.intervalRange.list.firstObject.min;
        model.max = weakSelf.model.intervalRange.list.firstObject.max;
        
        model.isDelete = YES;
        [weakSelf.model.intervalRange.list addObject:model];
        weakSelf.model.cellHeight += 35;
        !(_reloadData)? : _reloadData();
        
    };
    cell.remove = ^(YHlistModel *model) {
        [weakSelf.model.intervalRange.list removeObject:model];
        weakSelf.model.cellHeight -= 35;
        !(_reloadData)? : _reloadData();
    };
    
    cell.cheackBlock = ^(NSInteger max, NSInteger min, NSInteger val) {
        !(_cheackBlock)? : _cheackBlock(max,min,val);

    };
    
    
    return cell;
}

#pragma mark  -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.model.dbImages.count > 5)? 5 : self.model.dbImages.count;
    //                return (self.model.images.count > 5)? 5 : self.model.images.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.imageBtn setImage:self.model.dbImages[indexPath.item].image forState:UIControlStateNormal];
    //        [cell.imageBtn setImage:self.model.images[indexPath.item] forState:UIControlStateNormal];
    
    cell.clearnBtn.hidden = !((BOOL)(self.model.dbImages[indexPath.item].file));//[cell.imageBtn.currentImage isEqual:[UIImage imageNamed:@"otherAdd"]];

    __weak typeof(self) weakSelf = self;
    cell.clearnAction = ^{
        
        //        [weakSelf.model.images removeObjectAtIndex:indexPath.item];
        
        TTZDBModel *deleteModel = weakSelf.model.dbImages[indexPath.item];
        [weakSelf.model.dbImages removeObject:deleteModel];
        [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where fileId ='%@'",deleteModel.fileId]];
        
        if (self.model.dbImages.count < 5 && ![self.model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
            // [self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
            TTZDBModel *defaultModel = [TTZDBModel new];
            defaultModel.image = [UIImage imageNamed:@"otherAdd"];
            //defaultModel.billId = self.model.billId;
            //defaultModel.code = self.model.Id;
            
            
            [self.model.dbImages addObject:defaultModel];
            
        }
        
        //        if (self.model.images.count < 5 && ![self.model.images.lastObject isEqual:[UIImage imageNamed:@"otherAdd"]]) {
        //            [self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
        //        }
        
        [weakSelf.photoView  reloadData];
    };
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
//    return;
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    
//    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self setPhotoImagePickerVC:indexPath.item];
//    }];
//    
//    [alertVC addAction:photo];
//    
//    
//    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self setImagePickerVC:indexPath.item];
//    }];
//    [alertVC addAction:picture];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//
//    
//    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
//    if (popover) {
//        popover.sourceView = self;
//        popover.sourceRect = self.bounds;//CGRectMake(screenWidth * 0.5-50 , screenHeight * 0.5-50, 100, 100);
//        
//        [self.viewController  presentViewController:alertVC animated:YES completion:nil];
//    }else {
//        [self.viewController  presentViewController:alertVC animated:YES completion:nil];
//    }
//
//    return;
//    //        [self setImagePickerVC:indexPath.row];
//    [UIAlertController showActionSheetInViewController:self.viewController withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//        
//        if (buttonIndex == 2) {//paizhan
//            [self setPhotoImagePickerVC:indexPath.item];
//        }else if (buttonIndex == 3){
//            [self setImagePickerVC:indexPath.item];
//        }
//        
//    }];
}




#pragma mark  -
- (void)setPhotoImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark  -
- (void)setImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark  -  UIImagePickerControllerDelegate
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
    //        self.model.images[self.willSelectIndex] = image;
    
#pragma mark 保存图片
    [YHPhotoManger saveImage:image
                subDirectory:self.model.billId
                    fileName:fileName];
    
    
    
    
    if (self.willSelectIndex<4 && self.willSelectIndex == self.model.dbImages.count - 1) {
        //[self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        //defaultModel.billId = self.model.billId;
        //defaultModel.code = self.model.Id;
        
        
        [self.model.dbImages addObject:defaultModel];
        
        
    }
    
    //    if (self.willSelectIndex<4 && self.willSelectIndex == self.model.images.count - 1) {
    //        [self.model.images addObject:[UIImage imageNamed:@"otherAdd"]];
    //    }
    [self.photoView reloadData];
    
}


@end



@implementation YHPhotoAddCell

- (UIButton *)imageBtn{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"正在添加图片"] forState:UIControlStateNormal];
        _imageBtn.userInteractionEnabled = NO;
        kViewRadius(_imageBtn, 5);

        //_imageBtn.backgroundColor = [UIColor blackColor];
    }
    return _imageBtn;
}

- (UIButton *)clearnBtn{
    if (!_clearnBtn) {
        _clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearnBtn setImage:[UIImage imageNamed:@"clearn"] forState:UIControlStateNormal];
        [_clearnBtn addTarget:self action:@selector(clearnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearnBtn.hidden = YES;
    }
    return _clearnBtn;
}


- (void)clearnClick{
    !(_clearnAction)? : _clearnAction();
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageBtn];
        [self.contentView addSubview:self.clearnBtn];
        
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-5);
            
        }];
        [self.clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);          make.right.equalTo(self.contentView).offset(-5);
            
            make.size.equalTo(@(CGSizeMake(14, 14)));
        }];
        
    }
    return self;
}


@end


@implementation UIView (fetchViewController)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end






