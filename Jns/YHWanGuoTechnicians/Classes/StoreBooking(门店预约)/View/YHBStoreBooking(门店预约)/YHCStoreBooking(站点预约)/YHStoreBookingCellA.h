//
//  YHStoreBookingCellA.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTZPlateTextField.h"
#import "TTZDateTextField.h"

NS_ASSUME_NONNULL_BEGIN

////声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
//typedef void (^BtnClickBlock) (UIButton *button);

@interface YHStoreBookingCellA : UITableViewCell

//@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@property (weak, nonatomic) IBOutlet TTZPlateTextField *plateNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *customerNameTF;
@property (weak, nonatomic) IBOutlet UITextField *customerPhoneTF;
@property (weak, nonatomic) IBOutlet TTZDateTextField *bookDateTF;

@end

NS_ASSUME_NONNULL_END
