//
//  Order.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Order.h"

@implementation Order

-(id)initWithRestaurant:(Restaurant *)restaurant
               quantity:(unsigned int)quantity {
    
    self = [super init];
    
    if (self) {
        self.restaurantName = restaurant.name;
        self.leftoversItem = restaurant.leftoversItem;
        self.unitPrice = restaurant.price;
        self.quantity = quantity;
    }
    
    return self;
}

@end
