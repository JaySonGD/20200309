//
//  YHOrderTypeCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/9/11.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderTypeCell.h"
#import "YHCommon.h"
@interface YHOrderTypeCell ()

@property (weak, nonatomic) IBOutlet UIView *boXView;
@property (weak, nonatomic) IBOutlet UILabel *typeStrL;

@end
@implementation YHOrderTypeCell
-(void)loadInfo:(NSString*)typeStr{
    _typeStrL.text = typeStr;
    _boXView.hidden = !typeStr.length;
    _boXView.layer.borderWidth  = 1;
    _boXView.layer.borderColor  = YHLineColor.CGColor;
}
@end
