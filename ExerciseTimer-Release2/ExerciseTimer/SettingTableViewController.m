//
//  SettingTableViewController.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/28/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//
//  Page loads user defaults such as disable dim screen, work in background, intro rep length (iRepLen0?) and allows the user to change it


#import "SettingTableViewController.h"

@interface SettingTableViewController ()
@property UISwitch *dimScreenSwitch;
@property UISwitch *backgroundSwitch;
@property UIStepper *stepper;
@property BOOL backgroundSwitchBool;
@property BOOL blockDimScreen;
@property NSInteger iIntroLength;
@property BOOL showStepper;
@property NSInteger tmpIntroLength;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(66/255.0) green:(94/255.0) blue:(157/255.0) alpha:1];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _backgroundSwitch = [[UISwitch alloc] init];
    _backgroundSwitch.on = [userDefaults boolForKey:@"backgroundSwitch"];
    
     _dimScreenSwitch = [[UISwitch alloc] init];
    _stepper = [[UIStepper alloc] init];
    _dimScreenSwitch.on = [userDefaults boolForKey:@"keepScreenOn"];
    
    _blockDimScreen = _dimScreenSwitch.on;
    
    _backgroundSwitchBool = _backgroundSwitch.on;
    
    _iIntroLength = [userDefaults integerForKey:@"introLength"];
    _stepper.minimumValue = -1 * _iIntroLength + 3;
    _tmpIntroLength = _iIntroLength;
    
    _showStepper = NO;
    
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_blockDimScreen forKey:@"keepScreenOn"];
    [userDefaults setBool:_backgroundSwitchBool forKey:@"backgroundSwitch"];
    [userDefaults setInteger:_tmpIntroLength forKey:@"introLength"];
    [userDefaults synchronize];
    
    [super viewWillDisappear:animated];
    
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
    return 3;
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
        
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Intro Length: ";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)(_tmpIntroLength / 60), (long)_tmpIntroLength % 60];
        
        
        [cell.contentView addSubview:_stepper];
        
        if (_showStepper == YES) {
            _stepper.hidden = NO;
            [_stepper addTarget:self action:@selector(stepperPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            _stepper.translatesAutoresizingMaskIntoConstraints = NO;
            
            
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_stepper attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            //[cell addConstraint:[NSLayoutConstraint constraintWithItem:_stepper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTop multiplier:1 constant:25]];
            //[cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
            [cell addConstraint:[NSLayoutConstraint constraintWithItem:_stepper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-20]];
        
        
        
        } else {
           // [_stepper removeFromSuperview];
            _stepper.hidden = YES;
        }
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Work in Background?";
        
        cell.detailTextLabel.hidden = YES;
        [[cell viewWithTag:3] removeFromSuperview];
        
        
        
        [_backgroundSwitch addTarget:self action:@selector(workInBackgroundSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _backgroundSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_backgroundSwitch];
        
        
        
        //add constraints
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
        //[cell addConstraint:[NSLayoutConstraint constraintWithItem:_dimScreenSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    } else {
        
    }

    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //CGFloat height = self.tableView.rowHeight;
    CGFloat height;
    
    if (_showStepper == YES && indexPath.row == 2) {
        height = 95;
        
    } else {
        height = 50;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row == 2) {
        if (_showStepper == YES) {
            _showStepper = NO;
        } else if (_showStepper == NO) {
            _showStepper = YES;
        }
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    

}


#pragma mark - Buttons

-(void)stepperPressed:(id)sender {
    if ([sender class] == [UIStepper class]) {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
        
        _tmpIntroLength = (NSInteger)_iIntroLength + (NSInteger)[(UIStepper*)sender value];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li", (long)(_tmpIntroLength
                                     / 60), (long)(_tmpIntroLength % 60)];
    }
}

-(void)dimScreenSwitchPressed:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    _blockDimScreen = aSwitch.on;
    
}

-(void)workInBackgroundSwitchPressed:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    _backgroundSwitchBool = aSwitch.on;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    

}


@end
