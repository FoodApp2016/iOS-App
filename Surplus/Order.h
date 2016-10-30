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

@property (nonatomic) unsigned int id_;
@property (nonatomic) unsigned int customerId;
@property (nonatomic) unsigned int restaurantId;
@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *itemName;
@property (nonatomic) unsigned int quantity;
@property (nonatomic) unsigned int unitPrice;
@property (nonatomic, readonly) unsigned int amount;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *randToken;
@property (nonatomic) BOOL isCompleted;

- (id)initWithRestaurant:(Restaurant *)restaurant
                quantity:(unsigned int)quantity;

- (id)initWithJson:(NSDictionary *)json;

- (NSDictionary *)json;

- (unsigned int) amount;

@end
