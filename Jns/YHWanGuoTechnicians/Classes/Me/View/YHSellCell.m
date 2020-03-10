//
//  YHSellCell.m
//  YHMaFuBang
//
//  Created by Zhu Wensheng on 16/12/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHSellCell.h"
//#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"
#import "YHNetworkPHPManager.h"
#import "AppDelegate.h"
#import "YHTools.h"
@interface YHSellCell ()
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@end

@implementation YHSellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadInfo:(NSDictionary*)info{
    [_imageCollection reloadData];
}

@end
