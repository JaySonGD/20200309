//
//  YHPlanCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/19.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHPlanCell.h"
#import "YHCommon.h"
@interface YHPlanCell ()

@property (weak, nonatomic) IBOutlet UILabel *planL;
@end
@implementation YHPlanCell
- (void)loadDatasource:(NSString*)planStr isSel:(BOOL)isSel{
    _planL.layer.borderWidth  = 1;
    _planL.layer.borderColor  = YHCellColor.CGColor;
    if (isSel) {
        [_planL setTextColor:[UIColor whiteColor]];
        [_planL setBackgroundColor:YHNaviColor];
    }else{
        [_planL setTextColor:YHCellColor];
        [_planL setBackgroundColor:[UIColor whiteColor]];
    }
    _planL.text = planStr;
}
@end
