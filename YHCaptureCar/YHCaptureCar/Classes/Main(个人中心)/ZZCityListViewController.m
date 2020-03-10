//
//  ZZCityListViewController.m
//  YHCaptureCar
//
//  Created by Jay on 14/11/2018.
//  Copyright © 2018 YH. All rights reserved.
//

#import "ZZCityListViewController.h"



#import <MapKit/MapKit.h>

#import "YHHelpSellService.h"
#import "UIView+Layout.h"
#import "MBProgressHUD+MJ.h"
#import "UIAlertController+Blocks.h"

#import "ZZCityModel.h"

@interface ZZCityListViewController ()
<CLLocationManagerDelegate,UITableViewDataSource,
UITableViewDelegate,UISearchBarDelegate>

@property (strong,nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *curCityLB;
@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) ZZCity *dataModel;

@property (nonatomic, strong) NSArray <ZZCityModel *>*results;

@property (nonatomic, strong) UILabel *noMoreCityLb;
@end

@implementation ZZCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadData];
    [self startLocation];
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择城市";
}

- (void)createTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    

}

- (void)loadData{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService findCityListOnComplete:^(ZZCity *city) {
        [MBProgressHUD hideHUDForView:self.view];
        self.dataModel = city;
        [self createTableView];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}

//开始定位

-(void)startLocation{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //定位不能用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIAlertController showAlertInViewController:self withTitle:@"打开“定位服务”来允许“捕车”确定你的位置" message:@"捕车需要使用您的位置来为你提供服务" cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@[@"设置"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.cancelButtonIndex) return;
                
                NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                
                if( [[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }

            }];
        });
    }

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
//    self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:break;
            
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
     __weak typeof(self) weakSelf = self;
    CLLocation *newLocation = locations.firstObject;
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            [weakSelf.curCityLB setTitle:placemarks.firstObject.locality forState:UIControlStateNormal];
            weakSelf.curCityLB.enabled = YES;
        }else{
            [weakSelf.curCityLB setTitle:@"定位失败" forState:UIControlStateDisabled];
        }
//        for (CLPlacemark *place in placemarks) {
//            NSLog(@"name,%@",place.name);                      // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
//            NSLog(@"locality,%@",place.locality);              // 市
//            NSLog(@"subLocality,%@",place.subLocality);        // 区
//            NSLog(@"country,%@",place.country);                // 国家
//        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.searchBar.text.length) {
        tableView.sectionHeaderHeight = 0;
        tableView.tableHeaderView.height = 52;
        return 1;
    }
    
    tableView.sectionHeaderHeight = 36;

    NSInteger count = ceil(self.dataModel.hotCityList.count / 4);
    CGFloat hoth = count * 44 + (count-1)*10;
    tableView.tableHeaderView.height = 134+hoth;

    return  self.dataModel.regionList.count;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.searchBar.text.length) {
        return nil;
    }
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    sectionView.backgroundColor = YHBackgroundColor;
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 36)];
    [sectionView addSubview:titleLB];
    titleLB.text = self.dataModel.regionList[section].initial;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchBar.text.length? self.results.count: self.dataModel.regionList[section].cityList.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.searchBar.text.length? nil : [self.dataModel.regionList valueForKey:@"initial"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.searchBar.text.length? self.results[indexPath.row].regionName : self.dataModel.regionList[indexPath.section].cityList[indexPath.row].regionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self popViewController:nil];

    ZZCityModel *city = self.searchBar.text.length? self.results[indexPath.row] : self.dataModel.regionList[indexPath.section].cityList[indexPath.row];
    
    
    if (IsEmptyStr(city.Id)) {
        [MBProgressHUD showError:@"城市id不能为空"];
        return;
    }
    
    !(_selectCityBlock)? : _selectCityBlock(city);
    

}


//区头的字体颜色设置

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    //header.textLabel.textColor = [UIColor redColor];
//    header.contentView.backgroundColor = YHBackgroundColor;
//}

//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    //[self.view endEditing:YES];
    //NSString *string = self.indexArr[index];
    //[self showCenterIndexShowView:string];
    return index;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{

    //模糊查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionName CONTAINS %@", searchBar.text]; //
    NSMutableArray *temps  = [NSMutableArray array];
    [self.dataModel.regionList enumerateObjectsUsingBlock:^(ZZCityRegionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temps addObjectsFromArray:obj.cityList];
    }];
    
    NSArray <ZZCityModel *>*results = [temps filteredArrayUsingPredicate:predicate];    self.results = results;
    
    self.tableView.tableFooterView = results.count? [UIView new] : self.noMoreCityLb;

    [self.tableView reloadData];
    NSLog(@"%s--%@", __func__,results);
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //模糊查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionName CONTAINS %@", searchBar.text]; //
    NSMutableArray *temps  = [NSMutableArray array];
    [self.dataModel.regionList enumerateObjectsUsingBlock:^(ZZCityRegionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temps addObjectsFromArray:obj.cityList];
    }];
    
    NSArray <ZZCityModel *>*results = [temps filteredArrayUsingPredicate:predicate];
    self.results = results;
    self.tableView.tableFooterView = results.count? [UIView new] : self.noMoreCityLb;

    [self.tableView reloadData];
    NSLog(@"%s--%@", __func__,results);
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        _tableView.sectionHeaderHeight = 36;
        _tableView.sectionIndexColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.00];
        _tableView.sectionIndexTrackingBackgroundColor = YHNaviColor;

        _tableView.backgroundColor = YHBackgroundColor;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UILabel *)noMoreCityLb{
    if (!_noMoreCityLb) {
        _noMoreCityLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _noMoreCityLb.text = @"抱歉,暂时没有找到相关城市";
        _noMoreCityLb.textAlignment = NSTextAlignmentCenter;
    }
    return _noMoreCityLb;
}

- (UIButton *)curCityLB{
    if (!_curCityLB) {
        _curCityLB = [UIButton new];
       NSString *title =  ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)? @"定位服务不可用" : @"定位中...";
        [_curCityLB setTitle:title forState:UIControlStateDisabled];
        _curCityLB.enabled = NO;
        [_curCityLB setTitleColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.00] forState:UIControlStateNormal];
        [_curCityLB addTarget:self action:@selector(hotCityClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _curCityLB;
}

- (UIView *)headerView{
    if (!_headerView) {
//        44 + 10
        //NSInteger count = ceil(self.dataModel.hotCityList.count / 4);
        //CGFloat hoth = count * 44 + (count-1)*10;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];//134+hoth
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UISearchBar *search = [[UISearchBar alloc] init];
        search.backgroundColor = YHBackgroundColor;
        search.delegate = self;
        search.returnKeyType = UIReturnKeySearch;
        search.placeholder = @"请输入城市";
        [_headerView addSubview:search];
        _searchBar = search;
        search.frame = CGRectMake(0, 0, kScreenWidth, 52);
//        [search mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.mas_equalTo(_headerView);
//            make.height.mas_equalTo(52);
//        }];
        
        
        UIView *curView = [[UIView alloc] init];
        curView.clipsToBounds = YES;
        curView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:curView];
//        [curView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(search.mas_bottom);
//            make.left.right.mas_equalTo(_headerView);
//            make.height.mas_equalTo(36);
//        }];
        curView.frame = CGRectMake(0, 52, kScreenWidth, 36);

        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = YHBackgroundColor;
        [curView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(curView);
            make.height.mas_equalTo(0.5);
        }];

        
        UILabel *curCityTitleLB = [UILabel new];
        curCityTitleLB.text = @"当前城市";
        curCityTitleLB.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
        [curView addSubview:curCityTitleLB];
        [curCityTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(curView);
            make.left.mas_equalTo(curView.mas_left).offset(20);
            make.bottom.mas_equalTo(line.mas_top);
        }];

        
        [curView addSubview:self.curCityLB];
        [_curCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(curView);
            make.left.mas_equalTo(curCityTitleLB.mas_right).offset(10);
            make.bottom.mas_equalTo(line.mas_top);
        }];

        
        UILabel *hotCityTitleLB = [UILabel new];
        hotCityTitleLB.text = @"热门城市";
        hotCityTitleLB.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
        [_headerView addSubview:hotCityTitleLB];
//        [hotCityTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(line.mas_bottom);
//            make.left.mas_equalTo(_headerView.mas_left).offset(20);
//            make.height.mas_equalTo(36);
//        }];
        hotCityTitleLB.frame = CGRectMake(20, 88, 100, 36);

        
        UIView *hotCityView = [UIView new];
        hotCityView.clipsToBounds = YES;
        [_headerView addSubview:hotCityView];
        [hotCityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hotCityTitleLB.mas_bottom);
            make.left.mas_equalTo(_headerView.mas_left).offset(20);
            make.right.mas_equalTo(_headerView.mas_right).offset(-36);
            make.bottom.mas_equalTo(_headerView.mas_bottom).offset(-10);
        }];

        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat h = 44;
        CGFloat w = (screenWidth - 86) * 0.25;
        for (NSInteger i = 0; i < self.dataModel.hotCityList.count; i ++) {
            ZZCityModel *m = self.dataModel.hotCityList[i];
            //0 1 2 3
            //4
            CGFloat  section = i/4;
            CGFloat  row = i%4;
            
            y = section * (h + 10);
            x = row * (w + 10);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(x, y, w, h);
            [btn setTitle:m.regionName forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.00] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(hotCityClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
            [hotCityView addSubview:btn];
        }
        
        _headerView.clipsToBounds = YES;
    }
    
    return _headerView;
}

- (void)hotCityClick:(UIButton *)sender{
    if (sender == self.curCityLB) {
        
        //模糊查询
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionName = %@", [sender titleForState:UIControlStateNormal]]; //
        NSMutableArray *temps  = [NSMutableArray array];
        [self.dataModel.regionList enumerateObjectsUsingBlock:^(ZZCityRegionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temps addObjectsFromArray:obj.cityList];
        }];
        
        ZZCityModel *city = [temps filteredArrayUsingPredicate:predicate].firstObject;
        if (IsEmptyStr(city.Id)) {
            [MBProgressHUD showError:@"城市id不能为空"];
            return;
        }
        !(_selectCityBlock)? : _selectCityBlock(city);
        return;
    }
    if (IsEmptyStr(self.dataModel.hotCityList[sender.tag].Id)) {
        [MBProgressHUD showError:@"城市id不能为空"];
        return;
    }
    !(_selectCityBlock)? : _selectCityBlock(self.dataModel.hotCityList[sender.tag]);
    [self popViewController:nil];
}

- (void)dealloc{
    
}
@end
