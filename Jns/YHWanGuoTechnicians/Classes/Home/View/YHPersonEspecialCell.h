//
//  YHPersonEspecialCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPersonEspecialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicL;

@property (weak, nonatomic) IBOutlet UILabel *detailL;

@property (weak, nonatomic) IBOutlet UILabel *compentL;

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@property (nonatomic, assign) BOOL isRequireCorner;

@end

NS_ASSUME_NONNULL_END
