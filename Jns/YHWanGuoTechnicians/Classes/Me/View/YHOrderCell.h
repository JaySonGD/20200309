//
//  YHOrderCell.h
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHFunctionsEditerController.h"
@interface YHOrderCell : UITableViewCell

- (void)loadDatassource:(NSDictionary*)datasource functionId:(YHFunctionId)functionId index:(NSUInteger)index;
- (void)loadDatassource:(NSDictionary*)datasource functionId:(YHFunctionId)functionId;
- (void)loadName:(NSString*)name;
@end
