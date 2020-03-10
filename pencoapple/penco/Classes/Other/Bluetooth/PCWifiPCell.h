//
//  PCWifiPCell.h
//  penco
//
//  Created by Zhu Wensheng on 2019/6/25.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCWifiPCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *pFT;
- (void)loadData:(NSString*)info;
@end

NS_ASSUME_NONNULL_END
