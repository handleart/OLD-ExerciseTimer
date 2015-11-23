//
//  SetTimerNewTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 9/6/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "SetTimerNewTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "SetTimerNewTableViewController.h"
#import "ViewTimerTableViewController.h"
#import "AppDelegate.h"
#import "anExerciseSet.h"



@interface SetTimerNewTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property NSString *sPlaceholderValue;

@property  UIPickerView *soundNamePicker;
@property  UIPickerView *repPicker;
@property UIPickerView *timer1Picker;
@property UIPickerView *timer2Picker;

@property UILabel *totalLength;
@property UITextField *repNameTextField;
@property UIButton *saveButton;

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
@property NSString *sTotalLength;

@property NSInteger nameRow;
@property NSInteger repRow;
@property NSInteger timer1Row;
@property NSInteger timer2Row;
@property NSInteger soundRow;
@property NSInteger pickerRow;
@property NSInteger lastPickerRow;
@property BOOL pickerIsShowing;

@property NSInteger totalLengthSectionIndex;
@property NSInteger timerSectionIndex;
@property NSInteger saveSectionIndex;

@end

@implementation SetTimerNewTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self definePickerData];
    
    _totalLengthSectionIndex = 0;
    _timerSectionIndex = 1;
    _saveSectionIndex = 2;
    
    //self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if (_saveViewIsShowing == NO && _addViewIsShowing == NO) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    } else if (_addViewIsShowing == YES) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else if (_tmpTimer != nil) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    
    if (_saveViewIsShowing == NO && _addViewIsShowing == NO) {
        
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blueColor];
        self.navigationItem.leftBarButtonItem.enabled = NO;
       // NSLog(@"blue color");
    } else {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        //NSLog(@"white color");
    }

    
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.navigationItem.title = @"Manual Timer";
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _sPlaceholderValue = [NSString stringWithFormat:@"Preset Timer %lu", (long)[[app timers] count] + 1];
    
    _repPicker = [[UIPickerView alloc] init];
    _repPicker.translatesAutoresizingMaskIntoConstraints = NO;
    _repPicker.hidden = YES;
    _repPicker.showsSelectionIndicator = YES;
    
    _timer1Picker = [[UIPickerView alloc] init];
    _timer1Picker.translatesAutoresizingMaskIntoConstraints = NO;
    _timer1Picker.hidden = YES;
    
    _timer2Picker = [[UIPickerView alloc] init];
    _timer2Picker.translatesAutoresizingMaskIntoConstraints = NO;
     _timer2Picker.hidden = YES;
    
    _soundNamePicker = [[UIPickerView alloc] init];
    _soundNamePicker.translatesAutoresizingMaskIntoConstraints = NO;
    _soundNamePicker.hidden = YES;
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveButton.layer.borderWidth = 1.0f;
    _saveButton.layer.cornerRadius = 8.0f;
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _repNameTextField = [[UITextField alloc] init];
    
    _repNameTextField.tag = 3;
    
    if ([_tmpTimer.sTimerName isEqualToString:@""] || _tmpTimer.sTimerName == nil) {
        _repNameTextField.placeholder = _sPlaceholderValue;
    } else {
        _repNameTextField.text = _tmpTimer.sTimerName;
    }
    
    _repNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    

    if (_addViewIsShowing == YES) {
        [_saveButton setTitle:@"Add" forState:UIControlStateNormal];
        [_saveButton setTitle:@"Add" forState:UIControlStateSelected];
    } else {
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setTitle:@"Save" forState:UIControlStateSelected];
    }



    [_saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    _totalLength = [[UILabel alloc] init];
    
    if (_tmpTimer != nil) {
        //rep number
        //pickerRow = _repRow;
        
        _iNumRep = _tmpTimer.iNumReps;
        
        //Timer 1
        _pickerRow = _timer1Row;
        _iLenOfTimer1min = _tmpTimer.iRepLen1 / 60;
        _iLenOfTimer1sec = _tmpTimer.iRepLen1 % 60;
        
        //Timer 2
        _pickerRow = _timer2Row;
        _iLenOfTimer2min = _tmpTimer.iRepLen2 / 60;
        _iLenOfTimer2sec  = _tmpTimer.iRepLen2 % 60;
        NSUInteger iLen2IndexMin = [_aMin indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer2min]];
        NSUInteger iLen2IndexSec = [_aSec indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer2sec]];
        [self.timer2Picker selectRow:iLen2IndexMin inComponent:0 animated:NO];
        [self.timer2Picker selectRow:iLen2IndexSec inComponent:1 animated:NO];
        
        _sSoundName = _tmpTimer.sRepSoundName;

    } else {
        _tmpTimer = [[aTimer alloc] init];
        //only runs on initial load of the page -- which is the same as when _tmpTimer has not been init
        if (_bNotFirstTime != YES) {
            [_playButton setEnabled:YES];

            _iNumRep = 1;
            _iLenOfTimer1min = 0;
            _iLenOfTimer1sec = 5;
            
            _iLenOfTimer2min = 0;
            _iLenOfTimer2sec = 5;
            //Runs pickerview didselect row to update labels on the screen
            _sSoundName = [_aSoundPickListValues objectAtIndex:0];
            
            _bNotFirstTime = YES;
            
        }
    }
    

    
    _pickerIsShowing = false;
    
    //Be careful changing the -1 value for _nameRow. It is used throughout this page to change the rows
    if (_addViewIsShowing == YES || _saveViewIsShowing == YES) {
        _nameRow = 0;
    } else {
        _nameRow = -1;
    }
    
    
    _repRow = 1 + _nameRow;
    _timer1Row = 2 + _nameRow;
    _timer2Row = 3 + _nameRow;
    _soundRow = 4 + _nameRow;
    _pickerRow = 5 + _nameRow;
    
    _iLenOfTimer1 = _iLenOfTimer1min * 60 + _iLenOfTimer1sec;
    _iLenOfTimer2 = _iLenOfTimer2min * 60 + _iLenOfTimer2sec;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - button / field actions

- (IBAction)playButtonPressed:(id)sender {
    // using the navigation pragma section
}


- (IBAction)backButtonPressed:(id)sender {
    
    if (_addViewIsShowing == YES) {
        [self performSegueWithIdentifier:@"unwindToCreateExerciseSetWithoutSave" sender:self];
    } else if (_saveViewIsShowing == YES) {
        //[self performSegueWithIdentifier:@"unwindToChooseTimer" sender:self];
        
        UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];
        
        tvc.selectedIndex = 1;
        
        //CreateExerciseSetTableViewController *lvc =[[nc viewControllers] objectAtIndex:0];
        
        
        
        
        
        
        UIStoryboardSegue *segue =
        [UIStoryboardSegue segueWithIdentifier:@"TabBarViewPage2"
                                        source:self
                                   destination:tvc
                                performHandler:^{
                                    [self.navigationController presentViewController:tvc animated:NO completion: nil];
                                    
                                    // transition code that would
                                    // normally go in the perform method
                                }];
        
        [self prepareForSegue:segue sender:self];
        
        [segue perform];
    } else {

    }
    
}

- (IBAction)saveButtonPressed:(id)sender {
    [self populateTimer];
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    if ([[app timers] containsObject:_tmpTimer]) {
        //NSLog(@"value already in timer");
        
    } else {
        [[app timers] addObject:_tmpTimer];
        [_playButton setEnabled:YES];
        [_playButton setTintColor:nil];
        if (_saveViewIsShowing) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        }
    }

    
    [app saveTimersData];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_saveButton
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_saveButton
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];

    
    if (_addViewIsShowing == YES) {
        [self performSegueWithIdentifier:@"unwindToCreateExerciseSet" sender:self];
    }
    
    [self.tableView reloadData];
}

//hide the text field when not active
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //[textField setBackgroundColor:[UIColor blueColor]];
    return NO;
}

#pragma mark - helpers

-(void)populateTimer {
    if (_saveViewIsShowing == YES || _addViewIsShowing == YES) {
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
    _tmpTimer.sRepSoundExtension = @"aiff";
    
}

- (void)definePickerData {
    int i;
    
    NSMutableArray *minTmp = [NSMutableArray array];
    NSMutableArray *secTmp = [NSMutableArray array];
    NSMutableArray *repTmp = [NSMutableArray array];
    
    for (i = 0; i <= 59; i++) {
        NSString *x = [NSString stringWithFormat:@"%d", i];
        
        if (i < 10)
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
    
    _aNumRepsPickListValues = [repTmp copy];
    _aTimer1PickListValues = @[[_aMin copy], [_aSec copy]];
    _aTimer2PickListValues = @[[_aMin copy], [_aSec copy]];
    _aSoundPickListValues = @[@"Temple Bell", @"Whistle"];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_saveViewIsShowing == YES || _addViewIsShowing) {
        return 3;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {;
    if (section == _timerSectionIndex) {
        if (_pickerIsShowing == YES) {
            return 6 + _nameRow;
        } else {
            return 5 + _nameRow;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _timerSectionIndex && indexPath.row != _pickerRow) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPrototypeCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == _timerSectionIndex && indexPath.row == _pickerRow) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerPrototypeCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == _totalLengthSectionIndex){
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPrototypeCell" forIndexPath:indexPath];
        //cell.textLabel.text = @"Total Length";
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"Timer Length: %02li:%02li", (long)((_iNumRep * (_iLenOfTimer1) / 60 + (_iNumRep-1) * _iLenOfTimer2 / 60)), (long)((_iNumRep * _iLenOfTimer1 + (_iNumRep-1) *_iLenOfTimer2) % 60)];
        
        
        return cell;
        
        /*
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
                                                         attribute:NSLayoutAttributeCenterYWithinMargins
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
        
        */
         return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == _totalLengthSectionIndex && indexPath.row == 0) {
        cell.textLabel.text = @"Timer Length";
        //cell.detailTextLabel.text = @"Hello";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)((_iNumRep * (_iLenOfTimer1) / 60 + (_iNumRep-1) * _iLenOfTimer2 / 60)), (long)((_iNumRep * _iLenOfTimer1 + (_iNumRep-1) *_iLenOfTimer2) % 60)];

//        _totalLength.text = [NSString stringWithFormat:@"Timer Length: %02li:%02li", (_iNumRep * (_iLenOfTimer1) / 60 + (_iNumRep-1) * _iLenOfTimer2 / 60), (_iNumRep * _iLenOfTimer1 + (_iNumRep-1) *_iLenOfTimer2) % 60];
//        
//        
//        _totalLength.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [cell.contentView addSubview:_totalLength];
//        
//        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
//                                                         attribute:NSLayoutAttributeCenterX
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:cell.contentView
//                                                         attribute:NSLayoutAttributeCenterX
//                                                        multiplier:1.0
//                                                          constant:0]];
//        
//        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
//                                                         attribute:NSLayoutAttributeCenterY
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:cell.contentView
//                                                         attribute:NSLayoutAttributeCenterYWithinMargins
//                                                        multiplier:1.0
//                                                          constant:0]];
//        
//        //width
//        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_totalLength
//                                                         attribute:NSLayoutAttributeWidth
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:nil
//                                                         attribute:NSLayoutAttributeWidth
//                                                        multiplier:1.0
//                                                          constant:200]];
        
    //} else if (indexPath.section == _saveSectionIndex && indexPath.row == 0) {
    } else if (indexPath.section == _saveSectionIndex) {
        
        //_saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
//        _saveButton.layer.borderWidth = 1.0f;
//        _saveButton.layer.cornerRadius = 8.0f;
//        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        if (_addViewIsShowing == YES) {
//            [_saveButton setTitle:@"Add" forState:UIControlStateNormal];
//            [_saveButton setTitle:@"Add" forState:UIControlStateSelected];
//        } else {
//            [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
//            [_saveButton setTitle:@"Save" forState:UIControlStateSelected];
//        }
//        
//        
//        
//        [_saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    } else if (indexPath.section ==  _timerSectionIndex) {
        if (indexPath.row == _nameRow) {
            cell.textLabel.text = @"Rep Name";
            cell.detailTextLabel.hidden = YES;
            [[cell viewWithTag:3] removeFromSuperview];
//            
//            _repNameTextField = [[UITextField alloc] init];
//            
//            _repNameTextField.tag = 3;
//            
//            if ([_tmpTimer.sTimerName isEqualToString:@""] || _tmpTimer.sTimerName == nil) {
//                _repNameTextField.placeholder = _sPlaceholderValue;
//            } else {
//                _repNameTextField.text = _tmpTimer.sTimerName;
//            }
//            
//            _repNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:_repNameTextField];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repNameTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            
            _repNameTextField.textAlignment = NSTextAlignmentRight;
        } else if (indexPath.row == _pickerRow) {
            //if rep picker
            if (_pickerRow == 2 + _nameRow) {
                _repPicker.hidden = NO;
                _timer1Picker.hidden = YES;
                _timer2Picker.hidden = YES;
                _soundNamePicker.hidden = YES;

                [_repPicker setDelegate:self];
                
                NSUInteger repIndex = [_aNumRepsPickListValues indexOfObject:[NSString stringWithFormat:@"%li", (long)_iNumRep]];
                
                
                [self.repPicker selectRow:repIndex inComponent:0 animated:NO];

                
                [cell addSubview:_repPicker];
                
                //center x
                
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repPicker
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
                
                //center y
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_repPicker
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
            
            } else if (_pickerRow == 3 + _nameRow ) {
                //if timer 1 picker
                _repPicker.hidden = YES;
                _timer1Picker.hidden = NO;
                _timer2Picker.hidden = YES;
                _soundNamePicker.hidden = YES;
                
                [_timer1Picker setDelegate:self];
                
                NSUInteger iLen1IndexMin = [_aMin indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer1min]];
                NSUInteger iLen1IndexSec = [_aSec indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer1sec]];
                
                [self.timer1Picker selectRow:iLen1IndexMin inComponent:0 animated:NO];
                [self.timer1Picker selectRow:iLen1IndexSec inComponent:1 animated:NO];

                
                
                [cell addSubview:_timer1Picker];
                
                //center x
                
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer1Picker
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
                
                //center y
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer1Picker
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
                
            } else if (_pickerRow == 4 + _nameRow) {
                //if timer 2 picker
                _repPicker.hidden = YES;
                _timer1Picker.hidden = YES;
                _timer2Picker.hidden = NO;
                _soundNamePicker.hidden = YES;
                
                [_timer2Picker setDelegate:self];
                
                NSUInteger iLen2IndexMin = [_aMin indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer2min]];
                NSUInteger iLen2IndexSec = [_aSec indexOfObject:[NSString stringWithFormat:@"%li", (long)_iLenOfTimer2sec]];
                
                [self.timer2Picker selectRow:iLen2IndexMin inComponent:0 animated:NO];
                [self.timer2Picker selectRow:iLen2IndexSec inComponent:1 animated:NO];
                
                [cell addSubview:_timer2Picker];
                
                //center x
                
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer2Picker
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
                
                //center y
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_timer2Picker
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
            
            } else if (_pickerRow == 5 + _nameRow ) {
                _repPicker.hidden = YES;
                _timer1Picker.hidden = YES;
                _timer2Picker.hidden = YES;
                _soundNamePicker.hidden = NO;
                
                [_soundNamePicker setDelegate:self];
                
                NSUInteger iSoundIndex = [_aSoundPickListValues indexOfObject:_sSoundName];
                
                [self.soundNamePicker selectRow:iSoundIndex inComponent:0 animated:NO];
                
                [cell addSubview:_soundNamePicker];
                
                //center x
                
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_soundNamePicker
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
                
                //center y
                [cell addConstraint:[NSLayoutConstraint constraintWithItem:_soundNamePicker
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:[cell.contentView superview]
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
            }
        
        } else if (indexPath.row  == _repRow) {
            cell.textLabel.text = @"Number of Reps";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)_iNumRep];
        } else if (indexPath.row  == _timer1Row) {
            cell.textLabel.text = @"Rep Length";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer1min, (long)_iLenOfTimer1sec];
        } else if (indexPath.row  == _timer2Row) {
            cell.textLabel.text = @"Transition / Break Length";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer2min, (long)_iLenOfTimer2sec];
        } else if (indexPath.row  == _soundRow) {
            cell.textLabel.text = @"Sound Name";
            cell.detailTextLabel.text = _sSoundName;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == _timerSectionIndex) {
        if (indexPath.row == _pickerRow - 1 && _pickerIsShowing == YES) {
            //(if _saveViewIsShowing == YES || _addViewIsShowing == YES) {
                //_nameRow = 0;
            //}
            _repRow = 1 + _nameRow;
            _timer1Row = 2 + _nameRow;
            _timer2Row = 3  + _nameRow;
            _soundRow = 4  + _nameRow;
            _pickerRow = 6  + _nameRow;
            _pickerIsShowing = NO;
        } else if (indexPath.row == _repRow) {
//            _nameRow = 0;
            _repRow = 1 + _nameRow;
            _timer1Row = 3 + _nameRow;
            _timer2Row = 4 + _nameRow;
            _soundRow = 5 + _nameRow;
            _pickerRow =  2 + _nameRow;
            _pickerIsShowing = YES;
        } else if (indexPath.row == _timer1Row) {
//            _nameRow = 0;
            _repRow = 1 + _nameRow;
            _timer1Row = 2 + _nameRow;
            _timer2Row = 4 + _nameRow;
            _soundRow = 5 + _nameRow;
            _pickerRow = 3 + _nameRow;
            _pickerIsShowing = YES;
        } else if (indexPath.row == _timer2Row) {
//            _nameRow = 0;
            _repRow = 1 + _nameRow;
            _timer1Row = 2 + _nameRow;
            _timer2Row = 3 + _nameRow;
            _soundRow = 5 + _nameRow;
            _pickerRow = 4 + _nameRow;
            _pickerIsShowing = YES;
        } else if (indexPath.row == _soundRow)   {
//            _nameRow = 0;
            _repRow = 1 + _nameRow;
            _timer1Row = 2 + _nameRow;
            _timer2Row = 3 + _nameRow;
            _soundRow = 4 + _nameRow;
            _pickerRow = 5 + _nameRow;
            _pickerIsShowing = YES;
        } else {
            
        }
    } else {
        
    }


    [tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //CGFloat height = self.tableView.rowHeight;
    CGFloat height;
    
    
    if (indexPath.section == _timerSectionIndex && indexPath.row == _pickerRow) {
        //height = self.pickerIsShowing ? 180 : 0.0f;
        height = 180;
    } else {
        height = 50;
    }
    
    return height;
}

#pragma mark - picker

//gives back the number of columns in a picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual: _repPicker]) {
        return 1;
    }
    
    else if ([pickerView isEqual: _timer1Picker] || [pickerView isEqual: _timer2Picker]) {
        return 2;
    }
    else if ([pickerView isEqual: _soundNamePicker]) {
        return 1;
    }
    else {
        return 0;
    }
}

//gives back the number of rows in a picker
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual: _repPicker]) {
        return _aNumRepsPickListValues.count;
        //return [_numberOfReps objectAtIndex:row];
    } else if ([pickerView isEqual: _timer1Picker] || [pickerView isEqual: _timer2Picker]) {
        if (component == 0) {
            return _aMin.count;
        } else {
            return _aSec.count;
        }
    } else if ([pickerView isEqual: self.soundNamePicker]) {
        return _aSoundPickListValues.count;
    } else {
        return 0;
    }
}

//Set the values for the pickers
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *tmp1;
    
    NSIndexPath *cellAbovePickerIndexPath = [NSIndexPath indexPathForRow:(_pickerRow - 1) inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellAbovePickerIndexPath];

    
    if ([pickerView isEqual: self.repPicker]) {
        tmp1 = [self.aNumRepsPickListValues objectAtIndex:[self.repPicker selectedRowInComponent:component]];
        _iNumRep = [tmp1 intValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", tmp1];
    
    } else if ([pickerView isEqual: self.timer1Picker]) {
        if (component == 0) {
            tmp1 = self.aTimer1PickListValues[component][row];
            
            _iLenOfTimer1min = [tmp1 integerValue];
        } else {
            tmp1 = self.aTimer1PickListValues[component][row];
            _iLenOfTimer1sec = [tmp1 integerValue];
        }
        _iLenOfTimer1 = _iLenOfTimer1min * 60 + _iLenOfTimer1sec;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer1min, (long)_iLenOfTimer1sec];
    } else if ([pickerView isEqual: self.timer2Picker]) {
        if (component == 0) {
            tmp1 = self.aTimer2PickListValues[component][row];
            _iLenOfTimer2min = [tmp1 integerValue];
        } else {
            tmp1 = self.aTimer2PickListValues[component][row];
            _iLenOfTimer2sec = [tmp1 integerValue];
        }
        
        _iLenOfTimer2 = _iLenOfTimer2min * 60 + _iLenOfTimer2sec;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)_iLenOfTimer2min, (long)_iLenOfTimer2sec];
     } else if ([pickerView isEqual: self.soundNamePicker]) {
        tmp1 = [self.aSoundPickListValues objectAtIndex:[self.soundNamePicker selectedRowInComponent:component]];
        
        _sSoundName = tmp1;
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", tmp1];
    }
}



#pragma  mark - navigation
- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue {
    //ViewTimerTableViewController *source = [segue sourceViewController];
    //_iVolume = source.iVolume;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ViewTimer"]) {
        
        UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
        ViewTimerTableViewController *dest = [[dc viewControllers] lastObject];
        
        [self populateTimer];
        
        anExerciseSet *tmpExerciseSet = [[anExerciseSet alloc] init];

        //if (_saveViewIsShowing == YES) {
        if ((_tmpTimer.sTimerName != nil || [_tmpTimer.sTimerName length] != 0) && _saveViewIsShowing) {
            tmpExerciseSet.sSetName = _tmpTimer.sTimerName;
            [dest setSource:@"presetSetTimerView"];
        } else {
            tmpExerciseSet.sSetName = @"Manual Timer";
            _tmpTimer.sTimerName = @"Manual Timer";
            [dest setSource:@"TimerView"];
        }
        
        
        
        
        [tmpExerciseSet.aExercises addObject:_tmpTimer];
        [dest setExerciseSet:tmpExerciseSet];
        
        if (_saveViewIsShowing != YES && _addViewIsShowing != YES) {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.manualExerciseSets = [[NSMutableArray alloc] initWithObjects:@[tmpExerciseSet], nil];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"ManualTimer" forKey:@"lastPage"];
            
            [appDelegate saveTmpExerciseSetData];
            
            
        }
        
        
    } else if ([segue.identifier isEqualToString:@"unwindToCreateExerciseSetWithoutSave"]) {
        _tmpTimer = nil;
    } else if ([segue.identifier isEqualToString:@"unwindToCreateExerciseSet"]) {
        [self populateTimer];
    }
    
}


@end
