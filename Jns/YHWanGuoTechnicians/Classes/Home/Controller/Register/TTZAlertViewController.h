//
//  TTZAlertViewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZAlertViewController : UIViewController
@property (nonatomic, copy) dispatch_block_t checkAction;
@property (nonatomic, copy) dispatch_block_t continueAction;
@end
