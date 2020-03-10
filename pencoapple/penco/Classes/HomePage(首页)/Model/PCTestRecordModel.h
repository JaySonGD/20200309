//
//  PCTestRecordModel.h
//  penco
//
//  Created by Jay on 26/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PCLocationModel : NSObject
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *z;
@end


@interface PCPointModel : NSObject
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) PCLocationModel *location;
@end


@interface PCPartModel : NSObject
@property (nonatomic, strong) PCPointModel *normal;
@property (nonatomic, strong) PCPointModel *up;
@property (nonatomic, strong) PCPointModel *down;
@property (nonatomic, strong) PCPointModel *down1;

@end

@interface PCDifferModel : NSObject
@property (nonatomic, assign) CGFloat normal;
@property (nonatomic, assign) CGFloat up;
@property (nonatomic, assign) CGFloat down;

@end

@interface PCTestRecordModel : NSObject

@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *reportTime;

@property (nonatomic, strong) PCPartModel *leftUpperArm;
@property (nonatomic, strong) PCPartModel *rightUpperArm;
@property (nonatomic, strong) PCPartModel *leftLowerArm;
@property (nonatomic, strong) PCPartModel *rightLowerArm;
@property (nonatomic, strong) PCPartModel *bust;
@property (nonatomic, strong) PCPartModel *hipline;
@property (nonatomic, strong) PCPartModel *waist;
@property (nonatomic, strong) PCPartModel *leftLeg;
@property (nonatomic, strong) PCPartModel *leftThigh;
@property (nonatomic, strong) PCPartModel *rightLeg;
@property (nonatomic, strong) PCPartModel *rightThigh;
@property (nonatomic, strong) PCPartModel *shoulder;



@property (nonatomic, strong) PCDifferModel *leftUpperArmDiffer;
@property (nonatomic, strong) PCDifferModel *rightUpperArmDiffer;
@property (nonatomic, strong) PCDifferModel *leftLowerArmDiffer;
@property (nonatomic, strong) PCDifferModel *rightLowerArmDiffer;
@property (nonatomic, strong) PCDifferModel *bustDiffer;
@property (nonatomic, strong) PCDifferModel *hiplineDiffer;
@property (nonatomic, strong) PCDifferModel *waistDiffer;
@property (nonatomic, strong) PCDifferModel *leftLegDiffer;
@property (nonatomic, strong) PCDifferModel *leftThighDiffer;
@property (nonatomic, strong) PCDifferModel *rightLegDiffer;
@property (nonatomic, strong) PCDifferModel *rightThighDiffer;
@property (nonatomic, strong) PCDifferModel *shoulderDiffer;


@property (nonatomic, strong) PCPartModel *measureResults;


@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *weightDiffer;
@property (nonatomic, copy) NSString *heightDiffer;


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *modelUrl;
@property (nonatomic, assign) NSInteger status;
//测量量数据归属状态 0:待确认 1:已确认

@property (nonatomic, assign) BOOL isConfirm;

@property (nonatomic, strong) NSMutableArray <YHCellItem *>*items;

- (NSMutableArray<YHCellItem *> *)contrastWithHeight:(NSInteger)height;
//测量量code
//0:成功
//其他失败 详情⻅见体形算法Code码
@property (nonatomic, assign) NSInteger analysisCode;

@property (nonatomic, copy) NSString *analysisMessage;


@end

NS_ASSUME_NONNULL_END
