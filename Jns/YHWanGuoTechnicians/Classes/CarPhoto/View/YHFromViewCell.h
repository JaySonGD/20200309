//
//  YHFromViewCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHlistModel;
@interface YHFromViewCell : UITableViewCell
    @property (nonatomic, strong) YHlistModel *model;
    @property (nonatomic, copy) void(^add)(void);
    @property (nonatomic, copy) void(^remove)(YHlistModel *);
    @property (nonatomic, copy) void(^textChange)(NSString *text);

@property (nonatomic, copy)  void(^cheackBlock)(NSInteger max ,NSInteger min , NSInteger val);


//@property (nonatomic, assign) NSInteger min;
//@property (nonatomic, assign) NSInteger max;

@end
