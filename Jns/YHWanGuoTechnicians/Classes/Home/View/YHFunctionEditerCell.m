//
//  YHFunctionEditerCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHFunctionEditerCell.h"
#import "YHCommon.h"
extern NSString *const notificationFunctionDel;
extern NSString *const notificationFunctionAdd;
@interface YHFunctionEditerCell ()
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *strL;
@property (nonatomic)BOOL isHome;
@property (weak, nonatomic)NSNumber *functionKey;
- (IBAction)editerAction:(id)sender;
@end
@implementation YHFunctionEditerCell

- (void)loadDatasource:(NSNumber*)functionKey isEditer:(BOOL)isEditer isHome:(BOOL)isHome{
    self.isHome = isHome;
    self.functionKey = functionKey;
    NSArray *functionsInfo = @[@{@"str" : @"新建工单",
                                 @"img" :  @"home_28"
                                 },
                               @{@"str" : @"未处理工单",
                                 @"img" :  @"home_14"
                                 },
                               @{@"str" : @"历史工单",
                                 @"img" :  @"home_27"
                                 },
                               @{@"str" : @"全部功能",
                                 @"img" :  @"home_5"
                                 }
                               ];
    NSDictionary *info = functionsInfo[functionKey.integerValue];
    [_iconImgView setImage:[UIImage imageNamed:info[@"img"]]];
    [_strL setText:info[@"str"]];
    self.layer.borderWidth  = 1;
    if (isEditer) {
        self.layer.borderColor  = YHLineColor.CGColor;
    }else{
        self.layer.borderColor  = [UIColor whiteColor].CGColor;
    }
    self.contentView.layer.borderColor  = YHLineColor.CGColor;
    self.contentView.layer.borderWidth  = 1;

    _flagButton.hidden = !isEditer;
    
    [_flagButton setImage:((_isHome)? ([UIImage imageNamed:@"home_6"]) : ([UIImage imageNamed:@"home_20"])) forState:UIControlStateNormal];
}


- (IBAction)editerAction:(id)sender{
    if (_isHome) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationFunctionDel object:_functionKey userInfo:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationFunctionAdd object:_functionKey userInfo:nil];
    }
}
@end
