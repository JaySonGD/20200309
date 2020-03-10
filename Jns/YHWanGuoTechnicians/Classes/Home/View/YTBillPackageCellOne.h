//
//  YTBillPackageCellOne.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/23.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class packageOwnerModel;
@interface YTBillPackageCellOne : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *taoCanLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UITableView *tbv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h;
@property (nonatomic, strong) packageOwnerModel *model;
@end

NS_ASSUME_NONNULL_END
