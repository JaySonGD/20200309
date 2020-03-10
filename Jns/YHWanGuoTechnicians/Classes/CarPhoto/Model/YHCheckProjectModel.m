//
//  YHCheckProjectModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckProjectModel.h"

#import "TTZDBModel.h"

#import "NSObject+BGModel.h"

@implementation YHlistModel

@end

@implementation YHIntervalRangeModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[YHlistModel class]};
}
//    + (NSDictionary *)mj_replacedKeyFromPropertyName
//    {
//        return @{@"max":@[@"max",@"maxNumber"]};
//    }

@end

@implementation YHProjectListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}
- (NSMutableArray<UIImage *> *)images
{
    if(!_images){
        _images = [NSMutableArray array];
        
        // [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",_billId,_code]];
        
        [_images addObject:[UIImage imageNamed:@"otherAdd"]];
    }
    return _images;
}
- (NSMutableArray *)dbImages
{
    if (!_dbImages) {
        _dbImages = [NSMutableArray array];
        NSArray <TTZDBModel *> *dbImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,self.Id]];
        if (dbImages.count) {
            [_dbImages addObjectsFromArray:dbImages];
            if(dbImages.count <5){
                TTZDBModel *defaultModel = [TTZDBModel new];
                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                [_dbImages addObject:defaultModel];
            }
        }else{
            TTZDBModel *defaultModel = [TTZDBModel new];
            defaultModel.image = [UIImage imageNamed:@"otherAdd"];
            [_dbImages addObject:defaultModel];
        }
    }
    return _dbImages;
}

- (void)cleanDBImages
{
    [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,self.Id]];
    [self.dbImages removeAllObjects];
    self.dbImages = nil;
}

@end
@implementation YHProjectListGroundModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"projectList":[YHProjectListModel class]};
}

@end

@implementation YHSurveyCheckProjectModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"projectList":[YHProjectListGroundModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

@end

