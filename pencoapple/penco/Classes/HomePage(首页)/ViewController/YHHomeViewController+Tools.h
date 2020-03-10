//
//  YHHomeViewController+Tools.h
//  penco
//
//  Created by Zhu Wensheng on 2019/7/19.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHHomeViewController.h"

typedef enum : NSUInteger {
    PC3dModelShaping,//塑形
    PC3dModelMuscleGrowth,//增肌
    PC3dModelMan,//用户
    PC3dModelCancel,//取消
} PC3dModel;
NS_ASSUME_NONNULL_BEGIN

@interface YHHomeViewController (Tools)

-(NSString*)downloadModelPath:(PC3dModel)model;

-(void)download3DModel:(PC3dModel)model url:(NSString*)urlStr modelId:(NSString*)modelId;
-(void)downloadPly:(NSString*)urlStr plyId:(NSString*)plyId;
@end

NS_ASSUME_NONNULL_END
