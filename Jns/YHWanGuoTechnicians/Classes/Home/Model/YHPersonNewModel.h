//
//  YHPersonNewModel.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/5/6.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPersonHeaderModel : NSObject

@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *orgPoints;
@property (nonatomic, copy) NSString *availableCashback;
@property (nonatomic, copy) NSString *orgCode;
@property (nonatomic, copy) NSString *alreadyWithdraw;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *userOpenId;

@end

@interface YHPersonNewDetailModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

@end

@interface YHPersonNewModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) NSArray<YHPersonNewDetailModel *> *secondMenu;

- (NSMutableArray <YHPersonNewModel *>*)getPersonCenterData:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END

