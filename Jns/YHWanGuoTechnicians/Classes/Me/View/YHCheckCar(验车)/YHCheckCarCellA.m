//
//  YHCheckCarCellA.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/5/22.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckCarCellA.h"
#import "YHTools.h"

@implementation YHCheckCarCellA

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.typeCollectionView registerNib:[UINib nibWithNibName:@"YHCheckCarCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"YHCheckCarCollectionCell"];
}

#pragma mark - V1版本
-(void)refreshUIWithVersion:(NSString *)version WithImageStr:(NSString *)imageStr WithNameStr:(NSString *)nameStr WithRow:(NSInteger)row WithArray1:(NSMutableArray *)array1 WithArray2:(NSMutableArray *)array2 WithArray3:(NSMutableArray *)array3 WithArray4:(NSMutableArray *)array4 WithArray5:(NSMutableArray *)array5 WithArray6:(NSMutableArray *)array6;
{
    [self.typeImageView setImage:[UIImage imageNamed:imageStr]];
    self.typeLabel.text = nameStr;
    self.projectNameLabel.hidden = YES;
    self.isNormalLabel.hidden = YES;

    self.array1 = array1;
    self.array2 = array2;
    self.array3 = array3;
    self.array4 = array4;
    self.array5 = array5;
    self.array6 = array6;
    
    self.row = row;
    self.version = version;
    
    self.typeCollectionView.delegate = self;
    self.typeCollectionView.dataSource = self;
    
    [self.typeCollectionView reloadData];
}

#pragma mark - V2版本
-(void)refreshUIWithVersion:(NSString *)version WithModel:(YHCheckCarModelA *)model
{
    self.typeView.hidden = YES;
    self.projectNameLabel.text = model.projectName;
    self.isNormalLabel.text = model.projectOptionName;
    self.projectRelativeImgList = model.projectRelativeImgList;

    self.version = version;

    self.typeCollectionView.delegate = self;
    self.typeCollectionView.dataSource = self;
    
    [self.typeCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.version isEqualToString:@"1"]) {
        if ([self.typeLabel.text isEqualToString:@"可见伤"]) {
            return self.array1.count;
        } else if ([self.typeLabel.text isEqualToString:@"有喷漆"]) {
            return self.array2.count;
        } else if ([self.typeLabel.text isEqualToString:@"有色差"]) {
            return self.array3.count;
        } else if ([self.typeLabel.text isEqualToString:@"钣金修复"]) {
            return self.array4.count;
        } else if ([self.typeLabel.text isEqualToString:@"划痕"]) {
            return self.array5.count;
        } else {
            return self.array6.count;
        }
    } else {
        return self.projectRelativeImgList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHCheckCarCollectionCell * cell = [self.typeCollectionView dequeueReusableCellWithReuseIdentifier:@"YHCheckCarCollectionCell" forIndexPath:indexPath];
    
    if ([self.version isEqualToString:@"1"]) {
        if ([self.typeLabel.text isEqualToString:@"可见伤"]) {
            YHCheckCarModel0 *model = self.array1[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        } else if ([self.typeLabel.text isEqualToString:@"有喷漆"]) {
            YHCheckCarModel0 *model = self.array2[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        } else if ([self.typeLabel.text isEqualToString:@"有色差"]) {
            YHCheckCarModel0 *model = self.array3[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        } else if ([self.typeLabel.text isEqualToString:@"钣金修复"]) {
            YHCheckCarModel0 *model = self.array4[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        } else if ([self.typeLabel.text isEqualToString:@"划痕"]) {
            YHCheckCarModel0 *model = self.array5[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        } else {
            YHCheckCarModel0 *model = self.array6[indexPath.item];
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        }
    } else {
        if (self.projectRelativeImgList.count != 0) {
            NSLog(@"----------哈哈：%@---------%ld----------",[NSURL URLWithString:[YHTools hmacsha1YHJns:self.projectRelativeImgList[indexPath.item] width:90]],indexPath.section);
            [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:[YHTools hmacsha1YHJns:self.projectRelativeImgList[indexPath.item] width:90]] placeholderImage:[UIImage imageNamed:@"carModelDefault"]];
        }
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    if ([self.version isEqualToString:@"1"]) {
        if ([self.typeLabel.text isEqualToString:@"可见伤"]) {
            for (YHCheckCarModel0 *model in self.array1) {
                [tempArray addObject:model.img_url];
            }
        } else if ([self.typeLabel.text isEqualToString:@"有喷漆"]) {
            for (YHCheckCarModel0 *model in self.array2) {
                [tempArray addObject:model.img_url];
            }
        } else if ([self.typeLabel.text isEqualToString:@"有色差"]) {
            for (YHCheckCarModel0 *model in self.array3) {
                [tempArray addObject:model.img_url];
            }
        } else if ([self.typeLabel.text isEqualToString:@"钣金修复"]) {
            for (YHCheckCarModel0 *model in self.array4) {
                [tempArray addObject:model.img_url];
            }
        } else if ([self.typeLabel.text isEqualToString:@"划痕"]) {
            for (YHCheckCarModel0 *model in self.array5) {
                [tempArray addObject:model.img_url];
            }
        } else {
            for (YHCheckCarModel0 *model in self.array6) {
                [tempArray addObject:model.img_url];
            }
        }
    } else {
        if (self.projectRelativeImgList.count != 0) {
            for (NSString *str in self.projectRelativeImgList) {
                [tempArray addObject:[YHTools hmacsha1YHJns:str width:0]];
            }
        }
    }
    
    [YHHUPhotoBrowser showFromImageView:nil withURLStrings:tempArray placeholderImage:[UIImage imageNamed:@"carModelDefault"] atIndex:indexPath.item dismiss:^(UIImage *image, NSInteger index) {
        
    }];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 18;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

@end
