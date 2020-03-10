//
//  CheckNetwork.m
//  iphone.network1
//
//  Created by wangjun on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckNetwork.h"
typedef NS_ENUM(NSInteger, NETWORK_V){
    V1 = 1,
    V2
} ;

#define NETWORK_URL_V1 @"www.epailive.com"
#define NETWORK_URL_V2 @"www.apple.com"

static NSString *const use3GId = @"use3gId";
@interface CheckNetwork ()
@property (strong, nonatomic)Reachability *internetReachable;
@end

@implementation CheckNetwork

DEFINE_SINGLETON_FOR_CLASS(CheckNetwork);

- (NetworkStatus)reachabilityWithHostName_v:(NETWORK_V)v{
    Reachability *r;
    if (v == V1) {
        r = [Reachability reachabilityWithHostName:NETWORK_URL_V1];
    }else {
        r = [Reachability reachabilityWithHostName:NETWORK_URL_V2];
    }
    return [r currentReachabilityStatus];
}

-(BOOL)isExistenceNetwork
{
    return [self reachabilityWithHostName_v:V1] != NotReachable;
}

-(BOOL)isExistenceNetworkAndWarning
{
	BOOL isExistenceNetwork = [self reachabilityWithHostName_v:V1] != NotReachable;
	if (!isExistenceNetwork) {
		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:@"请查看网络是否正常" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
		[myalert show];
	}
	return isExistenceNetwork;
}

- (NetworkStatus)currntNetworkType{
    return [self reachabilityWithHostName_v:V1];
}

- (void)registerNetworkNotice{
    //注册网络变化监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    self.isUseViaWWAN = NO;
    // Set up Reachability
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    [self checkNetworkStatus:Nil];
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    switch (internetStatus){
        case NotReachable:{
            YHLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:{
            YHLog(@"The internet is working via WIFI");
            break;
        }
        case ReachableViaWWAN:{
            YHLog(@"The internet is working via WWAN!");
            [self show3gAlert];
            break;
        }
    }
}

- (void)show3gAlert{
    UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"网络提示" message:@"你正在使用3g网络，会产生流量费用" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil,nil];
    [myalert show];
}


- (NSString *)getIsUse3G
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:use3GId];
}

- (void)setIsUse3G:(NSNumber *)isUse3G
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:isUse3G forKey:use3GId];
}

@end
