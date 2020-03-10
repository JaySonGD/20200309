
//
//  YTPlanModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 19/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZSurveyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface YTBaseInfo : NSObject

@property (nonatomic, copy) NSString * carBrandId;
@property (nonatomic, copy) NSString * carBrandLogo;
@property (nonatomic, copy) NSString * carBrandName;
@property (nonatomic, copy) NSString * carCc;
@property (nonatomic, copy) NSString * carLineId;
@property (nonatomic, copy) NSString * carLineName;
@property (nonatomic, copy) NSString * carModelFullName;
@property (nonatomic, copy) NSString * carModelId;
@property (nonatomic, copy) NSString * carStyle;
@property (nonatomic, copy) NSString * carType;
@property (nonatomic, copy) NSString * carYear;
@property (nonatomic, copy) NSString * fuelMeter;
@property (nonatomic, copy) NSString * gearboxType;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * plateNumber;
@property (nonatomic, copy) NSString * plateNumberC;
@property (nonatomic, copy) NSString * plateNumberP;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * tripDistance;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * vin;


@property (nonatomic, strong) NSString *car_icon;
@property (nonatomic, strong) NSString *car_brand_name;
@property (nonatomic, strong) NSString *car_line_name;
@property (nonatomic, strong) NSString *car_cc;
@property (nonatomic, strong) NSString *car_cc_unit;
@property (nonatomic, strong) NSString *nian_kuan;
@property (nonatomic, strong) NSString *gearbox_type;
@property (nonatomic, strong) NSString *car_model_full_name;


@end

@interface packageOwnerModel : NSObject
@property (nonatomic, copy) NSString *title;//套餐标题
@property (nonatomic, copy) NSString *warranty_desc;//套餐说明
@property (nonatomic, copy) NSString *sales_price;//销售价
@property (nonatomic, copy) NSArray *system_names;// 系统名列表
@end

@interface YTPaymentRecordModel : NSObject
@property (nonatomic, copy) NSString *payDAmount;
@property (nonatomic, copy) NSString *payTime;
@end

@interface YTSplitPayInfoModel : NSObject
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *need_pay;
@property (nonatomic, assign) NSInteger payStatus;//支付状态，-1未支付，0部分支付，1支付完成
@property (nonatomic, strong) NSMutableArray <YTPaymentRecordModel *>*payment_record;
@end


@interface YTCheckResultModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *system_id;
@property (nonatomic, copy) NSString *parts_name;
@property (nonatomic, copy) NSString *check_result;

@end

@interface YHLPCModel1 : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *suggested_status;// 有无建议信息：1-有，0无
@property (nonatomic, strong) NSMutableDictionary *suggested_info;

@end


@interface YTPartModel : YHLPCModel1

@property (nonatomic, copy) NSString *part_name;
@property (nonatomic, copy) NSString *part_type;
@property (nonatomic, copy) NSString *part_type_name;//类别
@property (nonatomic, copy) NSString *part_count;
@property (nonatomic, copy) NSString *part_unit;
@property (nonatomic, copy) NSString *part_price;
@property (nonatomic, copy) NSString *part_brand;

@end

@interface YTConsumableModel : YHLPCModel1

@property (nonatomic, copy) NSString *consumable_name;
@property (nonatomic, copy) NSString *consumable_unit;
@property (nonatomic, copy) NSString *consumable_count;
@property (nonatomic, copy) NSString *consumable_standard;
@property (nonatomic, copy) NSString *consumable_price;
@property (nonatomic, copy) NSString *consumable_brand;

@end

@interface YTLaborModel : NSObject

@property (nonatomic, copy) NSString *labor_name;
@property (nonatomic, copy) NSString *labor_price;
@property (nonatomic, copy) NSString *labor_time;
@property (nonatomic, strong) NSString *status;

@end

@interface YTPlanModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *price_ssss;
@property (nonatomic, assign) NSInteger quality_time;
@property (nonatomic, assign) NSInteger quality_km;
@property (nonatomic, strong) NSString *quality_desc;
@property (nonatomic, strong) NSMutableArray <YTPartModel *>*parts;
@property (nonatomic, strong) NSMutableArray <YTConsumableModel *>*consumable;
@property (nonatomic, strong) NSMutableArray <YTLaborModel *>*labor;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *parts_total;
@property (nonatomic, copy) NSString *consumable_total;
@property (nonatomic, copy) NSString *labor_total;

@property (nonatomic, copy) NSString *name;

/** 是否系统类型：1-系统, 0-本地 */
@property (nonatomic, assign) NSInteger is_sys;

/** <##> */
@property (nonatomic, assign) BOOL isOnlyOne;

@property (nonatomic, strong) NSString *labor_time_total;//汽车安检工单总计
@property (nonatomic, strong) NSString *repairCaseId;

@end


@interface YTCResultModel : NSObject

@property (nonatomic, copy) NSString *makeResult;
@property (nonatomic, copy) NSString *makeIdea;

@property (nonatomic, copy) NSString *nextStatusCode;
/**是否技术方机构：1-是，0-否 */
@property (nonatomic, assign) BOOL isTechOrg;

@end


@interface YTDiagnoseModel : NSObject

@property (nonatomic, strong) NSArray *tutorial_list;//新增资料教程信息
/*方案数据*/
@property (nonatomic, strong) NSMutableArray <YTPlanModel *>*maintain_scheme;
/*诊断结果*/
@property (nonatomic, strong) YTCResultModel *checkResultArr;

@property (nonatomic, strong) YTBaseInfo *baseInfo;

@property (nonatomic, strong) YTBaseInfo *base_info;

/**操作状态：detail-不操作只看详情, handle-可操作 */
@property (nonatomic, copy) NSString *handleType;
/**close:关闭;进行中:underway;complete:工单完成  已支付(工单已完成)页面：billStatus 等于 complete*/
@property (nonatomic, copy) NSString *billStatus;

//"reportStatus":"1", // 报告生成状态 1：未生成，0：已生成
@property (nonatomic, copy) NSString *reportStatus;

@property (nonatomic, copy) NSString *m_item_edit_status;//0已经进行了一步  1未开始
/**
 编辑方案和派工页面：nextStatusCode 等于 initialSurveyCompletion
 方案选择页面：nextStatusCode 等于 affirmMode
 方案待支付页面：nextStatusCode 等于 storeBuyMaintainScheme
 点击已完工页面：nextStatusCode 等于 affirmComplete
 */
//
//编辑方案和派工页面：nextStatusCode 等于 initialSurveyCompletion
//方案选择页面：nextStatusCode 等于 affirmMode
//方案待支付页面：nowStatusCode 等于 affirmMode && nextStatusCode 等于 空字符串
//点击已完工页面：nextStatusCode 等于 affirmComplete

@property (nonatomic, copy) NSString *nextStatusCode;

@property (nonatomic, copy) NSString *nowStatusCode;//pendingPackage待购买套餐

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

/** 复检次数 */
@property (nonatomic, copy) NSString *recheck_num;
/** 复检状态 */
@property (nonatomic, copy) NSString *recheck_status;// 复检状态：0-复检中,1-已复检,空-无复检
/** 步骤提示语 */
@property (nonatomic, copy) NSString *step_hint;
/**车主选择套餐 */
@property (nonatomic, copy) NSArray <packageOwnerModel *> *package_owner;
/** 复检项目列表 */
//@property (nonatomic, copy) NSArray <TTZSYSModel *> *recheck_item;
/** 复检录入数据 */
//@property (nonatomic, copy) NSArray *recheck_item_value;
// 车主选择套餐状态：1-已选,0-未选
@property (nonatomic, copy) NSString *package_check;
// 复检报告生成状态 0：未生成，1：已生成
@property (nonatomic, copy) NSString *r_report_status;
//延长保修系统
@property (nonatomic, copy)NSArray *policy_system_names;

- (void)saveDiagnose;

@end



NS_ASSUME_NONNULL_END
