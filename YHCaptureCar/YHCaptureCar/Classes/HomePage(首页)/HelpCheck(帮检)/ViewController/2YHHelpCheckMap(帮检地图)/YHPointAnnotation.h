//
//  YHPointAnnotation.h
//  YHCaptureCar
//
//  Created by Jay on 18/5/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface YHPointAnnotation : MAPointAnnotation
@property (nonatomic, copy)NSString *ID;                 //站点ID

//@property (nonatomic, copy) NSString *jnsDeptId;
//—isOnline    String    支持在线预约 0-不支持 1-支持
//@property (nonatomic, assign) BOOL isOnline;
//—sceneIcon    String    图片名称 xh-小虎检车 bc-捕车 jns - JNS
@property (nonatomic, copy) NSString *sceneIcon;

@end
