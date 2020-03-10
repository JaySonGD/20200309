//
//  resultCell.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/9/9.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *resultTv;

@property (nonatomic,copy)NSString *resultStr;

@end

NS_ASSUME_NONNULL_END
