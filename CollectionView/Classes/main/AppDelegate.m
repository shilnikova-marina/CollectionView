//
//  AppDelegate.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Cache images settings
    int cacheSizeMemory = 32 * 1024 * 1024;
    int cacheSizeDisk = 100 * 1024 * 1024;
    [[NSURLCache sharedURLCache] setMemoryCapacity:cacheSizeMemory];
    [[NSURLCache sharedURLCache] setDiskCapacity:cacheSizeDisk];

    MainViewController *controller = [[MainViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
