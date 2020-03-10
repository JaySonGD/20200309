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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBottomLC;

@property (nonatomic, strong) NSArray *urls;
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

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 12;
    [super setFrame:frame];
}

- (void)loadDatasourceWorkbord:(NSArray*)works profit:(NSDictionary*)profit sourceInfo:(NSDictionary*)info
{
    /*
     // 当前可用金额(余额)
     "availableCashback": "0.00",
     // 当前月收入
     "currentMonthIncome": "0.00",
     // 累计收益
     "alreadyWithdraw": "0.00",
     */
    
    NSDictionary *data = profit[@"data"];
    NSString *availableCashback = data[@"availableCashback"];
    NSString *currentMonthIncome = data[@"currentMonthIncome"];
    NSString *alreadyWithdraw = data[@"alreadyWithdraw"];
    
    BOOL h_earning_status = [data[@"h_earning_status"] boolValue];// 首页收入模块显示状态: 1-显示，0-隐藏
    //    self.profitBox.hidden = YES;
    //    self.homeBottomLC.constant = 0;
    //    return;
    if (!h_earning_status) {
    //if ((availableCashback.floatValue == 0. && currentMonthIncome.floatValue == 0. && alreadyWithdraw.floatValue == 0.) && (!works || works.count == 0)) {
        _homeBottomLC.constant = 0;
    }else{
        _homeBottomLC.constant = 80;
        if (availableCashback.floatValue == 0. && currentMonthIncome.floatValue == 0. && alreadyWithdraw.floatValue == 0.) {
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
            _balanceL.text = data[@"availableCashback"];
            _monthProfitL.text = data[@"currentMonthIncome"];
            _allProfitL.text = data[@"alreadyWithdraw"];
        }
    }
    
    if (!info) {
        return;
    }
    
    NSArray *adv = info[@"adv"];
    
    NSMutableArray *imagesStrings = [@[]mutableCopy];
    self.urls = [adv valueForKeyPath:@"route_h5"];
    for (NSDictionary *item in adv) {
        [imagesStrings addObject:item[@"imgUrl"]];
    }
    self.bannerView.imageURLStringsGroup = imagesStrings;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = [UIImage imageNamed:@"adN"];
    self.bannerView.autoScrollTimeInterval = 4.;
    self.bannerView.delegate = self;
    
    _addrL.text = info[@"address"];
    _timeL.text = [NSString stringWithFormat:@"营业时间 %@-%@", info[@"startTime"], info[@"endTime"]];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    NSString *url = self.urls[index];
    if (IsEmptyStr(url)) return;
    
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    NSString *urlStr = [url stringByReplacingOccurrencesOfString:@"token=_TOKEN_" withString:[NSString stringWithFormat:@"token=%@",[YHTools getAccessToken]]];//[NSString stringWithFormat:@"%@/index.html?token=%@&status=ios&billType=all#/bill/reportCheckList",SERVER_PHP_URL_Statements_H5_Vue, [YHTools getAccessToken]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"status=_APP_" withString:@"status=ios"];
    
    [controller setValue:urlStr forKey:@"urlStr"];
    [controller setValue:@(YES) forKey:@"barHidden"];
    [nav pushViewController:controller animated:YES];
}
@end
