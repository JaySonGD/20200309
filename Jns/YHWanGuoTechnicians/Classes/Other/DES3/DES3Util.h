//
//  DES3Util.h
//  coreDataTest
//
//  Created by ZWS on 14-10-11.
//  Copyright (c) 2014年 ZWS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>


@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText; 
@end
