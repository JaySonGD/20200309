//
//  LogViewController.m
//  App
//
//  Created by Jay on 14/1/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "LogViewController.h"
#import "FQQRequest.h"
#import "UIView+Loading.h"
#import <MJRefresh.h>


@interface LogViewController ()
<UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger p;

@property (nonatomic, strong) NSMutableArray *kdata;
@property (nonatomic, assign) NSInteger kp;

@property (nonatomic, weak) UISearchBar *sear ;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 54;
    self.data = [NSMutableArray array];
    self.kdata = [NSMutableArray array];
    
    UISearchBar *sear = [[UISearchBar alloc] init];
    self.navigationItem.titleView = sear;
    self.sear = sear;
    sear.keyboardType = UIKeyboardTypeWebSearch;
    
    sear.delegate = self;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fectData];
    }];
    
    
    [self.tableView.mj_footer beginRefreshing];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(cate)];
    
    
}


- (void)cate{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"参数异常" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"过于频繁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];

    [vc addAction:[UIAlertAction actionWithTitle:@"同步设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"控制器不存在" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"方法不存在" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"App不存在" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"服务器异常" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];

    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"内购订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sear.text = action.title;
        [self searchBarSearchButtonClicked:self.sear];
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"采集日志" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
          self.sear.text = @"条";
          [self searchBarSearchButtonClicked:self.sear];
      }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"求片日志" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
          self.sear.text = @"</span>";
          [self searchBarSearchButtonClicked:self.sear];
      }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"注册日志" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
          self.sear.text = @".com";
          [self searchBarSearchButtonClicked:self.sear];
      }]];

    
    [vc addAction:[UIAlertAction actionWithTitle:@"cannel" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)fectData{
    
    if (self.sear.text.length) {
        
        [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/logSearch" parameter:@{@"debug":@(99),@"kw":self.sear.text,@"p":@(self.kp)} success:^(id respones) {
            
            NSArray *list = respones[@"data"];
            NSMutableArray *temp = [NSMutableArray array];;
            [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [obj mutableCopy];
                
                NSData *data = [[NSString stringWithFormat:@"◆ %@",obj[@"password"]] dataUsingEncoding:NSUnicodeStringEncoding];
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
                NSAttributedString *time = [[NSAttributedString alloc]initWithData:data
                                                                           options:options
                                                                documentAttributes:nil
                                                                             error:nil];
                
                
                NSData *data1 = [obj[@"username"] dataUsingEncoding:NSUnicodeStringEncoding];
                NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
                NSAttributedString *msg = [[NSAttributedString alloc]initWithData:data1
                                                                           options:options1
                                                                documentAttributes:nil
                                                                             error:nil];

                
                dic[@"time"] = time;
                dic[@"msg"] = msg;

                [temp addObject:dic];
            }];
            [self.kdata addObjectsFromArray:temp];
            [self.tableView reloadData];
            
            if (list.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
                self.kp ++;
            }
            
            ;
        } error:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
        
        return;
    }
    
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/logList" parameter:@{@"debug":@(99),@"p":@(self.p)} success:^(id respones) {
        
        NSArray *list = respones[@"data"];
        NSMutableArray *temp = [NSMutableArray array];;
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [obj mutableCopy];
            
            NSData *data = [[NSString stringWithFormat:@"◆ %@",obj[@"password"]] dataUsingEncoding:NSUnicodeStringEncoding];
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            NSAttributedString *time = [[NSAttributedString alloc]initWithData:data
                                                                       options:options
                                                            documentAttributes:nil
                                                                         error:nil];
            
            
            NSData *data1 = [obj[@"username"] dataUsingEncoding:NSUnicodeStringEncoding];
            NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            NSAttributedString *msg = [[NSAttributedString alloc]initWithData:data1
                                                                       options:options1
                                                            documentAttributes:nil
                                                                         error:nil];

            
            dic[@"time"] = time;
            dic[@"msg"] = msg;

            [temp addObject:dic];
        }];
        [self.data addObjectsFromArray:temp];
        [self.tableView reloadData];
        
        if (list.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            self.p ++;
        }
        
        ;
    } error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                   // called when keyboard search button pressed
{
    
    if (searchBar.text.length < 1) {
        return;
    }
    [searchBar endEditing:YES];
    [self.view showLoading:nil];
    self.kp = 0;
    
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/logSearch" parameter:@{@"debug":@(99),@"kw":searchBar.text,@"p":@(self.kp)} success:^(id respones) {
        
        NSArray *list = respones[@"data"];
        NSMutableArray *temp = [NSMutableArray array];
        self.kdata = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [obj mutableCopy];
            
            NSData *data = [[NSString stringWithFormat:@"◆ %@",obj[@"password"]] dataUsingEncoding:NSUnicodeStringEncoding];
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            NSAttributedString *time = [[NSAttributedString alloc]initWithData:data
                                                                       options:options
                                                            documentAttributes:nil
                                                                         error:nil];
            
            
            NSData *data1 = [obj[@"username"] dataUsingEncoding:NSUnicodeStringEncoding];
            NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            NSAttributedString *msg = [[NSAttributedString alloc]initWithData:data1
                                                                       options:options1
                                                            documentAttributes:nil
                                                                         error:nil];

            
            dic[@"time"] = time;
            dic[@"msg"] = msg;

            [temp addObject:dic];
        }];
        [self.kdata addObjectsFromArray:temp];

        
        
        if (list.count == 20) {
            self.kp ++;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        [self.tableView reloadData];
        [self.view hideLoading:nil];

        NSLog(@"%s", __func__);
    } error:^(NSError *error) {
        [self.view hideLoading:nil];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sear.text.length? self.kdata.count : self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.96 blue:0.97 alpha:1.00];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *obj = self.sear.text.length? self.kdata[indexPath.row] : self.data[indexPath.row];
    
    UILabel *name = cell.textLabel;
    UILabel *table = cell.detailTextLabel;
    
    
    table.attributedText = obj[@"msg"];
    name.attributedText = obj[@"time"];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *obj = self.sear.text.length? self.kdata[indexPath.row] : self.data[indexPath.row];
    
    UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [vc.topViewController setValue:obj forKey:@"obj"];
    [self presentViewController:vc animated:YES completion:nil];
    
}


@end
