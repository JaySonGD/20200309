//
//  LeSyncSDK.h
//  LeSyncSDK
//
//  Created by winter on 16/3/28.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^infoBlock)(BOOL isLogin,NSString *st,NSString *userID);
typedef void(^bindInfo)(BOOL isBind,NSString *assistAccount);
typedef void(^userInfo)(NSDictionary *userInfo);
typedef void (^errorDic)(NSDictionary *errorDic);
typedef void(^errorStr) (NSString *errorCode);
typedef void(^returnResult) (NSString *result);
typedef void(^halfBlock)(BOOL isHalfAccount);

typedef void(^requestSuccess)(BOOL judge);

typedef NS_ENUM(NSInteger,LeInlandPageIndentifier){
    //设置
    LeInlandSettingPageIndentifier = 0,
    //登录
    LeInlandLoginPageIndentifier,
    //注册
    LeInlandRegisterPageIndentifier,
    //修改密码
    LeInlandModifyPasswordPageIndentifier,
    //手机号登录
    LeInlandPhoneNumPageIndentifier,
    //邮箱号登录
    LeInlandEmailNumPageIndentifier,
    //三方登录
    LeInlandThirdLoginPageIndentifier,
    //验证绑定帐号页面
    LeInlandVerifyAssistIDPageIndentifier,
    //添加绑定帐号
    LeInlandAddAssistIDPageIndentifier,
    //重置密码
    LeInlandResetPasswordPageIndentifier
};

@protocol LenovoIDInlandDelegate <NSObject>

@optional

- (void)leInlandDidFinishFromPage:(LeInlandPageIndentifier)page WithLoginStatus:(BOOL)isLogin;


@end

@interface LenovoIDInlandSDK : NSObject

@property (nonatomic, copy) infoBlock infoBlock;
@property (nonatomic, copy) bindInfo bindInfo;
@property (nonatomic, copy) halfBlock halfBlock;

@property (nonatomic, copy) errorDic errorDic;
@property (nonatomic, weak) id<LenovoIDInlandDelegate> delegate;
//default is ture
@property (nonatomic, assign) BOOL isLog;
/**
 *  创建实例
 */
+ (instancetype)shareInstance;

/**
 *  初始化
 *
 *  @param realm app的唯一标示（授权令牌）
 *  @param dict  @{@"weChat":@(1),@"qqsns":@(1),@"sina":@(1)};
 1代表显示，0代表隐藏
 *
 */
- (void)leInlandApiInit:(NSString *)realm andThirdLoginCB:(NSString *)thirdCB withThirdDictionary:(NSDictionary *)dict;

/**
 *  初始化
 *
 *  @param realm app的唯一标示（授权令牌）
 *  @param isOverseas 1：海外用户 0：国内用户
 *  @param dict  @{@"google":@(1),@"facebook":@(1)};
 1代表显示，0代表隐藏
 */
- (void)leOverseasApiInit:(NSString *)realm andThirdLoginCB:(NSString *)thirdCB withThirdDictionary:(NSDictionary *)dict;

/**
 *  获取登录状态方法，加载登陆界面
 *
 *  @return 登录界面Controller
 */
+ (void)leInlandLoginWithRootViewController:(UIViewController *)viewController;

/**
 *  三方web 先绑定 后登陆界面
 *
 *  @param viewController 登录界面控制器
 *  @param loginString 登录需要的网页URL字符串
 */
+ (void)leInlandbindAndLoginWithWebNavController:(UINavigationController *)navController andLoginString:(NSDictionary *)bindDictionary;

/**
 *  三方web 已绑定 直接登录
 *
 *  @param viewController 登录界面控制器
 *  @param loginString 登录需要的网页URL字符串
 */
+ (void)leInlandLoginWithWebNavController:(UINavigationController *)navController andAccount:(NSString *)account tgt:(NSString *)tgt;

/**
 *  三方账号账号登录
 *
 *  @param viewController 登录界面控制器
 *  @param appkey
 *  @param accesstoken
 *  @param third  三放登录的类型(微信登录)
 *  @param openId (微信登录必传)
 */
+ (void)leInlandLoginWithHalfWithAppkey:(NSString *)appkey accessToken:(NSString *)accesstoken thirdPartyName:(NSString *)third openId:(NSString *)openId success:(requestSuccess)success error:(errorDic)errorCode;


/**
 danale chenweidong
 登录页面加载到keywindow rootviewcontroller
 国内登录 大拿
 
 @param isHiddenNavigation 是否隐藏导航栏
 @param isLoadbackButton 是否显示取消按钮
 */
-(void)leInLandLoginToKeyWindowRootViewControllerWithisHiddenNavigation:(BOOL)isHiddenNavigation isHidbackButton:(BOOL)isHidbackButton;

/**
 danale chenweidong
 登录页面加载到keywindow rootviewcontroller
 海外登录
 
 @param isHiddenNavigation 是否隐藏导航栏
 @param isLoadbackButton 是否显示取消按钮
 */
-(void)leOverseasLoginToKeyWindowRootViewControllerWithisHiddenNavigation:(BOOL)isHiddenNavigation isHidbackButton:(BOOL)isHidbackButton;

/**
 *  初始化
 *
 *  @param realm app的唯一标示（授权令牌）
 *  @param dict  @{@"weChat":@(1),@"qqsns":@(1),@"sina":@(1)};
 1代表显示，0代表隐藏
 *  @param isInland 1国内 0海外
 *
 */
- (void)leSetThirdDictionary:(NSDictionary *)dict isInland:(BOOL)isInland;


/**
 *  获取登录状态，手机短信快速登录页面
 *
 *  @param viewController 登录界面Controller
 */
+ (void)leInlandLoginBySMSWithViewController:(UIViewController *)viewController;

/**
 *  获取LenovoST
 *  @param infoBlock为获取st回调
 *  @param errorDic 为错误回调
 */

- (void)leInlandObtainStData:(infoBlock)infoBlock error:(errorDic)error;

/**
 *  获取登陆状态
 *
 *  @return YES 已登录  NO未登录
 */
- (BOOL)leInlandObtainLoginStatus;

/**
 *  获取账号激活状态
 *
 *  @return YES 已激活  NO未激活
 */
- (void)leInlandObtainWebLoginActivationStatus:(requestSuccess)isVerified
                                         error:(errorDic)error;

/**
 *  弹出激活框
 *
 *  @param userID 用户账号
 */
- (void)leInlandObtainAlertLoginActivationSuccess:(requestSuccess)success Error:(errorStr)errorCode;

/**
 *  获取登陆名
 *
 *  @return 登陆帐号名
 */
- (NSString *)leInlandObtainUserName;

/**
 *  获取用户ID（用户的唯一标识，未登录返回为空）
 *
 *  @return 用户ID
 */
- (NSString *)leInlandObtainUserID;

/**
 *  用户登出
 */
- (void)leInlandLogout;

/**
 *  设置
 */
+ (void)leInlandShowAccountWithRootViewController:(UIViewController *)viewController error:(errorDic)errorContent;

/**
 *  获取半账号信息
 *  @param infoBlock为获取st回调
 *  @param errorDic 为错误回调
 */
+ (void)leInlandObtainHalfAccountDataWithRealm:(NSString *)realm
                                            st:(NSString *)st
                                         block:(halfBlock)halfBlock
                                         error:(errorDic)error;

/**
 danale chenweidong
 *  修改密码
 */
+ (void)leInlandShowResetModifyPWWithRootViewController:(UIViewController *)viewController;

/**
 *  绑定邮箱、手机号
 *
 *  @param viewController 未绑定时加载的页面
 *  @param info           如果绑定返回相应信息（辅助帐号，是否绑定）
 */
- (void)leInlandIsBindAssistAccountWithViewController:(UIViewController *)viewController info:(bindInfo)info error:(errorDic)errorContent;

/**
 *  当前帐号是否绑定了邮箱或手机号
 *
 *  warning:此接口需帐号登录成功可用
 *  @param info           如果绑定返回相应信息（辅助帐号，是否绑定）
 *  @param reason         返回请求失败结果
 */
- (void)leInlandIsBindAccount:(bindInfo)info fail:(void(^)(NSString *reason))reason;

/**
 *  发送绑定帐号短信或邮件
 *
 *  @param accountName 设置的绑定邮箱或手机号
 *  @param result  返回发送结果
 */
- (void)leInlandSendBindingMessageWithBindingName:(NSString *)bindingName result:(returnResult)result;
@property (nonatomic, copy) returnResult globalResult;//接收result的值

/**
 *  解除绑定帐号
 *
 *  @param bindingName 已绑定帐号
 *  @param result      解除绑定结果
 */
- (void)leInlandRemoveBindingWithBindingName:(NSString *)bindingName result:(void(^)(NSString *result))result;

/**
 *  验证码验证绑定帐号
 *
 *  @param message     验证码
 *  @param bindingName 绑定帐号
 *  @param result      绑定结果
 */
- (void)leInlandVerifyBindingMessageWithMessage:(NSString *)message bindingName:(NSString *)bindingName result:(void(^)(NSString *result))result;

/**
 *  获取用户个人信息
 *
 *  @param userInfo 用户信息回调
 */
- (void)leInlandObtainLenovoUserInfo:(userInfo)userInfo error:(errorDic)error;

/**
 *  获取用户头像
 *
 *  @param userInfo 用户头像url回调
 */
- (void)leInlandObtainLenovoUserIcon:(userInfo)userIcon error:(errorDic)error;
/**
 *  帐号二次校验接口
 *
 *  @param checkInfo
 */
- (void)leInlandCheckLoginStateWithAccount:(NSString *)account password:(NSString *)password st:(NSString *)st state:(void(^)(BOOL checkState))checkState error:(errorDic)errorCode;
@end

