//
//  anExerciseSet.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/17/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "anExerciseSet.h"
#import "aTimer.h"

@implementation anExerciseSet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aExercises = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sSetName = [decoder decodeObjectForKey:@"sSetName"];
    self.aExercises = [decoder decodeObjectForKey:@"aExercises"];
    self.iTotalLength = [decoder decodeIntegerForKey:@"iTotalLength"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.sSetName forKey:@"sSetName"];
    [encoder encodeObject:self.aExercises forKey:@"aExercises"];
    [encoder encodeInteger:self.iTotalLength forKey:@"iTotalLength"];
}

@end
