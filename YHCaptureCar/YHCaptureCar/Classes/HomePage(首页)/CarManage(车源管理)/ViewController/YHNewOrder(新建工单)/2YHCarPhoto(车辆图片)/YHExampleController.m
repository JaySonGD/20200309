//
//  YHExampleController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHExampleController.h"
#import "YHCarPhotoModel.h"


#import "YHExampleCell.h"

#import "YHCommon.h"

#import <MJExtension/MJExtension.h>

@interface YHExampleController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (nonatomic, assign) NSInteger  index;

@end

@implementation YHExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     YHExampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *imageName = self.models[indexPath.item].imageName;
    cell.imageView.image = [UIImage imageNamed:imageName];//;
    //cell.backgroundColor = YHRandomColor;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width );
    if (page > self.models.count-1) {
        page = self.models.count - 1;
    }
    self.index = page;

    self.titleLB.text = self.models[page].title;
    self.nameLB.text = self.models[page].name;

}

#pragma mark  -  事件监听

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)lastAction:(UIButton *)sender {
    
    
    self.index --;
    if (self.index<0) {
        self.index = self.models.count - 1;
    }
    
    [self scrollToItemAtIndex:self.index];

}

- (IBAction)nextAction:(UIButton *)sender {
    
    self.index ++;
    if (self.index > self.models.count-1) {
        self.index = 0;
    }

    [self scrollToItemAtIndex:self.index];
}


#pragma mark  -  自定义方法

- (void)scrollToItemAtIndex:(NSInteger)index{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)setUI{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.layout.itemSize = CGSizeMake(screenWidth, screenHeight+20);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.collectionView.pagingEnabled = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndex:self.selectIndex];
    });

    self.navigationBarHeight.constant = NavbarHeight;
}


#pragma mark  -  get/set 方法


- (NSArray<YHPhotoModel *> *)models
{
    if (!_models) {
        NSArray * array = @[
                            @{@"imageName": @"外观正面1",@"name":@"车辆正面",@"title":@"车辆外观 示例图"},
                            @{@"imageName": @"外观背面1",@"name":@"车辆背面",@"title":@"车辆外观 示例图"},
                            @{@"imageName": @"外观左侧1",@"name":@"车辆左侧",@"title":@"车辆外观 示例图"},
                            @{@"imageName": @"外观右侧1",@"name":@"车辆右侧",@"title":@"车辆外观 示例图"},
                            @{@"imageName": @"机舱1",@"name":@"机舱",@"title":@"机舱 示例图"},
                            @{@"imageName": @"后尾箱1",@"name":@"后尾箱",@"title":@"后尾箱 示例图"},
                            @{@"imageName": @"内饰第一排1",@"name":@"一排",@"title":@"内饰 示例图"},
                            @{@"imageName": @"内饰第一排1",@"name":@"二排",@"title":@"内饰 示例图"},
                            @{@"imageName": @"仪表盘1",@"name":@"仪表盘",@"title":@"仪表盘 示例图"},
                            ];
        
        _models =  [YHPhotoModel mj_objectArrayWithKeyValuesArray:array];
        
    }
    return _models;
}


@end
