//
//  ViewController.m
//  App
//
//  Created by Jay on 12/9/2019.
//  Copyright © 2019 tianfutaijiu. All rights reserved.
//

#import "ViewController.h"
#import "FQQRequest.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <##> */
@property (nonatomic, strong) NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAppList];
    
    self.navigationItem.title = @"应用列表";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"log" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"log" style:UIBarButtonItemStylePlain target:self action:@selector(share)],[[UIBarButtonItem alloc] initWithTitle:@"cj" style:UIBarButtonItemStylePlain target:self action:@selector(cj)]];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"tort" style:UIBarButtonItemStylePlain target:self action:@selector(d)];

    
}

- (IBAction)cj{
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CJViewController"];
     
     [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)d{
    
    
    
   UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TortViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)share{
//
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];

    return;
    NSURL *url = [NSURL URLWithString:@"https://apps.apple.com/cn/app/id1483779156"];
//        NSURL *url = [NSURL URLWithString:@"https://apps.apple.com/cn/app/%E6%B3%B0%E5%89%A7tv-%E6%B3%B0%E5%89%A7%E5%BD%B1%E8%A7%86%E5%A4%A7%E5%85%A8/id1483779156"];

    UIActivityViewController * activityCtl = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
    
    [self  presentViewController:activityCtl animated:YES completion:nil];

}

- (void)getAppList{
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/alist" parameter:@{@"debug":@(99)} success:^(id respones) {
        
        self.data = respones[@"data"];
        [self.tableView reloadData];
        
        NSLog(@"%s", __func__);
    } error:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *obj = self.data[indexPath.row];
    
    UILabel *app_name =  cell.contentView.subviews[0];
    UILabel *bundle_id =  cell.contentView.subviews[1];
    UILabel *active =  cell.contentView.subviews[2];
    UILabel *mactive =  cell.contentView.subviews[3];
    UILabel *count =  cell.contentView.subviews[4];
    UILabel *abnormal =  cell.contentView.subviews[5];
    
    
    app_name.text = [NSString stringWithFormat:@"【%@】",obj[@"app_name"]];
    bundle_id.text = obj[@"bundle_id"];
    active.text = [NSString stringWithFormat:@"日活：%@",obj[@"active"]];
    mactive.text = [NSString stringWithFormat:@"月活：%@",obj[@"mactive"]];

    count.text = [NSString stringWithFormat:@"上线(总共/当日)：%@ / %@",obj[@"count"],obj[@"count_day"]];
    abnormal.text = [NSString stringWithFormat:@"审核(总共/当日)：%@ / %@",obj[@"abnormal"],obj[@"abnormal_day"]];

    
    UISwitch *online = cell.contentView.subviews[10];
    UISwitch *alluse = cell.contentView.subviews[11];
    UISwitch *cn_can_use = cell.contentView.subviews[12];
    UISwitch *show = cell.contentView.subviews[13];
    
    online.on = [obj[@"online"] boolValue];
    alluse.on = [obj[@"alluse"] boolValue];
    cn_can_use.on = [obj[@"cn_can_use"] boolValue];
    show.on = [obj[@"show"] boolValue];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DayViewController"];
    [vc setValue:self.data[indexPath.row][@"bundle_id"] forKey:@"bid"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
