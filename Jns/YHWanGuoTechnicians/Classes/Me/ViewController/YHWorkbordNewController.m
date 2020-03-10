//
//  YHWorkbordNewController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/28.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkbordNewController.h"
#import "YHSuccessController.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "YHWorkboardListController.h"

@interface YHWorkbordNewController ()
@property (weak, nonatomic) IBOutlet UITextField *carNumberF;
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UIButton *dateB;
@property (weak, nonatomic) IBOutlet UIButton *service1;
@property (weak, nonatomic) IBOutlet UIButton *service2;
@property (weak, nonatomic) IBOutlet UIButton *service3;
- (IBAction)serviceActions:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameF;


@property (strong, nonatomic)NSString *dateStr;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateP;
@property (weak, nonatomic) IBOutlet UIView *datePBox;
- (IBAction)dateComfirmAction:(id)sender;
- (IBAction)dateCancelAction:(id)sender;
@property (strong, nonatomic)NSString *date;
@property (nonatomic)YHWorkbordServiceType type;
- (IBAction)dateAction:(id)sender;
@end

@implementation YHWorkbordNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _type = YHWorkbordServiceTypeW;
    self.dateP.minimumDate = [NSDate date];
    
    if (self.isPushByWorkListDetail == YES) {
        self.carNumberF.text = [NSString stringWithFormat:@"%@ %@%@", EmptyStr(_uesrInfo[@"plateNumberP"]), EmptyStr(_uesrInfo[@"plateNumberC"]),EmptyStr(_uesrInfo[@"plateNumber"])];
    }

    self.nameF.text = EmptyStr(_uesrInfo[@"name"]);
    self.phoneF.text = EmptyStr(_uesrInfo[@"phone"]);
}

- (IBAction)serviceActions:(UIButton*)button {
    _type = button.tag;
    [@[_service1, _service2, _service3]enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = NO;
    }];
    button.selected = YES;
}

- (IBAction)dateComfirmAction:(id)sender {
    _datePBox.hidden = YES;
    self.date = [YHTools stringFromDate:_dateP.date byFormatter:@"yyyy-MM-dd"];
    _dateStr = self.date;
    _dateB.titleLabel.text = _dateStr;
    [_dateB setTitle:_dateStr forState:UIControlStateNormal];
}

- (IBAction)dateCancelAction:(id)sender {
    _datePBox.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_phoneF == textField) {
        if ([textField.text length]>=11)
            return NO;
    }
    return YES;
}

- (IBAction)addAction:(id)sender {
    NSString *plateNumberP = @"";
    NSString *plateNumberC = @"";
    NSString *plateNumber = @"";
    if (_carNumberF.text.length == 0) {
        [MBProgressHUD showError:@"请输入正确车牌号码"];
        return;
    }else{
        if ((_carNumberF.text.length >= 7) && (_carNumberF.text.length <= 9)) {
            plateNumberP = [_carNumberF.text substringWithRange:NSMakeRange(0, 1)];
            plateNumberC = [_carNumberF.text substringWithRange:NSMakeRange(1, 1)];
            plateNumber = [_carNumberF.text substringWithRange:NSMakeRange(2, _carNumberF.text.length - 2)];
        } else {
            [MBProgressHUD showError:@"请输入正确车牌号码"];
            return;
        }
    }
    if ([_phoneF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入正确联系号码"];
        return;
    }
    if ([_nameF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入客户名称"];
        return;
    }
    
    if (!_dateStr || [_dateStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"请请选择日期"];
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]addWorkboard:[YHTools getAccessToken]
                                                     serviceType:[NSString stringWithFormat:@"%ld", _type]
                                                 appointmentDate:_dateStr
                                                    plateNumberP:plateNumberP
                                                    plateNumberC:plateNumberC
                                                     plateNumber:plateNumber
                                                            name:_nameF.text
                                                           phone:_phoneF.text
                                                      customerId:EmptyStr(self.uesrInfo[@"customerId"])
                                                             vin:EmptyStr(self.uesrInfo[@"vin"])
                                                      onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//             UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//             YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
//             controller.titleStr = @"新增成功";
//             [weakSelf.navigationController pushViewController:controller animated:YES];
             
             [MBProgressHUD showError:@"新增成功" toView:weakSelf.navigationController.view];
             
             for (UIViewController *VC in weakSelf.navigationController.viewControllers) {
                 if ([VC isKindOfClass:[YHWorkboardListController class]]) {
                     [weakSelf.navigationController popToViewController:VC animated:YES];
                 }
             }
             
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 [weakSelf showErrorInfo:info];
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}
- (IBAction)dateAction:(id)sender {
    _datePBox.hidden = NO;
}
@end
