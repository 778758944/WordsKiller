//
//  AppDelegate.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/16.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

