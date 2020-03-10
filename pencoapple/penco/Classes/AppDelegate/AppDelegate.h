//
//  AppDelegate.h
//  penco
//
//  Created by Zhu Wensheng on 2019/6/17.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DDFileLogger;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) DDFileLogger *fileLogger;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

