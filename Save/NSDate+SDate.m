//
//  NSDate+SDate.m
//  Save
//
//  Created by Abbin on 26/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "NSDate+SDate.h"

@implementation NSDate (SDate)

-(NSInteger)day{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return [components day];
}

-(NSInteger)month{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return [components month];
}

-(NSInteger)year{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return [components year];
}

-(NSString*)monthName{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM"];
    return [df stringFromDate:self];
}

-(NSString*)shortDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMM-YYYY"];
    return [df stringFromDate:self];
}

@end
