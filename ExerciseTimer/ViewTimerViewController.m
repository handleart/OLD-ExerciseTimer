//
//  ViewTimerViewController.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import "ViewTimerViewController.h"
//#import "SetTimerViewController.h"


@interface ViewTimerViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonChangeTimerSetting;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseStart;
@property (weak, nonatomic) IBOutlet UILabel *lableRepTimerText;
@property (weak, nonatomic) IBOutlet UILabel *labelRepNumText;

@property NSDate *currentTime;
@property NSDate *extraTime;

@property int counter;
@property int iWhichTimer;

@property int repNumCount;
@property NSTimer *timer;

@property NSString *sRepName;

@end

@implementation ViewTimerViewController

- (void)updateScreen{
    int minutes, seconds;
    
    minutes = seconds = 0;
    
    minutes = _counter / 60;
    seconds = (_counter % 60);
    
    self.lableRepTimerText.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.labelRepNumText.text = [NSString stringWithFormat:@"%@", _sRepName];
}


-(void) countDownTimer{
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
                _sRepName = @"Break";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lableRepTimerText.layer.borderWidth = 0.5;
    self.labelRepNumText.layer.borderWidth = 0.5;
    self.buttonPauseStart.layer.borderWidth = 0.5;
    

    //[self.buttonPauseStart setTitle:@"Continue" forState:UIControlStateHighlighted];
    [self.buttonPauseStart setTitle:@"Continue" forState:UIControlStateSelected];
    
    
    [self setUpInitialState];
    

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
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/
 
@end

