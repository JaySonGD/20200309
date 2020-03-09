//
//  ListViewController.m
//  App
//
//  Created by Jay on 21/2/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *list = [[[NSUserDefaults standardUserDefaults] objectForKey:@"list"] mutableCopy];
          if (!list) {
              list = [NSMutableArray array];
          }
    
    self.navigationItem.title = @"书签列表";
    self.list = list;
    
    self.tableView.tableFooterView = [UIView new];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *obj = self.list[indexPath.row];
    cell.detailTextLabel.text = obj[@"url"];
    cell.textLabel.text = obj[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *obj = self.list[indexPath.row];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SHViewController"];

    [vc setValue:obj[@"url"] forKey:@"url"];
    [self.navigationController pushViewController:vc animated:YES];

    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.list[indexPath.row];
    [self.list removeObject:obj];
    [[NSUserDefaults standardUserDefaults] setValue:self.list forKey:@"list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end
