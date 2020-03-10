//
//  PCReportModel.h
//  penco
//
//  Created by Jay on 25/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCReportModel : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> *xaxisData;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *yaxisData;

@end

NS_ASSUME_NONNULL_END
