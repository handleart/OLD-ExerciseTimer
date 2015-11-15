//
//  ViewTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/1/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "ViewTimerTableViewController.h"
#import "SetTimerNewTableViewController.h"
//#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import "QuartzCore/QuartzCore.h"
#import "aTimer.h"
#import "AppDelegate.h"
#import "CreateExerciseSetTableViewController.h"


@interface ViewTimerTableViewController ()

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseStart;
@property (weak, nonatomic) IBOutlet UILabel *labelRepNumText;
@property (weak, nonatomic) IBOutlet UILabel *labelRepTimerText;

//@property NSDate *currentTime;
//@property NSDate *extraTime;

@property NSInteger counter;
@property int iWhichTimer;

@property int repNumCount;
@property NSTimer *timer;

@property NSString *sRepName;

@property (nonatomic, retain) AVAudioPlayer *player;

@property float iVolume;

//@property SystemSoundID mBeep;

//Intro Length
@property NSInteger iRepLen0;

@property aTimer* tmpTimer;
@property int setCount;
@property BOOL bInBackground;
@property BOOL doPlaySound;
@property NSTimeInterval distanceBetweenDates;
@property NSDate *now;
@property int secsLeftInRep;

@end

@implementation ViewTimerTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    
    //Set up the properties for sound play in the app. The app is set up to ignore silent and to play nice with other apps playing music
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Need to move this into setting to allow user to preselect it. For the time being, the lead in to the counter is set up as 5 sec.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _setCount = 0;
    _tmpTimer = [_exerciseSet.aExercises objectAtIndex:_setCount];
    _iRepLen0 = [userDefaults integerForKey:@"introLength"];;
    _iVolume = [userDefaults floatForKey:@"volume"];
    _volumeSlider.value = _iVolume;
    BOOL dimSwitch = [userDefaults boolForKey:@"keepScreenOn"];
    
    if (dimSwitch == YES) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:dimSwitch];
    }
    
    [self setUpInitialState];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIApplicationEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
}

/*
- (void) saveExerciseSetData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.exerciseSet != nil) {
        [dataDict setObject:self.exerciseSet forKey:@"tmpExerciseSet"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"tmpExerciseSet"];
    
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSDate date] forKey:@"now"];

    [userDefaults synchronize];
    
    
}
*/


- (IBAction)volumeSliderValueChanged:(id)sender {
    //NSLog(@"%@", _volumeSlider);
    _player.volume = _volumeSlider.value;
    _iVolume = _volumeSlider.value;
    
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
    // Dispose of the sound
    //if (!_mBeep) {
    //    AudioServicesDisposeSystemSoundID(_mBeep);
    //}
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
                                                  object:nil];
    */
    
}


-(void)appWillResignActive:(UIApplication *)application {
    [self.timer invalidate];
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    
    
    if (_buttonPauseStart.selected == NO) {
    
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
        
        _now = [NSDate date];
        /*
        if (_iWhichTimer == 0) {
            _secsLeftInRep = (int)_iWhichTimer - (int)_counter + (int)[_tmpTimer totalLength];
        } else {
            if (_iWhichTimer == 1) {
                
            } else {
                
            }
            for (int k = _repNumCount + 1; k < _tmpTimer.iRepLen1) {
                _secsLeftInRep
                
            }
        }
        */
        
        _secsLeftInRep = 1;
        
        //NSLog(@"now: %@", _now);
        
        [self createNotifications:_tmpTimer notification1length:0 notification2length:0 whichTimer:_iWhichTimer counter:_counter repNumCount:_repNumCount totalLocalNotifications:0];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"ViewTimerPage" forKey:@"lastPage"];
    [userDefaults setObject:_now forKey:@"ViewTimerPage_now"];
    
    
    //[self saveExerciseSetData];
}

-(NSInteger)timeAlreadySpentInExerciseSet {
    int tmp = 0;
    NSUInteger tmp2 = [[_exerciseSet aExercises] indexOfObject:_tmpTimer];
    
    
    for (int i = 0; i < [[_exerciseSet aExercises] count]; i++) {
        if (i == tmp2) { break; }
        else {
            tmp += [[[_exerciseSet aExercises] objectAtIndex:i] totalLength] + _iRepLen0;
        }
       
    }
    
    //NSLog(@"index of ES %i", tmp);
    
    return [self timeAlreadySpentInRep] + tmp;
}

-(NSInteger)timeAlreadySpentInRep {

    NSInteger iLength = 0;
    int iRep;
    
    if (_iWhichTimer == 0) {
        return _iRepLen0 - _counter;
    } else {
        iLength += _iRepLen0;
        
        if (_iWhichTimer == 2) {
            iLength += _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2 - _counter;
            iRep = _repNumCount - 1;
        } else {
            iLength += _tmpTimer.iRepLen1 - _counter ;
            iRep = _repNumCount - 1;
        }
        
        for (int i = 0; i < iRep; i++) {
            iLength += _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2;
        }
        
        //iLength += _tmpTimer.iRepLen1;
        
        return iLength;
    }

}

-(void)createNotifications:(aTimer *)tmpTimer notification1length:(NSInteger) iNotification1length notification2length:(NSInteger) iNotification2length whichTimer:(NSInteger)iWhichTimer counter:(NSInteger)counter repNumCount:(int)repNumCount totalLocalNotifications:(int)iTotalLocationNotifications{
    
    //Create notification to Start Rep, if rep1 len = 0 don't send a notificaiton for rep1 but for rep2
    
    //Create notification to take a Break / Transition ... if rep2 len = 0, don't send a notification
    
    if (iTotalLocationNotifications < 60) {
    
        for (int i = repNumCount; i <= tmpTimer.iNumReps - 1; i++) {
            if (iWhichTimer == 0) {
                // create notification for start of rep
                // keep repNumCount the same
                iNotification2length += counter;
                
                if (counter > 2) {
                
                    UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc]init];
                    
                    localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                    
                    localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                    
                    localNotificationRep1.alertBody = [NSString stringWithFormat:@"Start Rep"];
                    
                    [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                    
                    iTotalLocationNotifications += 1;
                }
                
                iWhichTimer = 1;
                counter = tmpTimer.iRepLen1;
                
                
                
            }
            
            
            if (iWhichTimer == 1) {
                // create notification for break, create notification for next set
                //increase repNumCount
                
                if (counter > 2) {
                
                    iNotification2length += counter;
                    UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
                    
                    //iNotification2length += counter;
                    localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                    
                    localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                    
                    localNotificationRep1.alertBody = [NSString stringWithFormat:@"Break / Transition"];
                    
                    [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];

                    iTotalLocationNotifications += 1;
                
                }
                
                iWhichTimer = 2;
                counter = tmpTimer.iRepLen2;
                
            }
            
            
            if (iWhichTimer == 2) {
                
                iNotification2length += counter;
                
                if (i == tmpTimer.iNumReps - 1) {
                    
                    //iNotification2length += counter;
                    
                    NSInteger currentTimerIndex = [[_exerciseSet aExercises] indexOfObject:tmpTimer];
                    
                    if (currentTimerIndex < [[_exerciseSet aExercises] count] - 1) {
                        
                        tmpTimer = [[_exerciseSet aExercises] objectAtIndex:currentTimerIndex + 1];
                        
                        UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
                        
                       
                        localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                        
                        localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                        
                        localNotificationRep1.alertBody = [NSString stringWithFormat:@"Get ready for %@ set", tmpTimer.sTimerName];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                        
                        iTotalLocationNotifications += 1;
                        
                        //hmmm
                        
                        [self createNotifications:tmpTimer notification1length:0 notification2length:iNotification2length whichTimer:0 counter:_iRepLen0 repNumCount:_repNumCount totalLocalNotifications:iTotalLocationNotifications];
                        
                    } else {
                    
                        UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
                        
                        //iNotification2length += counter;
                        localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                        
                        localNotificationRep1.soundName = [NSString stringWithFormat:@"Triple %@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                        
                        localNotificationRep1.alertBody = [NSString stringWithFormat:@"%@ completed!", [_exerciseSet sSetName]];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];

                        iTotalLocationNotifications += 1;
                    }
                
                
                    // create notification for next set
                    //increase repNumCount
                    
                    //If it's last rep of timer
                    //check to see if there is another timer after this one
                    //if there is, notify user that next rep will start soon, run createnotification with that Timer
                    //else notify user that the exercise set is done
                    
                    
                    //produce "intro notifications"
                    //call method with next item in exerciseTimer if it exists
                    
                } else {
                    
                    //iNotification2length += counter;
                    
                    if (counter > 2) {
                        
                        UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc]init];
                        
                        localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
                        
                        localNotificationRep1.soundName = [NSString stringWithFormat:@"%@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
                        
                        localNotificationRep1.alertBody = [NSString stringWithFormat:@"Start Rep"];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];
                        
                        iTotalLocationNotifications += 1;
                    }
                    
                
                    iWhichTimer = 1;
                    counter = tmpTimer.iRepLen1;
                    iTotalLocationNotifications += 1;
                }
            }
            
            
        }
        
    
    } else {
            //create message that app will be stopped
        
        UILocalNotification *localNotificationRep1 = [[UILocalNotification alloc] init];
        
        iNotification2length += counter;
        localNotificationRep1.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
        
        localNotificationRep1.soundName = [NSString stringWithFormat:@"Triple %@.%@", tmpTimer.sRepSoundName, tmpTimer.sRepSoundExtension];
        
        localNotificationRep1.alertBody = [NSString stringWithFormat:@"Notifications stopped. App has been in the bacground too long!"];
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotificationRep1];

    }
    
    
}

/*

-(void)appWillTerminate:(UIApplication *)application {
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self.timer invalidate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"lastPage"];
    
}

 */

- (void)UIApplicationEnterForeground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    _bInBackground = NO;
    
    if (_buttonPauseStart.selected == NO) {
        
        [self UIIsBack:[_now timeIntervalSinceDate:[NSDate date]]];
        
        [self countDownTimer];
        [self updateScreen];
    }
}

- (void)UIIsBack:(double)timeInBackGround {
    
    
    // check to see which timer it falls on and the use that timer here (assign _tmpTimer, iWhichTimer and reset _timeInBackGround
    
    
    NSInteger timeSpentInRep = [self timeAlreadySpentInRep];
    NSInteger modulustimeInBackGround = 0;
    
    BOOL timerEnded;
    
    //Check to see if we are still in the same timer by checking total time in the background + time already spent in rep against the total length of the timer + the intro
    if (-1 * timeInBackGround + timeSpentInRep >= [_tmpTimer totalLength] + _iRepLen0)  {
        int iTimerIndex = (int)[[_exerciseSet aExercises] indexOfObject:_tmpTimer];
        
        NSInteger timeRemainingInLastRep = [_tmpTimer totalLength] + _iRepLen0 - timeSpentInRep;
        
        
        
        for (int i = iTimerIndex + 1; i < [[_exerciseSet aExercises] count]; i++) {
            timeInBackGround += timeRemainingInLastRep;
            timeSpentInRep = 0;
            timeRemainingInLastRep = [[[_exerciseSet aExercises] objectAtIndex:i] totalLength] + _iRepLen0;
            
            if (-1 * timeInBackGround <= timeRemainingInLastRep) {
                _iWhichTimer = 0;
                _counter = _iRepLen0;
                _tmpTimer = [[_exerciseSet aExercises] objectAtIndex:i];
                if (_tmpTimer.sTimerName != nil) {
                    self.navigationItem.title = _tmpTimer.sTimerName;
                }
            
                break;
            }

            
            if (i == [[_exerciseSet aExercises] count] -1) {
                timerEnded = YES;
                _repNumCount = (int)_tmpTimer.iNumReps;
                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                _iWhichTimer = 1;
                _counter = 0;
                _doPlaySound = NO;
            }
            
        }
    }
    
    
    if (timerEnded != YES) {
        if (_iWhichTimer == 0 && -1 * timeInBackGround < _iRepLen0) {
            _counter += timeInBackGround;
            
        } else{
            
            
            if (_iWhichTimer ==0 && -1 * timeInBackGround >_iRepLen0)  {
                timeInBackGround += _iRepLen0;
                _repNumCount -= -1 + (int)((int)timeInBackGround / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                
            } else if (_iWhichTimer == 1) {
                _repNumCount -= (int)((int)timeInBackGround / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                timeSpentInRep = _tmpTimer.iRepLen1 - _counter;
            } else {
                _repNumCount -= (int)((int)timeInBackGround / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                timeSpentInRep = _tmpTimer.iRepLen2 - _counter;
            }
            
            //NSLog(@"total length %ld", (long)_tmpTimer.totalLength);
            //NSLog(@"distance %ld", (long)_timeInBackGround);
            
            if (_repNumCount < _tmpTimer.iNumReps) {
                modulustimeInBackGround = -1 * (int)((int)timeInBackGround % (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                if (modulustimeInBackGround < _tmpTimer.iRepLen1) {
                    _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                    _iWhichTimer = 1;
                    _counter = _tmpTimer.iRepLen1 - modulustimeInBackGround - timeSpentInRep;
                } else {
                    _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
                    _iWhichTimer = 2;
                    _counter = _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2- modulustimeInBackGround - timeSpentInRep;
                }
                
            
                
            }else {
                //we would need to figure out what timer we are in and call itself again
                
                
                _repNumCount = (int)_tmpTimer.iNumReps;
                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                _iWhichTimer = 1;
                _counter = 0;
                _doPlaySound = NO;
            }
             
        }
        
        //NSLog(@"m is %li, t Rep %li", (long)modulusDistanceBetweenDates, (long)timeSpentInRep);
        //NSLog(@"timer1 %i, counter %li",_iWhichTimer, (long)_counter);
    }
}


#pragma mark - Utilities

- (void)updateScreen{
    
    if (_bInBackground == NO) {
        
    
    
        int minutes, seconds;
        
        minutes = seconds = 0;
        
        minutes = (int) (_counter / 60);
        seconds = (int) (_counter % 60);
        
        self.labelRepTimerText.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        self.labelRepNumText.text = [NSString stringWithFormat:@"%@", _sRepName];
    }
}

- (void)setUpInitialState {
    [self configureButtons];
    [self prepareToPlayASound:_tmpTimer.sRepSoundName fileExtension:_tmpTimer.sRepSoundExtension];
    
    _counter = _iRepLen0;
    _repNumCount = 0;
    if (_tmpTimer.sTimerName != nil) {
        self.navigationItem.title = _tmpTimer.sTimerName;
    }
    
    //_sRepName = [NSString stringWithFormat:@"Get Ready!",_repNumCount];
    _sRepName = [NSString stringWithFormat:@"Get ready for %@ set", _tmpTimer.sTimerName];
    //_sRepName = [NSString stringWithFormat:@"Prep Counter"];
    _iWhichTimer = 0;
    

    
    [self updateScreen];
    
    if (_iWhichTimer != 0) {
    
        [self playASound];
    }
        
    [self countDownTimer];
    
}



//Plays System Sound
/*
- (void)playASound {
    //SystemSoundID mBeep;
    
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"Temple Bell" ofType:@"aiff"];
    
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, & _mBeep);
    
    // Play the sound
    AudioServicesPlaySystemSound(_mBeep);
    
 
}
 
*/
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


-(void) countDownTimer{
    UIBackgroundTaskIdentifier bgTask = 0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

-(void) countDown:(NSTimer *)timer {
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
            
            
            //This need to be fixed
            
            [self playASound];
            
            [self updateScreen];
            
            [self countDownTimer];
            
        }
        else {
            
            //NSLog(@"%li", (unsigned long)[_exerciseSet.aExercises count]);
            if ([_exerciseSet.aExercises count] - 1 > _setCount) {
                _setCount += 1;
                
                _tmpTimer = [_exerciseSet.aExercises objectAtIndex:_setCount];
                
                _sRepName = [NSString stringWithFormat:@"Next up - %@ set", _tmpTimer.sTimerName];
                _repNumCount = 0;
                _iWhichTimer = 0;
                _counter = _iRepLen0;
                
                
                if (_doPlaySound == YES) {
                    [self playASound];
                }
                [self updateScreen];
                [self countDownTimer];
                
            } else {
                [self.buttonPauseStart setTitle:@"Restart" forState:UIControlStateNormal];
                if (_doPlaySound == YES) {
                    [self playEndSound];
                } else {
                    _doPlaySound = YES;
                }
                
            }
            
        }
    }
}


#pragma mark - Buttons

-(void)configureButtons {
    [self.buttonPauseStart setTitle:@"Pause" forState:UIControlStateNormal];
    //[self.buttonPauseStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal forState:UIControlStateSelected];
    
    _buttonPauseStart.layer.borderWidth = 1.0f;
    _buttonPauseStart.layer.borderColor = [[UIColor redColor] CGColor];
    _buttonPauseStart.layer.cornerRadius = 8.0f;
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

    //NSLog(@"timer %li", (long)[self timeAlreadySpentInRep]);
    //NSLog(@"exercise set %li", (long)[self timeAlreadySpentInExerciseSet]);

    if (button == self.buttonPauseStart) {
        if ([button.currentTitle containsString:@"Restart"]) {
            [self setUpInitialState];
        } else {
            
            
            if (button.selected == YES){
                //[self.buttonPauseStart setTitle:@"Continue" forState:UIControlStateNormal];
                [self countDownTimer];
                
            } else if (button.selected == NO) {
                //[self.buttonPauseStart setTitle:@"Pause" forState:UIControlStateNormal];
                [self.timer invalidate];
            }
            
            button.selected = !button.selected;
        }
    }
    
}






#pragma mark - Table view data source
 
 //set the background color to blue for the table
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 
     //cell.backgroundColor = [UIColor blueColor];
     //cell.textLabel.textColor = [UIColor whiteColor];
 
}

/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
 
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (IBAction)backButtonPressed:(id)sender {
    if ([_source  isEqual: @"CreateExerciseSetTableViewController"]) {
        [self performSegueWithIdentifier:@"unwindToCreateExerciseSet" sender:self];
    } else {
        [self performSegueWithIdentifier:@"unwindToSetTimer" sender:self];
    }
    
    [_timer invalidate];
    
    //SetTimerNewTableViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
    
    
    /*
    UIStoryboardSegue *segue =
    [UIStoryboardSegue segueWithIdentifier:@"test"
                                    source:self
                               destination:lvc
                            performHandler:^{
                                // transition code that would
                                // normally go in the perform method
                            }];
    
    
    [self prepareForSegue:segue sender:self];
    [segue perform];
     
     */
    
    //[self performSegueWithIdentifier:@"unwindToSetTimer" sender:self];
    
    /*
    
    if ([_source isEqualToString:@"CreateExerciseSetTableViewController"]) {
        
        UINavigationController *nc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"createExerciseSetNavigationPage"];
        
        CreateExerciseSetTableViewController *lvc =[[nc viewControllers] objectAtIndex:0];
        
        //CreateExerciseSetTableViewController *lvc = (CreateExerciseSetTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"createExerciseSetPage"];
        
        
        [lvc setExerciseSet:_exerciseSet];
        
        //UIViewController *tmp = (UIViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"viewExerciseSetListPage"];
        
        //UITabBarController *tmp = (UITabBarController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        //tmp.selectedIndex = 2;
        
        //UIViewController *tmp = (UIViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"viewExerciseSetListPage"];
        
        //[lvc setTabBarItem:tmp];
        
        
        //"viewExerciseSetListPage"
        
        //[nc setViewControllers:@[tmp, lvc]];
        //[nc setViewControllers:@[lvc]];
        
        
     
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"test"
                                        source:self
                                   destination:lvc
                                performHandler:^{
                                    // transition code that would
                                    // normally go in the perform method
                                }];
        
        [self prepareForSegue:segue sender:self];

        [segue perform];
         
     
        
        
        [self presentViewController:nc  animated:YES completion:nil];
        
        
    } else if ([_source  isEqualToString:@"manualSetTimerView"]) {
        UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        UINavigationController *tmp = [tvc.viewControllers objectAtIndex:0];
        
        SetTimerNewTableViewController *lvc = [[tmp viewControllers] objectAtIndex:0];
        [lvc setTmpTimer:_tmpTimer];
        //[lvc setSaveViewIsShowing:YES];
        
        [self presentViewController:tvc  animated:YES completion:nil];
    
    } else if ([_source  isEqualToString:@"presetSetTimerView"]) {
        UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        UINavigationController *tmp = [tvc.viewControllers objectAtIndex:0];
        
        SetTimerNewTableViewController *lvc = [[tmp viewControllers] objectAtIndex:0];
        [lvc setTmpTimer:_tmpTimer];
        [lvc setSaveViewIsShowing:YES];
        
        [self presentViewController:tvc  animated:YES completion:nil];

    }
    
    //tb.selectedIndex =
    
    //[dest setSource:@"presetSetTimerView"];
    //[dest setSource:@"manualSetTimerView"]

    */
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    /*
    if ([segue.identifier isEqualToString:@"SetTimer"]) {
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        ViewTimerTableViewController *dest = [[nc viewControllers] lastObject];
        [dest setIVolume: _iVolume];
    }
    */
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:_iVolume forKey:@"volume"];
    [userDefaults synchronize];

    [userDefaults setObject:@"" forKey:@"lastPage"];
    [userDefaults setObject:@"" forKey:@"ViewTimerPage_now"];
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
}

@end
