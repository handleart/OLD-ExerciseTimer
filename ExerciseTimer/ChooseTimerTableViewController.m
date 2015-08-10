//
//  ChooseTimerTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/7/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "ChooseTimerTableViewController.h"
#import "aTimer.h"
#import "appDelegate.h"

@interface ChooseTimerTableViewController ()
@property NSMutableArray *savedTimers;

@end

@implementation ChooseTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.savedTimers = [[NSMutableArray alloc] init];
    
    //[self initTestData];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //app.timers = _savedTimers;
    //[app saveData];
    
    self.savedTimers = app.timers;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helpers
- (void)loadData {
    
    
    
}

#pragma mark - test helpers
- (void)initTestData {
    
    aTimer *timer1 = [[aTimer alloc] init];
    timer1.timerName = @"8 Min Abs";
    [self.savedTimers addObject:timer1];
    
    aTimer *timer2 = [[aTimer alloc] init];
    timer2.timerName = @"Mindfulness of Breathing";
    [self.savedTimers addObject:timer2];
    
    aTimer *timer3 = [[aTimer alloc] init];
    timer3.timerName = @"Other";
    [self.savedTimers addObject:timer3];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.savedTimers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"forIndexPath:indexPath];
    
    aTimer *tmpTimer = [self.savedTimers objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpTimer.timerName;
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
