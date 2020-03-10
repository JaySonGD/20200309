//
//  YHDetailDepthCell.m
//  YHWanGuoTechnicians
//

//  Created by Liangtao Yu on 2019/10/16.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHDetailDepthCell.h"

@interface YHDetailDepthCell()

@property (weak, nonatomic) IBOutlet UILabel *Name;

@property (weak, nonatomic) IBOutlet UILabel *SubName;


@end

@implementation YHDetailDepthCell

- (void)setNameStr:(NSString *)nameStr{
    
    self.Name.text = nameStr;
}

-(void)setSubNameStr:(NSString *)subNameStr{
    
    self.SubName.text = subNameStr;
}

-(void)setIsLast:(BOOL)isLast{
    
    if(!isLast)return;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 43, self.contentView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:232/255.9 green:232/255.0 blue:232/255.0 alpha:1];
    [self.contentView addSubview:line];
    
}

@end
