//
//  ViewController.m
//  test
//
//  Created by Jay on 5/11/2019.
//  Copyright © 2019 HKV_. All rights reserved.
//

#import "ViewController.h"
#import "VegaScrollFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
//    layout.minimumLineSpacing = lineSpacing
//    layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
//    let itemWidth = UIScreen.main.bounds.width - 2 * xInset
//    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//    collectionView.collectionViewLayout.invalidateLayout()
//    collectionView.contentInset.bottom = itemHeight
    
    
    self.collectionView.contentInset = UIEdgeInsetsMake(self.collectionView.contentInset.top, self.collectionView.contentInset.left, 84, self.collectionView.contentInset.right);
    

    VegaScrollFlowLayout *layout = (VegaScrollFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width - 2 * 20;
    layout.itemSize = CGSizeMake(itemWidth, 84);
    [self.collectionView.collectionViewLayout invalidateLayout];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 14;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;//UIColor.black.cgColor
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowOffset = CGSizeMake(0, 5);//CGSize(width: 0, height: 5)
    cell.layer.masksToBounds = false;
    
    return cell;
}

@end
