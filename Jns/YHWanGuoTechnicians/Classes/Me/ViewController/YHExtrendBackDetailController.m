//
//  YHExtrendBackDetailController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/20.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendBackDetailController.h"
#import "YHCommon.h"
#import "YHWebFuncViewController.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
@interface YHExtrendBackDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *serviceFL;
@property (weak, nonatomic) IBOutlet UILabel *warraryFL;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceL;
@property (weak, nonatomic) IBOutlet UILabel *serviceDateL;
@property (weak, nonatomic) IBOutlet UILabel *warrantyPriceL;
@property (weak, nonatomic) IBOutlet UILabel *warrantyDateL;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameL;
@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (weak, nonatomic) IBOutlet UILabel *packageL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *carNumberL;
@property (weak, nonatomic) IBOutlet UILabel *carTypeL;
@property (weak, nonatomic) IBOutlet UILabel *pricePL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@end

@implementation YHExtrendBackDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
    frame.size.height = 510;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 510)];
    
    _stateL.text = @[@"未返现", @"部分返现", @"全部返现"][_backModel];
    
    if (_backModel == YHExtrendBackModelUn) {
        _pricePL.textColor = YHExtrendBackColor;
        _priceL.textColor = YHExtrendBackColor;
        _stateL.textColor = YHExtrendBackColor;
        _servicePriceL.textColor = YHExtrendBackColor;
        _warrantyPriceL.textColor = YHExtrendBackColor;
        _serviceFL.text = @"未返服务费";
        _warraryFL.text = @"未返质保金";
    }else if (_backModel == YHExtrendBackModelPart ) {
        _pricePL.textColor = [UIColor blackColor];
        _priceL.textColor = [UIColor blackColor];
        _stateL.textColor = YHCellColor;
        _servicePriceL.textColor = YHCellColor;
        _warrantyPriceL.textColor = YHCellColor;
        
        _serviceFL.text = @"已返服务费";
        _warraryFL.text = @"未返质保金";
    }else if (_backModel == YHExtrendBackModelAll) {
        _pricePL.textColor = [UIColor blackColor];
        _priceL.textColor = [UIColor blackColor];
        _stateL.textColor = YHCellColor;
        _servicePriceL.textColor = YHCellColor;
        _warrantyPriceL.textColor = YHCellColor;
        _serviceFL.text = @"已返服务费";
        _warraryFL.text = @"已返质保金";
    }
    
    _priceL.text = _info[@"price"];
    _servicePriceL.text = [NSString stringWithFormat:@"¥%@", _info[@"seviceCharge"]];
    _serviceDateL.text = _info[@"scPredictTime"];
    _warrantyPriceL.text = [NSString stringWithFormat:@"¥%@", _info[@"warrantyMoney"]];
    _warrantyDateL.text = _info[@"wmPredictTime"];
    _serviceNameL.text = [NSString stringWithFormat:@"%@  >", _info[@"agentName"]];
    _orderIdL.text = _info[@"billNumber"];
    _vinL.text = _info[@"vin"];
    _packageL.text = _info[@"warrantyName"];
    _phoneL.text = _info[@"customerPhone"];
    _carNumberL.text = _info[@"plateNumber"];
    _carTypeL.text = _info[@"carModelFullName"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)toWebAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title = @"返现管理";
    controller.urlStr = [NSString stringWithFormat:@"%@%@/statisticsChart.html?token=%@&status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
