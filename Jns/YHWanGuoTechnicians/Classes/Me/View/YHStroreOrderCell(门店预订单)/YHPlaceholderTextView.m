//
//  YHPlaceholderTextView.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/8/7.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHPlaceholderTextView.h"

@implementation YHPlaceholderTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initPrivate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initPrivate];
    }
    return self;
}


- (void)initPrivate {
    
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

/**
 监听文字改变, 立马显示
 */
- (void)textDidChange {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 如果有文字就不绘制占位文字
    if ([self hasText]) {
        return;
    }
    
    // 设置字体属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithCapacity:0];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 设置占位符大小区域
    rect.origin.x = 5;
    rect.origin.y = 7;
    rect.size.width -= 2 * rect.origin.x;
    rect.size.height -= 2 * rect.origin.y;
    
    [self.zyn_placeholder drawInRect:rect
                      withAttributes:attrs];
}

@end
