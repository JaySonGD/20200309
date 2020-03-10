//
//  YHMapSheetView.m
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMapSheetView.h"
#import "YHReservationModel.h"

#import "YHCommon.h"

@interface YHMapSheetView()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLB;
@property (weak, nonatomic) IBOutlet UILabel *telLB;
@property (weak, nonatomic) IBOutlet UILabel *addrLB;
@property (nonatomic, strong) YHReservationModel *model;
@end

@implementation YHMapSheetView

+ (instancetype)mapSheetView{
    return [[NSBundle mainBundle] loadNibNamed:@"YHMapSheetView" owner:nil options:nil].lastObject;
}


+ (instancetype)showAnnotation:(YHReservationModel *)model{
    YHMapSheetView *view = [self mapSheetView];
    view.model = model;
    
    view.titleLB.text = model.name;
    view.contactNameLB.text = model.contact_name;
    view.telLB.text = model.contact_tel;
    view.addrLB.text = model.address;

//    CGFloat h = 263;
//    CGFloat w = [UIScreen mainScreen].bounds.size.width - 8 * 2;
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    view.frame = [UIScreen mainScreen].bounds;//CGRectMake(8, screenH - h, w,h);
    view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:view];

    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    return view;
}
- (IBAction)didSelect {
    !(_didSelectBlock)? : _didSelectBlock(self.model);
    [self hide];
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)call:(id)sender{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.model.contact_tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
