//
//  TTZTagRightView.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZTagRightView.h"

#import "YHCheckProjectModel.h"

#import "YHCommon.h"

@interface TTZTagRightView()
@property (weak, nonatomic) IBOutlet UIButton *intervalRangeAButton;
@property (weak, nonatomic) IBOutlet UIButton *intervalRangeBButton;
@property (weak, nonatomic) IBOutlet UIButton *intervalRangeCButton;
@property (nonatomic, strong) NSArray<UIButton *> *intervalRangeButtons;
@property (nonatomic, strong) NSMutableArray *selectModel;
@end

@implementation TTZTagRightView

- (NSMutableArray *)selectModel
{
    if (!_selectModel) {
        _selectModel = [NSMutableArray array];
    }
    return _selectModel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    kViewBorderRadius(self.intervalRangeAButton, 5, 0.5, YHBackgroundColor);
    kViewBorderRadius(self.intervalRangeBButton, 5, 0.5, YHBackgroundColor);
    kViewBorderRadius(self.intervalRangeCButton, 5, 0.5, YHBackgroundColor);
    
    self.intervalRangeButtons = @[self.intervalRangeAButton,self.intervalRangeBButton,self.intervalRangeCButton];
    
}

- (void)setModels:(NSArray<YHlistModel *> *)models
{
    _models = models;
    [self.selectModel removeAllObjects];
    
    self.intervalRangeAButton.hidden = self.intervalRangeBButton.hidden = self.intervalRangeCButton.hidden = YES;
    for (NSInteger i = 0; i < models.count; i ++) {
        YHlistModel *listModel = models[i];
        (!listModel.isSelect)?:([self.selectModel addObject:listModel]);
        
        UIButton *btn = self.intervalRangeButtons[i];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",listModel.name] forState:UIControlStateNormal];
        btn.hidden = NO;
        
        btn.selected = listModel.isSelect;
        
        if (listModel.isSelect) {
            btn.backgroundColor = YHNaviColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
        
    }
    
    
}

- (void)reload{
    for (NSInteger i = 0; i < self.models.count; i++) {
        YHlistModel *model = self.models[i];
        
        UIButton *btn = self.intervalRangeButtons[i];
        btn.selected = model.isSelect;
        if (model.isSelect) {
            btn.backgroundColor = YHNaviColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
        
    }
}

#pragma mark  -  事件监听

- (IBAction)intervalButtonClick:(UIButton *)sender {
    
    
    YHlistModel *model = self.models[sender.tag];
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
    
    
    
    //    sender.selected = !sender.isSelected;
    //    sender.backgroundColor = YHNaviColor;
    //    //self.intervalNameLB.text = sender.currentTitle;
    //
    //    if (sender == self.intervalRangeAButton) {
    //        self.intervalRangeBButton.selected = !sender.selected;
    //        self.intervalRangeCButton.selected = !sender.selected;
    //        self.intervalRangeBButton.backgroundColor = [UIColor whiteColor];
    //        self.intervalRangeCButton.backgroundColor = [UIColor whiteColor];
    //
    //
    //    }else if (sender == self.intervalRangeBButton) {
    //
    //        self.intervalRangeAButton.selected = !sender.selected;
    //        self.intervalRangeCButton.selected = !sender.selected;
    //        self.intervalRangeAButton.backgroundColor = [UIColor whiteColor];
    //        self.intervalRangeCButton.backgroundColor = [UIColor whiteColor];
    //
    //
    //    }else if (sender == self.intervalRangeCButton) {
    //        self.intervalRangeAButton.selected = !sender.selected;
    //        self.intervalRangeBButton.selected = !sender.selected;
    //        self.intervalRangeAButton.backgroundColor = [UIColor whiteColor];
    //        self.intervalRangeBButton.backgroundColor = [UIColor whiteColor];
    //
    //    }
}

@end
