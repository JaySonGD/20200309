//
//  PCMsgCell.h
//  penco
//
//  Created by Jay on 28/9/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCMsgCell : UITableViewCell
/** <##> */
@property (nonatomic, strong) NSMutableDictionary *obj;

/** <##> */
@property (nonatomic, copy) dispatch_block_t reloadBlock;
@end

NS_ASSUME_NONNULL_END
