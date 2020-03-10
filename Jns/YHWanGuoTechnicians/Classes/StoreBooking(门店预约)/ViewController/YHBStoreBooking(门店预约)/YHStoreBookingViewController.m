//
//  YHStoreBookingViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStoreBookingViewController.h"
#import "YHStoreBookingCellA.h"
#import "YHStoreBookingCellB.h"
#import "YHSitesDetailCellA.h"
#import "YHSolutionListViewController.h"
#import "YHStoreBookingModel.h"
#import "YHSiteDetailModel.h"
#import <MJExtension.h>

@interface YHStoreBookingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *storeBookingBtn;
@property (weak, nonatomic) IBOutlet UIView *storeBookingView;
@property (weak, nonatomic) IBOutlet UIButton *siteDetailsBtn;
@property (weak, nonatomic) IBOutlet UIView *siteDetailsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commonBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@property (nonatomic, assign) NSInteger tabTag;
@property (nonatomic, assign) BOOL isBooked;
@property (nonatomic, assign) BOOL isAllowCommited;

@property (nonatomic, strong) NSMutableArray *dataArray;

//@property (weak, nonatomic) IBOutlet UITextField *plateNumberTF;
//@property (weak, nonatomic) IBOutlet UITextField *customerName;
//@property (weak, nonatomic) IBOutlet UITextField *customerPhoneTF;
//@property (weak, nonatomic) IBOutlet TTZDateTextField *bookDateTF;
@property (nonatomic, strong)YHStoreBookingCellA *storeBookingCellA;
@property (nonatomic, strong)YHSiteDetailModel *siteDetailModel;

@property (nonatomic, copy)NSString *customer_name;
@property (nonatomic, copy)NSString *customer_phone;
@property (nonatomic, assign)NSInteger appointment_day_upper;

@end

@implementation YHStoreBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - ------------------------------------初始化变量----------------------------------------
- (void)initVar {
    self.tabTag = 1;
    
    self.isBooked = NO;
    self.isAllowCommited = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YHStoreBookingCellA" bundle:nil] forCellReuseIdentifier:@"YHStoreBookingCellA"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHStoreBookingCellB" bundle:nil] forCellReuseIdentifier:@"YHStoreBookingCellB"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHSitesDetailCellA" bundle:nil] forCellReuseIdentifier:@"YHSitesDetailCellA"];
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI {
    self.navigationController.navigationBar.hidden = YES;
    
    [self.storeBookingBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
    self.storeBookingView.backgroundColor = YHNaviColor;
    self.storeBookingView.hidden = NO;
    
    [self.siteDetailsBtn setTitleColor:YHLightGrayColor forState:UIControlStateNormal];
    self.siteDetailsView.backgroundColor = YHLightGrayColor;
    self.siteDetailsView.hidden = YES;
    
    [self.commonBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.commonBtn.backgroundColor = YHLightGrayColor;
    
    self.activityIndicatorView.hidden = YES;
}

#pragma mark - ------------------------------------初始化数据------------------------------------------
- (void)initData {
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]getBookingInfoWithToken:[YHTools getAccessToken]
                                                             solutionOrgiId:self.reservationModel.ID
                                                                 onComplete:^(NSDictionary *info)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view];
         NSLog(@"\n站点预约:\n%@",info);
         if ([[info[@"code"]stringValue] isEqualToString:@"20000"]) {
             weakSelf.customer_name = info[@"data"][@"customer_name"];
             weakSelf.customer_phone = info[@"data"][@"customer_phone"];
             weakSelf.appointment_day_upper = [info[@"data"][@"appointment_day_upper"] integerValue];
             weakSelf.siteDetailModel = [YHSiteDetailModel mj_objectWithKeyValues:info[@"data"][@"org_info"]];
             [weakSelf.tableView reloadData];
         } else {
             weakSelf.appointment_day_upper = 14;
             [weakSelf initData];
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

#pragma mark - ---------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tabTag == 1) {
        if (self.isBooked == NO) {
            YHStoreBookingCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"YHStoreBookingCellA"];
            cell.plateNumberTF.delegate = self;
            cell.customerNameTF.delegate = self;
            cell.customerPhoneTF.delegate = self;
            cell.customerNameTF.text = self.customer_name;
            cell.customerPhoneTF.text = self.customer_phone;
            cell.bookDateTF.minDate = [NSDate dateWithTimeIntervalSinceNow:+1 * 24 * 3600];
            cell.bookDateTF.maxDate = [NSDate dateWithTimeIntervalSinceNow:self.appointment_day_upper * 24 * 3600];
            cell.bookDateTF.text = [self dateChangeStr:cell.bookDateTF.minDate];
            self.storeBookingCellA = cell;
            return cell;
        } else {
            YHStoreBookingCellB *cell = [tableView dequeueReusableCellWithIdentifier:@"YHStoreBookingCellB"];
            cell.CheXingCheXiL.text = self.siteModel.carModelFullName;
            cell.plateNumberL.text = self.storeBookingCellA.plateNumberTF.text;
            cell.plateNumberL.text = self.storeBookingCellA.plateNumberTF.text;
            cell.customerNameLabel.text = self.storeBookingCellA.customerPhoneTF.text;
            cell.bookDateL.text = self.storeBookingCellA.bookDateTF.text;
            return cell;
        }
    } else {
        YHSitesDetailCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"YHSitesDetailCellA"];
        [cell refreshUIWithModel:self.siteDetailModel];
        cell.btnClickBlock = ^(UIButton * _Nonnull button) {
            NSString *telString = [NSString stringWithFormat:@"tel:%@", self.siteDetailModel.contact_tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
        };
        return cell;
    }
}

- (NSString *)dateChangeStr:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tabTag == 1) {
        if (self.isBooked == NO) {
            return 405;
        } else {
            return 278;
        }
    } else {
        return 206;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.storeBookingCellA.customerPhoneTF) {
        if ((self.storeBookingCellA.customerPhoneTF.text.length >= 11) && !IsEmptyStr(string)) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (IsEmptyStr(self.storeBookingCellA.plateNumberTF.text) &&
        IsEmptyStr(self.storeBookingCellA.customerNameTF.text) &&
        IsEmptyStr(self.storeBookingCellA.customerPhoneTF.text)) {
        [MBProgressHUD showError:@"请输入相关信息"];
        self.commonBtn.userInteractionEnabled = NO;
    } else {
        self.commonBtn.userInteractionEnabled = YES;
    }
    
    if (!IsEmptyStr(self.storeBookingCellA.plateNumberTF.text) &&
        !IsEmptyStr(self.storeBookingCellA.customerNameTF.text) &&
        !IsEmptyStr(self.storeBookingCellA.customerPhoneTF.text)) {
        self.commonBtn.backgroundColor = YHNaviColor;
    } else {
        self.commonBtn.backgroundColor = YHLightGrayColor;
    }
}

#pragma mark - -------------------------------------点击事件------------------------------------------
- (IBAction)backBtn:(UIButton *)sender {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchTabBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self.storeBookingBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.storeBookingView.backgroundColor = YHNaviColor;
            self.storeBookingView.hidden = NO;

            [self.siteDetailsBtn setTitleColor:YHLightGrayColor forState:UIControlStateNormal];
            self.siteDetailsView.backgroundColor = YHLightGrayColor;
            self.siteDetailsView.hidden = YES;
        }
            break;
        case 2:
        {
            [self.storeBookingBtn setTitleColor:YHLightGrayColor forState:UIControlStateNormal];
            self.storeBookingView.backgroundColor = YHLightGrayColor;
            self.storeBookingView.hidden = YES;

            [self.siteDetailsBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.siteDetailsView.backgroundColor = YHNaviColor;
            self.siteDetailsView.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.tabTag = sender.tag;
    [self.tableView reloadData];
}

- (IBAction)commonBtn:(UIButton *)sender {
    //判空处理
    //1.车牌号
    NSString *plateNumber = self.storeBookingCellA.plateNumberTF.text;
    NSString *plate_number_p;
    NSString *plate_number_c;
    NSString *plate_number;
    if (IsEmptyStr(plateNumber)) {
        [MBProgressHUD showError:@"请输入车牌号"];
        return;
    } else {
        if (plateNumber.length > 2) {
            plate_number_p = [plateNumber substringWithRange:NSMakeRange(0, 1)];
            plate_number_c = [plateNumber substringWithRange:NSMakeRange(1, 1)];
            plate_number = [plateNumber substringFromIndex:2];
        } else {
            [MBProgressHUD showError:@"请输入正确的车牌号"];
            return;
        }
    }
    
    
    //2.预约人
    NSString *customerName = self.storeBookingCellA.customerNameTF.text;
    if (IsEmptyStr(customerName)) {
        [MBProgressHUD showError:@"请输入预约人"];
        return;
    }
    
    
    //3.预约人电话
    NSString *customerPhone = self.storeBookingCellA.customerPhoneTF.text;
    if (IsEmptyStr(customerPhone)) {
        [MBProgressHUD showError:@"请输入预约人电话"];
        return;
    } else {
        if (![[customerPhone substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"] || (customerPhone.length != 11)) {
            [MBProgressHUD showError:@"请输入正确的预约人电话"];
            return;
        } else {
            self.isAllowCommited = YES;
        }
    }
    
    //4.预约日期
    NSString *bookDate = self.storeBookingCellA.bookDateTF.text;
    
    WeakSelf;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]getBookingInfoWithToken:[YHTools getAccessToken]
                                                             solutionOrgiId:self.reservationModel.ID
                                                                        vin:self.siteModel.vin
                                                               car_brand_id:self.siteModel.carBrandId
                                                                car_line_id:self.siteModel.carLineId
                                                               car_model_id:self.siteModel.carModelId
                                                        car_model_full_name:self.siteModel.carModelFullName
                                                                     car_cc:self.siteModel.carCc
                                                                car_cc_unit:self.siteModel.unit
                                                                  nian_kuan:self.siteModel.nianKuan
                                                               produce_year:self.siteModel.produceYear
                                                               gearbox_type:self.siteModel.gearboxType
                                                             plate_number_p:plate_number_p
                                                             plate_number_c:plate_number_c
                                                               plate_number:plate_number
                                                              customer_name:customerName
                                                             customer_phone:customerPhone
                                                           appointment_time:bookDate
                                                                 onComplete:^(NSDictionary *info)
     {
         [self.activityIndicatorView stopAnimating];
         NSLog(@"\n站点预约:\n%@===%@",info,info[@"msg"]);
         if ([[info[@"code"]stringValue] isEqualToString:@"20000"]) {
             [MBProgressHUD showSuccess:@"预约成功"];
             weakSelf.isBooked = YES;
             [weakSelf.commonBtn setTitle:@"已预约" forState:UIControlStateNormal];
             weakSelf.commonBtn.backgroundColor = YHLightGrayColor;
             [weakSelf.tableView reloadData];
             
             YHSolutionListViewController *VC = [[UIStoryboard storyboardWithName:@"YHStoreBooking" bundle:nil] instantiateViewControllerWithIdentifier:@"YHSolutionListViewController"];
             weakSelf.navigationController.navigationBarHidden = NO;
             VC.isSolution = NO;
             VC.isBook = YES;
             [weakSelf.navigationController pushViewController:VC animated:YES];
         } else {
             [MBProgressHUD showError:info[@"msg"]];
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

#pragma mark - --------------------------------------懒加载--------------------------------------------
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (NSString *)getCurrentDate{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    NSLog(@"%@",dateStr);
    return dateStr;
}

@end
