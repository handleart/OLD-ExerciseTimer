//
//  ViewTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/1/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "ViewTimerTableViewController.h"
#import "SetTimerTableViewController.h"
//#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import "QuartzCore/QuartzCore.h"


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

@end

@implementation ViewTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up the properties for sound play in the app. The app is set up to ignore silent and to play nice with other apps playing music
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Need to move this into setting to allow user to preselect it. For the time being, the lead in to the counter is set up as 5 sec.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _iRepLen0 = [userDefaults integerForKey:@"introLength"];;
    _iVolume = [userDefaults floatForKey:@"volume"];
    _volumeSlider.value = _iVolume;
    BOOL dimSwitch = [userDefaults boolForKey:@"keepScreenOn"];
    
    if (dimSwitch == YES) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:dimSwitch];
    }
    
    
    
    [self setUpInitialState];
    
    
    

    
    
}
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
    
}

/*
-(void)applicationWillResignActive:(UIApplication *)application {
    [self.timer invalidate];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self countDownTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
*/
 

#pragma mark - Utilities

- (void)updateScreen{
    int minutes, seconds;
    
    minutes = seconds = 0;
    
    minutes = (int) (_counter / 60);
    seconds = (int) (_counter % 60);
    
    self.labelRepTimerText.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.labelRepNumText.text = [NSString stringWithFormat:@"%@", _sRepName];
}

- (void)setUpInitialState {
    [self configureButtons];
    
    [self prepareToPlayASound:_sRepSoundName fileExtension:_sRepSoundExtension];
    
    _counter = _iRepLen0;
    
    _repNumCount = 0;
    
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
    [self prepareToPlayASound:_sEndSoundName fileExtension:_sEndSoundExtension];
    [_player play];
}

- (void)prepareToPlayASound:(NSString *)filename fileExtension:(NSString *)ext {
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
    NSURL *pathAsURL = [[NSURL alloc] initFileURLWithPath:audioFilePath];
    NSError *error;
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAsURL error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // preload the audio player
        [_player prepareToPlay];
    }
    
    _player.volume = _iVolume;
    
    
}


-(void) countDownTimer{
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

-(void) countDown:(NSTimer *)timer {
    _counter --;
    if (_counter >= 0) {
        [self updateScreen];
    }
    
    
    
    if (_counter <=0) {
        [timer invalidate];
        if (_repNumCount < _iNumReps) {
            if (_iWhichTimer == 1) {
                //_sRepName = @"Break";
                _sRepName = [NSString stringWithFormat:@"Transition / Break %d",_repNumCount];
                _iWhichTimer = 2;
                _counter = _iRepLen2;
                
            
            } else if (_iWhichTimer == 2 || _iWhichTimer == 0) {
                _repNumCount ++;

                _sRepName = [NSString stringWithFormat:@"Rep %d",_repNumCount];
                _iWhichTimer = 1;
                _counter = _iRepLen1;
                
                
            } else {
                NSLog(@"Um. Woops? You haven't designed this thing for more than 2 timers");
            }
            
            
            //This need to be fixed
            
            [self playASound];
            [self updateScreen];
            [self countDownTimer];
        }
        else {
            [self.buttonPauseStart setTitle:@"Restart" forState:UIControlStateNormal];
            
            [self playEndSound];
        
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
    NSLog(@"Button Title: %@", button.currentTitle);
    NSLog(@"Button Equal: %d", button == self.buttonPauseStart);

    if (button == self.buttonPauseStart) {
        if ([button.currentTitle containsString:@"Restart"]) {
            [self setUpInitialState];
        } else {
            
            
            if (button.selected == YES){
                [self countDownTimer];
                
            } else if (button.selected == NO) {
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
