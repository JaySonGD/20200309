//
//  YHAddModifyProjectVc.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAddModifyProjectVc.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHStoreTool.h"
#import <Masonry.h>
#import "YHSetPartSearchView.h"

#import "YHCommon.h"

//#import "MBProgressHUD+MJ.h"
#import "YJProgressHUD.h"

#define background_color [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]
#define text_color [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0]

@interface YHAddModifyProjectVc () <YHSetPartSearchViewDelegate>

@property (nonatomic, weak) YHSetPartSearchView *searchView;

//@property (nonatomic, weak) UITableView *searchTableView;

@property (nonatomic, weak) UIButton *addPartBtn;

//@property (nonatomic, weak) UILabel *promptL;

@end

@implementation YHAddModifyProjectVc

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = background_color;
    
    [self initUI];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.searchView setTextFieldText:self.searchText];
    
}

- (void)initUI{
    
    // 搜索框
    YHSetPartSearchView *searchView = [[YHSetPartSearchView alloc] init];
    [searchView setSearchBtnIsHides:YES];
    self.searchView = searchView;
    searchView.delegate = self;
//    __weak typeof(self)weakSelf = self;
    searchView.searchBtnClickBlock = ^(NSString *searchStr) {
       
    };
    CGFloat topMargin = iPhoneX ? 88 : 64;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
//    // initTableView
//    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    searchTableView.delegate = self;
//    searchTableView.dataSource = self;
//    searchTableView.tableFooterView = [[UIView alloc] init];
//    searchTableView.backgroundColor = [UIColor clearColor];
//    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    searchTableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
//    self.searchTableView = searchTableView;
//    [self.view addSubview:searchTableView];
//
//    [searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(searchView.mas_bottom);
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.bottom.equalTo(@0);
//    }];
    
    UIButton *addPartBtn = [[UIButton alloc] init];
    [addPartBtn setTitle:@"添加新项目" forState:UIControlStateNormal];
    self.addPartBtn = addPartBtn;
    [self.view addSubview:addPartBtn];
    addPartBtn.backgroundColor = YHNaviColor;
    addPartBtn.layer.cornerRadius = 5.0;
    addPartBtn.layer.masksToBounds = YES;
    [addPartBtn addTarget:self action:@selector(addPartBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMargin = iPhoneX ? -34 : -10;
    [addPartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(addPartBtn.superview).offset(-10);
        make.bottom.equalTo(addPartBtn.superview).offset(bottomMargin);
        make.height.equalTo(@40);
    }];
    // 提示语
//    UILabel *promptL = [[UILabel alloc] init];
//    self.promptL = promptL;
//    promptL.textColor = text_color;
//    promptL.hidden = YES;
//
//    [self.view addSubview:promptL];
//    [promptL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(searchView.mas_bottom);
//        make.left.equalTo(@20);
//        make.right.equalTo(@20);
//        make.height.equalTo(@40);
//    }];
    
}

#pragma mark - 添加 --
- (void)addPartBtnClickEvent{
    
    if (self.searchView.inputTf.text.length == 0) {
        [MBProgressHUD showError:@"请输入要增加的维修项目名称"];
        return;
    }
    
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [YJProgressHUD showProgress:@"" inView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] addRepairProject:[YHTools getAccessToken] repairProjectName:self.searchView.inputTf.text onComplete:^(NSDictionary *info) {
        [YJProgressHUD hide];
//        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        NSString *msg = info[@"msg"];
        if (code == 20000) {
        
            [MBProgressHUD showError:@"添加成功" toView:self.view];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_notificationToSearchViewBlockFromProject) {
                    _notificationToSearchViewBlockFromProject(self.searchView.inputTf.text);
                }
                 [self.navigationController popViewControllerAnimated:YES];
            });
           
        }else{
            [YJProgressHUD hide];
//            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } onError:^(NSError *error) {
        [YJProgressHUD hide];
//        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
        
    }];
    
    
}
- (void)setPartSearchViewTextFieldStartEdit{
    
}
@end
