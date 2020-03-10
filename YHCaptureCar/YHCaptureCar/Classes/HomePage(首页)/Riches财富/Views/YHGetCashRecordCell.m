//
//  YHGetCashRecordCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHGetCashRecordCell.h"

@interface YHGetCashRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *applyCashStatusL;

@property (weak, nonatomic) IBOutlet UILabel *applyCashNumberL;

@property (weak, nonatomic) IBOutlet UILabel *applyCashDateL;
@property (weak, nonatomic) IBOutlet UILabel *commentContentL;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleL;

@end

@implementation YHGetCashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}
- (void)setInfo:(NSDictionary *)info{
    
    _info = info;
    self.applyCashDateL.text = info[@"withDrawTime"];
    self.applyCashNumberL.text = [NSString stringWithFormat:@"￥ %.2f",[info[@"amount"] floatValue]];
    self.commentContentL.text = info[@"comment"];
    // 申请中
    if ([info[@"status"] isEqualToString:@"0"]) {
        self.applyCashStatusL.text = @"申请中";
        self.applyCashStatusL.textColor = [UIColor colorWithRed:43.0/255.0 green:167.0/255.0 blue:42.0/255.0 alpha:1.0];
    }
    // 成功
    if ([info[@"status"] isEqualToString:@"1"]) {
        self.applyCashStatusL.text = @"成功";
         self.applyCashStatusL.textColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];
    }
    // 失败
    if ([info[@"status"] isEqualToString:@"2"]) {
        self.applyCashStatusL.text = @"失败";
        self.applyCashStatusL.textColor = [UIColor colorWithRed:227.0/255.0 green:94.0/255.0 blue:69.0/255.0 alpha:1.0];
    }
    
    self.commentContentL.hidden = [info[@"status"] isEqualToString:@"2"] ? NO : YES;
    self.commentTitleL.hidden = self.commentContentL.hidden;
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
    
}

@end
