//
//  YHPassWordTextField.m
//  YHCaptureCar
//
//  Created by liusong on 2018/6/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPassWordTextField.h"

@implementation YHPassWordTextField

- (instancetype)init{
    if (self = [super init]) {
        self.secureTextEntry = YES;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds{

 return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{

 return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds{

 return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
 return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}

@end
