//
//  YHSVProgressHUD.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/4/24.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSVProgressHUD.h"
#import "Masonry.h"

@interface YHSVProgressHUD ()
@property (nonatomic, strong) UIView *hudView;
@property (strong, nonatomic)UIWebView *loadPopView;
+ (YHSVProgressHUD*)sharedView;
@end

@implementation YHSVProgressHUD

+ (void)showYH{
    [[self sharedView] loadPopView];
    [self show];
}
   
- (UIView*)loadPopView{
    if (!_loadPopView) {
#pragma clang diagnostic ignored "-Wnonnull"
        NSString *path = [[NSBundle mainBundle] pathForResource:@"load" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        _loadPopView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _loadPopView.scalesPageToFit = YES;
        [_loadPopView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        _loadPopView.backgroundColor = [UIColor clearColor];
        _loadPopView.opaque = NO;
        
    }
    
    if(!_loadPopView.superview) {
        [self addSubview:_loadPopView];
        __weak __typeof__(self) weakSelf = self;
        [_loadPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX).with.offset(0);
            make.centerY.equalTo(weakSelf.mas_centerY).with.offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
    }
    return _loadPopView;
}
@end
