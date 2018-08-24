//
//  AppDelegate.m
//
//  Created by wjg 2018/2/22.
//  Copyright © 2018年 wjg. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()

@property(strong, nonatomic)UIWindow *window;

@property(nonatomic,strong)NSTimer *idleTimer;
@property(nonatomic,assign)__block UIBackgroundTaskIdentifier idleBgtaskId;

@end

@implementation AppDelegate
    
#pragma mark - App Delegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //init config app delegate
    [self initConfig];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self beginBackgroundIdleTaskWithApplication:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self stopBackgroundIdleTaskWithApplication:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

#pragma mark - init Config
-(void)initConfig{
    
    //initConfigIdleBgtaskId
    [self initConfigIdleBgtaskId];
    
    //config window
    [self initConfigWindow];
}

#pragma mark -
-(void)initConfigIdleBgtaskId{
    
    _idleBgtaskId=0;
}

-(void)initConfigWindow{
    
}

#pragma mark - backgroundTaskWithApplication
-(void)beginBackgroundIdleTaskWithApplication:(UIApplication *)application{
    
    self.idleBgtaskId = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        if(self.idleTimer &&
           self.idleTimer.isValid){
            [self.idleTimer invalidate];
        }
        
        [application endBackgroundTask:self.idleBgtaskId];
        self.idleBgtaskId = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self idleBackgroundTask];
    });
}

-(void)stopBackgroundIdleTaskWithApplication:(UIApplication *)application{
    
    if(self.idleTimer &&
       self.idleTimer.isValid){
        [self.idleTimer invalidate];
    }
    
    if(self.idleBgtaskId!=UIBackgroundTaskInvalid &&
       self.idleBgtaskId!=0){
        
        [application endBackgroundTask:self.idleBgtaskId];
        self.idleBgtaskId = UIBackgroundTaskInvalid;
    }
}

#pragma mark -
-(void)idleBackgroundTask{
    
    self.idleTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(doIdleAction:) userInfo:nil repeats:YES];
}

-(void)doIdleAction:(NSTimer *)timer{
    //do idle task
}

@end
