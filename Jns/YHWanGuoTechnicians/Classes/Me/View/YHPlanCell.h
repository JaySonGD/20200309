//
//  YHPlanCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/19.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHPlanCell : UICollectionViewCell

- (void)loadDatasource:(NSString*)planStr isSel:(BOOL)isSel;
@end
