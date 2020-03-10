//
//  PCMessageModel.h
//  penco
//
//  Created by Jay on 13/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PCMessageBodyModel : NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, assign) NSInteger status;//2 未读，3已读
@property (nonatomic, copy) NSString *measureTime;
@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, assign) BOOL confirmStatus;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

//测量量code
//0:成功
//其他失败 详情⻅见体形算法Code码
@property (nonatomic, assign) NSInteger analysisCode;

@property (nonatomic, copy) NSString *analysisMessage;

@end



@interface PCMessageModel : NSObject

//@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, strong) PCMessageBodyModel *info;
@property (nonatomic, assign) NSInteger status;//2 未读，3已读

@end

NS_ASSUME_NONNULL_END
