//
//  CreateExerciseSetTableViewController.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "anExerciseSet.h"

@interface CreateExerciseSetTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property anExerciseSet *exerciseSet;

@end
