//
//  YHPlaceholderTextView.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/8/7.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPlaceholderTextView : UITextView

/** 占位符 */
@property (nonatomic, copy) NSString *zyn_placeholder;

/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
