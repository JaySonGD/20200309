//
//  YHAddPartVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  增加配件耗材

#import "YHAddPartVC.h"
#import "YHAddPartInfoView.h"
#import "YHAddPartTypeView.h"
#import <Masonry.h>

#import "YHCommon.h"
#import "YHTools.h"
#import "YHNetworkPHPManager.h"
#import "YHStoreTool.h"



#define background_color [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]
#define background_color_Btn_NO [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0]

@interface YHAddPartVC () <YHAddPartInfoViewDelegate>

@property (nonatomic, weak)YHAddPartInfoView *nameInfo;

@property (nonatomic, weak)UIButton *addBtn;

@property (nonatomic, weak)YHAddPartInfoView *unitInfo;

@property (nonatomic, assign) BOOL isSelectLeft;

@end

@implementation YHAddPartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAddPartBase];
    
    [self initAddPartUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.nameInfo.inputTft.text = self.searchText;
    if (self.searchText.length > 0) {
        self.addBtn.enabled = YES;
        self.addBtn.backgroundColor = YHNaviColor;
    }else{
        self.addBtn.enabled = NO;
        self.addBtn.backgroundColor = background_color_Btn_NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_notificationToSearchViewBlock) {
        _notificationToSearchViewBlock(self.nameInfo.inputTft.text);
    }
   
}
- (void)initAddPartBase{
    
    self.title = @"增加配件耗材";
    self.view.backgroundColor = background_color;
}
- (void)initAddPartUI{
    
    YHAddPartTypeView *typeView = [[YHAddPartTypeView alloc] init];
    [self.view addSubview:typeView];
    CGFloat topMargin = iPhoneX ? 88 : 64;
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@(topMargin));
    }];
    typeView.isSelectLeftBtn = YES;
    self.isSelectLeft = typeView.isSelectLeftBtn;
    __weak typeof(self)weakSelf = self;
    typeView.selectBtnClickEvent = ^(BOOL isSelectLeft) {
        weakSelf.isSelectLeft = isSelectLeft;
        if (isSelectLeft) {
            [weakSelf.nameInfo setTextFieldPlacehold:@"请输入配件名称"];
            
        }else{
            [weakSelf.nameInfo setTextFieldPlacehold:@"请输入耗材名称"];
        }
    };
    
    YHAddPartInfoView *nameInfo = [[YHAddPartInfoView alloc] init];
    nameInfo.delegate = self;
    self.nameInfo = nameInfo;
    [nameInfo setTitleLableText:@"名称"];
    [nameInfo setTextFieldPlacehold:@"请输入配件名称"];
    [self.view addSubview:nameInfo];
    [nameInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeView.mas_bottom).offset(1);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(typeView);
    }];
    
    YHAddPartInfoView *unitInfo = [[YHAddPartInfoView alloc] init];
    [unitInfo setTitleLableText:self.searchText];
    unitInfo.delegate = self;
    self.unitInfo = unitInfo;
    [unitInfo setTitleLableText:@"单位"];
    [unitInfo setTextFieldPlacehold:@"请设置单位"];
    [self.view addSubview:unitInfo];
    [unitInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameInfo.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(typeView);
    }];
    
    // 添加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.enabled = NO;
    self.addBtn = addBtn;
    [self.view addSubview:addBtn];
    addBtn.backgroundColor = background_color_Btn_NO;
    addBtn.layer.cornerRadius = 5.0;
    addBtn.layer.masksToBounds = YES;
    [addBtn setTitle:@"添 加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(addBtn.superview).offset(-10);
        make.bottom.equalTo(addBtn.superview).offset(bottomMargin);
        make.height.equalTo(@40);
    }];
    
}

- (void)setNaviBarTitle:(NSString *)naviBarTitle{
    self.title = naviBarTitle;
}

#pragma mark - 添加按钮 ---
- (void)addBtnClickEvent{
    
    NSString *type = self.isSelectLeft ? @"1" : @"2";
    [MBProgressHUD showMessage:@"" toView:self.view];
   
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] addParts:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] partsName:self.nameInfo.inputTft.text type:type partsUnit:self.unitInfo.inputTft.text onComplete:^(NSDictionary *info) {
       
        [MBProgressHUD hideHUDForView:self.view];
        
        int code = [info[@"code"] intValue];
        NSString *msg = info[@"msg"];
        if (code == 20000) { // 添加成功
            
            [MBProgressHUD showError:@"添加成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
#pragma mark - YHAddPartInfoViewDelegate --
- (void)YHAddPartInfoView:(YHAddPartInfoView *)infoView changedText:(NSString *)text{
        
    if (infoView == self.nameInfo) {
        
        if (text.length > 0) {
            self.addBtn.enabled = YES;
            self.addBtn.backgroundColor = YHNaviColor;
        }else{
            self.addBtn.enabled = NO;
            self.addBtn.backgroundColor = background_color_Btn_NO;
        }
    }
}
- (void)dealloc{
    
    NSLog(@"%@--dead",NSStringFromClass([self class]));
}
@end
