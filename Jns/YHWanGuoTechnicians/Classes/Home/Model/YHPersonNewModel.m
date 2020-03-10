//
//  YHPersonNewModel.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/5/6.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHPersonNewModel.h"
#import <MJExtension.h>

@implementation YHPersonHeaderModel

@end

@implementation YHPersonNewDetailModel



@end

@implementation YHPersonNewModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"secondMenu":[YHPersonNewDetailModel class]};
}

-(NSMutableArray<YHPersonNewModel *> *)getPersonCenterData:(NSArray *)arr{
    
    return [YHPersonNewModel mj_objectArrayWithKeyValuesArray:arr];
    
}

@end
