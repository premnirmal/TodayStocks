//
//  Market.m
//  StocksWidget
//
//  Created by Prem Nirmal on 5/5/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "Market.h"

@implementation Market

static const NSInteger monday = 2;
static const NSInteger friday = 6;

+(BOOL) isOpen {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekDay = [components weekday];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    if(weekDay < monday || weekDay > friday) {
        return NO;
    } else if(hour >= 17 || hour < 9) {
        return NO;
    } else if(hour == 9) {
        return minute >= 30;
    } else if(hour == 16) {
        return minute <= 30;
    } else {
        return YES;
    }
}


@end
