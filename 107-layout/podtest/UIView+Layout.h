//
//  UIView+Layout.h
//  podtest
//
//  Created by Jay on 18/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface LayoutConstraintModel : NSObject

- (LayoutConstraintModel *(^)(CGFloat constant))constantBlock;

- (LayoutConstraintModel *(^)(CGFloat multiplier))multiplierBlock;

- (LayoutConstraintModel *(^)(NSLayoutRelation layoutRel))layoutRelBlock;

- (LayoutConstraintModel *(^)(NSLayoutAttribute layoutAtt))layoutAttBlock;

- (LayoutConstraintModel *(^)(id relativeToView))relativeToViewBlock;


@end

@interface LayoutModel : NSObject

- (LayoutConstraintModel *(^)(void))lyHeight;
- (LayoutConstraintModel *(^)(void))lyWidth;

- (LayoutConstraintModel *(^)(void))lyCenterX;
- (LayoutConstraintModel *(^)(void))lyCenterY;

- (LayoutConstraintModel *(^)(void))lyRight;
- (LayoutConstraintModel *(^)(void))lyleft;
- (LayoutConstraintModel *(^)(void))lyTop;
- (LayoutConstraintModel *(^)(void))lyButtom;

@end

@interface NSLayoutConstraint (Layout)
- (void)remove;
@end

@interface UIView (Layout)

- (NSLayoutConstraint *)lyHeight;
- (NSLayoutConstraint *)lyWidth;

- (NSLayoutConstraint *)lyCenterX;
- (NSLayoutConstraint *)lyCenterY;

- (NSLayoutConstraint *)lyRight;
- (NSLayoutConstraint *)lyleft;
- (NSLayoutConstraint *)lyTop;
- (NSLayoutConstraint *)lyButtom;


- (void)setLayout:(void (^__nullable)(LayoutModel *layout))layout;

////////////

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@end

NS_ASSUME_NONNULL_END
