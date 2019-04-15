//
//  SetTimerNewTableViewController.h
//  Exercise Timer
//
//  Created by Art Mostofi on 9/6/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "aTimer.h"

@interface SetTimerNewTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue;


@property BOOL bNotFirstTime;
//@property float iVolume;
@property (assign) BOOL saveViewIsShowing;
@property (assign) BOOL addViewIsShowing;
@property aTimer *tmpTimer;

@end
