//
//  YHJspathAndVersionManager.m
//  YHTechnician
//
//  Created by Zhu Wensheng on 16/11/23.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHJspathAndVersionManager.h"
#import "YHTools.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "UIAlertView+Block.h"
#import "CheckNetwork.h"
#define APPJspathKey @"mafooHelp"//捕车(马夫帮)

static NSString * const AppVersionBaseURLString = @SERVER_JAVA_APP_VERSION_URL;
#define arId @"ios"
#define signKeyManager @"4028816455dcd8ad0asdfddd7f89006a"
@interface YHJspathAndVersionManager ()

@end

@implementation YHJspathAndVersionManager
DEFINE_SINGLETON_FOR_CLASS(YHJspathAndVersionManager);

- (void)versionManage:(NSString*)appUrl{
    //    NSLog(@"%d %d %d %d", [YHTools compVersion:@"1.0.0" version:@"1.0"],
    //          [YHTools compVersion:@"1.0.0" version:@"1.0.1"],
    //          [YHTools compVersion:@"1.0.0" version:@"2.0"],
    //          [YHTools compVersion:@"2.0" version:@"1.0.0"]);
    
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
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，前往更新!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        
                        [[UIApplication sharedApplication]openURL:url];
                    }];
                }else if([forceUpdate isEqualToString:@"N"]){
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            
                            NSURL *url = [NSURL URLWithString:[appUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }];
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
    NSString *buildTimeStr = buildTimeVersionMannger;
    NSString * sign = [YHTools md5:[[YHTools sortKey:[NSString stringWithFormat:@"reqAct=%@&arId=%@&appId=%@&appType=%@&time=%@", reqAct, arId, appId, appType, buildTimeStr]] stringByAppendingString:[NSString stringWithFormat:@"&key=%@",signKeyManager]]];
    NSDictionary *parameters = @{@"reqAct":reqAct,@"arId":arId,@"appId":appId,@"appType" : appType, @"time":buildTimeStr,@"sign":sign};
    
    [self YHBasePOST:SERVER_JAVA_APP_VERSION_Trunk@"/interfaces/app/version"param:parameters onComplete:onComplete onError:onError];
}

#pragma mark POST
/**
 
 **/
- (void)YHBasePOST:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self
     POST:URLString
     parameters:param
     progress:nil
     success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
         if (responseObject == nil) {
             if (onError) {
                 onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
             }
         }else{
             if (onComplete) {
                 onComplete(responseObject);
             }
         }
     }
     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
#ifdef TestError
         NSDictionary *userInfo =error.userInfo;
         
         NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
         NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
         
         if (!responseObject) {
             responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
         }
         NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
         if (onError) {
             onError(error);
         }
     }];
#endif
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
