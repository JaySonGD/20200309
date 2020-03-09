//
//  ZRouter.m
//  ZRouter
//
//  Created by Jay on 7/12/2018.
//  Copyright © 2018 ZZ. All rights reserved.
//

#import "ZRouter.h"
#import "ZRouterURL.h"


@interface ZRouter ()

@property (nonatomic, strong) NSMutableDictionary *routerMap;

@end

@implementation ZRouter
// MARK: - Getter

- (NSMutableDictionary *)routerMap {
    if (!_routerMap) {
        _routerMap = [NSMutableDictionary new];
    }
    return _routerMap;
}

+ (instancetype)sharedRouter{
    static ZRouter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZRouter new];
    });
    return instance;
}


/**
 注册路由
 @param path 路径
 @param actionBlock 路径对应的block对象
 */
- (void)registerPath:(NSString *)path actionBlock:(RouterActionBlock)actionBlock {
    ZRouterActionModel *actionObject = [ZRouterActionModel new];
    actionObject.path = path;
    actionObject.actionBlock = actionBlock;
    
    self.routerMap[path] = actionObject;

}


- (BOOL)runWithActionPath:(NSString *)path {
    return [self runWithActionPath:path params:nil];
}

- (BOOL)runWithActionPath:(NSString *)path params:(NSDictionary *)params {
    ZRouterURL *uri = [[ZRouterURL alloc] initWithPath:path params:params];
    return [self runWithActionURL:uri];
}

- (BOOL)runWithActionURL:(ZRouterURL *)url {
    ZRouterActionCallbackModel *actionCallbackObject = [ZRouterActionCallbackModel new];
    actionCallbackObject.url = url;
    return [self runWithActionCallbackObject:actionCallbackObject];
}


- (BOOL)runWithActionCallbackObject:(ZRouterActionCallbackModel *)actionCallbackObject {
    ZRouterActionModel *actionObject = self.routerMap[actionCallbackObject.url.path];
    
    !actionObject.actionBlock ?: actionObject.actionBlock(actionCallbackObject);
    return YES;
}



@end
