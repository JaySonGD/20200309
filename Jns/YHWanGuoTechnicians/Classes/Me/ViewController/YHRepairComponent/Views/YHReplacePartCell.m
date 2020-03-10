//
//  YHReplacePartCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHReplacePartCell.h"
#import "YHSetPartNameView.h"
#import <Masonry.h>

@interface YHReplacePartCell ()

@property (nonatomic, weak) YHSetPartNameView *view;

@end

@implementation YHReplacePartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    YHSetPartNameView *view = [[YHSetPartNameView alloc] init];
    self.view = view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view.superview);
    }];
    view.deleBtnPartNameClickBlock = ^{
        
        if (_replacePartDeleBtnClickBlock) {
            _replacePartDeleBtnClickBlock(self,self.indexPath);
        }
    };
    
    view.removeBtnPartNameClickBlock = ^{
        
        if (_replacePartRemoveBtnClickBlock) {
            _replacePartRemoveBtnClickBlock(self, self.indexPath);
        }
    };
}
- (void)hideRemoveBtn{
    
    self.view.removeBtn.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.deleBtn.hidden = NO;
    }];
}
- (void)setInfoDict:(NSDictionary *)infoDict{
    _infoDict = infoDict;
    self.view.textL.text = infoDict[@"repairProjectName"];
}
- (void)setFrame:(CGRect)frame{
    frame.size.height = frame.size.height - 1;
    [super setFrame:frame];
}
@end
