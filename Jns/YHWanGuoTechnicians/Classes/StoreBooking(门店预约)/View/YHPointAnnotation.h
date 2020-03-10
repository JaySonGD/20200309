//
//  YHPointAnnotation.h
//  YHCaptureCar
//
//  Created by Jay on 18/5/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface YHPointAnnotation : MAPointAnnotation
@property (nonatomic, copy)NSString *ID;                 //站点ID
@property (nonatomic, copy)NSString *imageName;
@end
