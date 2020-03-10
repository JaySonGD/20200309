//
//  YHCheckCarAllPictureViewController.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class TTZSurveyModel;
@interface YHCheckCarAllPictureViewController : YHBaseViewController
@property (nonatomic, strong) TTZSurveyModel *model;
@property (nonatomic, assign) BOOL isAllowUpLoad;
//@property (nonatomic, strong) NSMutableArray *info;
@property (nonatomic, copy)  dispatch_block_t callBackBlock;
@end
