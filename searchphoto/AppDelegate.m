//
//  AppDelegate.m
//  searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "AlbumViewController.h"
#import "Const.h"
#import "PhotoViewController.h"

static NSString *kSearchVCIdentity = @"AlbumViewControllerIdentity";
static NSString *kPhotoVCIdentity = @"PhotoViewControllerIdentity";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AlbumViewController *albumVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kSearchVCIdentity];
    albumVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"album", @"") image:[UIImage imageNamed:@"photo"] tag:1];
    UINavigationController *navVC2 = [[UINavigationController alloc] initWithRootViewController:albumVC];
    
    PhotoViewController *photoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kPhotoVCIdentity];
    photoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"photo", @"") image:[UIImage imageNamed:@"photo"] tag:2];
    UINavigationController *navVC1 = [[UINavigationController alloc] initWithRootViewController:photoVC];

    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.viewControllers = [NSArray arrayWithObjects:navVC1, navVC2, nil];
    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
//    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = tabbarController;
    
    [self.window makeKeyAndVisible];
    
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
