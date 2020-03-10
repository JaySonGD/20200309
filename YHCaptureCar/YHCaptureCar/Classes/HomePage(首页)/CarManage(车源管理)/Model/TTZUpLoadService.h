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

- (void)upLoad;

/** 是否正在上传任务 */
@property (nonatomic, assign) BOOL isUpLoad;

@end
