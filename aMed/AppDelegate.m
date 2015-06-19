//
//  AppDelegate.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *  Setting apperance of the application when it launches.
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Application key for using Google Maps and Geocoding
    [GMSServices provideAPIKey:@"AIzaSyAStmByBRbjtqO7WfmZHiRdrCZwcm3aofQ"];
    
    //Set color of the Navigation Bar
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x602167)];
    
    //Set color of the Tab Bar
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0x602167)];
    
    // set these in first nav controller instead
    //[[UITabBar appearance] setTranslucent:NO];
    //[[UINavigationBar appearance] setTranslucent:NO];

    //Change the title of the Navigation Bar
    [[UINavigationBar appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor], NSForegroundColorAttributeName,
    [UIFont fontWithName:@"ArialMT" size:16.0], NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
