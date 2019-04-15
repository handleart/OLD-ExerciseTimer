//
//  CreateExerciseTableViewCell.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/21/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "CreateExerciseTableViewCell.h"

@implementation CreateExerciseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.button.layer.borderWidth = 1.0f;
    //self.button.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.button.layer.cornerRadius = 8.0f;
    //[self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Save button was pressed");
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_button
                          setBackgroundColor:[UIColor grayColor]];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_button
                          setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];
}
@end
