//
//  YHUpLoadManager.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface YHUpLoadManager : NSObject
DEFINE_SINGLETON_FOR_HEADER(YHUpLoadManager);

- (void)upload;
@end
