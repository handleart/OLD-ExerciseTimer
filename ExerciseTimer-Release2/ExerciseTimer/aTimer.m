//
//  aTimer.m
//  Exercise Timer
//
//  Created by Art Mostofi on 8/7/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import "aTimer.h"

@implementation aTimer

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sTimerName = [decoder decodeObjectForKey:@"timerName"];
    self.iNumReps = [decoder decodeIntegerForKey:@"iNumReps"];
    self.iRepLen1 = [decoder decodeIntegerForKey:@"iRepLen1"];
    self.iRepLen2 = [decoder decodeIntegerForKey:@"iRepLen2"];
    self.bDimScreen = [decoder decodeBoolForKey:@"DimScreen"];
    self.sRepSoundName = [decoder decodeObjectForKey:@"sRepSoundName"];
    self.sRepSoundExtension =[decoder decodeObjectForKey:@"sRepSoundExtension"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.sTimerName forKey:@"timerName"];
    [encoder encodeInteger:self.iNumReps forKey:@"iNumReps"];
    [encoder encodeInteger:self.iRepLen1 forKey:@"iRepLen1"];
    [encoder encodeInteger:self.iRepLen2 forKey:@"iRepLen2"];
    [encoder encodeBool:self.bDimScreen forKey:@"DimScreen"];
    [encoder encodeObject:self.sRepSoundName forKey:@"sRepSoundName"];
    [encoder encodeObject:self.sRepSoundExtension forKey:@"sRepSoundExtension"];

}

-(NSInteger)totalLength {
    return _iNumReps * (_iRepLen1 + _iRepLen2);
    
}

-(NSString *)timerName {
    return _sTimerName;
}


@end
