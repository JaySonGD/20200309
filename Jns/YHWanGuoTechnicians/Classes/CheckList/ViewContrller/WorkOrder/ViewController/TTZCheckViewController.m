//
//  TTZCheckViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZCheckViewController.h"
#import "YHVideosController.h"
#import "YHOrderListController.h"
#import "YHOrderDetailNewController.h"

#import "TTZHeaderTagCell.h"
#import "TTZCheckCell.h"

#import "TTZSurveyModel.h"


#import "YHCommon.h"
#import "UIView+add.h"
#import "YHCarPhotoService.h"
#import "UIAlertController+Blocks.h"
#import "TTZAirConditionController.h"
#import "TTZTakePhotoController.h"

#import "YHWebFuncViewController.h"
#import "YHIntelligentDiagnoseController.h"

#import <MJExtension.h>
//#import "MBProgressHUD+MJ.h"
#import "ZZSubmitDataService.h"
#import "YTOrderDetailNewController.h"

@interface TTZCheckViewController ()
<
UICollectionViewDataSource,UITableViewDataSource,
UICollectionViewDelegate,UITableViewDelegate,UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *headerView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *circuitryBtn;
@property (nonatomic, strong) NSMutableDictionary *val;
//@property (nonatomic, assign) CGFloat totalProgress;
//@property (nonatomic, assign) BOOL isDelay;
@property (nonatomic, assign) NSInteger isSave; // 0 1保存 2不保存


//@property (nonatomic, strong) NSMutableArray *sysArray;

@end

@implementation TTZCheckViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    //NSArray *initialSurveyItemVals = [[self.detailNewController.info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItemVal"];
    //NSArray *initialSurveyItems = [[self.detailNewController.info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItem"];
    
    //self.sysArray = [TTZSYSModel mj_keyValuesArrayWithObjectArray:initialSurveyItems?initialSurveyItems:initialSurveyItemVals];
    //self.sysArray = [TTZSYSModel mj_keyValuesArrayWithObjectArray:self.sysModels];
    NSLog(@"%s", __func__);
    if (@available(iOS 13.0, *)) {}
    else{
       self.sysArray = [TTZSYSModel mj_keyValuesArrayWithObjectArray:self.sysModels];
    }
    
    
}

- (void)dealloc{
    NSLog(@"%s----guale", __func__);
    
    if([self.title isEqualToString:@"空调诊断"]){
        return;
    }
    if([self.title isEqualToString:@"J009"]){
        return;
    }

    if([self.billType isEqualToString:@"AirConditioner"]){
        return;
    }
    
    if([self.billType isEqualToString:@"J005"]){
        return;
    }
//    if([self.billType isEqualToString:@"J007"]){
//        return;
//    }

    
    
    //if ([self canSave] && (self.isSave == 0 || self.isSave == 1)) {
    if ([self canSave] && [self isChange] && (self.isSave == 0 || self.isSave == 1)) {
        
        [self tempSave];
    }
    
    if([self.billType isEqualToString:@"E002"]
       ||[self.billType isEqualToString:@"E003"]
       || [self.billType isEqualToString:@"J007"]
       ){
        return;
    }
    
    
    if(!([_billType isEqualToString:@"A"] || [_billType isEqualToString:@"Y"] || [_billType isEqualToString:@"Y001"] || [_billType isEqualToString:@"Y002"])) !(_callBackBlock)? : _callBackBlock();
    
}

//FIXME:  -  自定义方法
- (void)setUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.circuitryBtn];
    
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    //    [self.view addSubview:self.finishButton];
    //    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(44);
    //        make.bottom.mas_equalTo(self.view).offset(-10-kTabbarSafeBottomMargin);
    //        make.right.mas_equalTo(self.view).offset(-10);
    //        make.left.mas_equalTo(self.view).offset(10);
    //
    //    }];
    
    if (@available(iOS 11.0, *)) {
        self.headerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(!IsEmptyStr(self.billType) && ![self.billType isEqualToString:@"A"] && ![self.billType isEqualToString:@"Y"] && ![self.billType isEqualToString:@"Y001"] && ![self.billType isEqualToString:@"Y002"])  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    //self.totalProgress = [self calculateProgress];
    
    [self isSelectOneProject];
    
}

//- (CGFloat)calculateProgress{
//    CGFloat progress = 0.0;
//    for (TTZSYSModel *model in self.sysModels) {
//         progress += model.progress;
//    }
//    return progress;
//}
- (BOOL)isChange{
    __block BOOL isChange = NO;
    [self.sysModels[self.currentIndex].list enumerateObjectsUsingBlock:^(TTZGroundModel *  gObj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel * cbj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (cbj.isChange) {
                isChange = YES;
                *stop = YES;
            }
        }];
        if (isChange) {
            *stop = YES;
        }
    }];
    return isChange;
}

//FIXME:  -  帮助
- (void)jumpToVideoPlay:(TTZSurveyModel *)model{
    
    if (IsEmptyStr(model.imgSrc)) {
        
        if (!IsEmptyStr(model.intervalRange.list.firstObject.tips)) {
            /////
            NSMutableArray *message = [NSMutableArray arrayWithCapacity:model.intervalRange.list.count];
            [model.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if(!IsEmptyStr(obj.tips)) [message addObject:[NSString stringWithFormat:@"%@:%@",obj.name,obj.tips]];
            }];
            [UIAlertController showAlertInViewController:self withTitle:model.projectName message:nil cancelButtonTitle:@"知道" destructiveButtonTitle:nil otherButtonTitles:message tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
            return;
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    if ([self.title isEqualToString:@"空调诊断"] || [self.billType isEqualToString:@"AirConditioner"]) {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getVideoList:[YHTools getAccessToken] projectId:model.Id carBrand:self.carBrand onComplete:^(NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view];
            if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                NSDictionary *data = info[@"data"];
                NSArray *videos = data[@"list"];
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
        return;
    }
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getVideoList:[YHTools getAccessToken]
     projectId:model.Id
     billId:self.billId
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

//FIXME:  -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.sysModels[self.currentIndex].list.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTZHeaderTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.tagModel = self.sysModels[self.currentIndex].list[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray <TTZGroundModel *>*gModels = self.sysModels[self.currentIndex].list;
    
    [gModels enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    gModels[indexPath.item].isSelected = YES;
    
    if(indexPath.item <= self.tableView.numberOfSections && [self.tableView numberOfRowsInSection:indexPath.item]){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.item] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [collectionView reloadData];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //    self.isDelay = YES;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.isDelay = NO;
    //    });
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return CGSizeMake(self.sysModels[self.currentIndex].list[indexPath.item].itemWidth + 64, 34);
    return CGSizeMake(self.sysModels[self.currentIndex].list[indexPath.item].itemWidth + 36, 34);
}
//FIXME:  -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.rightButton.isSelected) {
        self.rightButton.selected =  [self isSelectOneProject];
    }
    return self.sysModels[self.currentIndex].list[section].list.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sysModels[self.currentIndex].list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    TTZGroundModel *gModel = self.sysModels[self.currentIndex].list[indexPath.section];
    TTZCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZCheckCell"];
    TTZSurveyModel *model = self.sysModels[self.currentIndex].list[indexPath.section].list[indexPath.row];
    model.isLastProject = (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1));
    model.billId = self.billId;
    model.sysClassId = self.sysModels[self.currentIndex].Id;
    
    cell.reloadBlock = ^{
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    
    cell.reloadAllBlock = ^{
        [UIView performWithoutAnimation:^{
            if (indexPath.row < [weakSelf.tableView numberOfRowsInSection:indexPath.section]-1) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    };
    
    cell.helpBlock = ^(TTZSurveyModel *model) {
        [weakSelf jumpToVideoPlay:model];
    };
    
    cell.getElecCtrlProjectListBlock = ^(NSArray<TTZSurveyModel *> *models) {
        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, models.count)];
        [gModel.list insertObjects:models atIndexes:sets];
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    };
    
    cell.removeElecCtrlProjectListBlock = ^(NSArray<TTZSurveyModel *> *models) {
        
        [gModel.list removeObjectsInArray:models];
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        //[weakSelf.tableView reloadData];
    };
    
    cell.takePhotoBlock = ^(TTZSurveyModel *model) {
        TTZTakePhotoController *photoVC = [[UIStoryboard storyboardWithName:@"CarPhoto" bundle:nil] instantiateViewControllerWithIdentifier:@"TTZTakePhotoController"];
       
        photoVC.model = model;
        photoVC.sysModel = weakSelf.sysModels[weakSelf.currentIndex];
        photoVC.doClick = ^{
            [UIView performWithoutAnimation:^{
                [weakSelf.tableView reloadData];
            }];
        };
        
        [weakSelf.navigationController pushViewController:photoVC animated:YES];

    };
    
    cell.model = model;
    
    //    cell.userInteractionEnabled = !self.isNoEdit;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTZSurveyModel *model = self.sysModels[self.currentIndex].list[indexPath.section].list[indexPath.row];
    
    if ((indexPath.row - 1)>=0 && [model.intervalType isEqualToString:@"gatherInputAdd"]) {//是故障码
        
        TTZSurveyModel *previouModel = self.sysModels[self.currentIndex].list[indexPath.section].list[indexPath.row - 1];
        previouModel.faultModel = model;
        
        NSArray *selectUnusualArray = [previouModel.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0 and value != 1"]];
        
        //[previouModel.intervalRange.list valueForKeyPath:<#(nonnull NSString *)#>]
        //if (!previouModel.showFaultCode && !model.codes.count) {//是否显示故障码
        if ((!previouModel.showFaultCode && !model.codes.count) && !selectUnusualArray.count) {//是否显示故障码
            
            return 0;
        }
        previouModel.showFaultCode = YES;
        previouModel.faultModel = model;
    }
    
    
    CGFloat cellHeight = model.cellHeight;
    
    if (cellHeight) {
        return cellHeight;
    }
    
    TTZCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZCheckCell"];
    CGFloat height = [cell rowHeight:model];
    
    model.cellHeight = height;
    return height;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray <TTZGroundModel *>*gModels = self.sysModels[self.currentIndex].list;
    
    //    if (!self.isDelay) {
    //        NSArray <NSIndexPath *>*sections = [tableView indexPathsForVisibleRows];
    //
    //        NSInteger  scrollSection = sections[sections.count/2].section;
    //
    //        [gModels enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            obj.isSelected = NO;
    //        }];
    //        gModels[scrollSection].isSelected = YES;
    //
    //        [self.headerView reloadData];
    //        [self.headerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollSection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //    }
    
    TTZCheckHeaderCell *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TTZCheckHeaderCell"];
    headerView.titleLabel.text = gModels[section].projectName;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 66;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == self.headerView) return;
    
    NSArray <NSIndexPath *>*indexs = [self.tableView indexPathsForVisibleRows];
    NSArray *sections = [indexs valueForKeyPath:@"section"];
    
    NSMutableArray <TTZGroundModel *>*gModels = self.sysModels[self.currentIndex].list;
    
    NSInteger  scrollSection = [sections.firstObject integerValue];
    
    [gModels enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    gModels[scrollSection].isSelected = YES;
    
    [self.headerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollSection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.headerView reloadData];
    
}

- (BOOL)canSave{
    
    __block BOOL isCanSave = YES;
    //安检
    if([self.sysModels[self.currentIndex].Id isEqualToString:@"21"]){//silun
        [self.sysModels[self.currentIndex].list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gobj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([gobj.Id isEqualToString:@"1231"]){//qiya
                NSArray <TTZSurveyModel *>* lists = gobj.list;
                NSArray <NSString *>*codes = @[@"1232",@"1233",@"1234",@"1235"];
                __block BOOL isContain = NO;
                [lists enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull cellobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!IsEmptyStr(cellobj.intervalRange.interval) && [codes containsObject:cellobj.Id]) {
                        isContain = YES;
                        *stop = YES;
                    }
                }];
                NSArray *selects = [gobj.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = '1236'"]];
                if (selects.count==1) {
                    TTZSurveyModel *model = selects.lastObject;
                    NSArray <TTZValueModel *>*values = [model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value = 1"]];
                    if (values.count ==1) {
                        TTZValueModel *vModel = values.firstObject;
                        if (isContain) {
                            if (vModel.isSelected==NO) {
                                isCanSave = NO;
                            }
                        }
                    }
                }
                
                *stop = YES;
            }
        }];
        
    }
    //全车
    if([self.sysModels[self.currentIndex].Id isEqualToString:@"21"]){//silun
        [self.sysModels[self.currentIndex].list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gobj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([gobj.Id isEqualToString:@"1201"]){//qiya
                NSArray <TTZSurveyModel *>* lists = gobj.list;
                NSArray <NSString *>*codes = @[@"1202",@"1203",@"1204",@"1205"];
                __block BOOL isContain = NO;
                [lists enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull cellobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!IsEmptyStr(cellobj.intervalRange.interval) && [codes containsObject:cellobj.Id]) {
                        isContain = YES;
                        *stop = YES;
                    }
                }];
                NSArray *selects = [gobj.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = '1206'"]];
                if (selects.count==1) {
                    TTZSurveyModel *model = selects.lastObject;
                    NSArray <TTZValueModel *>*values = [model.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value = 1"]];
                    if (values.count ==1) {
                        TTZValueModel *vModel = values.firstObject;
                        if (isContain) {
                            if (vModel.isSelected==NO) {
                                isCanSave = NO;
                            }
                        }
                    }
                }
                
                *stop = YES;
            }
        }];
        
    }
    
    
    return isCanSave;
}
//FIXME:  -  事件监听
- (void)circuitAction{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
    NSMutableDictionary *info = self.orderInfo? self.orderInfo.mutableCopy : [NSMutableDictionary dictionary];
    
    info[@"id"] = self.billId;
    controller.orderInfo = info;
    controller.functionKey = YHFunctionIdCircuitDiagram;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)isValueExist{
    
    for (TTZSYSModel *sm in self.sysModels) {
        for (TTZGroundModel *gm in sm.list) {
            for (TTZSurveyModel *cm in gm.list) {
                
                if (cm.isRequir && cm.projectVal.length < 1) {
                    
                    NSInteger row = [gm.list indexOfObject:cm];
                    NSInteger sec = [sm.list indexOfObject:gm];
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:sec];
                    
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cm.projectName]];
                    
                    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    return NO;
                }
                
            }
        }
    }
    
    
    return YES;
    /////
    BOOL isExist = NO;
    NSArray *initialSurveyProjectVal =  self.val[@"initialSurveyProjectVal"];
    for (int i = 0; i<initialSurveyProjectVal.count; i++) {
        NSDictionary *element = initialSurveyProjectVal[i];
        NSArray *projectVal = [element[@"projectVal"] valueForKeyPath:@"projectVal"];
        
        if (isExist) {
            break;
        }
        
        for (NSString *projectValStr in projectVal) {
            if (projectValStr.length > 0) {
                isExist = YES;
                break;
            }
        }
        
    }
    
    return isExist;
}

- (BOOL)isSelectOneProject{
    
    //__block NSInteger selectRadioCount = 0;
    
    NSArray <NSArray *>*lists = [[self.sysModels[self.currentIndex] valueForKey:@"list"] valueForKey:@"list"];
    
    for (NSArray <TTZSurveyModel *>*  clists in lists) {
        NSArray <TTZSurveyModel *>*selectLists = [clists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"intervalType = 'radio'"]];
        for (TTZSurveyModel * selectObj in selectLists) {
            NSArray *selectRadios = [selectObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
            if(selectRadios.count) return YES;
        }
    }
    
    //    [lists enumerateObjectsUsingBlock:^(NSArray <NSArray *>*  clists, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [clists enumerateObjectsUsingBlock:^(NSArray <TTZSurveyModel *>* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            NSArray <TTZSurveyModel *>*selectLists = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"intervalType = 'radio'"]];
    //
    //            [selectLists enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull selectObj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                NSArray *selectRadios = [selectObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
    //                selectRadioCount += selectRadios.count;
    //
    //
    //            }];
    //
    //        }];
    //    }];
    
    return NO;
}

- (BOOL)cansubmit{
    
    NSArray *arr = [[ZZSubmitDataService submitProjectVal:self.sysModels with:@"J007J"] valueForKeyPath:@"projectVal.length"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF > 0"];
    NSArray *arr1 = [arr filteredArrayUsingPredicate:predicate];
    
    if(!arr1.count){
        [MBProgressHUD showError:@"至少选择一项!"];
    }
    
    return arr1.count;
    
}

- (BOOL)canSubmit{
    
    __block BOOL isStop = NO ;
    [self.sysModels enumerateObjectsUsingBlock:^(TTZSYSModel *  sysModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (isStop) {
            *stop = YES;
            return;
        }
        
        [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel *  gObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (isStop) {
                *stop = YES;
                return;
            }
            
            [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel *  cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if(!cellObj.isRequir) {//不是必须
                    if ([cellObj.intervalType isEqualToString:@"independent"]){
                        
                        TTZValueModel *select = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]].firstObject;
                        
                        
                        if(!select || select.value == 1){//没选择 或者 正常
                            return ;
                        }
                        
                        
                        NSArray <TTZChildModel *>*selectChilds = [select.cylinderList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                        
                        if (selectChilds.count) {//至少有一个选择
                            return ;
                        }
                        
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@-%@至少要选择一个",cellObj.projectName,select.name]];
                        isStop = YES;
                        return;
                        
                    }
                    return ;
                }
                
                if (isStop) {
                    *stop = YES;
                    return;
                }
                //单选 多选
                if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                    
                    NSArray <TTZValueModel *>*selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    
                    
                    if(selects.count){
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                    }
                    //输入文本类型
                }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                    //if(!IsEmptyStr(cellObj.intervalRange.interval)) {
                    if(!IsEmptyStr(cellObj.projectVal) || !IsEmptyStr(cellObj.intervalRange.interval)) {
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                        
                    }
                    //故障码类型
                }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
                    //if(cellObj.codes.count) {
                    if(!IsEmptyStr(cellObj.projectVal)) {
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                        
                    }
                    // elecCodeForm 联动故障码
                }else if ([cellObj.intervalType isEqualToString:@"elecCodeForm"]){
                    if(cellObj.codes.count)  {
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                        
                    }
                    NSLog(@"%s", __func__);
                    //  表单
                }else if ([cellObj.intervalType isEqualToString:@"form"]){
                    if(cellObj.codes.count)  {
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                        
                    }
                    NSLog(@"%s", __func__);
                    //  气缸
                }else if ([cellObj.intervalType isEqualToString:@"sameIncrease"]){
                    if(cellObj.codes.count)  {
                        
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                        
                    }
                    NSLog(@"%s", __func__);
                }else if ([cellObj.intervalType isEqualToString:@"independent"]){
                    NSArray <TTZValueModel *>*selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    
                    
                    if(selects.count){
                        
                    }else{
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",cellObj.projectName]];
                        isStop = YES;
                        return;
                    }
                    NSLog(@"%s", __func__);
                }
                
                
                
            }];
        }];
    }];
    
    return !isStop;
}

- (void)finishAction:(UIButton *)sender{
    
    if ([self.billType isEqualToString:@"J005"] ||
        ([self.billType isEqualToString:@"J007"] && self.isFromAI)
        ) {
        
        if (![self canSubmit] || ![self cansubmit]) {
            return;
        }
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [ZZSubmitDataService saveInitialSurveyForBillId:self.billId billType:self.billType
                                             submitData:self.sysModels
                                               baseInfo:@{}
                                                success:^{
                                                    [MBProgressHUD hideHUDForView:self.view];
#warning to pay or list
                                                    
                                                    [self.navigationController.childViewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                        if([obj isKindOfClass:[YHWebFuncViewController class]]){
                                                            [(YHWebFuncViewController*)obj depthDiagnose:self.billId billType:self.billType menuCode:@"" billTypeNew:@""                            with:YES];
                                                        }
                                                    }];
                                                    
                                                }
                                                failure:^(NSError * _Nonnull error) {
                                                    [MBProgressHUD hideHUDForView:self.view];
                                                    [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                }];
        
        return;
    }
    
    if ([self.billType isEqualToString:@"AirConditioner"]) {
        if (![self canSubmit]) {
            return;
        }
        NSArray *submitProjectVal = [self submitProjectVal];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHCarPhotoService new] saveAirConditionCheckInfoWithOrderId:self.billId value:submitProjectVal success:^{
            [MBProgressHUD hideHUDForView:self.view];
            
            YHWebFuncViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count -2];
            vc = [vc isKindOfClass:[YHWebFuncViewController class]]? vc : [YHWebFuncViewController new];
            [vc getIntelligentReport:self.billId];
            return ;
            YHIntelligentDiagnoseController *inteVc = [YHIntelligentDiagnoseController new];
            inteVc.order_id = self.billId;
            [self.navigationController pushViewController:inteVc animated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        }];
        return;
    }
    
    if ([self.billType isEqualToString:@"J009"]) {
        if (![self canSubmit]) {
            return;
        }
        [MBProgressHUD showMessage:@"" toView:self.view];
        [ZZSubmitDataService saveInitialSurveyForBillId:self.billId billType:self.billType submitData:self.sysModels baseInfo:@{} success:^{
            [MBProgressHUD hideHUDForView:self.view];
//            YHWebFuncViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count -2];
//            vc = [vc isKindOfClass:[YHWebFuncViewController class]]? vc : [YHWebFuncViewController new];
//            [vc getReportByBillIdV2:self.billId];
            YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
            vc.billType = self.billType;
            vc.billId = self.billId;
            vc.title = @"AI空调检测";
            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];

            
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        }];
        return;
    }
    
    if ([self.title isEqualToString:@"空调诊断"]) {
        
        if (![self canSubmit]) {
            return;
        }
        
        NSArray *submitProjectVal = [self submitProjectVal];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHCarPhotoService new] getAirConditionResult:submitProjectVal success:^(NSMutableArray<NSDictionary *> *models) {
            TTZAirConditionController *vc = [TTZAirConditionController new];
            vc.models = models;
            vc.title = self.title;
            [self.navigationController pushViewController:vc animated:YES];
            [MBProgressHUD hideHUDForView:self.view];
            //NSMutableArray <TTZSYSModel *>*temps = [TTZSYSModel mj_objectArrayWithKeyValuesArray:self.sysArray];
            //self.sysModels = temps;
            //[self.tableView reloadData];
            return;
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        }];
        return;
    }
    
    if (![self canSave]) {
        [MBProgressHUD showError:@"请恢复轮胎气压值"];
        return;
    }
    //////////////
    if (self.currentIndex < self.sysModels.count - 1) {
        [self tempSave];
        if([self isValid]) self.currentIndex ++;
        if (self.currentIndex == self.sysModels.count - 1){[sender setTitle:@"完成" forState:UIControlStateNormal];}
    }else if (self.currentIndex == self.sysModels.count - 1) {
        
        if ([self.billType isEqualToString:@"J003"]) {
            [self tempSave];
            BOOL isExist = [self isValueExist];
            if (isExist) {
                
                [self.navigationController popViewControllerAnimated:YES];
                if (_backBlock) {
                    _backBlock();
                }
            }
            //            else{
            //
            //                [MBProgressHUD showError:@"提交数据不能为空"];
            //            }
            return;
        }
        
        //!(_callBackBlock)? : _callBackBlock();
        if([self isValid]) [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    TTZSYSModel *sysModel = self.sysModels[self.currentIndex];
    //YES == 正常 NO 取消
    [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [gModel.list enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [cellModel.faultModel.codes removeAllObjects];
            cellModel.faultModel.cellHeight = 0;
            cellModel.showFaultCode = NO;
            
            if (sender.isSelected) {
                //{"id":"1326","code":"chas_pressure_recover","projectName":"有无恢复轮胎气压正常值",
                if(![cellModel.Id isEqualToString:@"1326"]){
                    [cellModel.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull listModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        listModel.isSelected = (listModel.value == 1);
                        if (listModel.value == 1) {
                            cellModel.isChange = ![cellModel.projectVal containsString:listModel.name];
                            cellModel.cellHeight -= cellModel.tableViewHeight;
                            cellModel.tableViewHeight = 0;
                            
                            cellModel.cellHeight -= cellModel.add2CylinderHeight;
                            cellModel.add2CylinderHeight = 0;
                            cellModel.projectVal = [NSString stringWithFormat:@"%@",@(listModel.value)];
                            cellModel.projectOptionName = [NSString stringWithFormat:@"%@",listModel.name];
                            
                        }
                    }];
                }
            }else{
                [cellModel.intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull listModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    listModel.isSelected = NO;
                    
                    cellModel.isChange = !IsEmptyStr(cellModel.projectVal);
                    
                    cellModel.cellHeight -= cellModel.tableViewHeight;
                    cellModel.tableViewHeight = 0;
                    
                    cellModel.cellHeight -= cellModel.add2CylinderHeight;
                    cellModel.add2CylinderHeight = 0;
                    
                    cellModel.projectVal = @"";
                    cellModel.projectOptionName = @"";
                    
                }];
                
            }
        }];
    }];
    
    [self.tableView reloadData];
    
}

- (void)popViewController:(id)sender{
    
    if([self.billType isEqualToString:@"J005"]
       ){
        [super popViewController:sender];
        return;
        NSMutableArray *newVC = [NSMutableArray array];
        NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
        //        [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            if (![obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
        //                [newVC addObject:obj];
        //            }
        //            [newVC addObject:obj];
        //            *stop = YES;
        //        }];
        [newVC addObject:controllers.firstObject];
        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=J005_list&bill_type=%@&status=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId,self.billType];
        controller.urlStr = urlString;
        controller.barHidden = YES;
        [newVC addObject:controller];
        [self.navigationController setViewControllers:newVC];
        
        return;
        
        //        __block UIViewController *vc = nil;
        //        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            if ([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
        //                vc = obj;
        //                [self.navigationController popToViewController:obj animated:YES];
        //                *stop = YES;
        //            }
        //        }];
        //
        //        if (!vc) {
        //            [super popViewController:sender];
        //        }
        //
        //        return;
    }
    
    
    if([self.title isEqualToString:@"空调诊断"] || self.isFromAI)
    {
        [super popViewController:sender];
        return;
    }
    
    if([self.billType isEqualToString:@"AirConditioner"])
    {
        
        
        [super popViewController:sender];
        YHWebFuncViewController *vc = [self.navigationController.childViewControllers lastObject];
        
        NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"airCondition",@"token":[YHTools getAccessToken]} mj_JSONString];
        [vc appToH5:json];
        
        return;
    }
    
    if (![self isChange]) {
        [super popViewController:sender];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIAlertController showAlertInViewController:self
                                       withTitle:@"此次编辑是否保留"
                                         message:nil
                               cancelButtonTitle:@"不保留"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@[@"保留"]
                                        tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                            
                                            if(buttonIndex != controller.cancelButtonIndex){
                                                if (![self canSave]) {
                                                    [MBProgressHUD showError:@"请恢复轮胎气压值"];
                                                    return;
                                                }
                                                //[weakSelf tempSave];
                                                weakSelf.isSave = 1;
                                            }else{
                                                weakSelf.isSave = 2;
                                                if([self.billType isEqualToString:@"A"]
                                                   || [self.billType isEqualToString:@"Y"]
                                                   || [self.billType isEqualToString:@"Y001"]
                                                   || [self.billType isEqualToString:@"Y002"]
                                                   || [self.billType isEqualToString:@"E002"]
                                                   || [self.billType isEqualToString:@"E003"]
                                                   || [self.billType isEqualToString:@"J007"]
                                                   ){
                                                    
                                                    
                                                    NSMutableArray <TTZSYSModel *>*temps = [TTZSYSModel mj_objectArrayWithKeyValuesArray:self.sysArray];
                                                    
                                                    for (TTZGroundModel *gObj in temps[self.currentIndex].list) {
                                                        
                                                        for (TTZSurveyModel *cellobj in gObj.list) {
                                                            
                                                            cellobj.dbImages = nil;
                                                            NSArray *elecCtrlProjectList = cellobj.elecCtrlProjectList;
                                                            cellobj.elecCtrlProjectList = [self modelReplaceDict:elecCtrlProjectList widthAllModel:gObj.list];
                                                        }
                                                    }
                                                    //
                                                    [self.detailNewController.dataArr removeObjectAtIndex:self.currentIndex];
                                                    //
                                                    [self.detailNewController.dataArr insertObject:temps[self.currentIndex] atIndex:self.currentIndex];
                                                    
                                                    //self.detailNewController.dataArr = [TTZSYSModel mj_objectArrayWithKeyValuesArray:self.sysArray];
                                                    NSLog(@"%s", __func__);
                                                }
                                            }
                                            
                                            if( (self.isSave == 1 && ([self.billType isEqualToString:@"A"] || [self.billType isEqualToString:@"Y"] || [self.billType isEqualToString:@"Y001"] || [self.billType isEqualToString:@"Y002"])) && ![self isValid]  ){
                                                
                                                return;
                                            }
                                            
                                            //!(_callBackBlock)? : _callBackBlock();
                                            [super popViewController:sender];
                                        }];
}

- (NSArray *)modelReplaceDict:(NSArray *)dicts
                widthAllModel:(NSArray <TTZSurveyModel *>*)models{
    
    if ([dicts.firstObject isKindOfClass:[TTZSurveyModel class]] || !dicts) {
        return dicts;
    }
    NSMutableArray *temps = [NSMutableArray array];
    [dicts enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *Id = [obj valueForKey:@"id"];
        [models enumerateObjectsUsingBlock:^(TTZSurveyModel * cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([Id isEqualToString:cellObj.Id]) {
                [temps addObject:cellObj];
            }
        }];
    }];
    return temps;
}

- (void)tempSave{
    
    if([self.billType isEqualToString:@"A"] || [self.billType isEqualToString:@"Y"] || [self.billType isEqualToString:@"Y001"] || [self.billType isEqualToString:@"Y002"]) return;
    
    NSMutableArray *initialSurveyProjectVals = [NSMutableArray array];
    [self.sysModels enumerateObjectsUsingBlock:^(TTZSYSModel * _Nonnull sysObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableDictionary *initialSurveyProjectVal = [NSMutableDictionary dictionary];
        NSMutableArray *projectVals = [NSMutableArray array];
        
        [sysObj.list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%s--类型-%@", __func__,cellObj.intervalType);
                NSMutableDictionary *projectVal = [NSMutableDictionary dictionary];
                
                if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                    
                    NSArray *selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    
                    if(selects.count) projectVal[@"projectVal"] = [[selects valueForKeyPath:@"name"] componentsJoinedByString:@","];
                    else projectVal[@"projectVal"] = @"";
                    
                    
                }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                    if(cellObj.intervalRange.interval) projectVal[@"projectVal"] = cellObj.intervalRange.interval;
                    else projectVal[@"projectVal"] = @"";
                    
                }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
                    if(cellObj.codes.count) projectVal[@"projectVal"] = [cellObj.codes componentsJoinedByString:@","];
                    else projectVal[@"projectVal"] = @"";
                }else if ([cellObj.intervalType isEqualToString:@"elecCodeForm"]){
                    if(cellObj.codes.count) projectVal[@"projectVal"] = [cellObj.codes componentsJoinedByString:@","];
                    else projectVal[@"projectVal"] = @"";
                }else{
                    projectVal[@"projectVal"] = @"";
                }
                
                projectVal[@"id"] = cellObj.Id;
                projectVal[@"type"] = cellObj.intervalType;
                projectVal[@"projectImgList"] = cellObj.projectImgList;
                projectVal[@"projectThumbImgList"] = cellObj.projectThumbImgList;
                projectVal[@"projectRelativeImgList"] = cellObj.projectRelativeImgList;
                [projectVals addObject:projectVal];
                
            }];
        }];
        
        initialSurveyProjectVal[@"sysId"] = sysObj.Id;
        initialSurveyProjectVal[@"saveType"] = @"back";
        initialSurveyProjectVal[@"projectVal"] = projectVals;
        [initialSurveyProjectVals addObject:initialSurveyProjectVal];
        
    }];
    self.val[@"initialSurveyProjectVal"] = initialSurveyProjectVals;
    
    
    
    [[YHCarPhotoService new] newTemporarySaveForBillId:self.billId
                                                 value:self.val
                                               success:^{
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
                                               }
                                               failure:nil];
}

- (BOOL)isValidElecCtrlProje:(TTZSYSModel *)model{
    for (TTZGroundModel *gObj in model.list) {
        
        __block NSArray <TTZSurveyModel *>*elecCtrlProjectList;
        
        
        for (TTZSurveyModel *cellobj in gObj.list) {
            
            if([elecCtrlProjectList containsObject:cellobj]) continue;
            
            elecCtrlProjectList = [self findSubSurveyModel:cellobj.elecCtrlProjectList];
            
            //记录故障码带出项目列表
            if (elecCtrlProjectList.count) {
                NSArray *selects = [elecCtrlProjectList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"projectVal.length > 0"]];
                
                if (!selects.count) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@匹配结果至少要填一项",cellobj.projectName]];
                    return NO;
                }
                
            }
        }
    }
    return YES;
}
- (BOOL)isValidSysPressure:(TTZSYSModel *)model{
    // id: 560 名字: 空调系统高压压力  范围:6-15
    // id: 561 名字: 空调系统低压压力  范围:0.5-3.0
    // id: 562 名字: 出风口温度        范围:0-8
    // 如果空调出风口温度为0-8,判断高低压数据是否在此范围内,如果不是返回空调数据有误
    // 如果空调出风口温度不为0-8,则继续往下
    for (TTZGroundModel *gObj in model.list) {
        
        __block NSString * HSysPressure = nil;
        __block NSString * LSysPressure = nil;
        __block NSString * TuyereTemperatureT= nil;
        
        for (TTZSurveyModel *cellobj in gObj.list) {
            
            if ([cellobj.Id isEqualToString:@"560"]) {
                HSysPressure = cellobj.projectVal;
            }
            if ([cellobj.Id isEqualToString:@"561"]) {
                LSysPressure = cellobj.projectVal;
            }
            if ([cellobj.Id isEqualToString:@"562"]) {
                TuyereTemperatureT = cellobj.projectVal;
            }
        }
        
        if (!IsEmptyStr(TuyereTemperatureT) && TuyereTemperatureT.floatValue >= 0 && TuyereTemperatureT.floatValue <= 8) {
            
            if ( HSysPressure.floatValue < 6 || HSysPressure.floatValue > 15) {
                [MBProgressHUD showError:@"空调数据有误"];
                return NO;
            }
            
            if ( LSysPressure.floatValue < 0.5 || LSysPressure.floatValue > 3.0) {
                [MBProgressHUD showError:@"空调数据有误"];
                return NO;
            }
        }
    }
    return YES;
}
- (BOOL)isValidProje:(TTZSYSModel *)model{
    
    for (TTZGroundModel *gObj in model.list) {
        
        __block NSArray <TTZSurveyModel *>*elecCtrlProjectList;
        __block NSUInteger totalCount = 0;
        __block NSUInteger selectCount = 0;
        __block NSString *name = nil;
        
        for (TTZSurveyModel *cellobj in gObj.list) {
            
            if (![cellobj.intervalType isEqualToString:@"elecCodeForm"] && IsEmptyStr(cellobj.projectVal) && !name) {
                name = cellobj.projectName;
                NSArray <TTZValueModel *>*selects = [cellobj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                TTZValueModel *vmodel = selects.firstObject;
                if (vmodel.name && vmodel.childList.count) {
                    name = [NSString stringWithFormat:@"%@-%@结果至少选择一项",name,vmodel.name];
                }
                
                if (vmodel.name && vmodel.cylinderList.count) {
                    name = [NSString stringWithFormat:@"%@-%@结果至少选择一项",name,vmodel.name];
                }
                
            }
            
            //如果是故障码带出的项目就忽略
            if ([elecCtrlProjectList containsObject:cellobj]) {
                name = nil;
                continue ;
            }
            
            NSString *intervalType = cellobj.intervalType;
            
            if (cellobj.elecCtrlProjectList.count || !IsEmptyStr(cellobj.encyDescs)) {
                totalCount += 1;
                selectCount +=1;
                elecCtrlProjectList = [self findSubSurveyModel:cellobj.elecCtrlProjectList];
                
                
            }else if ([intervalType isEqualToString:@"input"]
                      || [intervalType isEqualToString:@"text"]
                      || [intervalType isEqualToString:@"select"]
                      || [intervalType isEqualToString:@"form"]
                      || [intervalType isEqualToString:@"sameIncrease"]
                      || [intervalType isEqualToString:@"radio"]) totalCount += 1;
            
            
            if(!IsEmptyStr(cellobj.projectVal)){
                if(![intervalType isEqualToString:@"elecCodeForm"] && !cellobj.elecCtrlProjectList.count && IsEmptyStr(cellobj.encyDescs)) selectCount +=1;
                //                if (selectCount != totalCount) {
                //                    [MBProgressHUD showError:[NSString stringWithFormat:@"请填写%@",name]];
                //                    return NO;
                //                }
            }
            //else
            //{
            if (selectCount != totalCount && selectCount) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"请填写%@",name]];
                return NO;
            }
            //}
            
        }
    }
    return YES;
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


- (BOOL)isValid{
    
    if(([self.billType isEqualToString:@"A"] || [self.billType isEqualToString:@"Y"] || [self.billType isEqualToString:@"Y001"] || [self.billType isEqualToString:@"Y002"])) {
        
        TTZSYSModel *oSysModel = self.sysModels[self.currentIndex];
        
        if (![self isValidProje:oSysModel]) {
            return NO;
        }
        if (![self isValidSysPressure:oSysModel]) {
            return NO;
        }
        if (![self isValidElecCtrlProje:oSysModel]) {
            return NO;
        }
    }
    
    //    return NO;
    return YES;
    
}

//FIXME:  -  get/set 方法

- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    NSInteger maxIndex = [self.billType isEqualToString:@"J003"] ? 2 : 4;
    _currentIndex = currentIndex;
    
    TTZSYSModel *sysModel = self.sysModels[currentIndex];
    self.navigationItem.title = [NSString stringWithFormat:@"%@检测",sysModel.className];
    NSInteger tagCount = sysModel.list.count;
    
    self.circuitryBtn.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight,screenWidth , self.is_circuitry?44:0);
    
    if (tagCount<maxIndex) {
        self.headerView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight+_circuitryBtn.frame.size.height,screenWidth , 0);
        self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight - self.headerView.frame.size.height - self.circuitryBtn.frame.size.height - kStatusBarAndNavigationBarHeight);
    }else{
        self.headerView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight+_circuitryBtn.frame.size.height,screenWidth , 44);
        self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight - self.headerView.frame.size.height - self.circuitryBtn.frame.size.height - kStatusBarAndNavigationBarHeight);
        
        CGFloat itemWidth = screenWidth / tagCount;
        if (itemWidth < 90) {
            itemWidth = 90;
        }
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.headerView.collectionViewLayout;
        layout.itemSize = CGSizeMake(itemWidth, 34);
    }
    
    if (currentIndex == self.sysModels.count - 1){
        
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
        
        if ([self.billType isEqualToString:@"J003"] ||
            [self.billType isEqualToString:@"J005"] ||
            ([self.billType isEqualToString:@"J007"] && self.isFromAI)
            ) {
            [self.finishButton setTitle:@"提交" forState:UIControlStateNormal];
        }
    }
    
    
    [self.headerView reloadData];
    [self.tableView reloadData];
    self.rightButton.selected = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self.headerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        if(self.tableView.numberOfSections && [self.tableView numberOfRowsInSection:0]) [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //[self.headerView setContentOffset:CGPointZero animated:YES];
        //[self.tableView setContentOffset:CGPointZero animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidEndDecelerating:self.tableView];
        });
        
    });
}

- (UICollectionView *)headerView{
    if (!_headerView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+_circuitryBtn.frame.size.height,screenWidth , 0) collectionViewLayout:layout];
        _headerView.showsHorizontalScrollIndicator = NO;
        _headerView.showsVerticalScrollIndicator = NO;
        _headerView.dataSource = self;
        _headerView.delegate = self;
        _headerView.bounces = NO;
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView registerClass:[TTZHeaderTagCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _headerView;
}


- (UIButton *)circuitryBtn{
    if (!_circuitryBtn) {
        _circuitryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circuitryBtn setTitle:@"电路图图解" forState:UIControlStateNormal];
        [_circuitryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_circuitryBtn setImage:[UIImage imageNamed:@"dianlutu"] forState:UIControlStateNormal];
        [_circuitryBtn setTitleColor:YHColor(119, 119, 119) forState:UIControlStateNormal];
        [_circuitryBtn addTarget:self action:@selector(circuitAction)
                forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, screenWidth, 0.5)];
        line.backgroundColor = YHBackgroundColor;
        [_circuitryBtn addSubview:line];
        _circuitryBtn.clipsToBounds = YES;
    }
    return _circuitryBtn;
}


- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"全部正常" forState:UIControlStateNormal];
        [_rightButton setTitle:@"全部取消" forState:UIControlStateSelected];
        [_rightButton setTitleColor:YHNagavitionBarTextColor forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton sizeToFit];
    }
    return _rightButton;
}

- (UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setBackgroundColor:YHNaviColor];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        //[_finishButton setTitle: [self.title isEqualToString:@"空调诊断"]?@"开始诊断": @"下一项" forState:UIControlStateNormal];
        [_finishButton setTitle:@"下一项" forState:UIControlStateNormal];
        
        if ([self.billType isEqualToString:@"AirConditioner"]) {
            [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
        }
        if ([self.billType isEqualToString:@"J009"]) {
            [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
        }

        if ([self.title isEqualToString:@"空调诊断"]) {
            [_finishButton setTitle:@"开始诊断" forState:UIControlStateNormal];
        }
        if ([self.billType isEqualToString:@"J005"]) {
            [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
        }
        if ([self.billType isEqualToString:@"J007"]) {
            [_finishButton setTitle: (self.isFromAI ? @"提交" : @"下一项") forState:UIControlStateNormal];
        }
        
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        kViewRadius(_finishButton, 8);
        [_finishButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.frame = CGRectMake(10, 10, screenWidth - 20, 44);
    }
    return _finishButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight - self.headerView.frame.size.height  - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerClass:[TTZCheckHeaderCell class] forHeaderFooterViewReuseIdentifier:@"TTZCheckHeaderCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TTZCheckCell" bundle:nil] forCellReuseIdentifier:@"TTZCheckCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kSafeBottomHeight, 0 );
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 66;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        //footerView.backgroundColor = [UIColor redColor];
        [footerView addSubview:self.finishButton];
        _tableView.tableFooterView = footerView;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
        
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableDictionary *)val{
    if(!_val){
        _val = [NSMutableDictionary dictionary];
        _val[@"baseInfo"] = self.baseInfo?self.baseInfo:@{};
        _val[@"initialSurveyProjectVal"] = [NSMutableArray array];
    }
    return _val;
}


- (NSMutableArray *)submitProjectVal{
    NSMutableArray *projectVal = [NSMutableArray array];
    
    
    
    [self.sysModels enumerateObjectsUsingBlock:^(TTZSYSModel *  sysModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel *  gObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel *  cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //单选 多选
                if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                    
                    NSArray <TTZValueModel *>*selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    
                    //NSString *projectValString = [[selects valueForKeyPath:@"value"] componentsJoinedByString:@","];
                    NSString *projectValString = [[selects valueForKeyPath:@"name"] componentsJoinedByString:@","];
                    
                    NSArray <TTZChildModel *>*childList = selects.firstObject.childList;
                    if (childList) {
                        NSArray <TTZChildModel *>*selectChild = [childList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                        projectValString = [[selectChild valueForKeyPath:@"value"] componentsJoinedByString:@","];
                        NSLog(@"%s", __func__);
                    }
                    
                    if(selects.count){
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    //输入文本类型
                }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                    //if(!IsEmptyStr(cellObj.intervalRange.interval)) {
                    if(!IsEmptyStr(cellObj.projectVal) || !IsEmptyStr(cellObj.intervalRange.interval)) {
                        
                        NSString *projectValString = IsEmptyStr(cellObj.projectVal)? cellObj.intervalRange.interval : cellObj.projectVal;
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    //故障码类型
                }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
                    //if(cellObj.codes.count) {
                    if(!IsEmptyStr(cellObj.projectVal)) {
                        
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":cellObj.projectVal}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    // elecCodeForm 联动故障码
                }else if ([cellObj.intervalType isEqualToString:@"elecCodeForm"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                    //  表单
                }else if ([cellObj.intervalType isEqualToString:@"form"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                    //  气缸
                }else if ([cellObj.intervalType isEqualToString:@"sameIncrease"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                }
                
                
                
            }];
        }];
    }];
    return projectVal;
}


@end
