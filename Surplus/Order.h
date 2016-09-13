//
//  Order.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "Customer.h"

@interface Order : NSObject

@property (nonatomic) unsigned int customerId;
@property (nonatomic) unsigned int restaurantId;
@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *itemName;
@property (nonatomic) unsigned int quantity;
@property (nonatomic) unsigned int unitPrice;
@property (nonatomic) unsigned int amount;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSString *pickupTime;
@property (strong, nonatomic) NSString *randToken;

- (id)initWithRestaurant:(Restaurant *)restaurant
                quantity:(unsigned int)quantity;

- (id)initWithJson:(NSDictionary *)json;

- (NSDictionary *)json;

@end
