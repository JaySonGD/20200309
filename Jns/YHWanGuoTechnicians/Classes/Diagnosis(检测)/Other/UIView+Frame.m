#import "UIView+Frame.h"

@implementation UIView (Frame)
/********* ----------x--------- *********/

/**
 设置控件的X位置
 */
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
/**
 返回控件的X位置
 */
- (CGFloat)x{
    return self.frame.origin.x;
}

/********* ----------y--------- *********/

/**
 设置控件的Y位置
 */
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/**
 返回控件的Y位置
 */
- (CGFloat)y{
    return self.frame.origin.y;
}

/********* ---------width---------- *********/

/**
 设置控件的width
 */
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/**
 返回控件的width
 */
- (CGFloat)width{
    return self.frame.size.width;
}

/********* ----------height--------- *********/

/**
 设置控件的height
 */
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 返回控件的height
 */
- (CGFloat)height{
    return self.frame.size.height;
}

/********* ----------size--------- *********/

/**
 设置控件的size
 */
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

/**
 返回控件的size
 */
- (CGSize)size{
    return self.frame.size;
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
