//
//  SetTimerViewController.m
//  ExerciseTimer
//
//  Created by Art Mostofi on 7/13/15.
//  Copyright (c) 2015 Art Mostofi. All rights reserved.
//

#import "SetTimerViewController.h"
#import "ViewTimerViewController.h"

@interface SetTimerViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRepLenTimer1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRepLenTimer2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerNumberOfReps;
@property NSArray *aNumberOfRepsData;
@property NSArray *aRepLenTimerData;
@property NSArray *aMin;
@property NSArray *aSec;
@property NSInteger iLenOfTimer1min;
@property NSInteger iLenOfTimer1sec;
@property NSInteger iLenOfTimer2min;
@property NSInteger iLenOfTimer2sec;

@property NSInteger *iNumOfReps;
@property NSInteger *iLenOfTimer1;
@property NSInteger *iLenOfTimer2;

@end

@implementation SetTimerViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //Assign # of Reps available to user
    
    
    //self.min = [NSArray ]
    
    int i;
    NSMutableArray *minTmp = [NSMutableArray array];
    NSMutableArray *secTmp = [NSMutableArray array];
    NSMutableArray *repTmp = [NSMutableArray array];
    
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
    
    
    self.aNumberOfRepsData = [repTmp copy];
    self.aRepLenTimerData = @[[_aMin copy], [_aSec copy]];
  
  
    self.pickerNumberOfReps.dataSource = self;
    self.pickerNumberOfReps.delegate = self;
    //self.pickerNumberOfReps.hidden = YES;

    
    self.pickerRepLenTimer1.dataSource = self;
    self.pickerRepLenTimer1.delegate = self;
    
    self.pickerRepLenTimer2.dataSource = self;
    self.pickerRepLenTimer2.delegate = self;
    

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"First Time Loading App? %d", _bNotFirstTime);
    
    if (_bNotFirstTime == nil || _bNotFirstTime == NO) {
        [self.pickerNumberOfReps selectRow:0 inComponent:0 animated:NO];
        [self.pickerRepLenTimer1 selectRow:1 inComponent:1 animated:NO];
        [self.pickerRepLenTimer2 selectRow:1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerNumberOfReps didSelectRow:0 inComponent:0];
        [self pickerView:self.pickerRepLenTimer1 didSelectRow:1 inComponent:1];
        [self pickerView:self.pickerRepLenTimer2 didSelectRow:1 inComponent:1];
    }
    
    _bNotFirstTime = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([pickerView isEqual: self.pickerNumberOfReps]) {
        return 1;
    }
    
    else if ([pickerView isEqual: self.pickerRepLenTimer1] || [pickerView isEqual: self.pickerRepLenTimer2]) {
        return 2;
    }
    else {
        return 0;
    }
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    if ([pickerView isEqual: self.pickerNumberOfReps]) {
        return _aNumberOfRepsData.count;
        //return [_numberOfReps objectAtIndex:row];
    }
    
    else if ([pickerView isEqual: self.pickerRepLenTimer1] || [pickerView isEqual: self.pickerRepLenTimer2]) {
        if (component == 0) {
            return _aMin.count;
        } else {
            return _aSec.count;
        }
        
        return 3;
    }
    else {
        return 1;
    }
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    if ([pickerView isEqual: self.pickerNumberOfReps]) {
        return _aNumberOfRepsData[row];
    }
    
    else if ([pickerView isEqual: self.pickerRepLenTimer1] || [pickerView isEqual: self.pickerRepLenTimer2]) {
       return _aRepLenTimerData[component][row];
    }
    
    else {
    
        return nil;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    NSString *tmp1;

    
    if ([pickerView isEqual: self.pickerNumberOfReps]) {
        tmp1 = [self.aNumberOfRepsData objectAtIndex:[self.pickerNumberOfReps selectedRowInComponent:component]];
        _iNumOfReps = [tmp1 intValue];
        
    }
    
    else if ([pickerView isEqual: self.pickerRepLenTimer1]) {
        if (component == 0) {
            tmp1 = self.aRepLenTimerData[component][row];
            _iLenOfTimer1min = [tmp1 integerValue];
        } else {
            tmp1 = self.aRepLenTimerData[component][row];
            _iLenOfTimer1sec = [tmp1 integerValue];
        }
        _iLenOfTimer1 = _iLenOfTimer1min * 60 + _iLenOfTimer1sec;
        
        
        
    }
    else if ([pickerView isEqual: self.pickerRepLenTimer2]) {
        if (component == 0) {
            tmp1 = self.aRepLenTimerData[component][row];
            _iLenOfTimer2min = [tmp1 integerValue];
        } else {
            tmp1 = self.aRepLenTimerData[component][row];
            _iLenOfTimer2sec = [tmp1 integerValue];
        }
        _iLenOfTimer2 = _iLenOfTimer1min * 60 + _iLenOfTimer1sec;
        
    }

    //Get the value for the numberOfReps picklist and hold for pass to next screen
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    //Get the value for the numberOfReps picklist and hold for pass to next screen
    
    if ([segue.identifier isEqualToString:@"ViewTimer"]) {
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        ViewTimerViewController *dest = [[nc viewControllers] lastObject];
        [dest setINumReps:_iNumOfReps];
        [dest setIRepLen1:_iLenOfTimer1];
        [dest setIRepLen2:_iLenOfTimer2];
        //ViewTimerViewController *dest = (ViewTimerViewController *)segue.destinationViewController;
        //dest.numReps = _numOfReps;
        //dest.repLen = _lenOfTimer1;
    
    }
}

#pragma mark PickerView Delegate


@end
