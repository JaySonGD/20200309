//
//  YHMarkCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/8/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YHMark) {
    YHMarkCurrent ,//当前
    YHMarkPreviousStepTwo ,//倒数第二步
    YHMarkPreviousStep ,//过程
    YHMarkComplete ,//完成
};
@interface YHMarkCell : UITableViewCell

- (void)loadDatasource:(NSDictionary*)info state:(YHMark)state;
@end
