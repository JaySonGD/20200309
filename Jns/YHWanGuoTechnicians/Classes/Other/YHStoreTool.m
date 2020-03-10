//
//  YHStoreTool.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/24.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStoreTool.h"

static NSString * const YH_orderDetail_key = @"YH_orderDetail_key_value"; // 工单详情
static NSString * const YH_redPoint_key = @"YH_redPoint_key_value";
static NSString * const YH_orgPoints_key = @"YH_orgPoints_key_value";
static NSString * const YH_org_id_key = @"YH_org_id_key_value";
static NSString * const YH_orgPointsStatus_key = @"YH_orgPointsStatus_value";
static NSString * const YH_orgname_key = @"YH_orgname_value";
static NSString * const YH_username_key = @"YH_username_value";

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

- (void)setRedPointHideStatus:(BOOL)isHide{
    
    [[NSUserDefaults standardUserDefaults] setBool:isHide forKey:YH_redPoint_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isHideRedPoint{
   return [[NSUserDefaults standardUserDefaults] boolForKey:YH_redPoint_key];
}

- (void)setOrgPoints:(NSString *)orgPoints{
    _orgPoints = orgPoints;
    [[NSUserDefaults standardUserDefaults] setValue:orgPoints forKey:YH_orgPoints_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)orgPoints{
    if (!_orgPoints) {
        _orgPoints = [[NSUserDefaults standardUserDefaults] objectForKey:YH_orgPoints_key];
    }
    return _orgPoints;
}

- (void)setOrg_id:(NSString *)org_id{
    _org_id = org_id;
    [[NSUserDefaults standardUserDefaults] setValue:org_id forKey:YH_org_id_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)org_id{
    if (!_org_id) {
        _org_id = [[NSUserDefaults standardUserDefaults] objectForKey:YH_org_id_key];
    }
    return _org_id;
    
}

- (void)setOrgPointsStatus:(NSString *)orgPointsStatus{
    _orgPointsStatus = orgPointsStatus;
    [[NSUserDefaults standardUserDefaults] setValue:_orgPointsStatus forKey:YH_orgPointsStatus_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)orgPointsStatus{
    if (!_orgPointsStatus) {
        _orgPointsStatus = [[NSUserDefaults standardUserDefaults] objectForKey:YH_orgPointsStatus_key];
    }
    return _orgPointsStatus;
}


- (void)setOrgName:(NSString *)orgName{
    _orgName= orgName;
    [[NSUserDefaults standardUserDefaults] setValue:orgName forKey:YH_orgname_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSString *)orgName{
    
    if (!_orgName) {
        _orgName = [[NSUserDefaults standardUserDefaults] objectForKey:YH_orgname_key];
    }
    return _orgName;
}

- (void)setRealname:(NSString *)realname{

    _realname = realname;
    [[NSUserDefaults standardUserDefaults] setValue:realname forKey:YH_username_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)realname{
    if (!_realname) {
        _realname = [[NSUserDefaults standardUserDefaults] objectForKey:YH_username_key];
    }
    return _realname;
    
}

@end
