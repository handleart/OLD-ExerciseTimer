//
//  AppDelegate.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import "AppDelegate.h"
#import "aTimer.h"
#import "anExerciseSet.h"
#import "ViewTimerTableViewController.h"

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
   
    aTimer *tmpTimer = [[aTimer alloc] init];
    aTimer *tmpTimer2 = [[aTimer alloc] init];
    aTimer *tmpTimer3 = [[aTimer alloc] init];
    aTimer *tmpTimer4 = [[aTimer alloc] init];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([savedData objectForKey:@"timers"] != nil) {
            self.timers = [[NSMutableArray alloc] initWithArray:[savedData objectForKey:@"timers"]];
        }
        else {
            self.timers = [[NSMutableArray alloc] init];
            
        }
    
    } else {
        self.timers = [[NSMutableArray alloc] init];
        
        
        //aTimer *tmpTimer = [[aTimer alloc] init];
        tmpTimer.sTimerName = @"Warm Up";
        tmpTimer.iNumReps = 1;
        tmpTimer.iRepLen1 = 90;
        tmpTimer.iRepLen2 = 0;
        tmpTimer.sRepSoundName = @"Whistle";
        tmpTimer.sRepSoundExtension = @"aiff";
        
        [_timers addObject:tmpTimer];
        
        //aTimer *tmpTimer2 = [[aTimer alloc] init];
        tmpTimer2.sTimerName = @"High Low Timer";
        tmpTimer2.iNumReps = 5;
        tmpTimer2.iRepLen1 = 30;
        tmpTimer2.iRepLen2 = 90;
        tmpTimer2.sRepSoundName = @"Whistle";
        tmpTimer2.sRepSoundExtension = @"aiff";
        
        [_timers addObject:tmpTimer2];

        tmpTimer3.sTimerName = @"Cool Down";
        tmpTimer3.iNumReps = 1;
        tmpTimer3.iRepLen1 = 90;
        tmpTimer3.iRepLen2 = 0;
        tmpTimer3.sRepSoundName = @"Whistle";
        tmpTimer3.sRepSoundExtension = @"aiff";
        
        [_timers addObject:tmpTimer3];
        
        //aTimer *tmpTimer4 = [[aTimer alloc] init];
        tmpTimer4.sTimerName = @"Mindfulness of Breathing";
        tmpTimer4.iNumReps = 4;
        tmpTimer4.iRepLen1 = 4*60;
        tmpTimer4.iRepLen2 = 0;
        tmpTimer4.sRepSoundName = @"Temple Bell";
        tmpTimer4.sRepSoundExtension = @"aiff";
        
        [_timers addObject:tmpTimer4];
        
        [self saveTimersData];
        
        
        
    }
    
    NSString *filePathExerciseSet = [documentsDirectoryPath stringByAppendingPathComponent:@"exerciseTimerAppData"];
    NSData *ExerciseSetData = [NSData dataWithContentsOfFile:filePathExerciseSet];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathExerciseSet]) {
        NSDictionary *ExerciseSetSavedData = [NSKeyedUnarchiver unarchiveObjectWithData:ExerciseSetData];
        if ([ExerciseSetSavedData objectForKey:@"exerciseSets"] != nil) {
            self.exerciseSets = [[NSMutableArray alloc] initWithArray:[ExerciseSetSavedData objectForKey:@"exerciseSets"]];
        } else {
            self.exerciseSets = [[NSMutableArray alloc] init];
        }
        
        
    } else {
        self.exerciseSets = [[NSMutableArray alloc] init];
        
        anExerciseSet *tmpExerciseSet = [[anExerciseSet alloc] init];
        
        if (tmpTimer != nil && tmpTimer2 != nil) {
        
            tmpExerciseSet.sSetName = @"HIIT Set";
            [tmpExerciseSet.aExercises addObject:tmpTimer];
            tmpExerciseSet.iTotalLength += [tmpTimer totalLength];
            [tmpExerciseSet.aExercises addObject:tmpTimer2];
            tmpExerciseSet.iTotalLength += [tmpTimer2 totalLength];
            [tmpExerciseSet.aExercises addObject:tmpTimer3];
            tmpExerciseSet.iTotalLength += [tmpTimer totalLength];
            
            [_exerciseSets addObject:tmpExerciseSet];
        
            [self saveExerciseSetData];
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
        [userDefaults setBool:true forKey:@"dimScreen"];
        [userDefaults synchronize];
    }
    
    
    if ([userDefaults objectForKey:@"introLength"] == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:5 forKey:@"introLength"];
        [userDefaults synchronize];
    }
    
    //BOOL xTmp = YES;
    
    NSString *tmpHere =[userDefaults objectForKey:@"lastPage"];
    
    
    if ([[userDefaults objectForKey:@"lastPage"] isEqual: @"ViewTimerPage"]) {

        //NSLog(@"%li", (long)[userDefaults integerForKey:@"introLength"]);
    
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        
        
        
        //ViewTimerTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewTimerPage"];
        
        
        UINavigationController *nc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewTimerPage"];
        
        ViewTimerTableViewController *viewController =[[nc viewControllers] objectAtIndex:0];
        
        //[nc setViewControllers: @[viewController]];

        
        //[viewController setExerciseSet:[_exerciseSets objectAtIndex:0]];
        
        [viewController setExerciseSet:[_exerciseSets objectAtIndex:0]];
        //[viewController setSource:@"presetSetTimerView"];
        //[viewController setSource:@"manualSetTimerView"];
        [viewController setSource:@"CreateExerciseSetTableViewController"];
        
        //self.window.rootViewController = viewController;
        self.window.rootViewController = nc;
        
        
        [self.window makeKeyAndVisible];
        
    } else {
        //NSLog(@"%li", (long)[userDefaults integerForKey:@"introLength"]);
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
        
    }
    
    
    
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
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

/*

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
        alarm.alertBody = @"Your timer was stopped!";
        
        [app scheduleLocalNotification:alarm];
    }
}
 
 */

- (void) saveTimersData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.timers != nil) {
        [dataDict setObject:self.timers forKey:@"timers"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"timerAppData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    
    //NSLog(@"Timer Data Saved");
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
    
    //NSLog(@"Exercise Data Saved");
}


@end
