//
//  PCPostureModel.h
//  penco
//
//  Created by Jay on 26/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCPostureCard.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^PostureImgHandler)(UIImage *image);

@interface PCPostureRisks : NSObject

@property (nonatomic, strong)NSMutableArray<PCPostureCard *> *risks;
@end
@interface PCPostureModel : NSObject
//下载体态图和回调
-(void)postureImg:(PostureImgHandler)hander;
@property (nonatomic, strong)NSMutableArray<PCPostureCard *> *postureCards;
@property (nonatomic, copy) NSString *measureTime;
@property (nonatomic, copy) NSString *postureId;
@property (nonatomic, copy) NSString *positivePhotoUrl;
@property (nonatomic, copy) NSString *analysisReportUrl;
@property (nonatomic, copy) NSString *sidePhotoUrl;
@property (nonatomic, strong)   id analysisResult;

//创感体态分析
@property (nonatomic, strong)   id analysisReport;//创感体态分析报告数据
@property (nonatomic, strong)   id analysisReportUrlList;//创感体态分析URL Map信息
@property (strong, nonatomic) NSMutableArray *imgs;//体态图片

//测量量code
//0:成功
//其他失败 详情⻅见体形算法Code码
@property (nonatomic, assign) NSInteger analysisCode;

@property (nonatomic, copy) NSString *analysisMessage;


@end

NS_ASSUME_NONNULL_END
