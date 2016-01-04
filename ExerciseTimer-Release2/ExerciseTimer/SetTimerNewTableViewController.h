//
//  SetTimerNewTableViewController.h
//  Exercise Timer
//
//  Created by Art Mostofi on 9/6/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//
// Variables:
// saveViewIsShowing determines that a button named save should be displayed that allows the user to save the preset time and stay on the same page
// addViewIsShowing determines that a button named add should be displayed that allows the user to add the preset time and go back to the previous page. Currently, create exercise set page
// tmpTimer: Should be set if a timer should be used to initialize the page
// bNotFirstTime: Tells the app this is the first time this page is being loaded and tmpTimer is going to be not used. This is probably not necessary as we will always set a tmptimer on application launch but requires some regression to remove it

#import <UIKit/UIKit.h>
#import "aTimer.h"

@interface SetTimerNewTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue;

@property BOOL bNotFirstTime;
@property (assign) BOOL saveViewIsShowing;
@property (assign) BOOL addViewIsShowing;
@property aTimer *tmpTimer;

@end
