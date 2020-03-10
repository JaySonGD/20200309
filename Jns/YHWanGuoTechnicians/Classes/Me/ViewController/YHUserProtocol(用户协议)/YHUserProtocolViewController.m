//
//  YHUserProtocolViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/6/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHUserProtocolViewController.h"

@interface YHUserProtocolViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation YHUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    NSAttributedString *contentText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    
    NSAttributedString *addTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n\n",self.name] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:26],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithAttributedString:addTitle];
    [resultStr appendAttributedString:contentText];
    
    if(!IsEmptyStr(_text)) self.textView.attributedText = resultStr;
    self.textView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    
    [self initBase];
}
- (NSString *)text{
    return !_text ? @"" : _text;
}
- (NSString *)name{
    return !_name ? @"" : _name;
}

- (void)initBase{
    
    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, backY, screenWidth, 44.0)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    [self.view addSubview:backGroundView];
    [self.view insertSubview:backGroundView belowSubview:backBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end

