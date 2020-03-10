//
//  YHQualityTableViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHQualityTableViewCell.h"

@interface YHQualityTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountLW;

@end

@implementation YHQualityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.requireSideShowBtn.userInteractionEnabled = NO;
    self.requireSideShowBtn.hidden = YES;
    
    self.amountL.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditEnd:) name:UITextFieldTextDidEndEditingNotification object:self.amountL];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.amountL];
}

- (void)textEditEnd:(NSNotification *)noti{
    
    UITextField *obj = (UITextField *)noti.object;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:obj.text forKey:@"textContent"];
    [dict setValue:self.indexPath forKey:@"indexPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textChangeWriteData" object:nil userInfo:dict];
}

- (void)textChange:(NSNotification *)noti{
    UITextField *obj = (UITextField *)noti.object;
    
    CGFloat amountW = [obj.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    if (amountW >= 150) {
        amountW = 150;
    }
    if (amountW > 40) {
        self.amountLW.constant = amountW + 20;
    }

}

- (void)setIs4s:(BOOL)is4s{
    [super setIs4s:is4s];
    if (self.is4s) {
        
        self.itemNameL.text = @"4S店维修参考价";
        self.unitL.text = @"元";
    }
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    [super setIndexPath:indexPath];
    
    if (self.is4s) {
        
        self.itemNameL.text = @"4S店维修参考价";
        self.unitL.text = @"元";
        return;
    }
    
    if (self.isNOCanEdit) {
        self.itemNameL.text = @"质保内容";
        return;
    }
    
    if (indexPath.row == 0) {
        self.itemNameL.text = @"质保时长";
        self.unitL.text = @"个月";
    }else {
        self.itemNameL.text = @"质保公里";
        self.unitL.text = @"公里";
    }
}
- (void)setCellModel:(NSMutableDictionary *)cellModel{
    
    if (self.isNOCanEdit && !self.is4s) {
        NSString *textResult = !cellModel[@"text"] || [cellModel[@"text"] isKindOfClass:[NSNull class]]? @"" :cellModel[@"text"];
         self.contentL.text = textResult;
        textResult = ![textResult isEqualToString:@"无质保"] ? [NSString stringWithFormat:@"由JNS·PICC提供%@质保",textResult] : @" 无质保";
        [self.requireSideShowBtn setTitle:textResult forState:UIControlStateNormal];
        return;
    }
    
    if (self.indexPath.row == 0) {
        self.amountL.text = !cellModel[@"quality_time"] || [cellModel[@"quality_time"] isKindOfClass:[NSNull class]]? @"" :cellModel[@"quality_time"];
    }else{
        self.amountL.text = !cellModel[@"quality_km"] || [cellModel[@"quality_km"] isKindOfClass:[NSNull class]]? @"" :cellModel[@"quality_km"];
    }
    
    if (self.is4s) {
        self.amountL.text = [cellModel[@"quality_time"] floatValue] == 0 ? @"" : cellModel[@"quality_time"];
    }
    
   CGFloat amountW = [self.amountL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    
    if (amountW >= 150) {
        amountW = 150;
    }
    
    if (amountW > 40) {
        self.amountLW.constant = amountW + 20;
    }
}

- (void)setIsNOCanEdit:(BOOL)isNOCanEdit{
    [super setIsNOCanEdit:isNOCanEdit];

    if (isNOCanEdit) {
        
        self.containView.hidden = YES;
        if (self.isTechOrg) { // 是技术方
            self.itemNameL.hidden = NO;
            self.contentL.hidden = NO;
            self.requireSideShowBtn.hidden = YES;
        }else{
            self.itemNameL.hidden = YES;
            self.contentL.hidden = YES;
            self.requireSideShowBtn.hidden = NO;
        }
        
    }else{
        // 可编辑
        self.contentL.hidden = YES;
        self.containView.hidden = NO;
        self.itemNameL.hidden = NO;
        self.requireSideShowBtn.hidden = YES;
    }
}

@end
