//
//  ZRouterModel.m
//  ZRouter
//
//  Created by Jay on 7/12/2018.
//  Copyright © 2018 ZZ. All rights reserved.
//

#import "ZRouterURL.h"

@implementation ZRouterURL

- (instancetype)initWithPath:(NSString *)path {
    return [self initWithPath:path params:nil];
}

- (instancetype)initWithPath:(NSString *)path params:(NSDictionary *)params {
    return [self initWithScheme:ZRouterScheme path:path params:params];
}

- (instancetype)initWithScheme:(NSString *)scheme path:(NSString *)path {
    return [self initWithScheme:scheme path:path params:nil];
}

- (instancetype)initWithScheme:(NSString *)scheme path:(NSString *)path params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _scheme = scheme;
        _path = path;
        _params = params;
        
    }
    return self;
}

@end

@implementation ZRouterActionModel
@end

@implementation ZRouterActionCallbackModel
@end
