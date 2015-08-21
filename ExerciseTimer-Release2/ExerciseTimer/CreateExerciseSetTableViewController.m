//
//  CreateExerciseSetTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "CreateExerciseSetTableViewController.h"
#import "aTimer.h"
#import "anExerciseSet.h"
#import "AppDelegate.h"


@interface CreateExerciseSetTableViewController ()

@property anExerciseSet *exerciseSet;
@property NSArray *aPresetTimers;
@property (nonatomic, retain) UIPickerView *picker;
@property NSInteger pickerRow;
@property NSInteger lastPickerRow;
@property NSInteger clickedRow;
@property BOOL pickerIsShowing;

@end

@implementation CreateExerciseSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exerciseSet = [[anExerciseSet alloc] init];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //app.timers = _savedTimers;
    //[app saveData];
    
    _pickerIsShowing = YES;
    _pickerRow = 0;
    _lastPickerRow = -1;
    
    self.aPresetTimers = app.timers;
    
    
    [self createInitialData];
    _picker = [[UIPickerView alloc] init];
    
}

- (void)createInitialData {
    
    
//    NSMutableArray *savedTimers1 = [[NSMutableArray alloc] init];
//    //
//    if (_exerciseSet.aExercises != nil) {
//        savedTimers1 = [_exerciseSet.aExercises copy];
//    }
    //
    aTimer *timer1 = [[aTimer alloc] init];
    timer1.sTimerName = @"Select preset timer";
    timer1.sRepSoundName = @"Temple Bell";
    timer1.sRepSoundExtension = @"aiff";
    timer1.iNumReps = 0;
    timer1.iRepLen1 = 0;
    timer1.iRepLen2 = 0;
    
    //[savedTimers1 addObject:timer1];
    _exerciseSet.sSetName = @"Test";
    _exerciseSet.iTotalLength = timer1.iNumReps * ( timer1.iRepLen1 + timer1.iRepLen2);
    
    //_exerciseSet.aExercises = savedTimers1;
    [_exerciseSet.aExercises addObject:timer1];
    
    _pickerRow = [_exerciseSet.aExercises count];
    
    
}
- (IBAction)addPresetTimer:(id)sender {
    [self createInitialData];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_pickerIsShowing) {
        return ([_exerciseSet.aExercises count] + 1);
    }
    
    return [_exerciseSet.aExercises count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
    
    // Configure the cell...
    
    
    if (indexPath.row == _pickerRow && _pickerIsShowing) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerPickerPrototypeCell" forIndexPath:indexPath];

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerNamePrototypeCell" forIndexPath:indexPath];
    }
    
    
     
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSInteger pickerRow;
    //pickerRow = [_exerciseSet.aExercises count];

    //NSInteger tmp = indexPath.row;
    
    
    if (indexPath.row == _pickerRow && _pickerIsShowing == YES) {

        [_picker setDelegate:self];
        [cell addSubview:_picker];
    } else if (indexPath.row > _pickerRow) {
        aTimer *tmpTimer = [self.exerciseSet.aExercises objectAtIndex:(indexPath.row-1)];
        
        cell.textLabel.text = tmpTimer.sTimerName;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li", tmpTimer.totalLength / 60, tmpTimer.totalLength % 60];
    } else {
        aTimer *tmpTimer = [self.exerciseSet.aExercises objectAtIndex:indexPath.row];
        
        cell.textLabel.text = tmpTimer.sTimerName;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li", tmpTimer.totalLength / 60, tmpTimer.totalLength % 60];
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _clickedRow && _pickerIsShowing == YES) {
        _pickerIsShowing = NO;
        _clickedRow = indexPath.row;
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:0];
        
        [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    } else if (_pickerIsShowing == NO) {
        _pickerIsShowing = YES;
        _clickedRow = indexPath.row;
        _pickerRow = indexPath.row + 1;
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:0];
        
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
            
        NSIndexPath *pickerDeleteIndexPath = [NSIndexPath indexPathForRow:_lastPickerRow inSection:0];
        NSIndexPath *pickerInsertIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:0];

        [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:pickerInsertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
    
    }
    
    /*
    
    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:_pickerRow inSection:0];

    
    [tableView beginUpdates];
    
     if (_pickerRow != _lastPickerRow) {
         //delete old rows
         if (_lastPickerRow >= 0) {
             NSIndexPath *lastPickerIndexPath = [NSIndexPath indexPathForRow:_lastPickerRow inSection:0];
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:lastPickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         //add new rows
         [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     } else {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     }
        
             
    
    
    [tableView endUpdates];

    */
    
    _lastPickerRow = _pickerRow;

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    if (indexPath.row == _pickerRow && _pickerIsShowing) {
       return 180;
    } else {
        return 50;
    }
}

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
    
    //do stuff
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
