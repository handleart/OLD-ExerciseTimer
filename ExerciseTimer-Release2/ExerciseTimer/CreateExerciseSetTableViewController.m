//
//  CreateExerciseSetTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "CreateExerciseSetTableViewController.h"
//#import "aTimer.h"
//#import "anExerciseSet.h"
#import "AppDelegate.h"
#import "CreateExerciseTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "ExerciseSetTableViewController.h"
#import "ViewTimerTableViewController.h"
#import "SetTimerNewTableViewController.h"

#define nameSectionIndex 0
#define editSectionIndex 1
#define addTimerSectionIndex 1
#define timerSectionIndex 2
#define saveSectionIndex 3

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
@property UIButton *addPresetTimerButton;
@property BOOL pickerIsShowing;
@property NSString *sPlaceholderValue;

@end

@implementation CreateExerciseSetTableViewController


- (IBAction)backButtonPressed:(id)sender {
    
    
    //[self performSegueWithIdentifier:@"unwindToChooseExerciseSet" sender:self];
    
    UITabBarController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewPage"];

    tvc.selectedIndex = 2;
    
    //CreateExerciseSetTableViewController *lvc =[[nc viewControllers] objectAtIndex:0];
    
    
    
    
    
    
    UIStoryboardSegue *segue =
    [UIStoryboardSegue segueWithIdentifier:@"TabBarViewPage1"
                                    source:self
                               destination:tvc
                            performHandler:^{
                                [self.navigationController presentViewController:tvc animated:NO completion: nil];
                                
                                // transition code that would
                                // normally go in the perform method
                            }];
    
    [self prepareForSegue:segue sender:self];
    
    [segue perform];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    //self.view.layer.cornerRadius = 10;
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _sPlaceholderValue = [NSString stringWithFormat:@"Exercise Set %li", (long)([[app exerciseSets] count] + 1)];
    _nameTextField.placeholder = _sPlaceholderValue;

    
    
    _selectedPickerRow = 0;
    _pickerIsShowing = YES;
    _pickerRow = 0;
    _pickerSection = 2;
    _lastPickerRow = -1;
    
    self.aPresetTimers = app.timers;
    

    
    
    if (self.exerciseSet == nil) {
        self.exerciseSet = [[anExerciseSet alloc] init];
        
        if (_aPresetTimers == nil || [_aPresetTimers count] == 0) {
             self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        [self addRow];
    } else {
        _pickerRow = [_exerciseSet.aExercises count];
        _pickerIsShowing = NO;
        
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    
    _picker = [[UIPickerView alloc] init];
    _picker.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_aPresetTimers == nil || [_aPresetTimers count] == 0) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor
];
        self.navigationItem.rightBarButtonItem.enabled = YES;

    }
 
}

- (void)addRow {
    
    
//    NSMutableArray *savedTimers1 = [[NSMutableArray alloc] init];
//    //
//    if (_exerciseSet.aExercises != nil) {
//        savedTimers1 = [_exerciseSet.aExercises copy];
//    }
    //
    
    if ([self.aPresetTimers count] == 0 || self.aPresetTimers == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please create a preset timer first."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [self performSegueWithIdentifier:@"CreateCustomPresetTimer" sender:self];
    } else {
        aTimer *timer1 = [self.aPresetTimers objectAtIndex:_selectedPickerRow];
        
        //_exerciseSet.iTotalLength = _exerciseSet.iTotalLength + [timer1 totalLength];
        
        //_exerciseSet.aExercises = savedTimers1;
        [_exerciseSet.aExercises addObject:timer1];
        _pickerRow = [_exerciseSet.aExercises count];
        
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //[textField setBackgroundColor:[UIColor blueColor]];
    return NO;
}
- (IBAction)editButtonPressed:(id)sender {
    //CreateCustomPresetTimer

    
    UIButton *edit = (UIButton *)sender;
    
    
    
    _pickerIsShowing = NO;
    
    
    if (self.editing == NO && _pickerIsShowing == YES) {
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:timerSectionIndex];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.editing = !self.editing;

    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [edit
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [edit
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];

    
    //NSLog(@"Editing has been enabled");
    
    
    
}

- (IBAction)addCustomTimerPressed:(id)sender {
    [self performSegueWithIdentifier:@"CreateCustomPresetTimer" sender:self];
    
}

- (IBAction)addPresetTimerPressed:(id)sender {
    [self addRow];
    
    /*
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_addPresetTimerButton
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_addPresetTimerButton
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];

    
     */
     
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == timerSectionIndex) {
    
        if (_pickerIsShowing) {
            return ([_exerciseSet.aExercises count] + 1);
        }
        
        return [_exerciseSet.aExercises count];
    
    } else if ( section == addTimerSectionIndex) {
        return 1;
    }

    //for section 0 and 2 there is only one row
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog([NSString stringWithFormat:@"Section %li", (long)indexPath.section]);
    
    // Configure the cell...
    //cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerExerciseNamePrototypeCell" forIndexPath:indexPath];
    
    if (indexPath.section == timerSectionIndex) {
        UITableViewCell *cell;
        if (indexPath.row == _pickerRow && _pickerIsShowing) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerPickerPrototypeCell" forIndexPath:indexPath];

        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerNamePrototypeCell" forIndexPath:indexPath];
        }
        return cell;
    } else if (indexPath.section == nameSectionIndex) {
        UITableViewCell *cell;
        //CreateExerciseTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerExerciseNamePrototypeCell" forIndexPath:indexPath];
       
        cell.textLabel.text = @"Exercise Name";
        cell.detailTextLabel.hidden = YES;
        [[cell viewWithTag:3] removeFromSuperview];
        
        _nameTextField = [[UITextField alloc] init];
        
        _nameTextField.tag = 3;
        
        if ([_exerciseSet.sSetName isEqualToString:@""] || _exerciseSet.sSetName == nil) {
            _nameTextField.placeholder = _sPlaceholderValue;
        } else {
            _nameTextField.text = _exerciseSet.sSetName;
        }
        
        
        _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_nameTextField];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        _nameTextField.textAlignment = NSTextAlignmentRight;
        
        return cell;
    } else if (indexPath.section == saveSectionIndex ){
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
    } else if (indexPath.section == addTimerSectionIndex) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
    
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        if (indexPath.row == 0) {
        
            _addPresetTimerButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            UILabel *addPresetLabel = [[UILabel alloc] init];
            
            addPresetLabel.text = @"Preset";
            
            _addPresetTimerButton.translatesAutoresizingMaskIntoConstraints = NO;
            addPresetLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            [_addPresetTimerButton addTarget:self action:@selector(addPresetTimerPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:_addPresetTimerButton];
            [cell.contentView addSubview:addPresetLabel];
            
            //center x
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_addPresetTimerButton
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeLeadingMargin
                                                            multiplier:1.0
                                                              constant:0]];
            
            //center y
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_addPresetTimerButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addPresetLabel
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_addPresetTimerButton
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:5]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addPresetLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_addPresetTimerButton
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            UIButton *addCustom = [UIButton buttonWithType:UIButtonTypeContactAdd];
            UILabel *addCustomLabel = [[UILabel alloc] init];
            
            addCustomLabel.text = @"Manual";

            
            addCustom.translatesAutoresizingMaskIntoConstraints = NO;
            addCustomLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [addCustom addTarget:self action:@selector(addCustomTimerPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:addCustom];
            [cell.contentView addSubview:addCustomLabel];
            
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustomLabel
//                                                             attribute:NSLayoutAttributeTrailing
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:cell.contentView
//                                                             attribute:NSLayoutAttributeTrailingMargin
//                                                            multiplier:1.0
//                                                              constant:0]];
//            
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustomLabel
//                                                             attribute:NSLayoutAttributeCenterY
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:cell.contentView
//                                                             attribute:NSLayoutAttributeCenterY
//                                                            multiplier:1.0
//                                                              constant:0]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustom
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:addPresetLabel
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:30]];

            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustomLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustomLabel
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:addCustom
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:5]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:addCustom
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            
            
            UIButton *edit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            edit.layer.borderWidth = 1.0f;
            //self.button.layer.borderColor = [[UIColor whiteColor] CGColor];
            edit.layer.cornerRadius = 8.0f;
            edit.translatesAutoresizingMaskIntoConstraints = NO;
            [edit setTitle:@"Edit" forState:UIControlStateNormal];
            [edit setTitle:@"Edit" forState:UIControlStateSelected];

            edit.translatesAutoresizingMaskIntoConstraints = NO;
            [edit addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

            [cell.contentView addSubview:edit];


            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeTrailingMargin
                                                            multiplier:1.0
                                                              constant:0]];
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0]];
            


            //width
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:70]];

            //height
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                              constant:40]];

            
        } else {
            
        }
        return cell;
        
//    } else if (indexPath.section == editSectionIndex) {
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
//        backView.backgroundColor = [UIColor clearColor];
//        cell.backgroundView = backView;
//        
//        if (indexPath.row == 0) {
//        
//            UIButton *edit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            edit.layer.borderWidth = 1.0f;
//            //self.button.layer.borderColor = [[UIColor whiteColor] CGColor];
//            edit.layer.cornerRadius = 8.0f;
//            edit.translatesAutoresizingMaskIntoConstraints = NO;
//            [edit setTitle:@"Edit" forState:UIControlStateNormal];
//            [edit setTitle:@"Edit" forState:UIControlStateSelected];
//            
//            edit.translatesAutoresizingMaskIntoConstraints = NO;
//            [edit addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.contentView addSubview:edit];
//            
//            
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
//                                                             attribute:NSLayoutAttributeCenterX
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:cell.contentView
//                                                             attribute:NSLayoutAttributeCenterX
//                                                            multiplier:1.0
//                                                              constant:10]];
//            
//            //center y
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
//                                                             attribute:NSLayoutAttributeCenterY
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:cell.contentView
//                                                             attribute:NSLayoutAttributeCenterY
//                                                            multiplier:1.0
//                                                              constant:0]];
//            
//            //width
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
//                                                             attribute:NSLayoutAttributeWidth
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:nil
//                                                             attribute:NSLayoutAttributeWidth
//                                                            multiplier:1.0
//                                                              constant:100]];
//            
//            //height
//            [cell addConstraint:[NSLayoutConstraint constraintWithItem:edit
//                                                             attribute:NSLayoutAttributeHeight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:nil
//                                                             attribute:NSLayoutAttributeHeight
//                                                            multiplier:1.0
//                                                              constant:40]];
//        
//        } else {
//            
//        }
//        return cell;
//        
    } else {
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
}

- (void)saveButtonPressed:(id)sender {
    //NSLog(@"Save button pressed!");
    
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
    
    if ([_nameTextField.text isEqualToString:@""] || [_nameTextField.text length] == 0) {
        _exerciseSet.sSetName = _nameTextField.placeholder;
    } else {
        _exerciseSet.sSetName = _nameTextField.text;
    }
    
    _exerciseSet.iTotalLength = 0;
    for (aTimer *obj in [_exerciseSet aExercises]) {
        _exerciseSet.iTotalLength += [obj totalLength];
    }
    
    
    
    if ([[app exerciseSets] containsObject:_exerciseSet]) {
       // NSLog(@"value already in timer");
        
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
    
    //[self performSegueWithIdentifier:@"CreateExerciseSet" sender:self];
    
    
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSInteger pickerRow;
    //pickerRow = [_exerciseSet.aExercises count];

    //NSInteger tmp = indexPath.row;
    
    if (indexPath.section == timerSectionIndex) {
    
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
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)(tmpTimer.totalLength / 60), (long)(tmpTimer.totalLength % 60)];
        } else {
            aTimer *tmpTimer = [self.exerciseSet.aExercises objectAtIndex:indexPath.row];
            
            cell.textLabel.text = tmpTimer.sTimerName;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)(tmpTimer.totalLength / 60), (long)(tmpTimer.totalLength % 60)];
        }
    } else if (indexPath.section == editSectionIndex) {
        //[cell setBackgroundColor:[UIColor clearColor]];
        //cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    } else if (indexPath.section == addTimerSectionIndex) {
        //[cell setBackgroundColor:[UIColor clearColor]];
        //cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == timerSectionIndex) {
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
            
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:pickerInsertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            
            [tableView endUpdates];
        }
        
    
    
         
        _lastPickerRow = _pickerRow;
        
    }
    
    //_clickedRow = ?
    
    
    
    NSInteger selectPickerRow = [_aPresetTimers indexOfObject:[[_exerciseSet aExercises] objectAtIndex:_clickedRow]];
    
    [_picker selectRow:selectPickerRow inComponent:0 animated:NO];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == timerSectionIndex  && indexPath.row != _pickerRow && [_exerciseSet.aExercises count] > 1) {
        return YES;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == timerSectionIndex && indexPath.row != _pickerRow && [_exerciseSet.aExercises count] > 1) {
    
        
            [self.exerciseSet.aExercises removeObjectAtIndex:indexPath.row];
            _pickerRow = [_exerciseSet.aExercises count];
            _pickerIsShowing = NO;
            [tableView reloadData];
        }
        
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == nameSectionIndex || indexPath.section == addTimerSectionIndex || indexPath.section == saveSectionIndex) {
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    aTimer *tmpTimer = [_exerciseSet.aExercises objectAtIndex:sourceIndexPath.row];
    [_exerciseSet.aExercises removeObjectAtIndex:sourceIndexPath.row];
    [_exerciseSet.aExercises insertObject:tmpTimer atIndex:destinationIndexPath.row];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)([tmpTimer totalLength] / 60), (long)([tmpTimer totalLength] % 60)];
    
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
- (IBAction)unwindToCreateExerciseSet:(UIStoryboardSegue *)segue {
    SetTimerNewTableViewController *source = [segue sourceViewController];
    
    
    
    //only reload if a new timer is created on the subsequent page
    if ([source isKindOfClass:[SetTimerNewTableViewController class]]) {
        if (source.tmpTimer != nil) {
            [_exerciseSet.aExercises addObject:source.tmpTimer];
            _clickedRow = [[self.exerciseSet aExercises] count] - 1;
            _pickerRow = _clickedRow + 1;
            _pickerSection = 2;
            _lastPickerRow = -1;
            _pickerIsShowing = YES;
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [_picker reloadAllComponents];
            if (app.timers == nil) {
                [_picker selectRow:0 inComponent:0 animated:NO];
            } else {
                [_picker selectRow:(long)[app.timers count] - 1 inComponent:0 animated:NO];
            }
            
            [self.tableView reloadData];

        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewTimerFromExerciseSet"]) {
        
        UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
        
        ViewTimerTableViewController *dest = [[dc viewControllers] lastObject];
        
        [dest setExerciseSet:_exerciseSet];
        [dest setSource:@"CreateExerciseSetTableViewController"];
        
        //[dest setIVolume: _iVolume];
        
        
    } else if ([segue.identifier isEqualToString:@"CreateCustomPresetTimer"]) {
        UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
        
        SetTimerNewTableViewController *dest = [[dc viewControllers] lastObject];
        
        [dest setAddViewIsShowing:YES];
    }
    
    

}


@end
