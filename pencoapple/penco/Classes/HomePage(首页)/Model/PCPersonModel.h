//
//  PCPersonModel.h
//  penco
//
//  Created by Jay on 25/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCPersonModel : NSObject


@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString *headImg;

//测量量⽤用户类型: 账号对应的测量量成员 master 普通测量量成员 common
@property (nonatomic, copy) NSString *personType;

//@property (nonatomic, assign) BOOL isShow;
@end

NS_ASSUME_NONNULL_END
