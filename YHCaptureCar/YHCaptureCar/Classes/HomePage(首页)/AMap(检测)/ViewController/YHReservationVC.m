//
//  YHReservationVC.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHReservationVC.h"

@interface YHReservationVC ()
    
    /**
     详情
     */
    @property (weak, nonatomic) IBOutlet UILabel *detailsMsg;
    
    /**
     联系人
     */
    @property (weak, nonatomic) IBOutlet UILabel *contact;
    
    /**
     联系电话
     */
    @property (weak, nonatomic) IBOutlet UILabel *tel;

/**
 预约button
 */
@property (weak, nonatomic) IBOutlet UIButton *reservationBtn;

@end

@implementation YHReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //弹框赋值
    self.detailsMsg.text = self.reservationM.name;
    self.contact.text = self.reservationM.contactName;
    self.tel.text = self.reservationM.tel;
    self.reservationBtn.layer.cornerRadius = 8.0f;
    self.reservationBtn.layer.masksToBounds = YES;
}

    
/**
进行新增预约VC
 */
- (IBAction)reservation:(UIButton *)sender {
//    if(self.callback){
//        self.callback(nil);
//    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pushToNewReservationVCWithReserM:)]) {
        [self.delegate pushToNewReservationVCWithReserM:self.reservationM];
    }
}


/**
打电话
 */
- (IBAction)call:(UIButton *)sender {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.tel.text];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
