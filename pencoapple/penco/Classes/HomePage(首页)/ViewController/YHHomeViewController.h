//
//  YHHomeViewController.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
@interface YHHomeViewController : YHBaseViewController
- (void)appToH5:(NSDictionary*)info;
@property (nonatomic, strong)NSString *model1;
-(void)pushUriModel:(NSString*)data;
@end
