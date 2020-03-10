//
//  TTZSurveyModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZChildModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *code;

////////////////////以下为辅助属性////////////////////////////
/** 是否被选中*/
@property (nonatomic, assign) BOOL isSelected;

@end

@interface TTZValueModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat value;
/**是否可以选择 0 可以 1 不可以 */
@property (nonatomic, assign) BOOL clickStauts;    
@property (nonatomic, copy) NSString *clickMsg;

@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString * min;
@property (nonatomic, copy) NSString * max;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *childName;
@property (nonatomic, copy) NSString *tips;  //82℃还没打开，98℃没有全开

@property (nonatomic, strong) NSArray <TTZChildModel *>*childList;

@property (nonatomic, strong) NSMutableArray <TTZChildModel *>*cylinderList;

////////////////////以下为辅助属性////////////////////////////
/** 是否被选中*/
@property (nonatomic, assign) BOOL isSelected;


@end





@interface TTZRangeModel : NSObject


@property (nonatomic, assign) NSInteger maxNumber;

@property (nonatomic, copy) NSString * min;
@property (nonatomic, copy) NSString * max;
@property (nonatomic, strong) NSMutableArray <TTZValueModel *>*list;//选项

@property (nonatomic, copy) NSString *interval;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *name;
@end






@class TTZDBModel;
@interface TTZSurveyModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
/**项目的名称*/
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *unit;
/** 数据类型 range范围 select 多选 radio 单选 input输入文本框 integer 整数 */
@property (nonatomic, copy) NSString *intervalType;
@property (nonatomic, strong) TTZRangeModel *intervalRange;
@property (nonatomic, strong) NSArray *intervalRangeBak;

/**是否必填:1-是，0-否*/
@property (nonatomic, assign) BOOL isRequir;
/**是否显示帮助*/
@property (nonatomic, copy) NSString *imgSrc;
/** 缓存图片集合*/
@property (nonatomic, strong) NSMutableArray <NSString *> *projectRelativeImgList;//图片相对地址（app专用）
@property (nonatomic, strong) NSMutableArray <NSString *> *projectThumbImgList;//缩略图绝对地址（H5专用）
@property (nonatomic, strong) NSMutableArray <NSString *> *projectImgList;///原图绝对地址（H5专用）
/**0-不可上传 1-可上传*/
@property (nonatomic, assign) BOOL uploadImgStatus;
/**"projectVal": "正常",  多选、选项类型存选项中文name,多个英文逗号拼接“*/
@property (nonatomic, copy) NSString *projectVal;
@property (nonatomic, copy) NSString *projectOptionName;
////////////////////以下为辅助属性////////////////////////////
/** cell 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray <TTZDBModel *>*dbImages;
/** 故障码 */
@property (nonatomic, strong) NSMutableArray <NSString *>*codes;
/** 最后一项 */
@property (nonatomic, assign) BOOL isLastProject;
/** 是否显示故障码 */
@property (nonatomic, assign) BOOL showFaultCode;
/** 他的故障吗*/
@property (nonatomic, weak) TTZSurveyModel *faultModel;
/** 工单id*/
@property (nonatomic, copy) NSString *billId;
/** 是否已改变*/
@property (nonatomic, assign) BOOL isChange;

/** 故障的系统ID*/
@property (nonatomic, copy) NSString *sysClassId;
/** 故障的描述*/
@property (nonatomic, copy) NSString *encyDescs;
@property (nonatomic, assign) CGFloat encyDesHeight;
/** 是否展示故障的描述*/
@property (nonatomic, assign) BOOL isShowDes;
/** 故障项目列表*/
@property (nonatomic, strong) NSArray <TTZSurveyModel *>*elecCtrlProjectList;

/** 堵啊选矿高度*/
@property (nonatomic, assign) CGFloat tableViewHeight;

/** add2高度*/
@property (nonatomic, assign) CGFloat add2CylinderHeight;

/** isRequirRequest*/
@property (nonatomic, assign) BOOL isRequirRequest;

@property (nonatomic, assign) BOOL isSelect;

@end





@interface TTZGroundModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
/**组别的名称*/
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, strong) NSMutableArray <TTZSurveyModel *>*list;//一个分组的多少个子项目
////////////////////以下为辅助属性////////////////////////////
/** 是否被选中*/
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CGFloat itemWidth;
@end

@interface TTZSYSNewSubModel : NSObject

@property (nonatomic, copy) NSString *engAssess;// "工程师评估"
@property (nonatomic, copy) NSString *result;//"检测结果"
@property (nonatomic, copy) NSString *itemName;//"检测项目名称"
@property (nonatomic, copy) NSString *detectionResult;//"异常时的结果描述" // 当level不为1或e时，自增序号换行拼接该信息
@property (nonatomic, copy) NSString *useAdvise;//"用车建议"
@property (nonatomic, copy) NSString *level;//问题严重程度：e-未检测 1-正常 0-轻微 2-中等  3-严重",//当为1时 ，显示 检测结果+换行+工程师评估+空格+用车建议;当不为1时，显示detectionResult
@property (nonatomic, copy) NSString *riskForecast;//"风险预估"
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *carSysId;//"大系统ID"

@end

@interface TTZSYSModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
/**系统名字*/
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *saveType;
@property (nonatomic, strong) NSMutableArray <TTZGroundModel *>*list;//一个列表的数据--多少组
@property (nonatomic, strong) NSMutableArray <TTZSYSNewSubModel *>*Sublist;//异常列表
////////////////////以下为辅助属性////////////////////////////
/** 是否已检查*/
//@property (nonatomic, copy) NSString *isCheck;
/** 检测进度*/
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) NSString *status;//异常状态;

@property (nonatomic, strong) NSNumber *close;//单元格是否收缩;

@end


@interface TTZSYSNewModel : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
//['elect','cold','engine','brake','driver_dust','driver_gear'];
//['电器17','空调12','发动机13','制动16','传动15','变速箱14'];

@end

@interface TTZSYSSupModel : NSObject

@property (nonatomic, strong) NSMutableArray<TTZSYSNewModel *> *status;
@property (nonatomic, strong) NSMutableArray<TTZSYSNewSubModel *> *code;

@end

