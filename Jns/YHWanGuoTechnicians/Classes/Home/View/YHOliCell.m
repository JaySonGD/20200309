    //
//  YHOliCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOliCell.h"
#import "YHCommon.h"
#import "AccidentDiagnosisCell.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "UIAlertController+Blocks.h"
#import "YHPhotoManger.h"

NSString *const notificationDrive = @"YHNotificationDrive";
NSString *const notificationOil = @"YHNotificationOil";
extern NSString *const notificationProjectCarSelAll;
@interface YHOliCell () <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (IBAction)buttonAction:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *sysDescL;
@property (weak, nonatomic) IBOutlet UIButton *helpB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *driveStateSG;
- (IBAction)driveAction:(id)sender;
@property (weak, nonatomic) NSMutableDictionary *itemInfo;
@property (nonatomic)NSInteger index;
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;

@property (nonatomic, assign) NSInteger willSelectIndex ;

@end
@implementation YHOliCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"cell"];
    self.photoView.showsHorizontalScrollIndicator = NO;
    self.photoView.backgroundColor = [UIColor whiteColor];

}

//FIXME:  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = [[self.itemInfo valueForKey:@"photo"] count];
    return (count > 5)? 5 : count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info index:(NSUInteger)index{
    _helpB.tag = index;
    self.index = index;
    [self loadDatasourceInitialInspection:info];
}

- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info {
    
    self.itemInfo = info;
    [self.photoView reloadData];
    
    
    
    _sysDescL.text = _itemInfo[@"projectName"];
    NSString *imgSrc = info[@"imgSrc"];
    _helpB.hidden = IsEmptyStr(imgSrc);
    NSNumber *sel = _itemInfo[@"sel"];
    if (!sel) {
        sel = @-1;
    }
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = (idx == sel.integerValue);
    }];
     __weak __typeof__(self) weakSelf = self;
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *intervalRange = weakSelf.itemInfo[@"intervalRange"];
        NSArray *list = intervalRange[@"list"];
        if (idx >= list.count) {
            *stop = YES;
            button.hidden = YES;
            
                if ([list isKindOfClass:[NSArray class]] && [list.firstObject valueForKey:@"tips"]) {
                    
                    self.helpB.hidden = NO;
                    /////
   
                }
                
        

        }else{
            button.hidden = NO;
            NSDictionary *item = list[idx];
            [button setTitle:item[@"name"] forState:UIControlStateNormal];
//            button.tag = [item[@"value"] integerValue];
        }
    }];
}


- (IBAction)buttonAction:(UIButton*)sender {
    

    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = NO;
    }];
    if (_itemInfo) {
        NSUInteger index = sender.tag;
        NSNumber *sel = _itemInfo[@"sel"];
        if (sel && sel.integerValue == index) {
            [_itemInfo removeObjectForKey:@"sel"];
            sender.selected = NO;
        }else{
            [_itemInfo setObject:[NSNumber numberWithLong:index] forKey:@"sel"];
            sender.selected = YES;
        }
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationProjectCarSelAll
         object:Nil
         userInfo:@{@"index" : @(_index)}];
    }else{
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationDrive
         object:Nil
         userInfo:@{@"projectId" : @57,
                    @"projectVal" : [NSString stringWithFormat:@"%ld", (long)sender.tag]}];
    }
}

- (IBAction)driveAction:(UISegmentedControl *)sender {
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationOil
     object:Nil
     userInfo:@{@"projectId" : @67,
                @"projectVal" : [NSString stringWithFormat:@"%ld", (long)[sender selectedSegmentIndex]]}];
}

@end
