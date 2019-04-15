//
//  SetTimerTableViewController.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/20/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//


#define cTimerSectionIndex 1
#define cSaveSectionIndex 2

#define cRepPickerIndex 2
#define cTimer1PickerIndex 4
#define cTimer2PickerIndex 6
#define cSoundPickerIndex 8
//#define cNameIndex 0
//#define cSaveIndex 0
#define cPickerCellHeight 180
#define cDefaultTableHeight 50

#import "QuartzCore/QuartzCore.h"
#import "SetTimerNTableViewController.h"
#import "ViewTimerTableViewController.h"
#import "AppDelegate.h"
#import "anExerciseSet.h"


@interface SetTimerTableViewController ()


@property UIPickerView *timer2Picker;
@property UITextField *timer2Label;
@property UIPickerView *timer1Picker;
@property UITextField *timer1Label;
@property UITextField *numLabel;
@property UITextField *soundNameLabel;
@property  UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
//@property (weak, nonatomic) IBOutlet UITextField *repNameTextField;
@property UITextField *repNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *timerTotalLabel;

@property UILabel* totalLength;


@property  UIBarButtonItem *rewindButton;
@property  UIPickerView *soundNamePicker;
@property  UIPickerView *repPicker;


@property (assign) BOOL repPickerIsShowing;
@property (assign) BOOL timer1PickerIsShowing;
@property (assign) BOOL timer2PickerIsShowing;
@property (assign) BOOL soundPickerIsShowing;


@property (strong, nonatomic) UITextField *activeTextField;

@property NSArray *aNumRepsPickListValues;
@property NSArray *aTimer1PickListValues;
@property NSArray *aTimer2PickListValues;
@property NSArray *aSoundPickListValues;


@property NSArray *aMin;
@property NSArray *aSec;

@property NSInteger iNumRep;
@property NSString *sSoundName;
@property NSString *sSoundNameExtension;
@property NSInteger iLenOfTimer1min;
@property NSInteger iLenOfTimer1sec;
@property NSInteger iLenOfTimer2min;
@property NSInteger iLenOfTimer2sec;
@property NSInteger iLenOfTimer1;
@property NSInteger iLenOfTimer2;

@property NSString *sPlaceholderValue;

@end

@implementation SetTimerTableViewController


- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue {
    //ViewTimerTableViewController *source = [segue sourceViewController];
    //_iVolume = source.iVolume;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self definePickerData];
    //[self definePickerState];

    //[self configureButtons];

    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _sPlaceholderValue = [NSString stringWithFormat:@"Preset Timer %li", [[app timers] count] + 1];
    
    /*
    if (_tmpTimer != nil) {
        
        //_repNameTextField.text = _tmpTimer.sTimerName;
        
        //_dimScreenSwitch.on = _tmpTimer.bDimScreen;
        
        
        //set up sound
        _soundNameLabel.text = _tmpTimer.sRepSoundName;
        _sSoundName = _tmpTimer.sRepSoundName;
        
        //This is defined in two places. Need to define costent in different file or maybe a method ?
        _sSoundNameExtension = @"aiff";
        
        
        //rep number
        
        NSUInteger repIndex = [_aNumRepsPickListValues indexOfObject:[NSString stringWithFormat:@"%li", _tmpTimer.iNumReps]];
        [self.repPicker selectRow:repIndex inComponent:0 animated:NO];
        [self pickerView:self.repPicker didSelectRow:repIndex inComponent:0];
       
        
        //Timer 1
        NSInteger rep1LenMin = _tmpTimer.iRepLen1 / 60;
        NSInteger rep1LenSec = _tmpTimer.iRepLen1 % 60;
        NSUInteger iLen1IndexMin = [_aMin indexOfObject:[NSString stringWithFormat:@"%li", rep1LenMin]];
        NSUInteger iLen1IndexSec = [_aSec indexOfObject:[NSString stringWithFormat:@"%li", rep1LenSec]];
        [self.timer1Picker selectRow:iLen1IndexMin inComponent:0 animated:NO];
        [self.timer1Picker selectRow:iLen1IndexSec inComponent:1 animated:NO];
        [self pickerView:self.timer1Picker didSelectRow:iLen1IndexMin inComponent:0];
        [self pickerView:self.timer1Picker didSelectRow:iLen1IndexSec inComponent:1];
        
        //Timer 2
        NSInteger rep2LenMin = _tmpTimer.iRepLen2 / 60;
        NSInteger rep2LenSec = _tmpTimer.iRepLen2 % 60;
        NSUInteger iLen2IndexMin = [_aMin indexOfObject:[NSString stringWithFormat:@"%li", rep2LenMin]];
        NSUInteger iLen2IndexSec = [_aSec indexOfObject:[NSString stringWithFormat:@"%li", rep2LenSec]];
        [self.timer2Picker selectRow:iLen2IndexMin inComponent:0 animated:NO];
        [self.timer2Picker selectRow:iLen2IndexSec inComponent:1 animated:NO];
        [self pickerView:self.timer2Picker didSelectRow:iLen2IndexMin inComponent:0];
        [self pickerView:self.timer2Picker didSelectRow:iLen2IndexSec inComponent:1];
        
        
        //[_repNameTextField setBackgroundColor:[UIColor blueColor]];
        //_iVolume = 0.5f;
        
        
    } else {
        _tmpTimer = [[aTimer alloc] init];
        //only runs on initial load of the page -- which is the same as when _tmpTimer has not been init
        if (_bNotFirstTime != YES) {
            //if (_tmpTimer == nil) {
            
            //}
            //Makes sure a value is selected from picklist
            [self.repPicker selectRow:0 inComponent:0 animated:NO];
            [self.timer1Picker selectRow:1 inComponent:1 animated:NO];
            [self.timer2Picker selectRow:1 inComponent:1 animated:NO];
            [self.soundNamePicker selectRow:0 inComponent:0 animated:NO];
            
            //Runs pickerview didselect row to update labels on the screen
            [self pickerView:self.repPicker didSelectRow:0 inComponent:0];
            [self pickerView:self.timer1Picker didSelectRow:1 inComponent:1];
            [self pickerView:self.timer2Picker didSelectRow:1 inComponent:1];
            [self pickerView:self.soundNamePicker didSelectRow:0 inComponent:0];
            
            _bNotFirstTime = YES;
            
            //_iVolume = 0.5f;
            //_iVolume = [[AVAudioSession sharedInstance] outputVolume];
            
            //NSLog([[AVAudioSession sharedInstance] outputVolume]);
            
            //[self.playButton setEnabled:NO];
            //[self.playButton setTintColor:[UIColor clearColor]];
        }
    }
    

    
    
    //_dimScreenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    
    
    //[[UIScrollView appearance] setBackgroundColor:[UIColor colorWithRed:215/255 green:222/255 blue:226/255 alpha:1]];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Helpers
- (void) scrollToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];    
}
 */


//This includes both Pickers and Text Fields delegation
/*
- (void)definePickerState {
    self.repPicker.dataSource = self;
    self.repPicker.delegate = self;
    //self.repPicker.hidden = true;
    
    self.timer1Picker.dataSource = self;
    self.timer1Picker.delegate = self;
    //self.timer1Picker.hidden = true;
    
    self.timer2Picker.dataSource = self;
    self.timer2Picker.delegate = self;
    //self.timer2Picker.hidden = true;
    
    
    self.soundNamePicker.dataSource = self;
    self.soundNamePicker.delegate = self;
    //self.soundNamePicker.hidden = true;
    
    //self.repNameTextField.delegate = self;
}
*/
//hide the text field when not active
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //[textField setBackgroundColor:[UIColor blueColor]];
    return NO; 
}

//Set the values for the picklists
//The values for the rep picklist, timer picklists and sound picklists are set here

- (void)definePickerData {

    
    int i;
    
    NSMutableArray *minTmp = [NSMutableArray array];
    NSMutableArray *secTmp = [NSMutableArray array];
    NSMutableArray *repTmp = [NSMutableArray array];
    
    
    
    //_aNumRepsPickListValues = @[@"1", @"2", @"3"];
    
    for (i = 0; i <= 59; i++) {
        NSString *x = [NSString stringWithFormat:@"%d", i];
        [minTmp addObject:x];
        if (i % 5 == 0) {
            [secTmp addObject:x];
        }
        if (i < 60 && i > 0) {
            [repTmp addObject:x];
        }
    }
    
    _aMin = [minTmp copy];
    _aSec = [secTmp copy];
    
    self.aNumRepsPickListValues = [repTmp copy];
    self.aTimer1PickListValues = @[[_aMin copy], [_aSec copy]];
    self.aTimer2PickListValues = @[[_aMin copy], [_aSec copy]];
    self.aSoundPickListValues = @[@"Temple Bell", @"Whistle"];

    
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
}


#pragma  mark - buttons

/*
-(void)configureButtons {
    [_timerTotalLabel setBackgroundColor:[UIColor clearColor]];
    _saveButton.layer.borderWidth = 1.0f;
    _saveButton.layer.cornerRadius = 8.0f;
    
    if (_saveViewIsShowing == true && _tmpTimer == nil) {
        [_playButton setEnabled:NO];
        //[_playButton setTintColor: [UIColor clearColor]];
        
        
    } else if (_saveViewIsShowing == false) {
        [_rewindButton setEnabled:NO];
        //[_rewindButton setTintColor: [UIColor clearColor]];
    }
    
}
*/

-(void)populateTimer {
    
    if (_saveViewIsShowing == YES) {
        if ([_repNameTextField.text length] == 0) {
            _tmpTimer.sTimerName = _repNameTextField.placeholder;
            _repNameTextField.text = _repNameTextField.placeholder;
        } else {
            _tmpTimer.sTimerName = _repNameTextField.text;
        }
    } else {
        _tmpTimer.sTimerName = @"Manual Timer";
    }

    
    _tmpTimer.iNumReps = self.iNumRep;
    _tmpTimer.iRepLen1 = self.iLenOfTimer1;
    _tmpTimer.iRepLen2 = self.iLenOfTimer2;
    //_tmpTimer.bDimScreen = self.dimScreenSwitch.on;
    _tmpTimer.sRepSoundName= self.sSoundName;
    _tmpTimer.sRepSoundExtension = self.sSoundNameExtension;
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"Save button pressed");
    
    [self populateTimer];
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    if ([[app timers] containsObject:_tmpTimer]) {
        NSLog(@"value already in timer");
        
    } else {
        [[app timers] addObject:_tmpTimer];
        [_playButton setEnabled:YES];
        [_playButton setTintColor:nil];
        
    }
    
    [app saveTimersData];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_saveButton
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_saveButton
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];

    
    //[[app timers] addObject:_tmpTimer];
    
    //
    
}



#pragma mark - Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 9;
    } else if (section == 2) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
        
        _totalLength = [[UILabel alloc] init];
        
        _totalLength.text = [NSString stringWithFormat:@"Timer Length: %02li:%02li", (_iNumRep * (_iLenOfTimer1) / 60 + (_iNumRep-1) * _iLenOfTimer2 / 60), (_iNumRep * _iLenOfTimer1 + (_iNumRep-1) *_iLenOfTimer2) % 60];
        
        _totalLength.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell.contentView addSubview:_totalLength];
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell.contentView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell.contentView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        
        //width
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:200]];
        
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Rep Name";
            cell.detailTextLabel.hidden = YES;
            [[cell viewWithTag:3] removeFromSuperview];
            
            _repNameTextField = [[UITextField alloc] init];
            
            _repNameTextField.tag = 3;
            
            if ([_tmpTimer.sTimerName isEqualToString:@""] || _tmpTimer.sTimerName == nil) {
                _repNameTextField.placeholder = _sPlaceholderValue;
            } else {
                _repNameTextField.text = _tmpTimer.sTimerName;
            }
            
            _repNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:_repNameTextField];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            
            _repNameTextField.textAlignment = NSTextAlignmentRight;
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Number of Reps";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)_iNumRep];
            return cell;
        } else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
            
            _repPicker = [[UIPickerView alloc] init];
            _repPicker.hidden = YES;
            
            [_repPicker setDelegate:self];
            [cell addSubview:_repPicker];
            
            
            //center x
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repPicker
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repPicker
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            
            return cell;
        } else if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Rep Length";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer1min, (long)_iLenOfTimer1sec];
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
            
            
            _timer1Picker = [[UIPickerView alloc] init];
            _timer1Picker.hidden = YES;
            
            [_timer1Picker setDelegate:self];
            [cell addSubview:_timer1Picker];
            
            //center x
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer1Picker
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer1Picker
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            return cell;
        } else if (indexPath.row == 5) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Transition Length";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer2min, (long)_iLenOfTimer2sec];
            return cell;
        } else if (indexPath.row == 6) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
            
            
            _timer2Picker = [[UIPickerView alloc] init];
            _timer2Picker.hidden  = YES;
            
            [_timer2Picker setDelegate:self];
            [cell addSubview:_timer2Picker];
            
            //center x
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer2Picker
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer2Picker
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            return cell;
        } else if (indexPath.row == 7) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Sound";
            cell.detailTextLabel.text = [NSString stringWithFormat:@""];
            return cell;
        } else if (indexPath.row == 8) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
            
            _soundNamePicker = [[UIPickerView alloc] init];
            _soundNamePicker.hidden = YES;
            
            [_soundNamePicker setDelegate:self];
            [cell addSubview:_soundNamePicker];
            
            //center x
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_soundNamePicker
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_soundNamePicker
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            return cell;
            
        }
    } else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _saveButton.layer.borderWidth = 1.0f;
        _saveButton.layer.cornerRadius = 8.0f;
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setTitle:@"Save" forState:UIControlStateSelected];
        [_saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:_saveButton];
        //center x
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_saveButton
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell.contentView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
        
        //center y
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_saveButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell.contentView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        
        
        
        
        //width
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_saveButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:100]];
        
        //height
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_saveButton
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:40]];
        
        return cell;
    }
    
    
    NSLog(@"A cell is not defined");
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.section == cTimerSectionIndex) {
        
        if (indexPath.row == cRepPickerIndex){
            //height = self.repPickerIsShowing ? cPickerCellHeight : 0.0f;
            height = cPickerCellHeight;
            
            
        } else if (indexPath.row == cTimer1PickerIndex){
            //height = self.timer1PickerIsShowing ? cPickerCellHeight : 0.0f;
            height = cPickerCellHeight;
        } else if (indexPath.row == cTimer2PickerIndex){
            
            //height = self.timer2PickerIsShowing ? cPickerCellHeight : 0.0f;
            height = cPickerCellHeight;
            
        } else if (indexPath.row == cSoundPickerIndex) {
            //height = self.soundPickerIsShowing ? cPickerCellHeight : 0.0f;
            height = cPickerCellHeight;
        //} else if (indexPath.row == cSaveIndex || indexPath.row == cNameIndex) {
        //    //height = self.saveViewIsShowing ? cDefaultTableHeight : 0.0f;
        //    height = cPickerCellHeight;
        } else {
            height = cDefaultTableHeight;
        }
    } else {
        height = cDefaultTableHeight;
    }
    
    return height;
}


//hides and unhides rows based on where it is clicked
//if any additional rows are added, it needs to be coded per if condition


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section == cTimerSectionIndex) {
        if (indexPath.row == cRepPickerIndex - 1){
            if (self.repPickerIsShowing){
                [self hidePickerCell:_repPicker];
                
            }else {
                
                if (self.timer1PickerIsShowing == YES) {
                    [self hidePickerCell:_timer1Picker];
                }
                
                if (self.timer2PickerIsShowing == YES) {
                    [self hidePickerCell:_timer2Picker];
                }
                
                if (self.soundPickerIsShowing == YES) {
                    [self hidePickerCell:_soundNamePicker];
                }
                
                [self.activeTextField resignFirstResponder];
                
                [self showPickerCell:_repPicker];
            }
        }
        
        if (indexPath.row == cTimer1PickerIndex - 1){
            
            if (self.timer1PickerIsShowing){
                
                [self hidePickerCell:_timer1Picker];
                
            }else {
                
                if (self.repPickerIsShowing == YES) {
                    [self hidePickerCell:_repPicker];
                }
                
                if (self.timer2PickerIsShowing == YES) {
                    [self hidePickerCell:_timer2Picker];
                }
                
                if (self.soundPickerIsShowing == YES) {
                    [self hidePickerCell:_soundNamePicker];
                }

                
                [self.activeTextField resignFirstResponder];
                
                [self showPickerCell:_timer1Picker];
            }
        }
        
        if (indexPath.row == cTimer2PickerIndex - 1){
            
            if (self.timer2PickerIsShowing){
                
                [self hidePickerCell:_timer2Picker];
                
            }else {
                
                if (self.timer1PickerIsShowing == YES) {
                    [self hidePickerCell:_timer1Picker];
                }
                
                if (self.repPickerIsShowing == YES) {
                    [self hidePickerCell:_repPicker];
                }
                
                if (self.soundPickerIsShowing == YES) {
                    [self hidePickerCell:_soundNamePicker];
                }

                
                [self.activeTextField resignFirstResponder];
                [self showPickerCell:_timer2Picker];
            }
        }
        
        if (indexPath.row == cSoundPickerIndex - 1){
            
            if (self.soundPickerIsShowing){
                
                [self hidePickerCell:_soundNamePicker];
                
            }else {
                
                if (self.timer1PickerIsShowing == YES) {
                    [self hidePickerCell:_timer1Picker];
                }
                
                if (self.timer2PickerIsShowing == YES) {
                    [self hidePickerCell:_timer1Picker];
                }
                
                if (self.repPickerIsShowing == YES) {
                    [self hidePickerCell:_repPicker];
                }
                
                
                [self.activeTextField resignFirstResponder];
                [self showPickerCell:_soundNamePicker];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     
     */
}

//updates the booleans for which cell is now showing
- (void)showPickerCell:(UIPickerView *)picker {
    
    /*
    if (picker == _repPicker) {
        self.repPickerIsShowing = YES;
    //} else if (picker == _timer1Picker) {
    //    self.timer1PickerIsShowing = YES;
    } else if (picker == _timer2Picker) {
        self.timer2PickerIsShowing = YES;
    } else if (picker == _soundNamePicker) {
        self.soundPickerIsShowing = YES;
    } else {
        NSLog(@"Problem with the picker that was passed to showPickerCell");
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    picker.hidden = NO;
    picker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        picker.alpha = 1.0f;
        
    }];
     */
}

//updates the booleans for which cell is now hidden
- (void)hidePickerCell:(UIPickerView *)picker {
    
    if (picker == _repPicker) {
        self.repPickerIsShowing = NO;
    } else if (picker == _timer1Picker) {
        self.timer1PickerIsShowing = NO;
    } else if (picker == _timer2Picker) {
        self.timer2PickerIsShowing = NO;
    } else if (picker == _soundNamePicker) {
        self.soundPickerIsShowing = NO;
    } else {
        NSLog(@"Hah? There is a problem with the picker that was passed to showPickerCell");
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         picker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         picker.hidden = YES;
                     }];
}


#pragma mark - picker

//gives back the number of columns in a picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual: self.repPicker]) {
        return 1;
    }
    
    else if ([pickerView isEqual: self.timer1Picker] || [pickerView isEqual: self.timer2Picker]) {
        return 2;
    }
    else if ([pickerView isEqual: self.soundNamePicker]) {
        return 1;
    }
    else {
        return 0;
    }
}

//gives back the number of rows in a picker
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual: self.repPicker]) {
        return _aNumRepsPickListValues.count;
        //return [_numberOfReps objectAtIndex:row];
    } else if ([pickerView isEqual: self.timer1Picker] || [pickerView isEqual: self.timer2Picker]) {
        if (component == 0) {
            return _aMin.count;
        } else {
            return _aSec.count;
        }
    } else if ([pickerView isEqual: self.soundNamePicker]) {
        return _aSoundPickListValues.count;
    } else {
        return 1;
    }

    

}


//Set the values for the pickers and set the color
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([thePickerView isEqual: self.repPicker]) {
        return _aNumRepsPickListValues[row];
    }
    else if ([thePickerView isEqual: self.timer1Picker])  {
        return _aTimer1PickListValues[component][row];
    } else if ([thePickerView isEqual: self.timer2Picker]) {
        return _aTimer2PickListValues[component][row];
    } else if ([thePickerView isEqual: self.soundNamePicker]) {
       return _aSoundPickListValues[row];
        
    }
    
    return nil;
        
    
    
}

/*

 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
 
     UILabel *label = [[UILabel alloc] init];
     NSString *tmp = [[NSString alloc] init];
     
     //label.backgroundColor = [UIColor blueColor];
     //label.textColor = [UIColor whiteColor];
     //label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
     label.font = [UIFont systemFontOfSize:22];
     
     label.textAlignment = NSTextAlignmentCenter;
     //[uView addSubview:label];
     
     if ([pickerView isEqual: self.repPicker]) {
         tmp = _aNumRepsPickListValues[row];
     }
     else if ([pickerView isEqual: self.timer1Picker])  {
         tmp = _aTimer1PickListValues[component][row];
     } else if ([pickerView isEqual: self.timer2Picker]) {
         tmp = _aTimer2PickListValues[component][row];
     } else if ([pickerView isEqual: self.soundNamePicker]) {
         tmp = _aSoundPickListValues[row];
         
     } else {
         tmp = nil;
         
     }
     
     label.text = tmp;
     
     //[uView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
     return label;
 }
 
 */
// This method is triggered whenever the user makes a change to the picker selection.
// The parameter named row and component represents what was selected.

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
    NSString *tmp1;
    
    
    if ([pickerView isEqual: self.repPicker]) {
        tmp1 = [self.aNumRepsPickListValues objectAtIndex:[self.repPicker selectedRowInComponent:component]];
        _iNumRep = [tmp1 intValue];
        _numLabel.text = [NSString stringWithFormat:@"%@", tmp1];
        
        
    } else if ([pickerView isEqual: self.timer1Picker]) {
        if (component == 0) {
            tmp1 = self.aTimer1PickListValues[component][row];
            
            _iLenOfTimer1min = [tmp1 integerValue];
        } else {
            tmp1 = self.aTimer1PickListValues[component][row];
            _iLenOfTimer1sec = [tmp1 integerValue];
        }
        _iLenOfTimer1 = _iLenOfTimer1min * 60 + _iLenOfTimer1sec;
        _timer1Label.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer1min, (long)_iLenOfTimer1sec];
        
        
    } else if ([pickerView isEqual: self.timer2Picker]) {
        if (component == 0) {
            tmp1 = self.aTimer2PickListValues[component][row];
            _iLenOfTimer2min = [tmp1 integerValue];
        } else {
            tmp1 = self.aTimer2PickListValues[component][row];
            _iLenOfTimer2sec = [tmp1 integerValue];
        }
        
        _iLenOfTimer2 = _iLenOfTimer2min * 60 + _iLenOfTimer2sec;
        _timer2Label.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer2min, (long)_iLenOfTimer2sec];
    } else if ([pickerView isEqual: self.soundNamePicker]) {
        tmp1 = [self.aSoundPickListValues objectAtIndex:[self.soundNamePicker selectedRowInComponent:component]];
        
        _sSoundName = tmp1;
        _sSoundNameExtension = @"aiff";
        _soundNameLabel.text = [NSString stringWithFormat:@"%@", tmp1];
        
        
    }
    
    
    self.navigationItem.title = @"Custom Timer";
    
    */
}

 



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ViewTimer"]) {
        
        UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
        ViewTimerTableViewController *dest = [[dc viewControllers] lastObject];
        
        [self populateTimer];
         
        anExerciseSet *tmpExerciseSet = [[anExerciseSet alloc] init];
        
        
        if (_saveViewIsShowing == YES) {
            if (_tmpTimer.sTimerName != nil || [_tmpTimer.sTimerName length] != 0) {
                tmpExerciseSet.sSetName = _tmpTimer.sTimerName;
            } else {
                tmpExerciseSet.sSetName = @"Preset Timer";
                _tmpTimer.sTimerName = @"Preset Timer";
            }
        } else {
            tmpExerciseSet.sSetName = @"Manual Timer";
            _tmpTimer.sTimerName = @"Manual Timer";
        }
        
        [tmpExerciseSet.aExercises addObject:_tmpTimer];
        
        //[dest setTmpTimer:_tmpTimer];
        [dest setExerciseSet:tmpExerciseSet];

        
       
        
        //[dest setIVolume: _iVolume];

        
    }

}



@end
