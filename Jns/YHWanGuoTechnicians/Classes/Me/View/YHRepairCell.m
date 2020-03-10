//
//  YHRepairCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/6/30.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairCell.h"
#import "YHCommon.h"
@interface YHRepairCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end
@implementation YHRepairCell

- (void)loadData:(NSString*)str isSel:(BOOL)isSel{
    _nameL.text = str;
    _nameL.textColor = ((isSel)? (YHNaviColor) : (YHCellColor));
    self.backgroundColor = ((isSel)? ([UIColor whiteColor]) : (YHLineColor));
}
@end
