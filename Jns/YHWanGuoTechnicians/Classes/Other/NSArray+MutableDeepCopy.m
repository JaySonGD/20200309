//
//  NSArray+MutableDeepCopy.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/5/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "NSArray+MutableDeepCopy.h"

@implementation NSArray (MutableDeepCopy)

-(NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *ar=[[NSMutableArray alloc] initWithCapacity:self.count];
    //新建一个NSMutableDictionary对象，大小为原NSDictionary对象的大小
    for(id value in self)
    {//循环读取复制每一个元素
        id copyValue;
        if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
            //如果key对应的元素可以响应mutableDeepCopy方法(还是NSDictionary)，调用mutableDeepCopy方法复制
            copyValue=[value mutableDeepCopy];
        }else if([value respondsToSelector:@selector(mutableCopy)] && ![value isKindOfClass:[NSNumber class]])
        {
            copyValue=[value mutableCopy];
        }
        if(copyValue==nil)
            copyValue=[value copy];
        [ar addObject:copyValue];
    }
    return ar;
}
@end
