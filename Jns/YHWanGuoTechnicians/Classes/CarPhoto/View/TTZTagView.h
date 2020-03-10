//
//  TTZTagView.h
//  tagView
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHlistModel;

@interface TTZTagView : UIView

@property (nonatomic,assign) BOOL isMultipleChoice;

@property (nonatomic, strong) NSArray<YHlistModel*> *models;

@property (nonatomic, copy) void(^clickAction)(NSArray<YHlistModel*> *);

- (CGFloat)contentHeight:( NSArray<YHlistModel*>*)models;

@end
@interface NSString (NSStringWidth)
- (CGFloat)stringWidthWithFont:(UIFont *)font height:(CGFloat)height;
@end
