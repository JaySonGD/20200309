//
//  YHRichesCell.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRichesCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *info;

- (void)setPremptText:(NSString *)text;

@end
