//
//  GTLGradientView.m
//  GTLCalendar
//
//  Created by daisuke on 2017/5/26.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "GTLGradientView.h"

#define squashColor [UIColor colorWithRed:195/255.0 green:230/255.0 blue:254/255.0 alpha:1.0]
#define dustyOrangeColor [UIColor colorWithRed:195/255.0 green:230/255.0 blue:254/255.0 alpha:1.0]

@interface GTLGradientView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation GTLGradientView

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
    // 漸層
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0, .5);      // 水平漸層
    self.gradientLayer.endPoint = CGPointMake(1, .5);        // 水平漸層
    self.gradientLayer.colors = @[(id)squashColor.CGColor, (id)dustyOrangeColor.CGColor];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

#pragma mark * override

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

@end
