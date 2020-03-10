//
//  YHFunctionsEditerController.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHFunctionsEditerController.h"
#import "YHTools.h"
#import "YHFunctionEditerCell.h"
#import "YHCommon.h"
NSString *const notificationFunctionDel = @"YHNotificationFunctionDel";
NSString *const notificationFunctionAdd = @"YHNotificationFunctionAdd";
@interface YHFunctionsEditerController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *editerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeFunctionHLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherFunctionHLC;

@property (weak, nonatomic) IBOutlet UICollectionView *homeC;
@property (weak, nonatomic) IBOutlet UICollectionView *otherC;
@property (strong, nonatomic)NSMutableArray *homeFunctions;
@property (strong, nonatomic)NSMutableArray *otherFunctions;
- (IBAction)editerAction:(id)sender;
@property (nonatomic)BOOL isEditer;
@end

@implementation YHFunctionsEditerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(functionActionDel:) name:notificationFunctionDel object:nil];
    [center addObserver:self selector:@selector(functionActionAdd:) name:notificationFunctionAdd object:nil];
    
    [self reFlashhotherFunctions];
    [self updataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)functionActionDel:(NSNotification*)obj{
    NSMutableArray *homeFunctions = [[YHTools getFunctions] mutableCopy];
    NSNumber *functionK = obj.object;
    [homeFunctions removeObject:functionK];
    [YHTools setFunctions:homeFunctions];
    
    [self reFlashhotherFunctions];
    [self updataView];
}

- (void)functionActionAdd:(NSNotification*)obj{
    
    NSMutableArray *homeFunctions = [[YHTools getFunctions] mutableCopy];
    NSNumber *functionK = obj.object;
    [homeFunctions insertObject:functionK atIndex:0];
    [YHTools setFunctions:homeFunctions];
    
    [self reFlashhotherFunctions];
    [self updataView];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updataView{
    
    
    NSUInteger homeCount = [self homeFunctions].count;
    NSUInteger otherCount = [self otherFunctions].count;
    NSUInteger lCount = screenWidth / (75 + 20);
    
    _homeFunctionHLC.constant = (75 * (((homeCount % lCount)? (1) : (0)) + homeCount / lCount) + 20);
    _otherFunctionHLC.constant = (75 * (((otherCount % lCount)? (1) : (0)) + otherCount / lCount) + 20);
    [_homeC reloadData];
    [_otherC reloadData];
}

- (NSArray*)reFlashhotherFunctions{
    self. homeFunctions = [[YHTools getFunctions] mutableCopy];
    [_homeFunctions removeLastObject];
    
    self.otherFunctions = [@[]mutableCopy];
    for (int i = 0; i < YHFunctionIdAll; i++) {
        [_otherFunctions addObject:[NSNumber numberWithInt:i]];
    }
    [_otherFunctions removeObjectsInArray:_homeFunctions];
    return _otherFunctions;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _homeC) {
        return _homeFunctions.count;
    }else{
        return _otherFunctions.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHFunctionEditerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *datasources;
    if (collectionView == _homeC) {
        datasources = _homeFunctions;
    }else{
        datasources = _otherFunctions;
    }
    [cell loadDatasource:datasources[indexPath.row] isEditer:_isEditer isHome:(collectionView == _homeC)];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)editerAction:(UIButton*)sender {
    
    self.isEditer = !_isEditer;
    
    sender.titleLabel.text = ((_isEditer)? (@"完成") : (@"管理"));
    [sender setTitle:((_isEditer)? (@"完成") : (@"管理")) forState:UIControlStateNormal];
    [self updataView];
}


@end
