//
//  ChooseTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/7/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//
//  This page displays all the saved preset timers. This relates to the preset timers tab of the app. 

//  Variables:
//      savedTimers: Stored values for all the saved preset timers
//      addTimer: Is the add preset button on the UI


#import "ChooseTimerTableViewController.h"
#import "SetTimerNewTableViewController.h"
#import "aTimer.h"
#import "appDelegate.h"
#import "anExerciseSet.h"


@interface ChooseTimerTableViewController ()

@property NSMutableArray *savedTimers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTimer;

@end

@implementation ChooseTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.savedTimers = [[NSMutableArray alloc] init];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];;
    
    self.savedTimers = app.timers;
    
}

// Table needs to be reloaded every time since preset can be added in other views
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.savedTimers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table View methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    aTimer *tmpTimer = [self.savedTimers objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpTimer.sTimerName;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li, Sound: %@", (long)(tmpTimer.totalLength / 60), (long)(tmpTimer.totalLength % 60),tmpTimer.sRepSoundName];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *exercises = app.exerciseSets;
        
        aTimer *toBeDeletedTimer = [self.savedTimers objectAtIndex:indexPath.row];
        
        NSMutableArray *discardItems = [[NSMutableArray alloc] init];
        
        //As part of the delete process, will need to see if any exercise sets need to be deleted since the exercise set page does not allow empty exercise sets
        
        for (anExerciseSet *a in exercises) {
            NSMutableArray *timersInExerciseSet = [a aExercises];
            
            if ([timersInExerciseSet containsObject:toBeDeletedTimer]) {
                [timersInExerciseSet removeObject:toBeDeletedTimer];
            }
            
            if ([timersInExerciseSet count] == 0) {
                [discardItems addObject:a];
            }
        }
        
        //Delete all exercise sets and if necessary reload that page
        
        if ([discardItems count] > 0) {
            [exercises removeObjectsInArray:discardItems];
            
            //reload exercise set page if it has already been loaded
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        }
        
        [self.savedTimers removeObjectAtIndex:indexPath.row];
        
        [app saveTimersData];
        
        
        [tableView reloadData];
    }
}

#pragma mark - unwind method
- (IBAction)unwindToChooseTimer:(UIStoryboardSegue *)segue {
    SetTimerNewTableViewController *source = [segue sourceViewController];
    
    //only reload if a new timer is created on the subsequent page
    if (source.tmpTimer != nil) {
        [self.tableView reloadData];
    }
    
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
    SetTimerNewTableViewController *dest = [[dc viewControllers] lastObject];
    
    if (sender == _addTimer) {
        [dest setSaveViewIsShowing: true];
    }
    
    if ([segue.identifier isEqualToString:@"Table Selected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        aTimer *tmpTimer = [_savedTimers objectAtIndex:indexPath.row];
        
        [dest setSaveViewIsShowing: YES];
        [dest setTmpTimer: tmpTimer];
        
    }
    
}


@end
