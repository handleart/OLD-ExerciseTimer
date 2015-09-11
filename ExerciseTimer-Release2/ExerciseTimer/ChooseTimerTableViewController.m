//
//  ChooseTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/7/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "ChooseTimerTableViewController.h"
#import "SetTimerNewTableViewController.h"
#import "aTimer.h"
#import "appDelegate.h"

@interface ChooseTimerTableViewController ()
@property NSMutableArray *savedTimers;
@property aTimer *selectedTimer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTimer;

@end

@implementation ChooseTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //[[UIScrollView appearance] setBackgroundColor:[UIColor blueColor]];
    
    self.savedTimers = [[NSMutableArray alloc] init];
    
    //[self initTestData];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //app.timers = _savedTimers;
    //[app saveData];
    
    
    self.savedTimers = app.timers;
    
    

    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - unwind method
- (IBAction)unwindToChooseTimer:(UIStoryboardSegue *)segue {
    SetTimerNewTableViewController *source = [segue sourceViewController];
    
    //only reload if a new timer is created on the subsequent page
    if (source.tmpTimer != nil) {
        [self.tableView reloadData];
    }
    
}

#pragma mark - test helpers
- (void)initTestData {
    
    aTimer *timer1 = [[aTimer alloc] init];
    timer1.sTimerName = @"8 Min Abs";
    [self.savedTimers addObject:timer1];
    
    aTimer *timer2 = [[aTimer alloc] init];
    timer2.sTimerName = @"Mindfulness of Breathing";
    [self.savedTimers addObject:timer2];
    
    aTimer *timer3 = [[aTimer alloc] init];
    timer3.sTimerName = @"Other";
    [self.savedTimers addObject:timer3];
    
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
    //[cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li, Sound: %@", tmpTimer.totalLength / 60, tmpTimer.totalLength % 60,tmpTimer.sRepSoundName];
    
    
    //cell.backgroundColor = [UIColor colorWithRed:215/255 green:222/255 blue:226/255 alpha:0.2];
    //cell.backgroundColor = [UIColor blueColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.textColor = [UIColor whiteColor];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedTimers removeObjectAtIndex:indexPath.row];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app saveTimersData];
        [tableView reloadData];
    }
}

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
