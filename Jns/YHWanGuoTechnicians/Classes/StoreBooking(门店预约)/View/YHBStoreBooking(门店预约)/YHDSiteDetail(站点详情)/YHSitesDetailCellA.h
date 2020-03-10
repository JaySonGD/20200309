//
//  YHSitesDetailCellA.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSiteDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHSitesDetailCellA : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (weak, nonatomic) IBOutlet UILabel *customerNameL;
@property (weak, nonatomic) IBOutlet UIButton *customerPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *bookDateL;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

- (void)refreshUIWithModel:(YHSiteDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
