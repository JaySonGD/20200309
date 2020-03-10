//
//  YHAuctionDetailCell0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHAuctionDetailModel0.h"

@interface YHAuctionDetailCell0 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *defineLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *landmarkImageView;


- (void)refreshUIWithDefineDataArray:(NSArray *)defineDataArray WithValueArray:(NSMutableArray *)valueArray WithRow:(NSInteger)row;

@end
