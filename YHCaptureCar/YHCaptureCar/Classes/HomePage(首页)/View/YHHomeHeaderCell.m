//
//  YHHomeHeaderCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/21.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <SDCycleScrollView/SDCycleScrollView.h>
#import "YHHomeHeaderCell.h"
#import "YHTools.h"
#import "YHNetworkManager.h"
@interface YHHomeHeaderCell ()
@property (weak, nonatomic) IBOutlet UIButton *workbrodB1;
@property (weak, nonatomic) IBOutlet UIButton *workbrodB2;
@property (weak, nonatomic) IBOutlet UIButton *workbrodB3;
@property (weak, nonatomic) IBOutlet UILabel *emptyWorksL;

@property (weak, nonatomic) IBOutlet UILabel *addrL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *distenceL;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *adL;
@property (weak, nonatomic) IBOutlet UIView *profitBox;
@property (weak, nonatomic) IBOutlet UILabel *allProfitL;
@property (weak, nonatomic) IBOutlet UILabel *monthProfitL;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@end
@implementation YHHomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDatasourceWorkbord:(NSArray*)works profit:(NSDictionary*)profit{
    
    /*
     // 当前可用金额(余额)
     "availableCashback": "0.00",
     // 当前月收入
     "currentMonthIncome": "0.00",
     // 累计收益
     "alreadyWithdraw": "0.00",
     */
    NSString *alreadyWithdraw = profit[@"alreadyWithdraw"];
    if (alreadyWithdraw.floatValue == 0.) {
        _profitBox.hidden = YES;
        _emptyWorksL.hidden = (works.count != 0);
        NSArray *buttons = @[_workbrodB1, _workbrodB2, _workbrodB3];
        for (NSInteger i = 0; i < buttons.count; i++) {
            UIButton *button = buttons[i];
            if (works.count > i) {
                NSDictionary *work = works[i];
                button.hidden = NO;
                button.titleLabel.text = [NSString stringWithFormat:@"%@ %@%@", work[@"plateNumberP"],work[@"plateNumberC"],work[@"plateNumber"]];
                [button setTitle:[NSString stringWithFormat:@"%@ %@%@", work[@"plateNumberP"],work[@"plateNumberC"],work[@"plateNumber"]] forState:UIControlStateNormal];
            }else{
                button.hidden = YES;
            }
        }
    }else{
        _profitBox.hidden = NO;
        _balanceL.text = profit[@"availableCashback"];
        _monthProfitL.text = profit[@"currentMonthIncome"];
        _allProfitL.text = profit[@"alreadyWithdraw"];
    }
    _profitBox.hidden = NO;
}

- (void)loadDatasource:(NSDictionary*)info{
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = [UIImage imageNamed:@"icon_auctionSceneBanner"];
    self.bannerView.autoScrollTimeInterval = 5.;
    if (info) {
        NSString *adv = info[@"result"][@"advs"];
        NSMutableArray *imagesStrings = [@[]mutableCopy];
        for (NSString *item in [adv componentsSeparatedByString:@","]) {

            [imagesStrings addObject:[YHTools hmacsha1YH:item width:0]];
        }
        self.bannerView.imageURLStringsGroup = imagesStrings;
    }else{
        self.bannerView.localizationImageNamesGroup = @[@"icon_auctionSceneBanner"];
    }
}
@end
