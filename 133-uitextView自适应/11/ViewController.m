//
//  ViewController.m
//  VirtualButtonDemo
//
//  Created by zhang on 2018/2/1.
//  Copyright © 2018年 QQ:1604973856. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell22.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell22" bundle:nil] forCellReuseIdentifier:@"cell2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 3) {
        return  UITableViewAutomaticDimension;
    }
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UITextView *txt = cell.contentView.subviews.firstObject;
    if (indexPath.row == 0) {
             txt.text = @"我来自SB的UILlabel -- 其中placeholder的相关属性（placeholder，字体颜色，字体大小）是通过在另外一个大小相等的UITextView *placeholderView的相关属性实现的，同等大小的_placeholderView可以完美的与之重合，是设置作为设置placeholder的View最好选择。重写公有属性的setter方法，设置_placeholderView的相关属性";
        cell.backgroundColor = [UIColor redColor];
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        UITextView *txt = cell.contentView.subviews.firstObject;
        txt.text = @"我来自SB的UTTextView -- 其中placeholder的相关属性（placeholder，字体颜色，字体大小）是通过在另外一个大小相等的UITextView *placeholderView的相关属性实现的，同等大小的_placeholderView可以完美的与之重合，是设置作为设置placeholder的View最好选择。重写公有属性的setter方法，设置_placeholderView的相关属性";
        cell.backgroundColor = [UIColor lightGrayColor];
    }else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        UITextView *txt = cell.contentView.subviews.firstObject;
        txt.text = @"我来自NIB的UTTextView -- 其中placeholder的相关属性（placeholder，字体颜色，字体大小）是通过在另外一个大小相等的UITextView *placeholderView的相关属性实现的，同等大小的_placeholderView可以完美的与之重合，是设置作为设置placeholder的View最好选择。重写公有属性的setter方法，设置_placeholderView的相关属性";
        cell.backgroundColor = [UIColor lightGrayColor];
    }else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        UITextView *txt = cell.contentView.subviews.firstObject;
        txt.text = @"我来自NIB复制到SB的UTTextView --  其中placeholder的相关属性（placeholder，字体颜色，字体大小）是通过在另外一个大小相等的UITextView *placeholderView的相关属性实现的，同等大小的_placeholderView可以完美的与之重合，是设置作为设置placeholder的View最好选择。重写公有属性的setter方法，设置_placeholderView的相关属性";
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        txt.text = @"其中placeholder的相关属性（placeholder，字体颜色，字体大小）是通过";
    }

    
    return cell;
}
@end
