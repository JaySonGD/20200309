//
//  YHUploadingController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHUploadingController.h"
#import "YHCommon.h"
#import "YHUploadingCell.h"
#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "TTZUpLoadService.h"

@interface YHUploadingController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *unFinfinshL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISwitch *networkSwitch;

@property (nonatomic, strong) NSArray <TTZDBModel *>*models;
@property (nonatomic, assign) NSInteger finisnCount;

@end

@implementation YHUploadingController

- (void)initVar
{
    _models = [[NSMutableArray alloc]init];

    _finisnCount = 0;
    _networkSwitch.on = TTZUpLoadService.sharedTTZUpLoadService.isAllowWWAN;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initVar];
    
    [self initUI];

    [self initData];
}

- (void)initUI
{
    [_collectionView registerNib:[UINib nibWithNibName:@"YHUploadingCell" bundle:nil] forCellWithReuseIdentifier:@"YHUploadingCell"];
}

- (void)initData
{
    //待完成初始数量
    _models =  [TTZDBModel findWhere:[NSString stringWithFormat:@"where isUpLoad = %d",YES]];
    _unFinfinshL.text = [NSString stringWithFormat:@"待完成(%ld)",_models.count];

    [TTZUpLoadService sharedTTZUpLoadService].complete = ^(NSString *fileId) {

        //待完成数量变化
        if (_finisnCount < _models.count) {
            _finisnCount += 1;
            _unFinfinshL.text = [NSString stringWithFormat:@"待完成(%ld)",_models.count - _finisnCount];
        } else {
            _unFinfinshL.text = [NSString stringWithFormat:@"上传完成"];
        }

        //图片上传情况
        [_models enumerateObjectsUsingBlock:^(TTZDBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.fileId isEqualToString:fileId]) {
                obj.isUpLoad = NO;
                [_collectionView reloadData];
            }
        }];
    };
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHUploadingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHUploadingCell" forIndexPath:indexPath];
    cell.bigImageView.image = _models[indexPath.row].image;
    cell.smallImageView.image = _models[indexPath.row].isUpLoad ? [UIImage imageNamed:@"icon_Uploading"] :[UIImage imageNamed:@"icon_Finished"];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
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

- (IBAction)networkSwitching:(UISwitch *)sender
{
    if (sender.on == YES) {
        TTZUpLoadService.sharedTTZUpLoadService.isAllowWWAN = YES;
    } else {
        TTZUpLoadService.sharedTTZUpLoadService.isAllowWWAN = NO;
    }
}

@end
