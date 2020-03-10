//
//  YTPayInfoController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 21/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTPayInfoController.h"
#import "YTTopupViewController.h"
#import "YHWebFuncViewController.h"

#import "YHCarPhotoService.h"
#import "YTPayModeInfo.h"
#import "WXPay.h"

#import <MJExtension.h>

@interface YTPayInfoController ()<UITextFieldDelegate>
@property (nonatomic, copy) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topupHeight;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTft;
@property (weak, nonatomic) IBOutlet UILabel *orgPointLB;
@property (weak, nonatomic) IBOutlet UILabel *needPayPointLB;
@property (weak, nonatomic) IBOutlet UILabel *needPayNameLB;
@property (weak, nonatomic) IBOutlet UILabel *wxNeedPayNameLB;
@property (weak, nonatomic) IBOutlet UILabel *wxNeedPayPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *carNeedPayNameLB;
@property (weak, nonatomic) IBOutlet UILabel *carNeedPayPriceLB;




@property (weak, nonatomic) IBOutlet UILabel *pointNameLB;
@property (weak, nonatomic) IBOutlet UILabel *wxNameLB;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLB;
@property (nonatomic, copy) NSString *inputStr;

@property (weak, nonatomic) IBOutlet UIButton *pointBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *ownerBtn;

@property (nonatomic, strong) NSArray <UIButton *> *btns;
@property (weak, nonatomic) IBOutlet UILabel *topupLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ownerHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointNameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viHeight;
@property (nonatomic, strong) YTPayModeInfo *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointH;

@end

@implementation YTPayInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneNumberTft];
    self.btns = @[self.pointBtn,self.wxBtn,self.ownerBtn];
    //self.pointBtn.selected = YES;
    
    //self.billId = @"2332";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] getPayModeInfo:self.billId success:^(YTPayModeInfo *model) {
        self.model = model;
        [model.pay_mode enumerateObjectsUsingBlock:^(YTPayMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.type isEqualToString:@"ORG_POINTS"]) {
                self.pointNameLB.text = obj.name;
                self.pointBtn.tag = idx;
                
                self.needPayPointLB.text = [NSString stringWithFormat:@"%@",obj.price];
                self.needPayNameLB.text = obj.need_pay_name;
                self.pointNameHeight.constant = 22.0;
//                self.viHeight.constant = 30;

//                if (model.org_point.doubleValue < fabs(obj.price.doubleValue))
//                {
//                    self.topupHeight.constant = 30;
////                    self.viHeight.constant = 66;
//
//                }else{
////                    self.topupHeight.constant = 0;
//                }

                
            }else if ([obj.type isEqualToString:@"ORG_WX"]) {
                self.wxNameLB.text = obj.name;
                self.wxHeight.constant = 54;//+17;
                self.wxBtn.tag = idx;
                self.wxNeedPayNameLB.text = obj.need_pay_name;
                self.wxNeedPayPriceLB.text = [NSString stringWithFormat:@"¥%@",obj.price];
                
            }else if ([obj.type isEqualToString:@"OWNER"]) {
                self.ownerNameLB.text = obj.name;
                self.ownerHeight.constant = 54;//+27;
                self.ownerBtn.tag = idx;
                self.carNeedPayNameLB.text = [NSString stringWithFormat:@"由车主承担支付费用,,由车主承担支付费用¥%@,付费完后车主可直接查看检测报告                        ",obj.price];//
                //;//obj.need_pay_name;
//                self.carNeedPayPriceLB.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }
            
        }];
        
        
        self.orgPointLB.text = model.org_point;
        
        self.phoneNumberTft.text = model.mobile;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.model.pay_mode.count == 1) {
            YTPayMode *obj = self.model.pay_mode.firstObject;
            if ([obj.type isEqualToString:@"OWNER"]) {
                [self btnClick:self.ownerBtn];
            }else if ([obj.type isEqualToString:@"ORG_WX"]){
                [self btnClick:self.wxBtn];

            }else if ([obj.type isEqualToString:@"ORG_POINTS"]){
                [self btnClick:self.pointBtn];
            }
        }
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (IBAction)determinePay:(UIButton *)sender {
    
    
    __block NSInteger index = -1;
    
    [self.btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected) {
            index = obj.tag;
            *stop = YES;
        }
    }];
    
    if (index>=0 || self.model.pay_mode.count == 0) {
        
        YTPayMode *mode = self.model.pay_mode.count? self.model.pay_mode[index] : nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[YHCarPhotoService new] determinePayMode:self.billId payType:mode.type mobile:self.phoneNumberTft.text success:^(NSDictionary *obj) {
            
            if (!obj) {
                [MBProgressHUD hideHUDForView:self.view];
                [self pushReport];
                return ;
            }
            
            //
            [[WXPay sharedWXPay] payByParameter:obj success:^{
                [MBProgressHUD showError:@"支付成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self pushReport];
                });
            } failure:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"支付失败！"];
            }];

            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        }];
        
        return;
    }
    
    [MBProgressHUD showError:@"请选择支付方式！"];

}

- (void)pushReport{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[YHCarPhotoService new] saveStorePushNewWholeCarReport:self.billId phone:self.phoneNumberTft.text success:^(NSDictionary *obj) {
        [self app2H5];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
//    }];
}

- (void)app2H5{
    
//    [self popViewController:nil];
//    YHWebFuncViewController *vc = [self.navigationController.childViewControllers lastObject];
//
//    NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"payOrder",@"bill_id":self.billType,@"bill_type":self.billType} mj_JSONString];
//    [vc appToH5:json];
    
        __block UIViewController *vc = nil;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHOrderListController")]) {
                [[NSNotificationCenter
                  defaultCenter] postNotificationName:@"YHNotificationOrderListChange" object:Nil userInfo:nil];
                vc = obj;
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    
    if (!vc) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (CGFloat)wxNeedPayNameH{
    return  [self.wxNeedPayNameLB.text boundingRectWithSize:CGSizeMake(self.wxNeedPayNameLB.frame.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.wxNeedPayNameLB.font}
                                          context:nil].size.height;
}

- (CGFloat)carNeedPayNameH{
    
    return  [self.carNeedPayNameLB.text boundingRectWithSize:CGSizeMake(self.carNeedPayNameLB.frame.size.width, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:self.carNeedPayNameLB.font}
                                                    context:nil].size.height+10;
}


- (IBAction)btnClick:(UIButton *)sender {
    
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        [self.btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        sender.selected = YES;
    }
    
    YTPayMode *obj = self.model.pay_mode[sender.tag];
    if (self.wxHeight.constant >0 ) {
        self.wxHeight.constant = 54;
    }
    if (self.ownerHeight.constant >0 ) {
        self.ownerHeight.constant = 54;
        self.topupHeight.constant = 0;
    }

  
    
    self.pointH.constant = 0;


    if (sender.isSelected) {

        if (sender == self.wxBtn ) {
            self.wxHeight.constant = 54+ (self.ownerHeight.constant?17:27);
        }else if (sender == self.ownerBtn) {
            self.ownerHeight.constant = 54+self.carNeedPayNameH;
        }else{
            self.pointH.constant = 44;
            if (self.model.org_point.doubleValue < fabs(obj.price.doubleValue)){
                self.topupHeight.constant = 30;
            }
        }
    }


}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
//    YTTopupViewController.h
   YTTopupViewController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTTopupViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldContentChange:(NSNotification *)noti{
//    [self formatPhoneNumber:self.phoneNumberTft];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //137 2537 5617
    if (textField.text.length >=11 && !IsEmptyStr(string)) {
        return NO;
    }
//    self.inputStr = string;
//    self.previousTextFieldContent = textField.text;
//    self.previousSelection = textField.selectedTextRange;
    return YES;
}

//- (void)formatPhoneNumber:(UITextField*)textField
//{
//    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
//    NSLog(@"targetCursorPosition:%li", (long)targetCursorPosition);
//    // nStr表示不带空格的号码
//    NSString* nStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString* preTxt = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" "
//                                                                                withString:@""];
//    char editFlag = 0;// 正在执行删除操作时为0，否则为1
//
//    if (nStr.length <= preTxt.length) {
//        editFlag = 0;
//    }
//    else {
//        editFlag = 1;
//    }
//
//    // textField设置text
//    if (nStr.length > 11)
//    {
//        textField.text = self.previousTextFieldContent;
//        textField.selectedTextRange = self.previousSelection;
//        return;
//    }
//
//    // 空格
//    NSString* spaceStr = @" ";
//
//    NSMutableString* mStrTemp = [NSMutableString new];
//    int spaceCount = 0;
//    if (nStr.length < 3 && nStr.length > -1)
//    {
//        spaceCount = 0;
//    }else if (nStr.length < 7 && nStr.length >2)
//    {
//        spaceCount = 1;
//
//    }else if (nStr.length < 12 && nStr.length > 6)
//    {
//        spaceCount = 2;
//    }
//
//    for (int i = 0; i < spaceCount; i++)
//    {
//        if (i == 0) {
//            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)], spaceStr];
//        }else if (i == 1)
//        {
//            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
//        }else if (i == 2)
//        {
//            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
//        }
//    }
//
//    if (nStr.length == 11)
//    {
//        [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
//    }
//
//    if (nStr.length < 4)
//    {
//        [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length-nStr.length % 3,
//                                                                    nStr.length % 3)]];
//    }else if(nStr.length > 3)
//    {
//        NSString *str = [nStr substringFromIndex:3];
//        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,
//                                                                   str.length % 4)]];
//        if (nStr.length == 11)
//        {
//            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
//        }
//    }
//    NSLog(@"=======mstrTemp=%@",mStrTemp);
//
//    textField.text = mStrTemp;
//    // textField设置selectedTextRange
//    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
//    if (editFlag == 0)
//    {
//        //删除
//        if (targetCursorPosition == 9 || targetCursorPosition == 4)
//        {
//            curTargetCursorPosition = targetCursorPosition - 1;
//        }
//    }
//    else {
//        //添加
//        if (nStr.length == 8 || (nStr.length == 3 && [self.inputStr isEqualToString:@""] && preTxt.length == 2) || (nStr.length == 4 && ![self.inputStr isEqualToString:@""] && preTxt.length == 3))
//        {
//            curTargetCursorPosition = targetCursorPosition + 1;
//        }
//
//    }
//
//    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
//                                                              offset:curTargetCursorPosition];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition
//                                                         toPosition :targetPosition]];
//}
@end
