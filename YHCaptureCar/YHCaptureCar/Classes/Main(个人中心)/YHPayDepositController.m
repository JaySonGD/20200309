//
//  YHPayDepositController.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/11.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPayDepositController.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "BRDatePickerView.h"
@interface YHPayDepositController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *ftBoxs;
@property (weak, nonatomic) IBOutlet UITextField *bankNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *payNameTF;
@property (weak, nonatomic) IBOutlet UITextField *payNmberTF;
@property (weak, nonatomic) IBOutlet UITextField *payDateTF;

- (IBAction)dateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation YHPayDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
    //    frame.size.height = 500;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 600)];
    
    [_ftBoxs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        YHLayerBorder(view, YHLineColor, 1)
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitAction:(id)sender {
    if (self.bankNumberTF.text.length == 0 ) {
        [MBProgressHUD showError:self.bankNumberTF.placeholder];
        return;
    }
    
    if (self.bankNameTF.text.length == 0 ) {
        [MBProgressHUD showError:self.bankNameTF.placeholder];
        return;
    }
    if (self.payNameTF.text.length == 0 ) {
        [MBProgressHUD showError:self.payNameTF.placeholder];
        return;
    }
    if (self.payNmberTF.text.length == 0 ) {
        [MBProgressHUD showError:self.payNmberTF.placeholder];
        return;
    }
    if (self.payDateTF.text.length == 0 ) {
        [MBProgressHUD showError:self.payDateTF.placeholder];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中..."];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkManager sharedYHNetworkManager]
     paymentPledgeMoney:[YHTools getAccessToken]
     account:_bankNumberTF.text
     bankName:_bankNameTF.text
     name:_payNameTF.text
     number:_payNmberTF.text
     remittingTime:self.payDateTF.text
     isNew:YES
     onComplete:^(NSDictionary *info) {
         [SVProgressHUD dismiss];
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             [MBProgressHUD showSuccess:@"提交成功！" toView:self.navigationController.view];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }else{
             YHLogERROR(@"");
             [weakSelf showErrorInfo:info];
         }
     } onError:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}

- (IBAction)dateAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    NSString *minTStr = @"2010-01-01 12:12:12";
    NSString *maxTStr = [YHTools stringFromDate:[NSDate date] byFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    [BRDatePickerView showDatePickerWithTitle:@"汇款日期" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:minTStr maxDateStr:maxTStr isAutoSelect:NO themeColor:YHNaviColor resultBlock:^(NSString *selectValue) {
        weakSelf.payDateTF.text = selectValue;
    } cancelBlock:^{
        
    }];
}
@end
