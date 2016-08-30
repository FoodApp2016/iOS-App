//
//  NSUserDefaults+CustomObjectStorage.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/29/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface NSUserDefaults (CustomObjectStorage)

- (void)saveCustomer:(Customer *)customer key:(NSString *)key;
- (Customer *)loadCustomerWithKey:(NSString *)key;

@end
