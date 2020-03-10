//
//  YHTools.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/10.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMKeychain.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "YHTools.h"
#import "AppDelegate.h"
#import "NSData+Encryption.h"
#import "YHBase64.h"
#import "YHCommon.h"
static NSString * const locationLocalityKey = @"YHLocationLocality";
static NSString * const locationSubLocalityKey = @"YHLocationSubLocality";
static NSString * const locationThoroughfareKey = @"YHLocationThoroughfare";
static NSString * const locationSubThoroughfareKey = @"YHLocationSubThoroughfare";
static NSString * const locationNameKey = @"YHLocationName";
static NSString * const userNameKey = @"YHLocationUserName";
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
static NSString * const PersonCenterNewService = @"PersonCenterNewService";
static NSString * const PersonCenterMask = @"PersonCenterMask";
static NSString * const PersonCenterNewServiceCellOne = @"PersonCenterNewServiceCellOne";
static NSString * const PersonCenterNewServiceCellTwo = @"PersonCenterNewServiceCellTwo";
static NSString * const PersonCenterNewServiceCellThree = @"PersonCenterNewServiceCellThree";
static NSString * const PersonCenterNewServiceCellFour = @"PersonCenterNewServiceCellFour";
@implementation YHTools

DEFINE_SINGLETON_FOR_CLASS(YHTools);

+ (NSArray*)sysProjectByKey:(NSString*)key {
    NSArray *info = @{@"0" : @[@"其他系统",@"carSys_6",@"carsys_61"],
                      @"43" : @[@"底盘系统",@"23",@"23"],
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
    NSTimeZone* GTMzone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:GTMzone];
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
    NSTimeZone* GTMzone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:GTMzone];
    [dateFormatter setDateFormat: formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
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
}

//个人中心蒙版
+ (NSString*)getPersonCenterMask{
    return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterMask];
}

//个人中心蒙版
+ (void)setPersonCenterMask:(NSString*)personCenterMask{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterMask] forKey:PersonCenterMask];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getPersonCenterNewService{
    return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterNewService];
}

//个人中心顶部新功能
+ (void)setPersonCenterNewService:(NSString*)personCenterNewService{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterNewService] forKey:PersonCenterNewService];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//个人中心店铺业绩
+ (NSString*)getPersonCenterNewServiceCellOne{
      return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterNewServiceCellOne];
}

//个人中心店铺业绩
+ (void)setPersonCenterNewServiceCellOne:(NSString*)personCenterNewServiceCellOne{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterNewServiceCellOne] forKey:PersonCenterNewServiceCellOne];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

//个人中心员工业绩
+ (NSString*)getPersonCenterNewServiceCellTwo{
      return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterNewServiceCellTwo];
}

//个人中心员工业绩
+ (void)setPersonCenterNewServiceCellTwo:(NSString*)personCenterNewServiceCellTwo{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterNewServiceCellTwo] forKey:PersonCenterNewServiceCellTwo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//学员信息
+ (NSString*)getPersonCenterNewServiceCellThree{
      return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterNewServiceCellThree];
}

//学员信息
+ (void)setPersonCenterNewServiceCellThree:(NSString*)personCenterNewServiceCellThree{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterNewServiceCellThree] forKey:PersonCenterNewServiceCellThree];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//拆装查询统计
+ (NSString*)getPersonCenterNewServiceCellFour{
      return [[NSUserDefaults standardUserDefaults] valueForKey:PersonCenterNewServiceCellFour];
}

//拆装查询统计
+ (void)setPersonCenterNewServiceCellFour:(NSString*)personCenterNewServiceCellFour{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@",[YHTools getName],personCenterNewServiceCellFour] forKey:PersonCenterNewServiceCellFour];
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
}

//本地延长保修缓存搜索关键字
+ (NSArray*)getExtendSearchKeys{
    return [[NSUserDefaults standardUserDefaults] valueForKey:locationExtendSearchKeys];
}

//本地延长保修缓存搜索关键字
+ (void)setExtendSearchKeys:(NSArray*)keys{
    if (keys == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:keys forKey:locationExtendSearchKeys];
}

//MD5 32位大写加密 需在头文件加上#import <CommonCrypto/CommonDigest.h>
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
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
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
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

//唯一标示
+(NSString *)getUniqueDeviceIdentifierAsString
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:@"YH.MengHu.YHTechnician"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = @"YH.MengHu.YHTechnician";
        query.password = strApplicationUUID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
        
    }
    
    return strApplicationUUID;
}

#pragma mark - 编码
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

#pragma mark - 解码
+(NSString*)decodeString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSString *decodedString=(__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),  CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret
{
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
 * 非认证检测根据图片尺寸和图片路径，生成相应签名
 */
+ (NSString *)hmacsha1YH:(NSString *)picture width:(long)width{
    return [NSString stringWithFormat:@"%@%@", SERVER_JAVA_NonAuthentication_IMAGE_URL, [YHTools hmacsha1YHCommon:picture width:width key:HmacSHA1Key]];
}

/**
 * 认证检测根据图片尺寸和图片路径，生成相应签名
 */
+ (NSString *)hmacsha1YHJns:(NSString *)picture width:(long)width{
    return [NSString stringWithFormat:@"%@%@", SERVER_JAVA_IMAGE_URL, [YHTools hmacsha1YHCommon:picture width:width key:HmacSHA1KeyJns]];
}

/**
 * 根据图片尺寸和图片路径，生成相应签名
 */
+ (NSString *)hmacsha1YHCommon:(NSString *)picture width:(long)width key:(NSString*)key{
    NSString *size = [NSString stringWithFormat:@"%ldx0", width];
    NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",size,picture];
    NSString *content = [YHTools hmacsha1:subFilePath key:key];
    content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    content = [content stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [NSString stringWithFormat:@"%@/%@", content, subFilePath];
}


@end
