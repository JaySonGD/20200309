//
//  YHCommonTool.m
//  YHCaptureCar
//
//  Created by liusong on 2018/5/2.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCommonTool.h"
#import <CoreTelephony/CTCellularData.h>
#import "YHCommon.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface YHCommonTool ()
/* 拒绝状态下执行的block **/
@property (nonatomic, copy) void(^restrictBlock)(void);
/* 允许状态下执行的block **/
@property (nonatomic, copy) void(^notRestrictBlock)(void);
/* 未知状态下执行的block **/
@property (nonatomic, copy) void(^unKnowBlock)(void);

@property (nonatomic, strong) UIViewController *currentVC;
/**执行默认的处理方式 */
@property (nonatomic, assign) BOOL isDefault;

@end

static YHCommonTool *_shareCommonTool = nil;
@implementation YHCommonTool

+ (instancetype)ShareCommonTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCommonTool = [[YHCommonTool alloc] init];
    });
    return _shareCommonTool;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (!_shareCommonTool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
             _shareCommonTool = [super allocWithZone:zone];
            _shareCommonTool.isDefault = NO;
        });

    }
    return _shareCommonTool;
}

+ (instancetype)ShareCommonToolWithRestrictedStatus:(void (^)(void))restrictBlock notRestrictedStatus:(void (^)(void))notRestrictBlock unKnowStatus:(void (^)(void))unKnowBlock{
    
  YHCommonTool *commonTool = [self ShareCommonTool];
    commonTool.restrictBlock = restrictBlock;
    commonTool.notRestrictBlock = notRestrictBlock;
    commonTool.unKnowBlock = unKnowBlock;
    commonTool.isDefault = NO;
    
    return commonTool;
}
+ (instancetype)ShareCommonToolDefaultCurrentController:(UIViewController *)currentVc{
    
     YHCommonTool *commonTool = [self ShareCommonTool];
     commonTool.currentVC = currentVc;
     commonTool.isDefault = YES;
     return commonTool;
}
- (void)setIsDefault:(BOOL)isDefault{
    
    _isDefault = isDefault;
    [self networkStatusLimitStatus];
}
#pragma mark - CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题获取网络权限状态
- (void)networkStatusLimitStatus {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10) {
        return;
    }
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    // 此函数会在网络权限改变时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                // 权限关闭的情况下 再次请求网络数据会弹出设置网络提示
            {
                YHLog(@"用户已经关闭网络访问权限拒绝");
                _CurrentNetLimitStatus = UINetLimitStatusRestricted;
                
                if (_isDefault) {
                    
                    // 网络访问权限关闭
                    [self alertPromptToSystemNetwort:@"应用JNS的无线网络权限已关闭"];
                    
                }else{
                    if (_notRestrictBlock) {
                        _notRestrictBlock();
                    }
                }
            }
                break;
            case kCTCellularDataNotRestricted:
                //  已经开启网络权限 监听网络状态
            {
                YHLog(@"已开启网络权限");
                _CurrentNetLimitStatus = UINetLimitStatusNotRestricted;
                if (_restrictBlock) {
                    _restrictBlock();
                }
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
                //未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
            {
                YHLog(@"未知情况");
                _CurrentNetLimitStatus = UINetLimitStatusRestrictedStateUnknown;
                
                if (_isDefault) {
                    
                    // 网络访问权限关闭
                    [self alertPromptToSystemNetwort:@"应用JNS的无线网络权限已关闭"];
                    
                }else{
                     if (_unKnowBlock) {
                        _unKnowBlock();
                    }
                }
               
            }
                break;
                
            default:
                break;
        }
    };
}
#pragma mark - 跳转到系统蜂窝网络界面 ----
- (void)alertPromptToSystemNetwort:(NSString *)promptText{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        return;
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:promptText message:@"请前往系统：设置->蜂窝移动网络->使用无线局域网与蜂窝移动的应用中设置，否则会影响应用的正常使用" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    if (self.currentVC) {
        
        [self.currentVC presentViewController:alertVc animated:YES completion:^{
            self.currentVC = nil;
        }];
    }
}
@end
