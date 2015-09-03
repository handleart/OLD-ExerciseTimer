//
//  SettingTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/28/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()
@property UISwitch *dimScreenSwitch;
@property UITextField *introLengthTextField;
@property BOOL blockDimScreen;
@property NSInteger iIntroLength;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     _dimScreenSwitch = [[UISwitch alloc] init];
    _introLengthTextField = [[UITextField alloc] init];
    //BOOL tmp = [userDefaults boolForKey:@"keepScreenOn"];;
    _dimScreenSwitch.on = [userDefaults boolForKey:@"keepScreenOn"];
    
    _blockDimScreen = _dimScreenSwitch.on;
    _iIntroLength = [userDefaults integerForKey:@"introLength"];
    //_introLengthTextField.text = [NSString stringWithFormat:@"%li", _iIntroLength];
    
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        
        //initialize items in row
    
        

        cell.textLabel.text = @"Keep Timer Screen On?";
        
        cell.detailTextLabel.hidden = YES;
        [[cell viewWithTag:3] removeFromSuperview];

        
        
        [_dimScreenSwitch addTarget:self action:@selector(dimScreenSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
    
        _dimScreenSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_dimScreenSwitch];
        
        
        
        //add constraints
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
        //[cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Intro Length: ";
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"00:%02li", _iIntroLength];
        
        cell.detailTextLabel.hidden = YES;
        //[[cell viewWithTag:3] removeFromSuperview];
        
        
        //_introLengthTextField = [[UITextField alloc] init];
        _introLengthTextField.delegate = self;
        
        _introLengthTextField.placeholder = [NSString stringWithFormat:@"00:%02li", _iIntroLength];
        _introLengthTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        [_introLengthTextField addTarget:self action:@selector(introLengthTextFieldEdited:) forControlEvents:UIControlEventAllEditingEvents];

        _introLengthTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_introLengthTextField];
        
        
        //add constraints
        
        
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_introLengthTextField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_introLengthTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_introLengthTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_introLengthTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        _introLengthTextField.textAlignment = NSTextAlignmentRight;
         
        
        
    } else if (indexPath.row == 2) {
        
    } else {
            
    }

    
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}
 */

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_blockDimScreen forKey:@"keepScreenOn"];
    [userDefaults setInteger:_iIntroLength forKey:@"introLength"];
    [userDefaults synchronize];
    
    [super viewWillDisappear:animated];
    
}

-(void)dimScreenSwitchPressed:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    _blockDimScreen = aSwitch.on;
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setBool:_blockDimScreen forKey:@"keepScreenOn"];
    //[userDefaults synchronize];
    
    
}

-(void)introLengthTextFieldEdited:(id)sender {
    
    
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.


    NSLog(@"Went through here");
    

}


@end
