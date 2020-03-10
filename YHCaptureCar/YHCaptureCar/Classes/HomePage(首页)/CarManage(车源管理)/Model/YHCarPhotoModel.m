//
//  YHCarPhotoModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarPhotoModel.h"


#import <MJExtension.h>

@implementation YHPhotoModel

@end

@implementation YHCarPhotoModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pic":[YHPhotoModel class]};
}



@end

@implementation YHPhotoDBModel
- (NSMutableArray<NSString *> *)others
{
    if (!_others) {
        _others = [NSMutableArray array];
    }else if (![_others isKindOfClass:[NSMutableArray class]]){
        _others = [_others mutableCopy];
    }
    
    return _others;
}


+ (NSArray *)uniqueKeys
{
    return @[@"mid"];
}
@end
