//
//  YHTools.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/10.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


//创建本地化数据宏
#define YHToolsLocalQuickHeader(name) \
+ (id)name;\
+ (void)set##name:(id)data;

#define YHToolsLocalQuick(name, key) \
static NSString * const YHLocation##name = key;\
+ (id)name{\
return [[NSUserDefaults standardUserDefaults] valueForKey:YHLocation##name];\
}\
+ (void)set##name:(id)data{\
[YHTools setData:data byKey:YHLocation##name];\
}

@class PCPersonModel;
@interface YHTools : NSObject

DEFINE_SINGLETON_FOR_HEADER(YHTools);

//同意app协议
YHToolsLocalQuickHeader(appAgreement)

//是否有通知
YHToolsLocalQuickHeader(mqttNotice)

//省保存
YHToolsLocalQuickHeader(province)
//城市保存
YHToolsLocalQuickHeader(cityName)

//区保存
YHToolsLocalQuickHeader(area)
//已链接蓝牙名称
YHToolsLocalQuickHeader(buluetoothName)
//塑形id
YHToolsLocalQuickHeader(shapingId)
//增肌id
YHToolsLocalQuickHeader(muscleId)
//用户模型报告id列表
YHToolsLocalQuickHeader(user3dModels)
//体态滑动指示页是否显示
YHToolsLocalQuickHeader(postureScroll)

//@property(nonatomic,assign)NSTimeInterval timeInterval;

+ (NSArray*)sysProjectByKey:(NSString*)key;

/*!
 *  @method stringFromDate:
 *
 *  @param
 date 日期
 formatter 日期格式字符串
 *
 *  @discussion 方法返回@formatter格式日期字符串
 *
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date byFormatter:(NSString*)formatter;


/*!
 *  @method dateFromString: byFormatter:
 *
 *  @param
 dateString 日期
 
 formatter 日期格式字符串
 *
 *  @discussion 方法返回@formatter格式日期
 *
 *
 */
+ (NSDate *)dateFromString:(NSString*)dateString byFormatter:(NSString*)formatter;


//城市
+ (NSString*)getLocationLocality;
// 是否是报告跳转
+ (BOOL)isReportJump;
+ (void)setIsReportJump:(BOOL)isReportJump;

//城市
+ (void)setLocationLocality:(NSString*)locationLocality;

// 区
+ (NSString*)getLocationSubLocality;

// 区
+ (void)setLocationSubLocality:(NSString*)locationSubLocality;

//街道
+ (NSString*)getLocationThoroughfare;

//街道
+ (void)setLocationThoroughfare:(NSString*)locationThoroughfare;

//子街道
+ (NSString*)getLocationSubThoroughfare;

//子街道
+ (void)setLocationSubThoroughfare:(NSString*)locationSubThoroughfare;

//地名
+ (NSString*)getLocationName;

//地名
+ (void)setLocationName:(NSString*)locationName;

//用户类型
+ (NSNumber*)getUserType;

//用户类型
+ (void)setUserType:(NSNumber*)type;

//用户名子名称
+ (NSString*)getSubName;

//用户名子名称
+ (void)setSubName:(NSString*)name;

//用户名
+ (NSString*)getName;

//用户名
+ (void)setName:(NSString*)name;


//站点code
+ (NSString*)getServiceCode;

//站点code
+ (void)setServiceCode:(NSString*)serviceCode;

//纬度
+ (NSNumber*)getLatitude;

//纬度
+ (void)setLatitude:(NSNumber*)latitude;

//经度
+ (NSNumber*)getLongitude;

//经度
+ (void)setLongitude:(NSNumber*)longitude;

//是否记住用户名和密码
+ (NSNumber*)getUserRemember;

//是否记住用户名和密码
+ (void)setUserRemember:(NSNumber*)isRemember;

//启动版本
+ (NSString*)getAppversion;

//启动版本
+ (void)setAppversion:(NSString*)version;

//首页功能块
+ (NSArray*)getFunctions;

///首页功能块
+ (void)setFunctions:(NSArray*)functions;

//access_token
+ (NSString*)getAccessToken;

///access_token
+ (void)setAccessToken:(NSString*)accessToken;

+ (NSString *)rulerToken;
+ (void)setRulerToken:(NSString *)rulerToken;

+ (NSString *)refreshToken;
+ (void)setRefreshToken:(NSString *)refreshToken;

+ (NSString *)accountId;
+ (void)setAccountId:(NSString *)accountId;

+ (NSString *)personId;
+ (void)setPersonId:(NSString *)personId;

+ (void)setReportJumpCode:(NSString *)code;
+ (NSString *)getReportJumpCode;

//微信授权信息
+ (NSDictionary*)getWeixinAccessInfo;

//微信授权信息
+ (void)setWeixinAccessInfo:(NSDictionary*)info;

//微信授权信息code
+ (NSString*)getWeixinCode;

//微信授权信息code
+ (void)setWeixinCode:(NSString*)info;

//云虎 appid
+ (NSString*)getAppIdYH;

//云虎 appid
+ (void)setAppIdYH:(NSString*)info;

//本地缓存搜索关键字
+ (NSArray*)getSearchKeys;

//本地缓存搜索关键字
+ (void)setSearchKeys:(NSArray*)keys;

//本地延保缓存搜索关键字
+ (NSArray*)getExtendSearchKeys;

//本地延保缓存搜索关键字
+ (void)setExtendSearchKeys:(NSArray*)keys;
    
//将字符串分割成数组,然后按首字母排序,再转回字符串
+ (NSString *)sortKey:(NSString*)str;


//MD5 32位大写加密 需在头文件加上#import <CommonCrypto/CommonDigest.h>
+ (NSString *)md5:(NSString *)str;

+ (NSString*)mileageShow:(NSString*)mileageStr;


+ (NSString*)mileageGetNum:(NSString*)mileageStr;


/*
 appVersion  本APP储存版本
 version  服务器储存版本
 */
+ (BOOL)compVersion:(NSString*)appVersion version:(NSString*)version;


//储存本地jspath版本信息
+ (NSDictionary*)getUserJspath;

//获取本地jspath版本信息
+ (void)setUserJspath:(NSDictionary*)info;
/*
 php 接口数组格式
 */
+ (NSString*)arrayToStr:(NSArray*)items;

/*
 php 接口Map格式
 */
+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary;


/*
 转json字符串
 */
+(NSString*)data2jsonString:(id)object;

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString*)yhStringByReplacing:(NSString*)str;



//获取当前的时间
+(NSString*)getCurrentTimes;

//获取当前时间戳有两种方法(以秒为单位)
//方法1
+(NSString *)getTimestampWithDate:(NSDate *)date;

//方法2
+(NSString *)getNowTimeTimestamp2;

//获取当前时间
+(NSString *)getDateStr;

//获取当前时间戳（以毫秒为单位）
+(NSString *)getNowTimeTimestamp3;

//image 添加点和线
+(UIImage*) image:(UIImage*) image withInfo:(NSDictionary*)info;

+ (NSString *)base64FromImage:(UIImage *)image;
+ (UIImage *)imageFromBase64:(NSString *)string;

+ (BOOL)canUpDate:(NSString*)version;
+ (BOOL)compare:(NSString*)thisVersion newVersion:(NSString*)newVersion;
+ (UIImage *)createQRCode;

//唯一标示
+(NSString *)getUniqueDeviceIdentifierAsString;

@property (nonatomic, strong) NSDictionary *appInfo;

@property (nonatomic, strong) PCPersonModel *masterPersion;
@property (nonatomic, strong) PCPersonModel *masterUser;
@property (nonatomic, weak) NSMutableArray<PCPersonModel *> *personList;

@property (nonatomic, strong) UIImage *lastImage;


//urlencided
+(NSString *)URLEncodedString:(NSString *)str;

+ (double )roundNumberStringWithRound:(NSInteger)round number:(CGFloat )number;


/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
@end
