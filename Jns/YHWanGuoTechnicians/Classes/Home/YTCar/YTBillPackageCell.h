//
//  YTBillPackageCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 9/10/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTBillPackageModel;


@interface YTBillPackageCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YTBillPackageModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBoxH;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *descLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disableBoxH;
@property (weak, nonatomic) IBOutlet UITableView *sysView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sysViewH;
@property (weak, nonatomic) IBOutlet UISwitch *editSw;

@property (nonatomic, copy) dispatch_block_t reload;


@end

NS_ASSUME_NONNULL_END
