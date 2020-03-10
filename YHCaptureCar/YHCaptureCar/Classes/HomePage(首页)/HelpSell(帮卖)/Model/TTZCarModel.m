//
//  TTZCarModel.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "TTZCarModel.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import <MJExtension.h>

@implementation offerModel

@end

@implementation TTZCarModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageWidth = 110;
    }
    return self;
}

- (void)setImageWidth:(NSInteger)imageWidth {
    _imageWidth = imageWidth * [UIScreen mainScreen].scale;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"carStatus" : @[@"carStatus",@"status"]};
}

- (NSString *)price{
    
    if (_price.length < 1)  return @"面议";
    
    if([_price floatValue] <= 0)  return @"面议";
    
    
   return [NSString stringWithFormat:@"%0.2f万",[_price floatValue]];
}

- (NSString *)carPicture
{
    NSString *carPictureURL = _flag ? [YHTools hmacsha1YHJns:_carPicture width:(long)_imageWidth] : [YHTools hmacsha1YH:_carPicture width:(long)_imageWidth];
    YHLog(@"---图片：%@", carPictureURL);
    return carPictureURL;
}

@end
