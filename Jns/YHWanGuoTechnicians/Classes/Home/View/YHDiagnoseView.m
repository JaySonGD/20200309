//
//  YHDiagnoseView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnoseView.h"

@implementation YHDiagnoseView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.diagnoseTextView.editable = NO;
    self.diagnoseTitieL.font = [UIFont boldSystemFontOfSize:18.0];
}

- (void)setCellModel:(NSString *)cellModel{
    
    cellModel = [cellModel stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    NSLog(@"---------hh%@",cellModel);
    self.diagnoseTextView.text = cellModel;
    NSLog(@"---------------ggg%@",self.diagnoseTextView.text);
}

- (IBAction)edit:(UIButton *)sender {
    
    if(self.editBlock){
        self.editBlock();
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.edutBtn.hidden = !self.editBlock;
    
    if ([self.orderType isEqualToString:@"J004"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.customView setRounded:self.customView.bounds corners:UIRectCornerAllCorners radius:8.0];
        });
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRounded:self.bounds corners:UIRectCornerAllCorners radius:8.0];
        });
    }
}

@end
