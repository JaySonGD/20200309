//
//  YTMobileCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTMobileCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, copy) void (^mobileTfBlock)(NSString *mobile);

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@end

NS_ASSUME_NONNULL_END
