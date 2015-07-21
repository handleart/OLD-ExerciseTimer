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
#define cPickerCellHeight 164

#import "SetTimerTableViewController.h"
#import "ViewTimerViewController.h"

@interface SetTimerTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *dimScreenSwitch;


@property (weak, nonatomic) IBOutlet UIPickerView *timer2Picker;
@property (weak, nonatomic) IBOutlet UITextField *timer2Label;
@property (weak, nonatomic) IBOutlet UIPickerView *timer1Picker;
@property (weak, nonatomic) IBOutlet UITextField *timer1Label;
@property (weak, nonatomic) IBOutlet UITextField *numLabel;
@property (weak, nonatomic) IBOutlet UITextField *label1;
@property (weak, nonatomic) IBOutlet UITextField *label2;
@property (assign) BOOL repPickerIsShowing;
@property (assign) BOOL timer1PickerIsShowing;
@property (assign) BOOL timer2PickerIsShowing;

@property (strong, nonatomic) UITextField *activeTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *repPicker;

@property NSArray *aNumRepsPickListValues;
@property NSArray *aTimer1PickListValues;
@property NSArray *aTimer2PickListValues;

@property NSArray *aMin;
@property NSArray *aSec;

@property NSInteger iNumRep;

@property NSInteger iLenOfTimer1min;
@property NSInteger iLenOfTimer1sec;
@property NSInteger iLenOfTimer2min;
@property NSInteger iLenOfTimer2sec;
@property NSInteger iLenOfTimer1;
@property NSInteger iLenOfTimer2;

@end

@implementation SetTimerTableViewController

- (IBAction)unwindToSetTimer:(UIStoryboardSegue *)segue {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self definePickerData];
    [self definePickerState];

     //UITableViewScrollPositionTop;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}

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
        if (i < 11 && i > 0) {
            [repTmp addObject:x];
        }
    }
    
    _aMin = [minTmp copy];
    _aSec = [secTmp copy];
    
    self.aNumRepsPickListValues = [repTmp copy];
    self.aTimer1PickListValues = @[[_aMin copy], [_aSec copy]];
    self.aTimer2PickListValues = @[[_aMin copy], [_aSec copy]];
    
    if (_bNotFirstTime != YES) {
        [self.repPicker selectRow:0 inComponent:0 animated:NO];
        [self.timer1Picker selectRow:1 inComponent:1 animated:NO];
        [self.timer2Picker selectRow:1 inComponent:1 animated:NO];
        
        [self pickerView:self.repPicker didSelectRow:0 inComponent:0];
        [self pickerView:self.timer1Picker didSelectRow:1 inComponent:1];
        [self pickerView:self.timer2Picker didSelectRow:1 inComponent:1];
    
        _bNotFirstTime = YES;
    }
    
    
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
}

#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    
    if (indexPath.row == cRepPickerIndex){
        
        height = self.repPickerIsShowing ? cPickerCellHeight : 0.0f;
        
    } else if (indexPath.row == cTimer1PickerIndex){
        
        height = self.timer1PickerIsShowing ? cPickerCellHeight : 0.0f;
        
    } else if (indexPath.row == cTimer2PickerIndex){
        
        height = self.timer2PickerIsShowing ? cPickerCellHeight : 0.0f;
        
    }
    
    return height;
}

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

            
            [self.activeTextField resignFirstResponder];
            [self showPickerCell:_timer2Picker];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)dimScreenSwitchPressed:(id)sender {
    
    if ([self.dimScreenSwitch isOn]) {
        [self.dimScreenSwitch setOn:YES animated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        [self.dimScreenSwitch setOn:NO animated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    
}

- (void)showPickerCell:(UIPickerView *)picker {
    
    if (picker == _repPicker) {
        self.repPickerIsShowing = YES;
    } else if (picker == _timer1Picker) {
        self.timer1PickerIsShowing = YES;
    } else if (picker == _timer2Picker) {
        self.timer2PickerIsShowing = YES;
    } else {
        NSLog(@"Hah? There is a problem with the picker that was passed to showPickerCell");
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    picker.hidden = NO;
    picker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        picker.alpha = 1.0f;
        
    }];
}


- (void)hidePickerCell:(UIPickerView *)picker {
    
    if (picker == _repPicker) {
        self.repPickerIsShowing = NO;
    } else if (picker == _timer1Picker) {
        self.timer1PickerIsShowing = NO;
    } else if (picker == _timer2Picker) {
        self.timer2PickerIsShowing = NO;
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual: self.repPicker]) {
        return 1;
    }
    
    else if ([pickerView isEqual: self.timer1Picker] || [pickerView isEqual: self.timer2Picker]) {
        return 2;
    }
    else {
        return 0;
    }
}

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
    } else {
        return 1;
    }

    

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if ([pickerView isEqual: self.repPicker]) {
        return _aNumRepsPickListValues[row];
    }
    
    else if ([pickerView isEqual: self.timer1Picker])  {
        return _aTimer1PickListValues[component][row];
    } else if ([pickerView isEqual: self.timer2Picker]) {
        return _aTimer2PickListValues[component][row];
    } else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
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
    }

   
    
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
        ViewTimerViewController *dest = [[nc viewControllers] lastObject];
        [dest setINumReps: _iNumRep];
        [dest setIRepLen1:_iLenOfTimer1];
        [dest setIRepLen2:_iLenOfTimer2];

        
    }

}


@end
