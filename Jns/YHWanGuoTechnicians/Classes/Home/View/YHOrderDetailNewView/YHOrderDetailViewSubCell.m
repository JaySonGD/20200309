//
//  YHOrderDetailViewSubCell.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/10.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailViewSubCell.h"


@interface YHOrderDetailViewSubCell()

@property (nonatomic, strong) UIView *resultV;
@property (nonatomic, strong) UILabel *resultLb;

@end

@implementation YHOrderDetailViewSubCell


-(instancetype)init{
    
    if(self = [super init]){
        
        self.resultV = [[UIView alloc]init];
        [self.contentView addSubview:self.resultV];
        
        self.resultLb = [[UILabel alloc]init];
        self.resultLb.textColor = [UIColor colorWithHexString:@"0x838383"];
        self.resultLb.font = [UIFont systemFontOfSize:14.5];
        self.resultLb.numberOfLines = 0;
        [self.contentView addSubview:self.resultLb];
        
        [self.resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.resultV.mas_right).offset(15);
               make.top.equalTo(@6);
               make.right.equalTo(@-18);
               make.bottom.equalTo(@-6);
           }];
        
        
        [self.resultV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@18);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            make.top.equalTo(self.resultLb).offset(1.5);
        }];
        
    }
    
    return self;
}

-(void)setResultStr:(NSString *)resultStr{
    
     self.resultLb.text = resultStr;
   
}

-(void)setStatus:(NSString *)status{
    
     //  F9BC2D  FF8B3E FB3537
    
    NSString *str = [status isEqualToString:@"0"] ? @"F9BC2D" :  [status isEqualToString:@"2"] ? @"FF8B3E" : @"FB3537";
    
     self.resultV.backgroundColor = [UIColor colorWithHexString:str];
}

@end
