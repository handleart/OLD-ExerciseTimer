//
//  anExerciseSet.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface anExerciseSet : NSObject
@property NSString *sSetName;
@property NSMutableArray *aExercises;


-(NSInteger)totalLength;

@end
