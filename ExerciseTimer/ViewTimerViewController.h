//
//  ViewTimerViewController.h
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewTimerViewController : UIViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property NSInteger iNumReps;
@property NSInteger iRepLen1;
@property NSInteger iRepLen2;

@end
