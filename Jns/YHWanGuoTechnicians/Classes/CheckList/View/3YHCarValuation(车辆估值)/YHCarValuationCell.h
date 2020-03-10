//
//  YHCarValuationCell.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCarValuationModel.h"
//#import "MBProgressHUD+MJ.h"

@interface YHCarValuationCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *referencePriceView;
@property (weak, nonatomic) IBOutlet UILabel *referencePriceLabel;

@property (weak, nonatomic) IBOutlet UIView *setCarPriceView;
@property (weak, nonatomic) IBOutlet UITextField *setCarPriceTextField;

@property (weak, nonatomic) IBOutlet UIView *alreadySetView;
@property (weak, nonatomic) IBOutlet UILabel *alreadySetPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *reportQRCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *reportQRCodeImageView;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, assign) BOOL isHaveDian;

- (void)refreshUIWithModel:(YHCarValuationModel *)model isPush:(BOOL)isPush controller:(UIViewController *)controller shareBtn:(UIButton *)shareBtn pushBtn:(UIButton *)pushBtn;

@end
