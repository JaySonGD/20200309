//
//  PCPreviewCell.h
//  penco
//
//  Created by Jay on 26/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCPreviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *valueLB;
@property (weak, nonatomic) IBOutlet UILabel *changeLB;

@end

NS_ASSUME_NONNULL_END
