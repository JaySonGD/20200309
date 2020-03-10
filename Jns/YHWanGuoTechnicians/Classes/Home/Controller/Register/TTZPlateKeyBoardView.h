//
//  TTZPlateKeyBoardView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTZPlateKeyBoardViewDelegate <NSObject>

- (void)clickWithString:(NSString *)string;

- (void)deleteBtnClick;

@end

@interface TTZPlateKeyBoardView : UIView

@property (nonatomic, weak) id<TTZPlateKeyBoardViewDelegate> delegate;

- (void)deleteEnd;
@property (nonatomic, assign,getter=isPunctuation)  BOOL punctuation;

@end
