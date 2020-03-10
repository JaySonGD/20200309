//
//  YHFourWheelsHeadView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHFourWheelsHeadView.h"
#import <Masonry/Masonry.h>

#import "YHAddPictureContentView.h"
#import "YHCommon.h"

#import "NSString+add.h"

@interface YHFourWheelsHeadView () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *leftL;
@property (nonatomic, weak) UILabel *speedL;
@property (nonatomic, weak) UITextField *speedTef;

@end

@implementation YHFourWheelsHeadView

- (instancetype)initWithFrame:(CGRect)frame billd:(NSString *)billd{
    if (self = [super initWithFrame:frame]) {
        
        self.billID = billd;
        
        [self initFourWheelsHeadView];
    }
    return self;
}
- (NSString *)getDistance{
    return self.speedTef.text;
}
- (void)initFourWheelsHeadView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftL = [[UILabel alloc] init];
    self.leftL = leftL;
    leftL.font = [UIFont systemFontOfSize:17.0];
    leftL.textAlignment = NSTextAlignmentRight;
    leftL.textColor = YHColor(136, 136, 136);
    [self addSubview:leftL];
    CGFloat marginX = 20;
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(0);
    }];
    
    
    UILabel *speedL = [[UILabel alloc] init];
    speedL.textColor = YHColor(178, 178, 178);
    self.speedL = speedL;
    speedL.font = [UIFont systemFontOfSize:14];
    [self addSubview:speedL];
    [speedL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftL.mas_left).and.offset(80);
        make.top.equalTo(leftL.mas_top);
        make.width.mas_equalTo(70);
        make.height.equalTo(leftL.mas_height);
    }];
    // 纵向分隔线
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = YHLineColor;
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(speedL.mas_left).and.mas_offset(70);
        make.top.equalTo(@5);
        make.width.equalTo(@1);
        make.height.equalTo(@50);
    }];
    
    UITextField *speedTef = [[UITextField alloc] init];
    self.speedTef = speedTef;
    speedTef.delegate = self;
    speedTef.font = [UIFont systemFontOfSize:14];
    speedTef.placeholder = @"请输入刹车距离";
    [self addSubview:speedTef];
    
    UILabel *rightL  = [[UILabel alloc] init];
    rightL.textColor = YHColor(192, 192, 192);
    rightL.font = [UIFont systemFontOfSize:17];
    rightL.text = @"m";
    [self addSubview:rightL];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightL.superview).and.offset(-20);
        make.top.equalTo(leftL.mas_top);
        make.width.equalTo(@20);
        make.height.equalTo(leftL.mas_height);
    }];
    // 横向分隔线
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = YHLineColor;
    [self addSubview:lineH];
    [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineH.superview);
        make.top.mas_equalTo(60);
        make.width.equalTo(lineH.superview);
        make.height.equalTo(@1);
    }];
    
    [speedTef mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineV.mas_left).and.offset(25);
        make.top.equalTo(speedL.mas_top);
        make.height.equalTo(leftL.mas_height);
        make.right.equalTo(speedTef.superview).and.offset(-40);
        
    }];
    
    UIView *sepriteLineV = [[UIView alloc] init];
    sepriteLineV.backgroundColor = YHLineColor;
    [self addSubview:sepriteLineV];
    
    [sepriteLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.left.equalTo(sepriteLineV.superview);
        make.width.equalTo(sepriteLineV.superview);
        make.bottom.equalTo(sepriteLineV.superview);
    }];
    
    YHAddPictureContentView *addPicView = [[YHAddPictureContentView alloc] initWithBilld:self.billID];
    [self addSubview:addPicView];
    [addPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addPicView.superview).and.offset(67);
        make.bottom.equalTo(addPicView.superview).and.offset(-10);
        make.left.equalTo(addPicView.superview);
        make.right.equalTo(addPicView.superview);
        
    }];
}
- (void)setBrakeDict:(NSDictionary *)brakeDict{
    _brakeDict = brakeDict;
    NSString *title = brakeDict[@"projectName"];
    NSArray *arr = [title componentsSeparatedByString:@"("];
    self.leftL.text = arr.firstObject;
    self.speedL.text = [@"(" stringByAppendingString:arr.lastObject];
    
}

- (void)setBillID:(NSString *)billID{
    _billID = billID;
    NSString *key = [NSString stringWithFormat:@"%@", billID];
    key = [key stringByAppendingString:@"YHFour_distance_brake"];
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (![NSString stringIsNull:text]) {
        self.speedTef.text = text;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    NSString *key = [NSString stringWithFormat:@"%@",self.billID];
    key = [key stringByAppendingString:@"YHFour_distance_brake"];
    
    [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
