//
//  YHAddPartInfoView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHAddPartInfoView;
@protocol YHAddPartInfoViewDelegate <NSObject>

@required
- (void)YHAddPartInfoView:(YHAddPartInfoView *)infoView changedText:(NSString *)text;

@end

@interface YHAddPartInfoView : UIView

@property (nonatomic, weak) UITextField *inputTft;

@property (nonatomic, weak) id <YHAddPartInfoViewDelegate> delegate;

- (void)setTitleLableText:(NSString *)text;
- (void)setTextFieldPlacehold:(NSString *)placeholdText;

@end
