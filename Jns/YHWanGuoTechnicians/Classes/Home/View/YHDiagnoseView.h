//
//  YHDiagnoseView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface YHDiagnoseView : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *edutBtn;
@property (weak, nonatomic) IBOutlet UITextView *diagnoseTextView;
@property (weak, nonatomic) IBOutlet UILabel *diagnoseTitieL;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (nonatomic,copy) dispatch_block_t editBlock;
@property (nonatomic,copy) NSString *orderType;

@end

NS_ASSUME_NONNULL_END
