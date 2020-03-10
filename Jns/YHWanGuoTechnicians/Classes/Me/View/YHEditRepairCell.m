//
//  YHEditRepairCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/12.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHEditRepairCell.h"
#import "YHCommon.h"

NSString *const notificationRepairAdd = @"YHNotificationRepairAdd";
NSString *const notificationRepairDel = @"YHNotificationRepairDel";
@interface YHEditRepairCell ()
- (IBAction)delAction:(id)sender;
- (IBAction)copyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *editIG;
@property (weak, nonatomic) IBOutlet UILabel *editRepairDescL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxRightLC;
@property (weak, nonatomic) IBOutlet UIButton *delB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLC;
@property (weak, nonatomic) IBOutlet UIButton *cyB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fisrtBLC;
@property (weak, nonatomic)NSDictionary *info;


@end
@implementation YHEditRepairCell
#pragma mark - 编辑按钮 ----
- (IBAction)editAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(notificationRepairEdit:)]) {
        [_delegate notificationRepairEdit:_info];
    }
}

- (void)loadDataSource:(NSDictionary*)info isAdd:(BOOL)isAdd isSel:(BOOL)isSel isCloud:(BOOL)isCloud isRepairPrice:(BOOL)isRepairPrice isFirt:(BOOL)isFirt{
    self.info = info;
    NSString *icon = @"repairN";
    if (!isAdd) {
        if (isSel) {
            _editRepairDescL.textColor = YHNaviColor;
            icon = ((isCloud)? (@"yunRepair") : (@"repair"));
        }else{
            _editRepairDescL.textColor = YHCellColor;
            icon = ((isCloud)? (@"yunRepairN") : (@"repairN"));
        }
    }else{
        _editRepairDescL.textColor = YHCellColor;
    }
    _editRepairDescL.text = ((isAdd)? (@"新增维修方式") : (info[@"repairStr"]));
    _delB.hidden = isAdd || isCloud;
    _cyB.hidden = isAdd;
    _editIG.image = [UIImage imageNamed:((isAdd)? (@"ic_add") : (icon))];
    if (isCloud) {
        _secondLC.constant = -51;
        _boxRightLC.constant = 102;
    }else if (isRepairPrice) {
        if (isFirt) {//只有一个维修方案，不可以删除方案
            _delB.hidden = YES;
            _cyB.hidden = isRepairPrice;
            _fisrtBLC.constant = -50;
            _boxRightLC.constant = 52;
        }else{
            _cyB.hidden = isRepairPrice;
            _fisrtBLC.constant = 1;
            _boxRightLC.constant = 102;
        }
    }else{
        _boxRightLC.constant = ((isAdd)? (0) : (153));
    }
    
}

- (void)loadDataSource:(NSDictionary*)info isAdd:(BOOL)isAdd isSel:(BOOL)isSel{
    [self loadDataSource:info isAdd:isAdd isSel:isSel isCloud:NO isRepairPrice:NO isFirt:NO];
}
#pragma mark - 删除按钮 ----
- (IBAction)delAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationRepairDel object:nil userInfo:_info];
}
#pragma mark - 复制按钮 ---
- (IBAction)copyAction:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:notificationRepairAdd
     object:nil
     userInfo:_info];
}
@end
