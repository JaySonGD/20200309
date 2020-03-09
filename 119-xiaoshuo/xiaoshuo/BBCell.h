//
//  BBCell.h
//  xiaoshuo
//
//  Created by Jay on 28/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, copy) NSString *url;
//- (void)startAnimation;
//- (void)endAnimation;
//
@end

NS_ASSUME_NONNULL_END
