//
//  YHJspathAndVersionManager.m
//  YHTechnician
//
//  Created by Zhu Wensheng on 16/11/23.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "ZZAlertViewController.h"
#import "YHJspathAndVersionManager.h"
#import "YHTools.h"

#include "YHCarPhotoService.h"

//#import "MBProgressHUD+MJ.h"
#import "UIAlertView+Block.h"
//#define APPJspathKey @"mafooHelp"
#define APPJspathKey @"wgcTechnician"//万国技师

static NSString * const AppVersionBaseURLString = @SERVER_JAVA_APP_VERSION_URL;
#define arId @"ios"
#define signKeyManager @"0e82080761d4c4531639c0321c588522"

@interface YHJspathAndVersionManager ()

@end

@implementation YHJspathAndVersionManager
DEFINE_SINGLETON_FOR_CLASS(YHJspathAndVersionManager);

- (void)versionManage:(NSString*)appUrl{
    
    //"version":"1.0.1",//版本号
    //"force_update":"Y",//是否强制更新
    //"app_address":"http://192.168.1.200/files/apk/1.apk",//app下载地址
    
    
    //    NSLog(@"%d %d %d %d", [YHTools compVersion:@"1.0.0" version:@"1.0"],
    //          [YHTools compVersion:@"1.0.0" version:@"1.0.1"],
    //          [YHTools compVersion:@"1.0.0" version:@"2.0"],
    //          [YHTools compVersion:@"2.0" version:@"1.0.0"]);
    
    //[UIImage imageNamed:@"modifySuccess"]
    //@"马赛克式、磨砂式、网格式等多种去水印方式。根据要去水"
//    ZZAlertViewController *vc = [ZZAlertViewController alertControllerWithTitle:@"爱剪辑" icon:nil message:@"马赛克式、磨砂式、网格式等多种去水印方式。根据要去水"];
//    __weak typeof(ZZAlertViewController*) weakVC = vc;

//    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"hello tv";
//        [textField becomeFirstResponder];
//
//    } didChangeCharacters:^(UITextField * _Nonnull textField) {
//        weakVC.buttons.firstObject.enabled = textField.hasText;
//    }];
//    [vc addTextViewWithConfigurationHandler:^(ZZTextView * _Nonnull textField) {
//        textField.maxLength = 60;
//        textField.placeholder = @"马赛克式、磨砂式、网格式等多种去水印方式。根据要去水";
//        [textField becomeFirstResponder];
//    } didChangeCharacters:^(UITextView * _Nonnull textField) {
//        weakVC.buttons.firstObject.enabled = textField.hasText;
//    }];
//
//    [vc addActionWithTitle:@"提交" style:ZZAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
//
//        NSLog(@"%s---%@", __func__,weakVC.textFields.firstObject.text);
//    } configurationHandler:^(UIButton * _Nonnull action) {
//        action.enabled = NO;
//    }];
    
    
//    [vc addActionWithTitle:@"取消" style:ZZAlertActionStyleDestructive handler:^(UIButton * _Nonnull action) {
//        NSLog(@"%s", __func__);
//    }];
//
//
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
//    [self updateApp:YES];
//    return;
    
#ifdef YHProduction
    //生产
    [self setValue:[NSURL URLWithString:AppVersionBaseURLString] forKey:@"baseURL"];
#endif
    
    NSString *buildTimeStr = [NSString stringWithFormat:@"%lu",(unsigned long)[[NSDate date] timeIntervalSince1970]];

    //NSString *key = [[YHTools sortKey:[NSString stringWithFormat:@"app_id=yh1XqnVMsZxJNrqAPs&app_type=ios&app_type_id=jns&time=%@",buildTimeStr]] stringByAppendingString:[NSString stringWithFormat:@"&key=%@",signKeyManager]];
    
    
     NSString *key = [YHTools md5:[YHTools sortKey:[NSString stringWithFormat:@"app_id=yh1XqnVMsZxJNrqAPs&app_type=ios&app_type_id=jns&time=%@",buildTimeStr]]].lowercaseString;
    NSString * sign = [YHTools md5:[NSString stringWithFormat:@"%@%@",key,signKeyManager]].lowercaseString;
    
    
    //NSString * sign = [YHTools md5:key];


    
    NSDictionary *param = @{
                            @"time":buildTimeStr,
                            @"sign":sign,
                            @"app_id":@"yh1XqnVMsZxJNrqAPs",
                            @"app_type":@"ios",
                            @"app_type_id":@"jns"
                            };
    
    [[YHCarPhotoService new] getAppEditionParam:param success:^(NSDictionary *info) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSDictionary *result = info;
        if (![result isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSString *forceUpdate = result[@"force_update"];
        NSString *version = result[@"version"];
//        NSString *appUrl = result[@"app_address"];
        
        if ([YHTools compVersion:appVersion version:version]) {
            
            if ([forceUpdate isEqualToString:@"Y"]) {
                [self updateAppWith:appUrl isNeed:YES];
                //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，前往更新!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                //                        NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                //
                //                        [[UIApplication sharedApplication]openURL:url];
                //                    }];
            }else if([forceUpdate isEqualToString:@"N"]){
                [self updateAppWith:appUrl isNeed:NO];
                //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                //                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                //                        if (buttonIndex == 1) {
                //
                //                            NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                //
                //                            [[UIApplication sharedApplication]openURL:url];
                //                        }
                //                    }];
            }else{
                //审核屏蔽更新
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
    
    
    return;


    
    [self getVersionByAppId:APPJspathKey appType:@"0" onComplete:^(NSDictionary *info) {
        NSString *retCode = info[@"retCode"];
        if ([retCode isEqualToString:@"0"]) {
            NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            NSDictionary *result = info[@"result"];
            if (![result isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            NSString *forceUpdate = result[@"forceUpdate"];
            NSString *version = result[@"version"];
            
            if ([YHTools compVersion:appVersion version:version]) {
                
                if ([forceUpdate isEqualToString:@"Y"]) {
                    [self updateAppWith:appUrl isNeed:YES];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，前往更新!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                        NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//                        [[UIApplication sharedApplication]openURL:url];
//                    }];
                }else if([forceUpdate isEqualToString:@"N"]){
                    [self updateAppWith:appUrl isNeed:NO];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                        if (buttonIndex == 1) {
//
//                            NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//                            [[UIApplication sharedApplication]openURL:url];
//                        }
//                    }];
                }else{
                    //审核屏蔽更新
                }
            }
            
        }else{
            [MBProgressHUD showError:info[@"retMsg"]];
        }
    } onError:^(NSError *error) {
        YHLog(@"%@", error);
    }];
}


- (void)updateAppWith:(NSString *)appUrl isNeed:(BOOL)need{
   ZZAlertViewController *vc = [ZZAlertViewController alertControllerWithTitle:@"更新" icon:[UIImage imageNamed:@"火箭"] message:@"有新的版本更新，是否前往更新？"];
    NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (need) {
        [vc addActionWithTitle:@"确定" style:ZZAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:url];
        }];
    }else{
        [vc addActionWithTitle:@"更新" style:ZZAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:url];
        }];
        
        [vc addActionWithTitle:@"关闭" style:ZZAlertActionStyleCancel handler:nil];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}


- (void)qualityInputBytoken:(NSString*)token
                 parameters:(NSDictionary*)parameter
               onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError{
    if (token == nil || parameter == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
#ifdef YHProduction
    //生产
    [self setValue:[NSURL URLWithString:@"https://s.laijingedu.cn"] forKey:@"baseURL"];
#endif

    self.requestSerializer=[AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:token forHTTPHeaderField:@"accessToken"];
    [self YHBasePOST:@"/edu/stu/quality/input"param:parameter onComplete:onComplete onError:onError];
}

- (void)qualityDetailBytoken:(NSString*)token
                 detailId:(NSString*)Id
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || Id == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    //https://s.laijingedu.cn
    
#ifdef YHProduction
    //生产
    [self setValue:[NSURL URLWithString:@"https://s.laijingedu.cn"] forKey:@"baseURL"];
#endif

    
    NSDictionary *par = @{@"id":Id};
    self.requestSerializer=[AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:token forHTTPHeaderField:@"accessToken"];
    [self YHBasePOST:[NSString stringWithFormat:@"/edu/comm/quality/detail?id=%@",Id] param:par onComplete:onComplete onError:onError];
    
    
}


#pragma mark Version And Jspath

/**
 
 1、 APP版本管理接口
 appId	appId，车主：carOwner  技师：technician
 appType	0-IOS，1-Andriod
 
 **/

- (void)getVersionByAppId:(NSString*)appId appType:(NSString*)appType onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError{
    if (appId == nil || appType == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSString * reqAct = @"getVersion";
    NSString *buildTimeStr = buildTime;
    NSString * sign = [YHTools md5:[[YHTools sortKey:[NSString stringWithFormat:@"reqAct=%@&arId=%@&appId=%@&appType=%@&time=%@", reqAct, arId, appId, appType, buildTimeStr]] stringByAppendingString:[NSString stringWithFormat:@"&key=%@",signKeyManager]]];
    NSDictionary *parameters = @{@"reqAct":reqAct,@"arId":arId,@"appId":appId,@"appType" : appType, @"time":buildTimeStr,@"sign":sign};
    
    [self YHBasePOST:SERVER_JAVA_APP_VERSION_Trunk@"/interfaces/app/version"param:parameters onComplete:onComplete onError:onError];
}


#pragma mark Init
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:AppVersionBaseURLString]];
    if (self) {
        //        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

@end
