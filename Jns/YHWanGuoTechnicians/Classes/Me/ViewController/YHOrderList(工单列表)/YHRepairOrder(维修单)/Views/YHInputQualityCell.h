//
//  YHInputQualityCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/29.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHInputQualityCell : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic , assign) CGRect oldTextViewBounds;//动态质保高度

@end

NS_ASSUME_NONNULL_END
