//
//  YTPayViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 19/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTPayViewController.h"

#import "YHCarPhotoService.h"

#import "YTPlanModel.h"
#import "YTPaymentRecordCell.h"

#import "WXPay.h"

@interface YTPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *needPayLB;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (nonatomic, strong) YTSplitPayInfoModel *model;
@end

@implementation YTPayViewController
- (IBAction)payAction:(id)sender {
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] solutionPay:self.diagnoseModel.billId price:self.moneyTF.text success:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        if (!info) {
            [MBProgressHUD showError:@"不需要购买！"];
            return ;
        }
        
        [[WXPay sharedWXPay] payByParameter:info success:^{
            [self loadData];

        } failure:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"支付失败！"];
        }];

        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topViewTop.constant += kStatusBarAndNavigationBarHeight;
    
    self.paymentTableView.tableFooterView = [UIView new];
    self.navigationItem.title = @"拆分支付";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拆分说明" style:UIBarButtonItemStyleDone target:self action:@selector(splitPayInfo)];
    
    
    self.paymentTableView.rowHeight = 54;
    [self.paymentTableView registerNib:[UINib nibWithNibName:@"YTPaymentRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self loadData];

}

- (void)loadData{

    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] splitPayInfo:self.diagnoseModel.billId success:^(YTSplitPayInfoModel *info) {

        [MBProgressHUD hideHUDForView:self.view];
        self.model = info;
        
        if (self.moneyTF.hasText) {
            if (info.payStatus == 1) {
                [MBProgressHUD showError:@"支付成功！"];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }else if (info.payStatus == 0){
                [MBProgressHUD showError:@"支付成功！"];
            }
        }
        
    
        
        self.totalPriceLB.text = [NSString stringWithFormat:@"总价 ¥ %@",info.total_price];
        self.needPayLB.text = [NSString stringWithFormat:@"¥ %@",info.need_pay];
        
        self.buttomView.hidden = !((BOOL)info.payment_record.count);
        [self.paymentTableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}

- (void)splitPayInfo{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.payment_record.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTPaymentRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    YTPaymentRecordModel *model = self.model.payment_record[indexPath.row];
    cell.payTime.text = model.payTime;
    cell.payDAmount.text = model.payDAmount;
    cell.title.text = [NSString stringWithFormat:@"第%ld笔",indexPath.row+1];

    return cell;
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
