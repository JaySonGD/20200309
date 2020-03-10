//
//  YHEditDiagnoseResultVc.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/29.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHEditDiagnoseResultVc.h"
#import "YHCommon.h"
#import <Masonry.h>
#import "IQKeyboardManager.h"
#import "YHTools.h"
#import "YHStoreTool.h"
#import "YHNetworkPHPManager.h"
#import "YHStoreTool.h"

#define text_color [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0]

@interface YHEditDiagnoseResultVc () <UITextViewDelegate>

@property (nonatomic, weak) UITextView *resTextview;

@end

@implementation YHEditDiagnoseResultVc

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initEditDiagnoseResultUI];
    [self initEditDiagnoseResultBase];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)initEditDiagnoseResultBase{
    
    self.title = self.type ? self.type == 1 ? @"诊断思路" : @"诊断结果"  : @"编辑诊断结果";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveResultMethod)];
    self.resTextview.text = self.type ? self.type == 1 ? @"请输入诊断思路内容" : @"请输入诊断结果内容"  :  @"输入结果";
    if (self.diagnoseResultText.length) {
        self.resTextview.text = self.diagnoseResultText;
    }
    self.resTextview.font = [UIFont systemFontOfSize:16.0];
    self.resTextview.textColor = text_color;
    self.resTextview.showsVerticalScrollIndicator = NO;
    self.resTextview.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (void)setDiagnoseResultText:(NSString *)diagnoseResultText{
    _diagnoseResultText = diagnoseResultText;
    if (diagnoseResultText.length) {
        self.resTextview.text = diagnoseResultText;
    }
}


#pragma mark - 保存 -----
- (void)saveResultMethod{
    
    self.type ? [self saveEdutResult:self.resTextview.text] : [self saveTemporaryData:self.resTextview.text];
}

- (void)saveEdutResult:(NSString *)resultText{
   
    if ([resultText isEqualToString:self.type == 1 ? @"请输入诊断思路内容" : @"请输入诊断结果内容"] || !resultText.length) {
        [MBProgressHUD showError:self.type == 1 ? @"请输入诊断思路内容" : @"请输入诊断结果内容"];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveEditResultToken:[YHTools getAccessToken] billId:self.bill_id editResult:resultText editType:self.type onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            
            [MBProgressHUD showError:@"保存成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationPaySucToloadData" object:nil];
        
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"保存失败"];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"保存失败"];
    
    }];
    
}

- (void)saveTemporaryData:(NSString *)diagnoseResultText{
    NSLog(@"saveResultMethodR");
    
    if ([diagnoseResultText isEqualToString:@"输入结果"]) {
        diagnoseResultText = @"";
//        [MBProgressHUD showError:@"请输入结果"];
//        return;
    }
    
    NSDictionary *temporyData = [YHStoreTool ShareStoreTool].temporaryData;
    NSDictionary *temporarySave = temporyData[@"temporarySave"];
    if (!temporarySave) {
        temporarySave = nil;
    }
    NSArray *repairModeData = temporarySave[@"repairModeData"];
   
    if (!repairModeData) {
        repairModeData = nil;
    }
    
    NSMutableDictionary *checkResultDict = [NSMutableDictionary dictionary];
    [checkResultDict setValue:diagnoseResultText forKey:@"makeResult"];
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] saveModifyPattern:[YHTools getAccessToken] billId:[YHStoreTool ShareStoreTool].orderInfo[@"id"] checkResult:checkResultDict repairModeData:repairModeData onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            if (diagnoseResultText.length > 0) {
                 [MBProgressHUD showError:@"保存结果成功"];
            }
            if (_saveSuccessBackBlock) {
                _saveSuccessBackBlock(diagnoseResultText);
            }
            
            // 本地数据同步
            NSMutableDictionary *newTemporySave = [NSMutableDictionary dictionaryWithDictionary:temporarySave];
            [newTemporySave setValue:checkResultDict forKey:@"checkResult"];
            NSMutableDictionary *newTemporyData = [NSMutableDictionary dictionaryWithDictionary:temporyData];
            [newTemporyData setValue:newTemporySave forKey:@"temporarySave"];
            [[YHStoreTool ShareStoreTool] setTemporaryData:newTemporyData];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [MBProgressHUD showError:@"保存结果失败"];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
         [MBProgressHUD showError:@"保存结果失败"];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
- (void)initEditDiagnoseResultUI{
    
    UITextView *resTextview = [[UITextView alloc] init];
    resTextview.delegate = self;
    self.resTextview = resTextview;
    resTextview.layer.cornerRadius = 4;
    resTextview.layer.masksToBounds = YES;
    [self.view addSubview:resTextview];
    
    CGFloat constTop = iPhoneX ? 88 : 64.0;
    [self.resTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15 + constTop));
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(screenHeight * .4);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backIiem;
}
- (void)popViewController:(UIButton *)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextViewDelegate ---
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.navigationController.navigationBar.height = kStatusBarAndNavigationBarHeight;//不知道为什么导航栏2下就会变小
    
    textView.text = [textView.text isEqualToString:self.type ? self.type == 1 ? @"请输入诊断思路内容" : @"请输入诊断结果内容"  :  @"输入结果"] ? @"" : textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.navigationController.navigationBar.height = kStatusBarAndNavigationBarHeight;//不知道为什么导航栏2下就会变小
    
    if (textView.text.length == 0) {
        textView.text = self.type ? self.type == 1 ? @"请输入诊断思路内容" : @"请输入诊断结果内容"  :  @"输入结果";
    }
}

@end
