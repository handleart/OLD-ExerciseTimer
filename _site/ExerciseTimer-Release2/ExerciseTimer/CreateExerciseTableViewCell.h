//
//  CreateExerciseTableViewCell.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/21/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExerciseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;


- (IBAction)buttonPressed:(id)sender;

@end
