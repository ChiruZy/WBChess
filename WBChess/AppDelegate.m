//
//  AppDelegate.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "AppDelegate.h"
#import "RootNavController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[RootNavController alloc]initWithRootViewController:[MainViewController alloc]];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}


@end
