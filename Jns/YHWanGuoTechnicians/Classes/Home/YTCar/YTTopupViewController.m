//
//  YTTopupViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 21/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTTopupViewController.h"

#import "YHUserProtocolViewController.h"

#import "YTPriceCell.h"

#import "YHCarPhotoService.h"
#import "YTPointsDealModel.h"

#import "WXPay.h"

@interface YTTopupViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *priceListView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceListViewHeight;
@property (nonatomic, strong) YTPointsDealModel *model;

@end

@implementation YTTopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layout.itemSize = CGSizeMake((kScreenWidth - 24 - 12 * 3)*0.5, 44);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] getPointsDealPayInfoSuccess:^(YTPointsDealModel *obj) {
        self.model = obj;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger count = ceil(obj.price_list.count / 2.0);
        self.priceListViewHeight.constant = 44 * count + 12 * (count + 1);
        self.orgNameLB.text = obj.org_name;
        [self.priceListView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}
- (IBAction)recharge:(UIButton *)sender {
    
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
            [MBProgressHUD showError:@"支付成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popViewController:nil];
            });
        } failure:^{
            [MBProgressHUD showError:@"支付失败！"];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
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
