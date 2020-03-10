//
//  NSMutableArray+YH.m
//  
//
//  Created by Zhu Wensheng on 2017/8/24.
//
//

#import "NSMutableArray+YH.h"

@implementation NSMutableArray (YH)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    
    if (toIndex != fromIndex && fromIndex < [self count] && toIndex< [self count]) {
        id obj = [self objectAtIndex:fromIndex];
        [obj retain];
        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:toIndex];
        }
        [obj release];
    }
}


@end
