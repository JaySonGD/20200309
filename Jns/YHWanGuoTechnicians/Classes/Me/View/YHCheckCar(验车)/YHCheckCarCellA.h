//
//  YHCheckCarCellA.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/5/22.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "YHHUPhotoBrowser.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

#import "YHCheckCarModel0.h"
#import "YHCheckCarModelA.h"
#import "YHCheckCarModelB.h"

#import "YHCheckCarCollectionCell.h"

@interface YHCheckCarCellA : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isNormalLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;

@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)NSMutableArray *array1;
@property(nonatomic,strong)NSMutableArray *array2;
@property(nonatomic,strong)NSMutableArray *array3;
@property(nonatomic,strong)NSMutableArray *array4;
@property(nonatomic,strong)NSMutableArray *array5;
@property(nonatomic,strong)NSMutableArray *array6;

@property (nonatomic, copy)NSString *version;
@property (nonatomic, strong)NSArray *projectRelativeImgList;

-(void)refreshUIWithVersion:(NSString *)version WithImageStr:(NSString *)imageStr WithNameStr:(NSString *)nameStr WithRow:(NSInteger)row WithArray1:(NSMutableArray *)array1 WithArray2:(NSMutableArray *)array2 WithArray3:(NSMutableArray *)array3 WithArray4:(NSMutableArray *)array4 WithArray5:(NSMutableArray *)array5 WithArray6:(NSMutableArray *)array6;

-(void)refreshUIWithVersion:(NSString *)version WithModel:(YHCheckCarModelA *)model;

@end
