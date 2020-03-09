//
//  ViewController22.m
//  pageVC
//
//  Created by Jay on 16/5/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController22.h"

@interface ViewController22 ()

@end

@implementation ViewController22

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s------%@", __func__,self.title);
    
    
    UITableView  *tb = [[UITableView alloc] init];
    tb.dataSource = self;
    [self.view addSubview:tb];
    
    tb.frame = CGRectMake(0, 88, self.view.bounds.size.width,  self.view.bounds.size.height - 88 - 83);
    
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //tb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%@",indexPath.row,self.title];
    
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s------%@", __func__,self.title);

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
