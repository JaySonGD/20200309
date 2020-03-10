//
//  TTZDBModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZDBModel : NSObject

@property (nonatomic, copy) NSString *fileId;
/** 是否触发了上传<##> */
//@property (nonatomic, assign) BOOL isDo;

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, assign) BOOL isUpLoad;


/** 辅助属性*/
@property (nonatomic, strong) UIImage *image;


@end
