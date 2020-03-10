//
//  YHPhotoManger.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHPhotoManger.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "TTZUpLoadService.h"


@implementation YHPhotoManger


+ (NSString *)fileName{
    return [NSString stringWithFormat:@"%lu",(unsigned long)[[NSDate date] timeIntervalSince1970]];
    
}

+ (BOOL)moveItemAtPath:(NSString *)carLineId toPath:(NSString *)billId{
    
    
    if ([carLineId isEqualToString:billId]) {
        
        BOOL flag = [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@'",billId]];

        [[TTZUpLoadService sharedTTZUpLoadService] upLoad];
        
        return flag;
    }
    
    NSString *carLineIdPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                                stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:carLineId];
    NSString *billIdPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                             stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:billId];
    
    
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:carLineIdPath toPath:billIdPath error:&error];
    if (!error) {
        NSLog(@"%s---文件已迁移", __func__);
        [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1,billId ='%@' where billId ='%@'",billId,carLineId]];
        
    }
    
    [[TTZUpLoadService sharedTTZUpLoadService] upLoad];
    
    return (BOOL)error;
}

+ (void)deleteUpLoadedFile:(TTZDBModel *)db
{
    NSString *filePath = [self filePathOfSubDirectory:db.billId fileName:db.file];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where fileId ='%@'",db.fileId]];
}

+ (void)saveImage:(UIImage *)image
     subDirectory:(NSString *)directory
         fileName:(NSString *)name{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                                 stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:directory] ;
        
        NSString *filePath = [cachesPath stringByAppendingPathComponent:name];
        
        NSLog(@"%s-图片路径：%@", __func__,filePath);
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachesPath isDirectory:NULL]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:NULL error:NULL];
        }
        
        
        [[self compressImageQuality:image toKByte:600] writeToFile:filePath atomically:YES];
        
    });
    
}


+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
//    return aImage;
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
        default:
            
            break;
            
    }
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
        default:
            
            break;
            
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             
                                             CGImageGetColorSpace(aImage.CGImage),
                                             
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            
            break;
            
            
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            
            break;
            
    }
    
    
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    return img;
    
}




+ (NSString *)filePathOfSubDirectory:(NSString *)directory
                            fileName:(NSString *)name{
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                             stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:directory] ;
    
    NSString *filePath = [cachesPath stringByAppendingPathComponent:name];
    
    return filePath;
}

+(UIImage *)compressOriginalImage:(UIImage *)image
                           toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * resultImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}
+ (NSData *)compressImageQuality:(UIImage *)image
                         toKByte:(NSInteger)kb {
    
    if (image.size.width > 1080) {
        image = [self compressOriginalImage:image toSize:CGSizeMake(1080, 1080 * image.size.height / image.size.width)];
        
    }
    image = [self fixOrientation:image];
    
    kb *= 1000;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1000.0f);
    
    
    return imageData;//@{@"image":[UIImage imageWithData:imageData],@"data":imageData};
}

+ (NSArray *)picturnCode{
    //if(!_picturnCode){
    NSArray * picturnCode = @[@"surface_front",@"surface_left",@"surface_back",
                              @"surface_right",@"engine_room",@"rear_box",@"interior_1",
                              @"interior_2",@"interior_3",@"instrument_panel",@"car_other"];
    //}
    return picturnCode;
}

@end
