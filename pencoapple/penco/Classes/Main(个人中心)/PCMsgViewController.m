//
//  PCMsgViewController.m
//  penco
//
//  Created by Jay on 28/9/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCMsgViewController.h"
#import "PCMsgCell.h"

@interface PCMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSMutableDictionary *> *data;
@end

@implementation PCMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = @[
                  @{@"title":@"223",@"des":@"有时希望在cell的上面放置一些按钮之类的空间,又想让这些空间跟着cell一起"}.mutableCopy,
                  @{@"title":@"223",@"des":@"有时希望在cell的上面放置一些按钮之类的空间,又想让这些空间跟着cell一起有时希望在cell的上面放置一些按钮之类的空间,又想让这些空间跟着cell一起",@"more":@(1)}.mutableCopy,
                  @{@"title":@"223",@"des":@"有时希望在cell一起"}.mutableCopy,
                  @{@"title":@"223",@"des":@"有时希望在cell的上面放置一些按钮之类的空间,又想让这些空间跟着cell一起"}.mutableCopy,
                  ];
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:12];
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 36;
    
    [self.data enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lb.text = obj[@"des"];
        [lb sizeToFit];
        CGFloat w = [lb intrinsicContentSize].width;
        if(w>maxW) obj[@"more"] = @(1);
    }];
    

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *obj = self.data[indexPath.row];
    PCMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.obj = obj;
    cell.reloadBlock = ^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

@end
