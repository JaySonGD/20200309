//
//  YHServiceHeaderCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/25.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <SDCycleScrollView/SDCycleScrollView.h>
#import "YHServiceHeaderCell.h"
#import "YHTools.h"
@interface YHServiceHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *allL;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameL;
@property (weak, nonatomic) IBOutlet UILabel *addrL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *disL;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *phoneB;
@end

@implementation YHServiceHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataSource:(NSDictionary*)info{
    
    NSArray *imagesStrings = info[@"coverUrl"];
    [_phoneB setTitle:info[@"tel"] forState:UIControlStateNormal];
    self.bannerView.imageURLStringsGroup = imagesStrings;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = [UIImage imageNamed:@"me_26"];
    
    
    _allL.text = [NSString stringWithFormat:@"%@", info[@"23"]];
    _serviceNameL.text = info[@"shopName"];
    _addrL.text = info[@"address"];
    _timeL.text = [NSString stringWithFormat:@"营业时间 %@-%@", info[@"startTime"], info[@"endTime"]];

}

@end
