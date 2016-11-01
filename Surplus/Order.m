//
//  Order.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Order.h"
#import "Customer.h"
#import "Constants.h"

#import "NSUserDefaults+CustomObjectStorage.h"

@implementation Order

-(id)initWithRestaurant:(Restaurant *)restaurant
               quantity:(unsigned int)quantity {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    self.customerId = customer.id_;
    self.restaurantId = restaurant.id_;
    self.restaurantName = restaurant.name;
    self.itemName = restaurant.leftoversItem;
    self.quantity = quantity;
    self.unitPrice = restaurant.price;
    self.isCompleted = NO;
    
    return self;
}

- (id)initWithJson:(NSDictionary *)json {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.id_ = (int)[json[@"id"] intValue];
    self.restaurantId = (int)[json[@"restaurantID"] integerValue];
    self.customerId = (int)[json[@"customerId"] integerValue];
    self.itemName = json[@"itemName"];
    self.quantity = (int)[json[@"quantity"] integerValue];
    self.unitPrice = (int)[json[@"unitPrice"] integerValue];
    self.randToken = json[@"randToken"];
    self.isCompleted = [json[@"isCompleted"] boolValue];
    
    return self;
}

- (NSDictionary *)json {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d MMM yyyy HH mm ss z";
    
    NSDictionary *dict = @{@"customerID": [NSString stringWithFormat:@"%d", self.customerId],
                           @"restaurantID": [NSString stringWithFormat:@"%d", self.restaurantId],
                           @"itemName": self.itemName,
                           @"quantity": [NSString stringWithFormat:@"%d", self.quantity],
                           @"unitPrice": [NSString stringWithFormat:@"%d", self.unitPrice]};
    
    return dict;
}

- (unsigned int) amount {
    
    return self.quantity * self.unitPrice;
}

@end
