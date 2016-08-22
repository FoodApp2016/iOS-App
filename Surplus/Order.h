//
//  Order.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface Order : NSObject

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *leftoversItem;
@property (nonatomic) unsigned int quantity;
@property (nonatomic) double unitPrice;

- (id)initWithRestaurant:(Restaurant *)restaurant quantity:(unsigned int)quantity;

@end
