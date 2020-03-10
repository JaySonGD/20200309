//
//  YHCarPhotoModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YHPhotoModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end

@interface YHCarPhotoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSMutableArray <YHPhotoModel*> *pic;

@end

@interface YHPhotoDBModel : NSObject

@property (nonatomic, copy) NSString *mid;
/** 是否触发了上传<##> */
@property (nonatomic, assign) BOOL isDo;

@property (nonatomic, copy) NSString *imagePath0;
@property (nonatomic, copy) NSString *imagePath1;
@property (nonatomic, copy) NSString *imagePath2;
@property (nonatomic, copy) NSString *imagePath3;


@property (nonatomic, copy) NSString *imagePath4;

@property (nonatomic, copy) NSString *imagePath5;

@property (nonatomic, copy) NSString *imagePath6;
@property (nonatomic, copy) NSString *imagePath7;
@property (nonatomic, copy) NSString *imagePath8;

@property (nonatomic, copy) NSString *imagePath9;

@property (nonatomic, copy) NSMutableArray <NSString*> *others;

@end
