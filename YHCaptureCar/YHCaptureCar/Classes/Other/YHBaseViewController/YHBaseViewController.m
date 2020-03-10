//
//  YHBaseViewController.m
//  FTE
//
//  Created by ZWS on 14-9-4.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHCommon.h"
#import "YHBaseNetWorkError.h"
#import "YHNetworkPHPManager.h"
#import "YHSVProgressHUD.h"
#import "YHTools.h"
#import "UIAlertView+Block.h"
extern NSString *const notificationOrderListChange;
@interface YHBaseViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation YHBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = YHNaviColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if(((self.navigationItem.leftBarButtonItem != nil && !self.navigationItem.leftBarButtonItem.customView.hidden)
        || (self.navigationController.childViewControllers.count > 1))
       && !_isHideLeftButton){
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 20, 44);
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backIiem;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //滑动收起键盘
    [[self view] endEditing:YES];
}

- (IBAction)popViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)notImplementedViewController:(id)sender{
    [MBProgressHUD showError:@"即将上线，敬请期待！"];
}

- (void)autoLayoutView:(UIView*)view{
    for (NSLayoutConstraint *item in view.constraints) {
        item.constant = (item.constant / 667.) * [UIScreen mainScreen].bounds.size.height;
    }
    for (UIView *subView in view.subviews) {
        [self autoLayoutView:subView];
    }
}

//无网络
- (void)netError:(NSError*)error{
    if (error.code == 0xFFFFFFF8) {
        NSDictionary *info = error.userInfo;
        [MBProgressHUD showError:info[@"info"]];
    }
}


//单点登录判断
- (bool)sso:(NSString*)retCode{
    return [[[YHBaseNetWorkError alloc]init] sso:retCode];
}

//登录过期
- (bool)networkServiceCenter:(NSNumber*)retCode{
    return [[[YHBaseNetWorkError alloc]init] networkServiceCenter:retCode];
}

//展示返回错误提示
- (void)showErrorInfo:(NSDictionary*)info{
    NSDictionary *msg = info[@"msg"];
    if ([msg isKindOfClass:[NSDictionary class]]) {
        NSArray *strs = msg.allValues;
        if (strs.count != 0) {
            [MBProgressHUD showError:strs[0]];
        }
    }else{
        [MBProgressHUD showError:info[@"retMsg"]];
    }
}

- (void)initInput:(UITextField*)field withInputView:(UIPickerView*)inputView target:(nullable id)target action:(nullable SEL)action{
    
    // 设置键盘上的ToolBar
    
    UIBarButtonItem *unitHiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:target action:action];
    
    UIBarButtonItem *unitSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *unitAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    unitAccessoryView.barStyle = UIBarStyleDefault;
    
    unitAccessoryView.items = [NSArray arrayWithObjects:unitSpaceButtonItem,unitHiddenButtonItem,nil];
    
    field.inputAccessoryView = unitAccessoryView;
    
    field.inputView = inputView;
    
}

@end
