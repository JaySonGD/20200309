//
//  YHInPutCell.h
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTZInPutModel;
@interface YHInPutCell : UITableViewCell
@property (nonatomic, strong) TTZInPutModel *model;
@property (nonatomic, copy)  dispatch_block_t jump2Map;
@end
