//
//  YHStoreTool.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/24.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStoreTool.h"

static const NSString *YH_orderDetail_key = @"YH_orderDetail_key_value"; // 工单详情


static YHStoreTool *storeTool_;
@implementation YHStoreTool

+ (YHStoreTool *)ShareStoreTool{
    
    if (!storeTool_) {
        storeTool_ = [[YHStoreTool alloc] init];
    }
    return storeTool_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeTool_ = [super allocWithZone:zone];
    });
    return storeTool_;
}

-(id) copyWithZone:(NSZone *)zone{
    return [YHStoreTool ShareStoreTool] ;
}

-(id) mutablecopyWithZone:(NSZone *)zone{
    return [YHStoreTool ShareStoreTool] ;
}

- (void)setOrderDetailArr:(NSArray *)orderDetailArr{
    _orderDetailArr = orderDetailArr;
}

- (NSArray *)orderDetailArr{
    return _orderDetailArr;
}

- (void)setOrderInfo:(NSDictionary *)orderInfo{
    _orderInfo = orderInfo;
}
- (NSDictionary *)orderInfo{
    return _orderInfo;
}
- (void)setNewOrderInfo:(NSDictionary *)newOrderInfo{
    _newOrderInfo = newOrderInfo;
}
- (NSDictionary *)newOrderInfo{
    return _newOrderInfo;
}
- (void)setTemporaryData:(NSDictionary *)temporaryData{
    _temporaryData = temporaryData;
    
}
- (NSDictionary *)temporaryData{
    return _temporaryData;
}

- (void)setRepairItemList:(NSArray *)repairItemList{
    _repairItemList = repairItemList;
}
- (NSArray *)repairItemList{
    return _repairItemList;
}

- (void)setAlreadyParts:(NSMutableArray *)alreadyParts{
    _alreadyParts = alreadyParts;
}
- (NSMutableArray *)alreadyParts{
    
    return _alreadyParts;
}

- (void)setAlreadyProjects:(NSMutableArray *)alreadyProjects{
    _alreadyProjects = alreadyProjects;
}
- (NSMutableArray *)alreadyProjects{
    return _alreadyProjects;
}
- (void)setDelayCareLeakOptionData:(NSMutableDictionary *)delayCareLeakOptionData{
    _delayCareLeakOptionData = delayCareLeakOptionData;
    
}
- (NSMutableDictionary *)delayCareLeakOptionData{
    if (!_delayCareLeakOptionData) {
        _delayCareLeakOptionData = [NSMutableDictionary dictionary];
    }
    return _delayCareLeakOptionData;
}

- (void)setAuthCodeImage:(UIImage *)authCodeImage{
    _authCodeImage = authCodeImage;
}
- (UIImage *)authCodeImage{
    return _authCodeImage;
}
@end
