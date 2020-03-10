//
//  PCWifiCell.h
//  penco
//
//  Created by Zhu Wensheng on 2019/8/12.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCWifiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ssidL;

-(void)ssid:(NSNumber*)ssid;
@end

NS_ASSUME_NONNULL_END
