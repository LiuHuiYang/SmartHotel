//
//  SHTimeZoneWrapper.m
//  SmartHotel
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 SmartHome. All rights reserved.
//


#import "SHTimeZoneWrapper.h"

static NSString *today;
static NSString *tomorrow;
static NSString *yesterday;

@implementation SHTimeZoneWrapper

+ (void)initialize
{
    
    if (self == [SHTimeZoneWrapper class]) {
        today = NSLocalizedString(@"Today", "Today");
        tomorrow = NSLocalizedString(@"Tomorrow", "Tomorrow");
        yesterday = NSLocalizedString(@"Yesterday", "Yesterday");
        
    }
}


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
        
//        printLog(@"name = %@, %@", name, _localeName);
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    
    if ([date isEqualToDate:self.date]) {
        
        return;
    }
    
    self.date = date;
    self.abbreviation = nil;
    self.gmtOffset = nil;
}

// MARK: - getter && setter

- (NSString *)whichDay {
    
    if (!_whichDay) {
        
        NSDateComponents *dateComponents;
        NSInteger myDay, tzDay;
        
        // Set the calendar's time zone to the default time zone.
        [self.calendar setTimeZone:[NSTimeZone defaultTimeZone]];
        dateComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:self.date];
        myDay = [dateComponents weekday];
        
        [self.calendar setTimeZone:self.timeZone];
        dateComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:self.date];
        tzDay = [dateComponents weekday];
        
        NSRange dayRange = [self.calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
        NSInteger maxDay = NSMaxRange(dayRange) - 1;
        
        if (myDay == tzDay) {
            
            _whichDay = today;
        
        } else {
            if ((tzDay - myDay) > 0) {
            
                _whichDay = tomorrow;
            
            } else {
               
                _whichDay = yesterday;
            }
            
            if ((myDay == maxDay) && (tzDay == 1)) {
                self.whichDay = tomorrow;
            }
        
            if ((myDay == 1) && (tzDay == maxDay)) {
                self.whichDay = yesterday;
            }
        }
    }
    
    return _whichDay;
}

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
