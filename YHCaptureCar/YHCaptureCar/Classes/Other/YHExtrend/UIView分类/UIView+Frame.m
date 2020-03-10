//
//  UIView+Frame.m
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
/********* ----------center.x--------- *********/

/**
 设置控件的center.x
 */
- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

/**
 返回控件的center.x
 */
- (CGFloat)centerX{
    return self.center.x;
}

/********* ----------center.y--------- *********/

/**
 设置控件的center.y
 */
- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

/**
 返回控件的center.y
 */
- (CGFloat)centerY{
    return self.center.y;
}

@end
