//
//  SetTimerTableViewController.h
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/20/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetTimerTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue;


@property BOOL bNotFirstTime;

@end
