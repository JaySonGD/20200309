//
//  LXKTopScrollViews.m
//  LXKTopScroll
//
//  Created by lxkboy on 2018/1/9.
//  Copyright © 2018年 lxkboy. All rights reserved.
//

#import "LXKTopScrollViews.h"

// 获取RGB颜色
#define LXKRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define LXKRGB(r,g,b) RGBA(r,g,b,1.0f)
static CGFloat const btnHeight = 45;
@interface LXKTopScrollViews ()<UIScrollViewDelegate>

/**
 btn底部的lineView(颜色滑动线)
 */
@property(nonatomic,strong)UIScrollView *lineScrollView;

/**
 底部scrollview（用来添加外部子控件）
 */
@property(nonatomic,strong)UIScrollView *scrollView;

/**
 上一次选中的btn，默认为第一个
 */
@property(nonatomic,strong)UIButton *lastButton;

/**
 顶部按钮数组
 */
@property(nonatomic,strong)NSMutableArray *topBtnArr;

/**
 顶部titleArr
 */
@property(nonatomic,strong)NSArray * titleArr;

/**
 选中字体大小
 */
@property(nonatomic,strong)UIFont *selectFont;

/**
 未选中字体大小
 */
@property(nonatomic,strong)UIFont *unSelectFont;

/**
 选中的颜色
 */
@property(nonatomic,strong)UIColor *selectColor;

/**
 未选中颜色
 */
@property(nonatomic,strong)UIColor *unSelectColor;

@property(nonatomic,assign)CGRect selfFrame;

@property(nonatomic,assign)CGFloat lineHeight;

@end
@implementation LXKTopScrollViews
-(instancetype)init
{
    if (self = [super init]) {
        //默认线条
        self.lineType = LXKScrollViewTypeAboutNormal;
    }
    return self;
}
+(LXKTopScrollViews *)instanceViewWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr selectColor:(UIColor *)selectColor unSelectColor:(UIColor *)unselectColor selectFont:(UIFont *)selectFont unSelectFont:(UIFont *)unSelectFont
{
    //属性初始化和赋值
    LXKTopScrollViews *selfView = [[LXKTopScrollViews alloc]initWithFrame:frame];
    selfView.topBtnArr = [NSMutableArray new];
    selfView.titleArr = titleArr;
    selfView.selectColor = selectColor;
    selfView.unSelectColor = unselectColor;
    selfView.selectFont = selectFont;
    selfView.unSelectFont = unSelectFont;
    selfView.selfFrame = frame;
    selfView.backgroundColor = [UIColor whiteColor];
    //创建btn底部的line
    [selfView creatLineScrollView];
    //创建顶部按钮
    [selfView creatTopBtn];
    //创建内容scrollview
    [selfView creatScrollView];
    return selfView;
}

///创建顶部选着btn
-(void)creatTopBtn
{
    int count = (int)self.titleArr.count;
    for (int i = 0; i < count; i++) {
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(i*self.selfFrame.size.width/count, 0, self.selfFrame.size.width/count, btnHeight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i;
        //设置字号和字体颜色
        btn.titleLabel.font = self.unSelectFont;
        //初始时，默认选中第一个btn
        if (i==0) {
            [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
            self.lastButton = btn;
        }
        else
            [btn setTitleColor:self.unSelectColor forState:UIControlStateNormal];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self.topBtnArr addObject:btn];
    }
}
///顶部按钮点击方法
-(void)clickTopBtn:(UIButton *)topBtn
{
    //恢复上次的按钮状态
    [self setBtnState:topBtn];
    //设置当前按钮对应的内容
    [self.scrollView setContentOffset:CGPointMake(self.selfFrame.size.width * topBtn.tag, 0) animated:YES];
    //点击了第几个按钮，代理出去
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLXKScroolViewTopBtnWithIndex:)]) {
        [self.delegate clickLXKScroolViewTopBtnWithIndex:topBtn.tag];
    }
}
///创建顶部的颜色滑动条
-(void)creatLineScrollView
{
    if (!self.lineScrollView) {
        self.lineScrollView = [[UIScrollView alloc]init];
        self.lineScrollView.showsHorizontalScrollIndicator = NO;
        self.lineScrollView.showsVerticalScrollIndicator = NO;
        self.lineScrollView.backgroundColor = [UIColor redColor];
        [self addSubview:self.lineScrollView];
    }
    [self setLineFrame];

}
-(void)setLineFrame
{
    CGFloat topY = btnHeight;
    //普通线条滑动
    if (self.lineType == LXKScrollViewTypeAboutNormal) {
        self.lineHeight = 2.f;
    }
    //方块滑动
    if (self.lineType == LXKScrollViewTypeAboutRectangle) {
        topY = 0;
        self.lineHeight = btnHeight ;
    }
    //椭圆，上下留出一部分空间
    if (self.lineType == LXKScrollViewTypeAboutEllipse) {
        topY = 8;
        self.lineHeight = btnHeight - topY * 2;
    }
    self.lineScrollView.frame = CGRectMake(0, topY, self.selfFrame.size.width/self.titleArr.count, self.lineHeight);
    self.lineScrollView.contentSize = CGSizeMake(self.selfFrame.size.width * self.titleArr.count, self.lineHeight);
    
    if (self.lineType == LXKScrollViewTypeAboutEllipse) {
        self.lineScrollView.layer.cornerRadius = self.lineHeight/2.0;
        self.lineScrollView.clipsToBounds = YES;
    }
}
///创建内容scrollview
-(void)creatScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineScrollView.frame),self.selfFrame.size.width , self.selfFrame.size.height - CGRectGetMaxY(self.lineScrollView.frame))];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(self.selfFrame.size.width*self.titleArr.count,self.selfFrame.size.height - CGRectGetMaxY(self.lineScrollView.frame));
    [self addSubview:self.scrollView];
}
#pragma mark -- scrollView delegate
//滚动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //逻辑：当滑动内容scrollview时，这里更具移动的X位置来实时更改lineScrollvier的frame
    if (scrollView == self.scrollView) {
        CGFloat topY = btnHeight;
        //方块滑动
        if (self.lineType == LXKScrollViewTypeAboutRectangle) {
            topY = 0;
            self.lineHeight = btnHeight ;
        }
        //椭圆，上下留出一部分空间
        if (self.lineType == LXKScrollViewTypeAboutEllipse) {
            topY = 8;
            self.lineHeight = btnHeight - topY * 2;
        }
        self.lineScrollView.frame = CGRectMake(self.scrollView.contentOffset.x/self.titleArr.count, topY, self.selfFrame.size.width/self.titleArr.count, self.lineHeight);
        self.lineScrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x/self.titleArr.count, 0);
        if (self.lineType == LXKScrollViewTypeAboutEllipse) {
            self.lineScrollView.layer.cornerRadius = self.lineHeight/2.0;
            self.lineScrollView.clipsToBounds = YES;
        }
    }
    
}
//停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        //获取scrollview滑动位置
        int i = self.scrollView.contentOffset.x/self.selfFrame.size.width;
        //获取停下来时对应的btn
        UIButton*btn = self.topBtnArr[i];
        //将上次选择的按钮状态还原
        [self setBtnState:btn];
        //代理出去当前的位置
        if (self.delegate && [self.delegate respondsToSelector:@selector(scroolToIndex:)]) {
            [self.delegate scroolToIndex:i];
        }
    }
}
-(void)setBtnState:(UIButton *)btn
{
    //将上次选中的按钮状态复原
    [self.lastButton setTitleColor:self.unSelectColor forState:UIControlStateNormal];
    self.lastButton.titleLabel.font = self.unSelectFont;
    //将当前的btn更改未选中状态
    [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
    btn.titleLabel.font = self.selectFont;
    
    self.lastButton = btn;
}
-(void)drawRect:(CGRect)rect
{
    //方块滑动
    if (self.lineType == LXKScrollViewTypeAboutRectangle) {
        [self creatLineScrollView];
    }
    //椭圆滑块
    if (self.lineType == LXKScrollViewTypeAboutEllipse) {
        [self creatLineScrollView];
    }
    if (self.lineColor) {
        self.lineScrollView.backgroundColor = self.lineColor;
    }
    //重写scrollview的frame
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.lineScrollView.frame),self.selfFrame.size.width , self.selfFrame.size.height - CGRectGetMaxY(self.lineScrollView.frame));
}
#pragma mark -- 向scrollview添加subview
-(void)addSubViewToScrollViewWithSubArr:(NSArray *)subViewArr
{
    for (int i = 0; i < subViewArr.count; i++) {
        UIView * view = subViewArr[i];
        view.frame = CGRectMake(self.selfFrame.size.width * i, 0, self.selfFrame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:view];
    }
}
@end
