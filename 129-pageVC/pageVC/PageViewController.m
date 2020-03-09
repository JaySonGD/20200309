//
//  ViewController.m
//  pageVC
//
//  Created by Jay on 16/5/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "PageViewController.h"

@interface TitleCell : UICollectionViewCell
@property (nonatomic, weak) UILabel *titleLB;
@end

@implementation TitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.font = [UIFont systemFontOfSize:18];
        titleLB.textAlignment = NSTextAlignmentCenter;;
        [self.contentView addSubview:titleLB];
        self.titleLB = titleLB;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLB.frame = self.contentView.bounds;
}

@end

@interface PageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray <UIViewController *>*vcs;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) UICollectionView *titleView;
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;

@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    [self setUI];
    
    
    
}

- (CGFloat)widthOfString:(NSString *)string{
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};     //字体属性，设置字体的font
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, 44);     //设置字符串的宽高  MAXFLOAT为最大宽度极限值  JPSlideBarHeight为固定高度
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.width);     //此方法结合  预编译字符串  字体font  字符串宽高  三个参数计算文本  返回字符串宽度
    
}

- (void)addTitles:(NSArray <NSString *>*)titles controller:(NSArray <UIViewController *>*)vcs{
    NSAssert(titles.count == vcs.count , @"navigationController 不能为空");

    self.titles = titles;
    self.vcs = vcs;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        
        CGFloat w = self.titleView.bounds.size.width;
        
        NSMutableArray *titleL = [NSMutableArray array];
        [titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleL addObject:@([self widthOfString:obj])];
        }];
        CGFloat maxValue = [[titleL valueForKeyPath:@"@max.floatValue"] floatValue];
        
        maxValue += 15;
        
        if ( maxValue < (w / titles.count) ) {
            maxValue = w / titles.count;
            self.titleView.scrollEnabled = NO;
        }
        
        
        self.layout.itemSize = CGSizeMake(maxValue, 44);
        
        
        [self.titleView reloadData];
        self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width * titles.count, 0);
        
        self.selectIndex = 0;


    });

}




- (void)setUI{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;

    NSAssert(self.navigationController != nil, @"navigationController 不能为空");
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *titleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, w, 44) collectionViewLayout:layout];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.dataSource = self;
    titleView.delegate = self;
    [titleView registerClass:[TitleCell class] forCellWithReuseIdentifier:@"cell"];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    self.layout = layout;

    layout.itemSize = CGSizeMake(w, 44);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    titleView.showsHorizontalScrollIndicator = NO;
    titleView.contentInset = UIEdgeInsetsZero;
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [self.view addSubview:contentView];
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    self.contentView = contentView;

    self.titleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.titles.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLB.text = self.titles[indexPath.item];
        cell.titleLB.textColor = (indexPath.item == self.selectIndex)? [UIColor redColor]:[UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.item;
}


#pragma mark - UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll:scrollView];
        }
    }
}

#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
   
    if (scrollView != self.titleView && self.titles) {
        
        
        NSInteger row = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.selectIndex = row+1000;

       
    }

}



- (void)setSelectIndex:(NSInteger)row{
    _selectIndex = row%1000;
    
    
    [UIView performWithoutAnimation:^{
        [self.titleView reloadData];
        [self.titleView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self->_selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        if (row < 1000) {
            [self.contentView setContentOffset:CGPointMake(self->_selectIndex * self.contentView.bounds.size.width, 0) animated:YES];
        }
    }];
    
    
    if(!self.vcs[self->_selectIndex].view.superview){
            [self addChildViewController:self.vcs[self->_selectIndex]];
            [self.contentView addSubview:self.vcs[self->_selectIndex].view];
            CGRect frame = self.vcs[self->_selectIndex].view.bounds;
            frame.origin.x = _selectIndex * self.contentView.bounds.size.width;
            self.vcs[self->_selectIndex].view.frame = frame;
    }

}
@end
