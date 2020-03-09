//
//  UIView+Layout.m
//  podtest
//
//  Created by Jay on 18/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>

@interface  LayoutModel()

@property (nonatomic, strong) LayoutConstraintModel *heightModel;
@property (nonatomic, strong) LayoutConstraintModel *widthModel;
@property (nonatomic, strong) LayoutConstraintModel *centerXModel;
@property (nonatomic, strong) LayoutConstraintModel *centerYModel;
@property (nonatomic, strong) LayoutConstraintModel *rightModel;
@property (nonatomic, strong) LayoutConstraintModel *leftModel;
@property (nonatomic, strong) LayoutConstraintModel *topModel;
@property (nonatomic, strong) LayoutConstraintModel *buttomtModel;

@end


@implementation LayoutModel

- (LayoutConstraintModel * (^)(void))lyHeight{
    return ^(void){
        if (!self.heightModel) {
            self.heightModel = [LayoutConstraintModel new];
        }
        return self.heightModel;
    };
}

- (LayoutConstraintModel * _Nonnull (^)(void))lyWidth{
    return ^(void){
        if (!self.widthModel) {
            self.widthModel = [LayoutConstraintModel new];
        }
        return self.widthModel;
    };
}

- (LayoutConstraintModel * _Nonnull (^)(void))lyCenterX{
    return ^(void){
        if (!self.centerXModel) {
            self.centerXModel = [LayoutConstraintModel new];
        }
        return self.centerXModel;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(void))lyCenterY{
    return ^(void){
        if (!self.centerYModel) {
            self.centerYModel = [LayoutConstraintModel new];
        }
        return self.centerYModel;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(void))lyRight{
    return ^(void){
        if (!self.rightModel) {
            self.rightModel = [LayoutConstraintModel new];
        }
        return self.rightModel;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(void))lyleft{
    return ^(void){
        if (!self.leftModel) {
            self.leftModel = [LayoutConstraintModel new];
        }
        return self.leftModel;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(void))lyTop{
    return ^(void){
        if (!self.topModel) {
            self.topModel = [LayoutConstraintModel new];
        }
        return self.topModel;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(void))lyButtom{
    return ^(void){
        if (!self.buttomtModel) {
            self.buttomtModel = [LayoutConstraintModel new];
        }
        return self.buttomtModel;
    };
}

@end

@interface LayoutConstraintModel ()

//view1.att1 =（以等号举栗子，layoutRel可> < ≥≤）relativeToView.layoutAtt * multiplier + constant;

/** 相对于谁布局 (除了hight/width（默认是nil） 外默认是父控件)*/
@property (nonatomic, weak) id relativeToView;
/** 相对于那个属性 （上下...）*/
@property (nonatomic, assign) NSLayoutAttribute layoutAtt;

@property (nonatomic, assign) NSLayoutRelation layoutRel;
/** 多少倍*/
@property (nonatomic, assign) CGFloat multiplier;
/** 相差多少*/
@property (nonatomic, assign) CGFloat constant;

@end

@implementation LayoutConstraintModel
{
     BOOL _relativeToViewBak;
}
@synthesize relativeToView  = _relativeToView;

- (void)setRelativeToView:(id)relativeToView{
    _relativeToViewBak = YES;
    _relativeToView = relativeToView;
}
- (id)relativeToView{
    if (_relativeToViewBak) {
        return _relativeToView;
    }
    
    return [NSNull null];
}


- (LayoutConstraintModel * _Nonnull (^)(CGFloat))constantBlock{
    return ^(CGFloat constant){
        self.constant = constant;
        return self;
    };
}

- (LayoutConstraintModel * _Nonnull (^)(CGFloat))multiplierBlock{
    return ^(CGFloat multiplier){
        self.multiplier = multiplier;
        return self;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(NSLayoutRelation))layoutRelBlock{
    return ^(NSLayoutRelation layoutRel){
        self.layoutRel = layoutRel;
        return self;
    };
}
- (LayoutConstraintModel * _Nonnull (^)(NSLayoutAttribute))layoutAttBlock{
    return ^(NSLayoutAttribute layoutAtt){
        self.layoutAtt = layoutAtt;
        return self;
    };
}

- (LayoutConstraintModel * _Nonnull (^)(id _Nonnull))relativeToViewBlock{
    return ^(id relativeToView){
        self.relativeToView = relativeToView;
        return self;
    };
}




@end
@implementation NSLayoutConstraint (Layout)

- (void)remove{
    UIView *Self = self.firstItem;
    if([Self isKindOfClass:[UIView class]]) [Self.superview removeConstraint:self];
}
@end
@implementation UIView (Layout)


- (void)setLayout:(void (^)(LayoutModel * _Nonnull))layout{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    LayoutModel *model = [LayoutModel new];
    !(layout)? : layout(model);

    if (model.heightModel) {
        [self setLyHeight:model.heightModel];
    }
    
    if (model.widthModel) {
        [self setLyWidth:model.widthModel];
    }
    if (model.centerXModel) {
        [self setLyCenterX:model.centerXModel];
    }
    if (model.centerYModel) {
        [self setLyCenterY:model.centerYModel];
    }
    if (model.topModel) {
        [self setLyTop:model.topModel];
    }

    if (model.buttomtModel) {
        [self setLyButtom:model.buttomtModel];
    }

    if (model.leftModel) {
        [self setLyleft:model.leftModel];
    }
    if (model.rightModel) {
        [self setLyRight:model.rightModel];
    }


    NSLog(@"%s", __func__);
}

- (NSLayoutConstraint *)lyHeight{
    return objc_getAssociatedObject(self, @"lyHeight");
}

//- (void)setLyHeight:(void (^)(LayoutModel * layout))lyHeight{
- (void)setLyHeight:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    //LayoutModel *model = [LayoutModel new];
    //!(lyHeight)? : lyHeight(model);
    
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        //model.relativeToView = self.superview;
        model.relativeToView = nil;
    }
    
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeHeight;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }
    

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:model.relativeToView
                                 attribute:model.layoutAtt
                                multiplier:model.multiplier
                                constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyHeight", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutConstraint *)lyWidth{
    return objc_getAssociatedObject(self, @"lyWidth");
}

//- (void)setLyWidth:(void (^)(LayoutModel *))lyWidth{
- (void)setLyWidth:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutModel *model = [LayoutModel new];
    //!(lyWidth)? : lyWidth(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        //model.relativeToView = self.superview;
        model.relativeToView = nil;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeWidth;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:model.relativeToView
                                 attribute:model.layoutAtt
                                multiplier:model.multiplier
                                  constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyWidth", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyCenterX{
    return objc_getAssociatedObject(self, @"lyCenterX");
}
//- (void)setLyCenterX:(void (^)(LayoutModel *))lyCenterX{
- (void)setLyCenterX:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutModel *model = [LayoutModel new];
    //!(lyCenterX)? : lyCenterX(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeCenterX;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyCenterX", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutConstraint *)lyCenterY{
    return objc_getAssociatedObject(self, @"lyCenterY");
}

//- (void)setLyCenterY:(void (^)(LayoutModel  *))lyCenterY{
- (void)setLyCenterY:(LayoutConstraintModel  *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutModel *model = [LayoutModel new];
    //!(lyCenterY)? : lyCenterY(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeCenterY;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyCenterY", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyTop{
    return objc_getAssociatedObject(self, @"lyTop");
}
//- (void)setLyTop:(void (^)(LayoutConstraintModel *))lyTop{
- (void)setLyTop:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutConstraintModel *model = [LayoutConstraintModel new];
    //!(lyTop)? : lyTop(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeTop;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyTop", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyleft{
    return objc_getAssociatedObject(self, @"lyleft");
}

//-(void)setLyleft:(void (^)(LayoutConstraintModel *))lyleft{
-(void)setLyleft:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutConstraintModel *model = [LayoutConstraintModel new];
    //!(lyleft)? : lyleft(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeLeft;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyleft", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSLayoutConstraint *)lyRight{
    return objc_getAssociatedObject(self, @"lyRight");
}

//- (void)setLyRight:(void (^)(LayoutConstraintModel *))lyRight{
- (void)setLyRight:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutConstraintModel *model = [LayoutConstraintModel new];
    //!(lyRight)? : lyRight(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeRight;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyRight", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSLayoutConstraint *)lyButtom{
    return objc_getAssociatedObject(self, @"lyButtom");
}

//- (void)setLyButtom:(void (^)(LayoutConstraintModel *))lyButtom{
- (void)setLyButtom:(LayoutConstraintModel *)model{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    //LayoutConstraintModel *model = [LayoutConstraintModel new];
    //!(lyButtom)? : lyButtom(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeBottom;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyButtom", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


////////////////////
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    
    center.x = centerX;
    
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
@end
