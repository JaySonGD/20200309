//
//  YTPointsDealModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YTPriceModel : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *name;

@end

@interface YTPointsDealModel : NSObject

@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *org_name;
//@property (nonatomic, strong) NSArray <NSString *> *price_list;
//@property (nonatomic, strong) NSMutableArray <YTPriceModel *> *list;

@property (nonatomic, strong) NSMutableArray <YTPriceModel *> *price_list;

@end



@interface YTPointsDealListModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *deal_name;
@property (nonatomic, copy) NSString *create_user_name;
@property (nonatomic, assign) NSInteger deal_sort;//交易分类: 0-其他,1-充值,2-消费

@property (nonatomic, copy) NSString *deal_points;
@property (nonatomic, copy) NSString *create_time;

@end

@interface YTPointsDealDetailModel : YTPointsDealListModel

@property (nonatomic, copy) NSString *order_number;

@property (nonatomic, copy) NSString *pay_amount;
@property (nonatomic, copy) NSString *deal_time;
@property (nonatomic, copy) NSString *deal_way;

@end


NS_ASSUME_NONNULL_END
