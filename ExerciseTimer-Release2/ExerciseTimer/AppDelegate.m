//
//  AppDelegate.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import "AppDelegate.h"
#import "aTimer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
        }
    #endif

    
    // look for saved data.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"timerAppData"];
   
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([savedData objectForKey:@"timers"] != nil) {
            self.timers = [[NSMutableArray alloc] initWithArray:[savedData objectForKey:@"timers"]];
        }
        else {
            self.timers = [[NSMutableArray alloc] init];
            
        }
    
    } //else {
    //    self.timers = [[NSMutableArray alloc] init];
    //}
    
    NSString *filePathExerciseSet = [documentsDirectoryPath stringByAppendingPathComponent:@"exerciseTimerAppData"];
    NSData *ExerciseSetData = [NSData dataWithContentsOfFile:filePathExerciseSet];
    NSDictionary *ExerciseSetSavedData = [NSKeyedUnarchiver unarchiveObjectWithData:ExerciseSetData];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathExerciseSet]) {
    
        if ([ExerciseSetSavedData objectForKey:@"exerciseSets"] != nil) {
            self.exerciseSets = [[NSMutableArray alloc] initWithArray:[ExerciseSetSavedData objectForKey:@"exerciseSets"]];
        } else {
            self.exerciseSets = [[NSMutableArray alloc] init];
        }
        
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    // set initial defaults
    
    if ([userDefaults objectForKey:@"volume"] == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:0.5f forKey:@"volume"];
        [userDefaults synchronize];
    }
    
    if ([userDefaults objectForKey:@"dimScreen"] == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:false forKey:@"dimScreen"];
        [userDefaults synchronize];
    }
    
    
    if ([userDefaults objectForKey:@"introLength"] == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:5 forKey:@"introLength"];
        [userDefaults synchronize];
    }

    //NSLog(@"%li", (long)[userDefaults integerForKey:@"introLength"]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
   
    
    
    
    //[self sendAppRunningNotice];

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

- (void)sendAppRunningNotice {
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        //alarm.soundName = @"alarmsound.caf";
        alarm.alertBody = @"Exercise timer is running in background!";
        
        [app scheduleLocalNotification:alarm];
    }
}

- (void) saveTimersData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.timers != nil) {
        [dataDict setObject:self.timers forKey:@"timers"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"timerAppData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    
    NSLog(@"Timer Data Saved");
}


- (void) saveExerciseSetData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.exerciseSets != nil) {
        [dataDict setObject:self.exerciseSets forKey:@"exerciseSets"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"exerciseTimerAppData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    
    NSLog(@"Exercise Data Saved");
}


@end
