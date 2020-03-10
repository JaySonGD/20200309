//
//  YHDetailDepthCell.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/16.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDetailDepthCell : UITableViewCell

@property (nonatomic ,copy) NSString *nameStr;

@property (nonatomic , copy) NSString *subNameStr;

@property (nonatomic , assign) BOOL isLast;//最后一个cell加下划线

@end

NS_ASSUME_NONNULL_END
