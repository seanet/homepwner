//
//  HomepwnerAppDelegate.m
//  Homepwner
//
//  Created by zhaoqihao on 14-8-20.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "HomepwnerAppDelegate.h"
#import "ItemsTableViewController.h"
#import "BNRItemStore.h"

@implementation HomepwnerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ItemsTableViewController *itemsTableViewController=[[ItemsTableViewController alloc]init];
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:itemsTableViewController];
    
    [self.window setRootViewController:navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    BOOL success=[[BNRItemStore sharedStore]saveChanges];
    if(success){
        NSLog(@"Saved all of the BNRItems");
    }else{
        NSLog(@"Could not save any of the BNRItems");
    }
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
