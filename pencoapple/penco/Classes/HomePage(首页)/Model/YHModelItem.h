//
//  YHModelItem.h
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YHCellItem : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat up;
@property (nonatomic, assign) CGFloat normal;
@property (nonatomic, assign) CGFloat down;
@property (nonatomic, assign) CGFloat change;

@property (nonatomic, copy) NSString *reportTime;
@property (nonatomic, copy) NSString *bodyParts;

@property (nonatomic) NSInteger min;//刻度最小
@property (nonatomic) NSInteger max;//刻度最大
@property (nonatomic) NSInteger normalMin;//正常最小
@property (nonatomic) NSInteger normalMax;//正常最大

@end

@interface YHModelItem : NSObject

@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *modelUrl;

@property (nonatomic, assign) CGFloat leftUpperArm;
@property (nonatomic, assign) CGFloat rightUpperArm;
@property (nonatomic, assign) CGFloat leftLowerArm;
@property (nonatomic, assign) CGFloat rightLowerArm;

@property (nonatomic, assign) CGFloat bust;
@property (nonatomic, assign) CGFloat hipline;
@property (nonatomic, assign) CGFloat waist;
@property (nonatomic, assign) CGFloat leftLeg;

@property (nonatomic, assign) CGFloat leftThigh;
@property (nonatomic, assign) CGFloat rightLeg;
@property (nonatomic, assign) CGFloat rightThigh;
@property (nonatomic, assign) CGFloat shoulder;


@property (nonatomic, strong) NSMutableArray <YHCellItem *>*items;

@end



NS_ASSUME_NONNULL_END
