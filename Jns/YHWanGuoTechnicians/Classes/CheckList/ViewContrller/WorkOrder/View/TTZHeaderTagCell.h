//
//  TTZHeaderTagCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTZGroundModel,TTZValueModel;
@interface TTZHeaderTagCell : UICollectionViewCell
@property (nonatomic, strong)  TTZGroundModel*tagModel;
@end


@interface TTZValueCell : UICollectionViewCell
@property (nonatomic, strong)  TTZValueModel*model;
@end
