//
//  YHFunctionEditerCell.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHFunctionEditerCell : UICollectionViewCell

- (void)loadDatasource:(NSNumber*)functionKey isEditer:(BOOL)isEditer isHome:(BOOL)isHome;
@end
