//
//  YHUserAppointmentDetailView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/10/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHUserAppointmentDetailView.h"


@interface YHUserAppointmentDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *appointmentPlaceNameL;
@property (weak, nonatomic) IBOutlet UILabel *appointmentAdressL;
@property (weak, nonatomic) IBOutlet UILabel *appointmentUserL;

@property (weak, nonatomic) IBOutlet UILabel *userPhoneL;

@property (weak, nonatomic) IBOutlet UILabel *arriveShopTimeL;
@property (weak, nonatomic) IBOutlet UILabel *commentL;

@end

@implementation YHUserAppointmentDetailView

- (void)setNeedData:(NSDictionary *)needData{
    _needData = needData;
   
    self.appointmentUserL.text = needData[@"customer_name"];
    self.appointmentAdressL.text = needData[@"address"];
    self.appointmentPlaceNameL.text = needData[@"shop_name"];
    self.userPhoneL.text = needData[@"customer_phone"];
    NSString *needResult = [NSString stringWithFormat:@"%@",needData[@"arrival_time"]];
    self.arriveShopTimeL.text = IsEmptyStr(needResult) ? @"未设置" : needData[@"arrival_time"];
    self.commentL.text = needData[@"comment"];
}
#pragma mark - 拨打电话 ------
- (IBAction)dialPhoneBtn:(id)sender {
    
    if (self.userPhoneL.text.length <= 0) {
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.userPhoneL.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];

}


@end
