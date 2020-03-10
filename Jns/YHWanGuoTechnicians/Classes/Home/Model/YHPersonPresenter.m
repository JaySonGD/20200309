//
//  YHPersonPresenter.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPersonPresenter.h"
#import <MJExtension.h>

@interface YHPersonPresenter ()

@property (nonatomic, weak) id <YHPersonPresenterDelegate>delegate;

@end

@implementation YHPersonPresenter

- (instancetype)initWithDelegate:(id<YHPersonPresenterDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)getPersonCenterData{
    
    YHPersonModel *personModel = [YHPersonModel new];
    YHPersonNewModel *personModel1 = [YHPersonNewModel new];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] userInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        
        NSMutableArray *itemArr = [personModel1 getPersonCenterData:info[@"data"][@"mineModule"]];
        YHPersonHeaderModel *personModel = [YHPersonHeaderModel mj_objectWithKeyValues:info[@"data"]];
        
        if ([self.delegate respondsToSelector:@selector(setPersonCenterData:with:)]) {
            [self.delegate setPersonCenterData:itemArr with:personModel];
        }
        
    } onError:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(setPersonCenterData:with:)]) {
            [self.delegate setPersonCenterData:nil with:nil];
        }
    }];
    
    [personModel getStationListInfoSuccess:^(NSDictionary * info) {
        
        if ([self.delegate respondsToSelector:@selector(setPersonCenterStationList:error:)]) {
            [self.delegate setPersonCenterStationList:info error:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        if ([self.delegate respondsToSelector:@selector(setPersonCenterStationList:error:)]) {
            [self.delegate setPersonCenterStationList:nil error:error];
        }
    }];
}

@end
