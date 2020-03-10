//
//  YHPhotoManger.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTZDBModel;
@interface YHPhotoManger : NSObject

+ (NSArray *)picturnCode;
// caches/images/directory/newtime
+ (NSString *)fileName;

+ (void)saveImage:(UIImage *)image
     subDirectory:(NSString *)directory
         fileName:(NSString *)name;

+ (NSString *)filePathOfSubDirectory:(NSString *)directory
                            fileName:(NSString *)name;

+ (void)deleteUpLoadedFile:(TTZDBModel *)db;

+ (BOOL)moveItemAtPath:(NSString *)carLineId
                toPath:(NSString *)billId;
@end
