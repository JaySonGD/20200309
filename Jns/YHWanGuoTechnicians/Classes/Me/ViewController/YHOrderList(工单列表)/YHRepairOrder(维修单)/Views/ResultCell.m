//
//  resultCell.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/9/9.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "ResultCell.h"

@implementation ResultCell

- (void)setResultStr:(NSString *)resultStr{
    
    self.resultTv.text = resultStr;
    
}

-(void)layoutSubviews{
    
    [self setRounded:self.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
    
}

@end
