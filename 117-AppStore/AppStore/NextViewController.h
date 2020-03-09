//
//  NextViewController.h
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NextViewController : UIViewController
- (instancetype)initWithColor:(UIColor *)color bgView:(UIView *)bgView;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UITableView *listView;

@end

NS_ASSUME_NONNULL_END
