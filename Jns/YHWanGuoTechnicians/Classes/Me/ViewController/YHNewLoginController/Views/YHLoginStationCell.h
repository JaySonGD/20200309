//
//  YHLoginStationCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHLoginStationCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *info;

+ (instancetype)createLoginStationCelltableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
