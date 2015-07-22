//
//  ViewTimerViewController.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import "ViewTimerViewController.h"
#import "AudioToolbox/AudioToolbox.h"


@interface ViewTimerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseStart;
@property (weak, nonatomic) IBOutlet UITextField *labelRepTimerText;
@property (weak, nonatomic) IBOutlet UITextField *labelRepNumText;

@property NSDate *currentTime;
@property NSDate *extraTime;

@property NSInteger counter;
@property int iWhichTimer;

@property int repNumCount;
@property NSTimer *timer;

@property NSString *sRepName;

@property SystemSoundID mBeep;


@end

@implementation ViewTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelRepTimerText.layer.borderWidth = 0.5;
    self.labelRepNumText.layer.borderWidth = 0.5;
    self.buttonPauseStart.layer.borderWidth = 0.5;
    
    //[self.buttonPauseStart setTitle:@"Continue" forState:UIControlStateHighlighted];
    [self.buttonPauseStart setTitle:@"Continue" forState:UIControlStateSelected];
    
    [self setUpInitialState];



}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    // Dispose of the sound
    if (!_mBeep) {
        AudioServicesDisposeSystemSoundID(_mBeep);
    }
    
}

-(void)applicationWillResignActive:(UIApplication *)application {
    [self.timer invalidate];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self countDownTimer];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilities



- (void)updateScreen{
    int minutes, seconds;
    
    minutes = seconds = 0;
    
    minutes = (int) (_counter / 60);
    seconds = (int) (_counter % 60);
    
    self.labelRepTimerText.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.labelRepNumText.text = [NSString stringWithFormat:@"%@", _sRepName];
}

- (void)playASound {
    //SystemSoundID mBeep;
    
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"Beep" ofType:@"aiff"];
    
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, & _mBeep);
    
    // Play the sound
    AudioServicesPlaySystemSound(_mBeep);
    
    
}


-(void) countDownTimer{
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];

    
    [self playASound];
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
                
            } else if (_iWhichTimer == 2) {
                _repNumCount ++;
                _sRepName = [NSString stringWithFormat:@"Rep #%d",_repNumCount];
                _iWhichTimer = 1;
                _counter = _iRepLen1;
                
            } else {
                NSLog(@"Um. Woops? You haven't designed this thing for more than 2 timers");
            }
            
            
            //This need to be fixed
            
            [self updateScreen];
            [self countDownTimer];
        }
        else {
            [self.buttonPauseStart setTitle:@"Restart" forState:UIControlStateNormal];
        }
    }
}

- (void)setUpInitialState {
    [self.buttonPauseStart setTitle:@"Pause" forState:UIControlStateNormal];
    
    _counter = _iRepLen1;
    _repNumCount = 1;
    
    _sRepName = [NSString stringWithFormat:@"Rep #%d",_repNumCount];
    
    _iWhichTimer = 1;
    
    [self updateScreen];
    [self countDownTimer];
    
}

#pragma mark - Buttons

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    

}
 
@end

