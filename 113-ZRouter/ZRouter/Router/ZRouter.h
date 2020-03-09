//
//  ZRouter.h
//  ZRouter
//
//  Created by Jay on 7/12/2018.
//  Copyright © 2018 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRouterURL.h"


@interface ZRouter : NSObject
+ (instancetype)sharedRouter;
- (void)registerPath:(NSString *)path actionBlock:(RouterActionBlock)actionBlock;


- (BOOL)runWithActionPath:(NSString *)path;
- (BOOL)runWithActionPath:(NSString *)path params:(NSDictionary *)params;
- (BOOL)runWithActionURL:(ZRouterURL *)url;
- (BOOL)runWithActionCallbackObject:(ZRouterActionCallbackModel *)actionCallbackObject;

@end

