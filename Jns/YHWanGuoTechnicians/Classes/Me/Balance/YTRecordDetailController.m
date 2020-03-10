//
//  YTRecordDetailController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRecordDetailController.h"

#import "YHCarPhotoService.h"

#import "YTPointsDealModel.h"

@interface YTRecordDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *dealNameLB;
@property (weak, nonatomic) IBOutlet UILabel *dealPointsLB;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLB;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *dealWayLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumberH;
@property (nonatomic, strong) YTPointsDealDetailModel *model;

@end

@implementation YTRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavigationBarBtn];
   
    self.orderNumberLB.superview.hidden = YES;
    self.createTimeLB.superview.hidden = YES;
    self.payAmountLB.superview.hidden = YES;
    self.dealTimeLB.superview.hidden = YES;
    self.dealWayLB.superview.hidden = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] getPointsDealInfoById:self.Id success:^(YTPointsDealDetailModel *model) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.model = model;
        
//        self.orderNumberLB.superview.hidden = NO;
//        self.createTimeLB.superview.hidden = NO;

        self.dealNameLB.text = model.deal_name;
        if (model.deal_sort == 0) {
            self.dealPointsLB.text = model.deal_points;
        }else if (model.deal_sort == 1){
            self.dealPointsLB.text = [NSString stringWithFormat:@"+ %@",model.deal_points];
            
        }else{
            self.dealPointsLB.text = [NSString stringWithFormat:@"- %@",model.deal_points];
        }

        self.orderNumberLB.text =  model.order_number  ? model.order_number : @"";
        self.createTimeLB.text = model.create_time;
        self.payAmountLB.text = [NSString stringWithFormat:@"￥ %@",model.pay_amount];
        self.dealTimeLB.text = model.deal_time;
        self.dealWayLB.text = model.deal_way;
        
        self.payAmountLB.superview.hidden = IsEmptyStr(model.pay_amount);
        self.dealTimeLB.superview.hidden = IsEmptyStr(model.deal_time);
        self.dealWayLB.superview.hidden = IsEmptyStr(model.deal_way);
        self.orderNumberLB.superview.hidden = IsEmptyStr(model.order_number);
        self.createTimeLB.superview.hidden = IsEmptyStr(model.create_time);
        
//        if (model.deal_sort == 2) { // 消费
//            self.payAmountLB.superview.hidden = YES;
//            self.dealTimeLB.superview.hidden = YES;
//            self.dealWayLB.superview.hidden = YES;
//
//        }else if(model.deal_sort == 1){ // 充值
//
//            if ([self.dealNameLB.text isEqualToString:@"体验店充值"] || [self.dealNameLB.text isEqualToString:@"消费充值"]) {
//                self.payAmountLB.superview.hidden = YES;
//                self.dealTimeLB.superview.hidden = YES;
//                self.dealWayLB.superview.hidden = YES;
//                self.orderNumberLB.superview.hidden = YES;
//
//            }else{
//                self.payAmountLB.superview.hidden = NO;
//                self.dealTimeLB.superview.hidden = NO;
//                self.dealWayLB.superview.hidden = NO;
//            }
//        }else{
//            self.payAmountLB.superview.hidden = NO;
//            self.dealTimeLB.superview.hidden = NO;
//            self.dealWayLB.superview.hidden = NO;
//        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)addNavigationBarBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"setPartRemove"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
    
}

@end
