//
//  YHImageItemView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHImageItemView : UIView
/** 展示图片imageView */
@property (nonatomic,weak) UIImageView *imageV;
/** 清除按钮 X */
@property (nonatomic, weak) UIButton *cleanBtn;
/** 与之绑定的图片路径 */
@property (nonatomic, copy) NSString *imagePath;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithImageItemViewClearnBlock:(void (^)(YHImageItemView *item))clearnBlock tapImageViewBlock:(void (^)(YHImageItemView *item))tapImageViewBlock;

@end
