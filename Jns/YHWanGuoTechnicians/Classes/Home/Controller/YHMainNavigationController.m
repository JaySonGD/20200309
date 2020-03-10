//
//  YHMainNavigationController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHMainNavigationController.h"
#import "YHInitialInspectionController.h"

#import "NSObject+BGModel.h"
#import "TTZDBModel.h"
#import "YHPhotoManger.h"

#define fileID  @"fileID_brake_distance"

@interface YHMainNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) NSMutableArray *fileIDArr;

@property (nonatomic,strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGesture;

@end

@implementation YHMainNavigationController

- (NSMutableArray *)fileIDArr{
    if (!_fileIDArr.count) {
        _fileIDArr = [NSMutableArray array];
    }
    return _fileIDArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
   UIViewController *VC = [super popViewControllerAnimated:animated];
    
    if ([NSStringFromClass([VC class]) isEqualToString:@"YHInitialInspectionController"]) {
        YHInitialInspectionController *inspecttionVC = (YHInitialInspectionController *)VC;
        
        if ([inspecttionVC.titleStr isEqualToString:@"四轮"] && inspecttionVC.isHasPhoto) {
            [self upLoadBrakeDistanceData:inspecttionVC];
        }
    }
    
    return VC;
}

- (void)upLoadBrakeDistanceData:(YHInitialInspectionController *)inspecttionVC{
    
    // 删除原先缓存的数据防止重复缓存
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:fileID];
    for (int i = 0; i<arr.count; i++) {
        TTZDBModel *model = [[TTZDBModel alloc] init];
        model.billId = [NSString stringWithFormat:@"%ld",[inspecttionVC.orderInfo[@"id"] integerValue]];
        model.file = arr[i];
        model.fileId = model.file;
        model.code = inspecttionVC.code == nil ? @"brake_distance" : inspecttionVC.code;
        [YHPhotoManger deleteUpLoadedFile:model];
    }
    // 重新取出图片缓存
    NSMutableArray *imageArr = [self getLocalData];
    for (int i = 0; i<imageArr.count; i++) {
        TTZDBModel *model = [[TTZDBModel alloc] init];
        model.billId = [NSString stringWithFormat:@"%ld",[inspecttionVC.orderInfo[@"id"] integerValue]];
        model.image = imageArr[i];
        model.file = [YHPhotoManger fileName];
        [self.fileIDArr addObject:model.file];
        model.fileId = model.file;
        model.code = inspecttionVC.code == nil ? @"brake_distance" : inspecttionVC.code;
        
        model.timestamp = model.timestamp? model.timestamp : YHPhotoManger.timestamp;

        [YHPhotoManger deleteUpLoadedFile:model];
        [model saveOrUpdate:@[@"image"]];
        [YHPhotoManger saveImage:imageArr[i] subDirectory:model.billId fileName:model.file];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.fileIDArr forKey:fileID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取沙盒数据 ---
- (NSMutableArray *)getLocalData{
    
    NSArray *imageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"getPic_imageIndex"];
    NSMutableArray *arr = [NSMutableArray array];
    if (imageArr.count > 0) {
        
        for (NSInteger i = 0; i<imageArr.count; i++) {
            
            NSString *imagePath = imageArr[i];
            NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:imagePath];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                [arr addObject:image];
            }
        }
    }
    NSMutableArray *newImageArr = [NSMutableArray arrayWithArray:arr];
    return newImageArr;
}
#pragma mark 侧滑的坑 ----
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if (self.childViewControllers.count == 1) {
            return NO;
    }
    
    if (self.childViewControllers.count > 1) {
        for (UIViewController *vc in self.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"YHNewLoginController")]) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
