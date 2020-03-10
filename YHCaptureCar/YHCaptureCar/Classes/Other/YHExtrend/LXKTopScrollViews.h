//
//  LXKTopScrollViews.h
//  LXKTopScroll
//
//  Created by lxkboy on 2018/1/9.
//  Copyright © 2018年 lxkboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXKScrollViewType.h"
//代理方法
@protocol LXKTopScrollViewsDelegate <NSObject>
///点击了顶部的第几个按钮
-(void)clickLXKScroolViewTopBtnWithIndex:(NSInteger)index;
///滑动到scrollview的第几个content
-(void)scroolToIndex:(NSInteger)index;
@end

@interface LXKTopScrollViews : UIView
@property (nonatomic,weak) id<LXKTopScrollViewsDelegate> delegate;
/**
 滚动线的颜色
 */
@property(nonatomic,strong)UIColor *lineColor;

/**
 滑块的类型
 */
@property(nonatomic,assign)LXKScrollViewType lineType;


/**
 创建scrollviews滑动

 @param frame 控件的frame
 @param titleArr 控件顶部的title数组
 @param selectColor 控件顶部选中的字体颜色
 @param unselectColor 控件顶部未选中的字体颜色
 @param selectFont 控件顶部选中的字体大小
 @param unSelectFont 控件顶部未选中的字体大小
 */
+(LXKTopScrollViews *)instanceViewWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr selectColor:(UIColor *)selectColor unSelectColor:(UIColor *)unselectColor selectFont:(UIFont *)selectFont unSelectFont:(UIFont *)unSelectFont;

/**
 向scrollview添加子控件
 注意：1、子控件的frame会在addsub方法里面重写，所以子控件初始化的时候可以不设置frame
      2、子控件的排列顺序和数组顺序一致
      3、数组数要和titleArr保持一致
 @param subViewArr 子控件数组
 */
-(void)addSubViewToScrollViewWithSubArr:(NSArray *)subViewArr;

@end
