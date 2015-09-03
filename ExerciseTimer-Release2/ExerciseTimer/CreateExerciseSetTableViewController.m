//
//  CreateExerciseSetTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "CreateExerciseSetTableViewController.h"
#import "aTimer.h"
//#import "anExerciseSet.h"
#import "AppDelegate.h"
#import "CreateExerciseTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "ExerciseSetTableViewController.h"


@interface CreateExerciseSetTableViewController ()

//@property anExerciseSet *exerciseSet;
@property NSArray *aPresetTimers;
@property (nonatomic, retain) UIPickerView *picker;
@property NSInteger pickerRow;
@property NSInteger selectedPickerRow;
@property NSInteger pickerSection;
@property NSInteger lastPickerRow;
@property NSInteger clickedRow;
@property UITextField *nameTextField;
@property UIButton *saveButton;
@property BOOL pickerIsShowing;

@end

@implementation CreateExerciseSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 10;
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //app.timers = _savedTimers;
    //[app saveData];
    
    _selectedPickerRow = 0;
    _pickerIsShowing = YES;
    _pickerRow = 0;
    _pickerSection = 1;
    _lastPickerRow = -1;
    
    self.aPresetTimers = app.timers;
    
    _exerciseSet.sSetName = @"";
    _exerciseSet.iTotalLength = 0;
    
    if (self.exerciseSet == nil) {
        self.exerciseSet = [[anExerciseSet alloc] init];
        [self addRow];
    }
    _picker = [[UIPickerView alloc] init];
    _picker.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)addRow {
    
    
//    NSMutableArray *savedTimers1 = [[NSMutableArray alloc] init];
//    //
//    if (_exerciseSet.aExercises != nil) {
//        savedTimers1 = [_exerciseSet.aExercises copy];
//    }
    //
    
    aTimer *timer1 = [[aTimer alloc] init];
    timer1 = [self.aPresetTimers objectAtIndex:_selectedPickerRow];
    
    _exerciseSet.iTotalLength = _exerciseSet.iTotalLength + [timer1 totalLength];
    
    //_exerciseSet.aExercises = savedTimers1;
    [_exerciseSet.aExercises addObject:timer1];
    
    _pickerRow = [_exerciseSet.aExercises count];
    
    
}
- (IBAction)addPresetTimer:(id)sender {
    [self addRow];
    
    UITableView *tableView = self.tableView;
    _clickedRow = [[self.exerciseSet aExercises] count] - 1;
    _pickerRow = _clickedRow + 1;
    
    _pickerIsShowing = YES;
    [tableView reloadData];
    _lastPickerRow = _pickerRow;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
    
        if (_pickerIsShowing) {
            return ([_exerciseSet.aExercises count] + 1);
        }
        
        return [_exerciseSet.aExercises count];
    
    }

    //for section 0 and 2 there is only one row
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog([NSString stringWithFormat:@"Section %li", (long)indexPath.section]);
    
    // Configure the cell...
    //cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerExerciseNamePrototypeCell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        UITableViewCell *cell;
        if (indexPath.row == _pickerRow && _pickerIsShowing) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerPickerPrototypeCell" forIndexPath:indexPath];

        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerNamePrototypeCell" forIndexPath:indexPath];
        }
        return cell;
    // section 0
    } else if (indexPath.section == 0) {
        UITableViewCell *cell;
        //CreateExerciseTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerExerciseNamePrototypeCell" forIndexPath:indexPath];
       
        cell.textLabel.text = @"Exercise Name";
        cell.detailTextLabel.hidden = YES;
        [[cell viewWithTag:3] removeFromSuperview];
        
        _nameTextField = [[UITextField alloc] init];
        
        _nameTextField.tag = 3;
        _nameTextField.placeholder = @"My Exercise Set";
        _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_nameTextField];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        _nameTextField.textAlignment = NSTextAlignmentRight;
        
        return cell;
    // section 2
    } else {        
        //CreateExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavePrototypeCell" forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
        
        
        
        
        //UIButton *saveButton = [[UIButton alloc] init];
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _saveButton.layer.borderWidth = 1.0f;
        //self.button.layer.borderColor = [[UIColor whiteColor] CGColor];
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
    
    
}

- (void)saveButtonPressed:(id)sender {
    NSLog(@"Save button pressed!");
    
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
    
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _exerciseSet.sSetName = _nameTextField.text;
    
    if ([[app exerciseSets] containsObject:_exerciseSet]) {
        NSLog(@"value already in timer");
        
    } else {
        
        [app.exerciseSets addObject:_exerciseSet];
    }
    
    [app saveExerciseSetData];
    
    
    /*
    if (_textField.text == nil || [_textField.text isEqualToString:@""]) {
        [self showValidationAlert];
    } else {
        
        //[self performSegueWithIdentifier:@"CreateExerciseSet" sender:self];
       
    }
     */
    
    [self performSegueWithIdentifier:@"CreateExerciseSet" sender:self];
    
    
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSInteger pickerRow;
    //pickerRow = [_exerciseSet.aExercises count];

    //NSInteger tmp = indexPath.row;
    
    if (indexPath.section == 1) {
    
        if (indexPath.row == _pickerRow && _pickerIsShowing == YES) {

            [_picker setDelegate:self];
            [cell addSubview:_picker];
            
            //center x
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_picker
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_picker
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
        } else if (indexPath.row > _pickerRow) {
            aTimer *tmpTimer = [self.exerciseSet.aExercises objectAtIndex:(indexPath.row-1)];
            
            cell.textLabel.text = tmpTimer.sTimerName;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", tmpTimer.totalLength / 60, tmpTimer.totalLength % 60];
        } else {
            aTimer *tmpTimer = [self.exerciseSet.aExercises objectAtIndex:indexPath.row];
            
            cell.textLabel.text = tmpTimer.sTimerName;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", tmpTimer.totalLength / 60, tmpTimer.totalLength % 60];
        }
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == _clickedRow && _pickerIsShowing == YES) {
            _pickerIsShowing = NO;
            _clickedRow = indexPath.row;
            NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:indexPath.section];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        } else if (_pickerIsShowing == NO) {
            _pickerIsShowing = YES;
            _clickedRow = indexPath.row;
            _pickerRow = indexPath.row + 1;
            NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:indexPath.section];
            
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            //If picker is showing and the clicked row is not the same as before
        } else {
            _pickerIsShowing = YES;
            //if above the clicked row
            if (_clickedRow < indexPath.row) {
                _clickedRow = indexPath.row - 1;
            } else {
                _clickedRow = indexPath.row;
            }
            _pickerRow = _clickedRow + 1;
            NSIndexPath *pickerDeleteIndexPath = [NSIndexPath indexPathForRow:_lastPickerRow inSection:indexPath.section];
            NSIndexPath *pickerInsertIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:indexPath.section];
            
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:pickerInsertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
        
    
    
         
        _lastPickerRow = _pickerRow;
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.exerciseSet.aExercises removeObjectAtIndex:indexPath.row];
        _pickerRow = [_exerciseSet.aExercises count];
        [tableView reloadData];
    }
    */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 3) {
        return 50;
        
    } else {
        if (indexPath.row == _pickerRow && _pickerIsShowing) {
           return 180;
        } else {
            return 50;
        }
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - picker section

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_aPresetTimers count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    aTimer *tmpTimer;
    tmpTimer = [_aPresetTimers objectAtIndex:row];
    
    NSString *tmp = [tmpTimer timerName];
    
    return tmp;
    
    //return tmpTimer.sTimerName;
    
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_clickedRow inSection:_pickerSection];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:pickerIndexPath];

    aTimer *tmpTimer;
    tmpTimer = [_aPresetTimers objectAtIndex:row];
    
    cell.textLabel.text = [tmpTimer timerName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", [tmpTimer totalLength] / 60, [tmpTimer totalLength] % 60];
    
    [[_exerciseSet aExercises] replaceObjectAtIndex:_clickedRow withObject:tmpTimer];
    _selectedPickerRow = row;
    
    
}

#pragma mark - error
-(void) showValidationAlert
{
    UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Exercise Name field is required." delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [ErrorAlert show];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
