//
//  YHCarSelAllCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/8/18.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YHCarAll) {
    YHCarAllLeft ,//
    YHCarAllCenter ,//
    YHCarAllRight ,//
};
@interface YHCarSelAllCell : UITableViewCell

- (void)loadButtonState:(YHCarAll)state sysIndex:(NSUInteger)index;
- (void)loadButtonState:(YHCarAll)state;

@property (nonatomic, strong) NSMutableDictionary *itemInfo;

@end
