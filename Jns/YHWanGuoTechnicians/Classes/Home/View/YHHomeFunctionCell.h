//
//  YHHomeFunctionCell.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHHomeModel.h"

@interface YHHomeFunctionCell : UITableViewCell

- (void)loadDatasource:(NSArray*)source;
/** 行数 */
@property (nonatomic,assign) NSInteger rows;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
