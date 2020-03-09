//
//  ViewController2.m
//  xiaoshuo
//
//  Created by Jay on 28/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

//  ViewController.m
//  xiaoshuo
//
//  Created by Jay on 26/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height

#define iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 刘海系列
#define  iPhoneX ((kStatusBarHeight > 20) ? YES : NO)

// 状态栏高度
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度（不包括状态栏）
//#define  kNavigationBarHeight  44.f
#define  kNavigationBarHeight(vc)  ((vc.navigationController)? vc.navigationController.navigationBar.bounds.size.height: (iPad? (iPhoneX? 50.f : 44.f) : 44.f))


// 选项卡高度
//#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
#define  kTabbarHeight(vc) ((vc.tabBarController)? vc.tabBarController.tabBar.bounds.size.height:(49.f+kTabbarSafeBottomMargin))

// Tabbar safe bottom margin.
//#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
#define  kTabbarSafeBottomMargin   ((kViewSafeAreInsets([UIApplication sharedApplication].keyWindow)).bottom)


// Status bar & navigation bar height.
//#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
#define kStatusBarAndNavigationBarHeight(vc) (kNavigationBarHeight(vc) + kStatusBarHeight)


#define kViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

//////////////////////////////////////////
//#define kCommonColor  kRGBColor(36, 130, 93)//41 196 64
#define kCommonColor  kColorWithHexString(0x0A951F)//41 196 64

#define kBackgroundColor  kRGBColor(236, 237, 238)

#define kRandomColor kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kColorWithHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]


///////////////////
/*
 T1导航栏 : 18pt
 列表/表单/标签/按钮 : 16pt
 正文: 14pt
 标题左右栏: 12pt
 T5说明文: 10pt
 */

#define  kNavigationBarTitleFont   [UIFont boldSystemFontOfSize:18.0]
#define  kLeftRightItemTitleFont   [UIFont systemFontOfSize:12.0]

#define  kTableTitleFont   [UIFont boldSystemFontOfSize:16.0]
#define  kMainBodyTitleFont   [UIFont systemFontOfSize:14.0]
#define  kDescribeTitleFont   [UIFont systemFontOfSize:10.0]


//View圆角和加边框

#define kViewBorderRadius(View,Radius,Width,Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角

#define kViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


#import "BBCell.h"
#import <FLAnimatedImageView+WebCache.h>


#import "ViewController2.h"

@interface ViewController2 ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController2



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.collectionView reload];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uodate" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSMutableArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:@"list"].mutableCopy;
        
        if (!list) {
            list = [NSMutableArray array];
        }
        
        self.datas = list;
        [self.collectionView reloadData];

    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:@"list"].mutableCopy;
    
    if (!list) {
        list = [NSMutableArray array];
    }
    
    self.datas = list;
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 3;
        
        layout.minimumLineSpacing = 3;
        
        layout.itemSize = CGSizeMake((kScreenW - 12) / 3.0,(kScreenW - 12) / 3.0*1.3);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        _collectionView.contentInset = UIEdgeInsetsMake(3, 3, 3, 3);
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.backgroundColor = kBackgroundColor;
        
        [self.view addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"BBCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return _collectionView;
}

//FIXME:  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *obj = self.datas[indexPath.item];
    
    NSString *file = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
    NSURL *item = [NSURL fileURLWithPath:file];
    
    UIActivityViewController * activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[item] applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *obj = self.datas[indexPath.item];

    BBCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    FLAnimatedImageView *v = (FLAnimatedImageView *)cell.imageView;
    [v sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil];
    cell.url = obj;
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

@end
