//
//  YHOrderDetailTopContainView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHOrderDetailTopContainView : UIView

@property (nonatomic, copy)void(^topButtonClickedBlock)(UIButton *btn);

@property (nonatomic, copy) NSArray <NSString *>*titleArr;

@end
