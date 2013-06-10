//
//  RAKulerizerAppDelegate.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerizerAppDelegate.h"

@implementation RAKulerizerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TestFlight takeOff:@"c3d5a0d4-f961-4a3c-8066-1a6894e33d6b"];
    
    // style navigation bar
    NSDictionary *navBarAppearanceDict = @{UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], UITextAttributeTextColor : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAppearanceDict];
    
    NSDictionary *barButtonAppearanceDict = @{UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

    //NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Sansumi"]);
    
    // splash screen fade out
    UIImageView *splash;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h"]];
    } else {
        splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    }
    
    [self.window.rootViewController.view addSubview:splash];
    [UIView animateWithDuration:1.5
                     animations:^{
                         splash.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [splash removeFromSuperview];
                     }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
