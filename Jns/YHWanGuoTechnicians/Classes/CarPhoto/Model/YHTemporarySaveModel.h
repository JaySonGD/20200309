//
//  YHTemporarySaveModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YHProjectValModel:NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *projectVal;
@end;
@interface YHInitialSurveyProjectValModel :NSObject
@property (nonatomic, copy) NSString *sysId;
@property (nonatomic, copy) NSString *saveType;
@property (nonatomic, copy) NSMutableArray <YHProjectValModel *>*projectVal;
@end

@interface YHTemporarySaveModel : NSObject
@property (nonatomic, strong) NSDictionary *baseInfo;

@property (nonatomic, strong) NSMutableArray <YHInitialSurveyProjectValModel *>*initialSurveyProjectVal;
@end



