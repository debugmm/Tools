//
//  AppDelegate.m
//
//  Created by wjg 2018/2/22.
//  Copyright © 2018年 wjg. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

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
    [self registerRemoteNotification];
    
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

#pragma mark - Remote Notification
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    NSLog(@"didRegisterUserNotificationSettings");
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //save device token to server
    NSString *deviceTokenSt = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenSt:%@",deviceTokenSt);
    
    //the deviceToken is seldom renewed.
    //so we can check deviceToken that whether need saving it to server or not.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //failed register remote notification
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    //received a remote notification
    
    
    //demo
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -
-(void)registerRemoteNotification{
    //=========
    //config preferred options of notification.
    //register remote notification.(Just for getting APNS's deviceToken)
    //receive apns's deviceToken.
    
    //save the deviceToken to your server.
    //receive remote-notification.
    //=========
    
    //Registers preferred options for notifying the user.
    if(@available(iOS 10.0,*)){
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions op=UNAuthorizationOptionBadge;
        
        [center requestAuthorizationWithOptions:op completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            NSLog(@"requestAuthorizationWithOptions%@",error);
        }];
    }
    else if(@available(iOS 8.0,*)){
        //iOS 8.0-10
        UIUserNotificationSettings *un=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:un];
    }
    
    //Register Remote Notifications. APNS sends a deviceToken to App.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
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
