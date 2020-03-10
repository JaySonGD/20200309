//
//  YHPersonPresenter.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHPersonModel.h"
#import "YHPersonNewModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol YHPersonPresenterDelegate <NSObject>

- (void)setPersonCenterData:(NSMutableArray <YHPersonSectionModel*> *)personList with:(YHPersonHeaderModel *)headerModel;

- (void)setPersonCenterStationList:(NSDictionary *)info error:(NSError *)error;

@end

@interface YHPersonPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(id <YHPersonPresenterDelegate>)delegate;

- (void)getPersonCenterData;

@end

NS_ASSUME_NONNULL_END
