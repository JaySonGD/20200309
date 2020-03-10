//
//  YHMyBankCardController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMyBankCardController.h"
#import "YHBindBankCordView.h"
#import "YHRichBindBankCardController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"

#import "YHSVProgressHUD.h"

@interface YHMyBankCardController ()

@property (nonatomic, weak) YHBindBankCordView *bindBankCordView;

@property (nonatomic, copy) NSString *bankCardId;

//是否有正在提现的记录 0 没有 1 有
@property (nonatomic, copy) NSString *isWithDraw;

@end

@implementation YHMyBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyBankCardInfoSuccess) name:@"bindOrModifyBankCardSuccessNotification" object:nil];
    
    [self initMyBankCardControllerUI];
    // 获取银行卡绑定信息
    [self getBindBankCardInfo];
}

- (void)initMyBankCardControllerUI{
    
    YHBindBankCordView *bindBankCordView = [[[NSBundle mainBundle] loadNibNamed:@"YHBindBankCordView" owner:nil options:nil] firstObject];
    self.bindBankCordView = bindBankCordView;
    bindBankCordView.autoresizingMask = UIViewAutoresizingNone;
    bindBankCordView.layer.borderColor = [UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0].CGColor;
    bindBankCordView.layer.borderWidth = 1.0;
    bindBankCordView.layer.cornerRadius = 10.0;
    bindBankCordView.layer.masksToBounds = YES;
    [self.view addSubview:bindBankCordView];
    
    CGFloat topMargin = IphoneX ? 88.0 : 64.0;
    [bindBankCordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bindBankCordView.superview);
        make.top.equalTo(@(topMargin + 20));
        make.width.equalTo(@340);
        make.height.equalTo(@120);
    }];
    
    //修改银行卡
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
}

- (void)modifyBankCardInfoSuccess{
    
    [self getBindBankCardInfo];
}
- (void)dealloc{
    NSLog(@"%@--------dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - -----------------------银行卡修改按钮显示权限判断(MWF)-------------------------
- (void)rightBtnClicked{
    if ([self.isWithDraw isEqualToString:@"0"]) {
        YHRichBindBankCardController *richBankCardVc = [[YHRichBindBankCardController alloc] init];
        richBankCardVc.isModifyBank = YES;
        richBankCardVc.bankCardId = self.bankCardId;
        [self.navigationController pushViewController:richBankCardVc animated:YES];
    } else if ([self.isWithDraw isEqualToString:@"1"]){
        [MBProgressHUD showError:@"您还有提现未到账，暂时无法更换银行卡"];
    } else {
        
    }
}

#pragma mark - ---------------------------------获取银行卡绑定信息(MWF)------------------------------------
- (void)getBindBankCardInfo{
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getBankCardInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            NSDictionary *result = info[@"result"];
            NSString *bank = result[@"bank"];
            NSString *cardNum = result[@"cardNum"];
            self.bankCardId = result[@"id"];
            self.isWithDraw = result[@"isWithDraw"];
            [self.bindBankCordView setBankLogoImageViewUrlString:[self urlStringWithBankName:bank]];
            [self.bindBankCordView setBankCardNumber:[NSString stringWithFormat:@"%@************%@",[cardNum substringToIndex:4],[cardNum substringFromIndex:cardNum.length - 4]]];
        }else{
            NSString *retMsg = info[@"retMsg"];
            [MBProgressHUD showError:retMsg];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark - 通过银行名称返回银行logo地址 ----
- (NSString *)urlStringWithBankName:(NSString *)bankName{
    
    NSString *urlString = nil;
    for (int i = 0; i<[self bankDataArr].count; i++) {
        
        NSDictionary *bankDict = [self bankDataArr][i];
        if ([bankDict[@"title"] isEqualToString:bankName]) {
            urlString = [NSString stringWithFormat:@"%s/files/images/bank_logo/%@",SERVER_JAVA_URL,bankDict[@"logo"]];
        }
    }
    
    return urlString;
}

- (NSMutableArray *)bankDataArr{
    
    NSMutableArray *bankArr = @[
                                @{
                                    @"logo":@"1_icbc.png",
                                    @"title":@"中国工商银行"
                                    },
                                @{
                                    @"logo":@"2_abc.png",
                                    @"title":@"中国农业银行"
                                    },
                                @{
                                    @"logo":@"3_bc.png",
                                    @"title":@"中国银行"
                                    },
                                @{
                                    @"logo":@"4_ccb.png",
                                    @"title":@"中国建设银行"
                                    },
                                @{
                                    @"logo":@"5_boc.png",
                                    @"title":@"交通银行"
                                    },
                                @{
                                    @"logo":@"6_sbc.png",
                                    @"title":@"中国邮政储蓄银行"
                                    },
                                @{
                                    @"logo":@"7_cmb.png",
                                    @"title":@"招商银行"
                                    },
                                @{
                                    @"logo":@"8_pab.png",
                                    @"title":@"平安银行"
                                    },
                                @{
                                    @"logo":@"9_cmb.png",
                                    @"title":@"民生银行"
                                    },
                                @{
                                    @"logo":@"10_ceb.png",
                                    @"title":@"中国光大银行"
                                    },
                                @{
                                    @"logo":@"11_hxb.png",
                                    @"title":@"华夏银行"
                                    },
                                @{
                                    @"logo":@"12_ccb.png",
                                    @"title":@"中信银行"
                                    },
                                @{
                                    @"logo":@"13_spdb.png",
                                    @"title":@"浦发银行"
                                    },
                                @{
                                    @"logo":@"14_cgb.png",
                                    @"title":@"广发银行"
                                    },
                                @{
                                    @"logo":@"15_ibc.png",
                                    @"title":@"兴业银行"
                                    }
                                ].mutableCopy;
    return bankArr;
}
@end
