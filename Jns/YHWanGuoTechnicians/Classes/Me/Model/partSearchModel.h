//
//  partSearchModel.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/6/17.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface partSearchModel : NSObject

//配件/耗材
@property (nonatomic,copy)NSString *full_name;//全名
@property (nonatomic,copy)NSString *name;//"配件"
@property (nonatomic,assign)int type;//类别  1-配件 2-耗材
@property (nonatomic,copy)NSString *type_name;//类别名称
@property (nonatomic,copy)NSString *brand;//"配件品牌
@property (nonatomic,copy)NSString *model_number;//型号
@property (nonatomic,copy)NSString *specification;//规格
@property (nonatomic,copy)NSString *unit;//单位
@property (nonatomic,copy)NSString *price;////价格
@property (nonatomic,assign)int parts_type_id;//配件类别标识ID
@property (nonatomic,copy)NSString *parts_type_name;//配件类别标识名称

//维修项目
@property (nonatomic,copy)NSString *item_price;//价格
@property (nonatomic,copy)NSString *item_name;//名称



@end

NS_ASSUME_NONNULL_END
