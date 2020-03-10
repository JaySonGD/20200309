//
//  YHDeleteRepairCaseView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDeleteRepairCaseView.h"

@implementation YHDeleteRepairCaseView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.topicL.font = [UIFont boldSystemFontOfSize:18.0];
}

+ (YHDeleteRepairCaseView *)alertToView:(UIView *)view{
    
    YHDeleteRepairCaseView *deleteAlertView = [[NSBundle mainBundle] loadNibNamed:@"YHDeleteRepairCaseView" owner:nil options:nil].firstObject;
    deleteAlertView.bounds = CGRectMake(0, 0, 275, 204);
    deleteAlertView.center = view.center;
    
    UIView *hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    deleteAlertView.hudView = hudView;
    hudView.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:hudView];
    [hudView addSubview:deleteAlertView];
    
    return deleteAlertView;
}
- (void)hideDeleteView{
    
    [self.hudView removeFromSuperview];
    self.hudView = nil;
}

@end
