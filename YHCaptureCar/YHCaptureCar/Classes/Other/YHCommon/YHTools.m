//
//  YHTools.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/10.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "YHTools.h"
#import "YHCommon.h"
#import "AppDelegate.h"
#import "NSData+Encryption.h"
#import "YHBase64.h"

static NSString * const locationLocalityKey = @"YHLocationLocality";
static NSString * const locationSubLocalityKey = @"YHLocationSubLocality";
static NSString * const locationThoroughfareKey = @"YHLocationThoroughfare";
static NSString * const locationSubThoroughfareKey = @"YHLocationSubThoroughfare";
static NSString * const locationNameKey = @"YHLocationName";
static NSString * const userNameKey = @"YHLocationUserName";
static NSString * const subUserNameKey = @"YHLocationSubUserName";
static NSString * const userType = @"YHLocationUserType";
static NSString * const userPasswordKey = @"YHLocationUserPassword";
static NSString * const locationUserLatitude = @"YHLocationUserLatitude";
static NSString * const locationUserLongitude = @"YHLocationUserLongitude";
static NSString * const locationUserRemember = @"YHLocationUserRemember";
static NSString * const locationAppVersion = @"YHLocationAppVersion";
static NSString * const locationUserJspath = @"YHLocationUserJspath";
static NSString * const locationFunctions = @"YHLocationFunctions";
static NSString * const locationAccessToken = @"YHLocationAccessToken";
static NSString * const locationWeixinAccessInfo = @"YHLocationWeixinAccessInfo";
static NSString * const locationWeixinCode = @"YHLocationWeixinCode";
static NSString * const locationAppIdYH = @"YHLocationAppIdYH";
static NSString * const locationSearchKeys = @"YHLocationSearchKeys";
static NSString * const locationExtendSearchKeys = @"YHLocationExtendSearchKeys";
static NSString * const locationServiceCode = @"YHLocationServiceCode";
static NSString * const reportJumpCode = @"YHReportJumpCode";
static NSString * const isReportJumpCode = @"YHReportJumpCode_isReportJumpCode";

@implementation YHTools

DEFINE_SINGLETON_FOR_CLASS(YHTools);

+ (NSArray*)sysProjectByKey:(NSString*)key {
    NSArray *info = @{@"0" : @[@"其他系统",@"carSys_6",@"carsys_61"],
                      @"1" : @[@"传动系统",@"carSys_1",@"carsys_10"],
                      @"15" : @[@"传动系统",@"carSys_1",@"carsys_10"],
                      @"21" : @[@"四轮",@"carSys_1",@"carsys_10"],
                      @"2" : @[@"电控系统",@"carSys_2",@"carsys_21"],
                      @"17" : @[@"电器系统",@"carSys_2",@"carsys_21"],
                      @"3" : @[@"发动机系统",@"carSys_3",@"carsys_31"],
                      @"13" : @[@"发动机系统",@"carSys_3",@"carsys_31"],
                      @"20" : @[@"发动机舱",@"carSys_3",@"carsys_31"],
                      @"4" : @[@"制动系统",@"carSys_4",@"carsys_41"],
                      @"16" : @[@"制动系统",@"carSys_4",@"carsys_41"],
                      @"5" : @[@"制冷系统",@"carSys_5",@"carsys_51"],
                      @"12" : @[@"空调系统",@"carSys_5",@"carsys_51"],
                      @"6" : @[@"车辆系统",@"carSys_6",@"carsys_61"],
                      @"7" : @[@"底盘系统",@"carSys_7",@"carsys_71"],
                      @"22" : @[@"底盘",@"carSys_7",@"carsys_71"],
                      @"14" : @[@"变速箱系统",@"carSys_7",@"carsys_71"],
                      @"8" : @[@"灯光系统",@"carSys_8",@"carsys_81"],
                      @"19" : @[@"灯光",@"carSys_8",@"carsys_81"],
                      @"9" : @[@"车身系统",@"carSys_9",@"carsys_91"],
                      @"18" : @[@"车身",@"carSys_9",@"carsys_91"],
                      @"10" : @[@"其他系统",@"carSys_6",@"carsys_61"],
                      @"11" : @[@"电控故障码",@"carSys_9",@"carsys_91"],
                      @"10000" : @[@"机油匹配(烧机油)",@"me_49",@"me_49"],
                      @"10001" : @[@"冷媒冷冻油",@"me_58",@"me_58"],
                      @"10002" : @[@"波箱油匹配",@"boxiangyou",@"boxiangyou"],}[key];
    
    return ((info)? (info) : (@[@"其他系统",@"carSys_6",@"carsys_61"]));
}

/*!
 *  @method stringFromDate:
 *
 *  @param
 date 日期
 formatter 日期格式字符串
 *
 *  @discussion 方法返回@formatter格式日期字符串
 *
 *  @see
 *  @seealso
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date byFormatter:(NSString*)formatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateFormatter setTimeZone:timeZone];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:formatter];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


/*!
 *  @method dateFromString: byFormatter:
 *
 *  @param
 dateString 日期
 
 formatter 日期格式字符串
 *
 *  @discussion 方法返回@formatter格式日期
 *
 *  @see
 *  @seealso
 *
 */
+ (NSDate *)dateFromString:(NSString*)dateString byFormatter:(NSString*)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: formatter];
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateFormatter setTimeZone:timeZone];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+(NSString*)encodeString:(NSString*)unencodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

//URLDEcode
+(NSString*)decodeString:(NSString*)encodedString
{
    
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSString*decodedString=(__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),  CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


//城市
+ (NSString*)getLocationLocality{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationLocalityKey];
}

//城市
+ (void)setLocationLocality:(NSString*)locationLocality{
    if (locationLocality == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationLocality forKey:locationLocalityKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

// 区
+ (NSString*)getLocationSubLocality{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationSubLocalityKey];
}

// 区
+ (void)setLocationSubLocality:(NSString*)locationSubLocality{
    if (locationSubLocality == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationSubLocality forKey:locationSubLocalityKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

//街道
+ (NSString*)getLocationThoroughfare{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationThoroughfareKey];
}

//街道
+ (void)setLocationThoroughfare:(NSString*)locationThoroughfare{
    if (locationThoroughfare == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationThoroughfare forKey:locationThoroughfareKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

//子街道
+ (NSString*)getLocationSubThoroughfare{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationSubThoroughfareKey];
}

//子街道
+ (void)setLocationSubThoroughfare:(NSString*)locationSubThoroughfare{
    if (locationSubThoroughfare == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationSubThoroughfare forKey:locationSubThoroughfareKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

//地名
+ (NSString*)getLocationName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationNameKey];
}

//地名
+ (void)setLocationName:(NSString*)locationName{
    if (locationName == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationName forKey:locationNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户类型
+ (NSNumber*)getUserType{
    return [[NSUserDefaults standardUserDefaults] valueForKey:userType];
}

//用户类型
+ (void)setUserType:(NSNumber*)type{
    if (type == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:userType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户名子名称
+ (NSString*)getSubName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:subUserNameKey];
}

//用户名子名称
+ (void)setSubName:(NSString*)name{
    if (name == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:subUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户名
+ (NSString*)getName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:userNameKey];
}

//用户名
+ (void)setName:(NSString*)name{
    if (name == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:userNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户密码
+ (NSString*)getPassword{
    NSData *password = [[NSUserDefaults standardUserDefaults] valueForKey:userPasswordKey];
    NSData *data = [password decryptWithKey:@"BankOfChinaNews.BOCOP.com"];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//用户密码
+ (void)setPassword:(NSString*)password{
    if (password == nil) {
        return;
    }
    NSData *clearData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data =  [clearData encryptWithKey:@"BankOfChinaNews.BOCOP.com"];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:userPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 是否是报告跳转
+ (BOOL)isReportJump{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:isReportJumpCode] boolValue];
}
+ (void)setIsReportJump:(BOOL)isReportJump{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isReportJump] forKey:isReportJumpCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//站点code
+ (NSString*)getServiceCode{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationServiceCode];
}

//站点code
+ (void)setServiceCode:(NSString*)serviceCode{
    if (serviceCode == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:serviceCode forKey:locationServiceCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//纬度
+ (NSNumber*)getLatitude{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationUserLatitude];
}

//纬度
+ (void)setLatitude:(NSNumber*)latitude{
    if (latitude == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:locationUserLatitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//经度
+ (NSNumber*)getLongitude{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationUserLongitude];
}

//经度
+ (void)setLongitude:(NSNumber*)longitude{
    if (longitude == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:locationUserLongitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否记住用户名和密码
+ (NSNumber*)getUserRemember{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationUserRemember];
}

//是否记住用户名和密码
+ (void)setUserRemember:(NSNumber*)isRemember{
    if (isRemember == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:isRemember forKey:locationUserRemember];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//启动版本
+ (NSString*)getAppversion{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationAppVersion];
}

//启动版本
+ (void)setAppversion:(NSString*)version{
    if (version == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:locationAppVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//首页功能块
+ (NSArray*)getFunctions{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationFunctions];
}

///首页功能块
+ (void)setFunctions:(NSArray*)functions{
    if (functions == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:functions forKey:locationFunctions];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//access_token
+ (NSString*)getAccessToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationAccessToken];
}

///access_token
+ (void)setAccessToken:(NSString*)accessToken{
    if (accessToken == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:locationAccessToken];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:locationAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setReportJumpCode:(NSString *)code{
    
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:reportJumpCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (NSString *)getReportJumpCode{
    return [[NSUserDefaults standardUserDefaults] valueForKey:reportJumpCode];
}

//微信授权信息
+ (NSDictionary*)getWeixinAccessInfo{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationWeixinAccessInfo];
}

//微信授权信息
+ (void)setWeixinAccessInfo:(NSDictionary*)info{
    if (info == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:locationWeixinAccessInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//微信授权信息code
+ (NSString*)getWeixinCode{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationWeixinCode];
}

//微信授权信息code
+ (void)setWeixinCode:(NSString*)info{
    if (info == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:locationWeixinCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//云虎 appid
+ (NSString*)getAppIdYH{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationAppIdYH];
}

//云虎 appid
+ (void)setAppIdYH:(NSString*)info{
    if (info == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:locationAppIdYH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//本地缓存搜索关键字
+ (NSArray*)getSearchKeys{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationSearchKeys];
}

//本地缓存搜索关键字
+ (void)setSearchKeys:(NSArray*)keys{
    if (keys == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:keys forKey:locationSearchKeys];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//本地延保缓存搜索关键字
+ (NSArray*)getExtendSearchKeys{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationExtendSearchKeys];
}

//本地延保缓存搜索关键字
+ (void)setExtendSearchKeys:(NSArray*)keys{
    if (keys == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:keys forKey:locationExtendSearchKeys];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

//MD5 32位大写加密 需在头文件加上#import <CommonCrypto/CommonDigest.h>
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
//    NSLog(@"====1.大写：%@====",[[NSString stringWithFormat:
//                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                          result[0], result[1], result[2], result[3],
//                          result[4], result[5], result[6], result[7],
//                          result[8], result[9], result[10], result[11],
//                          result[12], result[13], result[14], result[15]
//                          ] uppercaseString]);
//
//    NSLog(@"====2.小写：%@====",[[NSString stringWithFormat:
//                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                          result[0], result[1], result[2], result[3],
//                          result[4], result[5], result[6], result[7],
//                          result[8], result[9], result[10], result[11],
//                          result[12], result[13], result[14], result[15]
//                          ] lowercaseString]);
//
//    NSLog(@"====3.混合：%@====",[[NSString stringWithFormat:
//                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                          result[0], result[1], result[2], result[3],
//                          result[4], result[5], result[6], result[7],
//                          result[8], result[9], result[10], result[11],
//                          result[12], result[13], result[14], result[15]
//                          ] capitalizedString]);
    
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

//将字符串分割成数组,然后按首字母排序,再转回字符串
+ (NSString *)sortKey:(NSString*)str{
    //分割字符串
    NSArray * testA = [str componentsSeparatedByString:@"&"];
    //按首字母排序
    testA = [testA sortedArrayUsingSelector:@selector(compare:)];
    //数组转字符串
    NSString * testB = [NSString string];
    for (int i = 0; i < testA.count; i++ ) {
        if (i>0) {
            testB = [NSString stringWithFormat:@"%@&%@",testB,testA[i]];
        }else{
            testB = testA[i];
        }
    }
    return testB;
}

+ (NSString*)mileageShow:(NSString*)mileageStr{
    return [mileageStr stringByAppendingString:@"km"];
}

+ (NSString*)mileageGetNum:(NSString*)mileageStr{
    if ([mileageStr hasSuffix:@"km"]) {
        return [mileageStr stringByReplacingOccurrencesOfString:@"km" withString:@""];
    }else{
        return mileageStr;
    }
}


/*
 appVersion  本地储存版本
 version  服务器储存版本
 */
+ (BOOL)compVersion:(NSString*)appVersion version:(NSString*)version{
    
    
    NSArray *appVersionSem = [appVersion componentsSeparatedByString:@"."];
    NSArray *versionSem = [version componentsSeparatedByString:@"."];
    
    for (NSUInteger i = 0; i < appVersionSem.count; i++) {
        NSString *appSem = appVersionSem[i];
        if (versionSem.count <= i) {
            return NO;
        }
        NSString *sem = versionSem[i];
        if (appSem.integerValue > sem.integerValue) {
            return NO;
        }else if (appSem.integerValue < sem.integerValue) {
            return YES;
        }
    }
    return NO;
}

//储存本地jspath版本信息
+ (NSDictionary*)getUserJspath{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationUserJspath];
}

//获取本地jspath版本信息
+ (void)setUserJspath:(NSDictionary*)info{
    if (info == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:locationUserJspath];
     [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 php 接口数组格式
 */
+ (NSString*)arrayToStr:(NSArray*)items{
    __block NSString *itemsString = @"[";
    for (NSString *obj in items) {
        if ([itemsString isEqualToString:@"["]) {
            itemsString = [NSString stringWithFormat:@"%@\"%@\"", itemsString, obj];
        }else{
            itemsString = [NSString stringWithFormat:@"%@,\"%@\"", itemsString, obj];
        }
    }
    itemsString = [NSString stringWithFormat:@"%@]", itemsString];
    return itemsString;
}
/*
 php 接口Map格式
 */
+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary{
    
    //系统自带
    
    //    NSError * error;
    
    //    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    
    //    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //自定义
    
    NSString *jsonStr = @"{";
    
    NSArray * keys = [dictionary allKeys];
    
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        
        jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
        
    }
    
    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
    
    return jsonStr;
    
}


/*
 转json字符串
 */
+(NSString*)data2jsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:kNilOptions // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

//json格式字符串转字典：

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+ (NSString*)yhStringByReplacing:(NSString*)str{
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    return str;
}

//判断权限
+ (NSString*)getRejectListByPath:(NSString*)path{
    
    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = userInfo[@"data"];
    NSArray *menuList = data[@"menuList"];
    for (NSDictionary *menuInfo in menuList) {
        if ([menuInfo[@"path"] isEqualToString:path]) {
            return menuInfo[@"rejectList"];
        }
        if ([menuInfo[@"path"] isEqualToString:path]) {
            return @"Orders";
        }
    }
    return nil;
}





//获取当前的时间
+(NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSLog(@"-------datenow = %@-------",datenow);
    
    //将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"-------currentTimeString = %@-------",currentTimeString);
    
    return currentTimeString;
}

//获取当前时间戳有两种方法(以秒为单位)  方法1
+(NSString *)getTimestampWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    //    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

//获取当前时间戳有两种方法(以秒为单位)  方法2
+(NSString *)getNowTimeTimestamp2
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

//获取当前时间戳（以毫秒为单位）
+(NSString *)getNowTimeTimestamp3
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}


+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    const char *cKey  = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    //将加密结果进行一次BASE64编码。
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSUTF8StringEncoding];
    return hash;
}

/**
 * 非认证检测根据图片尺寸和图片路径，生成相应URL
 */
+ (NSString *)hmacsha1YH:(NSString *)picture width:(long)width{
    return [NSString stringWithFormat:@"%@%@", SERVER_JAVA_NonAuthentication_IMAGE_URL, [YHTools hmacsha1YHCommon:picture width:width key:HmacSHA1Key]];
}

/**
 * 认证检测根据图片尺寸和图片路径，生成相应URL
 */
+ (NSString *)hmacsha1YHJns:(NSString *)picture width:(long)width{
    return [NSString stringWithFormat:@"%@%@", SERVER_JAVA_IMAGE_URL, [YHTools hmacsha1YHCommonJNS:picture width:width key:HmacSHA1KeyJns]];
}

/**
 * 根据图片尺寸和图片路径，生成相应签名
 */
+ (NSString *)hmacsha1YHCommonJNS:(NSString *)picture width:(long)width key:(NSString*)key{
    NSString *size = [NSString stringWithFormat:@"%ldx0", width];
    NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",size,picture];
    NSString *content = [YHTools hmacsha1:subFilePath key:key];
    content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    content = [content stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [NSString stringWithFormat:@"%@/%@", content, subFilePath];
}

/**
 * 非认证根据图片尺寸和图片路径，生成相应签名
 */
+ (NSString *)hmacsha1YHCommon:(NSString *)picture width:(long)width key:(NSString*)key{
    NSString *size = [NSString stringWithFormat:@"%ldx0/files/images", width];
    NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",size,picture];
    NSString *content = [YHTools hmacsha1:subFilePath key:key];
    content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    content = [content stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [NSString stringWithFormat:@"%@/%@", content, subFilePath];
}



@end
