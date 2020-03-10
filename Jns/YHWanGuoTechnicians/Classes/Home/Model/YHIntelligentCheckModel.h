//
//  YHIntelligentCheckModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/8.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTPlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface  TutorialListModel : NSObject

@property (nonatomic, strong) NSString *parts_suggestion_id;//"配置建议id"

@property (nonatomic, strong) NSString *title;//电路图

@property (nonatomic, strong) NSString *code;// circuit-电路图,reset_tutorial-复位教程,oil-机油,gearbox_oil-波箱油,cell-电池,antifreeze-防冻液

@property (nonatomic, strong) NSString *pay_status;//购买状态：1-已购买，0-未购买

@property (nonatomic, strong) NSString *show_type;// 类型：1-列表，2-跳转查看

@property (nonatomic, strong) NSArray *list;//?

@end


@interface YHCheckResultArrModel : NSObject

@property (nonatomic, strong) NSString *makeResult;

@property (nonatomic, strong) NSString *makeIdea;//hz诊断思路

@end

@interface YHBaseInfoModel : NSObject

@property (nonatomic, strong) NSString *car_icon;
@property (nonatomic, strong) NSString *car_brand_name;
@property (nonatomic, strong) NSString *car_line_name;
@property (nonatomic, strong) NSString *car_cc;
@property (nonatomic, strong) NSString *car_cc_unit;
@property (nonatomic, strong) NSString *nian_kuan;
@property (nonatomic, strong) NSString *gearbox_type;
@property (nonatomic, strong) NSString *car_model_full_name;
@property (nonatomic, strong) NSString *vin;

@end

@interface YHLPCModel : YHLPCModel1

//@property (nonatomic, strong) NSString *status;
//@property (nonatomic, strong) NSString *suggested_status;// 有无建议信息：1-有，0无
//@property (nonatomic, strong) NSMutableDictionary *suggested_info;

@end


@interface YHLaborModel : NSObject//维修项目

@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *labor_name;
@property (nonatomic, strong) NSString *labor_price;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *labor_time;//工时

@end

@interface YHPartsModel : YHLPCModel//配件

@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *part_name;
@property (nonatomic, strong) NSString *part_price;
@property (nonatomic, strong) NSString *part_count;
@property (nonatomic, strong) NSString *part_unit;
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *part_type;
@property (nonatomic, strong) NSString *part_type_name;
@property (nonatomic, strong) NSString *part_brand;
@end

@interface YHConsumableModel : YHLPCModel

@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *consumable_name;
@property (nonatomic, strong) NSString *consumable_price;
@property (nonatomic, strong) NSString *consumable_count;
@property (nonatomic, strong) NSString *consumable_unit;
@property (nonatomic, strong) NSString *consumable_standard;//规格
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *consumable_brand;
/*
 "consumable_name":"机油", // 耗材名字
 "consumable_standard":"5w-40", // 耗材规格
 "consumable_unit":"升", // 耗材单位
 "consumable_count":"1", // 耗材数量
 "consumable_brand":"品牌",
 "consumable_price":"600.00", // 耗材单价
 "status":1, // 1-正常,2-免费赠送
 "subtotal": "888.00" //耗材小计
 "suggested_status":1,
 "suggested_info": {
 "parts_suggestion_id": "配件耗材配置建议id",
 "title": "机油配置建议",
 "pay_status": "0", //购买状态：1-已购买，0-未购买
 "list": [
 "name": "机油型号",
 "value": "*"
 ]
 }
 */

@end

@interface YHSchemeModel : NSObject

@property (nonatomic, strong) NSMutableArray <YHLaborModel *>*labor;
@property (nonatomic, strong) NSMutableArray <YHPartsModel *>*parts;
@property (nonatomic, strong) NSMutableArray <YHConsumableModel *>*consumable;
@property (nonatomic, strong) NSString *quality_time;
@property (nonatomic, strong) NSString *quality_km;
@property (nonatomic, strong) NSString *quality_desc;
@property (nonatomic, strong) NSString *price_ssss;
@property (nonatomic, strong) NSString *parts_total;
@property (nonatomic, strong) NSString *consumable_total;
@property (nonatomic, strong) NSString *labor_total;
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *labor_time_total;//汽车安检工单总计
@property (nonatomic, strong) NSString *name;
/** 是否系统类型：1-系统, 0-本地 */
@property (nonatomic, assign) NSInteger is_sys;
@property (nonatomic, strong) NSString *repairCaseId;
@property (nonatomic, assign) BOOL isOnlyOne;

@end

@interface YHReportModel : NSObject

@property (nonatomic, strong) YHCheckResultArrModel *checkResultArr;
@property (nonatomic, strong) NSMutableArray <YHSchemeModel *>*maintain_scheme;
@property (nonatomic, strong) YHBaseInfoModel *base_info;
@property (nonatomic, strong) YTBaseInfo *baseInfo;
/**操作状态：detail-不操作只看详情, handle-可操作 */
@property (nonatomic, copy) NSString *handleType;
/**close:关闭;进行中:underway;complete:工单完成  已支付(工单已完成)页面：billStatus 等于 complete*/
@property (nonatomic, copy) NSString *billStatus;

//"reportStatus":"1", // 报告生成状态 0：维修方式未生成，1：维修方式已生成
@property (nonatomic, copy) NSString *reportStatus;

@property (nonatomic, copy) NSString *reportEditStatus;// 报告是否可编辑状态 0：不可编辑(跳支付页)，1：可编辑维修方案，2：可编辑维修方案、诊断结果和诊断思路
/**
 编辑方案和派工页面：nextStatusCode 等于 initialSurveyCompletion
 方案选择页面：nextStatusCode 等于 affirmMode
 方案待支付页面：nextStatusCode 等于 storeBuyMaintainScheme
 点击已完工页面：nextStatusCode 等于 affirmComplete
 */

@property (nonatomic, copy) NSString *m_item_edit_status;//0已经进行了一步  1未开始
//
//编辑方案和派工页面：nextStatusCode 等于 initialSurveyCompletion
//方案选择页面：nextStatusCode 等于 affirmMode
//方案待支付页面：nowStatusCode 等于 affirmMode && nextStatusCode 等于 空字符串
//点击已完工页面：nextStatusCode 等于 affirmComplete

@property (nonatomic, copy) NSString *nextStatusCode;

@property (nonatomic, copy) NSString *nowStatusCode;

/** 工单状态描述 */
@property (nonatomic, copy) NSString *billStatusMsg;
/** 客户选择的维修方案id,空是未选 */
@property (nonatomic, copy) NSString *ownerRepairModeId;
/** 店铺选择的维修方案id,空是未选 */
@property (nonatomic, copy) NSString *selectiveRepairModeId;


@property (nonatomic, copy) NSString *billId;
//@property (nonatomic, assign) NSInteger state;
/**是否技术方机构：1-是，0-否 */
@property (nonatomic, assign) BOOL isTechOrg;

@property (nonatomic, assign) BOOL isHistoryOrder;

@property (nonatomic, strong) NSArray <TutorialListModel *>*tutorial_list;//新增资料教程信息

@end

NS_ASSUME_NONNULL_END
