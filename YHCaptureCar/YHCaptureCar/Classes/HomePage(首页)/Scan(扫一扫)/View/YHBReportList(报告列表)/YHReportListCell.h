//
//  YHReportListCell.h
//  YHCaptureCar
//
//  Created by mwf on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseCell.h"
#import "YHReportListModel.h"

@interface YHReportListCell : YHBaseCell

@property (weak, nonatomic) IBOutlet UILabel *checkTimeL;
@property (weak, nonatomic) IBOutlet UILabel *checkTypeL;

- (void)refreshUIWithModel:(YHReportListModel *)model;

@end
