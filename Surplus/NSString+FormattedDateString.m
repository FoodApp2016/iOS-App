//
//  NSString+FormattedDateString.m
//  Surplus
//
//  Created by Dhruv Manchala on 10/31/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "NSString+FormattedDateString.h"

@implementation NSString (FormattedDateString)

- (NSString *)formattedDateString {
    
    NSDateFormatter *dateFormatter =  [NSDateFormatter new];
    dateFormatter.dateFormat = @"YYYY-MM-DD'T'HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    dateFormatter.dateFormat = @"hh:mm a";
    
    NSLog(@"%@", date);
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
    
    return [dateFormatter stringFromDate:date];
}

@end
