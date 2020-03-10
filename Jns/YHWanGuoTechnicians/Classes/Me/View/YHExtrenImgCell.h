//
//  YHExtrenImgCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHExtrenImgCell : UICollectionViewCell

- (void)loadData:(NSString*)urlStr image:(UIImage*)image isAdd:(BOOL)isadd index:(NSUInteger)index;
@end
