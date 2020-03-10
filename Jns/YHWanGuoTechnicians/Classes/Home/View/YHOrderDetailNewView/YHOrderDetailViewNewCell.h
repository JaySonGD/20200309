//
//  ViewController.h
//  tableView之cell缩放
//
//  Created by imac on 16/9/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHOrderDetailViewNewCell : UITableViewCell

@property(nonatomic,copy) void (^click)(CGFloat h);
@property (nonatomic,strong) NSArray *dataArr;

@end

