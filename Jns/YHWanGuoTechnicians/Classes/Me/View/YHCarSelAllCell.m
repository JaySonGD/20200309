//
//  YHCarSelAllCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/8/18.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHCarSelAllCell.h"
#import "YHCommon.h"
#import "AccidentDiagnosisCell.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "YHPhotoManger.h"
#import "UIAlertController+Blocks.h"

@interface YHCarSelAllCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonCenter;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (nonatomic, assign) NSInteger willSelectIndex;

@end
@implementation YHCarSelAllCell
- (void)loadButtonState:(YHCarAll)state{
    [self loadButtonState:state sysIndex:0];
}

- (void)loadButtonState:(YHCarAll)state sysIndex:(NSUInteger)index{
    _buttonLeft.tag = (index << 16) + YHCarAllLeft;
    _buttonCenter.tag = (index << 16) + YHCarAllCenter;
    _buttonRight.tag = (index << 16) + YHCarAllRight;
    switch (state) {
        case YHCarAllLeft:
        {
            [_buttonLeft setBackgroundColor:YHNaviColor];
            [_buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [_buttonCenter setBackgroundColor:YHCellColor ];
            [_buttonRight setBackgroundColor:[UIColor whiteColor]];
            [_buttonRight setTitleColor:YHCellColor forState:UIControlStateNormal];
        }
            break;
        case YHCarAllCenter:
        {
            
            [_buttonLeft setBackgroundColor:[UIColor whiteColor]];
            [_buttonLeft setTitleColor:YHCellColor forState:UIControlStateNormal];
//            [_buttonCenter setBackgroundColor:YHCellColor ];
            [_buttonRight setBackgroundColor:[UIColor whiteColor]];
            [_buttonRight setTitleColor:YHCellColor forState:UIControlStateNormal];
        }
            break;
        case YHCarAllRight:
        {
            
            [_buttonLeft setBackgroundColor:[UIColor whiteColor]];
            [_buttonLeft setTitleColor:YHCellColor forState:UIControlStateNormal];
//            [_buttonCenter setBackgroundColor:YHCellColor ];
            [_buttonRight setBackgroundColor:YHNaviColor];
            [_buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _boxView.layer.borderColor  = YHLineColor.CGColor;
    _boxView.layer.borderWidth  = 1;
    [self.photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"cell"];
    self.photoView.showsHorizontalScrollIndicator = NO;
    self.photoView.backgroundColor = [UIColor whiteColor];

}
- (void)setItemInfo:(NSMutableDictionary *)itemInfo{
    _itemInfo = itemInfo;
    [self.photoView reloadData];
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

@end
