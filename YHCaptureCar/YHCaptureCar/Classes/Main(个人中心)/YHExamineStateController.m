//
//  YHExamineStateController.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/11.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHExamineStateController.h"
#import "YHCommon.h"
@interface YHExamineStateController ()
@property (weak, nonatomic) IBOutlet UIButton *stateB;
@property (weak, nonatomic) IBOutlet UILabel *stateStrL;
@property (weak, nonatomic) IBOutlet UILabel *stateInfo1L;
@property (weak, nonatomic) IBOutlet UILabel *stateInfo2L;
@property (weak, nonatomic) IBOutlet UILabel *failCauseL;

@property (weak, nonatomic) IBOutlet UIView *successInfoBox;
@property (weak, nonatomic) IBOutlet UIView *stateInfoBox;
@end

@implementation YHExamineStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _successInfoBox.hidden = !(_status == YHLeftMenuActionsRegistrationSuccessful);
    _stateInfoBox.hidden = !(_status == YHLeftMenuActionsAuditFail);
    
    [_stateInfo1L setTextColor:[UIColor whiteColor]];
    [_stateInfo2L setTextColor:[UIColor whiteColor]];
    switch (_status) {
        case YHLeftMenuActionsRegistrationSuccessful:
            {
                [_stateB setImage:[UIImage imageNamed:@"leftInfo2"] forState:UIControlStateNormal];
                _stateStrL.text = @"注册成功";
                _stateInfo1L.text = @"恭喜！您提交的";
                _stateInfo2L.text = @"信息已成功注册";
            }
            break;
        case YHLeftMenuActionsAuditFail:
        {
            _failCauseL.text = @"原因";
            [_stateB setImage:[UIImage imageNamed:@"leftInfo8"] forState:UIControlStateNormal];
            _stateStrL.text = @"审核不通过";
            _stateInfo1L.text = @"抱歉！请您填写";
            _stateInfo2L.text = @"正确的信息资料";
            _failCauseL.text = EmptyStr(_info[@"reason"]);
            [_stateInfo1L setTextColor:YHColor(254., 234., 55.)];
            [_stateInfo2L setTextColor:YHColor(254., 234., 55.)];
        }
            break;
        case YHLeftMenuActionsAuditIng:
        {
            [_stateB setImage:[UIImage imageNamed:@"leftInfo14"] forState:UIControlStateNormal];
            _stateStrL.text = @"审核中...";
            _stateInfo1L.text = @"努力审核中";
            _stateInfo2L.text = @"请耐心等待";
            
        }
            break;
            
        default:
            break;
            
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moreAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)popViewController:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
