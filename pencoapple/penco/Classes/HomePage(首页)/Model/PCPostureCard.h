//
//  PCPostureCard.h
//  penco
//
//  Created by Zhu Wensheng on 2019/10/14.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PCPostureCard : NSObject

@property (nonatomic, copy) NSString *level;//normal 低 mild 中 severe 高
@property (nonatomic, copy) NSString *value;//分数
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, strong) UIImage *regionImg;//局部图
@property (nonatomic, strong) NSString *imgUrl;//示意图url
@property (nonatomic, strong) NSString *detailUrl;//二级界面url
@property (nonatomic, strong) NSString *postreUrl;//体态结论


@property (nonatomic, weak) NSString *postureDetailsPage;//二级界面urly头
@property (nonatomic, weak) UIImage *img;//原始图
@property (nonatomic, strong) UIImage *imgCut;//截图备份
@property (nonatomic, weak) NSDictionary *point;//测量点
@property (nonatomic, strong) NSString *side;//侧面方向
@end


NS_ASSUME_NONNULL_END
