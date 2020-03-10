//
//  TTZTagView.m
//  tagView
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTagView.h"
#import "YHCheckProjectModel.h"
#import "YHCommon.h"

@interface TTZTagView ()
@property (nonatomic, strong) NSMutableArray <UIButton *> *views;
@property (nonatomic, strong) NSMutableArray  *frames;
@property (nonatomic, strong) NSMutableArray  <YHlistModel *>*selectModel;
@end


@implementation TTZTagView

- (NSMutableArray *)frames{
    if (!_frames) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}

- (NSMutableArray *)selectModel
{
    if (!_selectModel) {
        _selectModel = [NSMutableArray array];
    }
    return _selectModel;
}

- (NSMutableArray<UIButton *> *)views
{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}


- (void)setModels:(NSArray<YHlistModel *> *)models {
    _models = models;
    [self.views enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.views removeAllObjects];

    [self.selectModel removeAllObjects];
    
//    self.isMultipleChoice = YES;
    
    [self contentHeight:models];
    
    for (NSInteger i = 0; i < models.count; i++) {
        YHlistModel *model = models[i];
        
        (!model.isSelect)?:([self.selectModel addObject:model]);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:YHColorWithHex(0x505050) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.frame = [self.frames[i] CGRectValue];
        kViewBorderRadius(btn, 5, 0.5, YHBackgroundColor);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        btn.selected = model.isSelect;
        
        if (model.isSelect) {
            btn.backgroundColor = YHNaviColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
        
        [self.views addObject:btn];
        
    }
}

- (void)btnClick:(UIButton *)btn{
    
    YHlistModel *model = self.models[btn.tag];
    model.isSelect = !model.isSelect;

    
    if (self.isMultipleChoice) {
      
        if ([self.selectModel containsObject:model]) {
            [self.selectModel removeObject:model];
        }else{
            [self.selectModel addObject:model];
        }
        
    }else{
       YHlistModel *selectedModel = self.selectModel.firstObject;
        [self.selectModel removeAllObjects];

        if (selectedModel != model) {
            selectedModel.isSelect = !model.isSelect;
            [self.selectModel addObject:model];
        }
    }
    
    !(_clickAction)? : _clickAction(self.selectModel);

    [self reload];
    
}

- (void)reload{
    for (NSInteger i = 0; i < self.models.count; i++) {
        YHlistModel *model = self.models[i];
        
        UIButton *btn = self.views[i];
        btn.selected = model.isSelect;
        if (model.isSelect) {
            btn.backgroundColor = YHNaviColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
        
    }
}

- (CGFloat)contentHeight:(NSArray<YHlistModel *> *)models
{
    
    
    [self.frames removeAllObjects];
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat right = 0;
    CGFloat buttom = 8;
    
    for (NSInteger i = 0; i < models.count; i ++) {
        
        CGFloat x=0;
        CGFloat y=0;
        CGFloat w = [models[i].name stringWidthWithFont:[UIFont systemFontOfSize:13] height:30] + 16;
        CGFloat h = 30;
        
        if (self.frames.count < 1) {
            x = left;
            y = top;
            
        }else{
            
            CGRect  lastFrame = [self.frames[i-1] CGRectValue];
            
            CGFloat maxW = CGRectGetMaxX(lastFrame) + 5 + w + right;
            
            if (maxW > [UIScreen mainScreen].bounds.size.width - 24) {
                x = left;
                y = CGRectGetMaxY(lastFrame) + 5;
            }else{
                y = lastFrame.origin.y;
                x = CGRectGetMaxX(lastFrame)+5;
            }
            
        }
        
        CGRect  frame = CGRectMake(x, y, w, h);
        [self.frames addObject: [NSValue valueWithCGRect:frame]];
    }
    return CGRectGetMaxY( [self.frames.lastObject CGRectValue]) + buttom;
}

@end

@implementation NSString (NSStringWidth)
- (CGFloat)stringWidthWithFont:(UIFont *)font height:(CGFloat)height {
    if (self == nil || self.length == 0) {
        return 0;
    }
    
    NSString *copyString = [NSString stringWithFormat:@"%@", self];
    
    CGSize constrainedSize = CGSizeMake(999999, height);
    
    NSDictionary * attribute = @{NSFontAttributeName:font};
    CGSize size = [copyString boundingRectWithSize:constrainedSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return ceilf(size.width);
}
@end
