//
//  YHExtrendBackCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YHExtrendBackListController.h"
@interface YHExtrendBackCell : UITableViewCell

- (void)loadDatasource:(NSDictionary*)info model:(YHExtrendBackModel)model;
@end
