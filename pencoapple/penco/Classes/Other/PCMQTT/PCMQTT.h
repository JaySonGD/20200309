//
//  PCMQTT.h
//  penco
//
//  Created by Jay on 13/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface PCMQTT : NSObject
DEFINE_SINGLETON_FOR_HEADER(PCMQTT);

// default YES
@property (nonatomic, assign) BOOL autoConnect;

- (void)subscribe:(NSString*)topic;

-(void)unsubscribe:(NSString*)topic;

- (UInt16)sendMessage:(NSDictionary *)msg;

-(void)exit;

@end

NS_ASSUME_NONNULL_END
