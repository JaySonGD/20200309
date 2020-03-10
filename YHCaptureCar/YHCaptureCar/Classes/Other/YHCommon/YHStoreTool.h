//
//  YHStoreTool.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/24.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHStoreTool : NSObject
{
    NSArray *_orderDetailArr; // 工单详情数组
    NSDictionary *_orderInfo; // 工单信息
    NSDictionary *_temporaryData; // 缓存的所有信息
    NSArray *_repairItemList; // 选中配件搜索返回的维修项目列表
    NSMutableArray *_alreadyParts; // 设置配件耗材界面已经存在的数据
    NSMutableArray *_alreadyProjects; // 设置项目界面已经存在的数据
    NSDictionary *_newOrderInfo; // 未处理界面的进入全车工单信息
    NSDictionary *_checkValDict; // 未处理界面的进入全车工单信息
    NSMutableDictionary *_delayCareLeakOptionData; // 延保单泄露选项数据
    UIImage *_authCodeImage;  // 验证码图片
}
/**
 * 获取单例
 */
+ (YHStoreTool *)ShareStoreTool;

- (void)setOrderDetailArr:(NSArray *)orderDetailArr;
- (NSArray *)orderDetailArr;

- (void)setOrderInfo:(NSDictionary *)orderInfo;
- (NSDictionary *)orderInfo;

- (void)setNewOrderInfo:(NSDictionary *)newOrderInfo;
- (NSDictionary *)newOrderInfo;

- (void)setTemporaryData:(NSDictionary *)temporaryData;
- (NSDictionary *)temporaryData;

- (void)setRepairItemList:(NSArray *)repairItemList;
- (NSArray *)repairItemList;

- (void)setAlreadyParts:(NSMutableArray *)alreadyParts;
- (NSMutableArray *)alreadyParts;

- (void)setAlreadyProjects:(NSMutableArray *)alreadyProjects;
- (NSMutableArray *)alreadyProjects;

- (void)setDelayCareLeakOptionData:(NSMutableDictionary *)delayCareLeakOptionData;
- (NSMutableDictionary *)delayCareLeakOptionData;

- (void)setAuthCodeImage:(UIImage *)authCodeImage;
- (UIImage *)authCodeImage;

@end
