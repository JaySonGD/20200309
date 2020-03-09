//
//  VegaScrollFlowLayout.h
//  test
//
//  Created by Jay on 5/11/2019.
//  Copyright © 2019 HKV_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VegaScrollFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat springHardness;
@property (nonatomic, assign) BOOL isPagingEnabled;
@end

NS_ASSUME_NONNULL_END
