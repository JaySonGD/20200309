//
//  YHCarDetailHeaderView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/9/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarDetailHeaderView.h"


@interface YHCarDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *examineL;

@property (weak, nonatomic) IBOutlet UILabel *reasonL;

@end

@implementation YHCarDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleL.text = @"审核状态";
}

- (void)setExamineStatusText:(NSString *)text{
    self.examineL.text = text;
}
- (void)setExamineReasonText:(NSString *)text{
    
    self.reasonL.text = text;
}

@end
