//
//  ExerciseSetTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "ExerciseSetTableViewController.h"
#import "anExerciseSet.h"
#import "aTimer.h"
#import "AppDelegate.h"
#import "CreateExerciseSetTableViewController.h"

@interface ExerciseSetTableViewController ()

@property NSMutableArray *exerciseSet;


@end

@implementation ExerciseSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.exerciseSet = [[NSMutableArray alloc] init];
    
    //[self initTestData];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];


    self.exerciseSet = app.exerciseSets;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Test Data

- (void)initTestData {
    
    
    NSMutableArray *savedTimers1 = [[NSMutableArray alloc] init];
    
    //setup timers
    
    aTimer *timer1 = [[aTimer alloc] init];
    timer1.sTimerName = @"#1";
    timer1.sRepSoundName = @"Temple Bell";
    timer1.sRepSoundExtension = @"aiff";
    timer1.iNumReps = 2;
    timer1.iRepLen1 = 10;
    timer1.iRepLen2 = 5;
    
    
    aTimer *timer2 = [[aTimer alloc] init];
    timer2.sTimerName = @"#2";
    timer2.sRepSoundName = @"Temple Bell";
    timer2.sRepSoundExtension = @"aiff";
    timer2.iNumReps = 1;
    timer2.iRepLen1 = 5;
    timer2.iRepLen2 = 0;
    
    aTimer *timer3 = [[aTimer alloc] init];
    timer3.sTimerName = @"#3";
    timer3.sRepSoundName = @"Temple Bell";
    timer3.sRepSoundExtension = @"aiff";
    timer3.iNumReps = 2;
    timer3.iRepLen1 = 10;
    timer3.iRepLen2 = 5;
    
    
    [savedTimers1 addObject:timer1];
    [savedTimers1 addObject:timer2];
    [savedTimers1 addObject:timer3];
    
    anExerciseSet *tmpExerciseSet1 = [[anExerciseSet alloc] init];
    tmpExerciseSet1.sSetName = @"# One";
    tmpExerciseSet1.iTotalLength = 55;
    
    tmpExerciseSet1.aExercises = savedTimers1;
    [self.exerciseSet addObject:tmpExerciseSet1];
    
    
    
    
    
    
    
    anExerciseSet *tmpExerciseSet2 = [[anExerciseSet alloc] init];
    tmpExerciseSet2.sSetName = @"# Two";
    tmpExerciseSet2.iTotalLength = 60;
    NSMutableArray *savedTimers2 = [[NSMutableArray alloc] init];
    [savedTimers2 addObject:timer2];
    [savedTimers2 addObject:timer1];
    [savedTimers2 addObject:timer3];
    
    tmpExerciseSet2.aExercises = savedTimers2;
    
    [self.exerciseSet addObject:tmpExerciseSet2];
    
    NSMutableArray *savedTimers3 = [[NSMutableArray alloc] init];
    [savedTimers3 addObject:timer3];
    [savedTimers3 addObject:timer2];
    [savedTimers3 addObject:timer1];
    [savedTimers3 addObject:timer3];
    
    anExerciseSet *tmpExerciseSet3 = [[anExerciseSet alloc] init];
    tmpExerciseSet3.sSetName = @"# Three";
    tmpExerciseSet3.iTotalLength = 65;
    [tmpExerciseSet3.aExercises addObject:timer1];
    [tmpExerciseSet3.aExercises addObject:timer3];
    [tmpExerciseSet3.aExercises addObject:timer2];
    [self.exerciseSet addObject:tmpExerciseSet3];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exerciseSet count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseSetPrototypeCell" forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //- (void)tableView:(UITableView *)tableView willDisplayCell:(ExerciseTimerTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     cell.backgroundColor = [UIColor blueColor];
     cell.textLabel.textColor = [UIColor whiteColor];
     cell.detailTextLabel.textColor = [UIColor whiteColor];
     */
    
    anExerciseSet *tmpExerciseSet = [self.exerciseSet objectAtIndex:indexPath.row];
    
    /*
     cell.textLabel.text = tmpExerciseSet.sSetName;
     cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li", tmpExerciseSet.iTotalLength / 60, tmpExerciseSet.iTotalLength % 60];
     
     
     UIButton *editExerciseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     editExerciseButton.frame = CGRectMake(200.0f, 5.0f, 75.0f, 30.0f);
     [editExerciseButton setTitle:@"Edit" forState:UIControlStateNormal];
     [cell addSubview:editExerciseButton];
     [editExerciseButton addTarget:self
     action:@selector(editExercise:)
     forControlEvents:UIControlEventTouchUpInside];
     
     editExerciseButton.layer.borderWidth = 1.0f;
     editExerciseButton.layer.borderColor = [[UIColor whiteColor] CGColor];
     editExerciseButton.layer.cornerRadius = 8.0f;
     [editExerciseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
     */
    
    /*
     cell.editButton.layer.borderWidth = 1.0f;
     cell.editButton.layer.borderColor = [[UIColor whiteColor] CGColor];
     cell.editButton.layer.cornerRadius = 8.0f;
     [cell.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     */
    
    cell.textLabel.text = tmpExerciseSet.sSetName;
    //[cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Length: %02li:%02li", tmpExerciseSet.iTotalLength / 60, tmpExerciseSet.iTotalLength % 60];
  
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.exerciseSet removeObjectAtIndex:indexPath.row];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app saveExerciseSetData];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}
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
    
    
    if ([segue.identifier isEqualToString:@"ViewExistingExerciseSet"]) {
        UINavigationController *dc = (UINavigationController *)segue.destinationViewController;
        CreateExerciseSetTableViewController *dest = [[dc viewControllers] lastObject];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //aTimer *tmpTimer = [_exerciseSet objectAtIndex:indexPath.row];
        
        [dest setExerciseSet: [_exerciseSet objectAtIndex:indexPath.row]];
        
    }
    

}

- (IBAction)unwindToChooseExerciseSet:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

@end
