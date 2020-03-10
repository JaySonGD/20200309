//
//  TTZDBModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZDBModel.h"

#import "YHPhotoManger.h"

@implementation TTZDBModel
+ (NSArray *)uniqueKeys
{
    return @[@"fileId"];
}

- (UIImage *)image
{
    if (!_image) {
        NSString *filePath = [YHPhotoManger filePathOfSubDirectory:self.billId fileName:self.file];
        _image =[UIImage imageWithContentsOfFile:filePath];
    }
    
    return _image;
}

@end
