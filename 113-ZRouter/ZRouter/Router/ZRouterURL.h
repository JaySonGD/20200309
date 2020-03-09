//
//  ZRouterModel.h
//  ZRouter
//
//  Created by Jay on 7/12/2018.
//  Copyright © 2018 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const ZRouterScheme = @"YTRouter";

@interface ZRouterURL : NSObject

@property (nonatomic, copy, readonly) NSString *uri;
@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, weak)  UIViewController *viewController;


//- (instancetype)initWithURLString:(NSString *)URLString;
- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path params:(NSDictionary *)params;
//- (instancetype)initWithScheme:(NSString *)scheme path:(NSString *)path;
//- (instancetype)initWithScheme:(NSString *)scheme path:(NSString *)path params:(NSDictionary *)params;

@end


@class ZRouterActionCallbackModel;
typedef void(^RouterActionBlock)(ZRouterActionCallbackModel *callbackModel);

@interface ZRouterActionModel : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) RouterActionBlock actionBlock;
@end


typedef void(^RouterActionCallbackBlock)(id result);

@interface ZRouterActionCallbackModel : NSObject
@property (nonatomic, strong)  ZRouterURL*url;
@property (nonatomic, copy)    RouterActionCallbackBlock actionCallbackBlock;
@end


