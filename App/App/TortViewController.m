//
//  TortViewController.m
//  App
//
//  Created by Jay on 13/1/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "TortViewController.h"
#import "FQQRequest.h"
#import "UIView+Loading.h"

@interface TortViewController ()<UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation TortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];

    self.navigationItem.prompt = @"";

    
    UISearchBar *sear = [[UISearchBar alloc] init];
    self.navigationItem.titleView = sear;
    
    sear.keyboardType = UIKeyboardTypeWebSearch;
    
    sear.delegate = self;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                   // called when keyboard search button pressed
{
    if (searchBar.text.length < 1) {
        return;
    }
    [searchBar endEditing:YES];
    [self.view showLoading:nil];//@"http://129.204.117.172/api/tortSearch"
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/tortSearch" parameter:@{@"debug":@(99),@"kw":searchBar.text} success:^(id respones) {
        
        self.data = respones[@"data"];
        NSMutableArray *list = [NSMutableArray array];
        [self.data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [list addObject:[obj mutableCopy]];
        }];
        
        self.data = list;
        
        self.navigationItem.prompt = [NSString stringWithFormat:@"有%lu条与\"%@\"相关",(unsigned long)list.count,searchBar.text];
        
        [self.tableView reloadData];
        
        [self.view hideLoading:nil];
        
        NSLog(@"%s", __func__);
    } error:^(NSError *error) {
        [self.view hideLoading:nil];
    }];
    
    
    
}

- (void)dd:(UISwitch *)sw{
    NSMutableDictionary *obj = self.data[sw.tag];
    sw.userInteractionEnabled = NO;
    [self.view showLoading:nil];

    id vod_tort = @(![obj[@"vod_tort"] boolValue]);
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/tort" parameter:@{@"debug":@(99),@"table": obj[@"table"],@"vod_tort":vod_tort,@"vod_id":obj[@"vod_id"]} success:^(id respones) {
        
        obj[@"vod_tort"] = vod_tort;
        [self.tableView reloadData];
        sw.userInteractionEnabled = YES;
        [self.view hideLoading:nil];
    } error:^(NSError *error) {
        [self.tableView reloadData];
        sw.userInteractionEnabled = YES;
        [self.view hideLoading:nil];

    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *obj = self.data[indexPath.row];
    
    UILabel *name =  cell.contentView.subviews[0];
    UILabel *table =  cell.contentView.subviews[1];
    UILabel *type =  cell.contentView.subviews[2];
    UISwitch *mactive =  cell.contentView.subviews[3];
    mactive.tag = indexPath.row;
    
    UILabel *vod_play_from =  cell.contentView.subviews[4];
    UILabel *vod_time =  cell.contentView.subviews[5];
    UILabel *vod_remarks = cell.contentView.subviews[6];
    
    name.text = [NSString stringWithFormat:@"【%@】",obj[@"vod_name"]];
    table.text = obj[@"table"];
    type.text =  obj[@"type_name"];
    
    vod_play_from.text = obj[@"vod_play_from"];
    vod_time.text =  obj[@"vod_time"];
    vod_remarks.text =  obj[@"vod_remarks"];

    mactive.on = [obj[@"vod_tort"] boolValue];
    
    [mactive addTarget:self action:@selector(dd:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view showLoading:nil];

    NSDictionary *obj = self.data[indexPath.row];
    
    NSString *table = [obj[@"table"] stringByReplacingOccurrencesOfString:@"vod" withString:@"video"];

    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/detail" parameter:@{@"debug":@(99),@"table":table ,@"vod_id":obj[@"vod_id"]} success:^(id respones) {
        
        UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoViewController"];
        
        //NSDictionary *obj = respones[@"data"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:respones options:NSJSONWritingPrettyPrinted error:NULL];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];

        json = [NSString stringWithFormat:@"<pre>%@</pre>",json];

                    
        [vc.topViewController setValue:@{@"username":json} forKey:@"obj"];
        [self presentViewController:vc animated:YES completion:nil];

        [self.view hideLoading:nil];
    } error:^(NSError *error) {
        [self.view hideLoading:nil];
    }];
    
    
}

@end
