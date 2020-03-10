//
//  YHInputQualityCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/29.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHInputQualityCell.h"
#import "YHIntelligentCheckModel.h"

@interface YHInputQualityCell ()<UITextViewDelegate>

@property (nonatomic , strong) YHSchemeModel *model;

@end

@implementation YHInputQualityCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.textView.text = @"输入质保内容";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    
   
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textView.text isEqualToString:@"输入质保内容"]) {
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (!textView.text.length) {
        textView.text = @"输入质保内容";
        textView.textColor = [UIColor lightGrayColor];
        return;
    }
    
    self.model.quality_desc = textView.text;
    
    if (!self.textView.text.length) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"quality_descTextEnd" object:nil userInfo:@{@"quality_desc":self.textView.text}];
}

- (void)setCellModel:(YHSchemeModel *)cellModel{
    [super setCellModel:cellModel];
    self.model = cellModel;
    if (cellModel.quality_desc.length > 0 && ![cellModel.quality_desc isEqualToString:@"输入质保内容"]) {
        self.textView.textColor = [UIColor blackColor];
    }
    
    self.textView.text = cellModel.quality_desc;
    
    [self textViewDidChange:self.textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    //     计算 text view 的高度
//    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [self.textView.text boundingRectWithSize:CGSizeMake(bounds.size.width,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    CGFloat realHeight = ceilf(rect.size.height);
    
    CGSize newSize = [textView sizeThatFits:CGSizeMake(bounds.size.width, realHeight)];
    
    bounds.size = newSize;
    
    // 让 table view 重新计算高度
    //2.textView的高度不想等就更新 让 table view 重新计算高度
   
    
    if (bounds.size.height != self.oldTextViewBounds.size.height - 20) {
        
        UITableView *tableView = [self tableView];
        
        self.model.quality_desc = textView.text;
        
        [tableView beginUpdates];
        
        [tableView endUpdates];
    }
    
    self.oldTextViewBounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height + 20);
    
}


- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end
