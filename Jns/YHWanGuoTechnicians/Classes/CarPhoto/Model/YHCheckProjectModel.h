//
//  YHCheckProjectModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTZDBModel;

@interface YHlistModel : NSObject
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, copy) NSString *name;


    @property (nonatomic, assign) NSInteger min;
    @property (nonatomic, assign) NSInteger max;
    @property (nonatomic, copy) NSString *unit;
    @property (nonatomic, copy) NSString *dataType;
    @property (nonatomic, copy) NSString *type;

    // 辅助属性
    @property (nonatomic, copy) NSString *placeholder;
    @property (nonatomic, assign) BOOL isSelect;

    @property (nonatomic, assign) BOOL isDelete;

@end

@interface YHIntervalRangeModel : NSObject

@property (nonatomic, strong) NSMutableArray<YHlistModel*> *list;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, copy) NSString *placeholder;




@end
@interface YHProjectListModel : NSObject//检测项目cell



@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *intervalType;
@property (nonatomic, strong) YHIntervalRangeModel *intervalRange;

// 辅助属性
    /** 缓存cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
    /** 添加的图片 */
@property (nonatomic, strong) NSMutableArray <UIImage *>*images;

@property (nonatomic, strong) NSMutableArray <TTZDBModel *>*dbImages;

    
    /** 文本输入框的内容 */
@property (nonatomic, copy) NSString *projectVal;

/** 工单编号 */
@property (nonatomic, copy) NSString *billId;

- (void)cleanDBImages;

@end

@interface YHProjectListGroundModel : NSObject//检测项目cell的ground



@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *intervalType;
@property (nonatomic, strong) YHIntervalRangeModel *intervalRange;

@property (nonatomic, strong) NSMutableArray< YHProjectListModel*> *projectList;


/** 工单编号 */
@property (nonatomic, copy) NSString *billId;

@end



@interface YHSurveyCheckProjectModel : NSObject ////初检检测项目，所有


@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger classSort;
@property (nonatomic, copy) NSArray < YHProjectListGroundModel*> *projectList;
/** 辅助属性*/
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, copy) NSString *val;
@property (nonatomic, strong) UIColor *nameColor;

/** 工单编号 */
@property (nonatomic, copy) NSString *billId;

@end




