//
//  YTPointsDealModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTPointsDealModel.h"
#import <MJExtension.h>

@implementation YTPriceModel

@end

@implementation YTPointsDealModel
//- (void)setPrice_list:(NSArray<NSString *> *)price_list{
//    _price_list = price_list;
//    _list = [NSMutableArray array];
//    [price_list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        YTPriceModel *model = [YTPriceModel new];
//        model.price = obj;
//        [_list addObject:model];
//    }];
//}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"price_list":[YTPriceModel class]};
}

@end

@implementation YTPointsDealListModel

@end




@implementation YTPointsDealDetailModel

@end

