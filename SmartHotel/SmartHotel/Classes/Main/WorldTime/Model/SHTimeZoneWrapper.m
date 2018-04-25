//
//  SHTimeZoneWrapper.m
//  SmartHotel
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 SmartHome. All rights reserved.
//


#import "SHTimeZoneWrapper.h"

@implementation SHTimeZoneWrapper


- (id)initWithTimeZone:(NSTimeZone *)timeZone nameComponents:(NSArray *)nameComponents
{
    if (self = [super init])
    {
        _timeZone = timeZone;
        
        NSString *name = nil;
        
        if ([nameComponents count] == 2) {
           
            name = [nameComponents objectAtIndex:1];
        
        } else if ([nameComponents count] == 3) {
           
            name = [NSString stringWithFormat:@"%@ (%@)", [nameComponents objectAtIndex:2], [nameComponents objectAtIndex:1]];
        }
        
        _localeName = [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
    }
    return self;
}

// MARK: - getter && setter

- (NSString *)abbreviation {
    
    if (!_abbreviation) {
        
        _abbreviation = [_timeZone abbreviationForDate:_date];
    }
    
    return _abbreviation;
}

- (NSString *)gmtOffset {
    
    if (!_gmtOffset) {
        
        _gmtOffset = [_timeZone localizedName:NSTimeZoneNameStyleShortStandard locale:[NSLocale currentLocale]];
    }
    
    return _gmtOffset;
}


@end
