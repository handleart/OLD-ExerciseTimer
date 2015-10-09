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


@interface ViewTimerTableViewController ()

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseStart;
@property (weak, nonatomic) IBOutlet UILabel *labelRepNumText;
@property (weak, nonatomic) IBOutlet UILabel *labelRepTimerText;

@property NSDate *currentTime;
@property NSDate *extraTime;

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
@property long setCount;

@property BOOL bInBackground;
@property NSTimeInterval distanceBetweenDates;
@property NSDate *now;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
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
    
    
    if (_buttonPauseStart.selected == NO) {
    
        UILocalNotification* alarm = [[UILocalNotification alloc] init];
        if (alarm)
        {
            alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
            alarm.timeZone = [NSTimeZone defaultTimeZone];
            alarm.repeatInterval = 0;
            //alarm.soundName = @"alarmsound.caf";
            alarm.alertBody = @"ME Timer is running in the background!";
            
            [app scheduleLocalNotification:alarm];
        }
        
        _bInBackground = YES;
        
        _now = [NSDate date];
        
        //NSLog(@"now: %@", _now);
        
        [self createNotifications];
    }
    //[self saveExerciseSetData];
}

-(void)createNotifications {
    
    NSInteger iNotification1length = 0;
    NSInteger iNotification2length = 0;
    
    
    for (int i = _repNumCount; i <= _tmpTimer.iNumReps - 1; i++) {
    
        if (_iWhichTimer == 0 && i == 0) {
            
            
                UILocalNotification *localNotification1 = [[UILocalNotification alloc]init];
                localNotification1.fireDate = [NSDate dateWithTimeIntervalSinceNow:_counter];
            
                localNotification1.soundName = [NSString stringWithFormat:@"%@.%@", _tmpTimer.sRepSoundName, _tmpTimer.sRepSoundExtension];
                
                localNotification1.alertBody = @"Rep Start";
                
                [[UIApplication sharedApplication]scheduleLocalNotification:localNotification1];
                
            //iNotification1length += _counter;
            iNotification2length += _counter;
            //NSLog([NSString stringWithFormat:@"Len1: %li, Len2 %li", (long)iNotification1length, (long)iNotification2length]);
        }
        
        iNotification1length =  iNotification2length + _tmpTimer.iRepLen1;
        iNotification2length =  iNotification1length + _tmpTimer.iRepLen2;
        
        if (_tmpTimer.iNumReps - 1 == i) {
        
            iNotification2length = 0;
        
        }
    
        //NSLog([NSString stringWithFormat:@"Len1: %li, Len2 %li", (long)iNotification1length, (long)iNotification2length]);
        
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification1length];
        
        
        
        if (_tmpTimer.iNumReps - 1 != i) {
            localNotification.alertBody = @"Transition / Break";
            localNotification.soundName = [NSString stringWithFormat:@"%@.%@", _tmpTimer.sRepSoundName, _tmpTimer.sRepSoundExtension];
            
            UILocalNotification *localNotification2 = [[UILocalNotification alloc] init];
            localNotification2.fireDate = [NSDate dateWithTimeIntervalSinceNow:iNotification2length];
            
            localNotification2.soundName = [NSString stringWithFormat:@"%@.%@", _tmpTimer.sRepSoundName, _tmpTimer.sRepSoundExtension];
            
            localNotification2.repeatInterval = NSCalendarUnitSecond;
            
            
            localNotification2.alertBody = @"Start Rep";
            
            [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        } else {
            localNotification.alertBody = [NSString stringWithFormat:@"End of %@", _tmpTimer.timerName];
            localNotification.soundName = [NSString stringWithFormat:@"Triple %@.%@", _tmpTimer.sRepSoundName, _tmpTimer.sRepSoundExtension];
            

        }
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        
    }
        //NSArray *tmp = [[NSArray alloc] initWithArray: _tmpTimer.getRepLengthsAsArray];

    
}

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
    
}


- (void)UIApplicationEnterForeground:(UIApplication *)application {
   
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (_buttonPauseStart.selected == NO) {
    
        _bInBackground = NO;
        
        _distanceBetweenDates = [_now timeIntervalSinceDate:[NSDate date]];
        
        NSLog(@"now: %f", _distanceBetweenDates);
        
        //need to consider )_iWhichTimer == 0
        NSInteger timeSpentInRep = 0;
        NSInteger modulusDistanceBetweenDates = 0;
        
        if (_iWhichTimer == 0 && -1 * _distanceBetweenDates < _iRepLen0) {
                _counter += _distanceBetweenDates;
        } else{
            
        
            if (_iWhichTimer ==0 && -1 * _distanceBetweenDates >_iRepLen0)  {
                _repNumCount -= -1 + (int)((int)_distanceBetweenDates / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                _distanceBetweenDates += _iRepLen0;
            } else if (_iWhichTimer == 1) {
                _repNumCount -= (int)((int)_distanceBetweenDates / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                timeSpentInRep = _tmpTimer.iRepLen1 - _counter;
            } else {
                _repNumCount -= (int)((int)_distanceBetweenDates / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
                timeSpentInRep = _tmpTimer.iRepLen2 - _counter;
            }
            

            NSLog(@"%i", (int)((int)_distanceBetweenDates / (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2)));
            NSLog(@"%i", (int)((int)_distanceBetweenDates % (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2)));
            
            modulusDistanceBetweenDates = -1 * (int)((int)_distanceBetweenDates % (_tmpTimer.iRepLen1 + _tmpTimer.iRepLen2));
            
            
            
            
            if (modulusDistanceBetweenDates < _tmpTimer.iRepLen1) {
                
                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                _iWhichTimer = 1;
                _counter = _tmpTimer.iRepLen1 - modulusDistanceBetweenDates - timeSpentInRep;
            } else {
                _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
                _iWhichTimer = 2;
                _counter = _tmpTimer.iRepLen1 + _tmpTimer.iRepLen2- modulusDistanceBetweenDates - timeSpentInRep;
            }
            

            


        }
        
        NSLog(@"m is %li, t Rep %li", (long)modulusDistanceBetweenDates, (long)timeSpentInRep);
        NSLog(@"timer1 %i, counter %li",_iWhichTimer, _counter);
        
        [self countDownTimer];
        [self updateScreen];
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
    if (_exerciseSet.sSetName != nil) {
        self.navigationItem.title = _tmpTimer.sTimerName;
    }
    
    //_sRepName = [NSString stringWithFormat:@"Get Ready!",_repNumCount];
    _sRepName = [NSString stringWithFormat:@"Prep Counter"];
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
                
                
                
                [self playASound];
                [self updateScreen];
                [self countDownTimer];
                
            } else {
                [self.buttonPauseStart setTitle:@"Restart" forState:UIControlStateNormal];
                [self playEndSound];
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
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
}

@end
