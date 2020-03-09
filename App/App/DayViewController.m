//
//  DayViewController.m
//  App
//
//  Created by Jay on 12/9/2019.
//  Copyright © 2019 tianfutaijiu. All rights reserved.
//

#import "DayViewController.h"
#import "FQQRequest.h"
#import "UIView+Loading.h"

#import "MonitorViewController.h"

@interface DayViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data=@[@"0",@"1",@"2"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *obj = self.data[indexPath.row];
    cell.textLabel.text = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view showLoading:nil];

    
    [[FQQRequest share] requestDataPath:@"http://129.204.117.172/api/clist" parameter:@{@"debug":@(99),@"id":self.bid,@"day":self.data[indexPath.row]} success:^(id respones) {
            [self.view hideLoading:nil];

        NSArray * data = respones[@"data"];
        NSMutableDictionary *ll = [NSMutableDictionary dictionary];
        __block NSInteger onC = 0;
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([[obj valueForKey:@"online"] boolValue]){
                onC ++;
            }
        }];
        
        NSMutableDictionary * c0 = @{
               @"x":[NSString stringWithFormat:@"总共"],
               @"on":@(onC),
               @"no":@([data count]-onC),
               @"all":@([data count])
               }.mutableCopy;
        
        [ll setValue:c0 forKey:@"总共"];
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *location = [obj valueForKey:@"location"];
            NSData*jsonData = [location dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *locationObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
            NSMutableDictionary *cl = [ll valueForKey:locationObj.firstObject];
            if (cl) {

                if ([[obj valueForKey:@"online"] boolValue]) {
                    cl[@"on"] = @([cl[@"on"] integerValue]+1);
                }else{
                    cl[@"no"] = @([cl[@"no"] integerValue]+1);
                }
                cl[@"all"] = @([cl[@"all"] integerValue]+1);

                
                
            }else{
                cl = @{
                       @"x":[NSString stringWithFormat:@"%@(%@)",locationObj[7],locationObj.firstObject],
                       @"on":[[obj valueForKey:@"online"] boolValue]? @(1):@(0),
                       @"no":[[obj valueForKey:@"online"] boolValue]? @(0):@(1),
                       @"all":@(1)
                    }.mutableCopy;
                [ll setValue:cl forKey:locationObj.firstObject];
            }
            NSLog(@"%s", __func__);
        }];
        
            MonitorViewController *vc = [MonitorViewController new];
            vc.obj = ll;
            [self.navigationController pushViewController:vc animated:YES];

            NSLog(@"%s", __func__);
        } error:^(NSError *error) {
            [self.view hideLoading:nil];
        }];
    
}


@end
