//
//  YHAgreementCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAgreementCell : UITableViewCell

- (void)loadData:(NSDictionary*)info;
- (void)hideInSuranceCompany:(BOOL)isHide;

@end
