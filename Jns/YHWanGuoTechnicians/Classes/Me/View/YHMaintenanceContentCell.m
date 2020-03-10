//
//  YHMaintenanceContentCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/11/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHMaintenanceContentCell.h"

#import "YHMaintenanceCollectionCell.h"

@interface YHMaintenanceContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak)  UIView *view;

@property (nonatomic, weak) UICollectionView *collectView;

@property (nonatomic, copy) NSArray *itemList;

@end

@implementation YHMaintenanceContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    
    UILabel *titleL = [[UILabel alloc] init];
    self.titleL = titleL;
    UIColor *mainTextColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0];
    titleL.textColor = mainTextColor;
    titleL.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@0);
        make.top.equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    UIView *view = [[UIView alloc] init];
    self.view = view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(10);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@8);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor clearColor];
    collectView.scrollEnabled = NO;
    [collectView registerClass:[YHMaintenanceCollectionCell class] forCellWithReuseIdentifier:@"YHCollectionViewCellMaintenanceId"];
    self.collectView = collectView;
    collectView.delegate = self;
    collectView.dataSource = self;

    [self.view addSubview:collectView];
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(collectView.superview);
    }];
    
    [self.contentView layoutIfNeeded];

    dispatch_async(dispatch_get_main_queue(), ^{
        layout.itemSize = CGSizeMake(self.view.frame.size.width , 20);
    });
    
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 0.8;
    [super setFrame:frame];
}
- (void)setIsCanEdit:(BOOL)isCanEdit{
    _isCanEdit = isCanEdit;
    
    [self.collectView reloadData];;
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    
    self.titleL.text = [NSString stringWithFormat:@"%@（%@）",info[@"title"],info[@"careTimeDesc"]];
    
    NSArray *itemList = _info[@"itemList"];
    self.itemList = itemList;
    [self.collectView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.itemList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHMaintenanceCollectionCell * cell = (YHMaintenanceCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YHCollectionViewCellMaintenanceId" forIndexPath:indexPath];

    cell.clickEditBtnEvent = ^(NSDictionary *itemDict) {
        if (_clickSelectMaintenanceEvent) {
            _clickSelectMaintenanceEvent(itemDict);
        }
    };
    NSDictionary *item = self.itemList[indexPath.row];
    cell.isCanEdit = self.isCanEdit;
    cell.info = item;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    if(self.isLast){
    [self.contentView setRounded:self.contentView.frame corners:UIRectCornerBottomRight | UIRectCornerBottomLeft radius:4.0];
    }
}

@end
