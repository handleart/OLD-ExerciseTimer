//
//  SetTimerTableViewController.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/20/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#define cRepPickerIndex 1
#define cTimer1PickerIndex 3
#define cTimer2PickerIndex 5
#define cSoundPickerIndex 8
#define saveIndex 9
#define cPickerCellHeight 162

#import "SetTimerTableViewController.h"
#import "ViewTimerTableViewController.h"
#import "AppDelegate.h"
#import "aTimer.h"

@interface SetTimerTableViewController ()


@property (weak, nonatomic) IBOutlet UISwitch *dimScreenSwitch;
@property (weak, nonatomic) IBOutlet UITextField *dimScreenLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *timer2Picker;
@property (weak, nonatomic) IBOutlet UITextField *timer2Label;
@property (weak, nonatomic) IBOutlet UIPickerView *timer1Picker;
@property (weak, nonatomic) IBOutlet UITextField *timer1Label;
@property (weak, nonatomic) IBOutlet UITextField *numLabel;
@property (weak, nonatomic) IBOutlet UITextField *soundNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;


@property (weak, nonatomic) IBOutlet UIPickerView *soundNamePicker;


@property (weak, nonatomic) IBOutlet UIPickerView *repPicker;


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

@property aTimer *tmpTimer;

//@property NSString* sFont = @"HelveticaNeue-Bold";


@end

@implementation SetTimerTableViewController


- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue {
    ViewTimerTableViewController *source = [segue sourceViewController];
    _iVolume = source.iVolume;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self definePickerData];
    [self definePickerState];
    
    
    _tmpTimer = [[aTimer alloc] init];
    
    //only runs on initial load of the page
    if (_bNotFirstTime != YES) {
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
        
        _iVolume = 0.5f;
        
        //NSLog([[AVAudioSession sharedInstance] outputVolume]);
        
        //[self.playButton setEnabled:NO];
        //[self.playButton setTintColor:[UIColor clearColor]];
        
    }
     
    //_dimScreenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    
    
    [[UIScrollView appearance] setBackgroundColor:[UIColor blueColor]];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
- (void) scrollToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];    
}

- (void)definePickerState {
    self.repPicker.dataSource = self;
    self.repPicker.delegate = self;
    self.repPicker.hidden = true;
    
    self.timer1Picker.dataSource = self;
    self.timer1Picker.delegate = self;
    self.timer1Picker.hidden = true;
    
    self.timer2Picker.dataSource = self;
    self.timer2Picker.delegate = self;
    self.timer2Picker.hidden = true;
    
    
    self.soundNamePicker.dataSource = self;
    self.soundNamePicker.delegate = self;
    self.soundNamePicker.hidden = true;
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

#pragma mark - Table view methods

//set the background color to blue for the table
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor blueColor];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    
    if (indexPath.row == cRepPickerIndex){
        
        height = self.repPickerIsShowing ? cPickerCellHeight : 0.0f;
        
    } else if (indexPath.row == cTimer1PickerIndex){
        
        height = self.timer1PickerIsShowing ? cPickerCellHeight : 0.0f;
        
    } else if (indexPath.row == cTimer2PickerIndex){
        
        height = self.timer2PickerIsShowing ? cPickerCellHeight : 0.0f;
        
    } else if (indexPath.row == cSoundPickerIndex) {
        height = self.soundPickerIsShowing ? cPickerCellHeight : 0.0f;
    } else {
        height = 80;
    }
    
    return height;
}


//hides and unhides rows based on where it is clicked
//if any additional rows are added, it needs to be coded per if condition

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)dimScreenSwitchPressed:(id)sender {
    
    if ([self.dimScreenSwitch isOn]) {
        //[self.dimScreenSwitch setOn:YES animated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        //_dimScreenLabel.text = @"Screen dims?";
        //_dimScreenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
        NSLog(@"Swtich is on");
    } else {
        //[self.dimScreenSwitch setOn:NO animated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        //_dimScreenLabel.text = @"Screen dims?";
        NSLog(@"Switch is off");
    }
    
}

- (IBAction)saveButtonClicked:(id)sender {
    NSLog(@"Save button pressed");
    
    
    _tmpTimer.timerName = @"Temp";
    _tmpTimer.iNumReps = self.iNumRep;
    _tmpTimer.iRepLen1 = self.iLenOfTimer1;
    _tmpTimer.iRepLen2 = self.iLenOfTimer2;
    
    _tmpTimer.sRepSoundName= self.sSoundName;
    _tmpTimer.sRepSoundExtension = self.sSoundNameExtension;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    

    if ([[app timers] containsObject:_tmpTimer]) {
        NSLog(@"value already in timer");
        
    } else {
        [[app timers] addObject:_tmpTimer];
        self.saveButton.enabled = NO;
    }

    
    //[[app timers] addObject:_tmpTimer];

    //
    
}


//updates the booleans for which cell is now showing
- (void)showPickerCell:(UIPickerView *)picker {
    
    if (picker == _repPicker) {
        self.repPickerIsShowing = YES;
    } else if (picker == _timer1Picker) {
        self.timer1PickerIsShowing = YES;
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
 
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
 
     UILabel *label = [[UILabel alloc] init];
     NSString *tmp = [[NSString alloc] init];
     
     //label.backgroundColor = [UIColor blueColor];
     label.textColor = [UIColor whiteColor];
     //label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
     label.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
     
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
 
// This method is triggered whenever the user makes a change to the picker selection.
// The parameter named row and component represents what was selected.

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  
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

   
    
}

 

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


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
    if ([segue.identifier isEqualToString:@"ViewTimer"]) {
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        ViewTimerTableViewController *dest = [[nc viewControllers] lastObject];
        [dest setINumReps: _iNumRep];
        [dest setIRepLen1:_iLenOfTimer1];
        [dest setIRepLen2:_iLenOfTimer2];
        
        
        
        NSString *tmp = [NSString stringWithFormat:@"Triple %@", _sSoundName];
        
    
        [dest setSRepSoundName: _sSoundName];
        [dest setSRepSoundExtension: _sSoundNameExtension];
        
        [dest setSEndSoundName: tmp];
        [dest setSEndSoundExtension: _sSoundNameExtension];
        
        [dest setIVolume: _iVolume];

        
    }

}



@end
