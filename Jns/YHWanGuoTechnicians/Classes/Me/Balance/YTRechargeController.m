//
//  YTRechargeController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRechargeController.h"

#import "YHUserProtocolViewController.h"
#import "YTPointsDealModel.h"

#import "YHCarPhotoService.h"

#import "YTPriceCell.h"

#import "WXPay.h"


@interface YTRechargeController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopNameLB;
@property (weak, nonatomic) IBOutlet UICollectionView *pricrListView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceListViewH;

@property (nonatomic, strong) YTPointsDealModel *model;

@end

@implementation YTRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layout.itemSize = CGSizeMake((kScreenWidth - 24 - 12 * 3)*0.5, 44);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] getPointsDealPayInfoSuccess:^(YTPointsDealModel *obj) {
        self.model = obj;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger count = ceil(obj.price_list.count / 2.0);
        self.priceListViewH.constant = 44 * count + 12 * (count + 1);
        self.shopNameLB.text = obj.org_name;
        [self.pricrListView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (IBAction)recharge:(id)sender {
    YHUserProtocolViewController *VC = [[UIStoryboard storyboardWithName:@"YHUserProtocol" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUserProtocolViewController"];
    VC.text = @"rrrrr";
    VC.name = @"余额说明";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YTPriceModel *model = self.model.price_list[indexPath.row];
    [self.model.price_list enumerateObjectsUsingBlock:^(YTPriceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if(obj != model)obj.isSelect = NO;
    }];
    model.isSelect = !model.isSelect;
    [collectionView reloadData];
    // 支付
    [[YHCarPhotoService new] pointsDealPay:self.model.org_id price:model.price success:^(NSDictionary *info) {
    
        [[WXPay sharedWXPay] payByParameter:info success:^{
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"支付失败！"];
        }];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YTPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.model.price_list[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.price_list.count;
}


@end
