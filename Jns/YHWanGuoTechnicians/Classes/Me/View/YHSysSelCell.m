//
//  YHSysSelCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSysSelCell.h"
#import "YHCommon.h"
@interface YHSysSelCell ()
@property (weak, nonatomic) IBOutlet UIView *bocView;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
@property (weak, nonatomic) IBOutlet UILabel *sysDescL;

@end

@implementation YHSysSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)data{
    NSNumber *sel = data[@"sel"];
    _sysDescL.text = data[@"title"];
    _buttonB.selected = sel.boolValue;
    if (sel.boolValue) {
        _bocView.layer.borderWidth  = 2;
        _bocView.layer.borderColor  = YHNaviColor.CGColor;
        [_buttonB setBackgroundColor:YHNaviColor];
    }else{
        _bocView.layer.borderWidth  = 2;
        _bocView.layer.borderColor  = YHLineColor.CGColor;
        [_buttonB setBackgroundColor:[UIColor clearColor]];
    }
    
}

@end
