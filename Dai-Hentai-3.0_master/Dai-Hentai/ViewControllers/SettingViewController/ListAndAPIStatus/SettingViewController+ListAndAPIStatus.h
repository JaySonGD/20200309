//
//  SettingViewController+ListAndAPIStatus.h
//  Dai-Hentai
//
//  Created by DaidoujiChen on 2018/3/11.
//  Copyright © 2018年 DaidoujiChen. All rights reserved.
//

#import "PrivateSettingViewController.h"

@interface SettingViewController (ListAndAPIStatus)

- (UIViewController *)checkViewControllerBy:(NSString *)reuseIdentifier;
- (void)displayListAndAPIStatus;

@end
