//
//  YHCheckCarDetailCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckCarDetailCell.h"
#import "YHAskInfoViewCollectionCell.h"
#import <UIImageView+WebCache.h>
#import "YHHUPhotoBrowser.h"

#define halfWidth ([UIScreen mainScreen].bounds.size.width - 44)/2.0

@interface YHCheckCarDetailCell () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UILabel *subTitleL;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isAskInfo;

@end

@implementation YHCheckCarDetailCell

+ (instancetype)createCheckCarDetailCell:(UITableView *)tableView{
    
    static NSString *cellID = @"YHCheckCarDetailCellID";
    YHCheckCarDetailCell * checkCarcell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!checkCarcell) {
        checkCarcell = [[YHCheckCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        checkCarcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return checkCarcell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@45);
        make.width.equalTo(@(halfWidth));
        make.top.equalTo(titleL.superview);
        
    }];
    
    UILabel *subTitleL = [[UILabel alloc] init];
    subTitleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    subTitleL.font = [UIFont systemFontOfSize:14];
    subTitleL.textAlignment = NSTextAlignmentRight;
    self.subTitleL = subTitleL;
    [self.contentView addSubview:subTitleL];
    [subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(titleL);
        make.centerY.equalTo(titleL);
        make.right.equalTo(subTitleL.superview).offset(-8);
        make.left.equalTo(titleL.mas_right);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(64, 64);
    layout.sectionInset                = UIEdgeInsetsMake(15, 10, 15, 0);
    layout.minimumInteritemSpacing     = 10.f;
    layout.minimumLineSpacing          = 5.0f;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    [self.contentView addSubview:collectionView];
    
    [collectionView registerClass:[YHAskInfoViewCollectionCell class] forCellWithReuseIdentifier:@"YHCheckCarDetailCell_inCollectionView"];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.bounces = NO;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL);
        make.top.equalTo(subTitleL.mas_bottom);
        make.bottom.equalTo(collectionView.superview);
        make.right.equalTo(subTitleL);
    }];
    
}
#pragma mark - 基本信息 --
- (void)setBaseInfo:(NSDictionary *)baseInfo{
    _baseInfo = baseInfo;

    self.titleL.text = baseInfo[@"name"];
    self.subTitleL.text = baseInfo[@"value"];
    
    [self.titleL sizeToFit];
    
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@45);
        make.top.equalTo(self.titleL.superview);
    }];

    [self.subTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.titleL);
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.subTitleL.superview).offset(-8);
        make.left.equalTo(self.titleL.mas_right);
    }];
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    
    self.isAskInfo = NO;
    
    self.titleL.text = info[@"projectName"];
    self.subTitleL.text = info[@"projectVal"];
    // 问题级别：1-正常，0-不正常
    if ([info[@"errorLevel"] isEqualToString:@"0"]) {
        self.subTitleL.textColor = [UIColor redColor];
    }else{
         self.subTitleL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    }
    
    if (!info[@"projectVal"] || [info[@"projectVal"] isEqualToString:@""]) {
        self.subTitleL.textColor = [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1.0];
        self.subTitleL.text = @"未检测";
    }
    
    [self showViewWithSubTitleLableWidth];
    
     [self.collectionView reloadData];
    
}
#pragma width - 以subTitle先显示完全为准---
- (void)showViewWithSubTitleLableWidth{
    
    [self.subTitleL sizeToFit];
    [self.subTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(self.subTitleL.superview);
        make.right.equalTo(self.subTitleL.superview).offset(-8);
    }];
    
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(self.subTitleL);
        make.right.equalTo(self.subTitleL.mas_left);
        make.centerY.equalTo(self.subTitleL);
        
    }];
}

#pragma mark - 问询 --
- (void)setAskInfo:(NSDictionary *)askInfo{
    _askInfo = askInfo;
    
    self.isAskInfo = YES;
    
    self.titleL.text = askInfo[@"rowTitle"];
    self.subTitleL.text = askInfo[@"rowSubTitle"];
    [self showViewWithSubTitleLableWidth];
    
    [self.collectionView reloadData];

}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    frame.size.width -= 16;
    frame.origin.x += 8;
    [super setFrame:frame];
    
    if (self.indexPath.row == self.maxRows - 1) {
        [self setRounded:self.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
    }else{
        
        [self setRounded:self.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:0.0];
    }
}
#pragma mark - UICollectionViewDataSource ----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *imgList = self.isAskInfo ? self.askInfo[@"imgList"] : self.info[@"imgList"];
    return imgList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHAskInfoViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHCheckCarDetailCell_inCollectionView" forIndexPath:indexPath];
    NSArray *imgList = self.isAskInfo ? self.askInfo[@"imgList"] : self.info[@"imgList"];
    NSString *imgStr = imgList[indexPath.row];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[YHTools hmacsha1YHJns:imgStr width:65]]  placeholderImage:[UIImage imageNamed:@"carModelDefault"] options:SDWebImageRefreshCached];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate -----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *imgList = self.isAskInfo ? self.askInfo[@"imgList"] : self.info[@"imgList"];
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *imgStr in imgList) {
        [temArr addObject:[YHTools hmacsha1YHJns:imgStr width:[UIScreen mainScreen].bounds.size.width]];
    }
    
     [YHHUPhotoBrowser showFromImageView:nil withURLStrings:temArr placeholderImage:[UIImage imageNamed:@"carModelDefault"] atIndex:indexPath.item dismiss:^(UIImage *image, NSInteger index) {
     
     }];

}
@end
