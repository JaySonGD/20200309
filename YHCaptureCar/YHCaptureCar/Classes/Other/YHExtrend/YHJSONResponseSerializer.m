//
//  YHJSONResponseSerializer.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/16.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHJSONResponseSerializer.h"
#import "YHTools.h"
#import "YHCommon.h"
@implementation YHJSONResponseSerializer

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    
    //校验是否是json格式，在缺少accid 情况下 不返回检验ID
    id json = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:nil];
    
    if ([NSJSONSerialization isValidJSONObject:json]) {
        return [super responseObjectForResponse:response data:data error:error];
    }else{
        /**
         zws done
         数据解析加校验
         **/
        NSString *contentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *md5Sign = [contentStr substringFromIndex:contentStr.length - 32];
        NSString *jsonStr = [contentStr substringToIndex:contentStr.length - 32];
        NSString *jsonStrAndKey = [NSString stringWithFormat:@"%@%@", jsonStr, signKey];
        if ([[YHTools md5:jsonStrAndKey] isEqualToString:md5Sign]) {
            return [super responseObjectForResponse:response data:[data subdataWithRange:NSMakeRange(0, data.length - 32)] error:error];
        }else{//校验失败
            return @{@"retCode" : JsonDataCheckoutFailure,
                     @"retMsg" : @"网络返回数据校验失败",
                     };
        }
    }
}
@end
