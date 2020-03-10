//
//  YHCheckListCell0.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCheckListModel0.h"

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHCheckListCell0 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *carDealerNameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *bookTimeL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UIView *amountV;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UIView *balanceV;
@property(nonatomic, copy) BtnClickBlock btnClickBlock;

- (void)refreshUIWithModel:(YHCheckListModel0 *)model WithBalanceed:(BOOL)isBalanceed;

@end
