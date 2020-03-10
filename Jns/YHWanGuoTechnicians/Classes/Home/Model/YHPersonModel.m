//
//  YHPersonModel.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPersonModel.h"
#import <MJExtension.h>
#import "YHStoreTool.h"

@implementation YHPersonStationItemModel : NSObject


@end

@implementation YHPersonStationDataModel : NSObject

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[YHPersonStationItemModel class]};
}

@end

@implementation YHPersonStationInfoModel : NSObject


@end

@implementation YHPersonDetailModel


@end

@implementation YHPersonSectionModel


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[YHPersonDetailModel class]};
}

@end

@implementation YHPersonModel

- (NSMutableArray *)getPersonCenterData{
    
    NSMutableArray *itemArr = [NSMutableArray array];
    NSDictionary *modifyStationInfo = @{
                                        @"sectionTitle":@"",
                                        @"list":@[
                                                @{  @"topic":[YHStoreTool ShareStoreTool].realname,
                                                    @"detailTitle":[YHStoreTool ShareStoreTool].orgName,
                                                    @"complement":[NSString stringWithFormat:@"%.2f",[[[YHStoreTool ShareStoreTool] orgPoints] floatValue]],
                                                    @"isNext":@(YES),
                                                    @"icon":@"",
                                                    @"name_id":@"station"
                                                    }
                                                ]
                                        };
    NSDictionary *totalInfo = @{
                                        @"sectionTitle":@"统计功能",
                                        @"list":@[
                                                @{@"topic":@"预订单统计",
                                                  @"detailTitle":@"",
                                                  @"complement":@"",
                                                  @"isNext":@(YES),
                                                  @"icon":@"bookOrder",
                                                  @"name_id":@"book"
                                                  },
                                                @{@"topic":@"个人财富",
                                                  @"detailTitle":@"",
                                                  @"complement":@"",
                                                  @"isNext":@(YES),
                                                  @"icon":@"balance",
                                                  @"name_id":@"balance"
                                                  }
                                                ]
                                        };
    NSDictionary *orderInfo = @{
                                        @"sectionTitle":@"订单服务",
                                        @"list":@[
                                                @{@"topic":@"已购买报告",
                                                  @"detailTitle":@"",
                                                  @"complement":@"",
                                                  @"isNext":@(YES),
                                                  @"icon":@"purchase",
                                                  @"name_id":@"purchase"
                                                  }
                                                ]
                                        };
    NSDictionary *systemInfo = @{
                                        @"sectionTitle":@"系统设置",
                                        @"list":@[
                                                @{@"topic":@"关于JNS",
                                                  @"detailTitle":@"",
                                                  @"complement":@"",
                                                  @"isNext":@(YES),
                                                  @"icon":@"about",
                                                  @"name_id":@"about"
                                                  },
                                                @{@"topic":@"反馈建议",
                                                  @"detailTitle":@"",
                                                  @"complement":@"",
                                                  @"isNext":@(YES),
                                                  @"icon":@"feedBack",
                                                  @"name_id":@"feedBack"
                                                  }
                                                ]
                                        };
    [itemArr addObject:modifyStationInfo];
    [itemArr addObject:totalInfo];
    [itemArr addObject:orderInfo];
    [itemArr addObject:systemInfo];
    
    return [YHPersonSectionModel mj_objectArrayWithKeyValuesArray:itemArr];
}

#pragma mark - 切换站点接口(MWF)
- (void)getStationListInfoSuccess:(void (^)(NSDictionary * ))successBlock failure:(void (^)(NSError * ))errorBlock{

    [[YHNetworkPHPManager sharedYHNetworkPHPManager]newLoginUserName:[YHTools getName]
                                                            passWord:[YHTools md5:[YHTools getPassword]]
                                                              org_id:@""
                                                        confirm_bind:NO
                                                          onComplete:^(NSDictionary *info)
     {
         
//       YHPersonStationInfoModel *infoModel =  [YHPersonStationInfoModel mj_objectWithKeyValues:info];
         if (successBlock) {
             successBlock(info);
         }
     } onError:^(NSError *error) {
         if (errorBlock) {
             errorBlock(error);
         }
     }];
}

@end
