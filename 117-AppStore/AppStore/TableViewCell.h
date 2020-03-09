//
//  TableViewCell.h
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv;
- (void)startAnimation;
- (void)endAnimation;
@end

NS_ASSUME_NONNULL_END
