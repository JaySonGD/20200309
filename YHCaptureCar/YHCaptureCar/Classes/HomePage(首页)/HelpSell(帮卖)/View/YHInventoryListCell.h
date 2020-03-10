//
//  YHInventoryListCell.h
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTZCarModel;

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHInventoryListCell : UITableViewCell

@property (nonatomic, strong) TTZCarModel *model;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
