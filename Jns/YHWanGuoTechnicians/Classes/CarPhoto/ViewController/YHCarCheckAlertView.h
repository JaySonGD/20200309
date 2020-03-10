//
//  YHCarCheckAlertView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHSurveyCheckProjectModel;
@interface YHCarCheckAlertView : UIViewController
@property (nonatomic, strong) NSArray<YHSurveyCheckProjectModel *>*models;
@property (nonatomic, copy) dispatch_block_t submitBlock;

@end


@interface YHAlertListView : UITableViewCell
@property (nonatomic, strong) YHSurveyCheckProjectModel *model;
@end
