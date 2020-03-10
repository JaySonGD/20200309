//
//  AppDelegate+Http.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 13/6/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "AppDelegate+HttpEnv.h"
#ifdef Test
//#import "VirtualTouch.h"
#import <LLDebug.h>
#endif

@implementation AppDelegate (HttpEnv)

- (void)loadVirtualView{
#ifdef Test
    
    
    
    [[LLDebugTool sharedTool] startWorking];
    [LLConfig sharedConfig].availables = LLConfigAvailableNetwork   |
    LLConfigAvailableAppInfo        |
    LLConfigAvailableSandbox ;
    
    UILongPressGestureRecognizer *longP =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched)];
    UIWindow *view = [LLDebugTool sharedTool].window;
    [view addGestureRecognizer:longP];
    
    //    VirtualTouch *avatar = [[VirtualTouch alloc] initInKeyWindowWithFrame:CGRectMake(20, 44, 54, 54)];
    //    avatar.layer.contents = (id)[UIImage imageNamed:@"Aitive Touch"].CGImage;
    //    avatar.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    //    [avatar setTapBlock:^(VirtualTouch *avatar) {
    //
    //        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
    //        [generator prepare];
    //        [generator impactOccurred];
    //
    //        NSString *env = @[@"生产",@"本地",@"开发",@"测试"][kHttpEnvInt];
    //        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"当前访问环境【%@】",env] preferredStyle:UIAlertControllerStyleActionSheet];
    //        [vc addAction:[UIAlertAction actionWithTitle:@"测试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            [self setHttpEnv:3];
    //        }]];
    //        [vc addAction:[UIAlertAction actionWithTitle:@"开发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            [self setHttpEnv:2];
    //
    //        }]];
    //        [vc addAction:[UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            [self setHttpEnv:1];
    //
    //        }]];
    //        [vc addAction:[UIAlertAction actionWithTitle:@"生产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            [self setHttpEnv:0];
    //        }]];
    //        [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //
    //        if ([vc respondsToSelector:@selector(popoverPresentationController)]) {
    //            vc.popoverPresentationController.sourceView = avatar;
    //            vc.popoverPresentationController.sourceRect = avatar.frame;
    //        }
    //        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    //
    //    }];
#endif
    
}

#ifdef Test

- (void)buttonTouched{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
    
    NSString *env = @[@"生产",@"本地",@"开发",@"测试"][kHttpEnvInt];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"当前访问环境【%@】",env] preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"测试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setHttpEnv:3];
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"开发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setHttpEnv:2];
        
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setHttpEnv:1];
        
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"生产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setHttpEnv:0];
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    if ([vc respondsToSelector:@selector(popoverPresentationController)]) {
        UIWindow *view = [LLDebugTool sharedTool].window;
        
        vc.popoverPresentationController.sourceView =  view;
        vc.popoverPresentationController.sourceRect =  view.frame;
    }
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setHttpEnv:(NSInteger)env{
    [[NSUserDefaults standardUserDefaults] setValue:@(env) forKey:@"kHttpEnv"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    exit(0);
}
#endif

@end
