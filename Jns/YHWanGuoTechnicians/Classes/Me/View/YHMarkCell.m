//
//  YHMarkCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/8/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHMarkCell.h"
#import "YHCommon.h"
@interface YHMarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UIImageView *iconIG;
@property (weak, nonatomic) IBOutlet UILabel *lineTopL;
@property (weak, nonatomic) IBOutlet UILabel *lineBottomL;

@end

@implementation YHMarkCell

- (void)loadDatasource:(NSString*)info state:(YHMark)state{
    
    if (state == YHMarkCurrent) {
        [_iconIG setImage:[UIImage imageNamed:@"mark1"]];
        [_dateL setTextColor:YHNaviColor];
        [_timeL setTextColor:YHNaviColor];
        [_descL setTextColor:YHNaviColor];
        _lineTopL.hidden = YES;
        _lineBottomL.hidden = NO;
        [_lineBottomL setBackgroundColor:YHNaviColor];
    }else if (state == YHMarkPreviousStepTwo) {
        [_iconIG setImage:[UIImage imageNamed:@"mark2"]];
        [_dateL setTextColor:YHCellColor];
        [_timeL setTextColor:YHCellColor];
        [_descL setTextColor:YHCellColor];
        _lineTopL.hidden = NO;
        _lineBottomL.hidden = NO;
        [_lineTopL setBackgroundColor:YHNaviColor];
        [_lineBottomL setBackgroundColor:YHCellColor];
    }else if (state == YHMarkPreviousStep) {
        [_iconIG setImage:[UIImage imageNamed:@"mark2"]];
        [_dateL setTextColor:YHCellColor];
        [_timeL setTextColor:YHCellColor];
        [_descL setTextColor:YHCellColor];
        _lineTopL.hidden = NO;
        _lineBottomL.hidden = NO;
        [_lineTopL setBackgroundColor:YHCellColor];
        [_lineBottomL setBackgroundColor:YHCellColor];
    }else {
        [_iconIG setImage:[UIImage imageNamed:@"mark3"]];
        [_dateL setTextColor:YHCellColor];
        [_timeL setTextColor:YHCellColor];
        [_descL setTextColor:YHCellColor];
        _lineTopL.hidden = NO;
        _lineBottomL.hidden = YES;
        [_lineTopL setBackgroundColor:YHCellColor];
    }
    _dateL.text = [info substringWithRange:NSMakeRange(0,10)];
    _timeL.text = [info substringWithRange:NSMakeRange(10,9)];
    _descL.text = [info substringWithRange:NSMakeRange(19,info.length - 19)];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
