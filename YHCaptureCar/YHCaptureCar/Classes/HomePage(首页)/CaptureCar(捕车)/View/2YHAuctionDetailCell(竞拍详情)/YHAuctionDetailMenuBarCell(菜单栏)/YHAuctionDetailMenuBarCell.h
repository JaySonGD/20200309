//
//  YHAuctionDetailMenuBarCell.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/11.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAuctionDetailMenuBarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuBarLabel;
@property (weak, nonatomic) IBOutlet UIView *menuBarView;

@property (nonatomic, assign)BOOL isSelected;

@end
