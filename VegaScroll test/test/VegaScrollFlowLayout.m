//
//  VegaScrollFlowLayout.m
//  test
//
//  Created by Jay on 5/11/2019.
//  Copyright © 2019 HKV_. All rights reserved.
//

#import "VegaScrollFlowLayout.h"

@interface VegaScrollFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet <NSIndexPath *> *visibleIndexPaths;
@property (nonatomic, assign) CGFloat latestDelta;


@property (nonatomic, assign) CATransform3D transformIdentity;

@end



@implementation VegaScrollFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize{
    self.springHardness = 15;
    self.isPagingEnabled = YES;
    self.transformIdentity = CATransform3DIdentity;
    self.visibleIndexPaths = [NSMutableSet set];
    
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
}


- (void)resetLayout{
    [self.dynamicAnimator removeAllBehaviors];
    [self prepareLayout];
}

//1.实现
//(目的:做一些初始化;用来做布局的初始化操作(不建议在init方法里面做布局的初始化操作))
- (void)prepareLayout{
    [super prepareLayout];
    
    
    CGFloat expandBy = -100;
    CGRect visibleRect = CGRectInset(CGRectMake(self.collectionView.bounds.origin.x, self.collectionView.bounds.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height), 0, expandBy);
    
    
    NSArray< UICollectionViewLayoutAttributes *>*visibleItems = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSMutableArray *indexs = [NSMutableArray array];
    [visibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexs addObject:obj.indexPath];
    }];
    
    NSSet *indexPathsInVisibleRect = [NSSet setWithArray:indexs];
    [self removeNoLongerVisibleBehaviors:indexPathsInVisibleRect];
    
    NSMutableArray *newlyVisibleItems = [NSMutableArray array];
    [visibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.visibleIndexPaths containsObject:obj.indexPath]) {
            [newlyVisibleItems addObject:obj];
        }
    }];
    [self addBehaviors:newlyVisibleItems];
}

//2.实现
//(目的:拿出它计算好的布局属性来做一个微调,实现cell不断变大变小)
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *dynamicItems = [self.dynamicAnimator itemsInRect:rect];
    
    [dynamicItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat convertedY = item.center.y - self.collectionView.contentOffset.y - self.sectionInset.top;
        item.zIndex = item.indexPath.row;
//        [self headerTransformItemIfNeeded:convertedY attributes:item];
//        [self footerTransformItemIfNeeded:convertedY attributes:item];
    }];
    return dynamicItems;
}

//3.实现
//(目的:当我们手一松开,它最终停止滚动的时候,应该去在哪.它决定了collectionView停止滚动时候的偏移量)
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGPoint latestOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    if (!self.isPagingEnabled) {
        return latestOffset;
    }
    
    CGFloat row = roundf((proposedContentOffset.y *1.0 / self.itemSize.height + self.minimumLineSpacing));
    CGFloat calculatedOffset = row * self.itemSize.height + row * self.minimumLineSpacing;
    CGPoint targetOffset = CGPointMake(latestOffset.x, calculatedOffset);
    return targetOffset;
}



//4.实现
//(只要滑动就会重新刷新,就会调用prepareLayout和layoutAttributesForElementsInRect方法)
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    CGFloat delta  = newBounds.origin.y - self.collectionView.bounds.origin.y;
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(__kindof UIAttachmentBehavior * _Nonnull behavior, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attrs =(UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        attrs.center  = [self getUpdatedBehaviorItemCenter:behavior touchLocation:touchLocation];
        [self.dynamicAnimator updateItemUsingCurrentState:attrs];
    }];
    return NO;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}







- (void)footerTransformItemIfNeeded:(CGFloat )y attributes:(UICollectionViewLayoutAttributes *)item{
    
    if (self.itemSize.height && y > (self.collectionView.bounds.size.height - self.itemSize.height*0.5)) {
        
        CGFloat maxH = self.collectionView.bounds.size.height;
        
        CGFloat scaleFactor = [self scaleDistributor:maxH - y];
        CGFloat yDelta = -[self getYDelta:maxH - y];
        //CATransform3D transformIdentity = CATransform3DIdentity;
        item.transform3D = CATransform3DScale(self.transformIdentity, 0, yDelta, yDelta);
        item.transform3D = CATransform3DScale(item.transform3D, scaleFactor, scaleFactor, scaleFactor);
        item.alpha = [self alphaDistributor:maxH - y];
    }
}


- (void)headerTransformItemIfNeeded:(CGFloat )y attributes:(UICollectionViewLayoutAttributes *)item{
    
    if (self.itemSize.height && y < self.itemSize.height * 0.5) {
        CGFloat scaleFactor = [self scaleDistributor:y];
        CGFloat yDelta = [self getYDelta:y];
        item.transform3D = CATransform3DScale(self.transformIdentity, 0, yDelta, 0);
        item.transform3D = CATransform3DScale(item.transform3D, scaleFactor, scaleFactor, scaleFactor);
        item.alpha = [self alphaDistributor:y];
    }
}





- (void)removeNoLongerVisibleBehaviors:(NSSet *)indexPaths{
    
    NSMutableArray *noLongerVisibleBehaviours = [NSMutableArray array];
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(__kindof UIAttachmentBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)obj.items.firstObject;
        
        if ([obj isKindOfClass:[UIAttachmentBehavior class]] && [item isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            if (![indexPaths containsObject:item.indexPath]) {
                [noLongerVisibleBehaviours addObject:obj];
            }
        }
    }];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(  UIAttachmentBehavior * behavior, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![behavior isKindOfClass:[UIAttachmentBehavior class]]) {
            return;
        }
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        
        if (![item isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            return;
        }

        
        [self.dynamicAnimator removeBehavior:behavior];
        [self.visibleIndexPaths removeObject:item.indexPath];
    }];

}

- (void)addBehaviors:(NSArray <UICollectionViewLayoutAttributes *>*)items{
    
    if (!self.collectionView) return;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [items enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:obj.center];
        springBehaviour.length = 0.0;
        springBehaviour.damping = 0.8;
        springBehaviour.frequency = 1.0;
        if (!CGPointEqualToPoint(touchLocation, CGPointZero)) {
            obj.center = [self getUpdatedBehaviorItemCenter:springBehaviour touchLocation:touchLocation];
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPaths addObject:obj.indexPath];
    }];
}


- (CGPoint )getUpdatedBehaviorItemCenter:(UIAttachmentBehavior *)behavior
                           touchLocation:(CGPoint )touchLocation{
    
    CGFloat yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
    CGFloat xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
    CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / (self.springHardness * 100.0);
    
    UICollectionViewLayoutAttributes  *attrs =  (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
    CGPoint center = attrs.center;
    if (self.latestDelta < 0) {
        center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
    }else{
        center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
    }
    
    return center;
}



- (CGFloat )distributor:(CGFloat)y
              threshold:(CGFloat)threshold
                xOrigin:(CGFloat)xOrigin{
    if (threshold > xOrigin) {
        CGFloat arg =  (y - xOrigin)/(threshold - xOrigin);
        arg = arg? arg : 0;
        CGFloat y = sqrtf(arg);
        return (y>1)? 1 : y;
    }
    
    return 1;
}

- (CGFloat )scaleDistributor:(CGFloat )y{
    return [self distributor:y threshold:self.itemSize.height * 0.5 xOrigin:-self.itemSize.height * 5];
}


- (CGFloat )alphaDistributor:(CGFloat )y{
    return [self distributor:y threshold:self.itemSize.height * 0.5 xOrigin:-self.itemSize.height];
}


- (CGFloat )getYDelta:(CGFloat )y{
    return self.itemSize.height * 0.5 - y;
}


@end
