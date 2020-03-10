//
//  YHOrderDetailViewSupCell.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/10.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTZSurveyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHOrderDetailViewSupCell : UITableViewCell

@property (nonatomic, copy) TTZSYSModel *cellModel;

@property (nonatomic, strong) NSNumber *showNum;//是否展开

@end

NS_ASSUME_NONNULL_END
