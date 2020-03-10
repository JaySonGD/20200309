//
//  YHModelItem.m
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHModelItem.h"
#import "YHTools.h"
#import "PCPersonModel.h"

@implementation YHCellItem

@end


@implementation YHModelItem
- (NSMutableArray<YHCellItem *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
        

        YHCellItem *item4 = [YHCellItem new];
        item4.name = @"胸围";
        item4.value = self.bust;
        item4.icon = [NSString stringWithFormat:@"胸_%d",YHTools.sharedYHTools.masterPersion.sex];
        item4.bodyParts = @"bust";
        
        [_items addObject:item4];
        
        YHCellItem *item = [YHCellItem new];
        item.name = @"左上臂";
        item.value = self.leftUpperArm;
        item.icon = [NSString stringWithFormat:@"左臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item.bodyParts = @"leftUpperArm";
        
        [_items addObject:item];
        
        YHCellItem *item1 = [YHCellItem new];
        item1.name = @"右上臂";
        item1.value = self.rightUpperArm;
        item1.icon = [NSString stringWithFormat:@"右臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item1.bodyParts = @"rightUpperArm";
        
        [_items addObject:item1];
        
        YHCellItem *item6 = [YHCellItem new];
        item6.name = @"腰围";
        item6.value = self.waist;
        item6.icon = [NSString stringWithFormat:@"腰_%d",YHTools.sharedYHTools.masterPersion.sex];//@"腰";
        item6.bodyParts = @"waist";
        
        [_items addObject:item6];
        
        
        YHCellItem *item5 = [YHCellItem new];
        item5.name = @"臀围";
        item5.value = self.hipline;
        item5.icon = [NSString stringWithFormat:@"臀_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item5.bodyParts = @"hipline";
        
        [_items addObject:item5];


        YHCellItem *item8 = [YHCellItem new];
        item8.name = @"左大腿";
        item8.value = self.leftThigh;
        item8.icon = [NSString stringWithFormat:@"左大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左大腿";
        item8.bodyParts = @"leftThigh";
        
        [_items addObject:item8];
        
        
        YHCellItem *item10 = [YHCellItem new];
        item10.name = @"右大腿";
        item10.value = self.rightThigh;
        item10.icon = [NSString stringWithFormat:@"右大腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右大腿";

        item10.bodyParts = @"rightThigh";
        
        [_items addObject:item10];


        
        YHCellItem *item11 = [YHCellItem new];
        item11.name = @"肩宽";
        item11.value = self.shoulder;
        item11.icon = [NSString stringWithFormat:@"肩_%d",YHTools.sharedYHTools.masterPersion.sex];//@"肩";
        item11.bodyParts = @"shoulder";

        [_items addObject:item11];

        
        
        YHCellItem *item9 = [YHCellItem new];
        item9.name = @"右小腿";
        item9.value = self.rightLeg;
        item9.icon = [NSString stringWithFormat:@"右小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"右小腿";
        item9.bodyParts = @"rightLeg";

        [_items addObject:item9];

        

        
        YHCellItem *item7 = [YHCellItem new];
        item7.name = @"左小腿";
        item7.value = self.leftLeg;
        item7.icon = [NSString stringWithFormat:@"左小腿_%d",YHTools.sharedYHTools.masterPersion.sex];//@"左小腿";
        item7.bodyParts = @"leftLeg";

        [_items addObject:item7];

        

        

        YHCellItem *item2 = [YHCellItem new];
        item2.name = @"左下臂";
        item2.value = self.leftLowerArm;
        item2.icon = [NSString stringWithFormat:@"左小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item2.bodyParts = @"leftLowerArm";

        [_items addObject:item2];
        
        YHCellItem *item3 = [YHCellItem new];
        item3.name = @"右下臂";
        item3.value = self.rightLowerArm;
        item3.icon = [NSString stringWithFormat:@"右小臂_%d",YHTools.sharedYHTools.masterPersion.sex];//@"臀";
        item3.bodyParts = @"rightLowerArm";

        [_items addObject:item3];




        
    }
    return _items;
}
@end

