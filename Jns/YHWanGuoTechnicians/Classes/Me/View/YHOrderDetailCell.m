//
//  YHOrderDetailCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailCell.h"
#import "Masonry.h"
#import "YHCommon.h"
//#import "MBProgressHUD+MJ.h"
#import "YHTools.h"
#import <UIImageView+WebCache.h>
#import "YHHUPhotoBrowser.h"

NSString *const notificationPriceChange = @"YHNotificationPriceChange";
NSString *const notificationChildByTag = @"YHNotificationChildByTag";
@interface YHOrderDetailCell ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sysIG;
@property (weak, nonatomic) IBOutlet UILabel *sysDesc;

@property (weak, nonatomic) IBOutlet UILabel *priceF;
@property (weak, nonatomic) IBOutlet UIView *boxV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLC;
@property (weak, nonatomic) IBOutlet UIView *linwV;
@property (weak, nonatomic)NSArray *info;
@property (weak, nonatomic) IBOutlet UILabel *repairResultL;
@property (weak, nonatomic) IBOutlet UIView *allPriceBox;
@property (weak, nonatomic) IBOutlet UILabel *allPriceL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxVBottomLC;
@end

@implementation YHOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)loadDatasourceBaseInfo:(NSDictionary*)sysInfo isBlockPolicy:(NSNumber*)isBlockPolicy billType:(NSString*)billType{
    
    NSArray *views = self.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _boxVBottomLC.constant = 10;
    NSArray *sysSubsSrc = @[@[@"客户名称",@"userName"],@[@"客户电话",@"phone"],@[@"车牌号码",@"plateNumberP",@"plateNumberC",@"plateNumber"],@[@"车架号",@"vin"],@[@"车型",@"carBrandName",@"carLineName"],@[@"排量",@"carCc"],@[@"变速箱",@"gearboxType"],@[@"公里数",@"tripDistance"],@[@"燃油表",@"fuelMeter"],@[@"预约时间",@"startTime"]];
    
    NSMutableArray *sysSubs = [@[]mutableCopy];
    for (int i = 0; sysSubsSrc.count > i; i++) {
        NSArray *subInfo = sysSubsSrc[i];
        NSString *value = sysInfo[subInfo[1]];
        if (!IsEmptyStr(value)) {
            [sysSubs addObject:sysSubsSrc[i]];
        }
    }
    
    _sysDesc.text = @"基本信息";
    __weak __typeof__(self) weakSelf = self;
    UILabel *valueLPre = _sysDesc;
    for (int i = 0; sysSubs.count > i; i++) {
        NSArray *subInfo = sysSubs[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = subInfo[0];
        [titleL setTextColor:YHCellColor];
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.textColor = YHCellColor;
        NSString *value = sysInfo[subInfo[1]];
        if (IsEmptyStr(value)) {
            continue;
        }
        if ([subInfo[1] isEqualToString:@"tripDistance"]) {
            value = [NSString stringWithFormat:@"%@KM", value];
        }else if ([subInfo[1] isEqualToString:@"fuelMeter"]) {
            value = [NSString stringWithFormat:@"%@%%", value];
        }
        
        for (int index = 2; index < subInfo.count; index++) {
            value = [NSString stringWithFormat:@"%@%@", value, sysInfo[subInfo[index]]];
            
        }
        valueL.text = value;
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
        
        
        
        if (sysSubs.count == i + 1) {
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                
                make.height.greaterThanOrEqualTo(@55);
                make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
            }];
            
        }else{
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                make.height.greaterThanOrEqualTo(@55);
            }];
            
        }
        if ([subInfo[0] isEqualToString:@"客户名称"] && isBlockPolicy.boolValue) {//延长保修标示
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imageV setImage:[UIImage imageNamed:@"warranty"]];
            [weakSelf.boxV addSubview:imageV];
            
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(valueL.mas_leading).with.offset(0);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(15);
                make.height.greaterThanOrEqualTo(@20);
                make.height.greaterThanOrEqualTo(@20);
            }];
        }
        
        valueLPre = valueL;
        
        
    }
}


- (void)loadDatasourcefaultPhenomenonDescs:(NSString*)desc title:(NSString*)title{
    
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    
    _sysDesc.text = title;
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleL.text = desc;
    [titleL setTextColor:YHCellColor];
    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
    [lineL setTextColor:YHLineColor];
    [weakSelf.boxV addSubview:titleL];
    [weakSelf.boxV addSubview:lineL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (1 + 1));
        make.height.equalTo(@55);
    }];
    
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
        make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (1 + 1) -1);
        make.height.equalTo(@1);
    }];
}

- (void)loadDatasourceFaultPhenomenon:(NSArray*)info title:(NSString*)title{
    
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    
    _sysDesc.text = title;
    for (int i = 0; info.count > i; i++) {
        NSDictionary *subInfo = info[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = subInfo[@"faultPhenomenonName"];
        [titleL setTextColor:YHCellColor];
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
    }
}

- (void)loadDatasourceConsultingLamp:(NSDictionary*)lampInfo title:(NSString*)title{
    
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    
    NSArray *projectVal = lampInfo[@"projectVal"];
    _sysDesc.text = title;
    for (int i = 0; projectVal.count > i; i++) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = projectVal[i];
        [titleL setTextColor:YHCellColor];
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
    }
}

- (void)loadDatasourceConsulting:(NSDictionary*)consultingInfo{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _boxVBottomLC.constant = 10;
    _priceF.hidden = YES;
    NSString *title = consultingInfo[@"title"];
    _sysDesc.text = title;
    NSArray *value = consultingInfo[@"value"];
    
    
    UILabel *valueLPre = _sysDesc;
    if ([title isEqualToString:@"故障灯选择（多选）"]){
        NSDictionary *subInfo = value[0];
        NSArray *projectVal = subInfo[@"projectVal"];
        if ([projectVal isKindOfClass:[NSDictionary class]]) {
            projectVal = ((NSDictionary*)projectVal)[@"default"];
        }
        for (int i = 0; projectVal.count > i; i++) {
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
            titleL.text = projectVal[i];
            [titleL setTextColor:YHCellColor];
            UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
            [lineL setBackgroundColor:YHLineColor];
            [weakSelf.boxV addSubview:titleL];
            [weakSelf.boxV addSubview:lineL];
            
            
            
            if (projectVal.count == i + 1) {
                
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.greaterThanOrEqualTo(@55);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
                
            }else{
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.greaterThanOrEqualTo(@55);
                }];
                
            }
            
            
            [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(-1);
                make.height.equalTo(@1);
            }];
            
            valueLPre = titleL;
        }
    }else if( [title isEqualToString:@"燃油故障"]
             || [title isEqualToString:@"动力故障"] ) {
        
        __weak __typeof__(self) weakSelf = self;
        for (int i = 0; value.count > i; i++) {
            NSDictionary *subInfo = value[i];
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
            titleL.text = subInfo[@"projectName"];
            [titleL setTextColor:YHCellColor];
            UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
            valueL.textColor = YHCellColor;
            valueL.text = [NSString stringWithFormat:@"%@%@", subInfo[@"projectVal"], EmptyStr(subInfo[@"unit"])];
            
            UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
            [lineL setBackgroundColor:YHLineColor];
            [weakSelf.boxV addSubview:titleL];
            [weakSelf.boxV addSubview:valueL];
            [weakSelf.boxV addSubview:lineL];
            
            if (value.count == i + 1) {
                
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    
                    make.height.greaterThanOrEqualTo(@55);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
                
            }else{
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.equalTo(@55);
                }];
                
            }
            
            [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(-1);
                make.height.equalTo(@1);
            }];
            
            if (consultingInfo.count == i + 1) {
                valueL.numberOfLines = 0;
                [valueL setLineBreakMode:NSLineBreakByClipping];
                [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                    if([subInfo[@"projectName"] isEqualToString:@"备注"]){
                        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(40);
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(55);
                    }else{
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    }
                    make.height.greaterThanOrEqualTo(@55);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
            }else{
                [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.equalTo(@55);
                }];
            }
            
            valueLPre = valueL;
        }
    }else if ([title isEqualToString:@"故障现象"]){
        
        for (int i = 0; value.count > i; i++) {
            NSDictionary *subInfo = value[i];
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
            titleL.text = subInfo[@"faultPhenomenonName"];
            [titleL setTextColor:YHCellColor];
            UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
            [lineL setBackgroundColor:YHLineColor];
            [weakSelf.boxV addSubview:titleL];
            [weakSelf.boxV addSubview:lineL];
            
            if (value.count == i + 1) {
                
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.greaterThanOrEqualTo(@55);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
                
            }else{
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.height.equalTo(@55);
                }];
                
            }
            
            [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
                make.top.equalTo(valueLPre.mas_bottom).with.offset(-1);
                make.height.equalTo(@1);
            }];
            
            valueLPre = titleL;
        }
        
    }else{
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = value[0];
        titleL.numberOfLines = 0;
        [titleL setTextColor:YHCellColor];
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(valueLPre.mas_bottom).with.offset(20);
            make.width.equalTo(@(screenWidth - 40));
            make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-20);
        }];
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(valueLPre.mas_bottom).with.offset(-1);
            make.height.equalTo(@1);
        }];
    }
    
    
}

- (void)loadDatasourceTime:(NSDictionary*)modeInfo{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    //    _sysIG.hidden = YES;
    _titleLC.constant = 76;
    _boxVBottomLC.constant = 10;
    _priceF.hidden = YES;
    NSString *title = modeInfo[@"title"];
    _sysDesc.text = title;
    _sysDesc.textColor = YHCellColor;
    _sysIG.hidden = NO;
    [_sysIG setImage:[UIImage imageNamed:@"dateTimes"]];
    //    giveBack
    //
    //    giveBackTime
    //    overdueReason
    
    NSDictionary *giveBack =modeInfo[@"giveBack"];
    UILabel *titleDecsL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleDecsL.text = giveBack[@"giveBackTime"];
    [titleDecsL setTextColor:YHCellColor];
    
    [weakSelf.boxV addSubview:titleDecsL];
    
    NSString *overdueReason = giveBack[@"overdueReason"];
    if (overdueReason && ![overdueReason isEqualToString:@""]) {
        titleDecsL.numberOfLines = 0;
        [titleDecsL setContentMode:UIViewContentModeRight];
        [titleDecsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-10);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(0);
            make.height.equalTo(@55);
        }];
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:lineL];
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55.);
            make.height.equalTo(@1);
        }];
        
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageV.image = [UIImage imageNamed:@"dateOut"];
        [weakSelf.boxV addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(23);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55 + 12);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        
        UILabel *timeoutCaseTitleL = [[UILabel alloc] initWithFrame:CGRectZero];
        timeoutCaseTitleL.text = @"逾期原因";
        [timeoutCaseTitleL setTextColor:YHCellColor];
        [weakSelf.boxV addSubview:timeoutCaseTitleL];
        [timeoutCaseTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(76);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55);
            make.height.equalTo(@55);
        }];
        
        UILabel *timeoutCaseL = [[UILabel alloc] initWithFrame:CGRectZero];
        timeoutCaseL.text = overdueReason;
        [timeoutCaseL setTextColor:YHCellColor];
        [weakSelf.boxV addSubview:timeoutCaseL];
        
        //        timeoutCaseL.layer.borderWidth  = 1;
        //        timeoutCaseL.layer.borderColor  = YHLineColor.CGColor;
        //        timeoutCaseL.layer.cornerRadius = 5;
        timeoutCaseL.numberOfLines = 0;
        [timeoutCaseL setLineBreakMode:NSLineBreakByClipping];
        [timeoutCaseL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(110);
            make.height.greaterThanOrEqualTo(@55);
            make.width.equalTo([NSNumber numberWithFloat:screenWidth - 50]);
            make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-5);
        }];
        
        
        
    }else{
        titleDecsL.numberOfLines = 0;
        [titleDecsL setContentMode:UIViewContentModeRight];
        [titleDecsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(0);
            make.height.greaterThanOrEqualTo(@55);
            make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
        }];
    }

}

- (void)loadDatasourceProgramme:(NSDictionary*)modeInfo{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    //    _sysIG.hidden = YES;
    _titleLC.constant = 76;
    _boxVBottomLC.constant = 10;
    _priceF.hidden = YES;
    NSString *title = modeInfo[@"title"];
    _sysDesc.text = title;
    _sysDesc.textColor = YHHeaderTitleColor;
    _titleLC.constant = 15;
    _sysIG.hidden = YES;
//    [_sysIG setImage:[UIImage imageNamed:@"ershouche"]];
    
    UILabel *titleDecsL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleDecsL.text = modeInfo[@"schemeContent"];
    [titleDecsL setTextColor:YHCellColor];
    
    [weakSelf.boxV addSubview:titleDecsL];
    titleDecsL.numberOfLines = 0;
    [titleDecsL setContentMode:UIViewContentModeRight];
    [titleDecsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(30);
        make.top.equalTo(weakSelf.boxV.mas_top).with.offset(40);
        make.height.greaterThanOrEqualTo(@55);
        make.width.equalTo([NSNumber numberWithFloat:screenWidth - 80]);
        make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
    }];
}


- (void)loadDatasourceMode:(NSDictionary*)modeInfo isShowAllPrice:(BOOL)isShowAllPrice{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _priceF.hidden = YES;
    NSString *title = modeInfo[@"title"];
    _sysDesc.text = title;
    NSArray *value = modeInfo[@"value"];
    _allPriceBox.hidden = !isShowAllPrice;
    for (int i = 0; value.count > i; i++) {
        NSDictionary *subInfo = value[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.numberOfLines = 0;
        NSString *partsClassName = subInfo[@"partsName"];
        if (!partsClassName || [partsClassName isEqualToString:@""]) {
            partsClassName = subInfo[@"repairProjectName"];
        }
        if (!partsClassName || [partsClassName isEqualToString:@""]) {//云细检购买方案
            partsClassName = subInfo[@"className"];
        }
        if (!partsClassName || [partsClassName isEqualToString:@""]) {//故障信息
            partsClassName = subInfo[@"faultPhenomenonName"];
        }
        if (!partsClassName || [partsClassName isEqualToString:@""]) {//订单详情
            partsClassName = subInfo[@"key"];
        }
        titleL.text = partsClassName;
        [titleL setTextColor:YHCellColor];
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.textColor = YHCellColor;
        
        NSString *valueStr;
        NSString *shopItemQuote = subInfo[@"quote"];
        if (shopItemQuote && ![shopItemQuote isEqualToString:@""]) {
            valueStr = [NSString stringWithFormat:@"工时费:%@元", shopItemQuote];
        }
        NSNumber *depthPay = subInfo[@"price"];
        if (depthPay && depthPay.floatValue >= 0) {
            valueStr = [NSString stringWithFormat:@"¥%@元", depthPay];
        }
        
        if (!valueStr || [valueStr isEqualToString:@""]) {
            NSString *partsUnit = subInfo[@"partsUnit"];
            if (partsUnit && ![partsUnit isEqualToString:@""]) {
                partsUnit = [NSString stringWithFormat:@"(%@)", partsUnit];
            }else{
                partsUnit = @"";
            }
            NSString *scalar = subInfo[@"scalar"];
            if (scalar) {
                valueStr = [NSString stringWithFormat:@"数量:%@%@",  scalar, partsUnit];
            }else{
                valueStr = partsUnit;
            }
            NSString *shopPrice = subInfo[@"shopPrice"];
            if (shopPrice) {
                valueStr = [NSString stringWithFormat:@"%@ 单价:%@元",  valueStr, shopPrice];
            }
        }
        
        if (!valueStr || [valueStr isEqualToString:@""]) {
            if ([partsClassName isEqualToString:@"支付金额"]) {
                valueStr = [NSString stringWithFormat:@"¥%@", subInfo[@"value"]];
            }else{
                valueStr = subInfo[@"value"];
            }
        }
        
        if ([modeInfo[@"title"] isEqualToString:@"质保"] || [modeInfo[@"title"] isEqualToString:@"质保备注"]) {
            valueL.hidden = YES;
            _boxVBottomLC.constant = 10;
        }else{
            valueL.hidden = NO;
            if (!isShowAllPrice) {
                _boxVBottomLC.constant = 10;
            }else{
                _boxVBottomLC.constant = 75;
            }
        }
        valueL.text = valueStr;
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        
        if (value.count == i + 1) {
            titleL.numberOfLines = 0;
            [titleL setLineBreakMode:NSLineBreakByClipping];
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                make.height.greaterThanOrEqualTo(@55);
                make.width.equalTo([NSNumber numberWithFloat:screenWidth - 200]);
                make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
            }];
        }else{
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                make.width.equalTo([NSNumber numberWithFloat:screenWidth - 200]);
                make.height.equalTo(@55);
            }];
        }
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
        [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        NSNumber *isBlockPolicy = subInfo[@"isBlockPolicy"];
        if (isBlockPolicy.boolValue) {//延长保修标示
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imageV setImage:[UIImage imageNamed:@"warranty"]];
            [weakSelf.boxV addSubview:imageV];
            [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(40);
            }];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(titleL.mas_leading).with.offset(0);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) + 10);
//                make.top.equalTo(valueLPre.mas_bottom).with.offset(15);
                make.height.greaterThanOrEqualTo(@20);
                make.height.greaterThanOrEqualTo(@20);
            }];
        }
    }
    
    __block float priceValue = 0.0;
    for (NSDictionary *subItem in value) {
        NSString *price = subItem[@"shopPrice"];
        NSNumber *scalar = subItem[@"scalar"];
        float count = 2;
        if (scalar) {
            count = scalar.floatValue;
        }
        if (!price) {
            count = 1;
            price = subItem[@"quote"];
        }
        if (![price isEqualToString:@""] && price) {
            priceValue += (price.floatValue * count);
        }
    }
    
    [value enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *priceStr = item[@"price"];
        if (priceStr) {
            priceValue += priceStr.floatValue;
        }
    }];
    
    self.allPriceL.text = [NSString stringWithFormat:@"¥%.2f元", priceValue];
}

- (void)loadreportBillData:(NSDictionary*)info title:(NSString*)title{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _boxVBottomLC.constant = 75;
    
    _sysDesc.text = title;
    NSArray *reportBills = info[@"reportBills"];
    for (int i = 0; reportBills.count > i; i++) {
        NSDictionary *subInfo = reportBills[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = subInfo[@"billTypeName"];
        [titleL setTextColor:YHCellColor];
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.textColor = YHCellColor;
        valueL.text = [NSString stringWithFormat:@"¥%@", subInfo[@"quote"]];
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
        
        
        if (reportBills.count == i + 1) {
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                make.height.greaterThanOrEqualTo(@55);
                make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
            }];
        }else{
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                make.height.equalTo(@55);
            }];
        }
        
    }
    self.allPriceL.text = [NSString stringWithFormat:@"¥%@", info[@"reportTotalQuote"]];
}

- (void)loadDatasourceConsulting:(NSArray*)consultingInfo title:(NSString*)title{
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _boxVBottomLC.constant = 10;
    
    _sysDesc.text = title;
    for (int i = 0; consultingInfo.count > i; i++) {
        NSDictionary *subInfo = consultingInfo[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = subInfo[@"projectName"];
        [titleL setTextColor:YHCellColor];
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.textColor = YHCellColor;
        valueL.text = subInfo[@"projectVal"];//[YHTools yhStringByReplacing:subInfo[@"projectVal"]];
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
        
        
        if (consultingInfo.count == i + 1) {
            valueL.numberOfLines = 0;
            [valueL setLineBreakMode:NSLineBreakByClipping];
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                if([subInfo[@"projectName"] isEqualToString:@"备注"]){
                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(40);
                    make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) + 55);
                }else{
                    make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                }
                
                make.height.greaterThanOrEqualTo(@55);
                make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
            }];
        }else{
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                make.height.equalTo(@55);
            }];
        }
        
    }
}

- (void)loadDatasource:(NSArray*)infos title:(NSString*)title
{
    __weak __typeof__(self) weakSelf = self;
    
    NSArray *views = weakSelf.boxV.subviews ;
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    _boxVBottomLC.constant = 10;
    
    _sysDesc.text = title;
    
    _sysDesc.hidden = YES;
    
    int index = 1;
    for (int i = 0; infos.count > i; i++) {
        
        NSDictionary *subInfo = infos[i];
        
        //(1)工单类型名称
        UILabel *billTypeNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        billTypeNameL.text = subInfo[@"billTypeName"];
        [billTypeNameL setTextColor:YHCellColor];
        
        //(2)操作人
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
//        titleL.text = [NSString stringWithFormat:@"额欧文吧诶weWieWie诶weWieWieWieWieWieWie%@", subInfo[@"assignTech"]];
        titleL.numberOfLines = 2;
        titleL.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleL setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [titleL setTextColor:YHCellColor];
        titleL.text = [NSString stringWithFormat:@"%@",subInfo[@"assignTech"]];
        // 设置段落为左右对齐 NSTextAlignmentJustified
//        NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc]init];
//        par.alignment = NSTextAlignmentJustified;
//        par.lineSpacing = 5;
        NSMutableDictionary *dic = @{}.mutableCopy;
//        NSAttributedString *mstr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"我问你WWI问你WWI我问你问我我我我问你WWI%@",subInfo[@"assignTech"]] attributes:dic];
//        titleL.attributedText = mstr;
        
        
        NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        [dic setObject:titleL.font forKey:NSFontAttributeName];
        CGRect rect = [titleL.text boundingRectWithSize:CGSizeMake(174, MAXFLOAT)
                                         options:option
                                      attributes:dic
                                         context:nil];
        //经测试，向上取整可以减少误差
        CGFloat f = ceilf(rect.size.height);
        index = ceilf(f / 26);//行数
        //(3)进度
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.textColor = YHNaviColor;
        valueL.text = (([subInfo[@"billStatus"] isEqualToString:@"complete"])? (@"已完工") : (subInfo[@"nowStatusName"]));
        
        NSLog(@"============---%@---============",valueL.text);

        //(4)组外横刻线
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];

        //(5)组内横刻线
        UILabel *lineSL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineSL setBackgroundColor:YHWhiteColor];

        //(6)前往
        UIImageView *goImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_3"]];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.tag = [title isEqualToString:@"车况报告"]? (1000+i) : i;
        [button addTarget:self action:@selector(childButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [weakSelf.boxV addSubview:billTypeNameL];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        [weakSelf.boxV addSubview:lineSL];
        [weakSelf.boxV addSubview:button];
        [weakSelf.boxV addSubview:goImageView];
        
        UILabel *timeL = nil;
        if ([title isEqualToString:@"车况报告"]) {
            timeL = [[UILabel alloc] initWithFrame:CGRectZero];
            timeL.text = [NSString stringWithFormat:@"%@", subInfo[@"create_time"]];
            [timeL setTextColor:YHCellColor];
            timeL.textAlignment = NSTextAlignmentRight;
            [weakSelf.boxV addSubview:timeL];

            [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-20);
                make.centerY.equalTo(titleL.mas_centerY).offset(10);
            }];
        }
        
        CGFloat cellH = 120;
        if ([title isEqualToString:@"车况报告"]) {
            cellH = 118;
        }

        
        //(1)工单类型名称
        [billTypeNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset( cellH * i);
            make.height.equalTo(@40);
        }];
        
        //(2)操作人
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(index == 1 ? cellH * i + 50  : cellH * i + 40 );
            if ([title isEqualToString:@"车况报告"]) {
                make.height.mas_equalTo(48);
            }
           
            if(timeL){
            make.right.equalTo(timeL.mas_left).offset(-5);
            }
        }];
        
        
        //(4)组外横刻线
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(cellH * i -1);
            make.height.equalTo(@1);
        }];
        
        //(5)组内横刻线
        [lineSL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(cellH * i -1 + 40 );
            make.height.equalTo(@1);
        }];
        
        //(6)前往
        [goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-20);
            if(![title isEqualToString:@"车况报告"]) make.centerY.equalTo(titleL.mas_centerY);
            else make.centerY.equalTo(titleL.mas_centerY).offset(index == 1 ? -15 :-25);
            make.width.equalTo(@15);
            make.height.equalTo(@20);
        }];
        
        
        if (infos.count == i + 1) {
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                make.top.equalTo(titleL.mas_bottom).with.offset(0);
                make.height.greaterThanOrEqualTo(@40);
                make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
            }];
        }else{
            [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
                make.top.equalTo(titleL.mas_bottom).with.offset(0);
                make.height.equalTo(@40);
            }];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-0);
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(-0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset( cellH * i);
            make.bottom.equalTo(titleL);
        }];
    }
    
}

- (void)childButtonAction:(UIButton*)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationChildByTag object:nil userInfo:@{@"tag" : [NSNumber numberWithLong:button.tag]}];
}

- (void)loadDatasourceResult:(NSString*)result title:(NSString*)title{
    if (title) {
        _sysDesc.text = title;
    }
    _repairResultL.text = result;
}

- (void)loadDatasourceResult:(NSString*)result{
    [self loadDatasourceResult:result title:nil];
}

- (void)loadDatasourceInitialSurveyProject:(NSArray*)info sysClassId:(NSString*)sysClassId{
    [self loadDatasourceInitialSurveyProject:info sysClassId:sysClassId isPrice:NO isEditPrice:NO];
}


//FIXME:  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSDictionary *subInfo = self.info[collectionView.tag];
    NSArray <NSString *>*projectImgList = [subInfo valueForKey:@"projectRelativeImgList"];

    return projectImgList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTZPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *subInfo = self.info[collectionView.tag];
    NSArray <NSString *>*projectImgList = [subInfo valueForKey:@"projectRelativeImgList"];
    NSString *surl = projectImgList[indexPath.item];
    surl = [YHTools hmacsha1YHJns:surl width:50 * [UIScreen mainScreen].scale];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:surl] placeholderImage:[UIImage imageNamed:@"车辆右侧"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *subInfo = self.info[collectionView.tag];
    NSArray <NSString *>*projectImgList = [subInfo valueForKey:@"projectRelativeImgList"];
    NSMutableArray <NSString *>*urls = [NSMutableArray array];
    [projectImgList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [YHTools hmacsha1YHJns:obj width:0];
        [urls addObject:url];
    }];

    [YHHUPhotoBrowser showFromImageView:nil withURLStrings:urls atIndex:indexPath.item];
}
/*
 isPrice  是否是显示金额
 isEditPrice  是否是编辑金额
 */
- (void)loadDatasourceInitialSurveyProject:(NSArray*)info sysClassId:(NSString*)sysClassId isPrice:(BOOL)isPrice isEditPrice:(BOOL)isEditPrice{
    self.info = info;
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = NO;
    _sysIG.hidden = NO;
    _titleLC.constant = 76;
    _boxVBottomLC.constant = 10;
    
    NSArray *sysInfo = [YHTools sysProjectByKey:sysClassId];
    _sysIG.image = [UIImage imageNamed:sysInfo[1]];
    _sysDesc.text = sysInfo[0];
    UILabel *valueLPre = _sysDesc;
    for (int i = 0; info.count > i; i++) {
        NSDictionary *subInfo = info[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
#pragma mark - 😄

        NSString *name = subInfo[@"name"];
        if (!name) {
            name = subInfo[@"projectName"];
            if (!name) {
                name = @"售价";
            }
        }
        if ([name isEqualToString:@"左前"]
            || [name isEqualToString:@"右前"]
            || [name isEqualToString:@"左后"]
            || [name isEqualToString:@"右后"]
            || [name isEqualToString:@"高位"]) {//新全车左前右前等显示特殊处理，字体颜色特殊
            [titleL setTextColor:YHNaviColor];
        }else{
            [titleL setTextColor:YHCellColor];
        }
        titleL.text = name;
        titleL.numberOfLines = 0;
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        
        valueL.textColor = YHCellColor;
        [valueL setTextAlignment:NSTextAlignmentRight];
        valueL.numberOfLines = 0;
        [valueL setLineBreakMode:NSLineBreakByCharWrapping];
        NSString *unit = subInfo[@"unit"];
        if (!isPrice) { //显示金额， 不显示细检值
            NSString *projectVal = subInfo[@"projectVal"];
            if (![unit isEqualToString:@""] && ![projectVal isEqualToString:@""]) {
                valueL.text = [NSString  stringWithFormat:@"%@(%@)", subInfo[@"projectVal"], unit];
            }else{
                valueL.text = subInfo[@"projectVal"];
            }
        }
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        
#pragma mark - 😄+++
//        [subInfo setValue:(@[@"https://cdn.qimai.cn/test/201709/b93af413367e16e9941a48a6c6962c9a.png",@"https://cdn.qimai.cn/test/201709/b93af413367e16e9941a48a6c6962c9a.png",@"https://cdn.qimai.cn/test/201709/b93af413367e16e9941a48a6c6962c9a.png",@"https://cdn.qimai.cn/test/201709/b93af413367e16e9941a48a6c6962c9a.png",@"https://cdn.qimai.cn/qimai/201804/fb9cfcb1ec298beec2149f14685aa42a.jpg",@"https://cdn.qimai.cn/qimai/201804/fb9cfcb1ec298beec2149f14685aa42a.jpg",@"https://cdn.qimai.cn/qimai/201804/fb9cfcb1ec298beec2149f14685aa42a.jpg"].mutableCopy) forKey:@"projectImgList"];
        
        NSArray <NSString *>*projectImgList = [subInfo valueForKey:@"projectRelativeImgList"];
        CGFloat photoViewH = projectImgList.count? 50 : 0;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(photoViewH, photoViewH);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *photoView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];//[[UIView alloc] init];
        [photoView registerClass:[TTZPhotoCell class] forCellWithReuseIdentifier:@"cell"];
        photoView.showsHorizontalScrollIndicator = NO;
        photoView.tag = i;
        photoView.dataSource = self;
        photoView.delegate = self;
        photoView.backgroundColor = [UIColor whiteColor];
        photoView.bounces = NO;
        photoView.hidden = isEditPrice || isPrice;
        [weakSelf.boxV addSubview:photoView];
        
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
            make.height.equalTo(@55);
//            make.width.equalTo([NSNumber numberWithFloat:screenWidth - 170]);
            make.width.equalTo(@(screenWidth *0.5 - 45));
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(valueLPre.mas_bottom).with.offset(-1);
            make.height.equalTo(@1);
        }];
        
        
        
        if (isPrice) {
            UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectZero];
            priceL.numberOfLines = 0;
            if (isEditPrice) {
                priceL.text = @"元";
                [priceL setTextColor:YHCellColor];
                [priceL setTextAlignment:NSTextAlignmentRight];
                
                NSString *cloudQuote = subInfo[@"cloudQuote"];
                if (cloudQuote) {
                    UILabel *cloudQuoteL = [[UILabel alloc] initWithFrame:CGRectZero];
                    [weakSelf.boxV addSubview:cloudQuoteL];
                    [cloudQuoteL setTextColor:YHCellColor];
                    cloudQuoteL.text = [NSString stringWithFormat:@"报价%@元", cloudQuote];
                    [cloudQuoteL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                        make.centerX.equalTo(weakSelf.boxV.mas_centerX).with.offset(0);
                        make.height.greaterThanOrEqualTo(@55);
                    }];
                }
                
                UITextField *txFT = [[UITextField alloc] initWithFrame:CGRectZero];
                txFT.placeholder = @"必填";
                [txFT setTextAlignment:NSTextAlignmentRight];
                txFT.tag = i;
                txFT.delegate = self;
                NSString *price = subInfo[@"price"];
                if (price) {
                    txFT.text = price;
                }
                [weakSelf.boxV addSubview:priceL];
                [weakSelf.boxV addSubview:txFT];
                
                [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-15);
                    make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                    make.height.greaterThanOrEqualTo(@55);
                }];
                
                [txFT mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-35);
                    make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
                    make.width.equalTo(@100);
                    make.height.greaterThanOrEqualTo(@55);
                }];
            }else{//报价操作
                NSString *price = subInfo[@"price"];
                if (!price) {
                    price = subInfo[@"storeQuote"];
                }
                if (price) {
                    NSString *projectVal = subInfo[@"projectVal"];
                    if (![unit isEqualToString:@""] && ![projectVal isEqualToString:@""] && projectVal && unit) {
                        projectVal = [NSString  stringWithFormat:@"数值:%@(%@)", subInfo[@"projectVal"], unit];
                    }else if (![projectVal isEqualToString:@""] && projectVal) {
                        projectVal = [NSString  stringWithFormat:@"数值:%@", subInfo[@"projectVal"]];
                    }else{
                        projectVal = @"";
                    }
                    
                    priceL.text = [NSString stringWithFormat:@"%@ 价格:¥%@元", projectVal, price];
                    [priceL setTextColor:YHCellColor];
                    [priceL setTextAlignment:NSTextAlignmentRight];
                    [weakSelf.boxV addSubview:priceL];
                    
                    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-15);
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                        make.height.greaterThanOrEqualTo(@55);
                    }];
                    
                }else{
                    priceL.text = @"待报价";
                    [priceL setTextColor:YHCellColor];
                    [priceL setTextAlignment:NSTextAlignmentRight];
                    [weakSelf.boxV addSubview:priceL];
                    
                    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-35);
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                        make.height.equalTo(@55);
                    }];
                }
            }
            
            
            if (info.count == i + 1) {
                //细检数值位置刷新
                [priceL mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-15);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.width.equalTo([NSNumber numberWithFloat:screenWidth - 140]);
                    make.height.greaterThanOrEqualTo(@55);
#pragma mark - 😄---

//                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
                
#pragma mark - 😄+++
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(valueL.mas_bottom);
                    make.left.mas_equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.right.mas_equalTo(weakSelf.boxV.mas_right).with.offset(-20);
                    make.height.mas_equalTo(photoViewH);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];

                
            }else{
                //细检数值位置刷新
                [priceL mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-15);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
                    make.width.equalTo([NSNumber numberWithFloat:screenWidth - 140]);
                    make.height.greaterThanOrEqualTo(@55);
                }];
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(valueL.mas_bottom);
                    make.left.mas_equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.right.mas_equalTo(weakSelf.boxV.mas_right).with.offset(-20);
                    make.height.mas_equalTo(photoViewH);
                }];

            }
#pragma mark - 😄---
            if (isPrice || isEditPrice) {
                valueLPre = priceL;
            }else{
                valueLPre = photoView;
            }
        }else{
            if (info.count == i + 1) {
                
                [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                    if([name isEqualToString:@"气缸压力"]){
                        [valueL setTextAlignment:NSTextAlignmentLeft];
//                        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(40);
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(55);
                        make.width.equalTo(@(screenWidth - 40 - 25));
                    }else{
                        make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
//                        make.left.equalTo(weakSelf.boxV.mas_left).with.offset(150);
//                        make.width.equalTo(@(screenWidth - 150 - 25));
                        make.width.equalTo(@(screenWidth *0.5 - 45));
                    }
                    make.height.greaterThanOrEqualTo(@55);
#pragma mark - 😄---
//                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];
                
#pragma mark - 😄+++
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(valueL.mas_bottom);
                    make.left.mas_equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.right.mas_equalTo(weakSelf.boxV.mas_right).with.offset(-20);
                    make.height.mas_equalTo(photoViewH);
                    make.bottom.equalTo(weakSelf.boxV.mas_bottom).with.offset(-0);
                }];

                
            }else{
                
                
                [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.boxV.mas_right).with.offset(-25);
                    make.top.equalTo(valueLPre.mas_bottom).with.offset(0);
//                    make.left.equalTo(weakSelf.boxV.mas_left).with.offset(150);
//                    make.width.equalTo(@(screenWidth - 150 - 25));
                    make.width.equalTo(@(screenWidth *0.5 - 45));
                    make.height.greaterThanOrEqualTo(@55);
                }];
#pragma mark - 😄+++
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(valueL.mas_bottom);
                    make.left.mas_equalTo(weakSelf.boxV.mas_left).with.offset(20);
                    make.right.mas_equalTo(weakSelf.boxV.mas_right).with.offset(-20);
                    make.height.mas_equalTo(photoViewH);
                }];

            }
#pragma mark - 😄---
            if (isPrice || isEditPrice) {
                valueLPre = valueL;
            }else{
                valueLPre = photoView;
            }
        }
        
    }
}

- (void)loadDatasource:(NSDictionary*)sysInfo{
    
    __weak __typeof__(self) weakSelf = self;
    NSArray *views = weakSelf.boxV.subviews ;//
    views = [views subarrayWithRange:NSMakeRange(4, views.count - 4)];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    _linwV.hidden = YES;
    _sysIG.hidden = YES;
    _titleLC.constant = 35;
    
    _sysDesc.text = sysInfo[@"sysTitle"];
    NSArray *sysSubs = sysInfo[@"sysSubs"];
    for (int i = 0; sysSubs.count > i; i++) {
        NSDictionary *subInfo = sysSubs[i];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = subInfo[@"sysSub"];
        [titleL setTextColor:YHCellColor];
        UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        valueL.text = subInfo[@"sysValue"];
        [valueL setTextColor:YHCellColor];
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectZero];
        [lineL setBackgroundColor:YHLineColor];
        [weakSelf.boxV addSubview:titleL];
        [weakSelf.boxV addSubview:valueL];
        [weakSelf.boxV addSubview:lineL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(20);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1));
            make.height.equalTo(@55);
        }];
        
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.boxV.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.boxV.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.boxV.mas_top).with.offset(55. * (i + 1) -1);
            make.height.equalTo(@1);
        }];
    }
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *subInfo = _info[textField.tag];
    
    NSString *price = textField.text;
    if ([self isPureFloat:price]) {
        if (price.floatValue < 0) {
            [MBProgressHUD showError:@"请填写正确数值"];
            textField.text = @"";
        }else{
            [subInfo setObject:price forKey:@"price"];
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationPriceChange object:nil userInfo:nil];
        }
    }else{
        if ([price isEqualToString:@""]) {
            return;
        }
        [MBProgressHUD showError:@"请填写正确数值"];
        textField.text = @"";
    }
}
@end


@implementation TTZPhotoCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        kViewRadius(_imageView, 5);
    }
    return _imageView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}
@end
