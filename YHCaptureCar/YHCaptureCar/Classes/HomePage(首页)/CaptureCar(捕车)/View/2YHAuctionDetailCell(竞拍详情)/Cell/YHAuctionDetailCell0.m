//
//  YHAuctionDetailCell0.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionDetailCell0.h"
#import "YHCommon.h"

@implementation YHAuctionDetailCell0

- (void)refreshUIWithDefineDataArray:(NSArray *)defineDataArray WithValueArray:(NSMutableArray *)valueArray WithRow:(NSInteger)row
{
    self.defineLabel.text = defineDataArray[row];
    self.valueLabel.text = valueArray[row];
}

@end
