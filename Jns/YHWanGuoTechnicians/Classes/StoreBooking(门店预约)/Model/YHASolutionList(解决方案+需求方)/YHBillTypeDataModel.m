//
//  YHBillTypeDataModel.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/27.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBillTypeDataModel.h"

@implementation YHBillTypeDataModel

//利用MJExtension处理OC里"id"关键字
//http://blog.csdn.net/github_26672553/article/details/51910519
//id是Objective-C里的关键字，我们一般用大写的ID替换，但是往往服务器给我们的数据是小写的id，这个时候就可以用MJExtension框架里的方法转换一下：
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end
