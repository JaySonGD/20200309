//
//  YHHomeViewController.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseTableViewController.h"
@interface YHHomeViewController : YHBaseTableViewController

#pragma mark - 获取首页
+ (NSNumber *)getHomePageNumberWithKey:(NSString *)key;

@end
