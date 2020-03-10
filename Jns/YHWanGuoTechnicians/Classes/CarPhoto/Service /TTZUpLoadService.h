//
//  TTZUpLoadService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

@interface TTZUpLoadService : NSObject
DEFINE_SINGLETON_FOR_HEADER(TTZUpLoadService);

//- (void)upLoad;

//- (void)uploadWithAlert;
//- (void)uploadDidHandle:(void (^)(void))complete;
- (void)uploadOrder:(NSString *)billid
          didHandle:(void (^)(void))complete;


/** 是否正在上传任务 */
@property (nonatomic, assign) BOOL isUpLoad;

/** 单个文件上传成功回调*/
@property (nonatomic, copy) void (^complete)(NSString *fileId);


/** 移动数据上传*/
@property (nonatomic, assign) BOOL isAllowWWAN;

@end
