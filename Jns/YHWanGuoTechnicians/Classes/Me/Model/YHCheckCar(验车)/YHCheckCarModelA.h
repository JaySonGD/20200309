//
//  YHCheckCarModelA.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/5/22.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCheckCarModelB.h"

@interface YHCheckCarModelA : NSObject

@property(nonatomic,copy)NSString *img_path;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *img_url;

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *projectName;
@property(nonatomic,copy)NSString *projectVal;
@property(nonatomic,copy)NSString *projectOptionName;
@property(nonatomic,strong)NSArray *projectRelativeImgList;//检测项目图相对地址(APP只用该字段)

@end
