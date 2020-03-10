//
//  YHChooseView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHPhotoModel,TTZTextView;
@interface YHChooseView : UIView
+ (instancetype)chooseView;

@property (nonatomic, copy) void (^buttonClick)(UIButton *);
@property (nonatomic, copy) void (^otherClick)(NSInteger,UIView *);
@property (nonatomic, copy) void (^exampleClick)(NSInteger);

@property (weak, nonatomic) IBOutlet TTZTextView *textView;

@property (nonatomic, strong) NSArray <YHPhotoModel *>*models;
@property (nonatomic, strong) NSMutableArray <YHPhotoModel *>*otherModels;

@end


@interface YHOtherPhotoCell : UICollectionViewCell
@end
