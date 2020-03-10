//
//  YHHomeFunctionCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHHomeFunctionCell.h"

extern NSString *const notificationFunction;
@interface YHHomeFunctionCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *icons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *strs;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxs;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)functionAction:(id)sender;
@property (strong, nonatomic)NSArray *items;
@end

@implementation YHHomeFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)loadDatasource:(NSArray*)source{
    self.items = source;
    
    NSArray *functionsInfo = @[@{@"str" : @"帮检",
                                 @"img" :  @"menu1",
                                 @"img2" :  @"menu1"
                                 },
                               @{@"str" : @"认证车源",//@"拍车",
                                 @"img" :  @"menu2-1",//@"menu2",
                                 @"img2" :  @"menu2-1",//@"menu2"
                                 },
                               @{@"str" : @"质保车源",
                                 @"img" :  @"menu3",
                                 @"img2" :  @"menu3"
                                 },
                               @{@"str" : @"财富",
                                 @"img" :  @"menu4",
                                 @"img2" :  @"menu4"
                                 },
                               @{@"str" : @"售后",
                                 @"img" :  @"menu5",
                                 @"img2" :  @"menu5"
                                 },
                               @{@"str" : @"扫一扫",
                                 @"img" :  @"icon_Scan",
                                 @"img2" :  @"icon_Scan"
                                 },
                               @{@"str" : @"ERP",//@"车源管理",
                                 @"img" :  @"menu7",//@"menu10",
                                 @"img2" :  @"menu7",//@"menu10"
                                 },
                               @{@"str" : @"培训",
                                 @"img" :  @"menu9",
                                 @"img2" :  @"menu9"
                                 },
                               @{@"str" : @"帮手",
                                 @"img" :  @"menu8",
                                 @"img2" :  @"menu8"
                                 },
                               @{@"str" : @"开发中",
                                 @"img" :  @"menu1",
                                 @"img2" :  @"menu1"
                                 }
                               ];
    [_boxs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (source.count > idx) {
            NSNumber *functionK = source[idx];
            NSDictionary *info = functionsInfo[(YHFunctionId)functionK.integerValue];
            UIImageView *imgView = _icons[idx];
            [imgView setImage:[UIImage imageNamed:info[@"img2"]]];
            imgView.hidden = NO;
            
            UILabel *lable = _strs[idx];
            [lable setText:info[@"str"]];
            lable.hidden = NO;
            
//            if(![info[@"img2"]length]){
//                lable.font = [UIFont systemFontOfSize:20];
//                lable.numberOfLines = 2;
//                [lable mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.equalTo(@42);
//                    make.centerY.offset(0);
//                }];
//            }
            
            
            UIButton *button = _buttons[idx];
            button.hidden = NO;
        }else{
            
            UIImageView *imgView = _icons[idx];
            imgView.hidden = YES;
            UILabel *lable = _strs[idx];
            lable.hidden = YES;
            UIButton *button = _buttons[idx];
            button.hidden = YES;
        }
    }];
    
}

- (IBAction)functionAction:(UIButton*)sender {
    
    NSUInteger tag = sender.tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationFunction object:_items[tag] userInfo:nil];
}
@end
