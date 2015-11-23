//
//  AppDelegate.h
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSMutableArray *timers;
@property NSMutableArray *exerciseSets;
@property NSMutableArray *tmpExerciseSet;
@property NSMutableArray *manualExerciseSets;

-(void)saveTimersData;
-(void)saveExerciseSetData;
-(void)saveTmpExerciseSetData;

@end

