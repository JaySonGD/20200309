//
//  TTZTextView.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZTextView : UIView
    @property (nonatomic, copy) void (^textChange)(NSString *);
@property (nonatomic, copy) NSString *text;
@end
