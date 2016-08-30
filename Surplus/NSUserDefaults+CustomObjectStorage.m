//
//  NSUserDefaults+CustomObjectStorage.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/29/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "NSUserDefaults+CustomObjectStorage.h"

@implementation NSUserDefaults (CustomObjectStorage)

- (void)saveCustomer:(Customer *)customer key:(NSString *)key {
    
    NSLog(@"%@", customer.stripeId);
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:customer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (Customer *)loadCustomerWithKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Customer *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


@end
