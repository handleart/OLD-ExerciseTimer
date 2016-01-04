//
//  ViewTimerTableViewController.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/1/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//
//  exerciseSet: The page requires the Exercise Set to be set before the page is loaded
//  source: Source is optional but can be set to help determine the page to return when the app relaunches and navigation is not available
//      Values accepted are: CreateExerciseSetTableViewController, TimerView, presetSetTimerView
//      If no values is entered, the page returns to the tab view default page when back button is pressed

#import <UIKit/UIKit.h>
#import "anExerciseSet.h"

@interface ViewTimerTableViewController : UITableViewController


@property anExerciseSet* exerciseSet;
@property NSString* source;

@end
