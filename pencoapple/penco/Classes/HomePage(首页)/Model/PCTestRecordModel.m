
//
//  PCTestRecordModel.m
//  penco
//
//  Created by Jay on 26/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCTestRecordModel.h"
#import "YHTools.h"
#import "PCPersonModel.h"

@implementation PCLocationModel @end
@implementation PCPointModel @end
@implementation PCDifferModel @end
@implementation PCPartModel @end

@implementation PCTestRecordModel

- (void)setCreateTime:(NSString *)createTime{
    _createTime = [createTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

- (void)setReportTime:(NSString *)reportTime{
    _reportTime = [reportTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"reportId":@[@"reportId",@"figureRecordId"],
        @"status":@[@"status",@"confirmStatus"]
    };
}


- (BOOL)isConfirm{
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    //    @property (nonatomic, strong) PCPartModel *;
    if (self.leftUpperArmDiffer.normal > 0.05) {
        return YES;
    }
    if (self.rightUpperArmDiffer.normal > 0.05) {
        return YES;
    }
    if (self.leftLowerArmDiffer.normal > 0.05) {
        return YES;
    }
    if (self.rightLowerArmDiffer.normal > 0.05) {
        return YES;
    }
    
    if (self.bustDiffer.normal > 0.05) {
        return YES;
    }
    if (self.hiplineDiffer.normal > 0.05) {
        return YES;
    }
    
    if (self.waistDiffer.normal > 0.05) {
        return YES;
    }
    if (self.leftLegDiffer.normal > 0.05) {
        return YES;
    }
    
    if (self.leftThighDiffer.normal > 0.05) {
        return YES;
    }
    if (self.rightLegDiffer.normal > 0.05) {
        return YES;
    }
    if (self.rightThighDiffer.normal > 0.05) {
        return YES;
    }
    if (self.shoulderDiffer.normal > 0.05) {
        return YES;
    }
    
    return NO;
    
}


- (NSMutableArray<YHCellItem *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
        
        //7
        YHCellItem *item11 = [YHCellItem new];
        item11.name = @"肩宽";
        item11.normal = self.shoulder.normal.value;
        item11.up = self.shoulder.up.value;
        item11.value = self.shoulder.normal.value;
        item11.down = self.shoulder.down.value;
        item11.icon = [NSString stringWithFormat:@"肩_%d",YHTools.sharedYHTools.masterPersion.sex];//@"肩";
        item11.change = self.shoulderDiffer.normal;
        item11.bodyParts = @"shoulder";
        [_items addObject:item11];
        
        
        
        //0
        YHCellItem *item4 = [YHCellItem new];
        item4.name = @"胸围";
        item4.normal = self.bust.normal.value;
        item4.up = self.bust.up.value ;//self.bust;
        item4.value = self.bust.normal.value ;
        item4.down = self.bust.down.value ;
        item4.icon = [NSString stringWithFormat:@"胸_%d",YHTools.sharedYHTools.masterPersion.sex];//@"胸";
        item4.change = self.bustDiffer.normal;
        item4.bodyParts = @"bust";
        
        [_items addObject:item4];
        //1
        YHCellItem *item = [YHCellItem new];
        item.name = @"左上臂";
        item.normal = self.leftUpperArm.normal.value;
        item.up = self.leftUpperArm.normal.value ;//self.leftUpperArm;
        item.value = self.leftUpperArm.down.value ;
        item.down = self.leftUpperArm.down1.value ;
        item.icon = [NSString stringWithFormat:@"左臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item.change = self.leftUpperArmDiffer.normal ;
        item.bodyParts = @"leftUpperArm";
        
        [_items addObject:item];
        //2
        YHCellItem *item1 = [YHCellItem new];
        item1.name = @"右上臂";
        item1.normal = self.rightUpperArm.normal.value;
        item1.up = self.rightUpperArm.normal.value ;//self.rightUpperArm;
        item1.value = self.rightUpperArm.down1.value ;
        item1.down = self.rightUpperArm.down1.value ;
        item1.icon = [NSString stringWithFormat:@"右臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item1.change = self.rightUpperArmDiffer.normal ;
        item1.bodyParts = @"rightUpperArm";
        
        [_items addObject:item1];
        
        
        //10
        YHCellItem *item2 = [YHCellItem new];
        item2.name = @"左下臂";
        item2.normal = self.leftLowerArm.normal.value;
        item2.up = self.leftLowerArm.up.value; //self.leftLowerArm;
        item2.value = self.leftLowerArm.normal.value;
        item2.down = self.leftLowerArm.down.value;
        item2.icon = [NSString stringWithFormat:@"左小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item2.change = self.leftLowerArmDiffer.normal;
        item2.bodyParts = @"leftLowerArm";
        
        [_items addObject:item2];
        //11
        YHCellItem *item3 = [YHCellItem new];
        item3.name = @"右下臂";
        item3.normal = self.rightLowerArm.normal.value;
        item3.up = self.rightLowerArm.up.value ;//self.rightLowerArm;
        item3.value = self.rightLowerArm.normal.value ;
        item3.down = self.rightLowerArm.down.value ;
        item3.icon = [NSString stringWithFormat:@"右小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item3.change = self.rightLowerArmDiffer.normal;
        item3.bodyParts = @"rightLowerArm";
        
        [_items addObject:item3];
        
        
        //3
        YHCellItem *item6 = [YHCellItem new];
        item6.name = @"腰围";
        item6.normal = self.waist.normal.value;
        item6.up = self.waist.up.value ;//self.waist;
        item6.value = self.waist.normal.value ;
        item6.down = self.waist.down.value ;
        item6.icon = [NSString stringWithFormat:@"腰_%d",YHTools.sharedYHTools.masterPersion.sex];//@"腰";
        item6.change = self.waistDiffer.normal;
        item6.bodyParts = @"waist";
        
        [_items addObject:item6];
        
        //4
        YHCellItem *item5 = [YHCellItem new];
        item5.name = @"臀围";
        item5.normal = self.hipline.normal.value;
        item5.up = self.hipline.up.value ;//self.hipline;
        item5.value = self.hipline.normal.value ;
        item5.down = self.hipline.down.value ;
        item5.icon = [NSString stringWithFormat:@"臀_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item5.change = self.hiplineDiffer.normal ;
        item5.bodyParts = @"hipline";
        
        [_items addObject:item5];
        
        //5
        YHCellItem *item8 = [YHCellItem new];
        item8.name = @"左大腿";
        item8.normal = self.leftThigh.normal.value;
        item8.up = self.leftThigh.normal.value ;//self.leftThigh;
        item8.value = self.leftThigh.down.value ;
        item8.down = self.leftThigh.down1.value ;
        item8.icon = [NSString stringWithFormat:@"左大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左大腿";
        item8.change = self.leftThighDiffer.normal ;
        item8.bodyParts = @"leftThigh";
        
        [_items addObject:item8];
        
        //6
        YHCellItem *item10 = [YHCellItem new];
        item10.name = @"右大腿";
        item10.normal = self.rightThigh.normal.value;
        item10.up = self.rightThigh.normal.value;
        item10.value = self.rightThigh.down.value;
        item10.down = self.rightThigh.down1.value;
        item10.icon = [NSString stringWithFormat:@"右大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右大腿";
        item10.change = self.rightThighDiffer.normal;
        item10.bodyParts = @"rightThigh";
        
        [_items addObject:item10];
        
        //9
        YHCellItem *item7 = [YHCellItem new];
        item7.name = @"左小腿";
        item7.normal = self.leftLeg.normal.value;
        item7.up = self.leftLeg.up.value ;//self.leftLeg;
        item7.value = self.leftLeg.normal.value ;
        item7.down = self.leftLeg.down.value ;
        item7.icon = [NSString stringWithFormat:@"左小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左小腿";
        item7.change = self.leftLegDiffer.normal ;
        item7.bodyParts = @"leftLeg";
        
        [_items addObject:item7];
        
        //8
        YHCellItem *item9 = [YHCellItem new];
        item9.name = @"右小腿";
        item9.normal = self.rightLeg.normal.value;
        item9.up = self.rightLeg.up.value;//self.rightLeg;
        item9.value = self.rightLeg.normal.value;
        item9.down = self.rightLeg.down.value;
        item9.icon = [NSString stringWithFormat:@"右小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右小腿";
        item9.change = self.rightLegDiffer.normal;
        item9.bodyParts = @"rightLeg";
        
        [_items addObject:item9];
        
        
        
        
        
        
        
        
        
        [_items makeObjectsPerformSelector:@selector(setReportTime:) withObject:self.reportTime];
        
    }
    return _items;
}



- (NSMutableArray<YHCellItem *> *)contrastWithHeight:(NSInteger)height{
    if (!_items) {
        _items = [NSMutableArray array];
        
        
        YHCellItem *item11 = [YHCellItem new];
        item11.name = @"肩宽";
        item11.up = self.shoulder.up.value;
        item11.value = self.shoulder.normal.value;
        item11.down = self.shoulder.down.value;
        item11.icon = [NSString stringWithFormat:@"肩_%d",YHTools.sharedYHTools.masterPersion.sex];//@"肩";
        item11.change = self.shoulderDiffer.normal;
        item11.bodyParts = @"shoulder";
        
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item11.min = 0.23 * 90;
            item11.max = 0.23 * 210;
            item11.normalMin = 0.23 * height - 3;
            item11.normalMax = 0.23 * height + 3;
        }else{
            item11.min = 0.27 * 90;
            item11.max = 0.27 * 210;
            item11.normalMin = 0.27 * height - 3;
            item11.normalMax = 0.27 * height + 3;
        }
        [_items addObject:item11];
        
        
        YHCellItem *item4 = [YHCellItem new];
        item4.name = @"胸围";
        item4.up = self.bust.up.value ;//self.bust;
        item4.value = self.bust.normal.value ;
        item4.down = self.bust.down.value ;
        item4.icon = [NSString stringWithFormat:@"胸_%d",YHTools.sharedYHTools.masterPersion.sex];//@"胸";
        item4.change = self.bustDiffer.normal;
        item4.bodyParts = @"bust";
        
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item4.min = 0.495 * 90;
            item4.max = 0.495 * 210;
            item4.normalMin = 0.495 * height - 3;
            item4.normalMax = 0.495 * height + 3;
        }else{
            item4.min = 0.57 * 90;
            item4.max = 0.57 * 210;
            item4.normalMin = 0.57 * height - 3;
            item4.normalMax = 0.57 * height + 3;
        }
        [_items addObject:item4];
        
        YHCellItem *item = [YHCellItem new];
        item.name = @"左上臂";
        item.up = self.leftUpperArm.up.value ;//self.leftUpperArm;
        item.value = self.leftUpperArm.normal.value ;
        item.down = self.leftUpperArm.down.value ;
        item.icon = [NSString stringWithFormat:@"左臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item.change = self.leftUpperArmDiffer.normal ;
        item.bodyParts = @"leftUpperArm";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item.min = 0.14 * 90;
            item.max = 0.14 * 210;
            item.normalMin = 0.14 * height - 3;
            item.normalMax = 0.14 * height + 3;
        }else{
            item.min = 0.25 * 90 - 10;
            item.max = 0.25 * 210 - 10;
            item.normalMin = 0.25 * height - 10 - 3;
            item.normalMax = 0.25 * height - 10 + 3;
        }
        [_items addObject:item];
        
        
        YHCellItem *item1 = [YHCellItem new];
        item1.name = @"右上臂";
        item1.up = self.rightUpperArm.up.value ;//self.rightUpperArm;
        item1.value = self.rightUpperArm.normal.value ;
        item1.down = self.rightUpperArm.down.value ;
        item1.icon = [NSString stringWithFormat:@"右臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item1.change = self.rightUpperArmDiffer.normal ;
        item1.bodyParts = @"rightUpperArm";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item1.min = 0.14 * 90;
            item1.max = 0.14 * 210;
            item1.normalMin = 0.14 * height - 3;
            item1.normalMax = 0.14 * height + 3;
        }else{
            item1.min = 0.25 * 90 - 10;
            item1.max = 0.25 * 210 - 10;
            item1.normalMin = 0.25 * height - 10 - 3;
            item1.normalMax = 0.25 * height - 10 + 3;
        }
        [_items addObject:item1];
        
        
        YHCellItem *item2 = [YHCellItem new];
        item2.name = @"左下臂";
        item2.up = self.leftLowerArm.up.value; //self.leftLowerArm;
        item2.value = self.leftLowerArm.normal.value;
        item2.down = self.leftLowerArm.down.value;
        item2.icon = [NSString stringWithFormat:@"左小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item2.change = self.leftLowerArmDiffer.normal;
        item2.bodyParts = @"leftLowerArm";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item2.min = 0.14 * 90 - 2;
            item2.max = 0.14 * 210 - 2;
            item2.normalMin = 0.14 * height - 2 - 3;
            item2.normalMax = 0.14 * height - 2 + 3;
        }else{
            item2.min = 0.25 * 90 - 13;
            item2.max = 0.25 * 210 - 13;
            item2.normalMin = 0.25 * height - 13 - 3;
            item2.normalMax = 0.25 * height - 13 + 3;
        }
        [_items addObject:item2];
        
        YHCellItem *item3 = [YHCellItem new];
        item3.name = @"右下臂";
        item3.up = self.rightLowerArm.up.value ;//self.rightLowerArm;
        item3.value = self.rightLowerArm.normal.value ;
        item3.down = self.rightLowerArm.down.value ;
        item3.icon = [NSString stringWithFormat:@"右小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item3.change = self.rightLowerArmDiffer.normal;
        item3.bodyParts = @"rightLowerArm";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item3.min = 0.14 * 90 - 2;
            item3.max = 0.14 * 210 - 2;
            item3.normalMin = 0.14 * height - 2 - 3;
            item3.normalMax = 0.14 * height - 2 + 3;
        }else{
            item3.min = 0.25 * 90 - 13;
            item3.max = 0.25 * 210 - 13;
            item3.normalMin = 0.25 * height - 13 - 3;
            item3.normalMax = 0.25 * height - 13 + 3;
        }
        [_items addObject:item3];
        
        
        
        YHCellItem *item6 = [YHCellItem new];
        item6.name = @"腰围";
        item6.up = self.waist.up.value ;//self.waist;
        item6.value = self.waist.normal.value ;
        item6.down = self.waist.down.value ;
        item6.icon = [NSString stringWithFormat:@"腰_%d",YHTools.sharedYHTools.masterPersion.sex];//@"腰";
        item6.change = self.waistDiffer.normal;
        item6.bodyParts = @"waist";
        
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item6.min = 0.37 * 90;
            item6.max = 0.37 * 210;
            item6.normalMin = 0.37 * height - 3;
            item6.normalMax = 0.37 * height + 3;
        }else{
            item6.min = 0.42 * 90;
            item6.max = 0.42 * 210;
            item6.normalMin = 0.42 * height - 3;
            item6.normalMax = 0.42 * height + 3;
        }
        [_items addObject:item6];
        
        
        
        YHCellItem *item5 = [YHCellItem new];
        item5.name = @"臀围";
        item5.up = self.hipline.up.value ;//self.hipline;
        item5.value = self.hipline.normal.value ;
        item5.down = self.hipline.down.value ;
        item5.icon = [NSString stringWithFormat:@"臀_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item5.change = self.hiplineDiffer.normal ;
        item5.bodyParts = @"hipline";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item5.min = 0.51 * 90;
            item5.max = 0.51 * 210;
            item5.normalMin = 0.51 * height - 3;
            item5.normalMax = 0.51 * height + 3;
        }else{
            item5.min = 0.52 * 90;
            item5.max = 0.52 * 210;
            item5.normalMin = 0.52 * height - 3;
            item5.normalMax = 0.52 * height + 3;
        }
        [_items addObject:item5];
        
        
        
        
        
        
        
        
        YHCellItem *item8 = [YHCellItem new];
        item8.name = @"左大腿";
        item8.up = self.leftThigh.up.value ;//self.leftThigh;
        item8.value = self.leftThigh.normal.value ;
        item8.down = self.leftThigh.down.value ;
        item8.icon = [NSString stringWithFormat:@"左大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左大腿";
        item8.change = self.leftThighDiffer.normal ;
        item8.bodyParts = @"leftThigh";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item8.min = 0.28 * 90;
            item8.max = 0.28 * 210;
            item8.normalMin = 0.28 * height - 3;
            item8.normalMax = 0.28 * height + 3;
        }else{
            item8.min = 0.31 * 90;
            item8.max = 0.31 * 210;
            item8.normalMin = 0.31 * height - 3;
            item8.normalMax = 0.31 * height + 3;
        }
        [_items addObject:item8];
        
        
        YHCellItem *item10 = [YHCellItem new];
        item10.name = @"右大腿";
        item10.up = self.rightThigh.up.value;
        item10.value = self.rightThigh.normal.value;
        item10.down = self.rightThigh.down.value;
        item10.icon = [NSString stringWithFormat:@"右大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右大腿";
        item10.change = self.rightThighDiffer.normal;
        item10.bodyParts = @"rightThigh";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item10.min = 0.28 * 90;
            item10.max = 0.28 * 210;
            item10.normalMin = 0.28 * height - 3;
            item10.normalMax = 0.28 * height + 3;
        }else{
            item10.min = 0.31 * 90;
            item10.max = 0.31 * 210;
            item10.normalMin = 0.31 * height - 3;
            item10.normalMax = 0.31 * height + 3;
        }
        [_items addObject:item10];
        
        
        YHCellItem *item7 = [YHCellItem new];
        item7.name = @"左小腿";
        item7.up = self.leftLeg.up.value ;//self.leftLeg;
        item7.value = self.leftLeg.normal.value ;
        item7.down = self.leftLeg.down.value ;
        item7.icon = [NSString stringWithFormat:@"左小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左小腿";
        item7.change = self.leftLegDiffer.normal ;
        item7.bodyParts = @"leftLeg";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item7.min = 0.17 * 90;
            item7.max = 0.17 * 210;
            item7.normalMin = 0.17 * height - 3;
            item7.normalMax = 0.17 * height + 3;
        }else{
            item7.min = 0.21 * 90;
            item7.max = 0.21 * 210;
            item7.normalMin = 0.21 * height - 3;
            item7.normalMax = 0.21 * height + 3;
        }
        [_items addObject:item7];
        
        
        YHCellItem *item9 = [YHCellItem new];
        item9.name = @"右小腿";
        item9.up = self.rightLeg.up.value;//self.rightLeg;
        item9.value = self.rightLeg.normal.value;
        item9.down = self.rightLeg.down.value;
        item9.icon = [NSString stringWithFormat:@"右小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右小腿";
        item9.change = self.rightLegDiffer.normal;
        item9.bodyParts = @"rightLeg";
        if (YHTools.sharedYHTools.masterPersion.sex) {//女
            item9.min = 0.17 * 90;
            item9.max = 0.17 * 210;
            item9.normalMin = 0.17 * height - 3;
            item9.normalMax = 0.17 * height + 3;
        }else{
            item9.min = 0.21 * 90;
            item9.max = 0.21 * 210;
            item9.normalMin = 0.21 * height - 3;
            item9.normalMax = 0.21 * height + 3;
        }
        [_items addObject:item9];
        
        
        
        
        [_items makeObjectsPerformSelector:@selector(setReportTime:) withObject:self.reportTime];
        
    }
    return _items;
}
@end
