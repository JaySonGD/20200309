//
//  YHScanCell.h
//  YHCaptureCar
//
//  Created by mwf on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseCell.h"

@interface YHScanCell : YHBaseCell

@property (weak, nonatomic) IBOutlet UILabel *vinL;

- (void)refreshUIWithVinStr:(NSString *)vin;

@end
