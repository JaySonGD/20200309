//
//  Created by Jayson on 2019/6/22.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "YHBaseViewController.h"
//@class YHPhotoModel,YHPhotoDBModel,TTZDBModel;
@class TTZSYSModel,TTZSurveyModel;

@interface TTZTakePhotoController : YHBaseViewController

@property (nonatomic, copy) dispatch_block_t doClick;

@property (nonatomic, strong) TTZSYSModel *sysModel;
@property (nonatomic, strong) TTZSurveyModel *model;

@end
