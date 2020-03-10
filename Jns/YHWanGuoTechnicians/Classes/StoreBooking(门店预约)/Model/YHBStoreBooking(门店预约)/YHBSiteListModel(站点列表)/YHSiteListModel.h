//
//  YHSiteListModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSiteListModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *contact_name;
@property (nonatomic, copy)NSString *contact_tel;
@property (nonatomic, copy)NSString *lng;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *coordinate_ico;
@property (nonatomic, copy)NSString *address;

@end

NS_ASSUME_NONNULL_END
