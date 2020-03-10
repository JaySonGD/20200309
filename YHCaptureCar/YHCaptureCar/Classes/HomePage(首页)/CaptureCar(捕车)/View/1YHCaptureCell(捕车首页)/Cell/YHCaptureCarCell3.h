//
//  YHCaptureCarCell3.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHCaptureCarCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *remindLabel1;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel2;
@property (nonatomic, copy) BtnClickBlock btnClickBlock;

@end
