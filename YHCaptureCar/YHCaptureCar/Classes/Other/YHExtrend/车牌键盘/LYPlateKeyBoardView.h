//
//  LYPlateKeyBoardView.h
//  LYPlateKeyboard
//
//  Created by 乐浩 on 2017/11/9.
//  Copyright © 2017年 RBJR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYPlateKeyBoardViewDelegate <NSObject>

- (void)clickWithString:(NSString *)string;

- (void)deleteBtnClick;

@end

@interface LYPlateKeyBoardView : UIView

@property (nonatomic, weak) id<LYPlateKeyBoardViewDelegate> delegate;

- (void)deleteEnd;

@end
