//
//  PCPostureCell.h
//  penco
//
//  Created by Zhu Wensheng on 2019/7/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCPostureCell : UICollectionViewCell
- (void)loadImg:(UIImage*)image
          index:(NSInteger)index
            hip:(float)hip
           hipV:(float)hipV
       shoulder:(float)shoulder
      shoulderV:(float)shoulderV;
@end

NS_ASSUME_NONNULL_END
