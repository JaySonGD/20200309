//
//  BlockButton.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/3/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(UIButton * button);

@interface BlockButton : UIButton

@property (nonatomic, copy) Block block;
@end
