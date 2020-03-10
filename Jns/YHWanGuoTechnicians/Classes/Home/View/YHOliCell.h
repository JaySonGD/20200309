//
//  YHOliCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHOliCell : UITableViewCell

- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info;
- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info index:(NSUInteger)index;
@end
