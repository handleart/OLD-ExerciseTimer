//
//  ViewTimerTableViewController.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/1/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTimerTableViewController : UITableViewController

@property NSInteger iRepLen0;
@property NSInteger iNumReps;
@property NSInteger iRepLen1;
@property NSInteger iRepLen2;
@property float iVolume;

@property NSString* sRepSoundName;
@property NSString* sRepSoundExtension;

@property NSString* sEndSoundName;
@property NSString* sEndSoundExtension;



@end
