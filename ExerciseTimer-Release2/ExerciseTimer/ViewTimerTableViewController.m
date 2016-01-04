//
//  ViewTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/1/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//
//  This page is one of the initial pages I created for the app. As such, most of the labels, buttons are created using storyboard.
//  It's also the most complicated.
//
//  This page does several key things
//      1) Loops through the timers in each exercise sets and goes through each rep with a Rep 0 added to the beginning of each timer set
//      - Note that for the last rep in the timer, only Timer 1 is played. Timer 2 is skipped (since it didn't make sense to have a break after
//      that rep
//      2) Displays rep information to the user and plays a sound as appropriate
//      3) If the user goes to the background, determines whether the app should work in the background
//      4) If the app should work in the background, creates the user notifications in the system and saves current state
//      5) If the app does not work in the background, stops the app and saves current state
//      6) On return from background, determines how much time has passed to continue with the timer
//      7) Allows the user to transition to different pages by using source variables and segues
//


#import "ViewTimerTableViewController.h"
#import "SetTimerNewTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QuartzCore/QuartzCore.h"
#import "aTimer.h"
#import "AppDelegate.h"
#import "CreateExerciseSetTableViewController.h"

@interface ViewTimerTableViewController ()

//Labels / Button variable created using the storyboard
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseStart;
@property (weak, nonatomic) IBOutlet UILabel *labelRepNumText;
@property (weak, nonatomic) IBOutlet UILabel *labelRepTimerText;

//This is the counter that goes from Rep Length (0, 1 or 2) to 0
@property NSInteger counter;

//Determines whether we are on rep 0, 1 or 2.
@property int iWhichTimer;

//Determines which rep we are on. Note that for the last rep, only
@property int repNumCount;

//Is the rep name and is what is displayed in various places in the app. needs some clean up
@property NSString *sRepName;

//Which timer we are on in the exercise set. It's basically the index of the current timer in the exercise set aExercises array
@property int setCount;

//This is the current timer in the exercise set that we are on
@property aTimer* tmpTimer;

//Timer variable doing the countdown while the app is in foreground
@property NSTimer *timer;

//Sound related variables
@property (nonatomic, retain) AVAudioPlayer *player;

//Variable that uses volume from user defaults
@property float iVolume;

//Variable on whether sound should be played. It was developed to reduce weird cases where sound was playing even though the timer had ended
@property BOOL doPlaySound;

//Intro Length. This is set currently by the user in the setting page and stored as a user default.
@property NSInteger iRepLen0;

//This was a boolean set while I was evaluating different ways of having the app work in the background.
//I think we can safety remove this but need some testing
@property BOOL bInBackground;

//Variable that determines whether the app should work in the background
@property BOOL backgroundSwitch;

//Variable set to state that the exercise set is complete and stop the app.
@property BOOL bTimerEnded;

//This is the variable stating when the app went into background. It probably doesn't need to be set as a property but made life easier
@property NSDate *now;

@end

@implementation ViewTimerTableViewController

//As part of viewDidLoad, we want to initialize the color of the navigation bar, set user defaults and

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    
    //Set up the properties for sound play in the app. The app is set up to ignore silent and to play nice with other apps playing music
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Set up the user defaults set when the app last shut down
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _iRepLen0 = [userDefaults integerForKey:@"introLength"];;
    _iVolume = [userDefaults floatForKey:@"volume"];
    _volumeSlider.value = _iVolume;
    BOOL dimSwitch = [userDefaults boolForKey:@"keepScreenOn"];
    _backgroundSwitch = [userDefaults boolForKey:@"backgroundSwitch"];
    
    
    //Disable screen dimming if this variable is set to Yes in user defaults
    if (dimSwitch == YES) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:dimSwitch];
    }
    
    [self setUpInitialState];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIApplicationEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    //Dispose of the sound
    if (!_player) {
        _player = nil;
    }

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
}


-(void)appWillResignActive:(UIApplication *)application {
    [self.timer invalidate];
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    
    _now = [NSDate date];
    
    
    if (_backgroundSwitch == YES) {
    
        //NSLog(@"%i",_buttonPauseStart.selected);
         
        if (_buttonPauseStart.selected == NO && !([_buttonPauseStart.currentTitle containsString:@"Restart"]) && _bTimerEnded == NO ) {
        
            UILocalNotification* alarm = [[UILocalNotification alloc] init];
            if (alarm)
            {
                alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                alarm.repeatInterval = 0;
                //alarm.soundName = @"alarmsound.caf";
                alarm.alertBody = @"ME Timer is running in the background!";
                
                [app scheduleLocalNotification:alarm];
            }
            
            _bInBackground = YES;
            
            [self createNotifications:_tmpTimer whichTimer:_iWhichTimer counter:_counter repNumCount:_repNumCount totalLocalNotifications:0];
        }
    } else {
        
        UILocalNotification* alarm = [[UILocalNotification alloc] init];
        if (alarm)
        {
            alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
            alarm.timeZone = [NSTimeZone defaultTimeZone];
            alarm.repeatInterval = 0;
            //alarm.soundName = @"alarmsound.caf";
            alarm.alertBody = @"ME Timer is stopped!";
            
            [app scheduleLocalNotification:alarm];
        }
    
        
    }
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.tmpExerciseSet = [[NSMutableArray alloc] initWithObjects:@[_exerciseSet], nil];
    
    [appDelegate saveTmpExerciseSetData];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"ViewTimerPage" forKey:@"lastPage"];
    
    [userDefaults setObject:_source forKey:@"ViewTimerPage_source"];
    [userDefaults setObject:_now forKey:@"ViewTimerPage_now"];
    [userDefaults setInteger:_setCount forKey:@"ViewTimerPage_setCount"];
    [userDefaults setInteger:_iWhichTimer forKey:@"ViewTimerPage_iWhichTimer"];
    [userDefaults setInteger:_repNumCount forKey:@"ViewTimerPage_repNumCount"];
    [userDefaults setInteger:_counter forKey:@"ViewTimerPage_counter"];
    
    if (_backgroundSwitch == NO) {
         [userDefaults setBool:YES forKey:@"ViewTimerPage__buttonPauseStartState"];
    } else {
        [userDefaults setBool:_buttonPauseStart.selected forKey:@"ViewTimerPage__buttonPauseStartState"];
    }
    
    [userDefaults synchronize];
    
}


- (void)UIApplicationEnterForeground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    _bInBackground = NO;
    
    if (_buttonPauseStart.selected == NO && !([_buttonPauseStart.currentTitle containsString:@"Restart"])) {
        
        //[self UIIsBack:[_now timeIntervalSinceDate:[NSDate date]]];
        if (_backgroundSwitch == YES) {
            
            [self UIIsBack:[[NSDate date] timeIntervalSinceDate:_now]];
            
            [self countDownTimer];
            [self updateScreen];
        } else {
            _buttonPauseStart.selected = YES;
        }
        
    }
}

#pragma mark - utility to create notifications when app goes to the background

//this method was originally constructed to be called recursively. These variables are passed to this method since we are going to reset them inside the method
-(void)createNotifications:(aTimer *)tmpTimer whichTimer:(NSInteger)iWhichTimer counter:(NSInteger)counter repNumCount:(int)repNumCount totalLocalNotifications:(int)iTotalLocationNotifications
{
 
    NSInteger iNotification2length = 0;
    //Create notification to Start Rep, if rep1 len = 0 don't send a notificaiton for rep1 but for rep2
    //NSLog(@"Create Notifications");
    
    //Create notification to take a Break / Transition ... if rep2 len = 0, don't send a notification
    int iTimerIndex = _setCount;
    
    for (int j = iTimerIndex; j < [[_exerciseSet aExercises] count]; j++) {
        tmpTimer = [[_exerciseSet aExercises] objectAtIndex:j];
        
        if (iTotalLocationNotifications < 60) {
            if (iWhichTimer == 0) {
                // create notification for start of rep
                // keep repNumCount the same
                iNotification2length += counter;
                
                if (counter > 2) {
                    
                    UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc]init];
                    
                    localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                    
                    localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                    
                    localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@: Start Rep %i", [tmpTimer sTimerName], 1];
                    
                    [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                    
                    iTotalLocationNotifications += 1;
                    
                
                }
                
                iWhichTimer = 1;
                counter = tmpTimer.iRepLen1;
                repNumCount = 1;
            }
        
            for (int i = repNumCount; i <= tmpTimer.iNumReps; i++) {
                if (iWhichTimer == 1) {
                    // create notification for break, create notification for next set
                    //increase repNumCount
                    
                    iNotification2length += counter;
                    
                    
                    
                   if (i == tmpTimer.iNumReps) {
                       
                        
                        if (j != [[_exerciseSet aExercises] count] - 1) {
                            aTimer *tmpTimer2 = [[_exerciseSet aExercises] objectAtIndex:j + 1];
                            
                            
                            if (counter > 2) {
                                UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
                                
                                
                                localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                                
                                localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                                
                                localNotificationRep1.alertBody = [NSString stringWithFormat:@"Get ready for %@ set", tmpTimer2.sTimerName];
                                
                                [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                                
                                iTotalLocationNotifications += 1;
                            }
                            
                            iWhichTimer = 0;
                            counter = _iRepLen0;
                            repNumCount = 0;
  
                        } else {
                            
                            if (counter > 2) {
                                UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
                                
                                localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                                
                                localNotificationRep1.soundName = [NSString stringWithFormat:@"Triple %@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                                
                                localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@: Completed!", [_exerciseSet sSetName]];
                                
                                [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                                
                                iTotalLocationNotifications += 1;
                            }
                            
                            iWhichTimer = 0;
                            counter = _iRepLen0;
                            
                        }
                    
                    } else {
                    
                        if (counter > 2) {
                        
                            UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
 
                            localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                            
                            localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                            
                           
                            localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@: Break / Transition %i", [tmpTimer sTimerName], i];
                            
                            [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];

                            iTotalLocationNotifications += 1;
                        }
                        
                        iWhichTimer = 2;
                        counter = tmpTimer.iRepLen2;
                    
                    }
                }

                if (iWhichTimer == 2 && i != tmpTimer.iNumReps) {
                    
                    iNotification2length += counter;
                    
                    if (counter > 2) {
                        
                        UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc]init];
                        
                        localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                        
                        localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                        
                        if (i == repNumCount) {
                            localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@: Start Rep %i", [tmpTimer sTimerName], i+1];
                        } else {
                           localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@: Start Rep %i", [tmpTimer sTimerName], i+1];
                        }
                        
                        
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                        
                        iTotalLocationNotifications += 1;
                    }
                
                
                    iWhichTimer = 1;
                    counter = tmpTimer.iRepLen1;
                    iTotalLocationNotifications += 1;
            
                    
                     //NSLog(@"2 %li",  (long)iNotification2length);
                }
                
               

                
            }
            
        //If (near) the max number of notifications is created, notify the user that no more notifications are coming
        } else {
                //create message that app will be stopped
            
            UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
            
            //iNotification2length += counter;
            localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
            
            localNotificationRep1.soundName = [NSString stringWithFormat:@"Triple %@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
            
            localNotificationRep1.alertBody = [NSString stringWithFormat:@"Notifications stopped. App has been in the background too long!"];
            
            [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
            
            break;

        }
    
    }
    
    
}

#pragma mark - Utilities

//Determines how much time has been spent in the rep, including rep 0
-(NSInteger)timeAlreadySpentInRep {
    
    NSInteger iLength = 0;
    int iRep;
    
    if (_iWhichTimer == 0) {
        return _iRepLen0 - _counter;
    } else {
        iLength += _iRepLen0;
        
        if (_iWhichTimer == 2) {
            iLength += _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2 - _counter;
        } else {
            iLength += _tmpTimer.iRepLen1 - _counter;
        }
        
        iRep = _repNumCount - 1;
        
        for (int i = 0; i < iRep; i++) {
            iLength += _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2;
        }
        
        //iLength += _tmpTimer.iRepLen1;
        
        return iLength;
    }
    
}

//method to update the values on the screen.
- (void)updateScreen{
    if (_bInBackground == NO) {
        //int minutes, seconds;
        
        //minutes = seconds = 0;
        
        //minutes = (int) (_counter / 60);
        //seconds = (int) (_counter % 60);
        
        self.labelRepTimerText.text = [NSString stringWithFormat:@"%02d:%02d", (int) (_counter / 60), (int) (_counter % 60)];
        self.labelRepNumText.text = [NSString stringWithFormat:@"%@", _sRepName];
    }
}


//method to end timer and set up the screen to indicate that the timer has ended
-(void)setupEndState {
    [self.buttonPauseStart setTitle:@"Restart" forState:UIControlStateNormal];
    [_timer invalidate];
    
}

//method to initialize or re-initialize the page and set up the timer
- (void)setUpInitialState {
    [self configureButtons];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _now = (NSDate *)[userDefaults objectForKey:@"ViewTimerPage_now"];
    
    _doPlaySound = YES;
    _bTimerEnded = NO;
    
    //If _now is not nil, then we need to use user defaults to reinitialize the page
    if (_now != nil ) {
        
        _source = [userDefaults objectForKey:@"ViewTimerPage_source"];
        _setCount = (int)[userDefaults integerForKey:@"ViewTimerPage_setCount"];
        _iWhichTimer = (int)[userDefaults integerForKey:@"ViewTimerPage_iWhichTimer"];
        _repNumCount = (int)[userDefaults integerForKey:@"ViewTimerPage_repNumCount"];
        _counter = (int)[userDefaults integerForKey:@"ViewTimerPage_counter"];
        _buttonPauseStart.selected = (bool)[userDefaults boolForKey:@"ViewTimerPage__buttonPauseStartState"];
        
        _tmpTimer = [[_exerciseSet aExercises] objectAtIndex:_setCount];
        [self prepareToPlayASound:_tmpTimer.sRepSoundName fileExtension:_tmpTimer.sRepSoundExtension];
        
        if (_backgroundSwitch == YES) {
        
            [self UIIsBack:[[NSDate date] timeIntervalSinceDate:_now]];
            
            [self updateScreen];
            
            if (_iWhichTimer != 0 && _now == nil) {
                
                [self playASound];
            }
            [self countDownTimer];
            
            
        } else {
            [self.timer invalidate];
            // need to fix this. I name sRepName in too many places
            if (_iWhichTimer == 0) {
                _sRepName = [NSString stringWithFormat:@"Get ready!"];
            } else if (_iWhichTimer == 1) {
                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
           
            } else if (_iWhichTimer == 2) {
                _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
            }
            
            [self updateScreen];
        }
        
    //if _now is nil, then we don't need to recalculate where we were in the timer and we can set all the variables to initial variables
    } else {
        _counter = _iRepLen0;
        _repNumCount = 0;
        _setCount = 0;
        _tmpTimer = [[_exerciseSet aExercises] objectAtIndex:_setCount];
        
        [self prepareToPlayASound:_tmpTimer.sRepSoundName fileExtension:_tmpTimer.sRepSoundExtension];
        
        
        if (_tmpTimer.sTimerName != nil) {
            self.navigationItem.title = _tmpTimer.sTimerName;
        }
        
        _sRepName = [NSString stringWithFormat:@"Get ready!"];
        _iWhichTimer = 0;
        
        [self updateScreen];
        
        if (_iWhichTimer != 0 && _now == nil) {
            
            [self playASound];
        }
        
        [self countDownTimer];
        
    }

}

//Set the values in the UI when the UI returns from background
- (void)UIIsBack:(double)timeInBackground {
    
    NSInteger timeSpentinExerciseSet = [self timeAlreadySpentInRep];
    
    
    //determine which timer in the exercise set we are on and set the tmpTimer variable (as necessary)
    if (timeInBackground + timeSpentinExerciseSet >= [_tmpTimer totalLength] + _iRepLen0)  {
        //set the starting index to +1 of the index before we went into background
        int iTimerIndex = _setCount;
        
        NSInteger timeRemainingInLastRep = [_tmpTimer totalLength] + _iRepLen0 - timeSpentinExerciseSet;
        
        
        
        if (iTimerIndex + 1 >= [[_exerciseSet aExercises] count]) {
            _bTimerEnded = YES;
        } else {
            for (int i = iTimerIndex + 1; i < [[_exerciseSet aExercises] count]; i++) {
                
                timeInBackground -= timeRemainingInLastRep;
                timeSpentinExerciseSet = 0;
                timeRemainingInLastRep = [[[_exerciseSet aExercises] objectAtIndex:i] totalLength] + _iRepLen0;
                
                if (timeInBackground <= timeRemainingInLastRep) {
                    _iWhichTimer = 0;
                    _counter = _iRepLen0;
                    _tmpTimer = [[_exerciseSet aExercises] objectAtIndex:i];
                    if (_tmpTimer.sTimerName != nil) {
                        self.navigationItem.title = _tmpTimer.sTimerName;
                    }
                    
                    _setCount = i;
                    
                    break;
                }
                
                
                
                if (i == [[_exerciseSet aExercises] count] -1) {
                    _bTimerEnded = YES;
                    _tmpTimer = [[_exerciseSet aExercises] objectAtIndex:i];
                    
                }
            }
            
        }
    } else {
        _bTimerEnded = NO;
    }
    
    
    //Now that we know the timer, determine the exact time spent in the rep and re-initialize the variables to be displayed on the page
    
    if (_bTimerEnded == NO) {
        
        NSInteger timeNowSpent = timeSpentinExerciseSet + timeInBackground;
        
        if (timeNowSpent <= _iRepLen0) {
            _iWhichTimer = 0;
            _counter = _iRepLen0 - timeNowSpent;
            _sRepName = [NSString stringWithFormat:@"Get ready!"];
            _repNumCount = 0;
        } else {
            timeNowSpent -= _iRepLen0;
            
            _repNumCount = 1 + (int) (timeNowSpent / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
            
            //rounding by adding 0.5 -- this should be fine since timeNowSpent >= 0
            
            NSInteger tmpCounter = (int)((int)(timeNowSpent + 0.5) % (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
            
            if (tmpCounter <= _tmpTimer.iRepLen1) {
                _counter = _tmpTimer.iRepLen1 - tmpCounter;
                _iWhichTimer = 1;
                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
            } else {
                tmpCounter -= _tmpTimer.iRepLen1;
                _counter = _tmpTimer.iRepLen2 - tmpCounter;
                _iWhichTimer = 2;
                _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
            }
            
        }
    } else {
        [self setupEndState];
        _repNumCount = (int)_tmpTimer.iNumReps;
        _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
        _iWhichTimer = 1;
        _counter = 0;
        _setCount = (int)[[_exerciseSet aExercises] count] - 1;
        _doPlaySound = NO;
        self.navigationItem.title = _tmpTimer.sTimerName;
    }
}



#pragma mark - sound
//Plays sound use AVFoundation framework
- (void)playASound {
    [_player play];
}

-(void)playEndSound {
    
    NSString *sEndSoundName = [NSString stringWithFormat:@"Triple %@", _tmpTimer.sRepSoundName];
    NSString *sEndSoundExtension = _tmpTimer.sRepSoundExtension;
    [self prepareToPlayASound:sEndSoundName fileExtension:sEndSoundExtension];
    [_player play];
}

- (void)prepareToPlayASound:(NSString *)filename fileExtension:(NSString *)ext {
    
    
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
    
    NSURL *pathAsURL = [[NSURL alloc] initFileURLWithPath:audioFilePath];
    NSError *error;
    
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAsURL error:&error];
         
    
    
    if (error) {
        //NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // preload the audio player
        [_player prepareToPlay];
    }
 
    _player.volume = _iVolume;
}

#pragma mark - count down timer

-(void) countDownTimer{
    if (!_timer) {
        [_timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

//method called every 1 seconds that determines where we are in the timer
-(void) countDown:(NSTimer *)timer {
    
    if (_bTimerEnded == NO) {
        _counter --;
        if (_counter >= 0) {
            [self updateScreen];
        }
    
        if (_counter <=0) {
            [timer invalidate];
            if (_repNumCount < _tmpTimer.iNumReps) {
                if (_iWhichTimer == 1) {
                    //_sRepName = @"Break";
                    _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
                    _iWhichTimer = 2;
                    _counter = _tmpTimer.iRepLen2;
                    
                
                } else if (_iWhichTimer == 2 || _iWhichTimer == 0) {
                    _repNumCount ++;

                    _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                    _iWhichTimer = 1;
                    _counter = _tmpTimer.iRepLen1;
                    
                    
                } else {
                    //NSLog(@"Um. Woops? You haven't designed this thing for more than 2 timers");
                }
                
                [self playASound];
                [self updateScreen];
                [self countDownTimer];
                
            }
            else {
                if ([_exerciseSet.aExercises count] - 1 > _setCount) {
                    _setCount += 1;
                    
                    _tmpTimer = [_exerciseSet.aExercises objectAtIndex:_setCount];
                    _sRepName = [NSString stringWithFormat:@"Get ready!"];
                
                    [self prepareToPlayASound:_tmpTimer.sRepSoundName fileExtension:_tmpTimer.sRepSoundExtension];
                    
                    self.navigationItem.title = _tmpTimer.sTimerName;
                    
                    _repNumCount = 0;
                    _iWhichTimer = 0;
                    _counter = _iRepLen0;
                    
                    
                    if (_doPlaySound == YES) {
                        [self playASound];
                    }
                    [self updateScreen];
                    [self countDownTimer];
                    
                } else {
                    
                    [self setupEndState];
                    
                    _bTimerEnded = YES;
                    
                    if (_doPlaySound == YES) {
                        [self playEndSound];
                    } else {
                        _doPlaySound = YES;
                    }
                    
                }
                
            }
        }
    }
}



#pragma mark - Buttons and volume slider

-(void)configureButtons {
    [self.buttonPauseStart setTitle:@"Pause" forState:UIControlStateNormal];
    //[self.buttonPauseStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal forState:UIControlStateSelected];
    
    _buttonPauseStart.layer.borderWidth = 1.0f;
    _buttonPauseStart.layer.borderColor = [[UIColor redColor] CGColor];
    _buttonPauseStart.layer.cornerRadius = 8.0f;
}


- (IBAction)volumeSliderValueChanged:(id)sender {
    //NSLog(@"%@", _volumeSlider);
    _player.volume = _volumeSlider.value;
    _iVolume = _volumeSlider.value;
    
}

- (IBAction)handleButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
   // NSLog(@"Button Title: %@", button.currentTitle);
    //NSLog(@"Button Equal: %d", button == self.buttonPauseStart);
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [button
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [button
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];


    [_timer invalidate];
    
    if (button == self.buttonPauseStart) {
        if ([button.currentTitle containsString:@"Restart"]) {
            
            [self clearLocalUserDefaults];
            _bTimerEnded = NO;
            
            [self setUpInitialState];
        } else {
            if (button.selected == YES){
                [self countDownTimer];
            } else {
                [self.timer invalidate];
            }
            
            button.selected = !button.selected;
        }
    }
    
}


#pragma mark - clear user defaults

-(void)clearLocalUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"ViewTimerPage_source"];
    [userDefaults setObject:nil forKey:@"lastPage"];
    [userDefaults setObject:nil forKey:@"ViewTimerPage_now"];
    [userDefaults setInteger:0 forKey:@"ViewTimerPage_setCount"];
    [userDefaults setInteger:0 forKey:@"ViewTimerPage_iWhichTimer"];
    [userDefaults setInteger:0 forKey:@"ViewTimerPage_repNumCount"];
    [userDefaults setInteger:_iRepLen0 forKey:@"ViewTimerPage_counter"];
    [userDefaults setBool:NO forKey:@"ViewTimerPage__buttonPauseStartState"];

    [userDefaults synchronize];

}

#pragma mark - Navigation

//Create the segues on the fly based on the source of the page when the back button is pressed
//This was necessary since when the app comes from the background, it doesn't have the navigation stack created
- (IBAction)backButtonPressed:(id)sender {
    
    [_timer invalidate];
    
    if ([_source isEqualToString:@"CreateExerciseSetTableViewController"]) {
        
        UINavigationController *nc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"createExerciseSetNavigationPage"];
        
        CreateExerciseSetTableViewController *lvc = (CreateExerciseSetTableViewController*)[[nc viewControllers] objectAtIndex:0];
        
        [lvc setExerciseSet:_exerciseSet];
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"test"
                                        source:self
                                   destination:nc
                                performHandler:^{
                                    [self.navigationController presentViewController:nc animated:NO completion: nil];
                                }];
        
        [self prepareForSegue:segue sender:self];

        [segue perform];
    } else if ([_source  isEqualToString:@"TimerView"]) {
        UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        UINavigationController *tmp = [tvc.viewControllers objectAtIndex:0];
        
        SetTimerNewTableViewController *lvc = [[tmp viewControllers] objectAtIndex:0];
        [lvc setTmpTimer:_tmpTimer];
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"test"
                                        source:self
                                   destination:lvc
                                performHandler:^{
                                    [self.navigationController presentViewController:tvc animated:NO completion: nil];
                                    
                                    // transition code that would
                                    // normally go in the perform method
                                }];
        
        [self prepareForSegue:segue sender:self];
        
        [segue perform];
    
    } else if ([_source  isEqualToString:@"presetSetTimerView"]) {
        
        UINavigationController *nc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setTimerNavigationController"];
        
        SetTimerNewTableViewController *lvc = [[nc viewControllers] objectAtIndex:0];
        

        [lvc setTmpTimer:_tmpTimer];
        [lvc setSaveViewIsShowing:YES];
        
        
        //presetTimerNavigationController
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"test"
                                        source:self
                                   destination:nc
                                performHandler:^{
                                    [self.navigationController presentViewController:nc animated:NO completion: nil];

                                }];
        
        [self prepareForSegue:segue sender:self];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [segue perform];

    } else {
        UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        UINavigationController *tmp = [tvc.viewControllers objectAtIndex:0];
        
        SetTimerNewTableViewController *lvc = [[tmp viewControllers] objectAtIndex:0];
        [lvc setTmpTimer:_tmpTimer];
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"test"
                                        source:self
                                   destination:lvc
                                performHandler:^{
                                    [self.navigationController presentViewController:tvc animated:NO completion: nil];
                                }];
        
        [self prepareForSegue:segue sender:self];
        
        [segue perform];
    }
    

    
}

#pragma mark - navigation - clear and set defaults before segue

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //save the user volume fro next time user navigates to this page
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:_iVolume forKey:@"volume"];

    //remove any local user defaults for this page that would have been created if the page went into background
    [self clearLocalUserDefaults];

    //allow screen to dim and shutdown
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
}

@end
