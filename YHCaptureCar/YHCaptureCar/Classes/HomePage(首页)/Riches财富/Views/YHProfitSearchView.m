//
//  YHProfitSearchView.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHProfitSearchView.h"


@interface YHProfitSearchView ()

@property (weak, nonatomic) IBOutlet UILabel *filtrateL;
/** 起始时间 */
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
/** 中止时间 */
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
/** 起始时间点击监听按钮 */
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
/** 结束时间点击监听按钮 */
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
/** 查询按钮 */
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;

@end

@implementation YHProfitSearchView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.startBtn addTarget:self action:@selector(clickStartTimeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.endTimeBtn addTarget:self action:@selector(clickEndTimeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.queryBtn addTarget:self action:@selector(clickQueryBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    _selectTimeType = YHProfitSearchViewSelectTimeNone;
    
}
- (void)clickStartTimeEvent{
    
    if (_clickStartTimeBlock) {
        _clickStartTimeBlock();
    }
    _selectTimeType = YHProfitSearchViewSelectTimeStart;
}
- (void)clickEndTimeEvent{
    
    if (_clickEndTimeBlock) {
        _clickEndTimeBlock();
    }
    _selectTimeType = YHProfitSearchViewSelectTimeEnd;
}
- (void)clickQueryBtnEvent{
    
    if (_clickQueryBtnBlock) {
        _clickQueryBtnBlock();
    }
}
- (void)setStartTimeLabelText:(NSString *)text{
    
    self.startTimeL.text = text;
}
- (void)setEndTimeLableText:(NSString *)text{
    self.endTimeL.text = text;
}
- (NSString *)getStartTimeText{
    
    return self.startTimeL.text;
}
- (NSString *)getEndTimeText{
    return self.endTimeL.text;
}
- (NSDate *)getStartDate{
    return [self dateFromString:self.startTimeL.text];
}
- (NSDate *)getEndDate{
    
    return [self dateFromString:self.endTimeL.text];
}
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    return [dateFormatter dateFromString:dateString];
}
@end
