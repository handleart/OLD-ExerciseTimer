//
//  aTimer.h
//  Exercise Timer
//
//  Created by Art Mostofi on 8/7/15.
//  Copyright © 2015 Art Mostofi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aTimer : NSObject <NSCoding>

@property NSString *sTimerName;
@property NSInteger iNumReps;
@property NSInteger iRepLen1;
@property NSInteger iRepLen2;

@property NSString* sRepSoundName;
@property NSString* sRepSoundExtension;

-(NSInteger)totalLength;
-(NSString *)timerName;

-(NSArray *)getRepLengthsAsArray;

@end
