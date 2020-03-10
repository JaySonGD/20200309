//
//  YHHistoryController.m
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHHistoryController.h"
#import "PCAccountController.h"
#import "PCAlertViewController.h"

#import "YHCommon.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "PCPersonModel.h"
#import "MBProgressHUD+MJ.h"

#import "PCTestRecordModel.h"
#import "PCMessageModel.h"
#import "YHModelItem.h"

#import "PCHistoryCell.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
NSString *const notificationConfirmReport = @"notificationConfirmReport";

@interface YHHistoryController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray <YHCellItem *>*items;

@property (nonatomic, strong) PCTestRecordModel * model;

@property (nonatomic, assign) BOOL isPostTop;
@property (nonatomic, assign) BOOL isPostButtom;

@end

@implementation YHHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = YHColor0X(0xEFF1F0, 1.0);

    CGFloat w = (screenWidth - 20 * 2 - 15) * 0.5;
    CGFloat h = 87;//w / 160.0 * 87;
    self.layout.itemSize = CGSizeMake(w, h);
    self.layout.minimumLineSpacing = 15.0;
    self.layout.minimumInteritemSpacing = 15.0;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.collectionView.alwaysBounceVertical = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:notificationConfirmReport object:self.parentViewController queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        YHLog(@"%s---%@", __func__,note);
        if(note.object != self) return ;
        NSString *personId = [note.userInfo objectForKey:@"personId"];
        [self confirmReport:personId];
    }];
    
    
}

- (void)dealloc{
    YHLog(@"%s", __func__);
}


- (void)setAccountId:(NSString *)accountId{
    _accountId = accountId;
    _isPostTop = NO;
    _isPostButtom = NO;
    [self getReports];
}

- (void)setModel:(PCTestRecordModel *)model{
    _model = model;

    #ifdef YHTest
    [MBProgressHUD showError:[NSString stringWithFormat:@"报告: %@", model.reportId]];
    #endif
    //1、已确认的不弹提示框
    //2.需确认的弹提示框，数据差距大，点击就去切换用户
    
    ////测量量数据归属状态 0:待确认 1:已确认
    
//    if(!self.messageModel) return;//历史数据不需要确认
    
    
    if (!model.status) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定测量用户为\"%@\"",model.personName] message:nil];
            
            [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
                [self modifyUser];
            }];
            [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                [self confirmReport:self.personId];
            }];
            [self presentViewController:vc animated:NO completion:nil];

            
        });
        return;
    }
    
    if (self.isNews) {//自动确认消息，需要更新模型
        [self getLastReports:self.messageModel];
    }
}

- (void)getReports{
    
//    NSString *personId = YHTools.personId;
//    NSString *accountId = YHTools.accountId;
    
    if (!self.personId || !self.accountId || !self.reportId) {
        
        return;
    }

    
    [MBProgressHUD showMessage:nil toView:self.view];

    //1.8.4.获取指定测量记录
    //@{@"personId":@"",@"reportId":@"",@"accountId":@""}
    NSDictionary *parm = @{@"personId":self.personId,@"reportId":self.reportId,@"accountId":self.accountId};

    [[YHNetworkManager sharedYHNetworkManager] getReportId:parm onComplete:^(PCTestRecordModel * _Nonnull model,id info) {
        [MBProgressHUD hideHUDForView:self.view];

        self.model = model;
        [self.collectionView reloadData];
        
    } onError:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];


    }];
}


- (void)confirmReport:(NSString *)personId{
    
    if (!personId || !self.reportId) {
        
        return;
    }

    //@{@"personId":@"",@"reportId":@"",@"accountId":@""}
    NSDictionary *parm = @{@"personId":personId,@"reportId":self.reportId,@"accountId":[YHTools accountId]};
    if (self.messageModel == nil && self.scrollIndex == 0) {
        self.messageModel = [PCMessageModel new];
        self.messageModel.info = [PCMessageBodyModel new];
        self.messageModel.info.personId = personId;
        self.messageModel.info.accountId = [YHTools accountId];
        self.messageModel.info.reportId = self.reportId;
    }else{
        self.messageModel.info.personId = personId;
    }
    [[YHNetworkManager sharedYHNetworkManager] confirmReport:parm onComplete:^{
        [MBProgressHUD showError:@"确认成功"];

        if(self.messageModel && !self.scrollIndex){// 最新体型数据
            [self getLastReports:self.messageModel];
            return ;
        }
        
    } onError:^(NSError *error) {

    }];
}

- (void)getLastReports:(PCMessageModel *)model{
    
    
    if (!model.info.personId || !model.info.accountId || !model.info.reportId) {
        
        return;
    }
    
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    //1.8.4.获取指定测量记录
    //@{@"personId":@"",@"reportId":@"",@"accountId":@""}
    NSDictionary *parm = @{@"personId":model.info.personId,@"reportId":model.info.reportId,@"accountId":model.info.accountId};
    
    [[YHNetworkManager sharedYHNetworkManager] getReportId:parm onComplete:^(PCTestRecordModel * _Nonnull model ,id info) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCNotificationFirstFigureResult" object:nil userInfo:@{@"data":model,@"info":info}];
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } onError:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.userInfo[@"message"]];
        
    }];
}



- (void)modifyUser{
    PCAccountController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCAccountController"];
    vc.sourceVC = self.parentViewController;
    vc.observer = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PCHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.item];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    YHLog(@"%s---%f", __func__,scrollView.contentOffset.y);
    
    
    if (scrollView.contentOffset.y <= -150 && !_isPostTop) {
        _isPostTop = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCHistoryContentScrollPosition" object:nil userInfo:@{@"index":[NSIndexPath indexPathForRow:self.view.tag - 1 inSection:0]}];
        return;
    }
    
    if (scrollView.contentOffset.y >= 150 && !_isPostButtom) {
        _isPostButtom = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCHistoryContentScrollPosition" object:nil userInfo:@{@"index":[NSIndexPath indexPathForRow:self.view.tag + 1 inSection:0]}];
        return;
    }

    
}

- (NSMutableArray<YHCellItem *> *)items{
    
    if (!_items && self.model) {
        _items = [NSMutableArray array];
        
        //7
        YHCellItem *item11 = [YHCellItem new];
        item11.name = @"肩宽";
        item11.normal = self.model.shoulder.normal.value;
        item11.up = self.model.shoulder.up.value;
        item11.value = self.model.shoulder.normal.value;
        item11.down = self.model.shoulder.down.value;
        item11.icon = [NSString stringWithFormat:@"肩_%d",YHTools.sharedYHTools.masterPersion.sex];//@"肩";
        item11.change = self.model.shoulderDiffer.normal;
        item11.bodyParts = @"shoulder";
        [_items addObject:item11];
        
        
        
        //0
        YHCellItem *item4 = [YHCellItem new];
        item4.name = @"胸围";
        item4.normal = self.model.bust.normal.value;
        item4.up = self.model.bust.up.value ;//self.model.bust;
        item4.value = self.model.bust.normal.value ;
        item4.down = self.model.bust.down.value ;
        item4.icon = [NSString stringWithFormat:@"胸_%d",YHTools.sharedYHTools.masterPersion.sex];//@"胸";
        item4.change = self.model.bustDiffer.normal;
        item4.bodyParts = @"bust";
        
        [_items addObject:item4];
        //1
        YHCellItem *item = [YHCellItem new];
        item.name = @"左上臂";
        item.normal = self.model.leftUpperArm.normal.value;
        item.up = self.model.leftUpperArm.normal.value ;//self.model.leftUpperArm;
        item.value = self.model.leftUpperArm.down.value ;
        item.down = self.model.leftUpperArm.down1.value ;
        item.icon = [NSString stringWithFormat:@"左臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item.change = self.model.leftUpperArmDiffer.normal ;
        item.bodyParts = @"leftUpperArm";
        
        [_items addObject:item];
        //2
        YHCellItem *item1 = [YHCellItem new];
        item1.name = @"右上臂";
        item1.normal = self.model.rightUpperArm.normal.value;
        item1.up = self.model.rightUpperArm.normal.value ;//self.model.rightUpperArm;
        item1.value = self.model.rightUpperArm.down1.value ;
        item1.down = self.model.rightUpperArm.down1.value ;
        item1.icon = [NSString stringWithFormat:@"右臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item1.change = self.model.rightUpperArmDiffer.normal ;
        item1.bodyParts = @"rightUpperArm";
        
        [_items addObject:item1];
        
        
        //10
        YHCellItem *item2 = [YHCellItem new];
        item2.name = @"左下臂";
        item2.normal = self.model.leftLowerArm.normal.value;
        item2.up = self.model.leftLowerArm.up.value; //self.model.leftLowerArm;
        item2.value = self.model.leftLowerArm.normal.value;
        item2.down = self.model.leftLowerArm.down.value;
        item2.icon = [NSString stringWithFormat:@"左小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item2.change = self.model.leftLowerArmDiffer.normal;
        item2.bodyParts = @"leftLowerArm";
        
        [_items addObject:item2];
        //11
        YHCellItem *item3 = [YHCellItem new];
        item3.name = @"右下臂";
        item3.normal = self.model.rightLowerArm.normal.value;
        item3.up = self.model.rightLowerArm.up.value ;//self.model.rightLowerArm;
        item3.value = self.model.rightLowerArm.normal.value ;
        item3.down = self.model.rightLowerArm.down.value ;
        item3.icon = [NSString stringWithFormat:@"右小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item3.change = self.model.rightLowerArmDiffer.normal;
        item3.bodyParts = @"rightLowerArm";
        
        [_items addObject:item3];
        
        
        //3
        YHCellItem *item6 = [YHCellItem new];
        item6.name = @"腰围";
        item6.normal = self.model.waist.normal.value;
        item6.up = self.model.waist.up.value ;//self.model.waist;
        item6.value = self.model.waist.normal.value ;
        item6.down = self.model.waist.down.value ;
        item6.icon = [NSString stringWithFormat:@"腰_%d",YHTools.sharedYHTools.masterPersion.sex];//@"腰";
        item6.change = self.model.waistDiffer.normal;
        item6.bodyParts = @"waist";
        
        [_items addObject:item6];
        
        //4
        YHCellItem *item5 = [YHCellItem new];
        item5.name = @"臀围";
        item5.normal = self.model.hipline.normal.value;
        item5.up = self.model.hipline.up.value ;//self.model.hipline;
        item5.value = self.model.hipline.normal.value ;
        item5.down = self.model.hipline.down.value ;
        item5.icon = [NSString stringWithFormat:@"臀_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item5.change = self.model.hiplineDiffer.normal ;
        item5.bodyParts = @"hipline";
        
        [_items addObject:item5];
        
        //5
        YHCellItem *item8 = [YHCellItem new];
        item8.name = @"左大腿";
        item8.normal = self.model.leftThigh.normal.value;
        item8.up = self.model.leftThigh.normal.value ;//self.model.leftThigh;
        item8.value = self.model.leftThigh.down.value ;
        item8.down = self.model.leftThigh.down1.value ;
        item8.icon = [NSString stringWithFormat:@"左大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左大腿";
        item8.change = self.model.leftThighDiffer.normal ;
        item8.bodyParts = @"leftThigh";
        
        [_items addObject:item8];
        
        //6
        YHCellItem *item10 = [YHCellItem new];
        item10.name = @"右大腿";
        item10.normal = self.model.rightThigh.normal.value;
        item10.up = self.model.rightThigh.normal.value;
        item10.value = self.model.rightThigh.down.value;
        item10.down = self.model.rightThigh.down1.value;
        item10.icon = [NSString stringWithFormat:@"右大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右大腿";
        item10.change = self.model.rightThighDiffer.normal;
        item10.bodyParts = @"rightThigh";
        
        [_items addObject:item10];
        
        //9
        YHCellItem *item7 = [YHCellItem new];
        item7.name = @"左小腿";
        item7.normal = self.model.leftLeg.normal.value;
        item7.up = self.model.leftLeg.up.value ;//self.model.leftLeg;
        item7.value = self.model.leftLeg.normal.value ;
        item7.down = self.model.leftLeg.down.value ;
        item7.icon = [NSString stringWithFormat:@"左小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左小腿";
        item7.change = self.model.leftLegDiffer.normal ;
        item7.bodyParts = @"leftLeg";
        
        [_items addObject:item7];
        
        //8
        YHCellItem *item9 = [YHCellItem new];
        item9.name = @"右小腿";
        item9.normal = self.model.rightLeg.normal.value;
        item9.up = self.model.rightLeg.up.value;//self.model.rightLeg;
        item9.value = self.model.rightLeg.normal.value;
        item9.down = self.model.rightLeg.down.value;
        item9.icon = [NSString stringWithFormat:@"右小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右小腿";
        item9.change = self.model.rightLegDiffer.normal;
        item9.bodyParts = @"rightLeg";
        
        [_items addObject:item9];
        
        
        YHCellItem *item12 = [YHCellItem new];
        item12.name = @"体重";
        item12.normal = [self.model.weight floatValue] ;//self.bust;
        item12.icon = @"体重";
        [_items addObject:item12];

        
    }
    return _items;
}
@end
