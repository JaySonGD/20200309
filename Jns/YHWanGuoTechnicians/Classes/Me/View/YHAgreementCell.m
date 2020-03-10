//
//  YHAgreementCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHAgreementCell.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "YHMaintainContentView.h"
@interface YHAgreementCell ()

@property (weak, nonatomic) IBOutlet UILabel *InsuranceCompany;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qualityProtocolToP;

@property (weak, nonatomic) IBOutlet UILabel *qualityProtocolL;

@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *addTimeL;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *timeoutL;
@property (weak, nonatomic) IBOutlet UILabel *expireDateL;
@property (weak, nonatomic) IBOutlet UILabel *carCreatedDateL;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UILabel *transmissionL;
@property (weak, nonatomic) IBOutlet UILabel *vinL;

@property (weak, nonatomic) IBOutlet UILabel *brandL;
@property (weak, nonatomic) IBOutlet UILabel *agreementContentL;

@property (weak, nonatomic) IBOutlet UILabel *agreementConditionL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionLC;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qualityProtocolTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qualityProtocolH;

@property (nonatomic,weak) YHMaintainContentView *agreementContentView;

@property (nonatomic,weak) UILabel *maintenanceBigTitleL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomToLastViewMargin;
@property (weak, nonatomic) IBOutlet UIView *addMaintenanceView;
@property (weak, nonatomic) IBOutlet UIView *addMaintenanceMarginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMaintenanceMarginHeight;

@end

@implementation YHAgreementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentLC.constant = screenWidth - 25;
    _conditionLC.constant = screenWidth - 25;
    
    self.InsuranceCompany.text = @"*此服务由中国人民财产保险承保";
    self.qualityProtocolL.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
- (void)hideInSuranceCompany:(BOOL)isHide{
    self.InsuranceCompany.hidden = YES;
    if (self.InsuranceCompany.hidden) {
        self.qualityProtocolH.active = NO;
        self.qualityProtocolToP.active = NO;
        self.qualityProtocolTopConstraint.active = NO;
    }else{
        self.qualityProtocolH.constant = 21;
        self.qualityProtocolToP.constant = 16;
        self.qualityProtocolTopConstraint.constant = 8;
        
    }
}
- (void)loadData:(NSDictionary*)dataSource{
    
    _carNumL.text = [NSString stringWithFormat:@"%@%@ %@", [dataSource[@"plateNumberP"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"plateNumberP"],[dataSource[@"plateNumberC"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"plateNumberC"],[dataSource[@"plateNumber"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"plateNumber"]];
    _codeL.text = [dataSource[@"policyNumber"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"policyNumber"];
    _addTimeL.text = [dataSource[@"addTime"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"addTime"];
    _userNameL.text = [dataSource[@"userName"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"userName"];
    _phoneL.text = [dataSource[@"phone"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"phone"];
   
    NSString *str1 = [dataSource[@"validTimeName"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"validTimeName"];
     _timeoutL.text = [NSString stringWithFormat:@"%@或%@公里",str1,dataSource[@"carKm"]];
    _expireDateL.text = [NSString stringWithFormat:@"%@",[dataSource[@"endEffectiveTime"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"endEffectiveTime"]];
    
    _brandL.text = [NSString stringWithFormat:@"%@ %@",dataSource[@"carBrandName"],dataSource[@"carLineName"]] ;
    
    _carCreatedDateL.text = [NSString stringWithFormat:@"%@ 年", [dataSource[@"carYear"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"carYear"]];
    
    _unitL.text = [dataSource[@"carCc"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"carCc"];
   
    _transmissionL.text = [dataSource[@"gearboxType"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"gearboxType"];
   
    _vinL.text = [dataSource[@"vin"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"vin"];
    
    NSString *contentText = [YHTools yhStringByReplacing:[dataSource[@"yesRangeContent"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"yesRangeContent"]];
    contentText =  [contentText stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    _agreementContentL.text =  [contentText stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    // 质量保障延长条件
    NSString *conditionText = [dataSource[@"notRangeContent"] isKindOfClass:[NSNull class]] ? @"" : dataSource[@"notRangeContent"];
    conditionText = [conditionText stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
     _agreementConditionL.text = [conditionText stringByReplacingOccurrencesOfString:@"<br>" withString:@""];

    [self maintenanceModuleHandle:dataSource];

}

- (void)maintenanceModuleHandle:(NSDictionary *)dataSource{
    
        if (!dataSource) {

            return;
        }
    NSArray *careList = dataSource[@"careList"];
    
    if (careList.count == 0) {

        return;
    }
    
    self.addMaintenanceMarginView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:249/255.0 alpha:1.0];
    
    if (!self.maintenanceBigTitleL) {
       
        UILabel *maintenanceBigTitleL = [[UILabel alloc] init];
        maintenanceBigTitleL.text = @"延长保修保养内容";
        maintenanceBigTitleL.font = [UIFont systemFontOfSize:18.0];
        self.maintenanceBigTitleL = maintenanceBigTitleL;
        [self.addMaintenanceView addSubview:maintenanceBigTitleL];
        [maintenanceBigTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.equalTo(@10);
            make.width.equalTo(maintenanceBigTitleL.superview);
            make.height.equalTo(@34);
        }];
        
         CGFloat addHeight = 34.0;
        
        UIView *sepreateLine = [[UIView alloc] init];
        [self.addMaintenanceView addSubview:sepreateLine];
        sepreateLine.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:207.0/255.0 blue:212.0/255.0 alpha:1.0];
        [sepreateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.height.equalTo(@1);
            make.right.equalTo(@0);
            make.bottom.equalTo(maintenanceBigTitleL.mas_bottom).offset(10);
        }];
    
        addHeight += 10;
    
 
    for (int i = 0; i<careList.count; i++) {
        
        //保养内容
        YHMaintainContentView *agreementContentView = [[NSBundle mainBundle] loadNibNamed:@"YHMaintainContentView" owner:nil options:nil].firstObject;
        [self.addMaintenanceView addSubview:agreementContentView];
        NSDictionary *itemDict = careList[i];
        
        agreementContentView.maintenanceTimeL.text = itemDict[@"title"];
        agreementContentView.maintenanceStandL.text = [NSString stringWithFormat:@"%@（先到为准）",itemDict[@"careTimeDesc"]];
        agreementContentView.maintenanceTitleL.text = itemDict[@"itemTitle"];
        
        NSArray *itemList = itemDict[@"itemList"];
        
        for (int j = 0; j<itemList.count; j++) {
            
            NSDictionary *elementDict = itemList[j];
            
            UILabel *agreeContentL = [[UILabel alloc] init];
            [agreementContentView.maintenanceContentView addSubview:agreeContentL];
            agreeContentL.text = elementDict[@"itemName"];
            agreeContentL.font = [UIFont systemFontOfSize:15.0];
            agreeContentL.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
            [agreeContentL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(agreeContentL.superview);
                make.height.equalTo(@20);
                make.left.equalTo(@0);
                make.top.equalTo(@(20*j));
            }];
        }
        
        if (i == 0) {
            [agreementContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(agreementContentView.superview);
                make.top.equalTo(self.maintenanceBigTitleL.mas_bottom).offset(20);
                make.left.equalTo(@17);
                make.height.equalTo(@(itemList.count * 20 + 80));
            }];
            addHeight += 20;
        }else{
            
            [agreementContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(agreementContentView.superview);
                make.top.equalTo(self.agreementContentView.mas_bottom).offset(10);
                make.left.equalTo(@17);
                make.height.equalTo(@(itemList.count * 20 + 80));

            }];
            addHeight += 10;
        }
        
        addHeight += (80 + itemList.count * 20);
       
        self.agreementContentView = agreementContentView;
    }
    
        [self.addMaintenanceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(addHeight));
        }];
}
}

@end
