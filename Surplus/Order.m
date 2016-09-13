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

@implementation Order

-(id)initWithRestaurant:(Restaurant *)restaurant
               quantity:(unsigned int)quantity {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    Customer *customer = [Customer new]; customer.id_ = 1;
    [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsCustomerKey];
    
    self.customerId = customer.id_;
    self.restaurantId = restaurant.id_;
    self.restaurantName = restaurant.name;
    self.itemName = restaurant.leftoversItem;
    self.quantity = quantity;
    self.unitPrice = restaurant.price;
    self.amount = quantity * self.unitPrice;
    self.pickupTime = @"2007-01-01 10:00:00";
    
    return self;
}

- (id)initWithJson:(NSDictionary *)json {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.restaurantId = (int)[json[@"restaurantId"] integerValue];
    self.customerId = (int)[json[@"customerId"] integerValue];
    self.itemName = json[@"itemName"];
    self.quantity = (int)[json[@"quantity"] integerValue];
    self.unitPrice = (int)[json[@"unitPrice"] integerValue];
    self.amount = (int)[json[@"amount"] integerValue];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.timestamp = [dateFormatter dateFromString:json[@"timestamp"]];
    
    self.pickupTime = json[@"pickupTime"];
    self.randToken = json[@"randToken"];
    
    return self;
}

- (NSDictionary *)json {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d MMM yyyy HH mm ss z";
    
    NSDictionary *dict = @{@"customerId": [NSString stringWithFormat:@"%d", self.customerId],
                           @"restaurantId": [NSString stringWithFormat:@"%d", self.restaurantId],
                           @"itemName": self.itemName,
                           @"quantity": [NSString stringWithFormat:@"%d", self.quantity],
                           @"unitPrice": [NSString stringWithFormat:@"%d", self.unitPrice],
                           @"amount": [NSString stringWithFormat:@"%d", self.amount],
                           @"pickupTime": self.pickupTime};
    
    return dict;
}

@end
