//
//  TTZDBModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZDBModel : NSObject

/** 文件编号-不可变 */
@property (nonatomic, copy) NSString *fileId;

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *code;
/** 本地文件路径 */
@property (nonatomic, copy) NSString *file;
/** 是否触发了上传 */
@property (nonatomic, assign) BOOL isUpLoad;

/** 分类 1：检测项目 2：基本信息 3：报告信息 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger timestamp;//毫秒时间戳

/** 辅助属性*/
@property (nonatomic, strong) UIImage *image;

/** 单个文件上传失败的次数 */
@property (nonatomic, assign) NSInteger allowUploadCount;

@end
