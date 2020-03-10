//
//  YHExtrendBackSearchController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/19.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendBackSearchController.h"
#import "YHExtrendBackListController.h"
#import "YHNetworkPHPManager.h"
#import "YHCommon.h"
#import "YHTools.h"

#import "YHPlanCell.h"
NSString *const notificationBackSearch = @"YHNotificationBackSearch";
@interface YHExtrendBackSearchController ()
@property (weak, nonatomic) IBOutlet UIButton *planB1;
@property (weak, nonatomic) IBOutlet UIButton *planB2;
@property (weak, nonatomic) IBOutlet UIButton *planB3;
@property (weak, nonatomic) IBOutlet UIButton *planB4;
@property (weak, nonatomic) IBOutlet UIButton *stateBUn;
@property (weak, nonatomic) IBOutlet UIButton *stateBPart;
@property (weak, nonatomic) IBOutlet UIButton *stateBAll;
- (IBAction)stateActions:(id)sender;
- (IBAction)planActions:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)comfirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchFT;
@property (nonatomic)NSInteger backModelState;
@property (nonatomic)NSInteger planModel;
@property (strong, nonatomic)NSArray *dataSource;
@end

@implementation YHExtrendBackSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backModelState = -1;
    _planModel = -1;
    _planB1.layer.borderWidth  = 1;
    _planB1.layer.borderColor  = YHCellColor.CGColor;
    
    _planB2.layer.borderWidth  = 1;
    _planB2.layer.borderColor  = YHCellColor.CGColor;
    
    _planB3.layer.borderWidth  = 1;
    _planB3.layer.borderColor  = YHCellColor.CGColor;
    
    _planB4.layer.borderWidth  = 1;
    _planB4.layer.borderColor  = YHCellColor.CGColor;
    
    
    _stateBUn.layer.borderWidth  = 1;
    _stateBUn.layer.borderColor  = YHCellColor.CGColor;
    
    _stateBPart.layer.borderWidth  = 1;
    _stateBPart.layer.borderColor  = YHCellColor.CGColor;
    
    _stateBAll.layer.borderWidth  = 1;
    _stateBAll.layer.borderColor  = YHCellColor.CGColor;
    [self reupdataDatasource];
}


- (void)reupdataDatasource{
    self.dataSource = nil;
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getWarrantyNames:[YHTools getAccessToken]
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             weakSelf.dataSource = info[@"data"];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 [weakSelf showErrorInfo:info];
             }
         }
         [weakSelf.collectionView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stateActions:(UIButton*)button {
    _backModelState = button.tag;
    [@[_stateBUn, _stateBPart, _stateBAll] enumerateObjectsUsingBlock:^(UIButton *bu, NSUInteger idx, BOOL * _Nonnull stop) {
        [bu setTitleColor:YHCellColor forState:UIControlStateNormal];
        [bu setBackgroundColor:[UIColor whiteColor]];
    }];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:YHNaviColor];
}

- (IBAction)planActions:(UIButton*)button {
    _planModel = button.tag;
    [@[_planB1, _planB2, _planB3, _planB4] enumerateObjectsUsingBlock:^(UIButton *bu, NSUInteger idx, BOOL * _Nonnull stop) {
        [bu setTitleColor:YHCellColor forState:UIControlStateNormal];
        [bu setBackgroundColor:[UIColor whiteColor]];
    }];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:YHNaviColor];
}

- (IBAction)comfirmAction:(id)sender {
    [[self view] endEditing:YES];
    NSMutableDictionary *keys = [@{}mutableCopy];
    if (_backModelState != -1) {
        [keys setObject:@(_backModelState) forKey:@"state"];
    }
    if (_planModel != -1) {
        [keys setObject:_dataSource[_planModel] forKey:@"plan"];
    }
    if (![_searchFT.text isEqualToString:@""] && _searchFT.text) {
        [keys setObject:_searchFT.text forKey:@"key"];
    }
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationBackSearch
     object:Nil
     userInfo:keys];
    [self popViewController:nil];
}


#pragma mark - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return _dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        YHPlanCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_dataSource[indexPath.row] isSel:indexPath.row == _planModel];
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _planModel = indexPath.row;
    [collectionView reloadData];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = _dataSource[indexPath.row];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(10000, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return CGSizeMake(20 + size.width, 40);
}

@end
