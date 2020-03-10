//
//  YHCarPhotoController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarPhotoController.h"
#import "YHTakePhotoController.h"
#import "YHExampleController.h"

#import "YHCarVersionModel.h"
#import "TTZDBModel.h"
#import "YHCarPhotoModel.h"
#import "NSObject+BGModel.h"
#import "YHPhotoManger.h"
#import "YHCommon.h"

#import "YHBackgroundService.h"
//#import "YHUpLoadManager.h"
#import "YHCarBaseModel.h"

#import "YHChooseView.h"
#import "TTZTextView.h"


#import <MJExtension.h>
#import "UIAlertController+Blocks.h"


@interface YHCarPhotoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) YHChooseView *chooseView;

@property (nonatomic, strong) NSArray <YHPhotoModel *>*models;
@property (nonatomic, strong) NSMutableArray <YHPhotoModel *>*otherModels;
//@property (nonatomic, strong) YHPhotoDBModel *dbTemp;

@property (nonatomic, assign) NSInteger willSelectIndex;


/** 缓存图片的数据库记录 */
@property (nonatomic, strong) NSMutableArray <TTZDBModel *> *tempImage;
/** 缓存其他图片的数据库记录 */
@property (nonatomic, strong) NSMutableArray <TTZDBModel *> *otherTempImage;

/** 图片代码*/
//@property (nonatomic, strong) NSArray *picturnCode;

@end

@implementation YHCarPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  自定义方法
- (void)setUI{
    
    self.billId = self.billId.length ? self.billId : self.vinStr;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];
}

- (void)saveClick{
    
}


- (void)setExampleVC:(NSInteger)index{
    YHExampleController *exampleVC = [[UIStoryboard storyboardWithName:@"CarPhoto" bundle:nil] instantiateViewControllerWithIdentifier:@"YHExampleController"];
    exampleVC.selectIndex  = index;
    [self.navigationController pushViewController:exampleVC animated:YES];
    //[self presentViewController:exampleVC animated:YES completion:nil];
}
- (void)setTakePhotoVC:(NSInteger )index{
    
    YHTakePhotoController *photoVC = [[UIStoryboard storyboardWithName:@"CarPhoto" bundle:nil] instantiateViewControllerWithIdentifier:@"YHTakePhotoController"];
    
    photoVC.doClick = ^{
        self.chooseView.models = self.models;
        self.chooseView.otherModels = self.otherModels;
    };
    
    if (index >= 100) {
        //        self.otherModels[index-100].image = nil;
        photoVC.models = self.otherModels;
        photoVC.otherTempImage = self.otherTempImage;
        photoVC.billId = self.billId;
        //        photoVC.dbTemp = self.dbTemp;
        photoVC.index = index-100;
        for (NSInteger i = 0; i < self.otherModels.count; i++) {
            YHPhotoModel *model = self.otherModels[i];
            model.isSelected = (photoVC.index == i);
        }
    }else{
        
        //        self.models[index].image = nil;
        photoVC.models = (NSMutableArray *)self.models;
        photoVC.otherTempImage = self.otherTempImage;
        photoVC.billId = self.billId;
        
        //        photoVC.dbTemp = self.dbTemp;
        photoVC.index = index;
        for (NSInteger i = 0; i < self.models.count; i++) {
            YHPhotoModel *model = self.models[i];
            model.isSelected = (index == i);
        }
        
    }
    [self.navigationController pushViewController:photoVC animated:YES];
    
}

- (void)setImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //imagePicker.sourceType =
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)choosePicturn:(NSUInteger)index
               sender:(UIView *)sender{
    
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self setImagePickerVC:index];
            return;
        }
        [self setTakePhotoVC:index];
    }];
    
}


- (void)choosePicturn:(NSUInteger)index{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setTakePhotoVC:index];
    }];
    
    [alertVC addAction:photo];
    
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setImagePickerVC:index];
    }];
    [alertVC addAction:picture];
    
    
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(screenWidth * 0.5-50 , screenHeight * 0.5-50, 100, 100);
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self presentViewController:alertVC animated:YES completion:nil];
    }

    return;
    [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 2) {
            [self setTakePhotoVC:index];
        }else if (buttonIndex == 3){
            [self setImagePickerVC:index];
        }
        
    }];
}

#pragma mark  -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    
    NSString *imageName = [YHPhotoManger fileName];
    
    // 点击OK -->carLineId --> billId
    [YHPhotoManger saveImage:image
                subDirectory:self.billId
                    fileName:imageName];
    
    if (self.willSelectIndex >= 100) {//其他图片
        
        
        NSInteger index = self.willSelectIndex - 100;
        self.otherModels[index].image = image;
        
        TTZDBModel *selectModel = nil;
        if (self.otherTempImage.count > index) {
            selectModel = self.otherTempImage[index];
            selectModel.file = imageName;
        }else{
            selectModel = [TTZDBModel new];
            selectModel.file = imageName;
            selectModel.fileId = imageName;
            selectModel.code = YHPhotoManger.picturnCode.lastObject;
            selectModel.billId = self.billId;
            self.otherTempImage[index] = selectModel;
            
        }
        [selectModel saveOrUpdate:@[@"image"]];
        
        if (self.otherModels.count < 10 && self.otherModels.lastObject.image) {
            YHPhotoModel *model =[YHPhotoModel new];
            model.name = [NSString stringWithFormat:@"其他-%ld",index+1];
            [self.otherModels addObject:model];
        }
        
        self.chooseView.otherModels = self.otherModels;
        
    }else{
        
        NSInteger index = self.willSelectIndex;
        
        self.models[index].image = image;
        self.chooseView.models = self.models;
        
        TTZDBModel *selectModel = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,YHPhotoManger.picturnCode[index]]].firstObject;
        
        if (selectModel) {
            selectModel.file = imageName;
        }else{
            selectModel = [TTZDBModel new];
            selectModel.file = imageName;
            selectModel.fileId = imageName;
            selectModel.code = YHPhotoManger.picturnCode[self.willSelectIndex];
            selectModel.billId = self.billId;
        }
        
        [selectModel saveOrUpdate:@[@"image"]];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark  -  get/set 方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - NavbarHeight - TabbarHeight) style:UITableViewStylePlain];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        YHChooseView *headerView = [YHChooseView chooseView];
        _tableView.tableHeaderView = headerView;
        headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1380+230);
        _chooseView = headerView;
        headerView.otherModels = self.otherModels;
        headerView.models = self.models;
        
        __weak typeof(self) weakSelf = self;
        headerView.buttonClick = ^(UIButton *btn) {
            [weakSelf choosePicturn:btn.tag sender:btn];
        };
        headerView.otherClick = ^(NSInteger index,UIView *sender) {
            [weakSelf choosePicturn:index + 100 sender:sender];
        };
        
        headerView.exampleClick = ^(NSInteger index) {
            [weakSelf setExampleVC:index];
        };
        
        headerView.textView.textChange = ^(NSString *text) {
            weakSelf.carDesc = text;
        };
        
    }
    return _tableView;
}

- (NSArray<YHPhotoModel *> *)models
{
    if (!_models) {
        NSArray * array = @[
                            @{@"image": @"",@"name":@"车辆正面"},
                            @{@"image": @"",@"name":@"车辆左侧"},
                            @{@"image": @"",@"name":@"车辆背面"},
                            @{@"image": @"",@"name":@"车辆右侧"},
                            @{@"image": @"",@"name":@"机舱"},
                            @{@"image": @"",@"name":@"后尾箱"},
                            @{@"image": @"",@"name":@"一排"},
                            @{@"image": @"",@"name":@"二排"},
                            @{@"image": @"",@"name":@"三排"},
                            @{@"image": @"",@"name":@"仪表盘"},
                            ];
        
        _models =  [YHPhotoModel mj_objectArrayWithKeyValuesArray:array];
        for (NSInteger i = 0; i < _models.count; i++) {
            _models[i].image = [self imageForCode:YHPhotoManger.picturnCode[i]];
            _models[i].url =  [[self.carPhotos mj_keyValues] valueForKey:YHPhotoManger.picturnCode[i]];
        }
        NSLog(@"%s", __func__);
    }
    return _models;
}


- (NSArray<YHPhotoModel *> *)otherModels{
    if (!_otherModels) {
        NSArray * array = @[
                            @{@"image": @"",@"name":@"其他-0"},
                            ];
        
        NSMutableArray <YHPhotoModel *>*defult =  [YHPhotoModel mj_objectArrayWithKeyValuesArray:array];
        
        NSInteger count = self.otherTempImage.count;
        
        if(count){//没上传
            
            NSMutableArray *temps = [NSMutableArray array];
            for (NSInteger i = 0; i < count; i ++) {
                YHPhotoModel *model = [YHPhotoModel new];
                model.image = self.otherTempImage[i].image;
                model.name = [NSString stringWithFormat:@"其他-%ld",(long)i];
                [temps addObject:model];
            }
            
            if (count < 10) {
                defult.firstObject.name = [NSString stringWithFormat:@"其他-%ld",(long)count];
                [temps addObjectsFromArray:defult];
            }
            _otherModels = temps;
            
        }else{//已上传
            
            NSInteger imageCount = self.carPhotos.car_other.count;
            
            if (imageCount) {//有数据
                
                NSMutableArray *temps = [NSMutableArray array];
                for (NSInteger i = 0; i < imageCount; i ++) {
                    YHPhotoModel *model = [YHPhotoModel new];
                    model.name = [NSString stringWithFormat:@"其他-%ld",(long)i];
                    model.url = self.carPhotos.car_other[i];
                    
                    [temps addObject:model];
                }
                if (imageCount < 10) {//小于10张可添加
                    defult.firstObject.name = [NSString stringWithFormat:@"其他-%ld",(long)count];
                    [temps addObjectsFromArray:defult];
                }
                _otherModels = temps;
                
                
                
            }else{
                _otherModels = defult;
            }
        }
        
        
    }
    return _otherModels;
}


- (NSMutableArray<TTZDBModel *> *)tempImage
{
    if (!_tempImage) {
        _tempImage = [NSMutableArray array];
        NSArray <TTZDBModel *>*dbs = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId='%@'",self.billId]];
        [_tempImage addObjectsFromArray:dbs];
    }
    return _tempImage;
}


- (NSMutableArray<TTZDBModel *> *)otherTempImage
{
    if (!_otherTempImage) {
        _otherTempImage = [NSMutableArray array];
        NSArray *dbs = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,@"car_other"]];
        
        [_otherTempImage addObjectsFromArray:dbs];
    }
    
    return _otherTempImage;
}

- (BOOL)isFinished{
    
    
    if(self.billId.length && ![self.billId isEqualToString:self.vinStr]) return YES;
    
    __block BOOL _isFinished = YES;
    //__block BOOL isSelect = NO;
    
    [self.models enumerateObjectsUsingBlock:^(YHPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //0 1 2 3
        if (idx < 4) {//
            if (!obj.image) {
                _isFinished = NO;
                *stop = YES;
            }
            
        }else *stop = YES;


//        if (idx < 6) {//
//            if (!obj.image) {
//                _isFinished = NO;
//                *stop = YES;
//            }
//
//        }else if (idx < 9){
//            isSelect |= (BOOL)obj.image;
//        }else{
//            _isFinished &= isSelect;
//        }
        
    }];
    
    
    return _isFinished;
}

- (UIImage *)imageForCode:(NSString *)picturnCode{
    TTZDBModel *model = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,picturnCode]].firstObject;
    
    return model.image;
}

@end

