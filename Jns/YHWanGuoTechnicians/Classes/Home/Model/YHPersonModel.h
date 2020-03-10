//
//  YHPersonModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPersonStationItemModel : NSObject

@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *url_code;
@property (nonatomic, copy) NSString *xhjc_booking_num;

@end

@interface YHPersonStationDataModel : NSObject

@property (nonatomic, strong) NSMutableArray <YHPersonStationItemModel *> *list;

@end

@interface YHPersonStationInfoModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) YHPersonStationDataModel *data;

@end

@interface YHPersonDetailModel : NSObject

@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) NSString *complement;
@property (nonatomic, assign) BOOL isNext;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name_id;

@end

@interface YHPersonSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, strong)NSMutableArray <YHPersonDetailModel *> *list;

@end



@interface YHPersonModel : NSObject

- (NSMutableArray <YHPersonSectionModel *>*)getPersonCenterData;

- (void)getStationListInfoSuccess:(void(^)(NSDictionary *info))successBlock failure:(void(^)(NSError *error))errorBlock;

@end

NS_ASSUME_NONNULL_END
